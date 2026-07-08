# Install system package dependencies for kernel build and image creation
FROM ghcr.io/go-debos/debos:latest
LABEL maintainer="qswcct.devops@qti.qualcomm.com"
RUN \
    apt-get update \
    && apt-get install -y \
        git \
        crossbuild-essential-arm64 \
        make \
        fakemachine \
        flex \
        bison \
        bc \
        libdw-dev \
        libelf-dev \
        libssl-dev \
        libssl-dev:arm64 \
        dpkg-dev \
        debhelper-compat \
        kmod \
        python3 \
        python3-pip \
        python3-pexpect \
        rsync \
        coreutils \
        build-essential \
        curl \
        wget \
        file \
        tar \
        sudo \
        locales \
        openssh-client \
        ca-certificates \
        gnupg \
        lsb-release \
        debian-archive-keyring \
        debos \
        mmdebstrap \
        mtools \
        python3-pytest \
        python3-defusedxml \
        qemu-efi-aarch64 \
        qemu-system-arm \
        xmlstarlet \
        device-tree-compiler \
        u-boot-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 \
    && ln -sf /bin/bash /bin/sh

ARG USER=codelinaro
ARG GROUP=codelinaro
ARG UID=2366345
ARG GID=2366345
ARG USER_HOME=/home/${USER}
ARG WORKDIR=${USER_HOME}/app

RUN \
    set -x \
    && mkdir -p ${USER_HOME} ${WORKDIR} \
    && chown ${UID}:${GID} ${USER_HOME} \
    && chown ${UID}:${GID} ${WORKDIR} \
    && groupadd -g ${GID} ${GROUP} \
    && useradd -l -d ${USER_HOME} -u ${UID} -g ${GID} -s /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to non-root user
USER $USER
WORKDIR $WORKDIR

# Configure .gitconfig
RUN \
    git config --global user.email $USER@codelinaro.com \
    && git config --global user.name $USER

# Copy notice generation script
RUN \
    git clone https://git.codelinaro.org/clo/le/qcom-notice.git scripts

RUN ls scripts/

RUN pwd

ENTRYPOINT ["/bin/bash", "./scripts/deb_build.sh"]
