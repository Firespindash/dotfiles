#!/bin/sh

since=7
to=1
all_enable=0
no_adjust=0
emit_graphics=0
keep=0
midnight_issue=0
fulltime_or_no_usage=0
days_uptime_incrementor=0
debug=0
size="800,600"
filename="-"

# options that would be nice to implement -s, for size, -fn for font, -ft for format
while getopts :f:t:ac:n:gkdh opt
do
	case $opt in
		f)
			since=$(echo "$OPTARG" | tr -dc '0-9')
			[ $since -eq 0 ] && { echo "Error: Invalid number in -f."; exit 1; }
			;;
		t)
			to=$(echo "$OPTARG" | tr -dc '0-9')
			;;
		a)
			all_enable=1
			;;
		c)
			file="$OPTARG"
			[ -z $file ] && { echo "Error: Please give a file."; exit 1; }
			[ -f $file ] && filename=$file || {
				echo "Error: $file file couldn't be found."; exit 1; }
			;;
		n)
			no_adjust=1
			;;
		g)
			emit_graphics=1
			;;
		k)
			keep=1
			;;
		d)
			debug=1
			;;
		h)
			echo "$(basename $0) is a script to list system usage times with the log from last command.

  Options:
    -f '-Ndays', 'N'    Set FROM how many days you want to go back and display
    -t '-Ndays', 'N'    Set TO how many days you want it to go and display
    -a                  Display FROM ALL the log
    -c 'FILE'           Use a different config file for gnuplot,
                         default filename to be plot is 'last.log'
    -n                  Do not adjust the FROM/TO days to the default offset (FROM - 1)
    -g                  Generate graphics, plot data
    -k                  Keep FILE after generating a graph, only makes sense with -g
    -d                  Turn debug mode on
    -h                  Show help and exit

All options are optional and the single quote (') isn't needed.
The defaults are 7 days from yesterday,'-f -7days -t -1day'.
The maximum recommended is 30 days back, '-f -30days'.
Use -t 0 to see data about today!"
			exit
			;;
		*)
			echo "Error: Invalid flag, you can run with flag -h for help."
			exit 1
			;;
	esac
done

convertTimeToSeconds() {
	hours_to_convert=$(echo "$1" | cut -d ':' -f 1)
	minutes_to_convert=$(echo "$1" | cut -d ':' -f 2)
	hours_in_seconds=$(expr "$hours_to_convert" '*' 3600)
	minutes_in_seconds=$(expr "$minutes_to_convert" '*' 60)
	time_in_seconds=$(expr $hours_in_seconds + $minutes_in_seconds)
	
	printf "%d" "$time_in_seconds"
}

appendTrailingZero() {
	uptime -p | cut -d ' ' -f 2 | xargs printf '%02d'
}

timenow() {
	parameter="$1"
	
	[ $(uptime -p | grep -Ec 'h') -eq 0 ] &&
	 hour_and_minute="00:$(appendTrailingZero)" || {
	 hour_and_minute="$(appendTrailingZero):$(uptime | cut -d ':' -f 4 |
	  cut -d ' ' -f 1 | cut -d ',' -f 1)"; }
	 
	{ [ "$parameter" = "-s" ] && convertTimeToSeconds "$hour_and_minute"; } ||
	 echo "$hour_and_minute"
}

convertToTime() {
	seconds="$1"
	# This mess works because expr does not return floating numbers
	converted_hours=$(expr $seconds / 3600)
	total_in_minutes=$(expr $seconds / 60)
	converted_hours_in_minutes=$(expr $converted_hours '*' 60)
	converted_minutes=$(expr $total_in_minutes - $converted_hours_in_minutes)
	
	printf "%02d:%02d" "$converted_hours" "$converted_minutes"
}

