From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Sun, 19 Jul 2009 07:56:17 -0400
Message-ID: <20090719115617.GF2416@mit.edu>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com> <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest> <20090717150207.GA29705@mit.edu> <1247843694.4524.13.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1247843694.4524.13.camel@quest>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 17, 2009 at 04:14:54PM +0100, Scott James Remnant wrote:
> > So the patch ideal patch I'd like to see is one where you can toggle a
> > flag and debian/rules will either build for util-linux or
> > util-linux-ng.  If you've sent such a patch, my apologies for
> > overlooking it
> > 
> I did, it's the patches that are applied to the Ubuntu source package:

I've attached the cleaned up version which I've just checked into
e2fsprogs below.  I've created a single switch, UTIL_LINUX_NG=yes,
since the DISABLE_BLKID and DISABLE_UUID switches were never
orthogonal (the combination !DISABLE_BLKID and DISABLE_UUID wouldn't
do the right thing), and DISABLE_BLKID also disabled fsck as a
surprising side-effect.

I also changed the generation of debian/control from being automatic
to being something which must be manually done by the maintainer;
that's because dpkg-buildpackage, and in particular, dpkg-source,
looks at the debian/control file before debian/rules has a chance to
create it.

> > > I've done the packaging for him, it's just waiting on him to get back
> > > home to sponsor the uploads.
> > 
> > Are the .deb packages somewhere where I can examine them?
> > 
> Yes, they're in Ubuntu.

I just took a quick look at them, and it appears that they are missing
the libblkid1-dbg, libuuid1-dbg, and uuid-runtime-dbg packages.

Also, apparently no once noticed until now, but there's a bug in the
util-linux-ng's uuid.sym file.  The uuid_pack and uuid_unpack symbols
are missing, because someone forgot to include them in the uuid.sym
file.  The debian symbol generation system which I see you carefully
moved over detected the problem, but you apparently didn't take a
close enough look at its output to detect the warning messages.

BTW, **why** is util-linux-ng gratuitously introducing backwards
incompatibility such that packages built with util-linux-ng won't work
with the older shared libraries?   There's no reason to do this.

There is a hint in the (obsolete) comments in uuid.sym that suggests a
reason why, but it's not justified for libuuid:

/*
 * The symbol versioning ensures that a new application requiring symbol foo()
 * can't run with old libblkid.so not providing foo() - the global SONAME
 * version info can't enforce this since we never change the SONAME.
 *
 * The original libuuid from e2fsprogs (<=1.41.5) does not to use
 * symbol versioning -- all the original symbols are in UUID_1.0 now.
 */

Argh, util-linux-ng 2.16 has already been released; is it too late to
undo this change?

						- Ted

commit 95f65c3d70a7a883c3c98d7f53feed970dc64271
Author: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Date:   Sat Jul 18 22:14:58 2009 -0400

    debian: Allow building with util-linux-ng
    
    If building with util-linux-ng, we will use the external libblkid and
    libuuid, as well as disabling the internal fsck.
    
    Signed-off-by: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>

diff --git a/debian/control b/debian/control.in
similarity index 95%
rename from debian/control
rename to debian/control.in
index f930ddd..f0f364f 100644
--- a/debian/control
+++ b/debian/control.in
@@ -2,7 +2,11 @@ Source: e2fsprogs
 Section: admin
 Priority: required
 Maintainer: Theodore Y. Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
-Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 powerpc ppc64 s390 sparc], debhelper (>= 7.0)
+ifdef(`UTIL_LINUX_NG',
+``Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 powerpc ppc64 s390 sparc], debhelper (>= 7.0), m4, libblkid-dev (>= 2.16), uuid-dev (>= 2.16)
+'',
+``Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 powerpc ppc64 s390 sparc], debhelper (>= 7.0), m4
+'')dnl
 Standards-Version: 3.8.2
 Homepage: http://e2fsprogs.sourceforge.net
 
@@ -70,7 +74,7 @@ Description: command-line interface parsing library - headers and static librari
  It was originally inspired by the Multics SubSystem library.
  .
  This package contains the development environment for the ss library.
-
+ifdef(`UTIL_LINUX_NG',,``
 Package: libuuid1
 Section: libs
 Depends: passwd, ${shlibs:Depends}
@@ -174,6 +178,7 @@ Description: block device id library - headers and static libraries
  system instead.
  .
  This package contains the development environment for the blkid library.
+'')dnl
 
 Package: e2fsprogs-udeb
 XC-Package-Type: udeb
