%global _prefix /usr/local
Summary: Reimplementation of ChainSmith in Golang moved under pgvillage-tools umbrella
Name: chainsmith
Version: v0.3.20
Release: 1%{?dist}
License: GPL-3.0
Group: Unspecified
Url: https://gitHub.com/pgvillage-tools/chainsmith
Source0: chainsmith_v0.3.20_linux_arm64.tar.gz
BuildArch: aarch64

%description
Reimplementation of ChainSmith in Golang moved under pgvillage-tools umbrella

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/pgvillage-tools/chainsmith/releases/download/v0.3.20/chainsmith_v0.3.20_linux_arm64.tar.gz -o %{_sourcedir}/chainsmith_v0.3.20_linux_arm64.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/chainsmith_v0.3.20_linux_arm64.tar.gz

%{__install} -m 0755 %{_builddir}/chainsmith %{buildroot}/%{_bindir}/chainsmith


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/chainsmith