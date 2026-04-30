Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274493AB276;
	Thu, 30 Apr 2026 21:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583890; cv=none; b=CNlUFA5Aqcuz3W505QTMI4yX02YlJ8XMU9NMjZTUaVd4HCLPyXaF1k3ij4XzDdoO+pypTCFt7epipcw7hvVNaqullFqUfhcuL4g10uFMe5ltmQc+UBtSGvr01pox3/JXB0eFXHpzT8/5NRg+DPnuOSMKJQy6PQJOEh19igr+wjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583890; c=relaxed/simple;
	bh=j6nXSMHdW57X+7AE1hEnds7Y3Z2E3FI7sRzdiPSFlxA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqUMO6A5k6kuLIhDH65lruiemevtrAJjNAT0+9N6iFHR3C3U6sxQPWVozqpjrR7bGxvOhHEp1K1aSWRB6d5Bo5beWsVQfJST0sZs+XNbJozlsK8fp0VW5VVOIbSwDMPOIuLCORqtH8I6PU0uFfwBc0INDd6x1OB7lRqlh1GisQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSkhYwcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSkhYwcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ECBC2BCB3;
	Thu, 30 Apr 2026 21:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583889;
	bh=j6nXSMHdW57X+7AE1hEnds7Y3Z2E3FI7sRzdiPSFlxA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RSkhYwcG5VOan26+y3iV3fr6gMIqv9EFJYabMGe/IBtmD2vb4x99QqmbGaEv0CR3K
	 kcEc5M+H8w/nCE5fU6/+ukypVDPCcIOACg4AfI2B0ZpvopDYzwUQCuTAj9oohXXHtZ
	 FoOCIjpyx521yUWJPg5u8tqmsK8t1rlcjpfGD5r4QlbbK3AB9+s7MVSzRqUSoP3UVF
	 4ACBAVy9K4CIfNBWz0Qf7YqoeiwKDqXpmAwz3Y1NB1M16Fz7WqahaeAS8beSE2sgKs
	 FoLLX/O2oxlKAJvrYtIN+cP8UVGAMt+ksYLA7rUQoM9qxdXrc2bBKgO7Qk21QTv7TE
	 vonKhS3oMoLEQ==
Date: Thu, 30 Apr 2026 14:18:09 -0700
Subject: [PATCH 12/13] example/service: create a sample systemd service for a
 high-level fuse server
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363748.1314717.15016129531266257713.stgit@frogsfrogsfrogs>
In-Reply-To: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
References: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a simple high-level fuse server that can be run as a systemd
service.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 example/single_file.h        |   38 ++++++
 example/meson.build          |    6 +
 example/service_hl.c         |  240 ++++++++++++++++++++++++++++++++++++
 example/service_hl.socket.in |   15 ++
 example/service_hl@.service  |  102 +++++++++++++++
 example/service_ll.c         |    1 
 example/single_file.c        |  280 +++++++++++++++++++++++++++++++++++++++---
 7 files changed, 665 insertions(+), 17 deletions(-)
 create mode 100644 example/service_hl.c
 create mode 100644 example/service_hl.socket.in
 create mode 100644 example/service_hl@.service


diff --git a/example/single_file.h b/example/single_file.h
index 6e5d3e7c975385..290dd6051ed6f5 100644
--- a/example/single_file.h
+++ b/example/single_file.h
@@ -128,6 +128,7 @@ ssize_t single_file_pread(char *buf, size_t count, off_t pos);
 
 /* low-level fuse operation handlers */
 
+#ifdef USE_SINGLE_FILE_LL_API
 bool is_single_file_child(fuse_ino_t parent, const char *name);
 bool is_single_file_ino(fuse_ino_t ino);
 
@@ -153,5 +154,42 @@ void single_file_ll_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
 
 int reply_buf_limited(fuse_req_t req, const char *buf, size_t bufsize,
 		      off_t off, size_t maxsize);
+#endif
+
+/* high-level fuse operation handlers */
+
+#ifdef USE_SINGLE_FILE_HL_API
+bool is_single_open_file_path(const struct fuse_file_info *fi, const char *name);
+
+int single_file_hl_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
+			   off_t offset, struct fuse_file_info *fi,
+			   enum fuse_readdir_flags flags);
+
+int single_file_hl_statfs(const char *path, struct statvfs *buf);
+
+int single_file_hl_statx(const char *path, int statx_flags, int statx_mask,
+			 struct statx *stx, struct fuse_file_info *fi);
+
+int single_file_hl_getattr(const char *path, struct stat *stbuf,
+			   struct fuse_file_info *fi);
+int single_file_hl_chmod(const char *path, mode_t mode,
+			 struct fuse_file_info *fi);
+int single_file_hl_utimens(const char *path, const struct timespec ctv[2],
+			   struct fuse_file_info *fi);
+int single_file_hl_chown(const char *path, uid_t owner, gid_t group,
+			 struct fuse_file_info *fi);
+int single_file_hl_truncate(const char *path, off_t len,
+			    struct fuse_file_info *fi);
+
+int single_file_hl_opendir(const char *path, struct fuse_file_info *fi);
+int single_file_hl_open(const char *path, struct fuse_file_info *fi);
+
+int single_file_hl_fsync(const char *path, int datasync,
+			 struct fuse_file_info *fi);
+#endif
+
+#if !defined(USE_SINGLE_FILE_LL_API) && !defined(USE_SINGLE_FILE_HL_API)
+# warning USE_SINGLE_FILE_[HL]L_API not defined!
+#endif
 
 #endif /* FUSE_SINGLE_FILE_H_ */
diff --git a/example/meson.build b/example/meson.build
index e948f6ba74fdfa..19a383f7cd2c74 100644
--- a/example/meson.build
+++ b/example/meson.build
@@ -19,6 +19,12 @@ if platform.endswith('linux')
     configure_file(input: 'service_ll.socket.in',
                    output: 'service_ll.socket',
                    configuration: private_cfg)