queryDay() {
	starting_day="$1"
	day_after="$2"
	cropline="$3"

	printf "%s" "$(last $USER -R -s $starting_day -t $day_after --time-format iso |
	 head -n -2 | tail -n +$cropline | cut -d ' ' -f 3-)"

	# Case simulation for debugging below, uncomment to test

	# Indetermination case with today
	# printf "%s" "$(echo '
	# user    tty7         2023-10-27T21:45:32-03:00   still logged in' |
	# tail -n +$cropline | cut -d ' ' -f 3-)"
	
	# Multiple today entries with crashes
	# printf "%s" "$(echo '
	# user    tty7         2023-10-27T21:45:32-03:00   still logged in
	# user    tty7         2023-10-27T17:45:28-03:00 - 2023-10-27T17:56:55-03:00  (00:11)
	# user    tty7         2023-10-27T17:37:58-03:00 - crash                      (00:06)
	# user    tty7         2023-10-27T17:21:10-03:00 - crash                      (00:15)' |
	# tail -n +$cropline | cut -d ' ' -f 3-)"
}

fixStillLoggedIn() {
	query_date="$1"
	day_counter="$2"
	date_count_to_crop="$3"

	date_count_to_crop=$(expr $date_count_to_crop + 1)
	day_after_period=$(date --date="$(expr $day_counter - 2) days ago" -I)
	
    printf "%s" "$(queryDay $query_date $day_after_period $date_count_to_crop)"
}

countDateAppearances() {
	query_date="$1"
	date_to_count="$2"

	echo "$query_date" | sed 's/) /\n/g' | cut -d 'T' -f 1 | grep -c "$date_to_count"
}

getDateHourSum() {
	query="$1"
	lines_to_cut="$2"

	echo "$query" | sed 's/) /\n/g' | tail -n +$lines_to_cut | cut -d '(' -f 2 |
	 cut -d ':' -f 1 | paste -sd+ - | bc
}

getDateMinuteSum() {
	query="$1"
	lines_to_cut="$2"

	echo "$query" | sed 's/) /\n/g' | tail -n +$lines_to_cut | cut -d '(' -f 2 |
	 cut -d ')' -f 1 | cut -d ':' -f 2 | paste -sd+ - | bc
}

doTimeMath() {
	hours_to_math="$1"
	minutes_to_math="$2"
	
	extra_hour=$(expr "$minutes_to_math" / 60)
	minutes=$(expr "$minutes_to_math" % 60)
	hours=$(expr "$hours_to_math" + "$extra_hour")
	
	printf "%02d:%02d" $hours $minutes
}

getDateUptime() {
	query_period="$1"
	cropline="$2"

    echo "$query_period" | sed 's/) /\n/g' | tail -n +$cropline | cut -d 'T' -f 3 |
     cut -d '(' -f 2 | cut -d ')' -f 1
}

getIssuedDateUptime() {
	multiple_date_query="$1"
	lines_to_cut="$2"

	hour_sum=$(getDateHourSum "$multiple_date_query" "$lines_to_cut")
	minute_sum=$(getDateMinuteSum "$multiple_date_query" "$lines_to_cut")

	doTimeMath "$hour_sum" "$minute_sum"
}

writeData() {
	day_to_write="$1"
	time_to_write="$2"
	
	echo "$day_to_write $time_to_write" >> last.log
}

checkIfIssueDate() {
	query="$1"

	echo "$query" | sed 's/) /\n/g' | cut -d 'T' -f 2 | grep -c "[still|logout]"
}

checkForCrash() {
	query="$1"

	echo "$query" | grep -c "crash"
}

timeToFloatNumber() {
	time_string="$1"

	hours_to_convert=$(echo "$time_string" | cut -d ':' -f 1)
	minutes_to_math=$(echo "$time_string" | cut -d ':' -f 2)
	hours_in_minutes=$(echo "$hours_to_convert * 60" | bc)

	total_minutes=$(echo "$hours_in_minutes + $minutes_to_math" | bc)

	echo "scale=9; $total_minutes / 60" | bc
}

