Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE85376BD6;
	Thu, 30 Apr 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583905; cv=none; b=VVmVlZEas5Y3ZjK31rH534f4r1T99nYjxo/DCDMdE+EDE9wXyCsc1RWfW4dJnvdC+Ec8QdPjcUo7YMMc47xbhwa7O4RYIH5Np90LIRAHWOjwemOU7rYl93XRW1BI87Y9QI04sxiciUS9JUJRbqrhDVMCulSWF9KGmE+Np21Rghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583905; c=relaxed/simple;
	bh=XMfQWfN1ZSoga89cy7a4ogwETMr/FjARcc0gHZC2BPU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMjUbLzv6ZFgILtQJvVrrYNuuyRLbJtkpL62gU+8U+wQAud2uNIUWYmkbePuzg0LwNo4NBWv1uvpmPwV5Yg/ji4kMDZrQvODiFHtTSZrRk+U0fC3UOidPjjmF7Jh8jk/SeranjvClYdcxvBWDPp/qjjU9aWb3A/Gb3cDIC1BhgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VdiTJcJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VdiTJcJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6496BC2BCB3;
	Thu, 30 Apr 2026 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583905;
	bh=XMfQWfN1ZSoga89cy7a4ogwETMr/FjARcc0gHZC2BPU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VdiTJcJTbZz71Xl3VOE6MqljAFJtSezkq0BZBu4MiWYJTiYLhWQ5RGR8MKikAAR9f
	 7Sfpwas59Zd37COU4gCFVjVvZV6oO0mvtohkOsc8T9eXT9jEHQ8STwgdhXDv9XJ0t3
	 u2lUIWNfI+plc61rJlSqPN4WyJ4VKzS6GfEPoZ0DNUA1JxcanSJS/9+ERYS1k8Er+T
	 m02qWjBPvyNlYlz9agrcKPR/nsuvychmHRPAHlJ6xa6Iw3ZKdP9pK2UrauiO+q0kN+
	 LAK2J0BlJ0nuWPekngX8d/F4WW6RFVakHYOc/L+PrnLU5cu2uzmeOozZv6nFEz2PnX
	 TSDp3CFEfwQBw==
Date: Thu, 30 Apr 2026 14:18:24 -0700
Subject: [PATCH 13/13] nullfs: support fuse systemd service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363766.1314717.14077992750227350643.stgit@frogsfrogsfrogs>
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

This is the only example fuse server that exports a regular file instead
of a directory tree.  Port it to be usable as a systemd fuse service so
that we can test that capability.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 example/meson.build    |    6 +++
 example/null.c         |   51 +++++++++++++++++++++++-
 example/null.socket.in |   15 +++++++
 example/null@.service  |  102 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 171 insertions(+), 3 deletions(-)
 create mode 100644 example/null.socket.in
 create mode 100644 example/null@.service


diff --git a/example/meson.build b/example/meson.build
index 19a383f7cd2c74..45dbf26eb355a7 100644
--- a/example/meson.build
+++ b/example/meson.build
@@ -10,6 +10,12 @@ if not platform.endswith('bsd') and platform != 'dragonfly'
     # support mounting files, This is enforced in vfs_domount_first()
     # with the v_type != VDIR check.
     examples += [ 'null' ]
+
+    if platform.endswith('linux')
+        configure_file(input: 'null.socket.in',
+                       output: 'null.socket',
+                       configuration: private_cfg)
+    endif
 endif
 
 single_file_examples = [ ]
diff --git a/example/null.c b/example/null.c
index ec41def40ed5c5..43135cde39713e 100644
--- a/example/null.c
+++ b/example/null.c
@@ -17,15 +17,24 @@
  *
  *     gcc -Wall null.c `pkg-config fuse3 --cflags --libs` -o null
  *
+ * Change the ExecStart line in nullfile@.service:
+ *
+ *     ExecStart=/path/to/null
+ *
+ * to point to the actual path of the null binary.
+ *
+ * Finally, install the null@.service and null.socket files to the
+ * systemd service directory, usually /run/systemd/system.
+ *
  * ## Source code ##
  * \include passthrough_fh.c
  */
 
-
-#define FUSE_USE_VERSION 31
+#define FUSE_USE_VERSION FUSE_MAKE_VERSION(3, 19)
 
 #include <fuse.h>
 #include <fuse_lowlevel.h>
+#include <fuse_service.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -33,6 +42,8 @@
 #include <time.h>
 #include <errno.h>
 
+static mode_t mode = 0644;
+
 static int null_getattr(const char *path, struct stat *stbuf,
 			struct fuse_file_info *fi)
 {
@@ -41,7 +52,7 @@ static int null_getattr(const char *path, struct stat *stbuf,
 	if(strcmp(path, "/") != 0)
 		return -ENOENT;
 
-	stbuf->st_mode = S_IFREG | 0644;
+	stbuf->st_mode = S_IFREG | mode;
 	stbuf->st_nlink = 1;
 	stbuf->st_uid = getuid();
 	stbuf->st_gid = getgid();
@@ -112,11 +123,45 @@ static const struct fuse_operations null_oper = {
 	.write		= null_write,
 };
 
+static int null_service(struct fuse_service *service, struct fuse_args *args)
+{
+	int ret = 1;
+
+	if (fuse_service_append_args(service, args))
+		goto err_service;
+
+	if (fuse_service_finish_file_requests(service))
+		goto err_service;
+
+	fuse_service_expect_mount_format(service, S_IFREG);
+
+	/*
+	 * In non-service mode, we set up the file to be owned and writable
+	 * by the same user that starts the fuse server.  When running in a
+	 * container as a dynamic user, we just grant world write access.
+	 */
+	mode = 0666;
+	ret = fuse_service_main(service, args, &null_oper, NULL);
+
+err_service:
+	fuse_service_send_goodbye(service, ret);
+	fuse_service_destroy(&service);
+	fuse_opt_free_args(args);
+	return fuse_service_exit(ret);
+}
+
 int main(int argc, char *argv[])
 {
 	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
 	struct fuse_cmdline_opts opts;
 	struct stat stbuf;
+	struct fuse_service *service = NULL;
+
+	if (fuse_service_accept(&service) != 0)
+		return 1;
+
+	if (fuse_service_accepted(service))
+		return null_service(service, &args);
 
 	if (fuse_parse_cmdline(&args, &opts) != 0)
 		return 1;
diff --git a/example/null.socket.in b/example/null.socket.in
new file mode 100644
index 00000000000000..865e739561a45e
--- /dev/null
+++ b/example/null.socket.in
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for null Service
+
+[Socket]
+ListenSequentialPacket=@FUSE_SERVICE_SOCKET_DIR_RAW@/null
+Accept=yes
+SocketMode=@FUSE_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/example/null@.service b/example/null@.service
new file mode 100644
index 00000000000000..f77fbe927217cf
--- /dev/null
+++ b/example/null@.service
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=null Sample Fuse Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/path/to/null
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

