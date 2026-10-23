ARG BASEIMAGE=dontknow:dontcare
FROM ${BASEIMAGE}

RUN mkdir -p /etc/dnf/libdnf5.conf.d/ && \
    echo -e  '[main]\nfastestmirrors=true ' > /etc/dnf/libdnf5.conf.d/80-local.conf && \
    dnf update -y && \
    dnf install -y pinentry rpmdevtools rpm-build rpm-sign jq unzip

WORKDIR /usr/rpmbuilder

RUN useradd -G wheel rpmbuilder

USER rpmbuilder