# Static variable analysis
testingDebug() {
	echo "since: $since
to: $to
all_enable: $all_enable
no_adjust: $no_adjust
emit_graphics: $emit_graphics
keep: $keep
midnight_issue: $midnight_issue
fulltime_or_no_usage: $fulltime_or_no_usage
days_uptime_incrementor: $days_uptime_incrementor
debug: $debug
size: $size
filename: $filename
opt: $opt
OPTARG: $OPTARG
file: $file
count: $count
last_day: $last_day
log_start_date: $log_start_date
logtime: $logtime
first_day: $first_day
today: $today
yesterday: $yesterday
today_period_query: $today_period_query
listday: $listday
day_ahead: $day_ahead
date_query: $date_query
other_date_count: $other_date_count
date_count: $date_count
test_query: $test_query
search_query: $search_query
day_after_count: $day_after_count
total: $total
hours_to_convert: $hours_to_convert
minutes_to_math: $minutes_to_math
hours_in_minutes: $hours_in_minutes
total_minutes: $total_minutes
day_uptime: $day_uptime
timestamp: $timestamp
timestamp_from_login: $timestamp_from_login
timestamp_from_midnight: $timestamp_from_midnight
time_between_then_and_login: $time_between_then_and_login
time_between_then_and_midnight: $time_between_then_and_midnight
time_between_login_and_midnight: $time_between_login_and_midnight
today_count: $today_count
yesterday_uptime: $yesterday_uptime
time_in_seconds_sum: $time_in_seconds_sum
total_time_sum: $total_time_sum
today_uptime: $today_uptime
partial_uptime: $partial_uptime
uptime_now: $uptime_now
today_sum: $today_sum
Empty variables do not represent problems.
No variable should have a negative value, except for $days_uptime_incrementor."
}

# Grab last line, between timestamp
log_start_date=$(last $USER -R --time-format iso | sed 's/) /\n/g' | tail -n 1 |
 cut -d 'T' -f 1 | cut -d ' ' -f 3)

# Test if there is not enough data for the request
logtime=$(echo "($(date +%s) - $(date -d $log_start_date +%s)) / (3600*24)" | bc)

[ $logtime -lt $since ] && { echo "From is older than last's log."; exit 1; }

{ [ $no_adjust -eq 0 ] && [ $to -eq 0 ]; } && since=$(expr $since - 1) || last_day=$to

# Check if the all option is enabled, which date is the starting date
[ $all_enable -eq 1 ] && first_day=$logtime || first_day=$since

# Check for indetermination
[ $(uptime -p | grep -c 'day') -gt 0 ] && {
 days_uptime_incrementor=$(uptime -p | cut -d ' ' -f 2); fulltime_or_no_usage=1; }

# See comment below the for loop
[ $to -eq 0 ] && {
 today=$(date -I); yesterday=$(date --date='1 day ago' -I);

 [ $no_adjust -eq 1 ] && first_day=$(expr $first_day + 1);

 last_day=2;
 today_period_query=$(fixStillLoggedIn "$yesterday" 1 0);

 { [ $fulltime_or_no_usage -eq 0 ] &&
  [ $(echo "$today_period_query" | sed 's/) /\n/g' | cut -d 'T' -f 1 |
   grep -c $today) -eq 0 ]; } && midnight_issue=1; }

> last.log

