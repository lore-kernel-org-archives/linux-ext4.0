From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] debian: Remove uuid packages
Date: Thu, 16 Jul 2009 19:59:05 +0100
Message-ID: <E1MRWBq-0000yy-0F@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

The uuid-related packages are now built by util-linux 2.16, so
e2fsprogs should not do so.

Signed-off-by: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 debian/control |   87 +-----------------------------------------------=
--------
 debian/rules   |   66 ++++++++----------------------------------
 2 files changed, 14 insertions(+), 139 deletions(-)

diff --git a/debian/control b/debian/control
index 51686a4..e0b679a 100644
--- a/debian/control
+++ b/debian/control
@@ -2,7 +2,7 @@ Source: e2fsprogs
 Section: admin
 Priority: required
 Maintainer: Theodore Y. Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
-Build-Depends: texi2html (>=3D 1.76), gettext, texinfo, dc, pkg-config=
, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel po=
werpc ppc64 s390 sparc], debhelper (>=3D 7.0), libblkid-dev (>=3D 2.16)
+Build-Depends: texi2html (>=3D 1.76), gettext, texinfo, dc, pkg-config=
, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel po=
werpc ppc64 s390 sparc], debhelper (>=3D 7.0), libblkid-dev (>=3D 2.16)=
, libuuid-dev (>=3D 2.16)
 Standards-Version: 3.8.2
 Homepage: http://e2fsprogs.sourceforge.net
=20
@@ -71,70 +71,6 @@ Description: command-line interface parsing library =
- headers and static librari
  .
  This package contains the development environment for the ss library.
=20
-Package: libuuid1
-Section: libs
-Depends: passwd, ${shlibs:Depends}
-Recommends: uuid-runtime
-Replaces: e2fsprogs (<< 1.34-1)
-Architecture: any
-Description: Universally Unique ID library
- The libuuid library generates and parses 128-bit universally unique
- id's (UUID's).  A UUID is an identifier that is unique across both
- space and time, with respect to the space of all UUIDs.  A UUID can
- be used for multiple purposes, from tagging objects with an extremely
- short lifetime, to reliably identifying very persistent objects
- across a network.
- .
- See RFC 4122 for more information. =20
-
-Package: uuid-runtime
-Section: libs
-Priority: optional
-Depends: passwd, libuuid1 (>> 1.40.3-1), ${shlibs:Depends}
-Replaces: e2fsprogs (<=3D 1.40.3-1ubuntu1)
-Architecture: any
-Description: runtime components for the Universally Unique ID library
- The libuuid library generates and parses 128-bit universally unique
- id's (UUID's).  A UUID is an identifier that is unique across both
- space and time, with respect to the space of all UUIDs.  A UUID can
- be used for multiple purposes, from tagging objects with an extremely
- short lifetime, to reliably identifying very persistent objects
- across a network.
- .
- See RFC 4122 for more information. =20
- .
- This package contains the uuidgen program and the uuidd daemon.
- .
- The uuidd daemon is used to generate UUIDs, especially time-based
- UUID=E2=80=99s, in a secure and guaranteed-unique fashion, even in th=
e face
- of large numbers of threads trying to grab UUID=E2=80=99s running on
- different CPU=E2=80=99s. It is used by libuuid as well as the uuidgen
- program.
-
-Package: libuuid1-udeb
-XC-Package-Type: udeb
-Section: debian-installer
-Priority: optional
-Depends: ${shlibs:Depends}
-Architecture: any
-Description: stripped down universally unique id library, for debian-i=
nstaller
- libuuid generates and parses 128-bit universally unique id's (UUID's)=
=2E
- See RFC 4122 for more information.
- .
- This is a minimal package for debian-installer.
-
-Package: uuid-dev
-Section: libdevel
-Priority: extra
-Depends: libc6-dev | libc-dev, libuuid1 (=3D ${mainBinary})
-Replaces: e2fslibs-dev (<< 1.15)
-Architecture: any
-Description: universally unique id library - headers and static librar=
ies
- libuuid generates and parses 128-bit universally unique id's (UUID's)=
=2E
- See RFC 4122 for more information.
- .
- This package contains the development environment for the uuid librar=
y.
-
 Package: e2fsprogs-udeb
 XC-Package-Type: udeb
 Section: debian-installer
@@ -206,17 +142,6 @@ Description: debugging information for e2fsprogs
  The debug information is used for execution tracing and core
  dump analysis.=20
