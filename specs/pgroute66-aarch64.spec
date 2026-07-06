%global _prefix /usr/local
Summary: Postgres router which prevents split brain routing
Name: pgroute66
Version: v0.8.9
Release: 1%{?dist}
License: GPL-3.0
Group: Unspecified
Url: https://gitHub.com/mannemsolutions/pgroute66
Source0: pgroute66_v0.8.9_linux_arm64.tar.gz
BuildArch: aarch64

%description
Postgres router which prevents split brain routing

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/mannemsolutions/pgroute66/releases/download/v0.8.9/pgroute66_v0.8.9_linux_arm64.tar.gz -o %{_sourcedir}/pgroute66_v0.8.9_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/pgroute66_v0.8.9_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/pgroute66 %{buildroot}/%{_bindir}/pgroute66


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/pgroute66