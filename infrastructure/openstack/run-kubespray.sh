#!/bin/bash -e

tag=`date +%s`-$$

git clone https://github.com/kubernetes-incubator/kubespray.git kubespray-$tag

./inventory-from-tfstate.sh terraform.tfstate > kubespray-$tag/inventory.cfg

cd kubespray-$tag

ansible-playbook -i ./inventory.cfg -b -v -e docker_dns_servers_strict=no cluster.yml

ansible -i ./inventory.cfg kube-node -m shell -a "sudo docker run --rm -t -v /opt/cni/bin:/opt/cni/bin travelping/multus-cni install -m 0755 /src/bin/multus /opt/cni/bin/"