=20
-Package: uuid-runtime-dbg
-Section: debug
-Priority: extra
-Depends: uuid-runtime (=3D ${binary:Version})
-Architecture: any
-Description: debugging information for uuid-runtime
- This package includes the debug information useful for debugging the
- uuid runtime programs, contained in the uuid-runtime package.
- The debugging information is used for execution tracing and core
- dump analysis.
-
 Package: e2fslibs-dbg
 Section: debug
 Priority: extra
@@ -246,13 +171,3 @@ Description: debugging information for libss2
  This package includes the debug information useful for debugging the
  ss library, contained in the libss2 package.  The debug information
  is used for execution tracing and core dump analysis.
-
-Package: libuuid1-dbg
-Section: debug
-Priority: extra
-Depends: libuuid1 (=3D ${binary:Version})
-Architecture: any
-Description: debugging information for libuuid1
- This package includes the debug information useful for debugging the
- UUID library, contained in the libuuid1 package.  The debug
- information is used for execution tracing and core dump analysis.
diff --git a/debian/rules b/debian/rules
index 71f1779..98e9808 100755
--- a/debian/rules
+++ b/debian/rules
@@ -26,8 +26,6 @@ COMERR_VERSION =3D $(shell grep ELF_VERSION lib/et/Ma=
kefile.in | cut '-d ' -f3)
 COMERR_SOVERSION =3D $(shell grep ELF_SO_VERSION lib/et/Makefile.in | =
cut '-d ' -f3)
 SS_VERSION =3D $(shell grep ELF_VERSION lib/ss/Makefile.in | cut '-d '=
 -f3)
 SS_SOVERSION =3D $(shell grep ELF_SO_VERSION lib/ss/Makefile.in | cut =
'-d ' -f3)
-UUID_VERSION =3D $(shell grep ELF_VERSION lib/uuid/Makefile.in | cut '=
-d ' -f3)
-UUID_SOVERSION =3D $(shell grep ELF_SO_VERSION lib/uuid/Makefile.in | =
cut '-d ' -f3)
 EXT2FS_SOVERSION =3D $(shell grep ELF_SO_VERSION lib/ext2fs/Makefile.i=
n | cut '-d ' -f3)
 E2P_SOVERSION =3D $(shell grep ELF_SO_VERSION lib/e2p/Makefile.in | cu=
t '-d ' -f3)
=20
@@ -37,18 +35,12 @@ topdir=3D$(shell pwd)
 debdir=3D${topdir}/debian
 tmpdir=3D${debdir}/tmp
 udebdir=3D${debdir}/e2fsprogs-udeb
-uuidudebdir=3D${debdir}/libuuid1-udeb
 libcomerrdir=3D${debdir}/libcomerr${COMERR_SOVERSION}
 comerrdevdir=3D${debdir}/comerr-dev
 libcomerrdbgdir=3D${debdir}/libcomerr2-dbg
 libssdir=3D${debdir}/libss${SS_SOVERSION}
 ssdevdir=3D${debdir}/ss-dev
 libssdbgdir=3D${debdir}/libss2-dbg
-libuuiddir=3D${debdir}/libuuid${UUID_SOVERSION}
-uuiddevdir=3D${debdir}/uuid-dev
-libuuiddbgdir=3D${debdir}/libuuid1-dbg
-uuidruntimedir=3D${debdir}/uuid-runtime
-uuidruntimedbgdir=3D${debdir}/uuid-runtime-dbg
 libext2dir=3D${debdir}/e2fslibs
 libext2devdir=3D${debdir}/e2fslibs-dev
 libext2dbgdir=3D${debdir}/e2fslibs-dbg
@@ -67,9 +59,6 @@ mandir=3D${tmpdir}${MANDIR}
 UDEB_NAME =3D $(package)-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
 UDEB_PRIORITY =3D $(shell grep '^Package: e2fsprogs-udeb' debian/contr=
ol -A 10 | grep ^Priority: | cut -d ' ' -f 2)
=20
-UUID_UDEB_NAME =3D libuuid1-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
-UUID_UDEB_PRIORITY =3D $(shell grep '^Package: libuuid1-udeb' debian/c=
ontrol -A 10 | grep ^Priority: | cut -d ' ' -f 2)
-
 STAMPSDIR=3Ddebian/stampdir
 CFGSTDSTAMP=3D${STAMPSDIR}/configure-std-stamp
 CFGBFSTAMP=3D${STAMPSDIR}/configure-bf-stamp
@@ -112,18 +101,18 @@ STD_CONF_FLAGS =3D --with-ccopts=3D"${CCOPTS}" --=
enable-compression
=20
 BF_CONF_FLAGS =3D --with-ccopts=3D"${CCOPTS} ${BF_CCOPTS}" \
 	--disable-nls --disable-imager --disable-testio-debug \
-	--disable-uuidd --disable-tls \
+	--disable-tls \
 	--disable-debugfs  --disable-e2initrd-helper
=20
 STATIC_CONF_FLAGS =3D --with-ccopts=3D"${CCOPTS}" \
 	--disable-nls --disable-imager \
-	--disable-uuidd --disable-tls \
+	--disable-tls \
 	--disable-e2initrd-helper \
 	--with-ccopts=3D-fno-stack-protector
=20
 MIPS_NOPIC_CONF_FLAGS =3D --with-ccopts=3D"${CCOPTS}" \
 	--disable-nls --disable-imager \
-	--disable-uuidd --disable-tls \
+	--disable-tls \
         --disable-resizer # --disable-debugfs
=20
 # we can't use those flags at configure time
@@ -316,9 +305,6 @@ install-udeb: build
 		ln -s e2fsck fsck.ext3 ; ln -s mke2fs mkfs.ext2 ; \
 		ln -s mke2fs mkfs.ext3 ; ln -s mke2fs mkfs.ext4)
