%global _prefix /usr/local
Summary: Cluster aware scheduler for PostgreSQL
Name: pgquartz
Version: v0.6.5
Release: 1%{?dist}
License: GPL-3.0
Group: Unspecified
Url: https://gitHub.com/mannemsolutions/pgquartz
Source0: pgquartz_v0.6.5_linux_arm64.tar.gz
BuildArch: aarch64

%description
Cluster aware scheduler for PostgreSQL

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/mannemsolutions/PgQuartz/releases/download/v0.6.5/pgquartz_v0.6.5_linux_arm64.tar.gz -o %{_sourcedir}/pgquartz_v0.6.5_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/pgquartz_v0.6.5_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/pgquartz %{buildroot}/%{_bindir}/pgquartz


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/pgquartz