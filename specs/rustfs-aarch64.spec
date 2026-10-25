%global _prefix /usr/local
Summary: RustFS is an open-source, S3-compatible high-performance object storage system supporting migration and coexistence with other S3-compatible platforms such as MinIO and Ceph.
Name: rustfs
Version: 1.0.3
Release: 1%{?dist}
License: Apache-2.0
Group: Unspecified
Url: https://github.com/rustfs/rustfs
Source0: rustfs-linux-aarch64-musl-v1.0.3.zip
BuildArch: aarch64

%description
RustFS is an open-source, S3-compatible high-performance object storage system supporting migration and coexistence with other S3-compatible platforms such as MinIO and Ceph.

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/rustfs/rustfs/releases/download/1.0.3/rustfs-linux-aarch64-musl-v1.0.3.zip -o %{_sourcedir}/rustfs-linux-aarch64-musl-v1.0.3.zip



%install
mkdir -p %{buildroot}/%{_bindir}
unzip -o %{_sourcedir}/rustfs-linux-aarch64-musl-v1.0.3.zip

%{__install} -m 0755 %{_builddir}/rustfs %{buildroot}/%{_bindir}/rustfs


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/rustfs