=20
-	mkdir -p ${uuidudebdir}/lib
-	mv ${udebdir}/lib/libuuid.* ${uuidudebdir}/lib
-
 binary-indep:=20
   # no arch-independant debs.
=20
@@ -354,15 +340,11 @@ binary-arch: install install-udeb
 	mkdir -p ${debdir}/comerr-dev/usr/share/doc
 	ln -sf libcomerr${COMERR_SOVERSION} ${debdir}/comerr-dev/usr/share/do=
c/comerr-dev
=20
-	mkdir -p ${debdir}/libuuid${UUID_SOVERSION}/usr/share/doc/libuuid${UU=
ID_SOVERSION}
-	mkdir -p ${debdir}/uuid-dev/usr/share/doc
-#	ln -sf libuuid${UUID_SOVERSION} ${debdir}/uuid-dev/usr/share/doc/uui=
d-dev
-
 	mkdir -p ${debdir}/e2fslibs/usr/share/doc/e2fslibs
 	mkdir -p ${debdir}/e2fslibs-dev/usr/share/doc
 	ln -sf e2fslibs ${debdir}/e2fslibs-dev/usr/share/doc/e2fslibs-dev
=20
-	dh_installdocs -Ne2fsprogs-udeb -Nlibuuid1-udeb
+	dh_installdocs -Ne2fsprogs-udeb
=20
   # HTML docs
 	$(INSTALL) -d ${debdir}/e2fslibs-dev/usr/share/doc/e2fslibs/html-info=
/
@@ -392,10 +374,10 @@ binary-arch: install install-udeb
=20
 	DH_OPTIONS=3D dh_installchangelogs -pe2fsprogs \
 		-plibcomerr${COMERR_SOVERSION} \
-		-plibss${SS_SOVERSION} -plibuuid${UUID_SOVERSION} \
-		-pe2fslibs -puuid-dev -puuid-runtime -pe2fsck-static \
-		-pe2fsprogs-dbg -puuid-runtime-dbg -pe2fslibs-dbg \
-		-plibcomerr2-dbg -plibss2-dbg -plibuuid1-dbg
+		-plibss${SS_SOVERSION} \
+		-pe2fslibs -pe2fsck-static \
+		-pe2fsprogs-dbg -pe2fslibs-dbg \
+		-plibcomerr2-dbg -plibss2-dbg
=20
 	dh_fixperms
 ifneq ($(ismips),)
@@ -406,7 +388,6 @@ endif
=20
 	# debug package stuff
 	rm -rf ${udebdir}/usr
-	rm -rf ${uuidudebdir}/usr
=20
 	mkdir -p ${debugdir}/usr/lib
 	mv ${maindir}/usr/lib/debug ${debugdir}/usr/lib
@@ -415,10 +396,6 @@ endif
 		${debugdir}/usr/lib/debug
 	rm -rf ${e2fsckstaticdir}/usr/lib
=20
-	mkdir -p ${uuidruntimedbgdir}/usr/lib
-	mv ${uuidruntimedir}/usr/lib/debug ${uuidruntimedbgdir}/usr/lib
-	rmdir ${uuidruntimedir}/usr/lib
-
 	mkdir -p ${libext2dbgdir}/usr/lib
 	mv ${libext2dir}/usr/lib/debug ${libext2dbgdir}/usr/lib
 	rmdir ${libext2dir}/usr/lib
