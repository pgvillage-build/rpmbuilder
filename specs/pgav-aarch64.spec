%global _prefix /usr/local
Summary: Tool to track postgres availability
Name: pgav
Version: v0.1.2
Release: 1%{?dist}
License: GPL-3.0
Group: Unspecified
Url: https://gitHub.com/mannemsolutions/pgav
Source0: pgav_v0.1.2_Linux-aarch64.tar.gz
BuildArch: aarch64

%description
Tool to track postgres availability

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/mannemsolutions/pgav/releases/download/v0.1.2/pgav_v0.1.2_Linux-aarch64.tar.gz -o %{_sourcedir}/pgav_v0.1.2_Linux-aarch64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/pgav_v0.1.2_Linux-aarch64.tar.gz

%{__install} -m 0755 %{_builddir}/pgav %{buildroot}/%{_bindir}/pgav


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/pgav