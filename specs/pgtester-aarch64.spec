%global _prefix /usr/local
Summary: pgtester
Name: pgtester
Version: v0.6.14
Release: 1%{?dist}
License: GPL-3.0
Group: Unspecified
Url: https://github.com/pgvillage-tools/pgtester
Source0: pgtester_v0.6.14_linux_arm64.tar.gz
BuildArch: aarch64

%description
pgtester

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/pgvillage-tools/pgtester/releases/download/v0.6.14/pgtester_v0.6.14_linux_arm64.tar.gz -o %{_sourcedir}/pgtester_v0.6.14_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/pgtester_v0.6.14_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/pgtester %{buildroot}/%{_bindir}/pgtester


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/pgtester