for i in $(seq $first_day -1 $last_day)
do
	listday=$(date --date="$i days ago" -I)
	day_ahead=$(date --date="$(expr $i - 1) days ago" -I)
	date_query=$(queryDay "$listday" "$day_ahead" 1)

	# Fix "gone - no logout/still logged in" issue
	other_date_count=0

	[ $(checkIfIssueDate "$date_query") -gt 0 ] && {
	 date_query=$(fixStillLoggedIn "$listday" $i $other_date_count);
	 other_date_count=$(countDateAppearances "$date_query" "$day_ahead");
	 date_count=$(countDateAppearances "$date_query" "$listday");
	 date_query=$(fixStillLoggedIn "$listday" $i $other_date_count); } ||
	 date_count=$(countDateAppearances "$date_query" "$listday")

	# Identify a double + entry, requires duplicates issue
	{ [ $date_count -gt 1 ] && [ $other_date_count -eq 0 ]; } && {
	 test_query=$(fixStillLoggedIn "$listday" $(expr $i - 1) 1);

	 [ $(echo "$test_query" | grep -c '+') -gt 0 ] && {
	  search_query=$(last reboot -R -s "$listday" --time-format iso);
	  days_uptime_incrementor=$(echo "$search_query" | sed 's/) /\n/g' |
	   grep "$listday" | grep -o '.*+' | cut -d '(' -f 2 | cut -d '+' -f 1 |
	   tr '\n' ' ' | cut -d ' ' -f 1); };

	 { [ $days_uptime_incrementor -gt 1 ] &&
	  [ $(countDateAppearances "$search_query" "$listday") -gt 1 ]; } && {
 	   date_query=$(echo "$test_query" | grep "$listday" | sed 's/(.*+/(/'); }; }

	# Fix for the "crash" issue
	[ $(checkForCrash "$date_query") -gt 0 ] &&
	 date_query=$(echo "$date_query" | sed 's/crash/T/g')

	# Fix indetermination issue (main part)
	[ $date_count -eq 0 ] && {
	 [ $fulltime_or_no_usage -eq 0 ] && day_uptime="00:00" || {
	  day_uptime="24:00";
	  days_uptime_incrementor=$(expr $days_uptime_incrementor - 1);
	  
	  [ $days_uptime_incrementor -eq 0 ] && fulltime_or_no_usage=0; }; } || {
	 # detect duplicates part goes here
	 [ $date_count -gt 1 ] && {
	  date_query=$(getIssuedDateUptime "$date_query" 1);
	  day_after_count=$(countDateAppearances "$date_query" "$day_ahead");
	  day_after_count=$(expr $day_after_count + 1);
	  total=$(getIssuedDateUptime "$date_query" $day_after_count);

	  # Correct possible issue
	  [ $(echo $total | cut -d ':' -f 1) -gt 24 ] &&
	   day_uptime="24:00" || day_uptime="$total"; } || {
     day_uptime=$(getDateUptime "$date_query" 1);

	 # detect if time starts with +
	 [ -z $day_uptime ] && {
	  incrementor=$i;
	  
	  while [ -z "$day_uptime" ] && [ $incrementor -gt $last_day ]; do
	  	date_query=$(fixStillLoggedIn "$listday" $incrementor 1)
	    day_after_period=$(date -d "$(expr $incrementor - 1) days ago" -I)
		day_after_count=$(countDateAppearances "$date_query" "$day_after_period")
	 	day_after_count=$(expr $day_after_count + 2)
	 				
	    [ $(checkForCrash "$date_query") -gt 0 ] &&
	     date_query=$(echo "$date_query" | sed 's/crash/T/g')
	    			
		day_uptime=$(getDateUptime "$date_query" $day_after_count)
	    incrementor=$(expr $incrementor - 1)
	    done; };
	    	
     [ $(echo "$day_uptime" | grep -c '+') -gt 0 ] && {
   	  days_uptime_incrementor=$(echo "$day_uptime" | grep -o '.*+' |
	   cut -d '(' -f 2 | cut -d '+' -f 1);
	  fulltime_or_no_usage=1;
	  day_uptime="$(echo "$day_uptime" | sed 's/.*+//')"; }; }; }
	
    writeData "$listday" "$day_uptime"
done

