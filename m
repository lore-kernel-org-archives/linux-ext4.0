Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3249132C924;
	Wed, 22 Apr 2026 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900646; cv=none; b=T8TvcwsWy20Ut3NydeVhADIptPL2CMA2Dch6oP8TglZPbUGv2ufl/E/vOILz5iDhhxKGyukmBCrrfpaTML5tAVilZXymwY9DuNbBbMGF7GqTu/sxywPJgNyUJJvh7eW1tgDxtVKRPfHjgi8wzqVWexzx7pwZPs9asfAaqzB9+a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900646; c=relaxed/simple;
	bh=9L1HZddCQvHV5SFhUNt3RFhZ1S7dl1qZFSJrU3Edfvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXBOumcxJfr8KG1R6ESntX/846VdxvWRwVrelgX6BX1rNi3C5s2KAGM/o3k2/hijYLmDd0rcIKfp0zocgqoRuZgxCWgj7dXh6ObPF12ztmBa4FoCoc2Sxw8FjnSo8MKsXIb8XYxHrWTwgTzzqQH8xOewW4J4jXmkg6uiK1ZMoe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWMx9UDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWMx9UDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03476C2BCB6;
	Wed, 22 Apr 2026 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900646;
	bh=9L1HZddCQvHV5SFhUNt3RFhZ1S7dl1qZFSJrU3Edfvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TWMx9UDI//YRmBNyNzbg+CW/rv9jJgSkkrDZIcjoSklP2R/NSyYiJ4800MaPKFPR6
	 euVQzuPrhNfDaAo279Wfgoq8+X9v+AWmU6aE3dR8ou2j7hu8hAxNa9mj6Sy6oM1fqA
	 a5L8pw8wExA1me+TTmOaWfuf0N9HgjICir4nScd7NAM28rb4DgTlR2NSoG4OfwGbpy
	 GPm1BWY1eDgyPvCZCUbjChYLz2cYP7Io3ZxLwQwRF3lOgsn2sbwip3wAqEm8AvrfxX
	 jmXf/e6xA0+0zA9leA2owpjJePDmwZOzpy8OL4VlwB7dsie4tj3Drk56aDb9tOuJBo
	 BAIQaYVus5C1g==
Date: Wed, 22 Apr 2026 16:30:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, demiobenour@gmail.com
Subject: [RFC PATCH 2/4] exfat: enable fuse systemd service mode
Message-ID: <20260422233045.GH7739@frogsfrogsfrogs>
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

Enable use of exfat as a contained systemd service.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libexfat/exfat.h       |    3 +
 configure.ac           |  150 ++++++++++++++++++++++++++++++++++++++++++++++++
 fuse/Makefile.am       |   16 +++++
 fuse/exfat.socket.in   |   15 +++++
 fuse/exfat@.service.in |  102 +++++++++++++++++++++++++++++++++
 fuse/main.c            |  131 ++++++++++++++++++++++++++++++++++++++++--
 libexfat/io.c          |   21 ++++++-
 libexfat/mount.c       |   19 +++++-
 8 files changed, 447 insertions(+), 10 deletions(-)
 create mode 100644 fuse/exfat.socket.in
 create mode 100644 fuse/exfat@.service.in

diff --git a/libexfat/exfat.h b/libexfat/exfat.h
index 9b9a682844c093..3023ecd53acd5b 100644
--- a/libexfat/exfat.h
+++ b/libexfat/exfat.h
@@ -147,6 +147,7 @@ void exfat_warn(const char* format, ...) PRINTF;
 void exfat_debug(const char* format, ...) PRINTF;
 
 struct exfat_dev* exfat_open(const char* spec, enum exfat_mode mode);
+struct exfat_dev* exfat_fdopen(int fd, const char* spec, enum exfat_mode mode);
 int exfat_close(struct exfat_dev* dev);
 int exfat_fsync(struct exfat_dev* dev);
 enum exfat_mode exfat_get_mode(const struct exfat_dev* dev);
@@ -225,6 +226,8 @@ int exfat_set_label(struct exfat* ef, const char* label);
 
 int exfat_soil_super_block(const struct exfat* ef);
 int exfat_mount(struct exfat* ef, const char* spec, const char* options);
