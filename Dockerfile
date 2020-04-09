FROM aicampbell/vnc-ubuntu18-xfce

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils apt-transport-https software-properties-common curl iputils-ping vim leafpad libnss3-tools && \
    apt-key adv --keyserver-options --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' && \
    apt-get update

##### Installation Docker
RUN apt-get install -y docker-engine && \
    curl -sSL https://raw.githubusercontent.com/docker/docker/master/hack/dind -o /usr/local/bin/dind && \
    chmod a+x /usr/local/bin/dind

##### Extension JsonViewer pour chromium
RUN touch /etc/chromium-browser/policies/managed/test_policy.json && \
    echo "{\"ExtensionInstallForcelist\": [\"aimiinbnnkboelefkjlenlgimcabobli;https://clients2.google.com/service/update2/crx\"]}" > /etc/chromium-browser/policies/managed/test_policy.json

#### Installation s3cmd
#RUN apt-get install -y s3cmd
## install setuptools first
RUN apt-get install -y python-pip unzip && \
    pip install --upgrade pip setuptools && \
    wget https://github.com/s3tools/s3cmd/releases/download/v2.1.0/s3cmd-2.1.0.zip -O s3cmd.zip && \
    unzip s3cmd.zip && \
    cd s3cmd-2.1.0/ && \
    python setup.py install
ADD .s3cfg .s3cfg

##### Clean
RUN apt-get clean && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/lists/*

##### Changer fond d'écran
RUN rm /headless/.config/bg_sakuli.png
ADD wallpaper.png /headless/.config/bg_sakuli.png

##### Ajout script de démarrage & bashrc
ADD startup.sh /headless/startup.sh
ADD bashrc.sh /headless/bashrc.sh
RUN cat /headless/startup.sh >> /headless/wm_startup.sh && \
    cat /headless/bashrc.sh >> /headless/.bashrc && \
    rm /headless/startup.sh && \
    rm /headless/bashrc.sh

VOLUME ["/var/lib/docker"]
ENTRYPOINT ["/bin/bash"]
CMD ["/dockerstartup/vnc_startup.sh","--wait"]
