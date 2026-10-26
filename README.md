# rpmbuilder

Build rpm files for the pgvillage tools, from their GitHub releases (see `config/github2spec.yaml`).

## Supported distributions

Every release has rpms for x86_64 and aarch64 on:

| Distribution       | Releases    | Name in the tarball |
| ------------------ | ----------- | ------------------- |
| Rocky Linux / RHEL | 8, 9, 10    | `el8`, `el9`, `el10` |
| Fedora             | 43, 44      | `fc43`, `fc44`      |
| openSUSE Leap      | 16.0        | `lp160`             |

The releases are not hardcoded: a release builds for every release of these distributions that
[endoflife.date](https://endoflife.date) lists as released and not end of life, once its container image exists
(`scripts/distro_releases.sh`). The table shows the releases at the time of writing.

## Install

Each [release](https://github.com/pgvillage-build/rpmbuilder/releases) has one tarball per distribution release,
`pgvillage-rpms-<tag>-<distro>.tar.gz`, and a `SHA256SUMS` file. A tarball unpacks to
`pgvillage-rpms-<tag>-<distro>/<arch>/*.rpm`.

```
TAG=v1.2.3      # the release
DISTRO=el9      # see the table above
BASEURL=https://github.com/pgvillage-build/rpmbuilder/releases/download/${TAG}
curl -LO "${BASEURL}/pgvillage-rpms-${TAG}-${DISTRO}.tar.gz" -LO "${BASEURL}/SHA256SUMS"
sha256sum -c --ignore-missing SHA256SUMS
tar -xzf "pgvillage-rpms-${TAG}-${DISTRO}.tar.gz"

# the rpms are signed with gpg_pubkey.asc from this repository
sudo rpm --import https://raw.githubusercontent.com/pgvillage-build/rpmbuilder/main/gpg_pubkey.asc
rpm -K "pgvillage-rpms-${TAG}-${DISTRO}/$(uname -m)/"*.rpm

# Rocky Linux, RHEL and Fedora
sudo dnf install "./pgvillage-rpms-${TAG}-${DISTRO}/$(uname -m)/pgfga-"*.rpm
# openSUSE Leap
sudo zypper install "./pgvillage-rpms-${TAG}-${DISTRO}/$(uname -m)/pgfga-"*.rpm
```

## How it is built

The GitHub workflows do the building:

- `.github/workflows/release.yml` builds and signs every package for every distribution release when a release
  is published, and attaches the tarballs.
- `.github/workflows/ci-run-on-pr.yaml` builds on a few distribution releases for every pull request, and keeps
  the tarballs as a workflow artifact.

The builder image is `docker/rpmtools/Dockerfile`; `scripts/speclist_as_json.sh` decides what is built where.

## Build locally

The Makefile does the same with docker-compose, for one distribution release and the architecture of your machine:

```
make specs                                  # generate specs/ from config/github2spec.yaml
make rpms IMAGE=rockylinux/rockylinux:10    # build the builder image and the rpms in rpms/ (default fedora:44)
make sign                                   # sign rpms/ (needs GPG_KEY_B64 and GPG_PASSPHRASE, see Secrets)
```

`SPECBUILDER_ONLY=pgfga make specs` only generates the given packages. With podman, add
`DOCKER=podman COMPOSE=podman-compose`.

## Secrets
Are added in this repo as a gpg encrypted file.
To extract:
```
cd ~/git/pgvillage-build/rpmbuilder
gpg -d secrets.tar.gz.gpg | tar -xv
```
After that your RPM's will be signed ;)...

## Support
For all rpms that are available from https://github.com/pgvillage-build/rpmbuilder/releases support can be acquired from Nibble-IT in The Netherlands.

For more information please contact us at https://www.nibble-it.nl/contact