@@ -245,7 +250,7 @@ Description: debugging information for e2fsprogs
  and its libraries, contained in the e2fsprogs and e2fsck-static packages.
  The debug information is used for execution tracing and core
  dump analysis. 
-
+ifdef(`UTIL_LINUX_NG',,``
 Package: uuid-runtime-dbg
 Section: debug
 Priority: extra
@@ -256,6 +261,7 @@ Description: debugging information for uuid-runtime
  uuid runtime programs, contained in the uuid-runtime package.
  The debugging information is used for execution tracing and core
  dump analysis.
+'')dnl
 
 Package: e2fslibs-dbg
 Section: debug
@@ -286,7 +292,7 @@ Description: debugging information for libss2
  This package includes the debug information useful for debugging the
  ss library, contained in the libss2 package.  The debug information
  is used for execution tracing and core dump analysis.
-
+ifdef(`UTIL_LINUX_NG',,``
 Package: libblkid1-dbg
 Section: debug
 Priority: extra
@@ -306,3 +312,4 @@ Description: debugging information for libuuid1
  This package includes the debug information useful for debugging the
  UUID library, contained in the libuuid1 package.  The debug
  information is used for execution tracing and core dump analysis.
+'')dnl
diff --git a/debian/rules b/debian/rules
index 9520b02..1ba79ff 100755
--- a/debian/rules
+++ b/debian/rules
@@ -10,6 +10,13 @@
 # be paranoid
 export LC_ALL=C
 
+# Allow distro-specific behaviour
+DISTRO :=$(shell sed -ne '/DISTRIB_ID/s/.*=//p' /etc/lsb-release || echo Debian)
+SYS_BLKID_VER :=$(shell dpkg-query -W -f '${version}\n' libblkid1 | cut -b 1)
+ifeq ($(SYS_BLKID_VER),2)
+UTIL_LINUX_NG ?= yes
+endif
+
 # These are used for cross-compiling and for saving the configure script
 # from having to guess our platform (since we know it already)
 DEB_HOST_ARCH   ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
@@ -26,10 +33,15 @@ COMERR_VERSION = $(shell grep ELF_VERSION lib/et/Makefile.in | cut '-d ' -f3)
 COMERR_SOVERSION = $(shell grep ELF_SO_VERSION lib/et/Makefile.in | cut '-d ' -f3)
 SS_VERSION = $(shell grep ELF_VERSION lib/ss/Makefile.in | cut '-d ' -f3)
 SS_SOVERSION = $(shell grep ELF_SO_VERSION lib/ss/Makefile.in | cut '-d ' -f3)
+
+ifneq ($(UTIL_LINUX_NG),yes)
 UUID_VERSION = $(shell grep ELF_VERSION lib/uuid/Makefile.in | cut '-d ' -f3)
 UUID_SOVERSION = $(shell grep ELF_SO_VERSION lib/uuid/Makefile.in | cut '-d ' -f3)
+
 BLKID_VERSION = $(shell grep ELF_VERSION lib/blkid/Makefile.in | cut '-d ' -f3)
 BLKID_SOVERSION = $(shell grep ELF_SO_VERSION lib/blkid/Makefile.in | cut '-d ' -f3)
+endif
+
 EXT2FS_SOVERSION = $(shell grep ELF_SO_VERSION lib/ext2fs/Makefile.in | cut '-d ' -f3)
 E2P_SOVERSION = $(shell grep ELF_SO_VERSION lib/e2p/Makefile.in | cut '-d ' -f3)
 
@@ -39,14 +51,17 @@ topdir=$(shell pwd)
 debdir=${topdir}/debian
 tmpdir=${debdir}/tmp
 udebdir=${debdir}/e2fsprogs-udeb
+ifneq ($(UTIL_LINUX_NG),yes)
 blkidudebdir=${debdir}/libblkid1-udeb
 uuidudebdir=${debdir}/libuuid1-udeb
+endif
 libcomerrdir=${debdir}/libcomerr${COMERR_SOVERSION}
 comerrdevdir=${debdir}/comerr-dev
 libcomerrdbgdir=${debdir}/libcomerr2-dbg
 libssdir=${debdir}/libss${SS_SOVERSION}
 ssdevdir=${debdir}/ss-dev
 libssdbgdir=${debdir}/libss2-dbg
+ifneq ($(UTIL_LINUX_NG),yes)
 libblkiddir=${debdir}/libblkid${BLKID_SOVERSION}
 libblkiddevdir=${debdir}/libblkid-dev
 libblkiddbgdir=${debdir}/libblkid1-dbg
@@ -55,6 +70,7 @@ uuiddevdir=${debdir}/uuid-dev
 libuuiddbgdir=${debdir}/libuuid1-dbg
 uuidruntimedir=${debdir}/uuid-runtime
 uuidruntimedbgdir=${debdir}/uuid-runtime-dbg
+endif
 libext2dir=${debdir}/e2fslibs
 libext2devdir=${debdir}/e2fslibs-dev
 libext2dbgdir=${debdir}/e2fslibs-dbg
@@ -71,13 +87,15 @@ MANDIR=/usr/share/man
 mandir=${tmpdir}${MANDIR}
 
 UDEB_NAME = $(package)-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
-UDEB_PRIORITY = $(shell grep '^Package: e2fsprogs-udeb' debian/control -A 10 | grep ^Priority: | cut -d ' ' -f 2)
+UDEB_PRIORITY = $(shell grep '^Package: e2fsprogs-udeb' debian/control.in -A 10 | grep ^Priority: | cut -d ' ' -f 2)
 
+ifneq ($(UTIL_LINUX_NG),yes)
 BLKID_UDEB_NAME = libblkid1-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
-BLKID_UDEB_PRIORITY = $(shell grep '^Package: libblkid1-udeb' debian/control -A 10 | grep ^Priority: | cut -d ' ' -f 2)
+BLKID_UDEB_PRIORITY = $(shell grep '^Package: libblkid1-udeb' debian/control.in -A 10 | grep ^Priority: | cut -d ' ' -f 2)
 
 UUID_UDEB_NAME = libuuid1-udeb_$(MAIN_VERSION)_$(DEB_HOST_ARCH).udeb
-UUID_UDEB_PRIORITY = $(shell grep '^Package: libuuid1-udeb' debian/control -A 10 | grep ^Priority: | cut -d ' ' -f 2)
+UUID_UDEB_PRIORITY = $(shell grep '^Package: libuuid1-udeb' debian/control.in -A 10 | grep ^Priority: | cut -d ' ' -f 2)
+endif
 
 STAMPSDIR=debian/stampdir
 CFGSTDSTAMP=${STAMPSDIR}/configure-std-stamp
@@ -115,7 +133,13 @@ endif
 BF_CCOPTS = -Os -fomit-frame-pointer
 
 COMMON_CONF_FLAGS =  \
-                --enable-elf-shlibs --infodir=/usr/share/info --enable-fsck
+                --enable-elf-shlibs --infodir=/usr/share/info
+ifeq ($(UTIL_LINUX_NG),yes)
+COMMON_CONF_FLAGS += --disable-fsck --disable-libblkid \
+			--disable-libuuid --disable-uuidd
+else
+COMMON_CONF_FLAGS += --enable-fsck
+endif
 
 STD_CONF_FLAGS = --with-ccopts="${CCOPTS}" --enable-compression
 
@@ -145,6 +169,16 @@ ismips=ismips
 endif
 endif
 
+M4_ARGS=
+ifeq ($(UTIL_LINUX_NG),yes)
+M4_ARGS+=-DUTIL_LINUX_NG
+else
+M4_ARGS+=-UUTIL_LINUX_NG
+endif
+
+debian/control: debian/control.in debian/rules
+	m4 $(M4_ARGS) < debian/control.in > $@
+
 ${CFGSTDSTAMP}:
 	dh_testdir
 
@@ -325,11 +359,13 @@ install-udeb: build
 		ln -s e2fsck fsck.ext3 ; ln -s mke2fs mkfs.ext2 ; \
 		ln -s mke2fs mkfs.ext3 ; ln -s mke2fs mkfs.ext4)
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	mkdir -p ${blkidudebdir}/lib
 	mv ${udebdir}/lib/libblkid.* ${blkidudebdir}/lib
 
 	mkdir -p ${uuidudebdir}/lib
 	mv ${udebdir}/lib/libuuid.* ${uuidudebdir}/lib
+endif
 
 binary-indep: 
   # no arch-independant debs.
@@ -358,9 +394,11 @@ binary-arch: install install-udeb
 
   # symlinks to prepare dh_installdocs run
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	mkdir -p ${debdir}/libblkid${BLKID_SOVERSION}/usr/share/doc/libblkid${BLKID_SOVERSION}
 	mkdir -p ${debdir}/libblkid-dev/usr/share/doc
 	ln -sf libblkid${BLKID_SOVERSION} ${debdir}/libblkid-dev/usr/share/doc/libblkid-dev
+endif
 
 	mkdir -p ${debdir}/libss${SS_SOVERSION}/usr/share/doc/libss${SS_SOVERSION}
 	mkdir -p ${debdir}/ss-dev/usr/share/doc
