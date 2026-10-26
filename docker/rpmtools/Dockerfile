ARG BASEIMAGE=dontknow:dontcare
FROM ${BASEIMAGE}

# rpm tools, and the build dependencies for packages built from source (rpmbuilder/templates/go.spec.j2,
# e.g. wal-g-pg).
# el needs epel (libsodium-devel) and crb (lzo-devel), fedora has it all.
# openSUSE uses zypper and has no %{dist}: set one (.lp160 for Leap 16.0) to keep the rpm names of releases apart.
RUN . /etc/os-release && \
    case "${ID}" in \
      opensuse-leap) \
        zypper --non-interactive update && \
        zypper --non-interactive install pinentry gpg2 rpmdevtools rpm-build jq unzip system-group-wheel \
          git cmake gcc make pkgconf tar lzo-devel libsodium-devel && \
        zypper clean --all && \
        echo "%dist .lp$(echo "${VERSION_ID}" | tr -d .)" > /etc/rpm/macros.dist ;; \
      *) \
        mkdir -p /etc/dnf/libdnf5.conf.d/ && \
        echo -e  '[main]\nfastestmirrors=true ' > /etc/dnf/libdnf5.conf.d/80-local.conf && \
        dnf update -y && \
        dnf install -y pinentry gnupg2 rpmdevtools rpm-build rpm-sign jq unzip && \
        if [ "${ID}" != fedora ]; then \
          dnf install -y dnf-plugins-core epel-release && crb enable; \
        fi && \
        dnf install -y git cmake gcc make pkgconf-pkg-config tar lzo-devel libsodium-devel && \
        dnf clean all ;; \
    esac

WORKDIR /usr/rpmbuilder

RUN useradd -m -G wheel rpmbuilder

USER rpmbuilder
