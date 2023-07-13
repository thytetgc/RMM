#!/bin/bash
#
# Alert on Tactical if the service is faulty and restart

for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

if [ -z "$service" ];
then
    service=snmpd.service
fi

HAS_SYSTEMD=$(ps --no-headers -o comm 1)
if [ "${HAS_SYSTEMD}" != 'systemd' ]; then
    echo "This install script only supports systemd"
    echo "Please install systemd or manually create the service using your systems's service manager"
    exit 0
fi

failsvc=$(sudo systemctl is-failed "$service")

if [[ "$failsvc" != 'active' ]]; then
    echo -e ''$service' is not active'
    echo -e 'Restarting the service'
sudo systemctl restart "$service"
    exit 1
else
    echo  ''$service' services are running'
    exit 0
fi
