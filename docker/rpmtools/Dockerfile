ARG BASEIMAGE=dontknow:dontcare
FROM ${BASEIMAGE}

RUN mkdir -p /etc/dnf/libdnf5.conf.d/ && \
    echo -e  '[main]\nfastestmirrors=true ' > /etc/dnf/libdnf5.conf.d/80-local.conf && \
    dnf update -y && \
    dnf install -y pinentry gnupg2 rpmdevtools rpm-build rpm-sign jq unzip

# build dependencies for packages built from source (rpmbuilder/templates/go.spec.j2, e.g. wal-g-pg);
# el needs epel (libsodium-devel) and crb (lzo-devel), fedora has it all
RUN . /etc/os-release && \
    if [ "${ID}" != fedora ]; then \
      dnf install -y dnf-plugins-core epel-release && crb enable; \
    fi && \
    dnf install -y git cmake gcc make pkgconf-pkg-config tar lzo-devel libsodium-devel && \
    dnf clean all

WORKDIR /usr/rpmbuilder

RUN useradd -G wheel rpmbuilder

USER rpmbuilder
