source env.sh

python2 cleanup-cloud-servers.py
knife node delete -y webserver-host.novalocal & knife client delete -y webserver-host.novalocal & wait && echo DONE
knife node delete -y postgres-host.novalocal & knife client delete -y postgres-host.novalocal & wait && echo DONE
