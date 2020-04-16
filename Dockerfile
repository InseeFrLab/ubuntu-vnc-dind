FROM aicampbell/vnc-ubuntu18-xfce

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils apt-transport-https software-properties-common curl iputils-ping vim leafpad libnss3-tools && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update

##### Installation Docker
RUN apt-get install -y docker-ce && \
    curl -sSL https://raw.githubusercontent.com/docker/docker/master/hack/dind -o /usr/local/bin/dind && \
    chmod a+x /usr/local/bin/dind

##### Extension JsonViewer pour chromium
RUN touch /etc/chromium-browser/policies/managed/test_policy.json && \
    echo "{\"ExtensionInstallForcelist\": [\"aimiinbnnkboelefkjlenlgimcabobli;https://clients2.google.com/service/update2/crx\"]}" > /etc/chromium-browser/policies/managed/test_policy.json

# Installing s3cmd

RUN apt install -y s3cmd

# Installing vault

RUN apt-get install -y unzip
RUN cd /usr/bin && \
    wget https://releases.hashicorp.com/vault/1.3.4/vault_1.3.4_linux_amd64.zip && \
    unzip vault_1.3.4_linux_amd64.zip && \
    rm vault_1.3.4_linux_amd64.zip
RUN vault -autocomplete-install

# Installing kubectl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl
RUN apt-get install bash-completion

# Installing helm

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh
    
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
