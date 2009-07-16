From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] debian: Remove blkid packages
Date: Thu, 16 Jul 2009 19:56:47 +0100
Message-ID: <E1MRWBp-0000yr-Sq@zelda.netsplit.com>
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

The blkid-related packages are now built by util-linux 2.16, so
e2fsprogs should not do so.

Signed-off-by: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 debian/control |   52 +---------------------------------------------------
 debian/rules   |   51 +++++++++------------------------------------------
 2 files changed, 10 insertions(+), 93 deletions(-)

diff --git a/debian/control b/debian/control
index 4199754..51686a4 100644
--- a/debian/control
+++ b/debian/control
@@ -2,7 +2,7 @@ Source: e2fsprogs
 Section: admin
 Priority: required
 Maintainer: Theodore Y. Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
-Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powerpc ppc64 s390 sparc], debhelper (>= 7.0)
+Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powerpc ppc64 s390 sparc], debhelper (>= 7.0), libblkid-dev (>= 2.16)
 Standards-Version: 3.8.2
 Homepage: http://e2fsprogs.sourceforge.net
 
@@ -135,46 +135,6 @@ Description: universally unique id library - headers and static libraries
  .
  This package contains the development environment for the uuid library.
 
-Package: libblkid1
-Section: libs
-Depends: ${shlibs:Depends}
-Architecture: any
-Description: block device id library
- The blkid library which allows system programs like fsck and 
- mount to quickly and easily find block devices by filesystem UUID and 
- LABEL.  This allows system administrators to avoid specifying 
- filesystems by hard-coded device names, but via a logical naming 
- system instead.
-
-Package: libblkid1-udeb
-XC-Package-Type: udeb
-Section: debian-installer
-Priority: optional
-Depends: ${shlibs:Depends}
-Architecture: any
-Description: stripped down block device id library, for debian-installer
- The blkid library which allows system programs like fsck and 
- mount to quickly and easily find block devices by filesystem UUID and 
- LABEL.  This allows system administrators to avoid specifiying 
- filesystems by hard-coded device names, but via a logical naming 
- system instead.
- .
- This is a minimal package for debian-installer.
-
-Package: libblkid-dev
-Section: libdevel
-Priority: extra
-Depends: libc6-dev | libc-dev, libblkid1 (= ${binary:Version})
-Architecture: any
-Description: block device id library - headers and static libraries
- The blkid library which allows system programs like fsck and 
- mount to quickly and easily find block devices by filesystem UUID and 
- LABEL.  This allows system administrators to avoid specifiying 
- filesystems by hard-coded device names, but via a logical naming 
- system instead.
- .
- This package contains the development environment for the blkid library.
-
 Package: e2fsprogs-udeb
 XC-Package-Type: udeb
 Section: debian-installer
@@ -287,16 +247,6 @@ Description: debugging information for libss2
  ss library, contained in the libss2 package.  The debug information
  is used for execution tracing and core dump analysis.
 
-Package: libblkid1-dbg
-Section: debug
-Priority: extra
-Depends: libblkid1 (= ${binary:Version})
-Architecture: any
-Description: debugging information for libblkid1
- This package includes the debug information useful for debugging the
- blkid library, contained in the libblkid1 package.  The debug
- information is used for execution tracing and core dump analysis.
-
 Package: libuuid1-dbg
 Section: debug
 Priority: extra
diff --git a/debian/rules b/debian/rules
index f71749e..71f1779 100755
--- a/debian/rules
+++ b/debian/rules
@@ -28,8 +28,6 @@ SS_VERSION = $(shell grep ELF_VERSION lib/ss/Makefile.in | cut '-d ' -f3)
 SS_SOVERSION = $(shell grep ELF_SO_VERSION lib/ss/Makefile.in | cut '-d ' -f3)
 UUID_VERSION = $(shell grep ELF_VERSION lib/uuid/Makefile.in | cut '-d ' -f3)
 UUID_SOVERSION = $(shell grep ELF_SO_VERSION lib/uuid/Makefile.in | cut '-d ' -f3)
-BLKID_VERSION = $(shell grep ELF_VERSION lib/blkid/Makefile.in | cut '-d ' -f3)
-BLKID_SOVERSION = $(shell grep ELF_SO_VERSION lib/blkid/Makefile.in | cut '-d ' -f3)
 EXT2FS_SOVERSION = $(shell grep ELF_SO_VERSION lib/ext2fs/Makefile.in | cut '-d ' -f3)
 E2P_SOVERSION = $(shell grep ELF_SO_VERSION lib/e2p/Makefile.in | cut '-d ' -f3)
 
@@ -39,7 +37,6 @@ topdir=$(shell pwd)
 debdir=${topdir}/debian
 tmpdir=${debdir}/tmp
 udebdir=${debdir}/e2fsprogs-udeb
