#!/bin/bash

set -e

function usage()
{
    echo "Usage: bootstrap.sh {central_manager} {pool_password}" 1>&2
    exit 1
}

CENTRAL_MANAGER=$1
if [ "x$CENTRAL_MANAGER" == "x" ]; then
    usage
fi

POOL_PASSWORD=$2
if [ "x$POOL_PASSWORD" == "x" ]; then
    usage
fi

# make sure the base image is up to date
yum -y upgrade
yum -y install epel-release yum-plugin-priorities

# base packages - based on https://github.com/rynge/osgvo-docker
#yum -y install http://repo.grid.iu.edu/osg/3.3/osg-3.3-el7-release-latest.rpm
yum -y groupinstall "Compatibility Libraries" \
                    "Development Tools" \
                    "Scientific Support"
yum -y install tcsh wget curl rsync which time bc octave octave-devel \
               libtool libtool-ltdl libtool-ltdl-devel \
               fontconfig libxml2 openssl098e libGLU libXpm \
               binutils-devel gcc libgfortran libgomp \
               subversion git gcc-gfortran gcc-c++ binutils binutils-devel \
               libquadmath libicu \
               python-devel libxml2-devel mesa-libGL-devel \
               numpy scipy python-astropy astropy-tools \
               glew-devel libX11-devel libXpm-devel libXft-devel libXt \
               libXext-devel libXmu-devel tk-devel tcl-devel \
               glib-devel glib2-devel gsl-devel \
               java-1.8.0-openjdk java-1.8.0-openjdk-devel \
               R-devel

# bootstrap salt
yum install -y salt-master salt-minion
mkdir -p /etc/salt/minion.d /etc/salt/master.d
echo "master: "`hostname -f` >/srv/jetstream-osg-worker/salt/salt/master.conf
cp /srv/jetstream-osg-worker/salt/salt/*.conf /etc/salt/minion.d/
cp /srv/jetstream-osg-worker/salt/salt/jetstream-osg.conf /etc/salt/master.d/
hostname -f >/etc/salt/minion_id
systemctl restart salt-master

# run the recipe
salt-call state.highstate >/dev/null 2>&1 || true
if [ -e /etc/salt/pki/master/minions_pre/$HOSTNAME ]; then
    mv /etc/salt/pki/master/minions_pre/$HOSTNAME /etc/salt/pki/master/minions/$HOSTNAME
fi
salt-call state.highstate

# once HTCondor is installed, set the pool password and where to find the master
condor_store_cred -p `uuidgen` -f /srv/jetstream-osg-worker/salt/htcondor/pool_password
echo "CONDOR_HOST = $CENTRAL_MANAGER" >/srv/jetstream-osg-worker/salt/htcondor/50-master.conf

salt-call state.highstate

# Install Singularity - still in upcoming
yum -y install --enablerepo osg-upcoming-development singularity

yum -y clean all

systemctl restart salt-minion

