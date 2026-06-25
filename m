Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A3630BF6D
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416316; cv=none; b=MjZ9Jo0vFZcvZcCcd6Y4nVYFHjqnh1jjgWdeEKLPUhkTc5x/vUhUGB3JruZ5A0KN6/05Vg3umS9rN9BApaFusUR+qp3BDIhe7apRVNzSSJeBArgCEN6kjLaTrAfrAs4aqFd4Fjwjedw69K7RzETuzcO3hGQVAUrS5hv+zzAvjYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416316; c=relaxed/simple;
	bh=B7HxcIV8LjhwxIshTzpTxQbqV1Et+reRHLT0wT7OWLU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ImeQypEMfdvPb0mX580JQDIrAEO/ujqIh3h1SwVDHFQqSQz+ufg8rrIxMq/7yMHq7YVGF6PM8svMf5vsuaxbPtQU3oLxL4ozxQ94IomG0R5ztZ/MdH2EpGVCDvAMf5goPFgZDcHvaAm2guX/xHAUyuvH77Xf15qRskATOFoAWPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kclNNT3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kclNNT3V"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DC0071F000E9;
	Thu, 25 Jun 2026 19:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416314;
	bh=D8wG9G9XpSwOLlwQupiqxN6LvUJH3JjSKE8t2LSW3gg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kclNNT3VzciR9fujFPeEPfhstdi2dVEu9+yXr/4dsaGSODBQUjcvRni7GHKmWmeyv
	 vPlc9TMIK6j9rUz4RSqQFtKuE6+HUXT9o5DWwg4XW9NGdlWTTTh9ZXLKcO0OfrP2qs
	 HjQxQn4KzdKD5q6HRfYbfWWXqDzZcLVY0Z9e2jIUzbyg7TnPFsKSyul5Ua79vjGK9/
	 cdKn3gC+7c/+MnPjA8gudlW/LLe7d98E7dhkQmhuumZ6Sc5cWRULtpaA0m1Q9Kq56A
	 nGq3Qq7PTfpAoqYmseLpeQhHWUXLQMwZZoUGNImpQ0SDBp81S6k7jsqcdmaeakuyMA
	 BRIuGeQL+zFtg==
Date: Thu, 25 Jun 2026 12:38:33 -0700
Subject: [PATCH 07/10] fuse4fs: enable safe service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606937.1810414.14943872795668449608.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make it possible to run fuse4fs as a safe systemd service, wherein the
fuse server only has access to the fds that we pass in.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 MCONFIG.in                  |    2 
 configure                   |  186 +++++++++++++++++++++++++++++++
 configure.ac                |  108 ++++++++++++++++++
 fuse4fs/Makefile.in         |   40 ++++++-
 fuse4fs/fuse4fs.c           |  254 +++++++++++++++++++++++++++++++++++++++++--
 fuse4fs/fuse4fs.socket.in   |   17 +++
 fuse4fs/fuse4fs@.service.in |  102 +++++++++++++++++
 lib/config.h.in             |    6 +
 util/subst.conf.in          |    3 +
 9 files changed, 703 insertions(+), 15 deletions(-)
 create mode 100644 fuse4fs/fuse4fs.socket.in
 create mode 100644 fuse4fs/fuse4fs@.service.in


diff --git a/MCONFIG.in b/MCONFIG.in
index d66e2f3bc1d552..7a17778b6da67f 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -42,6 +42,8 @@ HAVE_CROND = @have_crond@
 CROND_DIR = @crond_dir@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
+HAVE_FUSE_SERVICE = @have_fuse_service@
+HAVE_FUSE4FS_SERVICE = @have_fuse4fs_service@
 
 @SET_MAKE@
 
diff --git a/configure b/configure
index f24897fcdd4949..87960ad2cae3c3 100755
--- a/configure
+++ b/configure
@@ -645,6 +645,7 @@ enable_year2038=no
 ac_subst_vars='LTLIBOBJS
 LIBOBJS
 OS_IO_FILE
+have_fuse4fs_service
 systemd_system_unit_dir
 have_systemd
 systemd_LIBS
@@ -697,6 +698,9 @@ UNI_DIFF_OPTS
 SEM_INIT_LIB
 FUSE4FS_CMT
 FUSE2FS_CMT
+fuse_service_socket_perms
+fuse_service_socket_dir
+have_fuse_service
 FUSE_LIB
 fuse3_LIBS
 fuse3_CFLAGS
@@ -929,6 +933,8 @@ with_libiconv_prefix
 with_libintl_prefix
 enable_largefile
 with_libarchive
+with_fuse_service_socket_dir
+with_fuse_service_socket_perms
 enable_fuse2fs
 enable_fuse4fs
 enable_lto
@@ -1652,6 +1658,11 @@ Optional Packages:
   --with-libintl-prefix[=DIR]  search for libintl in DIR/include and DIR/lib
   --without-libintl-prefix     don't search for libintl in includedir and libdir
   --without-libarchive    disable use of libarchive
