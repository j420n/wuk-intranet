%define contentdir /var/www

Summary: The PHP HTML-embedded scripting language
Name: php
Version: 5.2.17
Release: 2
License: The PHP License v3.01
Group: Development/Languages
URL: http://www.php.net/

Source0: http://www.php.net/distributions/%{name}-%{version}.tar.bz2
Source1: %{name}.conf
Source2: %{name}.ini

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root


BuildRequires: httpd-devel >= 2.0.46-1, pam-devel
BuildRequires: libstdc++-devel, sqlite-devel >= 3.6.0
BuildRequires: zlib-devel, pcre-devel >= 6.6, smtpdaemon, libedit-devel
BuildRequires: bzip2, perl, libtool >= 1.4.3, gcc-c++, re2c

BuildRequires: gd-devel >= 2.0.35
BuildRequires: libjpeg-devel, libpng-devel, zlib-devel
BuildRequires: httpd-devel >= 2.2.6-1
BuildRequires: curl-devel >= 7.17.1
BuildRequires: openssl-devel >= 0.9.8, freetype-devel >= 2.3.5, t1lib-devel
BuildRequires: pcre-devel >= 7.4
BuildRequires: libxml2-devel >= 2.6.31
BuildRequires: libxml2 libxml2-devel pcre-devel bzip2-devel libjpeg-devel libpng-devel libXpm-devel
BuildRequires: freetype-devel gmp-devel mysql-devel unixODBC-devel readline-devel net-snmp-devel
BuildRequires: libxslt-devel


Obsoletes: php-dbg, php3, phpfi, stronghold-php
Requires: httpd >= 2.2.6-1
Requires: %{name}-common = %{version}-%{release}
Requires: php-cli%{?_isa} = %{version}-%{release}
Requires: gd >= 2.0.35
Requires: bzip2, libjpeg, libpng, zlib
Requires: curl >= 7.17.1
Requires: openssl >= 0.9.8, freetype >= 2.3.5, t1lib
Requires: pcre >= 7.4
Requires: libxml2 >= 2.6.31

# To ensure correct /var/lib/php/session ownership:
Requires(pre): httpd

Provides: mod_php = %{version}-%{release}


%description
PHP is an HTML-embedded scripting language. PHP attempts to make it
easy for developers to write dynamically generated webpages. PHP also
offers built-in database integration for several commercial and
non-commercial database management systems, so writing a
database-enabled webpage with PHP is fairly simple. The most common
use of PHP coding is probably as a replacement for CGI scripts. 

The php package contains the module which adds support for the PHP
language to Apache HTTP Server.


%package cli
Group: Development/Languages
Summary: Command-line interface for PHP
Provides: %{name}-cgi = %{version}-%{release}
Requires: %{name}-common = %{version}-%{release}
Requires: gd >= 2.0.35
Requires: bzip2, libjpeg, libpng, zlib
Requires: curl >= 7.17.1
Requires: openssl >= 0.9.8, freetype >= 2.3.5, t1lib
Requires: pcre >= 7.4
Requires: libxml2 >= 2.6.31

%description cli
The php-cli package contains the command-line interface 
executing PHP scripts, /opt/freeware/bin/php, and the CGI interface.


%package common
Group: Development/Languages
Summary: Common files for PHP

%description common
The php-common package contains files used by both the php
package and the php-cli package.


%package devel
Group: Development/Libraries
Summary: Files needed for building PHP extensions
Requires: %{name} = %{version}-%{release}
Requires: gd-devel >= 2.0.35
Requires: bzip2, libjpeg-devel, libpng-devel, zlib-devel
Requires: curl-devel >= 7.17.1
Requires: httpd-devel >= 2.2.6-1
Requires: openssl-devel >= 0.9.8, freetype-devel >= 2.3.5, t1lib-devel
Requires: pcre-devel >= 7.4
Requires: libxml2-devel >= 2.6.31

%description devel
The php-devel package contains the files needed for building PHP
extensions. If you need to compile your own PHP extensions, you will
need to install this package.


%prep
%setup -q


%build

# shell function to configure and build a PHP tree
buildphp() {
ln -sf ../configure
%configure \
	--cache-file=../config.cache \
        --with-libdir=%{_lib} \
	--with-config-file-path=%{_sysconfdir} \
	--with-config-file-scan-dir=%{_sysconfdir}/php.d \
	--disable-debug \
	--with-pic \
	--disable-rpath \
	--without-pear \
	--with-bz2 \
	--with-exec-dir=%{_bindir} \
	--with-freetype-dir=%{_prefix} \
	--with-png-dir=%{_prefix} \
	--with-xpm-dir=%{_prefix} \
	--enable-gd-native-ttf \
	--without-gdbm \
	--with-gettext \
	--with-gmp \
	--with-iconv \
	--with-jpeg-dir=%{_prefix} \
	--with-openssl \
        --with-pcre-regex=%{_prefix} \
	--with-zlib \
	--with-layout=GNU \
	--enable-exif \
	--enable-ftp \
	--enable-magic-quotes \
	--enable-sockets \
	--enable-sysvsem --enable-sysvshm --enable-sysvmsg \
	--with-kerberos \
	--enable-ucd-snmp-hack \
	--enable-shmop \
	--enable-calendar \
        --without-sqlite \
        --with-libxml-dir=%{_prefix} \
	--enable-xml \
        --with-system-tzdata \
    $*
gmake %{?_smp_mflags}
}


# build the command line and the CGI version of PHP
mkdir build-cgi
cd build-cgi
buildphp \
    --enable-fastcgi
cd ..


# build the Apache module
mkdir build-apache
cd build-apache
buildphp \
    --with-apxs2=%{_sbindir}/apxs
cd ..


%install
[ "${RPM_BUILD_ROOT}" != "/" ] && rm -rf ${RPM_BUILD_ROOT}

# unfortunately 'make install-sapi' does not seem to work for use, therefore
# we have to install the targets separately
cd build-cgi
for TARGET in install-cli install-build install-headers install-programs ; do
    gmake INSTALL_ROOT=${RPM_BUILD_ROOT} ${TARGET}
done

# install the php-cgi binary
cp sapi/cgi/php-cgi ${RPM_BUILD_ROOT}%{_bindir}
chmod 755 ${RPM_BUILD_ROOT}%{_bindir}/php-cgi

# install the DSO
cd ../build-apache
mkdir -p ${RPM_BUILD_ROOT}%{_libdir}/httpd/modules
chmod 755 ${RPM_BUILD_ROOT}%{_libdir}/httpd/modules
cp .libs/libphp5.so ${RPM_BUILD_ROOT}%{_libdir}/httpd/modules
chmod 755 ${RPM_BUILD_ROOT}%{_libdir}/httpd/modules/libphp5.so
cd ..

# strip binaries
/usr/bin/strip ${RPM_BUILD_ROOT}%{_bindir}/php
/usr/bin/strip ${RPM_BUILD_ROOT}%{_bindir}/php-cgi
/usr/bin/strip ${RPM_BUILD_ROOT}%{_libdir}/httpd/modules/libphp5.so

# install the Apache httpd config file for PHP
mkdir -p ${RPM_BUILD_ROOT}%{_sysconfdir}/httpd/conf/extra
chmod 755 ${RPM_BUILD_ROOT}%{_sysconfdir}/httpd/conf/extra
cp %{SOURCE1} ${RPM_BUILD_ROOT}%{_sysconfdir}/httpd/conf/extra/httpd-php.conf
chmod 644 ${RPM_BUILD_ROOT}%{_sysconfdir}/httpd/conf/extra/httpd-php.conf

# install the default configuration file and icons
cp %{SOURCE2} ${RPM_BUILD_ROOT}%{_sysconfdir}/php.ini
mkdir -p ${RPM_BUILD_ROOT}%{contentdir}/icons
chmod 755 ${RPM_BUILD_ROOT}%{contentdir}/icons
cp php.gif ${RPM_BUILD_ROOT}%{contentdir}/icons

# for third-party packaging:
mkdir -p ${RPM_BUILD_ROOT}%{_libdir}/php/pear
chmod 755 ${RPM_BUILD_ROOT}%{_libdir}/php/pear
mkdir -p ${RPM_BUILD_ROOT}/var/lib/php
chmod 755 ${RPM_BUILD_ROOT}/var/lib/php
mkdir -p ${RPM_BUILD_ROOT}/var/lib/php/session
chmod 700 ${RPM_BUILD_ROOT}/var/lib/php/session

