#!/bin/bash
# Author: Mahesh Sharma
# Parameters Required from User:
echo "Enter CIDR formate 'IP/8-32' & Subnet Number: n you Required, Where n is Number"
cidr_ip=$1
subnet_number=$2
# Calculating IP & Mast Seperately      
addr=`echo $cidr_ip | awk -F'/' '{ print $1 }'` 
mask=`echo $cidr_ip | awk -F'/' '{ print $2 }'` 
sbit=`echo $addr | awk -F'.' '{print $1,".",$2,".",$3 }'` 
lbit=`echo $addr | awk -F'.' '{ print $4 }'` 
rbit=$(( 32 - $mask)) 
max_addr=$(( 2 ** $rbit)) 
max_lbit=$lbit 
echo -e "IP: $addr\nMASK: $mask\nL-BIT: $lbit\nS-BIT: $sbit\nReamining-Bit: $rbit\nMAX-Address: $max_addr\nMAX-Lbit: $max_lbit"
# Power Calculation for Range findings.
power_fun()
{
 next_power=2
 power=1
 subnet_range=$1
 while [ $next_power -lt $subnet_range  ]; do
 power=$(($power+1))
 next_power=$(( 2 ** $power))
 done
}
#initialising Loop Variables
raddr=$max_addr
max_slbit=$lbit
total_addr=0
start_lbit=$lbit
int=$subnet_number
while [ $int -gt 0 ]; do
 start_lbit=$(( $start_lbit + $total_addr ))
 subnet_range=$(( $raddr /  $int )) 
 power_fun $subnet_range 
 total_addr=$(( 2 ** $power ))
 max_slbit=$(( $max_slbit + $total_addr ))
 raddr=$(( $raddr - $total_addr ))
 last_lbit=$(( $max_slbit - 1))
 subnetmask=$(( $rbit - $power + $mask )) 
 gateway_lbit=$(( $start_lbit + 1 ))
 thosts=$(( $total_addr - 3 ))
 echo "Subnet= $sbit.$start_lbit/$subnetmask Network=$sbit.$start_lbit Broadcast=$sbit.$last_lbit Gateway= $sbit.$gateway_lbit Hosts=$thosts"
 int=$(($int-1)) 
done