+  --with-fuse-service-socket-dir[=DIR]
+                          Create fuse3 filesystem service sockets in DIR.
+  --with-fuse-service-socket-perms[=MODE]
+                          Create fuse3 filesystem service socket with these
+                          permissions.
   --with-multiarch=ARCH   specify the multiarch triplet
   --with-udev-rules-dir[=DIR]
                           Install udev rules into DIR.
@@ -14598,7 +14609,7 @@ else
         fuse3_LIBS=$pkg_cv_fuse3_LIBS
         { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: yes" >&5
 printf "%s\n" "yes" >&6; }
-        FUSE_LIB=-lfuse3
+        FUSE_LIB=-lfuse3 ; have_fuse3_pkg=yes
 fi
 
 
@@ -14680,6 +14691,155 @@ printf "%s\n" "#define HAVE_FUSE_LOWLEVEL 1" >>confdefs.h
 
 fi
 
+have_fuse_service=
+fuse_service_socket_dir=
+if test -n "$have_fuse_lowlevel"
+then
+
+# Check whether --with-fuse_service_socket_dir was given.
+if test ${with_fuse_service_socket_dir+y}
+then :
+  withval=$with_fuse_service_socket_dir;
+else case e in #(
+  e) with_fuse_service_socket_dir=yes ;;
+esac
+fi
+
+	if test "x${with_fuse_service_socket_dir}" != "xno"
+then :
+
+		if test "x${with_fuse_service_socket_dir}" = "xyes"
+then :
+
+			if test "x$have_fuse3_pkg" = "xyes"
+then :
+
+				with_fuse_service_socket_dir="$($PKG_CONFIG --variable=service_socket_dir fuse3)"
+
+else case e in #(
+  e)
+				with_fuse_service_socket_dir=""
+			   ;;
+esac
+fi
+
+fi
+		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for fuse3 service socket dir" >&5
+printf %s "checking for fuse3 service socket dir... " >&6; }
+		fuse_service_socket_dir="${with_fuse_service_socket_dir}"
+		if test -n "${fuse_service_socket_dir}"
+then :
+
+			{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: ${fuse_service_socket_dir}" >&5
+printf "%s\n" "${fuse_service_socket_dir}" >&6; }
+
+else case e in #(
+  e)
+			{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: no" >&5
+printf "%s\n" "no" >&6; }
+		   ;;
+esac
+fi
+
+fi
+
+# Check whether --with-fuse_service_socket_perms was given.
+if test ${with_fuse_service_socket_perms+y}
+then :
+  withval=$with_fuse_service_socket_perms;
+else case e in #(
+  e) with_fuse_service_socket_perms=yes ;;
+esac
+fi
+
+	if test "x${with_fuse_service_socket_perms}" != "xno"
+then :
+
+		if test "x${with_fuse_service_socket_perms}" = "xyes"
+then :
+
+			if test "x$have_fuse3_pkg" = "xyes"
+then :
+
+				with_fuse_service_socket_perms="$($PKG_CONFIG --variable=service_socket_perms fuse3)"
+
+else case e in #(
+  e)
+				with_fuse_service_socket_perms=""
+			   ;;
+esac
+fi
+
+fi
+		fuse_service_socket_perms="${with_fuse_service_socket_perms}"
+
+fi
+fi
+if test -n "$FUSE_USE_VERSION"
+then
+	{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for fuse_service_accept in libfuse" >&5
+printf %s "checking for fuse_service_accept in libfuse... " >&6; }
+	cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+	#define _GNU_SOURCE
+	#define _FILE_OFFSET_BITS	64
+	#define FUSE_USE_VERSION	319
+	#include <fuse_lowlevel.h>
+	#include <fuse_service.h>
+
+int
+main (void)
+{
+
+	struct fuse_service *moo;
+	fuse_service_accepted(moo);
+
+  ;
+  return 0;
+}
+
+_ACEOF
+if ac_fn_c_try_link "$LINENO"
+then :
+  have_fuse_service_accept=yes
+	   { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+printf "%s\n" "yes" >&6; }
+else case e in #(
+  e) { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: no" >&5
+printf "%s\n" "no" >&6; } ;;
+esac
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.beam \
+    conftest$ac_exeext conftest.$ac_ext
+
+	{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for fuse3 service support" >&5
+printf %s "checking for fuse3 service support... " >&6; }
+	if test -n "${fuse_service_socket_dir}" && test "${have_fuse_service_accept}" = "yes"
+then :
+
+		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+printf "%s\n" "yes" >&6; }
+		have_fuse_service="yes"
+
+else case e in #(
+  e)
+		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: no" >&5
+printf "%s\n" "no" >&6; }
+	   ;;
+esac
+fi
+fi
+
+
+
+if test "$have_fuse_service" = yes
+then
+
+printf "%s\n" "#define HAVE_FUSE_SERVICE 1" >>confdefs.h
+
+fi
+
 FUSE2FS_CMT=
 # Check whether --enable-fuse2fs was given.
 if test ${enable_fuse2fs+y}
