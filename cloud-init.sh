#!/usr/bin/env bash

sudo yum -y update

# Update the Hostname
hostnamectl hostname ${node_name}.${aws_base_dns_domain}

# Register system 
sudo subscription-manager unregister
sudo subscription-manager register --username ${rh_subscription_username} --password ${rh_subscription_password}
subscription-manager config --rhsm.manage_repos=1
sudo subscription-manager refresh
sudo subscription-manager repos --enable rhocp-4.13-for-rhel-9-$(uname -m)-rpms --enable fast-datapath-for-rhel-9-$(uname -m)-rpms

# Install the microshift
sudo dnf install -y microshift

# Copy the imagepullsecret
sudo cp /tmp/openshift-pull-secret /etc/crio/openshift-pull-secret
sudo chown root:root /etc/crio/openshift-pull-secret
sudo chmod 600 /etc/crio/openshift-pull-secret

# Config the baseDomain
sudo cp /etc/microshift/config.yaml.default /etc/microshift/config.yaml
sudo sed -i "s/#baseDomain: microshift.example.com/baseDomain: ${aws_base_dns_domain}/g" /etc/microshift/config.yaml

# Start the microshift
sudo systemctl start microshift
sudo systemctl enable microshift