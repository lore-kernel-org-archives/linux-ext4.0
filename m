Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8123A3E69;
	Wed, 22 Apr 2026 23:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900591; cv=none; b=QMPjTqsbXWlHfq5SRrcTjtx6jF7UCh3hcFPXk7oULMEiNcwcaow0h6S8xXtVtm/AS9EHp5V02Wg7odXq48rQom4rbVzJyD/hmGmkrXre0szRDtYl/SPDjNa82vLVDv5ypjmvxwZZQwJS+1u05gE9KAF1e82aKLczaz7Y7qD68kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900591; c=relaxed/simple;
	bh=NCztthpEtAsgBxxVb7EYoaSvE1eJCRW1L2HMmyijlc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBoU+xybXjSJsxMg2Kb+QodvwfqZeAc4I0Op+a60Nb8IJDKQb90ttLoUoWn4IAG310s+BVTTASutuEKNw6wRU0WsPR7v373gtgWKoM1+eyb16WiKqLzHrwQpGCoLAAY4UHz7F7sVgMj3pdmH6SLYJkpURjD65DVFk8+rC+gUJv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrDBx5QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrDBx5QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACD5C19425;
	Wed, 22 Apr 2026 23:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900590;
	bh=NCztthpEtAsgBxxVb7EYoaSvE1eJCRW1L2HMmyijlc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RrDBx5QZHRo1xqE30jeGuto2AoKyZZy2k9bFbn/oE8ZLHQ52mCMo/i3XctUb9T+lz
	 f9XyLrhGxF6B7bkmcIWIqa5Alx8jEZ+hyJNCaa+8+qZ8PDYO/KVoXiVXqSO38MG8mZ
	 WTaQm723JdFCINOgsBte9Fqrh91GeMYOoGKedI7KcT4MLBP7N8uULeemzcAknoTKQc
	 J6Wqcv6qTdLcOrkB8h0N34tIWmoOWcGTHt2SK9WO6wp2LytYT9rO0aKwz51bNJR8/l
	 UcAYcKKdt5v0mXLzgK4Pa3iC6AknNK+m4usxeSwylHTah93wgt+4kEdqBn2/nSZyD+
	 P2+T6gi8jyHwg==
Date: Wed, 22 Apr 2026 16:29:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, demiobenour@gmail.com
Subject: [RFC PATCH 1/4] fusefatfs: enable fuse systemd service mode
Message-ID: <20260422232950.GG7739@frogsfrogsfrogs>
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

Enable use of fusefatfs as a contained systemd service.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 CMakeLists.txt        |   18 +++++++
 config.h.in           |    2 +
 diskio.c              |    3 +
 fusefatfs.c           |  124 ++++++++++++++++++++++++++++++++++++++++++++++---
 fusefatfs.socket.in   |   17 +++++++
 fusefatfs@.service.in |  102 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 259 insertions(+), 7 deletions(-)
 create mode 100644 fusefatfs.socket.in
 create mode 100644 fusefatfs@.service.in

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5e7d70ec85b748..473d1c451d0810 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -14,6 +14,24 @@ pkg_check_modules(FUSE fuse3)
 if(NOT FUSE_FOUND)
 	pkg_check_modules(FUSE REQUIRED fuse)
 endif()
+pkg_get_variable(FUSE3_SERVICE_SOCKET_DIR fuse3 service_socket_dir)
+pkg_get_variable(FUSE3_SERVICE_SOCKET_PERMS fuse3 service_socket_perms)
+pkg_check_modules(SYSTEMD systemd)
+if (SYSTEMD_FOUND)
+	pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemd_system_unit_dir)
+endif()
+IF ( (NOT "${FUSE3_SERVICE_SOCKET_DIR}" STREQUAL "") AND (NOT "${SYSTEMD_SYSTEM_UNIT_DIR}" STREQUAL "") )
+	message(STATUS "Found libfuse3 service socket dir: ${FUSE3_SERVICE_SOCKET_DIR}")
+	message(STATUS "Found libfuse3 service socket perms: ${FUSE3_SERVICE_SOCKET_PERMS}")
+	set(DEFINE_HAVE_FUSE_SERVICE "#define HAVE_FUSE_SERVICE")
+	configure_file(fusefatfs.socket.in ${CMAKE_BINARY_DIR}/fusefatfs.socket @ONLY)
+	configure_file(fusefatfs@.service.in ${CMAKE_BINARY_DIR}/fusefatfs@.service @ONLY)
+	message(STATUS "Found systemd system unit dir: ${SYSTEMD_SYSTEM_UNIT_DIR}")
+	install(FILES ${CMAKE_BINARY_DIR}/fusefatfs.socket
+		DESTINATION ${CMAKE_INSTALL_PREFIX}${SYSTEMD_SYSTEM_UNIT_DIR})
+	install(FILES ${CMAKE_BINARY_DIR}/fusefatfs@.service
+		DESTINATION ${CMAKE_INSTALL_PREFIX}${SYSTEMD_SYSTEM_UNIT_DIR})
+endif()
 string(REGEX REPLACE "\\..*" "" FUSE_VERSION ${FUSE_VERSION})
 
 set(CMAKE_REQUIRED_DEFINITIONS -D_FILE_OFFSET_BITS=64)
