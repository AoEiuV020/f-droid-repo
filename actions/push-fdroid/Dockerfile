FROM registry.gitlab.com/fdroid/docker-executable-fdroidserver:master

RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install python3-pip

# https://gitlab.com/fdroid/docker-executable-fdroidserver/-/issues/28
RUN git clone --depth 1 -b v4.1.2 --recursive https://github.com/androguard/androguard.git && \
    cd androguard && \
    pip install . --break-system-packages

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
