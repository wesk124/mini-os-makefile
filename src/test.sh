#!/bin/sh

# Declare variables

COUNT_OF_CONFIGS=$1
CURR_DIR=`pwd`

VAR_KERNEL="$CURR_DIR/mini-os.gz"
VAR_DESTRO="destroy"
VAR_MEMORY="30"
VAR_VCPU="1"



# generating the configure files

for i in `seq 1 $COUNT_OF_CONFIGS`; do
	touch "/etc/xen/test_app$i.cfg"
	VAR_NAME="test_app$i"
	cat > /etc/xen/test_app$i.cfg << EOL
kernel='${VAR_KERNEL}'
memory=${VAR_MEMORY}
vcpus=${VAR_VCPU}
name='test_app${i}'
on_crash='${VAR_DESTRO}'
EOL
	done	
touch "etc/xen/target_app.cfg"
cat > /etc/xen/target_app.cfg <<EOL
kernel='${VAR_KERNEL}'
memory=${VAR_MEMORY}
vcpus=${VAR_VCPU}
name='target_app'
on_crash='${VAR_DESTRO}'
EOL

for j in `seq 1 $COUNT_OF_CONFIGS`; do
	(xl create /etc/xen/test_app$j.cfg) &
done
wait

# Write in the target appiliance boot time
VAR_RESULT=$(chrono xl create /etc/xen/target_app.cfg)
echo $COUNT_OF_CONFIGS $VAR_RESULT >> data.txt 

# Destroy all appliances and remove all configure files

for k in `seq 1 $COUNT_OF_CONFIGS`; do 
	(xl destroy test_app$k)
	rm /etc/xen/test_app$k.cfg
done
wait

xl destroy target_app
rm /etc/xen/target_app.cfg