-blkidudebdir=${debdir}/libblkid1-udeb
 uuidudebdir=${debdir}/libuuid1-udeb
 libcomerrdir=${debdir}/libcomerr${COMERR_SOVERSION}
 comerrdevdir=${debdir}/comerr-dev
@@ -47,9 +44,6 @@ libcomerrdbgdir=${debdir}/libcomerr2-dbg
 libssdir=${debdir}/libss${SS_SOVERSION}
 ssdevdir=${debdir}/ss-dev
 libssdbgdir=${debdir}/libss2-dbg
-libblkiddir=${debdir}/libblkid${BLKID_SOVERSION}
-libblkiddevdir=${debdir}/libblkid-dev
-libblkiddbgdir=${debdir}/libblkid1-dbg
 libuuiddir=${debdir}/libuuid${UUID_SOVERSION}
 uuiddevdir=${debdir}/uuid-dev
 libuuiddbgdir=${debdir}/libuuid1-dbg
@@ -73,9 +67,6 @@ mandir=${tmpdir}${MANDIR}
 UDEB_NAME = $(package)-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
 UDEB_PRIORITY = $(shell grep '^Package: e2fsprogs-udeb' debian/control -A 10 | grep ^Priority: | cut -d ' ' -f 2)
 
-BLKID_UDEB_NAME = libblkid1-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
-BLKID_UDEB_PRIORITY = $(shell grep '^Package: libblkid1-udeb' debian/control -A 10 | grep ^Priority: | cut -d ' ' -f 2)
-
 UUID_UDEB_NAME = libuuid1-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
 UUID_UDEB_PRIORITY = $(shell grep '^Package: libuuid1-udeb' debian/control -A 10 | grep ^Priority: | cut -d ' ' -f 2)
 
@@ -115,7 +106,7 @@ endif
 BF_CCOPTS = -Os -fomit-frame-pointer
 
 COMMON_CONF_FLAGS =  \
-                --enable-elf-shlibs --infodir=/usr/share/info --enable-fsck
+                --enable-elf-shlibs --infodir=/usr/share/info
 
 STD_CONF_FLAGS = --with-ccopts="${CCOPTS}" --enable-compression
 
@@ -325,9 +316,6 @@ install-udeb: build
 		ln -s e2fsck fsck.ext3 ; ln -s mke2fs mkfs.ext2 ; \
 		ln -s mke2fs mkfs.ext3 ; ln -s mke2fs mkfs.ext4)
 
-	mkdir -p ${blkidudebdir}/lib
-	mv ${udebdir}/lib/libblkid.* ${blkidudebdir}/lib
-
 	mkdir -p ${uuidudebdir}/lib
 	mv ${udebdir}/lib/libuuid.* ${uuidudebdir}/lib
 
@@ -358,10 +346,6 @@ binary-arch: install install-udeb
 
   # symlinks to prepare dh_installdocs run
 
-	mkdir -p ${debdir}/libblkid${BLKID_SOVERSION}/usr/share/doc/libblkid${BLKID_SOVERSION}
-	mkdir -p ${debdir}/libblkid-dev/usr/share/doc
-	ln -sf libblkid${BLKID_SOVERSION} ${debdir}/libblkid-dev/usr/share/doc/libblkid-dev
-
 	mkdir -p ${debdir}/libss${SS_SOVERSION}/usr/share/doc/libss${SS_SOVERSION}
 	mkdir -p ${debdir}/ss-dev/usr/share/doc
 	ln -sf libss${SS_SOVERSION} ${debdir}/ss-dev/usr/share/doc/ss-dev
@@ -378,10 +362,7 @@ binary-arch: install install-udeb
 	mkdir -p ${debdir}/e2fslibs-dev/usr/share/doc
 	ln -sf e2fslibs ${debdir}/e2fslibs-dev/usr/share/doc/e2fslibs-dev
 
-	$(INSTALL) -p -m 0644 debian/libblkid.copyright \
-		${debdir}/libblkid${BLKID_SOVERSION}/usr/share/doc/libblkid${BLKID_SOVERSION}/copyright
-
-	dh_installdocs -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
+	dh_installdocs -Ne2fsprogs-udeb -Nlibuuid1-udeb
 
   # HTML docs
 	$(INSTALL) -d ${debdir}/e2fslibs-dev/usr/share/doc/e2fslibs/html-info/
@@ -410,11 +391,11 @@ binary-arch: install install-udeb
 	dh_installinfo -pe2fslibs-dev ${stdbuilddir}/doc/libext2fs.info
 
 	DH_OPTIONS= dh_installchangelogs -pe2fsprogs \
-		-plibblkid${BLKID_SOVERSION} -plibcomerr${COMERR_SOVERSION} \
+		-plibcomerr${COMERR_SOVERSION} \
 		-plibss${SS_SOVERSION} -plibuuid${UUID_SOVERSION} \
 		-pe2fslibs -puuid-dev -puuid-runtime -pe2fsck-static \
 		-pe2fsprogs-dbg -puuid-runtime-dbg -pe2fslibs-dbg \
