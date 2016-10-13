#!/bin/sh

nodes_name=(${!nodes_map[@]});

tmp_file=/etc/hosts.bak
target=/etc/hosts
rm -rf  $tmp_file
### generate host file
for ((i=0; i<${#nodes_map[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_map[$name]};
      echo "$ip $name">>$tmp_file
  done;
### scp to other nodes
for ((i=0; i<${#nodes_map[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_map[$name]};
      echo "-------------$name------------"
      ###set hostname
      ssh root@$ip hostnamectl --static set-hostname $name
      scp /etc/hosts.bak root@$ip:/etc/hosts
  done;
### check
for ((i=0; i<${#nodes_map[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_map[$name]};
      echo "-------------$name------------"
      ###ping hostname
      ping -c 2 $name
      ssh root@$ip hostname
  done