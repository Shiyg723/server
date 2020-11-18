FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu18.04

# install basic dependencies
RUN apt-get update 
RUN apt-get install -y wget \
		vim \
		cmake

# install Anaconda3
RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda3.sh
RUN bash ~/anaconda3.sh -b -p /home/anaconda3 \
	&& rm ~/anaconda3.sh 
ENV PATH /home/anaconda3/bin:$PATH

# change mirror
RUN mkdir ~/.pip \
	&& cd ~/.pip 	
RUN	echo -e "[global]\nindex-url = https://pypi.mirrors.ustc.edu.cn/simple/" >> ~/pip.conf

# install tensorflow
RUN /home/anaconda3/bin/pip install tensorflow-gpu


# install x11vnc
WORKDIR /tmp
ADD image/etc /etc

ARG DEBIAN_FRONTEND=noninteractive 

# Install some required system tools and packages for X Windows
RUN add-apt-repository ppa:webupd8team/atom && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        automake \
        autoconf \
        gettext \
        libtool-bin \
        libltdl-dev \
        ruby \
        ruby-dev \
        atom \
        meld \
        docker.io && \
    apt-get -y autoremove && \
    gem install travis && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Customize atom
RUN pip install -U \
        autopep8 flake8 &&\
    apm install \
        language-docker \
        autocomplete-python \
        git-plus \
        merge-conflicts \
        split-diff \
        platformio-ide-terminal \
        intentions \
        busy-signal \
        linter-ui-default \
        linter \
        linter-flake8 \
        python-autopep8 \
        clang-format && \
    rm -rf /tmp/* && \
    echo '@atom .' >> $DOCKER_HOME/.config/lxsession/LXDE/autostart && \
    \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME
