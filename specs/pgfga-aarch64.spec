%global _prefix /usr/local
Summary: Tool to manage PostgreSQL Fine Grained Access
Name: pgfga
Version: v2.0.2
Release: 1%{?dist}
License: Apache-2.0
Group: Unspecified
Url: https://gitHub.com/mannemsolutions/pgfga
Source0: pgfga_v2.0.2_linux_arm64.tar.gz
BuildArch: aarch64

%description
Tool to manage PostgreSQL Fine Grained Access

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/mannemsolutions/pgfga/releases/download/v2.0.2/pgfga_v2.0.2_linux_arm64.tar.gz -o %{_sourcedir}/pgfga_v2.0.2_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/pgfga_v2.0.2_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/pgfga %{buildroot}/%{_bindir}/pgfga


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/pgfga