+
+    single_file_examples += [ 'service_hl' ]
+    configure_file(input: 'service_hl.socket.in',
+                   output: 'service_hl.socket',
+                   configuration: private_cfg)
+
 endif
 
 threaded_examples = [ 'notify_inval_inode',
diff --git a/example/service_hl.c b/example/service_hl.c
new file mode 100644
index 00000000000000..ea041f670f2ec5
--- /dev/null
+++ b/example/service_hl.c
@@ -0,0 +1,240 @@
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2026 Oracle.
+ *
+ * This program can be distributed under the terms of the GNU GPLv2.
+ * See the file GPL2.txt.
+ */
+
+/** @file
+ *
+ * Minimal example filesystem using high-level API and systemd service API.
+ *
+ * - Shows how to build a high level FUSE filesystem server that can be managed
+ *   by systemd
+ * - Enables on-demand filesystem mounting via socket activation
+ * - Demonstrates requesting resources from the mount-caller's environment
+ * - Allows running FUSE servers with minimal privileges; isolated mount,
+ *   network, and pid namespaces; and a separate uid/gid (unlike traditional
+ *   FUSE which needs mount permissions and runs in the caller's environment)
+ *
+ * Compile with:
+ *
+ *     gcc -Wall single_file.c service_hl.c `pkg-config fuse3 --cflags --libs` -o service_hl
+ *
+ * Note: If the pkg-config command fails due to the absence of the fuse3.pc
+ *     file, you should configure the path to the fuse3.pc file in the
+ *     PKG_CONFIG_PATH variable.
+ *
+ * Change the ExecStart line in service_hl@.service:
+ *
+ *     ExecStart=/path/to/service_hl
+ *
+ * to point to the actual path of the service_hl binary.
+ *
+ * Finally, install the service_hl@.service and service_hl.socket files to the
+ * systemd service directory, usually /run/systemd/system.  Run these commands
+ * to activate:
+ *
+ *     systemctl daemon-reload
+ *     systemctl start service_hl.socket
+ *
+ * Then mount with:
+ *
+ *     mount -t fuse.service_hl /dev/sda /mnt
+ *
+ * ## Source code ##
+ * \include service_hl.c
+ * \include service_hl.socket
+ * \include service_hl@.service
+ * \include single_file.c
+ * \include single_file.h
+ */
+
+#define FUSE_USE_VERSION FUSE_MAKE_VERSION(3, 19)
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <fuse.h>
+#include <fuse_service.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <assert.h>
+#include <pthread.h>
+#include <stddef.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <linux/fs.h>
+#include <linux/stat.h>
+#define USE_SINGLE_FILE_HL_API
+#include "single_file.h"
+
+struct service_hl {
+	char *device;
+	struct fuse_service *service;
+
+	/* really booleans */
+	int debug;
+};
+
+static struct service_hl hl = { };
+
+static void *service_hl_init(struct fuse_conn_info *conn,
+			struct fuse_config *cfg)
+{
+	(void) conn;
+	cfg->kernel_cache = 1;
+
+	return NULL;
+}
+
+static int service_hl_read(const char *path, char *buf, size_t count,
+			   off_t pos, struct fuse_file_info *fi)
+{
+	if (!is_single_open_file_path(fi, path))
+		return -EIO;
+
+	if (hl.debug)
+		fprintf(stderr, "%s: pos 0x%llx count 0x%llx\n",
+			__func__,
+			(unsigned long long)pos,
+			(unsigned long long)count);
+
+	if (!single_file.allow_dio && fi->direct_io)
+		return -ENOSYS;
+
+	single_file_check_read(pos, &count);
+
+	if (!count)
+		return 0;
+
+	return single_file_pread(buf, count, pos);
+}
+
+static int service_hl_write(const char *path, const char *buf, size_t count,
+			    off_t pos, struct fuse_file_info *fi)
+{
+	int ret;
+
+	if (!is_single_open_file_path(fi, path))
+		return -EIO;
+
+	if (hl.debug)
+		fprintf(stderr, "%s: pos 0x%llx count 0x%llx\n",
+			__func__,
+			(unsigned long long)pos,
+			(unsigned long long)count);
+
+	if (!single_file.allow_dio && fi->direct_io)
+		return -ENOSYS;
+
+	ret = single_file_check_write(pos, &count);
+	if (ret < 0)
+		return ret;
+
+	if (!count)
+		return 0;
+
+	return single_file_pwrite(buf, count, pos);
+}
+
+static const struct fuse_operations service_hl_oper = {
+	.getattr	= single_file_hl_getattr,
+	.readdir	= single_file_hl_readdir,
+	.open		= single_file_hl_open,
+	.opendir	= single_file_hl_opendir,
+	.statfs		= single_file_hl_statfs,
+	.chmod		= single_file_hl_chmod,
+	.utimens	= single_file_hl_utimens,
+	.fsync		= single_file_hl_fsync,
+	.chown		= single_file_hl_chown,
+	.truncate	= single_file_hl_truncate,
+	.statx		= single_file_hl_statx,
+
+	.init		= service_hl_init,
+	.read		= service_hl_read,
+	.write		= service_hl_write,
+};
+
+#define SERVICE_HL_OPT(t, p, v) { t, offsetof(struct service_hl, p), v }
+
+static struct fuse_opt service_hl_opts[] = {
+	SERVICE_HL_OPT("debug",		debug,			1),
+	SINGLE_FILE_OPT_KEYS,
+	FUSE_OPT_END
+};
+
+static int service_hl_opt_proc(void *data, const char *arg, int key,
+			       struct fuse_args *outargs)
+{
+	int ret = single_file_opt_proc(data, arg, key, outargs);
+
+	if (ret < 1)
+		return ret;
+
+	switch (key) {
+	case FUSE_OPT_KEY_NONOPT:
+		if (!hl.device) {
+			hl.device = strdup(arg);
+			return 0;
+		}
+		return 1;
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
+	int ret = 1;
+
+	if (fuse_service_accept(&hl.service))
+		goto err_args;
+
+	if (!fuse_service_accepted(hl.service))
+		goto err_args;
+
+	if (fuse_service_append_args(hl.service, &args))
+		goto err_service;
+
+	if (fuse_opt_parse(&args, &hl, service_hl_opts, service_hl_opt_proc))
+		goto err_service;
+
+	if (!hl.device) {
+		printf("usage: %s [options] <device> <mountpoint>\n", argv[0]);
+		printf("       %s --help\n", argv[0]);
+		goto err_service;
+	}
+
+	if (single_file_service_open(hl.service, hl.device))
+		goto err_service;
+
+	if (fuse_service_finish_file_requests(hl.service))
+		goto err_singlefile;
+
+	if (single_file_configure(hl.device, NULL))
+		goto err_singlefile;
+
+	fuse_service_expect_mount_format(hl.service, S_IFDIR);
+
+	ret = fuse_service_main(hl.service, &args, &service_hl_oper, NULL);
+
+err_singlefile:
+	single_file_close();
+err_service:
+	free(hl.device);
+	fuse_service_send_goodbye(hl.service, ret);
+	fuse_service_destroy(&hl.service);
+err_args:
+	fuse_opt_free_args(&args);
+	return fuse_service_exit(ret);
+}
diff --git a/example/service_hl.socket.in b/example/service_hl.socket.in
new file mode 100644
index 00000000000000..46035d6c315b8d
--- /dev/null
+++ b/example/service_hl.socket.in
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for service_hl Service
+
+[Socket]
+ListenSequentialPacket=@FUSE_SERVICE_SOCKET_DIR_RAW@/service_hl
+Accept=yes
+SocketMode=@FUSE_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/example/service_hl@.service b/example/service_hl@.service
new file mode 100644
index 00000000000000..883b9c649cbc90
--- /dev/null
+++ b/example/service_hl@.service
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=service_hl Sample Fuse Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/path/to/service_hl
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
+# Log to the kernel dmesg, just like an in-kernel filesystem driver
+StandardOutput=append:/dev/ttyprintk
+StandardError=append:/dev/ttyprintk
+
+# Run with no capabilities at all
+CapabilityBoundingSet=
+AmbientCapabilities=
+NoNewPrivileges=true
+
+# We don't create files
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
diff --git a/example/service_ll.c b/example/service_ll.c
index d045176443d4e3..33a8bd48bc1215 100644
--- a/example/service_ll.c
+++ b/example/service_ll.c
@@ -67,6 +67,7 @@
 #include <unistd.h>
 #include <assert.h>
 #include <pthread.h>
+#define USE_SINGLE_FILE_LL_API
 #include "single_file.h"
 
 struct service_ll {
diff --git a/example/single_file.c b/example/single_file.c
index 9b6f76504686b5..a962232d576e17 100644
--- a/example/single_file.c
+++ b/example/single_file.c
@@ -27,7 +27,10 @@
 #define FUSE_USE_VERSION (FUSE_MAKE_VERSION(3, 19))
 
 #include "fuse_lowlevel.h"
+#include "fuse.h"
 #include "fuse_service.h"
+#define USE_SINGLE_FILE_LL_API
+#define USE_SINGLE_FILE_HL_API
 #include "single_file.h"
 
 #define min(x, y) ((x) < (y) ? (x) : (y))
@@ -60,6 +63,23 @@ struct single_file single_file = {
 	.lock = PTHREAD_MUTEX_INITIALIZER,
 };
 
+static fuse_ino_t single_file_path_to_ino(const char *path)
+{
+	if (strcmp(path, "/") == 0)
+		return FUSE_ROOT_ID;
+	if (strcmp(path + 1, single_file_name) == 0)
+		return SINGLE_FILE_INO;
+	return 0;
+}
+
+static fuse_ino_t single_open_file_path_to_ino(const struct fuse_file_info *fi,
+					       const char *path)
+{
+	if (fi)
+		return fi->fh;
+	return single_file_path_to_ino(path);
+}
+
 static void dirbuf_add(fuse_req_t req, struct dirbuf *b, const char *name,
 		       fuse_ino_t ino)
 {
@@ -95,6 +115,13 @@ bool is_single_file_ino(fuse_ino_t ino)
 	return ino == SINGLE_FILE_INO;
 }
 
+bool is_single_open_file_path(const struct fuse_file_info *fi, const char *name)
+{
+	if (fi)
+		return is_single_file_ino(fi->fh);
+	return name[0] == '/' && strcmp(name + 1, single_file_name) == 0;
+}
+
 void single_file_ll_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
 			    off_t off, struct fuse_file_info *fi)
 {
@@ -121,6 +148,37 @@ void single_file_ll_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
 	free(b.p);
 }
 
+int single_file_hl_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
+			   off_t offset, struct fuse_file_info *fi,
+			   enum fuse_readdir_flags flags)
+{
+	struct stat stbuf;
+	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
+
+	memset(&stbuf, 0, sizeof(stbuf));
+
+	(void) offset;
+	(void) flags;
+
+	switch (ino) {
+	case FUSE_ROOT_ID:
+		break;
+	case SINGLE_FILE_INO:
+		return -ENOTDIR;
+	default:
+		return -ENOENT;
+	}
+
+	stbuf.st_ino = FUSE_ROOT_ID;
+	filler(buf, ".", &stbuf, 0, FUSE_FILL_DIR_DEFAULTS);
+	filler(buf, "..", &stbuf, 0, FUSE_FILL_DIR_DEFAULTS);
+
+	stbuf.st_ino = SINGLE_FILE_INO;
+	filler(buf, single_file_name, &stbuf, 0, FUSE_FILL_DIR_DEFAULTS);
+
+	return 0;
+}
+
 static bool sf_stat(fuse_ino_t ino, struct single_file_stat *llstat)
 {
 	struct fuse_entry_param *entry = &llstat->entry;
@@ -248,40 +306,82 @@ void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
 	else
 		fuse_reply_statx(req, 0, &stx, 0.0);
 }
+
+int single_file_hl_statx(const char *path, int statx_flags, int statx_mask,
+			 struct statx *stx, struct fuse_file_info *fi)
+{
+	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
+	bool filled;
+
+	if (!ino)
+		return -ENOENT;
+
+	if ((statx_flags & AT_STATX_FORCE_SYNC) && is_single_file_ino(ino) &&
+	    single_file.backing_fd >= 0) {
+		int ret = fsync(single_file.backing_fd);
+
+		if (ret)
+			return -errno;
+	}
+
+	pthread_mutex_lock(&single_file.lock);
+	filled = sf_statx(ino, statx_mask, stx);
+	pthread_mutex_unlock(&single_file.lock);
+
+	return filled ? 0 : -ENOENT;
+}
 #else
 void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
 			  struct fuse_file_info *fi)
 {
 	fuse_reply_err(req, ENOSYS);
 }
