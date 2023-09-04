ARG BASE_TAG="1.11.0"
ARG BASE_IMAGE="core-ubuntu-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND noninteractive
ENV KASM_RX_HOME $STARTUPDIR/kasmrx
ENV INST_SCRIPTS $STARTUPDIR/install

### Add sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/list/* \
    && cat /etc/sudoers

### Install Tools
COPY ./src/ubuntu/install/tools $INST_SCRIPTS/tools/
RUN bash $INST_SCRIPTS/tools/install_tools_deluxe.sh  && rm -rf $INST_SCRIPTS/tools/

# Install Utilities
COPY ./src/ubuntu/install/misc $INST_SCRIPTS/misc/
RUN bash $INST_SCRIPTS/misc/install_tools.sh && rm -rf $INST_SCRIPTS/misc/


### Install various tools
RUN apt install -y wget curl nano htop

### Install WINE
COPY ./src/ubuntu/install/wine $INST_SCRIPTS/wine/
RUN bash $INST_SCRIPTS/wine/install_wine.sh  && rm -rf $INST_SCRIPTS/wine/

# Install Google Chrome
COPY ./src/ubuntu/install/chrome $INST_SCRIPTS/chrome/
RUN bash $INST_SCRIPTS/chrome/install_chrome.sh  && rm -rf $INST_SCRIPTS/chrome/

### Install Knime
RUN mkdir -p /opt/ && cd /opt && curl https://download.knime.org/analytics-platform/linux/knime_5.1.0.linux.gtk.x86_64.tar.gz > knime.tar.gz && tar -xzf knime.tar.gz && rm knime.tar.gz && mv knime_5.1.0 knime

### Install NodeJS 18
RUN sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
RUN sudo apt -y install nodejs

#ADD ./src/common/scripts $STARTUPDIR
RUN $STARTUPDIR/set_user_permission.sh $HOME

RUN chown 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