-		-plibcomerr2-dbg -plibss2-dbg -plibblkid1-dbg -plibuuid1-dbg
+		-plibcomerr2-dbg -plibss2-dbg -plibuuid1-dbg
 
 	dh_fixperms
 ifneq ($(ismips),)
@@ -425,7 +406,6 @@ endif
 
 	# debug package stuff
 	rm -rf ${udebdir}/usr
-	rm -rf ${blkidudebdir}/usr
 	rm -rf ${uuidudebdir}/usr
 
 	mkdir -p ${debugdir}/usr/lib
@@ -455,13 +435,9 @@ endif
 	mv ${libuuiddir}/usr/lib/debug ${libuuiddbgdir}/usr/lib
 	rmdir ${libuuiddir}/usr/lib
 
-	mkdir -p ${libblkiddbgdir}/usr/lib
-	mv ${libblkiddir}/usr/lib/debug ${libblkiddbgdir}/usr/lib
-	rmdir ${libblkiddir}/usr/lib
-
 	# dpkg symbol handling
 ifneq (,$(findstring update-symbols,$(DEB_BUILD_OPTIONS)))
-	for i in e2fslibs libcomerr2 libss2 libblkid1 libuuid1; \
+	for i in e2fslibs libcomerr2 libss2 libuuid1; \
 	do \
 		echo "Generating symbols for $$i..."; \
 		dpkg-gensymbols -p$$i -Pdebian/$$i > debian/$$i.tmp-patch; \
@@ -486,20 +462,14 @@ endif
 	$(INSTALL) -p -m 0644 debian/libss2.copyright \
 		${libssdbgdir}/usr/share/doc/libss2-dbg/copyright
 
-	$(INSTALL) -p -m 0644 debian/libblkid.copyright \
-		${libblkiddbgdir}/usr/share/doc/libblkid1-dbg/copyright
-
 	$(INSTALL) -p -m 0644 debian/libuuid1.copyright \
 		${libuuiddbgdir}/usr/share/doc/libuuid1-dbg/copyright
 
 	dh_compress
 
-	dh_makeshlibs -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
+	dh_makeshlibs -Ne2fsprogs-udeb -Nlibuuid1-udeb
 	dh_makeshlibs -plibcomerr${COMERR_SOVERSION} \
 		-V 'libcomerr2 (>= 1.33-3)'
-	dh_makeshlibs -plibblkid${BLKID_SOVERSION} -V 'libblkid1 (>= 1.39-1)'
-	echo "udeb: libblkid 1 libblkid1-udeb" >> \
-		debian/libblkid1/DEBIAN/shlibs
 	echo "udeb: libuuid 1 libuuid1-udeb" >> debian/libuuid1/DEBIAN/shlibs
 
 	dh_installdeb
@@ -510,7 +480,7 @@ endif
 		-u"-Ldebian/e2fsprogs-udeb.shlibs.local"
 
 	dh_gencontrol -Ncomerr-dev -Nss-dev -Nuuid-dev \
-		-Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
+		-Ne2fsprogs-udeb -Nlibuuid1-udeb
 	DH_OPTIONS= dh_gencontrol -pcomerr-dev \
 	  -u '-v${COMERR_VERSION}-${MAIN_VERSION} -VmainBinary=${MAIN_VERSION}'
 	DH_OPTIONS= dh_gencontrol -pss-dev \
@@ -518,16 +488,13 @@ endif
 	DH_OPTIONS= dh_gencontrol -puuid-dev \
 	  -u '-v${UUID_VERSION}-${MAIN_VERSION} -VmainBinary=${MAIN_VERSION}'
 	dh_gencontrol	-pe2fsprogs-udeb -- -fdebian/files~
-	dh_gencontrol	-plibblkid1-udeb -- -fdebian/files~
 	dh_gencontrol	-plibuuid1-udeb -- -fdebian/files~
 
 	dpkg-distaddfile $(UDEB_NAME) debian-installer $(UDEB_PRIORITY)
-	dpkg-distaddfile $(BLKID_UDEB_NAME) debian-installer $(BLKID_UDEB_PRIORITY)
 	dpkg-distaddfile $(UUID_UDEB_NAME) debian-installer $(UUID_UDEB_PRIORITY)
-	dh_md5sums -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
-	dh_builddeb -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
+	dh_md5sums -Ne2fsprogs-udeb -Nlibuuid1-udeb
+	dh_builddeb -Ne2fsprogs-udeb -Nlibuuid1-udeb
 	dh_builddeb -pe2fsprogs-udeb --filename=$(UDEB_NAME)
-	dh_builddeb -plibblkid1-udeb --filename=$(BLKID_UDEB_NAME)
 	dh_builddeb -plibuuid1-udeb --filename=$(UUID_UDEB_NAME)
 
 binary: binary-indep binary-arch
-- 
1.6.0.5

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
