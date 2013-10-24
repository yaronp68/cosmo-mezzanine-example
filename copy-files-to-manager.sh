source env.sh

scp -p -i $management_key_path $workdir/cosmo-install-manager.sh $user@$host:$userhome
scp -p -i $management_key_path $workdir/run-application.sh $user@$host:$userhome
scp -p -i $management_key_path $workdir/keystone_config.json $user@$host:$userhome
scp -p -i $management_key_path $workdir/id_rsa $user@$host:$userhome/.ssh
scp -p -i $management_key_path $workdir/id_rsa.pub $user@$host:$userhome/.ssh

cd $workdir
tar czvf mezzanine-app.tar.gz mezzanine-app
scp -p -i $management_key_path $workdir/mezzanine-app.tar.gz $user@$host:$userhome
ssh -i $management_key_path $user@$host -t "tar xzvf $userhome/mezzanine-app.tar.gz"
