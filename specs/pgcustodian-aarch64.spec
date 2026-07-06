%global _prefix /usr/local
Summary: PostgreSQL TDE Vault integration
Name: pgcustodian
Version: v0.1.2
Release: 1%{?dist}
License: GPL-3.0
Group: Unspecified
Url: https://gitHub.com/mannemsolutions/pgcustodian
Source0: pgcustodian_v0.1.2_linux_arm64.tar.gz
BuildArch: aarch64

%description
PostgreSQL TDE Vault integration

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/mannemsolutions/pgcustodian/releases/download/v0.1.2/pgcustodian_v0.1.2_linux_arm64.tar.gz -o %{_sourcedir}/pgcustodian_v0.1.2_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/pgcustodian_v0.1.2_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/pgcustodian %{buildroot}/%{_bindir}/pgcustodian


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/pgcustodian