@@ -16595,6 +16755,30 @@ esac
 fi
 
 
+
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for fuse4fs service support and systemd" >&5
+printf %s "checking for fuse4fs service support and systemd... " >&6; }
+if test "${FUSE4FS_CMT}${have_fuse_service}${have_systemd}" = "yesyes"
+then :
+
+           { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+printf "%s\n" "yes" >&6; }
+
+printf "%s\n" "#define HAVE_FUSE4FS_SERVICE 1" >>confdefs.h
+
+           have_fuse4fs_service=yes
+
+else case e in #(
+  e)
+           { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: no" >&5
+printf "%s\n" "no" >&6; }
+           have_fuse4fs_service=no
+
+ ;;
+esac
+fi
+
+
 OS_IO_FILE=""
 case "$host_os" in
   mingw*)
diff --git a/configure.ac b/configure.ac
index 38a18de0b67283..381bb15d920a0f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1376,7 +1376,7 @@ dnl Check to see if the FUSE library is -lfuse3 or -losxfuse
 dnl
 FUSE_LIB=
 dnl osxfuse.dylib supersedes fuselib.dylib
-PKG_CHECK_MODULES([fuse3], [fuse3], [FUSE_LIB=-lfuse3],
+PKG_CHECK_MODULES([fuse3], [fuse3], [FUSE_LIB=-lfuse3 ; have_fuse3_pkg=yes],
 [
 	AC_CHECK_LIB(osxfuse, fuse_main, [FUSE_LIB=-losxfuse])
 ])
@@ -1428,6 +1428,96 @@ then
 		  [Define to 1 if fuse supports lowlevel API])
 fi
 
+dnl
+dnl Check if the FUSE library tells us where to put fs service sockets
+dnl
+have_fuse_service=
+fuse_service_socket_dir=
+if test -n "$have_fuse_lowlevel"
+then
+	AC_ARG_WITH([fuse_service_socket_dir],
+	  [AS_HELP_STRING([--with-fuse-service-socket-dir@<:@=DIR@:>@],
+		  [Create fuse3 filesystem service sockets in DIR.])],
+	  [],
+	  [with_fuse_service_socket_dir=yes])
+	AS_IF([test "x${with_fuse_service_socket_dir}" != "xno"],
+	  [
+		AS_IF([test "x${with_fuse_service_socket_dir}" = "xyes"],
+		  [
+			AS_IF([test "x$have_fuse3_pkg" = "xyes" ],
+			  [
+				with_fuse_service_socket_dir="$($PKG_CONFIG --variable=service_socket_dir fuse3)"
+			  ], [
+				with_fuse_service_socket_dir=""
+			  ])
+		  ])
+		AC_MSG_CHECKING([for fuse3 service socket dir])
+		fuse_service_socket_dir="${with_fuse_service_socket_dir}"
+		AS_IF([test -n "${fuse_service_socket_dir}"],
+		  [
+			AC_MSG_RESULT(${fuse_service_socket_dir})
+		  ],
+		  [
+			AC_MSG_RESULT(no)
+		  ])
+	  ],
+	  [])
+	AC_ARG_WITH([fuse_service_socket_perms],
+	  [AS_HELP_STRING([--with-fuse-service-socket-perms@<:@=MODE@:>@],
+		  [Create fuse3 filesystem service socket with these permissions.])],
+	  [],
+	  [with_fuse_service_socket_perms=yes])
+	AS_IF([test "x${with_fuse_service_socket_perms}" != "xno"],
+	  [
+		AS_IF([test "x${with_fuse_service_socket_perms}" = "xyes"],
+		  [
+			AS_IF([test "x$have_fuse3_pkg" = "xyes" ],
+			  [
+				with_fuse_service_socket_perms="$($PKG_CONFIG --variable=service_socket_perms fuse3)"
+			  ], [
+				with_fuse_service_socket_perms=""
+			  ])
+		  ])
+		fuse_service_socket_perms="${with_fuse_service_socket_perms}"
+	  ],
+	  [])
+fi
+if test -n "$FUSE_USE_VERSION"
+then
+	AC_MSG_CHECKING(for fuse_service_accept in libfuse)
+	AC_LINK_IFELSE(
+	[	AC_LANG_PROGRAM([[
+	#define _GNU_SOURCE
+	#define _FILE_OFFSET_BITS	64
+	#define FUSE_USE_VERSION	319
+	#include <fuse_lowlevel.h>
+	#include <fuse_service.h>
+		]], [[
+	struct fuse_service *moo;
+	fuse_service_accepted(moo);
+		]])
+	], have_fuse_service_accept=yes
+	   AC_MSG_RESULT(yes),
+	   AC_MSG_RESULT(no))
+
+	AC_MSG_CHECKING([for fuse3 service support])
+	AS_IF([test -n "${fuse_service_socket_dir}" && test "${have_fuse_service_accept}" = "yes"],
+	  [
+		AC_MSG_RESULT(yes)
+		have_fuse_service="yes"
+	  ],
+	  [
+		AC_MSG_RESULT(no)
+	  ])
+fi
+AC_SUBST(have_fuse_service)
+AC_SUBST(fuse_service_socket_dir)
+AC_SUBST(fuse_service_socket_perms)
+if test "$have_fuse_service" = yes
+then
+	AC_DEFINE(HAVE_FUSE_SERVICE, 1, [Define to 1 if fuse supports service])
+fi
+
 dnl
 dnl Check if fuse2fs is actually built.
 dnl
