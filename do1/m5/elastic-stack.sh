#!/bin/bash

echo "* Installing Elasticsearch"
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-x86_64.rpm
sudo rpm -Uvh elasticsearch-*.rpm

echo "* Remove basic elasticsearch.yml"
sudo sudo rm /etc/elasticsearch/elasticsearch.yml -f

echo "* Copying Elasticsearch Config Files"
sudo cp /vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo cp /vagrant/jvm.options /etc/elasticsearch/jvm.options.d/

echo "* Start Elasticsearch service"
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

echo "* Installing Logstash"
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.6.2-x86_64.rpm
sudo rpm -Uvh logstash-*.rpm

echo "* Copying beats.conf for Logstash"
sudo cp /vagrant/beats.conf /etc/logstash/conf.d/beats.conf

echo "* Start Logstash service"
sudo systemctl daemon-reload
sudo systemctl enable logstash
sudo systemctl start logstash

echo "* Installing Kibana"
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.6.2-x86_64.rpm
sudo rpm -Uvh kibana-*.rpm

echo "* Remove basic kibana.yml"
sudo sudo rm /etc/kibana/kibana.yml -f

echo "* Copying Kibana Config Files"
sudo cp /vagrant/kibana.yml /etc/kibana/kibana.yml

echo "* Start Kibana service"
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana

echo "* Adjust firewall rules"
firewall-cmd --add-port 8080/tcp --permanent
firewall-cmd --add-port 5044/tcp --permanent
firewall-cmd --add-port 5601/tcp --permanent
firewall-cmd --add-port 9200/tcp --permanent
firewall-cmd --add-port 9300/tcp --permanent
firewall-cmd --reload