@@ -431,13 +408,9 @@ endif
 	mv ${libssdir}/usr/lib/debug ${libssdbgdir}/usr/lib
 	rmdir ${libssdir}/usr/lib
=20
-	mkdir -p ${libuuiddbgdir}/usr/lib
-	mv ${libuuiddir}/usr/lib/debug ${libuuiddbgdir}/usr/lib
-	rmdir ${libuuiddir}/usr/lib
-
 	# dpkg symbol handling
 ifneq (,$(findstring update-symbols,$(DEB_BUILD_OPTIONS)))
-	for i in e2fslibs libcomerr2 libss2 libuuid1; \
+	for i in e2fslibs libcomerr2 libss2; \
 	do \
 		echo "Generating symbols for $$i..."; \
 		dpkg-gensymbols -p$$i -Pdebian/$$i > debian/$$i.tmp-patch; \
@@ -450,9 +423,6 @@ endif
 	$(INSTALL) -p -m 0644 debian/e2fsprogs.copyright \
 		${debugdir}/usr/share/doc/e2fsprogs-dbg/copyright
=20
-	$(INSTALL) -p -m 0644 debian/uuid-runtime.copyright \
-		${uuidruntimedbgdir}/usr/share/doc/uuid-runtime-dbg/copyright
-
 	$(INSTALL) -p -m 0644 debian/e2fslibs.copyright \
 		${libext2dbgdir}/usr/share/doc/e2fslibs-dbg/copyright
=20
@@ -462,15 +432,11 @@ endif
 	$(INSTALL) -p -m 0644 debian/libss2.copyright \
 		${libssdbgdir}/usr/share/doc/libss2-dbg/copyright
=20
-	$(INSTALL) -p -m 0644 debian/libuuid1.copyright \
-		${libuuiddbgdir}/usr/share/doc/libuuid1-dbg/copyright
-
 	dh_compress
=20
-	dh_makeshlibs -Ne2fsprogs-udeb -Nlibuuid1-udeb
+	dh_makeshlibs -Ne2fsprogs-udeb
 	dh_makeshlibs -plibcomerr${COMERR_SOVERSION} \
 		-V 'libcomerr2 (>=3D 1.33-3)'
-	echo "udeb: libuuid 1 libuuid1-udeb" >> debian/libuuid1/DEBIAN/shlibs
=20
 	dh_installdeb
 	dh_shlibdeps -l${stdbuilddir}/lib
@@ -479,23 +445,17 @@ endif
 	dh_shlibdeps -pe2fsprogs-udeb -l${stdbuilddir}/lib \
 		-u"-Ldebian/e2fsprogs-udeb.shlibs.local"
=20
-	dh_gencontrol -Ncomerr-dev -Nss-dev -Nuuid-dev \
-		-Ne2fsprogs-udeb -Nlibuuid1-udeb
+	dh_gencontrol -Ncomerr-dev -Nss-dev -Ne2fsprogs-udeb
 	DH_OPTIONS=3D dh_gencontrol -pcomerr-dev \
 	  -u '-v${COMERR_VERSION}-${MAIN_VERSION} -VmainBinary=3D${MAIN_VERSI=
ON}'
 	DH_OPTIONS=3D dh_gencontrol -pss-dev \
 	  -u '-v${SS_VERSION}-${MAIN_VERSION} -VmainBinary=3D${MAIN_VERSION}'
-	DH_OPTIONS=3D dh_gencontrol -puuid-dev \
-	  -u '-v${UUID_VERSION}-${MAIN_VERSION} -VmainBinary=3D${MAIN_VERSION=
}'
 	dh_gencontrol	-pe2fsprogs-udeb -- -fdebian/files~
-	dh_gencontrol	-plibuuid1-udeb -- -fdebian/files~
=20
 	dpkg-distaddfile $(UDEB_NAME) debian-installer $(UDEB_PRIORITY)
-	dpkg-distaddfile $(UUID_UDEB_NAME) debian-installer $(UUID_UDEB_PRIOR=
ITY)
-	dh_md5sums -Ne2fsprogs-udeb -Nlibuuid1-udeb
-	dh_builddeb -Ne2fsprogs-udeb -Nlibuuid1-udeb
+	dh_md5sums -Ne2fsprogs-udeb
+	dh_builddeb -Ne2fsprogs-udeb
 	dh_builddeb -pe2fsprogs-udeb --filename=3D$(UDEB_NAME)
-	dh_builddeb -plibuuid1-udeb --filename=3D$(UUID_UDEB_NAME)
=20
 binary: binary-indep binary-arch
=20
--=20
1.6.0.5

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng=
" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