+
+int single_file_hl_statx(const char *path, int statx_flags, int statx_mask,
+			 struct statx *stx, struct fuse_file_info *fi)
+{
+	return -ENOSYS;
+}
 #endif /* STATX_BASIC_STATS */
 
+static void single_file_statfs(struct statvfs *buf)
+{
+	pthread_mutex_lock(&single_file.lock);
+	buf->f_bsize = single_file.blocksize;
+	buf->f_frsize = 0;
+
+	buf->f_blocks = single_file.blocks;
+	buf->f_bfree = 0;
+	buf->f_bavail = 0;
+	buf->f_files = 1;
+	buf->f_ffree = 0;
+	buf->f_favail = 0;
+	buf->f_fsid = 0x50C00L;
+	buf->f_flag = 0;
+	if (single_file.ro)
+		buf->f_flag |= ST_RDONLY;
+	buf->f_namemax = 255;
+	pthread_mutex_unlock(&single_file.lock);
+}
+
 void single_file_ll_statfs(fuse_req_t req, fuse_ino_t ino)
 {
 	struct statvfs buf;
 
 	(void)ino;
 
-	pthread_mutex_lock(&single_file.lock);
-	buf.f_bsize = single_file.blocksize;
-	buf.f_frsize = 0;
-
-	buf.f_blocks = single_file.blocks;
-	buf.f_bfree = 0;
-	buf.f_bavail = 0;
-	buf.f_files = 1;
-	buf.f_ffree = 0;
-	buf.f_favail = 0;
-	buf.f_fsid = 0x50C00L;
-	buf.f_flag = 0;
-	if (single_file.ro)
-		buf.f_flag |= ST_RDONLY;
-	buf.f_namemax = 255;
-	pthread_mutex_unlock(&single_file.lock);
-
+	single_file_statfs(&buf);
 	fuse_reply_statfs(req, &buf);
 }
 
