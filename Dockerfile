FROM ubuntu:24.04
ENV container docker

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3 \
    systemd \
    sudo \
    systemd-sysv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN find /lib/systemd/system/sysinit.target.wants/ -type l | grep -v systemd-tmpfiles-setup | xargs rm -f

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
/etc/systemd/system/*.wants/* \
/lib/systemd/system/local-fs.target.wants/* \
/lib/systemd/system/sockets.target.wants/*udev* \
/lib/systemd/system/sockets.target.wants/*initctl* \
/lib/systemd/system/basic.target.wants/* \
/lib/systemd/system/anaconda.target.wants/* \
/lib/systemd/system/plymouth* \
/lib/systemd/system/systemd-update-utmp*

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/lib/systemd/systemd"]