(
  cd ${RPM_BUILD_ROOT}
  for dir in bin include
  do
    mkdir -p usr/${dir}
  done
)


%preun
if [ "$1" = 0 ]; then
    cat %{_sysconfdir}/httpd/conf/httpd.conf | \
      grep -v "# PHP settings" | \
      grep -v "Include conf/extra/httpd-php.conf" \
      > %{_sysconfdir}/httpd/conf/tmp_httpd.conf
    mv -f %{_sysconfdir}/httpd/conf/tmp_httpd.conf %{_sysconfdir}/httpd/conf/httpd.conf
    echo "Please restart your web server using: 'service httpd restart'"
fi


%post
cat %{_sysconfdir}/httpd/conf/httpd.conf | \
  grep -v "# PHP settings" | \
  grep -v "Include conf/extra/httpd-php.conf" \
  > %{_sysconfdir}/httpd/conf/tmp_httpd.conf
mv -f %{_sysconfdir}/httpd/conf/tmp_httpd.conf %{_sysconfdir}/httpd/conf/httpd.conf
echo "# PHP settings" >> %{_sysconfdir}/httpd/conf/httpd.conf
echo "Include conf/extra/httpd-php.conf" >> %{_sysconfdir}/httpd/conf/httpd.conf
echo "Please restart your web server using: 'service httpd restart'"


%clean
[ "${RPM_BUILD_ROOT}" != "/" ] && rm -rf ${RPM_BUILD_ROOT}


%files
%defattr(-,root,root)
%{_libdir}/httpd/modules/libphp5.so
%attr(0770,root,apache) %dir /var/lib/php/session
%config(noreplace) %{_sysconfdir}/httpd/conf/extra/httpd-php.conf
%{contentdir}/icons/php.gif


%files common
%defattr(-,root,root)
%doc CODING_STANDARDS CREDITS EXTENSIONS INSTALL LICENSE NEWS README*
%doc Zend/ZEND_*
%config(noreplace) %{_sysconfdir}/php.ini
%dir /var/lib/php
%dir %{_libdir}/php
%dir %{_libdir}/php/pear


%files cli
%defattr(-,root,root)
%{_bindir}/php
%{_bindir}/php-cgi
%{_mandir}/man1/php.1.gz
/usr/bin/php
/usr/bin/php-cgi


%files devel
%defattr(-,root,root)
%dir %{_libdir}/php
%{_includedir}/php
%{_libdir}/build
%{_mandir}/man1/php-config.1.gz
%{_mandir}/man1/phpize.1.gz
/usr/bin/php-config
/usr/bin/phpize


%changelog
* Wed May 18 2011 Michael Perzl <michael@perzl.org> - 5.2.17-2
- fixed wrong dependency on bzip2-devel of php-devel (needs bzip2 only)

* Fri Jan 07 2011 Michael Perzl <michael@perzl.org> - 5.2.17-1
- updated to version 5.2.17

* Tue Dec 14 2010 Michael Perzl <michael@perzl.org> - 5.2.15-1
- updated to version 5.2.15

* Fri Jul 23 2010 Michael Perzl <michael@perzl.org> - 5.2.14-1
- updated to version 5.2.14

* Tue Mar 02 2010 Michael Perzl <michael@perzl.org> - 5.2.13-1
- updated to version 5.2.13

* Thu Feb 18 2010 Michael Perzl <michael@perzl.org> - 5.2.12-2
- enable fastcgi for the CLI version

* Tue Jan 19 2010 Michael Perzl <michael@perzl.org> - 5.2.12-1
- updated to version 5.2.12

* Fri Nov 27 2009 Michael Perzl <michael@perzl.org> - 5.2.11-1
- updated to version 5.2.11

* Thu Nov 26 2008 Michael Perzl <michael@perzl.org> - 5.2.8-1
- updated to version 5.2.8

* Fri May 02 2008 Michael Perzl <michael@perzl.org> - 5.2.6-1
- updated to version 5.2.6

* Wed Apr 23 2008 Michael Perzl <michael@perzl.org> - 5.2.5-2
- some minor spec file fixes

* Mon Dec 03 2007 Michael Perzl <michael@perzl.org> - 5.2.5-1
- first version for AIX V5.1 and higher