+int single_file_hl_statfs(const char *path, struct statvfs *buf)
+{
+	(void)path;
+
+	single_file_statfs(buf);
+	return 0;
+}
+
 void single_file_ll_getattr(fuse_req_t req, fuse_ino_t ino,
 			    struct fuse_file_info *fi)
 {
@@ -301,6 +401,28 @@ void single_file_ll_getattr(fuse_req_t req, fuse_ino_t ino,
 				llstat.entry.attr_timeout);
 }
 
+int single_file_hl_getattr(const char *path, struct stat *stbuf,
+			   struct fuse_file_info *fi)
+{
+	struct single_file_stat llstat;
+	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
+	bool filled;
+
+	if (!ino)
+		return -ENOENT;
+
+	memset(&llstat, 0, sizeof(llstat));
+	pthread_mutex_lock(&single_file.lock);
+	filled = sf_stat(ino, &llstat);
+	pthread_mutex_unlock(&single_file.lock);
+
+	if (!filled)
+		return -ENOENT;
+
+	memcpy(stbuf, &llstat.entry.attr, sizeof(*stbuf));
+	return 0;
+}
+
 static void get_now(struct timespec *now)
 {
 #ifdef CLOCK_REALTIME
@@ -353,6 +475,82 @@ void single_file_ll_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
 	fuse_reply_err(req, EPERM);
 }
 
