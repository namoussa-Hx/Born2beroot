#!/bin/bash
#The architecture of the operating system and its kernel version.
system_info=$(uname -a)
#The number of physical processors.
pp=$(grep "physical id" /proc/cpuinfo | wc -l)
#The number of virtual processors.
vp=$(grep "^processor" /proc/cpuinfo | wc -l)
#The current available RAM on your server and its utilization rate as a percentage.
av_ram=$(free -m | grep Mem |awk '{print $7}')
us_ram=$(free -m | grep Mem |awk '{print $3}')
total_ram=$(free -m | grep Mem |awk '{print $2}')
us_per=$(free -m | grep Mem |awk '{printf("%.2f%%"), $3/$2*100}')
#The current available memory on your server and its utilization rate as a percentage.
full_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
used_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
disk_u_per=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
#The current utilization rate of the processors as a percentage.
cu=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
#The date and time of the last reboot.
d_reboot=$(who -b | awk '{print($3 " " $4)}')
#Whether LVM is active or not
lvm_a_na=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
#The number of active connections.
active_conn=$(netstat -tun | grep -c 'ESTABLISHED')
#The number of users using the server
user_serv=$(who | wc -l)
#The IPv4 address of your server and its MAC (Media Access Control) address
ip=$(hostname -I)
mac=$(ip link show | grep "link/ether" | awk '{print $2}')
#The number of commands executed with the sudo program.
cmd=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)
wall "	#Architecture: $system_info
	#CPU physical: $pp
	#vCPU: $vp
	#Memory Usage: $us_ram/${total_ram}MB ($us_per)
	#Disk Usage: $used_disk/${full_disk}MB ($disk_u_per%)
	#CPU load: $cu
	#Last boot: $d_reboot
	#LVM use: $lvm_a_na
	#Connection TCP: $active_conn ESTABLISHED
	#User log: $user_serv
	#Network: IP $ip ($mac)
	#Sudo: $cmd cmd"