@@ -370,16 +408,20 @@ binary-arch: install install-udeb
 	mkdir -p ${debdir}/comerr-dev/usr/share/doc
 	ln -sf libcomerr${COMERR_SOVERSION} ${debdir}/comerr-dev/usr/share/doc/comerr-dev
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	mkdir -p ${debdir}/libuuid${UUID_SOVERSION}/usr/share/doc/libuuid${UUID_SOVERSION}
 	mkdir -p ${debdir}/uuid-dev/usr/share/doc
 #	ln -sf libuuid${UUID_SOVERSION} ${debdir}/uuid-dev/usr/share/doc/uuid-dev
+endif
 
 	mkdir -p ${debdir}/e2fslibs/usr/share/doc/e2fslibs
 	mkdir -p ${debdir}/e2fslibs-dev/usr/share/doc
 	ln -sf e2fslibs ${debdir}/e2fslibs-dev/usr/share/doc/e2fslibs-dev
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	$(INSTALL) -p -m 0644 debian/libblkid.copyright \
 		${debdir}/libblkid${BLKID_SOVERSION}/usr/share/doc/libblkid${BLKID_SOVERSION}/copyright
+endif
 
 	dh_installdocs -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
 
@@ -416,11 +458,15 @@ binary-arch: install install-udeb
 	dh_installinfo -pe2fslibs-dev ${stdbuilddir}/doc/libext2fs.info
 
 	DH_OPTIONS= dh_installchangelogs -pe2fsprogs \
-		-plibblkid${BLKID_SOVERSION} -plibcomerr${COMERR_SOVERSION} \
-		-plibss${SS_SOVERSION} -plibuuid${UUID_SOVERSION} \
-		-pe2fslibs -puuid-dev -puuid-runtime -pe2fsck-static \
-		-pe2fsprogs-dbg -puuid-runtime-dbg -pe2fslibs-dbg \
-		-plibcomerr2-dbg -plibss2-dbg -plibblkid1-dbg -plibuuid1-dbg
+		-plibcomerr${COMERR_SOVERSION} \
+		-plibss${SS_SOVERSION} \
+		-pe2fslibs -pe2fsck-static \
+		-pe2fsprogs-dbg -pe2fslibs-dbg \
+		-plibcomerr2-dbg -plibss2-dbg
+ifneq ($(UTIL_LINUX_NG),yes)
+	DH_OPTIONS= dh_installchangelogs -plibuuid${UUID_SOVERSION} \
+		-puuid-dev -puuid-runtime -puuid-runtime-dbg -plibuuid1-dbg
+endif
 
 	dh_fixperms
 ifneq ($(ismips),)
@@ -431,8 +477,10 @@ endif
 
 	# debug package stuff
 	rm -rf ${udebdir}/usr
+ifneq ($(UTIL_LINUX_NG),yes)
 	rm -rf ${blkidudebdir}/usr
 	rm -rf ${uuidudebdir}/usr
+endif
 
 	mkdir -p ${debugdir}/usr/lib
 	mv ${maindir}/usr/lib/debug ${debugdir}/usr/lib
@@ -441,9 +489,11 @@ endif
 		${debugdir}/usr/lib/debug
 	rm -rf ${e2fsckstaticdir}/usr/lib
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	mkdir -p ${uuidruntimedbgdir}/usr/lib
 	mv ${uuidruntimedir}/usr/lib/debug ${uuidruntimedbgdir}/usr/lib
 	rmdir ${uuidruntimedir}/usr/lib
+endif
 
 	mkdir -p ${libext2dbgdir}/usr/lib
 	mv ${libext2dir}/usr/lib/debug ${libext2dbgdir}/usr/lib
@@ -457,6 +507,7 @@ endif
 	mv ${libssdir}/usr/lib/debug ${libssdbgdir}/usr/lib
 	rmdir ${libssdir}/usr/lib
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	mkdir -p ${libuuiddbgdir}/usr/lib
 	mv ${libuuiddir}/usr/lib/debug ${libuuiddbgdir}/usr/lib
 	rmdir ${libuuiddir}/usr/lib
@@ -464,10 +515,15 @@ endif
 	mkdir -p ${libblkiddbgdir}/usr/lib
 	mv ${libblkiddir}/usr/lib/debug ${libblkiddbgdir}/usr/lib
 	rmdir ${libblkiddir}/usr/lib
+endif
 
 	# dpkg symbol handling
 ifneq (,$(findstring update-symbols,$(DEB_BUILD_OPTIONS)))