+int single_file_hl_chmod(const char *path, mode_t mode,
+			 struct fuse_file_info *fi)
+{
+	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
+
+	if (!ino)
+		return -ENOENT;
+	if (ino != SINGLE_FILE_INO)
+		return -EPERM;
+	if (single_file.ro)
+		return -EPERM;
+
+	pthread_mutex_lock(&single_file.lock);
+	single_file.mode = (single_file.mode & S_IFMT) | (mode & ~S_IFMT);
+	get_now(&single_file.ctime);
+	pthread_mutex_unlock(&single_file.lock);
+
+	return 0;
+}
+
+static void set_time(const struct timespec *ctv, struct timespec *tv)
+{
+	switch (ctv->tv_nsec) {
+	case UTIME_OMIT:
+		return;
+	case UTIME_NOW:
+		get_now(tv);
+		break;
+	default:
+		memcpy(tv, ctv, sizeof(*tv));
+		break;
+	}
+}
+
+int single_file_hl_utimens(const char *path, const struct timespec ctv[2],
+			   struct fuse_file_info *fi)
+{
+	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
+
+	if (!ino)
+		return -ENOENT;
+	if (ino != SINGLE_FILE_INO)
+		return -EPERM;
+	if (single_file.ro)
+		return -EPERM;
+
+	pthread_mutex_lock(&single_file.lock);
+	set_time(&ctv[0], &single_file.atime);
+	set_time(&ctv[1], &single_file.mtime);
+	get_now(&single_file.ctime);
+	pthread_mutex_unlock(&single_file.lock);
+
+	return 0;
+}
+
+int single_file_hl_chown(const char *path, uid_t owner, gid_t group,
+			 struct fuse_file_info *fi)
+{
+	(void)path;
+	(void)owner;
+	(void)group;
+	(void)fi;
+
+	return -EPERM;
+}
+
+int single_file_hl_truncate(const char *path, off_t len,
+			    struct fuse_file_info *fi)
+{
+	(void)path;
+	(void)len;
+	(void)fi;
+
+	return -EPERM;
+}
+
 void single_file_ll_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
 {
 	struct single_file_stat llstat;
@@ -384,6 +582,34 @@ void single_file_ll_open(fuse_req_t req, fuse_ino_t ino,
 		fuse_reply_open(req, fi);
 }
 
+int single_file_hl_opendir(const char *path, struct fuse_file_info *fi)
+{
+	fuse_ino_t ino = single_file_path_to_ino(path);
+
+	if (!ino)
+		return -ENOENT;
+	if (ino == SINGLE_FILE_INO)
+		return -ENOTDIR;
+
+	fi->fh = ino;
+	return 0;
+}
+
+int single_file_hl_open(const char *path, struct fuse_file_info *fi)
+{
+	fuse_ino_t ino = single_file_path_to_ino(path);
+
+	if (!ino)
+		return -ENOENT;
+	if (ino != SINGLE_FILE_INO)
+		return -EISDIR;
+	if (single_file.ro && (fi->flags & O_ACCMODE) != O_RDONLY)
+		return -EROFS;
+
+	fi->fh = ino;
+	return 0;
+}
+
 void single_file_ll_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
 			  struct fuse_file_info *fi)
 {
@@ -401,6 +627,26 @@ void single_file_ll_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
 	fuse_reply_err(req, ret);
 }
 
+int single_file_hl_fsync(const char *path, int datasync,
+			 struct fuse_file_info *fi)
+{
+	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
+
+	(void)datasync;
+
+	if (!ino)
+		return -ENOENT;
+
+	if (ino == SINGLE_FILE_INO) {
+		int ret = fsync(single_file.backing_fd);
+
+		if (ret)
+			return -errno;
+	}
+
+	return 0;
+}
+
 unsigned long long parse_num_blocks(const char *arg, int log_block_size)
 {
 	char *p;