@@ -2101,6 +2191,22 @@ AS_IF([test "x${with_systemd_unit_dir}" != "xno"],
   ])
 AC_SUBST(have_systemd)
 AC_SUBST(systemd_system_unit_dir)
+
+AC_MSG_CHECKING([for fuse4fs service support and systemd])
+AS_IF([test "${FUSE4FS_CMT}${have_fuse_service}${have_systemd}" = "yesyes"],
+      [
+           AC_MSG_RESULT(yes)
+           AC_DEFINE(HAVE_FUSE4FS_SERVICE, 1,
+                     [Define to 1 if fuse4fs should be built with fuse service support])
+           have_fuse4fs_service=yes
+      ],
+      [
+           AC_MSG_RESULT(no)
+           have_fuse4fs_service=no
+      ]
+)
+AC_SUBST(have_fuse4fs_service)
+
 dnl Adjust the compiled files if we are on windows vs everywhere else
 dnl
 OS_IO_FILE=""
diff --git a/fuse4fs/Makefile.in b/fuse4fs/Makefile.in
index cecee2b2554f82..67b8afd54493b0 100644
--- a/fuse4fs/Makefile.in
+++ b/fuse4fs/Makefile.in
@@ -17,6 +17,13 @@ UMANPAGES=
 @FUSE4FS_CMT@UPROGS+=fuse4fs
 @FUSE4FS_CMT@UMANPAGES+=fuse4fs.1
 
+ifeq ($(HAVE_FUSE4FS_SERVICE),yes)
+SERVICE_FILES	+= fuse4fs.socket fuse4fs@.service
+INSTALLDIRS_TGT	+= installdirs-systemd
+INSTALL_TGT	+= install-systemd
+UNINSTALL_TGT	+= uninstall-systemd
+endif
+
 FUSE4FS_OBJS=	fuse4fs.o journal.o recovery.o revoke.o
 
 PROFILED_FUSE4FS_OJBS=	profiled/fuse4fs.o profiled/journal.o \
@@ -54,7 +61,7 @@ DEPEND_CFLAGS = -I$(top_srcdir)/e2fsck
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
-	$(FMANPAGES) $(LPROGS)
+	$(FMANPAGES) $(LPROGS) $(SERVICE_FILES)
 
 all-static::
 
@@ -71,6 +78,14 @@ fuse4fs: $(FUSE4FS_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
 		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBINTL) \
 		$(CLOCK_GETTIME_LIB) $(SYSLIBS) $(LIBS_E2P)
 
+%.socket: %.socket.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
+%.service: %.service.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
 journal.o: $(srcdir)/../debugfs/journal.c
 	$(E) "	CC $<"
 	$(Q) $(CC) -c $(JOURNAL_CFLAGS) -I$(srcdir) \
@@ -93,11 +108,15 @@ fuse4fs.1: $(DEP_SUBSTITUTE) $(srcdir)/fuse4fs.1.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/fuse4fs.1.in fuse4fs.1
 
-installdirs:
+installdirs: $(INSTALLDIRS_TGT)
 	$(E) "	MKDIR_P $(bindir) $(man1dir)"
 	$(Q) $(MKDIR_P) $(DESTDIR)$(bindir) $(DESTDIR)$(man1dir)
 
-install: all $(UMANPAGES) installdirs
+installdirs-systemd:
+	$(E) "	MKDIR_P $(SYSTEMD_SYSTEM_UNIT_DIR)"
+	$(Q) $(MKDIR_P) $(DESTDIR)$(SYSTEMD_SYSTEM_UNIT_DIR)
+
+install: all $(UMANPAGES) installdirs $(INSTALL_TGT)
 	$(Q) for i in $(UPROGS); do \
 		$(ES) "	INSTALL $(bindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(bindir)/$$i; \
@@ -110,13 +129,19 @@ install: all $(UMANPAGES) installdirs
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man1dir)/$$i; \
 	done
 
