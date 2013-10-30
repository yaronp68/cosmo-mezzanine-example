Mezzanine Example
=======================

Overview
---------
Fill me up.

Demo Application Structure Description
--------------------------------------
The [`Mezzanine`](http://mezzanine.jupo.org/) demo application (see `mezzanine-app/mezzanine_blueprint.yaml`) is composed of the following pieces:
* Two nodes represent host machines, one for the web frontend and one for `postgres`.
* A node for the [`nginx`](http://nginx.org/) server which is `contained_in` the web fronted host.
* A node for [`gunicorn`](http://gunicorn.org/) which is also `contained_in` the web frontend host.
* A node for the [`postgres`](http://www.postgresql.org/) database server which is `contained_in` the `postgres` host.
* A node for the `mezzanine db` which represents the actual database schema used by the mezzanine application.
This node is `contained_in` the `postgres` database node
* A node for the actual `mezzanine app`. This node is `contained_in` the `gunicorn` node and is `connected_to`
The `mezzanine db` node.

The two host nodes are provisioned using the [`python-novaclient`](https://pypi.python.org/pypi/python-novaclient/) library. The rest of the nodes are installed and started
using [`Chef`](http://www.opscode.com/chef/).


For an in depth the description of the model concepts behind this demo application see [Concepts](concepts.md).


Chef Server Setup
-------------------
In order to run this demo you will need a Chef server up and running with the following recipes and their dependencies installed:
* `https://github.com/fewbytes-cookbooks/cosmo-mezzanine` - This recipe should be installed with the name `mezzanine`.
* `https://github.com/fewbytes-cookbooks/cosmo-mezzanine-demo` - This recipe should be installed with the name `cosmo-mezzanine-demo`.


Management Setup
----------------
1. Start a new machine instance that will serve as that management machine. Use an Ubuntu 12.04 64bit Server edition image.
Make sure that the machine is started with a security group such that ports `8080` (For [`Kibana`](http://www.elasticsearch.org/overview/kibana/)) 
and `9200` (For [`Elastic Search`](http://www.elasticsearch.org/) are open for `tcp` connections.
These will be used by [`logstash`](http://logstash.net/) that is installed as part of the management installation process.
 

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

1. edit `cosmo-mezzanine-example/keystone_config.json` as follows:
    * `username` and `password` should be the password credentials and _not_ the the api access keys as this is what the python novaclient uses.
    * `auth_url` should be the keystone auth v2.0 url
    * `tenant_name` - In HP cloud this would be the project id and in Rackspace this would be the account number.

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

After this step, the management machine will have:
* [`Celery`](http://www.celeryproject.org/) installed and a worker running to execute its management based tasks.
* [`RabbitMQ`](http://www.rabbitmq.com/) service running that is used as the backend for `celery`.
* [`Riemann`](http://riemann.io/) server running that is used for monitoring purposes.
* A workflow engine
* [`logstash`](http://logstash.net/) that is configured to read the demo output and write the entries to an embedded 
`elastic search` instance. On top of that, `kibana` is configured to present the this output on port `8080`.

Running the demo
-----------------
Once you have setup the management machine as described above, execute the following in the ssh session that we started in the previous step.
```
cd cosmo-work
./cosmo.sh --dsl=$HOME/mezzanine-app/mezzanine_blueprint.yaml
```
If this execution finished successfully you should see something like this:
`ManagerBoot Application has been successfully deployed`

You can now fire up your browser and head over to:
`http://MANAGEMENT_IP:8080` to view all the events using `Kibana`. 
For best viewing experience, it is suggested the the following columns be enabled:
* @timestamp
* type
* description

If you wish to cleanup the chef server and terminate the vm instances started, update `cleanup-cloud-server.py` with the appropriate details and configure your `.chef/knife.rb` so that `knife` commands work properly from within the repository directory. Then, execute `./cleanup.sh` from your local machine.

Please note that running `cleanup-cloud-server.py` requires `python-novaclient` to be installed. It can be installed using the following command:
```
pip install python-novaclient
```



