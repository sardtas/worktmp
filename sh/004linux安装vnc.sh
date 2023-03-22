#在目标机上装vncserver
apt install vnc4server

#xfce4桌面
sudo apt-get install xfce4 xfce4-goodies

#gnome 桌面 不行，连接不上
# apt install ubuntu-gnome-desktop
#sudo apt-get install --no-install-recommends ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

#用普通用户运行，并设置密码
vncserver
#配置远程桌面
cd 
vim .vnc/xstartup
##################################
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP" &
unset SESSION_MANAGER
unset DBUGS_SESSION_BUS_ADDRESS
startxfce4 &
##################################

# 将 x-window-manager 改成 gnome-session  
kde的桌面改成 startkde
或者 export STARTUP="/usr/bin/gnome-session --session=ubuntu" 　　$STARTUP


关闭vnc服务 
vncserver -kill :2
启动服务
vncserver -geometry 1800x940 :2




