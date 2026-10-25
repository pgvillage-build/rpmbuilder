%global _prefix /usr/local
Summary: A S3-compatible command-line client written in Rust.
Name: rustfs-cli
Version: v0.1.36
Release: 1%{?dist}
License: Apache-2.0
Group: Unspecified
Url: https://github.com/rustfs/cli
Source0: rustfs-cli-linux-arm64-v0.1.36.tar.gz
BuildArch: aarch64

%description
A S3-compatible command-line client written in Rust.

%prep
mkdir -p %{_sourcedir}
curl -L https://github.com/rustfs/cli/releases/download/v0.1.36/rustfs-cli-linux-arm64-v0.1.36.tar.gz -o %{_sourcedir}/rustfs-cli-linux-arm64-v0.1.36.tar.gz



%install
mkdir -p %{buildroot}/%{_bindir}
tar -xvf %{_sourcedir}/rustfs-cli-linux-arm64-v0.1.36.tar.gz

%{__install} -m 0755 %{_builddir}/rc %{buildroot}/%{_bindir}/rc


%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/rc