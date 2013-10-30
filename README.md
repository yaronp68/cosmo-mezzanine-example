Mezzanine Example
=======================

Chef Server Setup
-------------------
In order to run this demo you will need a Chef server up and running with the following recipes and their dependencies installed:
* `https://github.com/fewbytes-cookbooks/cosmo-mezzanine` - This recipe should be installed with the name `mezzanine`.
* `https://github.com/fewbytes-cookbooks/cosmo-mezzanine-demo` - This recipe should be installed with the name `cosmo-mezzanine-demo`.


Management Setup
----------------
1. Start a new machine instance that will serve as that management machine. Use an Ubuntu 12.04 64bit Server edition image.

1. Clone this repository in your local machine (not the management machine).
```
git clone https://github.com/CloudifySource/cosmo-mezzanine-example.git
cd cosmo-mezzanine-example
```

1. edit `cosmo-mezzanine-example/env.sh` so that:
    * `host` is set to the management machine public ip.
    * `workdir` points to the root directory of this repository.
    * `user` is the username to use on the management machine.
    * `userhome` is `user`'s home directory
    * `management_key_path` is a path to the ssh key used to connect to the management machine.

1. Place the ssh key that will be used for the client vm instances in the `cosmo-mezzanine-example` dir and name it `id_rsa`. (in the `mezzanine` example, this will be the key belonging to the key pair that goes by the name `head`)

1. edit `cosmo-mezzanine-example/keystone_config.json` with the appropriate details.

1. edit `cosmo-mezzanine-example/mezzanine-app/mezzanine_blueprint.yaml` so that `nova_config` is properly configured (2 places)

1. edit `cosmo-mezzanine-example/mezaanine-app/definitions/mezzanine_types.yaml` so that:
    * The chef configuration + key matches your chef server configuration
    * the `user` property under `worker_config` matches the user of the image you picked in `nova_config`

1. From the terminal, execute the following:
```
source env.sh
./copy-files-to-management.sh
ssh -i $management_key_path $user@$host
./cosmo-install-manager.sh
```


Running the demo
-----------------
Once you have setup the management machine as described above, execute the following in the ssh session that we started in the previous step.
```
cd cosmo-work
./cosmo.sh --dsl=$HOME/mezzanine-app/mezzanine_blueprint.yaml
```
If this execution finished successfully you should see something like this:
`ManagerBoot Application has been successfully deployed (press CTRL+C to quit)`

If you wish to cleanup the chef server and terminate the vm instances started, update `cleanup-cloud-server.py` with the appropriate details and configure your `.chef/knife.rb` so that `knife` commands work properly from within the repository directory. Then, execute `./cleanup.sh` from your local machine.