-	for i in e2fslibs libcomerr2 libss2 libblkid1 libuuid1; \
+SYMBOL_LIBS := e2fslibs libcomerr2 libss2
+ifneq ($(UTIL_LINUX_NG),yes)
+SYMBOL_LIBS += libblkid1 libuuid1
+endif
+	for i in $(SYMBOL_LIBS); \
 	do \
 		echo "Generating symbols for $$i..."; \
 		dpkg-gensymbols -p$$i -Pdebian/$$i > debian/$$i.tmp-patch; \
@@ -480,8 +536,10 @@ endif
 	$(INSTALL) -p -m 0644 debian/e2fsprogs.copyright \
 		${debugdir}/usr/share/doc/e2fsprogs-dbg/copyright
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	$(INSTALL) -p -m 0644 debian/uuid-runtime.copyright \
 		${uuidruntimedbgdir}/usr/share/doc/uuid-runtime-dbg/copyright
+endif
 
 	$(INSTALL) -p -m 0644 debian/e2fslibs.copyright \
 		${libext2dbgdir}/usr/share/doc/e2fslibs-dbg/copyright
@@ -492,21 +550,25 @@ endif
 	$(INSTALL) -p -m 0644 debian/libss2.copyright \
 		${libssdbgdir}/usr/share/doc/libss2-dbg/copyright
 
+ifneq ($(UTIL_LINUX_NG),yes)
 	$(INSTALL) -p -m 0644 debian/libblkid.copyright \
 		${libblkiddbgdir}/usr/share/doc/libblkid1-dbg/copyright
 
 	$(INSTALL) -p -m 0644 debian/libuuid1.copyright \
 		${libuuiddbgdir}/usr/share/doc/libuuid1-dbg/copyright
+endif
 
 	dh_compress
 
 	dh_makeshlibs -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
 	dh_makeshlibs -plibcomerr${COMERR_SOVERSION} \
 		-V 'libcomerr2 (>= 1.33-3)'
+ifneq ($(UTIL_LINUX_NG),yes)
 	dh_makeshlibs -plibblkid${BLKID_SOVERSION} -V 'libblkid1 (>= 1.39-1)'
 	echo "udeb: libblkid 1 libblkid1-udeb" >> \
 		debian/libblkid1/DEBIAN/shlibs
 	echo "udeb: libuuid 1 libuuid1-udeb" >> debian/libuuid1/DEBIAN/shlibs
+endif
 
 	dh_installdeb
 	dh_shlibdeps -l${stdbuilddir}/lib
@@ -521,20 +583,28 @@ endif
 	  -u '-v${COMERR_VERSION}-${MAIN_VERSION} -VmainBinary=${MAIN_VERSION}'
 	DH_OPTIONS= dh_gencontrol -pss-dev \
 	  -u '-v${SS_VERSION}-${MAIN_VERSION} -VmainBinary=${MAIN_VERSION}'
+ifneq ($(UTIL_LINUX_NG),yes)
 	DH_OPTIONS= dh_gencontrol -puuid-dev \
 	  -u '-v${UUID_VERSION}-${MAIN_VERSION} -VmainBinary=${MAIN_VERSION}'
+endif
 	dh_gencontrol	-pe2fsprogs-udeb -- -fdebian/files~
+ifneq ($(UTIL_LINUX_NG),yes)
 	dh_gencontrol	-plibblkid1-udeb -- -fdebian/files~
 	dh_gencontrol	-plibuuid1-udeb -- -fdebian/files~
+endif
 
 	dpkg-distaddfile $(UDEB_NAME) debian-installer $(UDEB_PRIORITY)
+ifneq ($(UTIL_LINUX_NG),yes)
 	dpkg-distaddfile $(BLKID_UDEB_NAME) debian-installer $(BLKID_UDEB_PRIORITY)
 	dpkg-distaddfile $(UUID_UDEB_NAME) debian-installer $(UUID_UDEB_PRIORITY)
+endif
 	dh_md5sums -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
 	dh_builddeb -Ne2fsprogs-udeb -Nlibblkid1-udeb -Nlibuuid1-udeb
 	dh_builddeb -pe2fsprogs-udeb --filename=$(UDEB_NAME)
+ifneq ($(UTIL_LINUX_NG),yes)
 	dh_builddeb -plibblkid1-udeb --filename=$(BLKID_UDEB_NAME)
 	dh_builddeb -plibuuid1-udeb --filename=$(UUID_UDEB_NAME)
+endif
 
 binary: binary-indep binary-arch
 
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
