Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51BE301472;
	Wed, 22 Apr 2026 23:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900741; cv=none; b=SR9qniIOJ+gYOS8HEMUZgULI0nmibROn012re1NWe6K7kF/ftJ7IVRv5BqCS2MmXs7jKmnnkw8KxOK1Ktq35NSGesn68baLbIVVEuSM+JUPuaLduUoWtSNkOnKXmTmHOOy4Pw/wnkm5a2cKTIIcHcAJLT8CoshcBvajnLXUXHdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900741; c=relaxed/simple;
	bh=WwnC7XitwZWKv4lRazmoyJetBh+19Er4i2EDf+JnNfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qvp9C76acXsbpnJs2fDYu9HWhiM3B1iHGuR5EG24E9vtRMunSsUtPPw+BwoU6BjIYGnydoJ+GCEXZbUwimLXaodRXFRjJfvvZSFxgjJMAoQq/IHrj0O6xbw0W3P0mG5SVeqV4XnZglR2RBunyW1Mwml1Ye1KGw1Wg8xevFbTkHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORliHy3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORliHy3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EEEC19425;
	Wed, 22 Apr 2026 23:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900740;
	bh=WwnC7XitwZWKv4lRazmoyJetBh+19Er4i2EDf+JnNfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ORliHy3ioGXo3PgiRUVurWuBUrYoLjtAXXlw0Sv1r+oscSzizAVkPV1n6ZYgST/TY
	 y2zOviz0ZrFTNaDsghG+PrD5VDyLLZdTr0rPWOvYhqlT0f0/Xl6CRRfFXXXzK5uncf
	 NawY2uVRsLFDAReHYBlXOz30RZkIXRddjHonI+gVgqFWcXisLfG5psERT+5U3fVEaN
	 EtFjwNqTenhc06Ud77aSkXfk85cMREp2YOgArBx6b3UomGrkY1/+IZ3N/cKM+6j21e
	 wN0+//WShnS48GNC9ZRp9AkquLJ9NEFuhG7NffMkWAdrChBiVrzraOO+RKRIXscOJA
	 eD2NM1tkV+5Ug==
Date: Wed, 22 Apr 2026 16:32:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, demiobenour@gmail.com
Subject: [RFC PATCH 3/4] fuseiso: enable systemd service mode
Message-ID: <20260422233220.GI7739@frogsfrogsfrogs>
References: <20260422231518.GA7717@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422231518.GA7717@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Enable use of fuseiso as a contained fuse service.  This is a patch
against the Debian package, which was ported to fuse3.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/isofs.h             |    2 -
 configure.in            |  148 +++++++++++++++++++++++++++++++++++++++++++++++
 src/Makefile.am         |   16 +++++
 src/fuseiso.c           |  134 +++++++++++++++++++++++++++++++++++++------
 src/fuseiso.socket.in   |   16 +++++
 src/fuseiso@.service.in |  102 ++++++++++++++++++++++++++++++++
 6 files changed, 398 insertions(+), 20 deletions(-)
 create mode 100644 src/fuseiso.socket.in
 create mode 100644 src/fuseiso@.service.in

diff --git a/src/isofs.h b/src/isofs.h
index 3755e886c9ccc2..b765baf209d77e 100644
--- a/src/isofs.h
+++ b/src/isofs.h
@@ -25,7 +25,7 @@
 #include <linux/iso_fs.h>
 #include <linux/rock.h>
 
