#!/bin/bash

# Config rabbit hosts.
host1=192.168.100.11
host2=192.168.100.12
vip=192.168.100.10

rabbitmq_pwd="<fill_pass>"
database_pwd="<fill_pass>"

#
# Config backup
#
echo "# 1. Comment the transport_url config and make the configs backup."
echo "#    Because when we start (we will in the next step) Heat container (Ocata) to execute db_sync."
echo "#    We don't want this Ocata service communicate with another Newton service."
mkdir heat-backup-configs
cp -a /etc/kolla/heat-* heat-backup-configs
sed -i -e "s/transport_url/#transport_url/g" /etc/kolla/heat-*/heat.conf
echo "#    Comment the transport_url config...Done!"
#
# Database backup
#
echo "# 2. Make current Heat database (Newton) backup"
mysqldump -u root -p$database_pwd  -h $vip heat > heat_newton.sql
echo "#    Backup current Heat database...Done! See heat_newton.sql file."
#
# Run send_requests.py script
#
echo "# 3. Run the send_requests.py in another tab."
echo "#    Command: python $PWD/test_heat_status/send_request.py"
echo "#    Log file: $PWD/test_heat_status/send_request.log"
#
# Start Heat engine container (Ocata), to execute db_sync.
#
echo "# 4. Start heat_engine_ocata container"
# Just do it one time.
if [ $HOST = "node1" ];
then
    docker start heat_engine_ocata
    docker exec -it heat_engine_ocata /bin/sh -c "heat-manage db_sync" heat
fi
#
# Change the transport_url config again with new vhost (named 'ocata').
#
echo "# 5. Make sure new vhost was created and named ocata. Change transport_url."
transport_url="transport_url = rabbit://openstack:$rabbitmq_pwd@$node1:5672,openstack:$rabbitmq_pwd@node2:5672"
sed -i -e "s/#$transport_url/$transport_url\/ocata/g" /etc/kolla/heat-*/heat.conf
echo "#    Change transport_url...Done!"
#
# Stop heat_engine container (Newton) and start heat_engine_ocata container.
#
echo "# 6. Stop Heat Newton container and start Heat Ocata container."
# Different stop/start order.
if [ $HOST == "node1" ];
then
    docker stop heat_engine && docker restart heat_engine_ocata
    docker stop heat_api && docker start heat_api_ocata
    docker stop heat_api_cfn && docker start heat_api_cfn_ocata
fi

if [ $HOST = "node2" ];
then
    docker stop heat_api && docker start heat_api_ocata
    docker stop heat_api_cfn && docker start heat_api_cfn_ocata
    docker stop heat_engine && docker restart heat_engine_ocata
fi
echo "# 7. Rolling upgrade is Done. Check $PWD/test_heat_status/send_request.log"