+int exfat_mount_from(struct exfat* ef, int fd, const char* spec,
+		     const char* options);
 void exfat_unmount(struct exfat* ef);
 
 time_t exfat_exfat2unix(le16_t date, le16_t time, uint8_t centisec,
diff --git a/configure.ac b/configure.ac
index ee62b88931b738..63e7327f7ee651 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,7 +32,7 @@ AM_PROG_AR
 AC_SYS_LARGEFILE
 AC_CANONICAL_HOST
 PKG_CHECK_MODULES([FUSE3], [fuse3],
-  [AC_DEFINE([FUSE_USE_VERSION], [30], [Required FUSE API version.])],
+  [have_fuse3_pkg=yes ; AC_DEFINE([FUSE_USE_VERSION], [319], [Required FUSE API version.])],
   [PKG_CHECK_MODULES([FUSE2], [fuse >= 2.6],
     [AC_DEFINE([FUSE_USE_VERSION], [26], [Required FUSE API version.])])])
 AC_MSG_CHECKING([whether host-specific configuration is needed for $host_os])
@@ -55,6 +55,154 @@ case "$host_os" in
     AC_MSG_RESULT([no])
 	;;
 esac
+
+
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
+	CFLAGS="$CFLAGS $FUSE3_CFLAGS"
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
+AC_MSG_CHECKING([for exfat-fuse service support and systemd])
+AS_IF([test "${FUSE4FS_CMT}${have_fuse_service}${have_systemd}" = "yesyes"],
+      [
+           AC_MSG_RESULT(yes)
+           AC_DEFINE(HAVE_EXFAT_FUSE_SERVICE, 1,
+                     [Define to 1 if exfat should be built with fuse service support])
+           have_exfat_service=yes
+           AM_CONDITIONAL(HAVE_EXFAT_FUSE_SERVICE, [true])
+      ],
+      [
+           AC_MSG_RESULT(no)
+           AM_CONDITIONAL(HAVE_EXFAT_FUSE_SERVICE, [false])
+           have_exfat_service=no
+      ]
+)
+AC_SUBST(have_exfat_service)
+
 AC_CONFIG_HEADERS([libexfat/config.h])
 AC_CONFIG_FILES([
 	libexfat/Makefile
diff --git a/fuse/Makefile.am b/fuse/Makefile.am
index 09c8cac9f5d0ec..660b23ce1965fc 100644
--- a/fuse/Makefile.am
+++ b/fuse/Makefile.am
@@ -27,6 +27,22 @@ mount_exfat_fuse_CPPFLAGS = -imacros $(top_srcdir)/libexfat/config.h
 mount_exfat_fuse_CFLAGS = $(FUSE2_CFLAGS) $(FUSE3_CFLAGS) $(UBLIO_CFLAGS)
 mount_exfat_fuse_LDADD = $(top_srcdir)/libexfat/libexfat.a $(FUSE2_LIBS) $(FUSE3_LIBS) $(UBLIO_LIBS)
 
+if HAVE_EXFAT_FUSE_SERVICE
+bin_SCRIPTS = exfat.socket exfat@.service
+endif
+
+exfat.socket: exfat.socket.in
+	sed \
+		-e "s|@FUSE3_SERVICE_SOCKET_DIR@|$(fuse_service_socket_dir)|g" \
+		-e "s|@FUSE3_SERVICE_SOCKET_PERMS@|$(fuse_service_socket_perms)|g" \
+		< $< > $@
+
+exfat@.service: exfat@.service.in
+	sed -e "s|@SBINDIR@|$(sbindir)|g" \
+		   < $< > $@
+
+EXTRA_PROGRAMS=$(SERVICE_FILES)
+
 install-exec-hook:
 	ln -sf $(sbin_PROGRAMS) $(DESTDIR)$(sbindir)/mount.exfat
 
diff --git a/fuse/exfat.socket.in b/fuse/exfat.socket.in
new file mode 100644
index 00000000000000..8a957ad700fc16
--- /dev/null
+++ b/fuse/exfat.socket.in
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for exfat Service
+
+[Socket]
+ListenSequentialPacket=@FUSE3_SERVICE_SOCKET_DIR@/exfat
+Accept=yes
+SocketMode=@FUSE3_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/fuse/exfat@.service.in b/fuse/exfat@.service.in
new file mode 100644
index 00000000000000..9b7855fe524de6
--- /dev/null
+++ b/fuse/exfat@.service.in
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=exfat Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/@SBINDIR@/mount.exfat-fuse
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
diff --git a/fuse/main.c b/fuse/main.c
index cf1033a543f038..d7aa8d21db62e3 100644
--- a/fuse/main.c
+++ b/fuse/main.c
@@ -34,6 +34,10 @@
 #include <sys/types.h>
 #include <pwd.h>
 #include <unistd.h>
+#ifdef HAVE_EXFAT_FUSE_SERVICE
+# include <sys/mount.h>
+# include <fuse_service.h>
+#endif
 
 #ifndef DEBUG
 	#define exfat_debug(format, ...) do {} while (0)
@@ -45,6 +49,102 @@
 
 struct exfat ef;
 
+#ifdef HAVE_EXFAT_FUSE_SERVICE
+static struct fuse_service *service;
+static int bdev_fd = -1;
+
+static inline bool fuse_exfat_is_service(void)
+{
+	return fuse_service_accepted(service);
+}
+
+static int fuse_exfat_service_connect(struct fuse_args *args)
+{
+	int ret;
+
+	ret = fuse_service_accept(&service);
+	if (ret)
+		return ret;
+
+	if (fuse_service_accepted(service))
+		return fuse_service_append_args(service, args);
+
+	return 0;
+}
+
+static int fuse_exfat_service_get_config(const char *device, bool ro)
+{
+	int open_flags = 0; /* fuseblk server means we can't open exclusive */
+	int fd;
+	int ret;
+
+	if (ro)
+		open_flags |= O_RDONLY;
+	else
+		open_flags |= O_SYNC | O_RDWR;
+
+	ret = fuse_service_request_file(service, device, open_flags, 0, 0);
+	if (ret)
+		return ret;
+
+	ret = fuse_service_receive_file(service, device, &fd);
+	if (ret)
+		return ret;
+
+	if (fd < 0) {
+		fprintf(stderr, "%s opening device: %s.\n", device,
+			   strerror(-fd));
+		return -1;
+	}
+	bdev_fd = fd;
+
+	return fuse_service_finish_file_requests(service);
+}
+
+static int fuse_exfat_service_mount(struct exfat *ef, const char *spec,
+				    const char *exfat_options)
+{
+	const int is_ro = exfat_match_option(exfat_options, "ro");
+	int rc;
+
+	rc = fuse_exfat_service_get_config(spec, is_ro);
+	if (rc)
+		return EXIT_FAILURE;
+
+	return exfat_mount_from(ef, bdev_fd, spec, exfat_options);
+}
+
+static int fuse_exfat_service_main(char **argv,
+				   const struct fuse_operations *ops)
+{
+	struct fuse_args args = FUSE_ARGS_INIT(0, argv);
+	char **p = argv;
+
+	while (*(p++) != NULL)
+		args.argc++;
+
+	fuse_service_expect_mount_format(service, S_IFDIR);
+	return fuse_service_main(service, &args, ops, NULL);
+}
+
+static int fuse_exfat_service_finish(int exitcode)
+{
+	if (!fuse_exfat_is_service())
+		return exitcode;
+
+	fuse_service_send_goodbye(service, exitcode);
+	fuse_service_destroy(&service);
+
+	return fuse_service_exit(exitcode);
+}
+#else
+# define fuse_exfat_is_service(...)		(false)
+# define fuse_exfat_service_connect(...)	(0)
+# define fuse_exfat_service_mount(...)		(1)
+# define fuse_exfat_service_main(...)		(1)
+# define fuse_exfat_service_finish(ret)		(ret)
+#endif /* HAVE_EXFAT_FUSE_SERVICE */
+
 static struct exfat_node* get_node(const struct fuse_file_info* fi)
 {
 	return (struct exfat_node*) (size_t) fi->fh;
@@ -529,6 +629,12 @@ static char* add_user_option(char* options)
 
 	if (getuid() == 0)
 		return options;
+	if (fuse_exfat_is_service()) {
+		options = add_option(options, "uid", "0");
+		if (!options)
+			return NULL;
+		return add_option(options, "gid", "0");
+	}
 
 	pw = getpwuid(getuid());
 	if (pw == NULL || pw->pw_name == NULL)
@@ -601,12 +707,17 @@ static char* add_passthrough_fuse_options(char* fuse_options,
 static int fuse_exfat_main(char* mount_options, char* mount_point)
 {
 	char* argv[] = {"exfat", "-s", "-o", mount_options, mount_point, NULL};
+
+	if (fuse_exfat_is_service())
+		return fuse_exfat_service_main(argv, &fuse_exfat_ops);
+
 	return fuse_main(sizeof(argv) / sizeof(argv[0]) - 1, argv,
 			&fuse_exfat_ops, NULL);
 }
 
 int main(int argc, char* argv[])
 {
+	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
 	const char* spec = NULL;
 	char* mount_point = NULL;
 	char* fuse_options;
@@ -633,7 +744,11 @@ int main(int argc, char* argv[])
 		return 1;
 	}
 
-	while ((opt = getopt(argc, argv, "dno:Vv")) != -1)
+	rc = fuse_exfat_service_connect(&args);
+	if (rc)
+		exit(EXIT_FAILURE);
+
+	while ((opt = getopt(args.argc, args.argv, "dno:Vv")) != -1)
 	{
 		switch (opt)
 		{
@@ -675,16 +790,20 @@ int main(int argc, char* argv[])
 			break;
 		}
 	}
-	if (argc - optind != 2)
+	if (args.argc - optind != 2)
 	{
 		free(exfat_options);
 		free(fuse_options);
 		usage(argv[0]);
 	}
-	spec = argv[optind];
-	mount_point = argv[optind + 1];
+	spec = args.argv[optind];
+	mount_point = args.argv[optind + 1];
 
-	if (exfat_mount(&ef, spec, exfat_options) != 0)
+	if (fuse_exfat_is_service())
+		rc = fuse_exfat_service_mount(&ef, spec, exfat_options);
+	else
+		rc = exfat_mount(&ef, spec, exfat_options);
+	if (rc != 0)
 	{
 		free(exfat_options);
 		free(fuse_options);
@@ -704,5 +823,5 @@ int main(int argc, char* argv[])
 	rc = fuse_exfat_main(fuse_options, mount_point);
 
 	free(fuse_options);
-	return rc;
+	return fuse_exfat_service_finish(rc);
 }
diff --git a/libexfat/io.c b/libexfat/io.c
index 7af5316da70b4b..2a4c823979a9a8 100644
--- a/libexfat/io.c
+++ b/libexfat/io.c
@@ -86,7 +86,8 @@ static int open_rw(const char* spec)
 	return fd;
 }
 
-struct exfat_dev* exfat_open(const char* spec, enum exfat_mode mode)
+static struct exfat_dev* __exfat_open(int fd, const char* spec,
+				      enum exfat_mode mode)
 {
 	struct exfat_dev* dev;
 	struct stat stbuf;
@@ -119,6 +120,10 @@ struct exfat_dev* exfat_open(const char* spec, enum exfat_mode mode)
 		return NULL;
 	}
 
+	dev->fd = fd;
+	if (dev->fd >= 0)
+		goto opened;
+
 	switch (mode)
 	{
 	case EXFAT_MODE_RO:
@@ -162,6 +167,7 @@ struct exfat_dev* exfat_open(const char* spec, enum exfat_mode mode)
 		return NULL;
 	}
 
+opened:
 	if (fstat(dev->fd, &stbuf) != 0)
 	{
 		close(dev->fd);
@@ -284,6 +290,19 @@ struct exfat_dev* exfat_open(const char* spec, enum exfat_mode mode)
 	return dev;
 }
 
+struct exfat_dev* exfat_open(const char* spec, enum exfat_mode mode)
+{
+	return __exfat_open(-1, spec, mode);
+}
+
+struct exfat_dev* exfat_fdopen(int fd, const char* spec, enum exfat_mode mode)
+{
+	if (fd < 0)
+		return NULL;
+
+	return __exfat_open(fd, spec, mode);
+}
+
 int exfat_close(struct exfat_dev* dev)
 {
 	int rc = 0;
diff --git a/libexfat/mount.c b/libexfat/mount.c
index 86fb84db2445f5..dd6cf707d2ebbc 100644
--- a/libexfat/mount.c
+++ b/libexfat/mount.c
@@ -180,7 +180,8 @@ static void exfat_free(struct exfat* ef)
 	ef->sb = NULL;
 }
 
-int exfat_mount(struct exfat* ef, const char* spec, const char* options)
+static int __exfat_mount(struct exfat* ef, int fd, const char* spec,
+			 const char* options)
 {
 	int rc;
 	enum exfat_mode mode;
@@ -196,7 +197,10 @@ int exfat_mount(struct exfat* ef, const char* spec, const char* options)
 		mode = EXFAT_MODE_ANY;
 	else
 		mode = EXFAT_MODE_RW;
-	ef->dev = exfat_open(spec, mode);
+	if (fd >= 0)
+		ef->dev = exfat_fdopen(fd, spec, mode);
+	else
+		ef->dev = exfat_open(spec, mode);
 	if (ef->dev == NULL)
 		return -ENODEV;
 	if (exfat_get_mode(ef->dev) == EXFAT_MODE_RO)
@@ -340,6 +344,17 @@ int exfat_mount(struct exfat* ef, const char* spec, const char* options)
 	return -EIO;
 }
 
+int exfat_mount_from(struct exfat* ef, int fd, const char* spec,
+		     const char* options)
+{
+	return __exfat_mount(ef, fd, spec, options);
+}
+
+int exfat_mount(struct exfat* ef, const char* spec, const char* options)
+{
+	return __exfat_mount(ef, -1, spec, options);
+}
+
 static void finalize_super_block(struct exfat* ef)
 {
 	if (ef->ro)