+install-systemd: $(SERVICE_FILES) installdirs-systemd
+	$(Q) for i in $(SERVICE_FILES); do \
+		$(ES) "	INSTALL_DATA $(SYSTEMD_SYSTEM_UNIT_DIR)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(SYSTEMD_SYSTEM_UNIT_DIR)/$$i; \
+	done
+
 install-strip: install
 	$(Q) for i in $(UPROGS); do \
 		$(E) "	STRIP $(bindir)/$$i"; \
 		$(STRIP) $(DESTDIR)$(bindir)/$$i; \
 	done
 
-uninstall:
+uninstall: $(UNINSTALL_TGT)
 	for i in $(UPROGS); do \
 		$(RM) -f $(DESTDIR)$(bindir)/$$i; \
 	done
@@ -124,9 +149,16 @@ uninstall:
 		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
 	done
 
+uninstall-systemd:
+	for i in $(SERVICE_FILES); do \
+		$(RM) -f $(DESTDIR)$(SYSTEMD_SYSTEM_UNIT_DIR)/$$i; \
+	done
+
 clean::
 	$(RM) -f $(UPROGS) $(UMANPAGES) profile.h \
 		fuse4fs.profiled \
+		$(SERVICE_FILES) \
+		fuse4fs.socket \
 		profiled/*.o \#* *.s *.o *.a *~ core gmon.out
 
 mostlyclean: clean
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index ebf42609c1a739..97e668fadc2398 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -42,6 +42,10 @@
 # define _FILE_OFFSET_BITS 64
 #endif /* _FILE_OFFSET_BITS */
 #include <fuse_lowlevel.h>
+#ifdef HAVE_FUSE4FS_SERVICE
+# include <sys/mount.h>
+# include <fuse_service.h>
+#endif
 #ifdef __SET_FOB_FOR_FUSE
 # undef _FILE_OFFSET_BITS
 #endif /* __SET_FOB_FOR_FUSE */
@@ -140,6 +144,10 @@
 
 #define FUSE4FS_ATTR_TIMEOUT	(0.0)
 
+#ifndef O_DIRECT
+# define O_DIRECT	(0)
+#endif
+
 static inline uint64_t round_up(uint64_t b, unsigned int align)
 {
 	unsigned int m;
@@ -285,8 +293,21 @@ struct fuse4fs {
 #endif
 	struct fuse_session *fuse;
 	struct cache inodes;
+#ifdef HAVE_FUSE4FS_SERVICE
+	struct fuse_service *service;
+	int bdev_fd;
+#endif
 };
 
+#ifdef HAVE_FUSE4FS_SERVICE
+static inline bool fuse4fs_is_service(const struct fuse4fs *ff)
+{
+	return fuse_service_accepted(ff->service);
+}
+#else
+# define fuse4fs_is_service(...)		(false)
+#endif
+
 #define FUSE4FS_CHECK_HANDLE(req, fh) \
 	do { \
 		if ((fh) == NULL || (fh)->magic != FUSE4FS_FILE_MAGIC) { \
@@ -1270,6 +1291,118 @@ static errcode_t fuse4fs_check_support(struct fuse4fs *ff)
 	return 0;
 }
 
+#ifdef HAVE_FUSE4FS_SERVICE
+static int fuse4fs_service_connect(struct fuse4fs *ff, struct fuse_args *args)
+{
+	int ret;
+
+	ret = fuse_service_accept(&ff->service);
+	if (ret)
+		return ret;
+
+	if (!fuse4fs_is_service(ff))
+		return 0;
+
+	return fuse_service_append_args(ff->service, args);
+}
+
+static bool fuse4fs_service_should_drop_kernel_mode(const struct fuse4fs *ff)
+{
+	return ff->kernel && fuse4fs_is_service(ff) &&
+	       !fuse_service_can_allow_other(ff->service);
+}
+
+static void fuse4fs_service_close_bdev(struct fuse4fs *ff)
+{
+	if (ff->bdev_fd >= 0)
+		close(ff->bdev_fd);
+	ff->bdev_fd = -1;
+}
+
+static int fuse4fs_service_exit(struct fuse4fs *ff, int exitcode)
+{
+	if (!fuse4fs_is_service(ff))
+		return exitcode;
+
+	fuse_service_send_goodbye(ff->service, exitcode);
+	fuse_service_release(ff->service);
+	close(ff->bdev_fd);
+	ff->bdev_fd = -1;
+
+	return fuse_service_exit(exitcode);
+}
+
+static int fuse4fs_service_open_bdev(struct fuse4fs *ff)
+{
+	double deadline = init_deadline(FUSE4FS_OPEN_TIMEOUT);
+	const int open_flags = O_EXCL | (ff->directio ? O_DIRECT : 0);
+	int open_mode = O_RDWR;
+	int fd;
+	int ret;
+
+	do {
+		ret = fuse_service_request_file(ff->service, ff->device,
+						open_mode | open_flags, 0, 0);
+		if (ret)
+			return ret;
+
+		ret = fuse_service_receive_file(ff->service, ff->device, &fd);
+		if (ret)
+			return ret;
+
+		if ((fd == -EPERM || fd == -EACCES || fd == -EROFS) &&
+		    open_mode == O_RDWR) {
+			/* Try readonly, but force the loop to run once more */
+			open_mode = O_RDONLY;
+			ret = 1;
+		}
+	} while (ret == 1 || (fd == -EBUSY && retry_before_deadline(deadline)));
+
+	if (fd < 0) {
+		err_printf(ff, "%s %s: %s.\n", _("opening device"), ff->device,
+			   strerror(-fd));
+		return -1;
+	}
+
+	if (!ff->ro && open_mode == O_RDONLY)
+		ff->ro = 1;
+
+	ff->bdev_fd = fd;
+	return 0;
+}
+
+static int fuse4fs_service_get_config(struct fuse4fs *ff)
+{
+	int ret, ret2;
+
+	ret = fuse4fs_service_open_bdev(ff);
+
+	/* Always prevent further fds from being added to our file table */
+	ret2 = fuse_service_finish_file_requests(ff->service);
+	if (ret2 && !ret)
+		ret = ret2;
+
+	return ret;
+}
+
+static errcode_t fuse4fs_service_openfs(struct fuse4fs *ff, char *options,
+					int flags)
+{
+	char path[64];
+
+	snprintf(path, sizeof(path), "/dev/fd/%d", ff->bdev_fd);
+	return ext2fs_open2(path, options, flags, 0, 0, unixfd_io_manager,
+			    &ff->fs);
+}
+#else
+# define fuse4fs_service_connect(...)		(0)
+# define fuse4fs_service_should_drop_kernel_mode(...)	(false)
+# define fuse4fs_service_close_bdev(...)	((void)0)
+# define fuse4fs_service_exit(fctx, ret)	(ret)
+# define fuse4fs_service_get_config(...)	(EOPNOTSUPP)
+# define fuse4fs_service_openfs(...)		(EOPNOTSUPP)
+#endif
+
 static errcode_t fuse4fs_acquire_lockfile(struct fuse4fs *ff)
 {
 	char *resolved;
@@ -1340,6 +1473,8 @@ static void fuse4fs_unmount(struct fuse4fs *ff)
 				   uuid);
 	}
 
+	fuse4fs_service_close_bdev(ff);
+
 	if (ff->lockfile)
 		fuse4fs_release_lockfile(ff);
 }
