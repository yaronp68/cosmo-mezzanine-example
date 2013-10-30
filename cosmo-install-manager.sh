# installed required packages to run bootstrap_lxc_manager
sudo apt-get -y update && sudo apt-get install -y python-dev git rsync openjdk-7-jdk maven && sudo apt-get install -q -y python-pip && sudo pip install retrying && sudo pip install timeout-decorator && echo OK

# use open sdk java 7
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java

# configure and clone cosmo-manager from github
BRANCH=develop
WORKINGDIR=$HOME/cosmo-work
# VERSION=0.1-RELEASE
VERSION=0.1-SNAPSHOT
CONFIGDIR=$WORKINGDIR/cosmo-manager/vagrant
mkdir -p $WORKINGDIR
cd $WORKINGDIR
git clone https://github.com/CloudifySource/cosmo-manager.git
( cd cosmo-manager ; git checkout $BRANCH )

# bootstrap this machine as a management machine
python2.7 cosmo-manager/vagrant/bootstrap_lxc_manager.py --working_dir=$WORKINGDIR --cosmo_version=$VERSION --config_dir=$CONFIGDIR --install_openstack_provisioner --install_logstash

if [ $? -ne 0 ]; then
    exit $?
fi

mvn clean package -DskipTests -Pall -f cosmo-manager/orchestrator/pom.xml
rm cosmo.jar
cp cosmo-manager/orchestrator/target/cosmo.jar .