# Solves issue when using this at midnight with the today option at the same time
# It involves solving the duplicate date plus the "still logged in" issue
[ $to -eq 0 ] && {
 date_query=$(fixStillLoggedIn "$yesterday" 1 1);
 date_count=$(countDateAppearances "$date_query" "$yesterday");
 today_count=$(countDateAppearances "$date_query" "$today");
 
 # Code below is questionable if needed
 [ $date_count -eq 0 ] && { before_yesterday=$(date -d "2 days ago" -I);
  date_query=$(fixStillLoggedIn "$before_yesterday" 1 $(expr $today_count + 1));
  other_date_count=$(countDateAppearances "$date_query" "$before_yesterday");
  date_count=$(countDateAppearances "$date_query" "$yesterday"); } ||
  other_date_count=0;

 { [ $date_count -gt 0 ] && [ $today_count -gt 0 ]; } &&
  date_query=$(fixStillLoggedIn "$yesterday" 1 $(expr $today_count + 1));

 # For yesterday
 [ $date_count -gt 1 ] && 
  yesterday_uptime=$(getIssuedDateUptime "$date_query" "$today_count") ||
  [ $date_count -eq 1 ] &&
   yesterday_uptime=$(getDateUptime "$date_query" "$today_count");

 [ $midnight_issue -eq 1 ] && {
  # Really high precision is not needed here (only if it was a more critical
  # system)
  # Still though, the solution for the problem uses math that involves pretty
  # much time triangulation
  timestamp=$(date +%s);
  timestamp_from_login=$(date -d "$(uptime -s)" +%s);
  timestamp_from_midnight=$(date -d "$today 00:00:00" +%s);
  time_between_then_and_login=$(expr $timestamp - $timestamp_from_login);
  time_between_then_and_midnight=$(expr $timestamp - $timestamp_from_midnight);
  time_between_login_and_midnight=$(expr $time_between_then_and_login - \
   $time_between_then_and_midnight);

  # For yesterday
  [ $date_count -gt 1 ] && {
   time_in_seconds_sum=$(convertTimeToSeconds "$yesterday_uptime");
   total_time_sum=$(expr $time_in_seconds_sum + \
    $time_between_login_and_midnight);
   yesterday_uptime=$(convertToTime $total_time_sum); } ||
   yesterday_uptime=$(convertToTime $time_between_login_and_midnight);
	
  # For today
  today_uptime=$(date +"%R"); } || {
  # For yesterday
  [ -z $yesterday_uptime ] && { [ $fulltime_or_no_usage -eq 0 ] &&
   yesterday_uptime="00:00" || yesterday_uptime="24:00"; };
		
  # For today
  [ $fulltime_or_no_usage -eq 0 ] && today_uptime=$(timenow) ||
   today_uptime=$(date +"%R"); };

 # For today
 [ $today_count -gt 0 ] && {
  [ $(countDateAppearances "$date_query" "$before_yesterday") -gt 0 ] &&
   date_query=$(echo "$date_query" | head -n -$other_date_count);

  date_query=$(fixStillLoggedIn "$yesterday" 1 1);
  date_query=$(echo "$date_query" | head -n -$date_count);
  partial_uptime=$(convertTimeToSeconds $(getIssuedDateUptime "$date_query" 1));
  uptime_now=$(timenow "-s");
  today_sum=$(expr $partial_uptime + $uptime_now);
  today_uptime=$(convertToTime $today_sum); };
 
  writeData "$yesterday" "$yesterday_uptime";
  writeData "$today" "$today_uptime"; }

[ $debug -eq 1 ] && testingDebug

[ $emit_graphics -eq 1 ] && {
 hour_jump=2;
 count=$(expr $since - $to);
 size="800,600";
 
 while read line; do
 	line_timestamp=$(echo "$line" | cut -d ' ' -f 1)
 	line_time=$(echo "$line" | cut -d ' ' -f 2)
 	line_float_number_time=$(timeToFloatNumber "$line_time")
 	echo "$line_timestamp $line_float_number_time $line_time" >> float.log
 done < last.log;

 \mv float.log last.log;
	
 # Set graphics size based on how many days to display
 [ $count -gt 7 ] && size="1920,1080";
 [ $count -gt 29 ] || [ $all_enable -eq 1 ] && size="2560,1440";
 [ $count -le 1 ] && { echo "To is older than From."; exit 1; };
	
 # Finally, process the plotting
 { [ ! "$filename" = "-" ] && gnuplot "$filename"; } ||
  gnuplot << EOF
  set terminal pngcairo transparent size ${size} font "Comfortaa,16" 
  set output 'last.png'
  unset border

  set style data histogram
  set style histogram cluster gap 2
  set style fill solid noborder
  set boxwidth 0.9
  set grid ytics
  set xlabel "Days"
  set xtics nomirror font "Comfortaa,14" rotate by -90
  set tics scale 0.0

  set yrange [0.000000000:24.000000000]
  set xdata time
  set ytics 0.016666667 # 1/60
  set timefmt "%Y-%m-%d"
  set format x "%Y-%m-%d"
  set ylabel "Hours"
  unset ytics

  set title "Time usage per day on Linux"
  plot "last.log" using (column(0) * 1.5) : 2 : xtic(1) with boxes lc rgb "#720b98" \
   notitle, "last.log" using (column(0)*1.5):(column(2)+1):(column(3)) with labels notitle
EOF

 [ $keep -eq 0 ] && rm last.log; }