-#define FUSE_USE_VERSION 314
+#define FUSE_USE_VERSION 319
 #include <fuse.h>
 
 typedef struct _isofs_context {
diff --git a/configure.in b/configure.in
index 9692dc114bfd73..30e2726cea8f2f 100644
--- a/configure.in
+++ b/configure.in
@@ -7,7 +7,153 @@ AC_LANG_C
 AC_PROG_CC
 AM_PROG_LIBTOOL
 
-PKG_CHECK_MODULES([FUSE],[fuse3 >= 3.14.0],[],[AC_MSG_ERROR([libfuse3 is required])])
+PKG_CHECK_MODULES([FUSE],[fuse3 >= 3.19.0],[have_fuse3_pkg=yes],[AC_MSG_ERROR([libfuse3 is required])])
 PKG_CHECK_MODULES([GLIB],[glib-2.0],[],[AC_MSG_ERROR([glib-2.0 is required])])
 
+dnl
+dnl Check if the FUSE library tells us where to put fs service sockets
+dnl
+have_fuse_service=
+fuse_service_socket_dir=
+if test -n "$have_fuse3_pkg"
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
+
+	AC_MSG_CHECKING([for fuse_service_accept in libfuse])
+	old_cflags="$CFLAGS"
+	CFLAGS="$CFLAGS $FUSE_CFLAGS"
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
+	CFLAGS="$old_cflags"
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
+dnl
+dnl Where do systemd services go?
+dnl
+AC_ARG_WITH([systemd_unit_dir],
+  [AS_HELP_STRING([--with-systemd-unit-dir@<:@=DIR@:>@],
+	[Install systemd system units into DIR.])],
+  [],
+  [with_systemd_unit_dir=yes])
+AS_IF([test "x${with_systemd_unit_dir}" != "xno"],
+  [
+	AS_IF([test "x${with_systemd_unit_dir}" = "xyes"],
+	  [
+		PKG_CHECK_MODULES([systemd], [systemd],
+		  [
+			with_systemd_unit_dir="$($PKG_CONFIG --variable=systemdsystemunitdir systemd)"
+		  ], [
+			with_systemd_unit_dir=""
+		  ])
+		m4_pattern_allow([^PKG_(MAJOR|MINOR|BUILD|REVISION)$])
+	  ])
+	AC_MSG_CHECKING([for systemd system unit dir])
+	systemd_system_unit_dir="${with_systemd_unit_dir}"
+	AS_IF([test -n "${systemd_system_unit_dir}"],
+	  [
+		AC_MSG_RESULT(${systemd_system_unit_dir})
+		have_systemd="yes"
+	  ],
+	  [
+		AC_MSG_RESULT(no)
+		have_systemd="no"
+	  ])
+  ],
+  [
+	have_systemd="disabled"
+  ])
+AC_SUBST(have_systemd)
+AC_SUBST(systemd_system_unit_dir)
+
+AC_MSG_CHECKING([for fuseiso service support and systemd])
+AS_IF([test "${FUSE4FS_CMT}${have_fuse_service}${have_systemd}" = "yesyes"],
+      [
+           AC_MSG_RESULT(yes)
+           AC_DEFINE(HAVE_FUSEISO_FUSE_SERVICE, 1,
+                     [Define to 1 if fuseiso should be built with fuse service support])
+           have_fuseiso_fuse_service=yes
+           AM_CONDITIONAL(HAVE_FUSEISO_FUSE_SERVICE, [true])
+      ],
+      [
+           AC_MSG_RESULT(no)
+           AM_CONDITIONAL(HAVE_FUSEISO_FUSE_SERVICE, [false])
+           have_fuseiso_fuse_service=no
+      ]
+)
+AC_SUBST(have_fuseiso_service)
+
 AC_OUTPUT(Makefile src/Makefile zAppRun/Makefile)
diff --git a/src/Makefile.am b/src/Makefile.am
index cb05da8cd1653c..97cded13a71c96 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,4 +8,20 @@ INCLUDES= $(all_includes)
 fuseiso_LDFLAGS = $(all_libraries) $(FUSE_LIBS) $(GLIB_LIBS) -lz
 noinst_HEADERS = isofs.h
 
+if HAVE_FUSEISO_FUSE_SERVICE
+bin_SCRIPTS = fuseiso.socket fuseiso@.service
+endif
+
+fuseiso.socket: fuseiso.socket.in
+	sed \
+		-e "s|@FUSE3_SERVICE_SOCKET_DIR@|$(fuse_service_socket_dir)|g" \
+		-e "s|@FUSE3_SERVICE_SOCKET_PERMS@|$(fuse_service_socket_perms)|g" \
+		< $< > $@
+
+fuseiso@.service: fuseiso@.service.in
+	sed -e "s|@BINDIR@|$(bindir)|g" \
+		   < $< > $@
+
+EXTRA_PROGRAMS=$(SERVICE_FILES)
+
 AM_CFLAGS = -D_FILE_OFFSET_BITS=64 $(FUSE_CFLAGS) $(GLIB_CFLAGS) -Wall
diff --git a/src/fuseiso.c b/src/fuseiso.c
index 47b94c72161c5f..46b2a61429074b 100644
--- a/src/fuseiso.c
+++ b/src/fuseiso.c
@@ -38,12 +38,16 @@
 
 #include <linux/iso_fs.h>
 
-#define FUSE_USE_VERSION 314
+#define FUSE_USE_VERSION 319
 #include <fuse.h>
 
 #include <zlib.h>
 #include <locale.h>
 #include <langinfo.h>
+#ifdef HAVE_FUSEISO_FUSE_SERVICE
+# include <sys/mount.h>
+# include <fuse_service.h>
+#endif
 
 #include "isofs.h"
 
@@ -61,6 +65,78 @@ int maintain_mount_point;
 int maintain_mtab;
 char* iocharset;
 
+#ifdef HAVE_FUSEISO_FUSE_SERVICE
+static struct fuse_service *service;
+
+static inline bool isofs_is_service(void)
+{
+    return fuse_service_accepted(service);
+}
+
+static int isofs_service_connect(struct fuse_args *args)
+{
+    int ret;
+
+    ret = fuse_service_accept(&service);
+    if (ret)
+        return ret;
+
+    if (fuse_service_accepted(service))
+        return fuse_service_append_args(service, args);
+
+    return 0;
+}
+
+static int isofs_service_get_config(const char *device, int *fdp)
+{
+    int fd;
+    int ret;
+
+    ret = fuse_service_request_file(service, device, O_RDONLY, 0, 0);
+    if (ret)
+        return ret;
+
+    ret = fuse_service_receive_file(service, device, &fd);
+    if (ret)
+        return ret;
+
+    if (fd < 0) {
+        fprintf(stderr, "%s opening device: %s.\n", device,
+                strerror(-fd));
+        return -1;
+    }
+    *fdp = fd;
+
+    return fuse_service_finish_file_requests(service);
+}
+
+static int isofs_service_main(int fuseopts_cnt, char **fuseopts,
+                              const struct fuse_operations *ops)
+{
+    struct fuse_args args = FUSE_ARGS_INIT(fuseopts_cnt, fuseopts);
+
+    fuse_service_expect_mount_format(service, S_IFDIR);
+    return fuse_service_main(service, &args, ops, NULL);
+}
+
+static int isofs_service_finish(int exitcode)
+{
+    if (!isofs_is_service())
+        return exitcode;
+
+    fuse_service_send_goodbye(service, exitcode);
+    fuse_service_destroy(&service);
+
+    return fuse_service_exit(exitcode);
+}
+#else
+# define isofs_is_service(...)		(false)
+# define isofs_service_connect(...)	(0)
+# define isofs_service_get_config(...)	(EOPNOTSUPP)
+# define isofs_service_main(...)	(1)
+# define isofs_service_finish(ret)	(ret)
+#endif /* HAVE_FUSEISO_FUSE_SERVICE */
+
 char* normalize_name(const char* fname) {
     char* abs_fname = (char *) malloc(PATH_MAX);
     realpath(fname, abs_fname);
@@ -305,6 +381,8 @@ void usage(const char* prog) {
 
 int main(int argc, char *argv[])
 {
+    struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
+
     setlocale(LC_ALL, ""); // set current locale for proper iocharset
     
     // defaults
@@ -315,10 +393,15 @@ int main(int argc, char *argv[])
     char **fuseopts = reallocarray(NULL, 1, sizeof(*fuseopts));
     fuseopts[0] = argv[0];
     size_t fuseopts_cnt = 1;
+    int rc;
+
+    rc = isofs_service_connect(&args);
+    if (rc)
+        exit(EXIT_FAILURE);
     
     int c;
     char *s;
-    while((c = getopt(argc, argv, "+npc:ho:sfdV")) > 0) {
+    while((c = getopt(args.argc, args.argv, "+npc:ho:sfdV")) > 0) {
         switch((char)c) {
             case 'n':
                 maintain_mtab = 0;
@@ -361,26 +444,35 @@ int main(int argc, char *argv[])
         };
     };
     
-    if((argc - optind) < 2) {
+    if((args.argc - optind) < 2) {
         usage(argv[0]);
         exit(EXIT_FAILURE);
     };
     
-    imagefile = normalize_name(argv[optind++]);
+    imagefile = normalize_name(args.argv[optind++]);
+
+    if (isofs_is_service()) {
+        maintain_mtab = 0;
+        maintain_mount_point = 0;
+
+        rc = isofs_service_get_config(imagefile, &image_fd);
+        if (rc || image_fd < 0)
+            exit(EXIT_FAILURE);
+    } else {
+        image_fd = open(imagefile, O_RDONLY);
+        if(image_fd == -1) {
+            fprintf(stderr, "Supplied image file name: \"%s\"\n", imagefile);
+            perror("Can`t open image file");
+            exit(EXIT_FAILURE);
+        };
+    }
     
-    image_fd = open(imagefile, O_RDONLY);
-    if(image_fd == -1) {
-        fprintf(stderr, "Supplied image file name: \"%s\"\n", imagefile);
-        perror("Can`t open image file");
-        exit(EXIT_FAILURE);
-    };
+    mount_point = normalize_name(args.argv[optind]);
     
-    mount_point = normalize_name(argv[optind]);
+    fuseopts = reallocarray(fuseopts, fuseopts_cnt + args.argc - optind, sizeof(*fuseopts));
     
-    fuseopts = reallocarray(fuseopts, fuseopts_cnt + argc - optind, sizeof(*fuseopts));
-    
-    while(optind < argc) {
-        fuseopts[fuseopts_cnt++] = argv[optind++];
+    while(optind < args.argc) {
+        fuseopts[fuseopts_cnt++] = args.argv[optind++];
     };
     
     if(!iocharset) {
@@ -395,7 +487,6 @@ int main(int argc, char *argv[])
         };
     };
     
-    int rc;
     if(maintain_mount_point) {
         rc = check_mount_point();
         if(rc != 0) {
@@ -412,6 +503,13 @@ int main(int argc, char *argv[])
     
     // will exit in case of failure
     rc = isofs_real_preinit(imagefile, image_fd);
-    
-    return fuse_main(fuseopts_cnt, fuseopts, &isofs_oper, NULL);
+    if (rc)
+        exit(EXIT_FAILURE);
+
+    if (isofs_is_service())
+        rc = isofs_service_main(fuseopts_cnt, fuseopts, &isofs_oper);
+    else
+        rc = fuse_main(fuseopts_cnt, fuseopts, &isofs_oper, NULL);
+
+    return isofs_service_finish(rc);
 };
diff --git a/src/fuseiso.socket.in b/src/fuseiso.socket.in
new file mode 100644
index 00000000000000..a2ea11e408fa81
--- /dev/null
+++ b/src/fuseiso.socket.in
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for fuseiso Service
+
+[Socket]
+ListenSequentialPacket=@FUSE3_SERVICE_SOCKET_DIR@/isofs
+ListenSequentialPacket=@FUSE3_SERVICE_SOCKET_DIR@/iso9660
+Accept=yes
+SocketMode=@FUSE3_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/src/fuseiso@.service.in b/src/fuseiso@.service.in
new file mode 100644
index 00000000000000..7f2d8977ccf6a9
--- /dev/null
+++ b/src/fuseiso@.service.in
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=fuseiso Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/@BINDIR@/fuseiso
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