diff --git a/config.h.in b/config.h.in
index 7f916d685c1e42..e6d2e8c82b7d0c 100644
--- a/config.h.in
+++ b/config.h.in
@@ -4,5 +4,7 @@
 #define PROGNAME "@CMAKE_PROJECT_NAME@"
 #define VERSION "@CMAKE_PROJECT_VERSION@"
 
+@DEFINE_HAVE_FUSE_SERVICE@
+
 #endif
 
diff --git a/diskio.c b/diskio.c
index 122f93f3316e66..ca83a102e49b78 100644
--- a/diskio.c
+++ b/diskio.c
@@ -41,6 +41,9 @@ DSTATUS disk_initialize (
 	struct fftab *drv = fftab_get(pdrv);
 	if (!drv) return STA_NOINIT;
 
+	if (drv->fd >= 0)
+		return RES_OK;
+
 	if (drv->flags & FFFF_RDONLY)
 		drv->fd = open(drv->path, O_RDONLY);
 	else
diff --git a/fusefatfs.c b/fusefatfs.c
index 248f5c3a8a37c8..376f6cd1c338dd 100644
--- a/fusefatfs.c
+++ b/fusefatfs.c
@@ -20,7 +20,7 @@
 #define FUSE_USE_VERSION 29
 #define FUSE3_ONLY(...)
 #else
-#define FUSE_USE_VERSION FUSE_MAKE_VERSION(3, 14)
+#define FUSE_USE_VERSION FUSE_MAKE_VERSION(3, 19)
 #define FUSE3_ONLY(...) __VA_ARGS__
 #endif
 
@@ -37,6 +37,11 @@
 #include <fftable.h>
 #include <config.h>
 
+#ifdef HAVE_FUSE_SERVICE
+# include <sys/mount.h>
+# include <fuse_service.h>
+#endif
+
 int fuse_reentrant_tag = 0;
 
 #if FF_DEFINED == 80286
@@ -52,6 +57,96 @@ static pthread_mutex_t fff_mutex = PTHREAD_MUTEX_INITIALIZER;
 #define mutex_out() pthread_mutex_unlock(&fff_mutex)
 #define mutex_out_return(RETVAL) do {mutex_out(); return(RETVAL); } while (0)
 
+#ifdef HAVE_FUSE_SERVICE
+static struct fuse_service *service;
+static int bdev_fd = -1;
+
+static inline bool fff_is_service(void)
+{
+	return fuse_service_accepted(service);
+}
+
+static int fff_service_connect(struct fuse_args *args)
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
+static int fff_service_get_config(const char *device, bool ro,
+				  struct stat *sbuf)
+{
+	int open_flags = O_EXCL;
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
+	ret = fuse_service_finish_file_requests(service);
+	if (ret)
+		return ret;
+
+	return fstat(bdev_fd, sbuf);
+}
+
+static void fff_service_assign_bdev(struct fftab *ffentry)
+{
+	if (fff_is_service())
+		ffentry->fd = bdev_fd;
+}
+
+static int fff_service_main(struct fuse_args *args,
+			    const struct fuse_operations *ops,
+			    struct fftab *data)
+{
+	fuse_service_expect_mount_format(service, S_IFDIR);
+	return fuse_service_main(service, args, ops, data);
+}
+
+static int fff_service_finish(int exitcode)
+{
+	if (!fff_is_service())
+		return exitcode;
+
+	fuse_service_send_goodbye(service, exitcode);
+	fuse_service_destroy(&service);
+
+	return fuse_service_exit(exitcode);
+}
+#else
+# define fff_is_service(...)			(false)
+# define fff_service_connect(...)		(0)
+# define fff_service_get_config(...)		(EOPNOTSUPP)
+# define fff_service_assign_bdev(...)		((void)0)
+# define fff_service_main(...)			(1)
+# define fff_service_finish(ret)		(ret)
+#endif /* HAVE_FUSE_SERVICE */
+
 #define fffpath(index, path) \
   *fffpath; \
   ssize_t __fffpathlen = (index == 0) ? 0 : strlen(path) + 3; \
@@ -423,6 +518,9 @@ static struct fftab *fff_init(const char *source, int codepage, int flags) {
 	if (index >= 0) {
 		struct fftab *ffentry = fftab_get(index);
 		char sdrv[12];
+
+		fff_service_assign_bdev(ffentry);
+
 		snprintf(sdrv, 12, "%d:", index);
 		FRESULT fres = f_mount(&ffentry->fs, sdrv, 1);
 		if (fres != FR_OK) {
@@ -531,10 +629,10 @@ fff_opt_proc(void *data, const char *arg, int key, struct fuse_args *outargs)
 			return 1;
 		case FUSE_OPT_KEY_NONOPT:
 			if (!options->source) {
-				options->source = arg;
+				options->source = strdup(arg);
 				return 0;
 			} else if(!options->mountpoint) {
-				options->mountpoint = arg;
+				options->mountpoint = strdup(arg);
 				return 1;
 			} else
 				return -1;
@@ -565,6 +663,11 @@ int main(int argc, char *argv[])
 	int flags = 0;
 	struct stat sbuf;
 	putenv("TZ=UTC0");
+
+	err = fff_service_connect(&args);
+	if (err)
+		exit(1);
+
 	if (fuse_opt_parse(&args, &options, fff_opts, fff_opt_proc) == -1) {
 		fuse_opt_free_args(&args);
 		return -1;
@@ -585,7 +688,11 @@ int main(int argc, char *argv[])
 		goto returnerr;
 	}
 
-	if (stat(options.source, &sbuf) < 0) {
+	if (fff_is_service())
+		err = fff_service_get_config(options.source, options.ro, &sbuf);
+	else
+		err = stat(options.source, &sbuf);
+	if (err < 0) {
 		fprintf(stderr, "%s: %s\n", options.source, strerror(errno));
 		goto returnerr;
 	}
@@ -600,12 +707,15 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "Fuse init error\n");
 		goto returnerr;
 	}
-	err = fuse_main(args.argc, args.argv, &fusefat_ops, ffentry);
+	if (fff_is_service())
+		err = fff_service_main(&args, &fusefat_ops, ffentry);
+	else
+		err = fuse_main(args.argc, args.argv, &fusefat_ops, ffentry);
 	fff_destroy(ffentry);
 	fuse_opt_free_args(&args);
 	if (err) fprintf(stderr, "Fuse error %d\n", err);
-	return err;
+	return fff_service_finish(err);
 returnerr:
 	fuse_opt_free_args(&args);
-	return -1;
+	return fff_service_finish(-1);
 }
diff --git a/fusefatfs.socket.in b/fusefatfs.socket.in
new file mode 100644
index 00000000000000..3512b3570d6178
--- /dev/null
+++ b/fusefatfs.socket.in
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for fusefatfs Service
+
+[Socket]
+ListenSequentialPacket=@FUSE3_SERVICE_SOCKET_DIR@/vfat
+ListenSequentialPacket=@FUSE3_SERVICE_SOCKET_DIR@/msdos
+ListenSequentialPacket=@FUSE3_SERVICE_SOCKET_DIR@/fat
+Accept=yes
+SocketMode=@FUSE3_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/fusefatfs@.service.in b/fusefatfs@.service.in
new file mode 100644
index 00000000000000..ac7c4d6cdad93a
--- /dev/null
+++ b/fusefatfs@.service.in
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=fusefatfs Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/@CMAKE_INSTALL_BINDIR@/fusefatfs
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
