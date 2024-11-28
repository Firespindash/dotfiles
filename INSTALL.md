These are instructions on how to install this customization. \
It is also recommended that you have installed the apps that are expected to be there in the configs (mainly _compton_ and the ones from _eww_):
_thunar_, _xbindkeys_, _alacritty-ligatures_, _celluloid_, _gedit_, _falkon_, _timeshift_, _Karlender_ and _qview_. \
IMPORTANT: Remember to change things in the Control Center after the installation, and substitute mv for rsync -Prav
if you want to partially maintain already existing configurations like in the *.config* directory.
 
Global Menu: \
   To install topmenu on panel.

   ```
   pacman -S cmake appmenu-gtk-module 
   yay -S vala-panel-appmenu-mate 
   ```
   
   Then, there may be an error to be fixed.
   
   `cd ~/.cache/yay/vala-panel-appmenu/ `

   Edit in the **PKGBUILD** file setting the following: \
   _disable_xfce=false to true
   ```
: ${_build_mate:=true} 
: ${_build_xfce:=false} 
: ${_build_vala:=false} 
: ${_build_budgie:=false} 
   ```

   And done:
   
   ```
   makepkg -si 
   cd - 
   ```

River-theme: \
   To install River theme. Also install _gtk3-classic_ package
    for it to work properly.
   
   Create the local themes directory if it does not exist. (`mkdir ~/.themes/`)
   
   ```
   mv River-theme/Xresources ~/.Xresources 
   mv River-theme/ ~/.themes/River/ 
   mv ~/.themes/River/GTK/* ~/.themes/River/ 
   mv ~/.themes/River/gtk-4.0/gtk.css ~/.config/gtk-4.0/ 
   rm -rf ~/.themes/River/GTK/ 
   rm -rf ~/.themes/River/dev/ 
   rm -rf ~/.themes/River/Kvantum/dev/ 
   rm -rf ~/.themes/River/metacity-1/dev/ 
   rm -rf ~/.themes/River/extra-assets/dev/ 
   ```
   
   Icon theme: \
      First, download the 01-Tela-circle.tar.xz and the Tela-circle-nord.tar.xz in the Files tab on the link:
      https://www.gnome-look.org/p/1359276/ \
      And create if it does not exist. (`mkdir ~/.icons/ `)
      And install it doing in a similar manner:

    mv ~/Downloads/Tela-circle-nord.tar.xz ~/.icons/ 
    cd ~/.icons/ 
    tar -xf Tela-circle-nord.tar.xz 
    rm -rf Tela-circle-nord.tar.xz 
    sudo cp -r ~/.icons/Tela-circle-nord /usr/share/icons/ 
    cd - 

   Cursor theme: \
      I use _Deepin_ Dark cursor theme, please look at the [extra-deps/extra-pkgs.txt](https://github.com/Firespindash/dotfiles/blob/main/extra-deps/extra-pkgs.txt) file.

Configs: \
   Includes configurations about terminal, _rofi_, etc.

   ```
   rsync -Prav dotconfig/ ~/.config/ 
   rm -rf ~/.config/rofi/emoji-keyboard/dev/ 
   rm -rf ~/.config/mate/desktop-backup/ 
   ```

   Home-specific dot configs.

   ```
   mv dotbashrc ~/.bashrc 
   mv share/command-not-found.bash ~/.local/share/doc/ 
   mv dotprofile ~/.profile 
   mv dotxprofile ~/.xprofile 
   mv dotxbindkeysrc ~/.xbindkeysrc 
   mv bin ~/bin 
   chmod +x ~/bin/* 
   rm -rf ~/bin/dev 
   ```

Terminal: \
   To install the terminal configuration you can just the packaged terminal at:
   https://github.com/Firespindash/st \
   Or compile it with the instructions from the repo:
   Install the needed dependency if not already installed. (`pacman -S gd `)
   For more details on depencies see the my [st repo](https://github.com/Firespindash/st),
   but it should go like the following:

   ```
   git clone https://github.com/Firespindash/st.git 
   sudo make clean install 
   xrdb merge ~/.Xresources 
   ```

_Thunar_: \
   Now it has customized settings, to install them.

   `mv thumbnailers ~/.local/share/ `

Update Notification: \
   To install update notification script for the desktop.

   `sudo mv bin/update-notif.sh /usr/bin/ `

Logout-screen: \
   To install the logout widget.
   
   ```
   pacman -S python-pyqt5 
   mv logout-screen/share/ ~/.local/share/logout-screen/ 
   rm -rf logout-screen/ ~/.local/share/logout-screen/dev/ 
   ```
   
_Eww_: \
   To install dock bar of apps, _eww_ widgets.

   ```
   yay -S eww 
   mv ~/.config/eww/share/ ~/.local/share/eww/ 
   ```
   
   Sidebar Menu:

   If needed or not present yet, install _bc_. (`pacman -S bc `)
   Then:
   
   ```
   . ~/.config/eww/makebar.sh 
   rm -rf ~/.config/eww/sidemenu/dev 
   chmod +x ~/.config/eww/sidemenu/scripts/* 
   ```
   
   And (optionally):
   
   `pacman -S gnuplot `

Wallpaper: \
   Should work out-of-the-box. But, to set a nice wallpaper you can change it to where you want to. \
   After, set it in the _Mate Control Center_ or you can press Win+M/Alt+right click in the desktop and click in the option "Set wallpaper" in the _jgmenu_. Example:
   
   `mv wallpaper/leafs-improved.png ~/Images/wallpapers/ `

_Mate_: \
   To restore desktop customized settings.
   
   `dconf load /org/mate/ < dotconfig/mate/desktop-backup/mate-backup `

_Picom_: \
   To install the compositor for transparency and blur effect.
   I am using the picom-pijulius which is not a package at the time of this writing.
   So I have a method to install it without using C++ dependencies.
   Make sure you already have _base-devel_ installed. (`pacman -S base-devel`)
   You may also usually need to install if not already installed:

   `pacman -S libev uthash libpcre2 libdbus libconfig `

   ```
   git clone https://github.com/pijulius/picom.git 
   cd picom/ 
   ```

   Now the tools that are going to substitute default meson and ninja to more complaint versions without C++:

   `yay -S muon-meson samurai `

   After that, the installation continues with:

   ```
   muon setup -D buildtype=release build 
   ninja -C build 
   ```

   Then for some reason I do not know yet, the build gets done, but the installation might fail:

   ```
   sudo cp build/src/picom /usr/local/bin/ 
   sudo ln -s /usr/local/bin/picom /usr/local/bin/compton 
   sudo cp *.desktop /usr/share/applications/ 
   ```

Done, now you can even remove this directory.

`cd ../ && rm -rf dotfiles/ `
