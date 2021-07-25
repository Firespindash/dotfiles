#!/bin/bash
# don't execute this, execute commands separately 
dconf write /org/mate/marco/general/theme "'River'" # set theme 

marco-theme-viewer River # visualise theme for tests 

marco-compton --replace # commit changes to wm 