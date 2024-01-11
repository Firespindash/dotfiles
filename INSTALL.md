These are instructions on how to install this customization. \
It is also recommended that you have installed the apps that are expected to be there in the configs (mainly _compton-tryone_ and the ones from _eww_):
_thunar_, _xbindkeys_, _alacritty-ligatures_, _celluloid_, _gedit_, _falkon_, _timeshift_, _Karlender_ and _qview_.
 
Global Menu: \
   To install topmenu on panel.

   ```
   pacman -S appmenu-gtk-module 
   yay -S vala-panel-appmenu-registrar-git 
   pacman -S cmake 
   yay -S vala-panel-appmenu 
   ```
   
   Then, there may be an error to be fixed.
   
   `cd ~/.cache/yay/vala-panel-appmenu/ `

   Edit in the **PKGBUILD** file setting the following: \
   _disable_xfce=false to true
   ```
   _disable_xfce=true
   _disable_vala=true
   _disable_budgie=true
   ```

   And done:
   
   ```
   makepkg -si 
   cd ~/dotfiles/ 
   ```

River-theme: \
   To install River theme. Also install _gtk3-classic_ package
    for it to work properly.
   
   Create the local themes directory if it does not exist. (`mkdir ~/.themes/`)
   
   ```
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
      First, download the Tela-circle-black.tar.xz in Files(13) on the link:
      https://www.gnome-look.org/p/1359276/ \
      And create if it does not exist. (`mkdir ~/.icons/ `)

      mv ~/Downloads/Tela-circle-black.tar.xz ~/.icons/ 
      cd ~/.icons/ 
      tar -xf Tela-circle-black.tar.xz 
      rm -rf Tela-circle-black.tar.xz 
      sudo cp -r ~/.icons/Tela-circle-black /usr/share/icons/ 
      cd ~/dotfiles 

   Cursor theme: \
      I use _Deepin_ Dark cursor theme, please look at the [extra-deps/extra-pkgs.txt](https://github.com/Firespindash/dotfiles/blob/main/extra-deps/extra-pkgs.txt) file.

Configs: \
   Includes configurations about terminal, _rofi_, etc.

   ```
   mv dotconfig/ ~/.config/ 
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
   rm -rf ~/bin/dev 
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
   pacman -S python-pip 
   pip install pyqt5 
   cp -r logout-screen/ ~/.config/ 
   mv ~/.config/logout-screen/share/ ~/.local/share/logout-screen/ 
   rm -rf ~/.local/share/logout-screen/dev/ 
   ```
   
_Eww_: \
   To install dock bar of apps, _eww_ widgets.
   For it, you will need the _rust nightly_ toolchain.
   
   `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh `
   
   And just proceed and reload _bash_, then:

   ```
   source $HOME/.cargo/env
   rustup default nightly
   ```

   You can get rid of _rustup_ after.

   ```
   cd ../ 
   git clone https://github.com/elkowar/eww 
   cd eww/ 
   cargo build --release 
   chmod +x target/release/eww 
   mv target/release/eww ~/bin/eww
   ```
   
   And test the program to see if it is working.
   
   ```
   cd ~/dotfiles/ 
   cp -r dotconfig/eww/ ~/.config/ 
   mv ~/.config/eww/share/ ~/.local/share/eww/ 
   ```
   
   Sidebar Menu:
   
   ```
   . ~/.config/eww/makebar.sh
   rm -rf ~/.config/eww/sidemenu/dev 
   ```
   
   And (optionally):
   
   `pacman -S gnuplot`

Wallpaper: \
   Should work out-of-the-box. But, to set a nice wallpaper you can change it to where you want to. \
   After, set it in the _Mate Control Center_ or you can press Win+M/Alt+right click in the desktop and click in the option "Set wallpaper" in the _jgmenu_. Example:
   
   `mv wallpaper/leafs-improved.png ~/Images/wallpapers/ `

_Mate_: \
   To restore desktop customized settings.
   
   `dconf load /org/mate/ < dotconfig/mate/desktop-backup/mate-backup `

Done, now you can even remove this directory.

`cd ../ && rm -rf dotfiles/ `
