FROM azuresdk/azure-cli-python
RUN apt-get update
COPY demo.sh /opt/
COPY gfs-machine-parameters.json /opt/
COPY gfs-machine-provision.sh /opt/
COPY gfs-machine.json /opt/
COPY gfs-machine.sh /opt/
COPY output /opt/
COPY vnet.json /opt/

WORKDIR /opt/
