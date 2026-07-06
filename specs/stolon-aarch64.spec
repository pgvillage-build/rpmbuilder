%global _prefix /usr/local
Summary: PostgreSQL cloud native High Availability and more.
Name: stolon
Version: v0.17.0
Release: 1%{?dist}
License: Apache-2.0
Group: Unspecified
Url: https://gitHub.com/mannemsolutions/stolon
Source0: stolon_v0.17.0_linux_arm64.tar.gz
BuildArch: aarch64

%description
PostgreSQL cloud native High Availability and more.

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/mannemsolutions/stolon/releases/download/v0.17.0/stolon_v0.17.0_linux_arm64.tar.gz -o %{_sourcedir}/stolon_v0.17.0_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/stolon_v0.17.0_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/stolonctl %{buildroot}/%{_bindir}/stolonctl
%{__install} -m 0755 %{_builddir}/stolon-sentinel %{buildroot}/%{_bindir}/stolon-sentinel
%{__install} -m 0755 %{_builddir}/stolon-proxy %{buildroot}/%{_bindir}/stolon-proxy
%{__install} -m 0755 %{_builddir}/stolon-keeper %{buildroot}/%{_bindir}/stolon-keeper


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/stolonctl
%{_bindir}/stolon-sentinel
%{_bindir}/stolon-proxy
%{_bindir}/stolon-keeper