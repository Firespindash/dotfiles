#!/bin/sh

# WARNING: This, like many detection algorithms, is just a "wild guesser",
# many apps won't show up because of internal Eww issues
matchPackageAndGrab() {
	app_type="$1"
	keywords_to_match="$@"

	list=$(ls /usr/share/applications/*"${app_type}"*.desktop 2>/dev/null)
	[ -n "$list" ] && list_length=$(echo "$list" | grep -c ".desktop$") || list_length=0
	package_name=""
	
	keyword_regex=$(echo "$keywords_to_match" | tr ' ' '|')

	fields=1
	while [ $fields -le $list_length ] && [ -z "$package_name" ]
	do
		file=$(echo "$list" | awk 'NR=='$fields)
		package_name=$(man -f $(basename "${file%.desktop}") 2>/dev/null |
		 grep -E "$keyword_regex" | cut -d ',' -f 1 | cut -d '(' -f 1 | awk 'NR==1')
		fields=$(echo "$fields + 1" | bc)
	done

	# flatpak support part
	[ -z "$package_name" ] && [ -d /var/lib/flatpak ] && {
		package_name=$(flatpak list --system --app --columns=application,description |
		 grep -E "$keyword_regex" | awk '{print $1}');
		[ -n "$package_name" ] && package_name="flatpak run $package_name"; }
	
	echo "$package_name"
}

multipleByRatio() {
	value_to_math="$1"
	ratio_to_apply="$2"

	echo "$value_to_math $ratio_to_apply" | awk '{printf "%.f", $1 * $2}'
}

dirname_to_operate="dotconfig/eww/sidemenu"
scripts_directory="dotconfig/eww/sidemenu/scripts"

mv -v $dirname_to_operate/eww.yuck $dirname_to_operate/eww.yuck.bak

# checks for commands
# INFO: You can change here if you are having trouble in the programs being recognized
colorpicker=$(matchPackageAndGrab "color" "picker" "screen")
volume_control=$(matchPackageAndGrab "volume" "control")
calendar=$(matchPackageAndGrab "calendar" "schedule" "management")

# IMPORTANT: This part will be considered a polyfill if Eww supports % in widgets
# or if GTK CSS support for REM (with root font size) properly gets to Eww 

# unit calculations
query_monitor=$(xrandr | grep -Eo "current .*," | awk 'NR==1')
monitor_width=$(echo "$query_monitor" | cut -d ' ' -f 2)

[ ! "$monitor_width" = "1600" ] && {
 mv -v $dirname_to_operate/eww.scss $dirname_to_operate/eww.scss.bak;

 monitor_height=$(echo "$query_monitor" | cut -d ' ' -f 4 | cut -d ',' -f 1);
 window_height=$(echo "$monitor_height - 24" | bc);
 ratio=$(echo "${monitor_width} 1600" | awk '{printf "%.4f", $1 / $2}');
 blocks_roundness=$(multipleByRatio 10 "$ratio");
 blocks_width=$(multipleByRatio 267 "$ratio");
 blocks_height=$(multipleByRatio 197 "$ratio");
 first_row_top_margin=$(multipleByRatio 9 "$ratio");
 air_quality_widget_padding=$(multipleByRatio 56 "$ratio");
 monospaced_font_size=$(multipleByRatio 19 "$ratio");
 maximum_font_size=$(multipleByRatio 72 "$ratio");
 icon_size=$(multipleByRatio 25 "$ratio");
 label_size=$(multipleByRatio 22 "$ratio");
 big_font_size=$(multipleByRatio 17 "$ratio");
 font_size=$(multipleByRatio 16 "$ratio");
 minimum_font_size=$(multipleByRatio 8 "$ratio");
 smaller_font_size=$(multipleByRatio 6 "$ratio");
 # eww.yuck extra units
 smaller_row_width=$(multipleByRatio 90 "$ratio");
 smaller_row_height=$(multipleByRatio 130 "$ratio");
 small_button_height=$(multipleByRatio 60 "$ratio");
 medium_label_width=$(multipleByRatio 167 "$ratio");
 medium_button_height=$(multipleByRatio 57 "$ratio");
 small_button_image_margin=$(multipleByRatio 17 "$ratio");
 medium_button_width=$(multipleByRatio 128 "$ratio");
 medium_button_image_margin=$(multipleByRatio 36 "$ratio");
 big_label_height=$(multipleByRatio 127 "$ratio");
 row_width=$(multipleByRatio 576 "$ratio");
 row_height=$(multipleByRatio 217 "$ratio");
 air_quality_widget_spacing=$(multipleByRatio 50 "$ratio");
 last_row_width=$(multipleByRatio 540 "$ratio");
 image_height=$(multipleByRatio 200 "$ratio");

 # substitution of units
 sed "s/$blocks_roundness/10/
	  s/$blocks_width/267/
	  s/$blocks_height/197/
	  s/$smaller_row_width/90/
	  s/$smaller_row_height/130/
	  s/$small_button_height/60/
	  s/$medium_label_width/167/
	  s/$medium_button_height/57/
	  s/$small_button_image_margin/17/
	  s/$medium_button_width/128/
	  s/$medium_button_image_margin/36/
	  s/$big_label_height/127/
	  s/$row_width/576/
	  s/$row_height/217/
	  s/$air_quality_widget_spacing/50/
	  s/$last_row_width/540/
	  s/$image_height/200/
	  s/$window_height/876/" $dirname_to_operate/eww.yuck.bak > /tmp/eww.yuck;

 sed "s/$blocks_roundness/10/
	  s/$blocks_width/267/
	  s/$blocks_height/197/
	  s/$first_row_top_margin/9/
	  s/$air_quality_widget_padding/56/
	  s/$monospaced_font_size/19/
	  s/$maximum_font_size/72/
	  s/$icon_size/25/
	  s/$label_size/22/
	  s/$big_font_size/17/
	  s/$font_size/16/
	  s/$minimum_font_size/8/
	  s/$smaller_font_size/6/" \
  $dirname_to_operate/eww.scss.bak > $dirname_to_operate/eww.scss; }

# substitution of commands/deletion part
# TODO: For the future, add a parser for yuck with the help of the
# literal widget inside eww.yuck

[ -n "$colorpicker" ] && {
 mv -v $scripts_directory/c9r-wrap $scripts_directory/c9r-wrap.bak;
 sed "s/mate-color-select/$colorpicker/" \
  $scripts_directory/c9r-wrap.bak > $scripts_directory/c9r-wrap; }

[ -n "$volume_control" ] && {
 sed "s/mate-volume-control/$volume_control/" \
  /tmp/eww.yuck > /tmp/eww2.yuck; }

[ -n "$calendar" ] && {
 sed "s/codes.loers.Karlender/$calendar/" \
 /tmp/eww2.yuck > $dirname_to_operate/eww.yuck; }

rm /tmp/*.yuck

. $scripts_directory/w5r-wrap -f
