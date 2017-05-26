FROM ubuntu
RUN apt-get update
RUN apt-get install -y curl python-yaml python-jinja2 git vim sshpass
RUN git clone http://github.com/ansible/ansible.git /opt/ansible
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
     tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
RUN apt-get install -y apt-transport-https
RUN apt-get update && apt-get install -y azure-cli
RUN ssh-keygen -t rsa -f  ~/.ssh/id_rsa -P ""

ENV PATH /opt/ansible/bin:/sbin:/usr/sbin:/usr/bin:/bin:/opt/az/bin/
ENV ANSIBLE_LIBRARY /opt/ansible/library
ENV PYTHONPATH /opt/ansible/lib:$PYTHON_PATH

COPY demo.sh /opt/
COPY gfs-machine-parameters.json /opt/
COPY gfs-machine-provision.sh /opt/
COPY gfs-machine.json /opt/
COPY gfs-machine.sh /opt/
COPY vnet.json /opt/

WORKDIR /opt/