@@ -1395,8 +1530,11 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 	 */
 	deadline = init_deadline(FUSE4FS_OPEN_TIMEOUT);
 	do {
-		err = ext2fs_open2(ff->device, options, flags, 0, 0,
-				   unix_io_manager, &ff->fs);
+		if (fuse4fs_is_service(ff))
+			err = fuse4fs_service_openfs(ff, options, flags);
+		else
+			err = ext2fs_open2(ff->device, options, flags, 0, 0,
+					   unix_io_manager, &ff->fs);
 		if ((err == EPERM || err == EACCES) &&
 		    (!ff->ro || (flags & EXT2_FLAG_RW))) {
 			/*
@@ -1741,6 +1879,10 @@ static int fuse4fs_setup_logging(struct fuse4fs *ff)
 	if (logfile)
 		return fuse4fs_capture_output(ff, logfile);
 
+	/* systemd already hooked us up to /dev/ttyprintk */
+	if (fuse4fs_is_service(ff))
+		return 0;
+
 	/* in kernel mode, try to log errors to the kernel log */
 	if (ff->kernel)
 		fuse4fs_capture_output(ff, "/dev/ttyprintk");
@@ -5962,14 +6104,13 @@ static const char *get_subtype(const char *argv0)
 }
 
 static void fuse4fs_compute_libfuse_args(struct fuse4fs *ff,
-					 struct fuse_args *args,
-					 const char *argv0)
+					 struct fuse_args *args)
 {
 	char extra_args[BUFSIZ];
 
 	/* Set up default fuse parameters */
 	snprintf(extra_args, BUFSIZ, "-osubtype=%s,fsname=%s",
-		 get_subtype(argv0),
+		 get_subtype(args->argv[0]),
 		 ff->device);
 	if (ff->no_default_opts == 0)
 		fuse_opt_add_arg(args, extra_args);
@@ -5986,6 +6127,15 @@ static void fuse4fs_compute_libfuse_args(struct fuse4fs *ff,
 #endif
 	}
 
+	/*
+	 * If we're mounting as a systemd service but the mount helper told us
+	 * that allow_other isn't allowed, then disable -okernel.  This mount
+	 * option gets special consideration because it's hardcoded in the
+	 * service unit file.
+	 */
+	if (fuse4fs_service_should_drop_kernel_mode(ff))
+		ff->kernel = 0;
+
 	if (ff->kernel) {
 		/*
 		 * ACLs are always enforced when kernel mode is enabled, to
@@ -6097,6 +6247,69 @@ static int fuse4fs_event_loop(struct fuse4fs *ff,
 	return fuse_session_loop_mt(ff->fuse, loop_config) == 0 ? 0 : 8;
 }
 
+#ifdef HAVE_FUSE4FS_SERVICE
+static int fuse4fs_service_main(struct fuse_args *args, struct fuse4fs *ff)
+{
+	struct fuse_cmdline_opts opts;
+	struct fuse_loop_config *loop_config = NULL;
+	int ret;
+
+	/*
+	 * Service initialization doesn't fork or change stdout/stderr so we
+	 * can drop the extra logfd right now.
+	 */
+	if (ff->logfd >= 0)
+		close(ff->logfd);
+	ff->logfd = -1;
+
+	ret = fuse_service_parse_cmdline_opts(args, &opts);
+	if (ret != 0) {
+		ret = 1;
+		goto out;
+	}
+
+	ret = fuse4fs_create_session(ff, args, &opts);
+	if (ret || !ff->fuse)
+		goto out_free_opts;
+
+	loop_config = fuse_loop_cfg_create();
+	if (loop_config == NULL) {
+		ret = 7;
+		goto out_destroy_session;
+	}
+
+	if (fuse_set_signal_handlers(ff->fuse) != 0) {
+		ret = 6;
+		goto out_loopcfg;
+	}
+
+	ret = fuse_service_session_mount(ff->service, ff->fuse, S_IFDIR, &opts);
+	if (ret) {
+		ret = 4;
+		goto out_signals;
+	}
+
+	fuse_service_send_goodbye(ff->service, 0);
+	fuse_service_release(ff->service);
+
+	ret = fuse4fs_event_loop(ff, loop_config, &opts);
+
+out_signals:
+	fuse_remove_signal_handlers(ff->fuse);
+out_loopcfg:
+	fuse_loop_cfg_destroy(loop_config);
+out_destroy_session:
+	fuse_session_destroy(ff->fuse);
+	ff->fuse = NULL;
+out_free_opts:
+	free(opts.mountpoint);
+out:
+	return ret;
+}
+#else
+# define fuse4fs_service_main(...)		(8)
+#endif
+
 static int fuse4fs_main(struct fuse_args *args, struct fuse4fs *ff)
 {
 	struct fuse_cmdline_opts opts;
@@ -6168,18 +6381,28 @@ int main(int argc, char *argv[])
 		.bfl = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER,
 		.oom_score_adj = -500,
 		.opstate = F4OP_WRITABLE,
+#ifdef HAVE_FUSE4FS_SERVICE
+		.bdev_fd = -1,
+#endif
 	};
 	errcode_t err;
 	FILE *orig_stderr = stderr;
 	int ret;
 
+	ret = fuse4fs_service_connect(&fctx, &args);
+	if (ret) {
+		ret = 1;
+		goto out_exit;
+	}
+
 	ret = fuse_opt_parse(&args, &fctx, fuse4fs_opts, fuse4fs_opt_proc);
 	if (ret)
-		exit(1);
+		goto out_exit;
 	if (fctx.device == NULL) {
 		fprintf(stderr, "Missing ext4 device/image\n");
 		fprintf(stderr, "See '%s -h' for usage\n", argv[0]);
-		exit(1);
+		ret = 1;
+		goto out_exit;
 	}
 
 	/* /dev/sda -> sda for reporting */
@@ -6209,6 +6432,14 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
+	if (fuse4fs_is_service(&fctx)) {
+		ret = fuse4fs_service_get_config(&fctx);
+		if (ret) {
+			ret = 2;
+			goto out;
+		}
+	}
+
 	try_set_io_flusher(&fctx);
 	try_adjust_oom_score(&fctx);
 
@@ -6264,9 +6495,12 @@ int main(int argc, char *argv[])
 	/* Initialize generation counter */
 	get_random_bytes(&fctx.next_generation, sizeof(unsigned int));
 
-	fuse4fs_compute_libfuse_args(&fctx, &args, argv[0]);
+	fuse4fs_compute_libfuse_args(&fctx, &args);
 
-	ret = fuse4fs_main(&args, &fctx);
+	if (fuse4fs_is_service(&fctx))
+		ret = fuse4fs_service_main(&args, &fctx);
+	else
+		ret = fuse4fs_main(&args, &fctx);
 	switch(ret) {
 	case 0:
 		/* success */
@@ -6308,6 +6542,8 @@ int main(int argc, char *argv[])
 	if (fctx.device)
 		free(fctx.device);
 	pthread_mutex_destroy(&fctx.bfl);
+out_exit:
+	ret = fuse4fs_service_exit(&fctx, ret);
 	fuse_opt_free_args(&args);
 	return ret;
 }
diff --git a/fuse4fs/fuse4fs.socket.in b/fuse4fs/fuse4fs.socket.in
new file mode 100644
index 00000000000000..99e391bcc6787e
--- /dev/null
+++ b/fuse4fs/fuse4fs.socket.in
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2025-2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for ext4 Service
+
+[Socket]
+ListenSequentialPacket=@fuse_service_socket_dir@/ext2
+ListenSequentialPacket=@fuse_service_socket_dir@/ext3
+ListenSequentialPacket=@fuse_service_socket_dir@/ext4
+Accept=yes
+SocketMode=@fuse_service_socket_perms@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/fuse4fs/fuse4fs@.service.in b/fuse4fs/fuse4fs@.service.in
new file mode 100644
index 00000000000000..38434c383c7be3
--- /dev/null
+++ b/fuse4fs/fuse4fs@.service.in
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2025-2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=ext4 Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=@bindir@/fuse4fs -o kernel
+
+# Try to capture core dumps
+LimitCORE=infinity
+
+SyslogIdentifier=%N
+
+# No realtime CPU scheduling
+RestrictRealtime=true
+
+# Don't let us see anything in the regular system, and don't run as root
+DynamicUser=true
+ProtectSystem=strict
+ProtectHome=true
+PrivateTmp=true
+PrivateDevices=true
+PrivateUsers=true
+
+# No network access
+PrivateNetwork=true
+ProtectHostname=true
+RestrictAddressFamilies=none
+IPAddressDeny=any
+
+# Don't let the program mess with the kernel configuration at all
+ProtectKernelLogs=true
+ProtectKernelModules=true
+ProtectKernelTunables=true
+ProtectControlGroups=true
+ProtectProc=invisible
+RestrictNamespaces=true
+RestrictFileSystems=
+
+# Hide everything in /proc, even /proc/mounts
+ProcSubset=pid
+
+# Only allow the default personality Linux
+LockPersonality=true
+
+# No writable memory pages
+MemoryDenyWriteExecute=true
+
+# Don't let our mounts leak out to the host
+PrivateMounts=true
+
+# Restrict system calls to the native arch and only enough to get things going
+SystemCallArchitectures=native
+SystemCallFilter=@system-service
+SystemCallFilter=~@privileged
+SystemCallFilter=~@resources
+
+SystemCallFilter=~@clock
+SystemCallFilter=~@cpu-emulation
+SystemCallFilter=~@debug
+SystemCallFilter=~@module
+SystemCallFilter=~@reboot
+SystemCallFilter=~@swap
+
+SystemCallFilter=~@mount
+
+# libfuse io_uring wants to pin cores and memory
+SystemCallFilter=mbind
+SystemCallFilter=sched_setaffinity
+
+# Leave a breadcrumb if we get whacked by the system call filter
+SystemCallErrorNumber=EL3RST
+
+# Log to the kernel dmesg, just like an in-kernel ext4 driver
+StandardOutput=append:/dev/ttyprintk
+StandardError=append:/dev/ttyprintk
+
+# Run with no capabilities at all
+CapabilityBoundingSet=
+AmbientCapabilities=
+NoNewPrivileges=true
+
+# fuse4fs doesn't create files
+UMask=7777
+
+# No access to hardware /dev files at all
+ProtectClock=true
+DevicePolicy=closed
+
+# Don't mess with set[ug]id anything.
+RestrictSUIDSGID=true
+
+# Don't let OOM kills of processes in this containment group kill the whole
+# service, because we don't want filesystem drivers to go down.
+OOMPolicy=continue
+OOMScoreAdjust=-1000
diff --git a/lib/config.h.in b/lib/config.h.in
index abba5e2c625b24..15b99c6d28c59e 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -142,6 +142,9 @@
 /* Define to 1 if you have the 'ftruncate64' function. */
 #undef HAVE_FTRUNCATE64
 
+/* Define to 1 if fuse4fs should be built with fuse service support */
+#undef HAVE_FUSE4FS_SERVICE
+
 /* Define to 1 if fuse supports cache_readdir */
 #undef HAVE_FUSE_CACHE_READDIR
 
@@ -151,6 +154,9 @@
 /* Define to 1 if fuse supports lowlevel API */
 #undef HAVE_FUSE_LOWLEVEL
 
+/* Define to 1 if fuse supports service */
+#undef HAVE_FUSE_SERVICE
+
 /* Define to 1 if you have the 'futimes' function. */
 #undef HAVE_FUTIMES
 
diff --git a/util/subst.conf.in b/util/subst.conf.in
index 5af5e356d46ac7..3d0ec5cc39eabd 100644
--- a/util/subst.conf.in
+++ b/util/subst.conf.in
@@ -24,3 +24,6 @@ root_bindir		@root_bindir@
 libdir			@libdir@
 $exec_prefix		@exec_prefix@
 pkglibexecdir		@libexecdir@/e2fsprogs
+bindir			@bindir@
+fuse_service_socket_dir	@fuse_service_socket_dir@
+fuse_service_socket_perms	@fuse_service_socket_perms@

