Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1F1FBEBC;
	Wed, 22 Apr 2026 23:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900776; cv=none; b=JYSdFjNJyBbdhLzNtHRLYNJKt9hhukY3sJ1+EBA8sVRC48cPLBEvSriDbXpIga73isrzPo+eiYOCeRkHuZFyRsy5GQWPyt2YMk6z+fHcnF8fWIZV7G4U9oAnZp/HU9gn9OVc0iknQCl4pnHw0baqfuOHjlR/hq2V6xReHHVSxE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900776; c=relaxed/simple;
	bh=Mr4XuetFvL1CpNi8BM91LvuBxo/gWXceGxVA4B3PsI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qq64Dny7x2DKxAv8beJZnwgJW+pnt0fIOVeECegeHWrmDxu/TkMlj2Wu/ltABc+73UkR3wM3krjPysvfv5vw66g4xeDnQ831ig9kJ0/EKC0qZ2zOXjOELezAQ1nh/wHjQsijUnnKLA0CWTE8qPLoL5kxnpU4iaMPaEjC88sqMWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRCNlYox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRCNlYox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2121DC19425;
	Wed, 22 Apr 2026 23:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900776;
	bh=Mr4XuetFvL1CpNi8BM91LvuBxo/gWXceGxVA4B3PsI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fRCNlYoxYkytcGj6vzmuGHyTox/PpJqr3oNevZqEhAbyygAt4nQvNIcSqlch1LOUe
	 CVTRZAIi+NpERhk3QPk+sT9UBdIgyCAy7ZUN2J3vrvjeQE49OZXMZo5K1E2jOshngB
	 o0dU0jl/8b3u5mR8SzRHwNLiyjI6aXAn0awEzOEh8+VBousAdhVOgZf+R9jgKe5dt/
	 hipVStbUwx9ZTiBJIPNmWSNWiO2Fgy1kdKVz2u8CJvSmFcBJ76XjeE0mW7P0+1QGI8
	 1uD50xTDjBpiybP0/pvjmt8yMWmA9uvplnt3t1YyLU67A7sebVRnZrDsT0t6QXPtwa
	 KRAs2TaaacYHw==
Date: Wed, 22 Apr 2026 16:32:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, demiobenour@gmail.com
Subject: [RFC PATCH 4/4] httpdirfs: enable fuse systemd service mode
Message-ID: <20260422233255.GJ7739@frogsfrogsfrogs>
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

Enable use of httpdirfs as a contained systemd service.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/fuse_local.h          |    2 +
 meson.build               |   26 ++++++++++++
 src/fuse_local.c          |   62 ++++++++++++++++++++++++++++
 src/httpdirfs.socket.in   |   16 +++++++
 src/httpdirfs@.service.in |   99 +++++++++++++++++++++++++++++++++++++++++++++
 src/main.c                |    7 +++
 6 files changed, 210 insertions(+), 2 deletions(-)
 create mode 100644 src/httpdirfs.socket.in
 create mode 100644 src/httpdirfs@.service.in

diff --git a/src/fuse_local.h b/src/fuse_local.h
index 9f459c1e1a8151..69157cd3fa7883 100644
--- a/src/fuse_local.h
+++ b/src/fuse_local.h
@@ -9,4 +9,6 @@
 /* Initialise fuse */
 int fuse_local_init(int argc, char **argv);
 
+int fuse_local_main(int argc, char *argv[], int (*main)(int argc, char **argv));
+
 #endif
diff --git a/meson.build b/meson.build
index 431a1547b20bfc..5d7c4721bb756c 100644
--- a/meson.build
+++ b/meson.build
@@ -41,6 +41,32 @@ expat_dep = dependency('expat')
 openssl_dep = dependency('openssl')
 execinfo_dep = cc.find_library('execinfo', required: false)
 
+# Check for systemd support
+systemd_dep = dependency('systemd', required: false)
+if systemd_dep.found()
+   systemd_system_unit_dir = systemd_dep.get_variable(pkgconfig: 'systemd_system_unit_dir', default_value: '')
+   libfuse_service_socket_dir = fuse_dep.get_variable(pkgconfig: 'service_socket_dir', default_value: '')
+   libfuse_service_socket_perms = fuse_dep.get_variable(pkgconfig: 'service_socket_perms', default_value: '')
+endif
+
+private_cfg = configuration_data()
+if systemd_system_unit_dir == '' or libfuse_service_socket_dir == ''
+  warning('systemd service support will not be built')
+else
+   private_cfg.set('SYSTEMD_SYSTEM_UNIT_DIR', systemd_system_unit_dir)
+   private_cfg.set('LIBFUSE_SERVICE_SOCKET_DIR', libfuse_service_socket_dir)
+   private_cfg.set('LIBFUSE_SERVICE_SOCKET_PERMS', libfuse_service_socket_perms)
+   private_cfg.set('BINDIR', get_option('bindir'))
+   c_args += [ '-DHAVE_HTTPDIR_FUSE_SERVICE' ]
+
+   configure_file(input: 'src/httpdirfs@.service.in',
+                  output: 'httpdirfs@.service',
+                  configuration: private_cfg)
+   configure_file(input: 'src/httpdirfs.socket.in',
+                  output: 'httpdirfs.socket',
+                  configuration: private_cfg)
+endif
+
 httpdirfs = executable('httpdirfs',
     srcs,
     dependencies : [gumbo_dep, libcurl_dep, fuse_dep, uuid_dep, expat_dep, openssl_dep, execinfo_dep],
diff --git a/src/fuse_local.c b/src/fuse_local.c
index ae9778f84e6ef3..c373bd67214335 100644
--- a/src/fuse_local.c
+++ b/src/fuse_local.c
@@ -6,13 +6,58 @@
 /*
  * must be included before including <fuse.h>
  */
-#define FUSE_USE_VERSION 30
+#define FUSE_USE_VERSION 319
 #include <fuse.h>
 
 #include <errno.h>
 #include <string.h>
 #include <unistd.h>
 
+#ifdef HAVE_HTTPDIR_FUSE_SERVICE
+# include <sys/mount.h>
+# include <fuse_service.h>
+
+static struct fuse_service *service;
+
+static inline bool fs_is_service(void)
+{
+	return fuse_service_accepted(service);
+}
+
+static int fs_service_connect(struct fuse_args *args)
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
+static int fs_service_run(int argc, char **argv,
+			  const struct fuse_operations *fs_oper)
+{
+	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
+	int exitcode;
+
+	fuse_service_expect_mount_format(service, S_IFDIR);
+	exitcode = fuse_service_main(service, &args, fs_oper, NULL);
+
+	fuse_service_send_goodbye(service, exitcode);
+	fuse_service_destroy(&service);
+
+	return fuse_service_exit(exitcode);
+}
+#else
+# define fs_is_service(...)		(false)
+# define fs_service_connect(...)	(0)
+# define fs_service_run(...)		(1)
+#endif /* HAVE_HTTPDIR_FUSE_SERVICE */
+
 static void *fs_init(struct fuse_conn_info *conn, struct fuse_config *cfg)
 {
     (void) conn;
@@ -183,5 +228,20 @@ static struct fuse_operations fs_oper = {
 
 int fuse_local_init(int argc, char **argv)
 {
+    if (fs_is_service())
+        return fs_service_run(argc, argv, &fs_oper);
+
     return fuse_main(argc, argv, &fs_oper, NULL);
 }
+
+int fuse_local_main(int argc, char *argv[], int (*main)(int argc, char **argv))
+{
+	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
+	int ret;
+
+	ret = fs_service_connect(&args);
+	if (ret)
+		return ret;
+
+	return main(args.argc, args.argv);
+}
diff --git a/src/httpdirfs.socket.in b/src/httpdirfs.socket.in
new file mode 100644
index 00000000000000..ae587646ad707e
--- /dev/null
+++ b/src/httpdirfs.socket.in
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=Socket for httpdirfs Service
+
+[Socket]
+ListenSequentialPacket=@LIBFUSE_SERVICE_SOCKET_DIR@/http
+ListenSequentialPacket=@LIBFUSE_SERVICE_SOCKET_DIR@/https
+Accept=yes
+SocketMode=@LIBFUSE_SERVICE_SOCKET_PERMS@
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/src/httpdirfs@.service.in b/src/httpdirfs@.service.in
new file mode 100644
index 00000000000000..d808feca3238d7
--- /dev/null
+++ b/src/httpdirfs@.service.in
@@ -0,0 +1,99 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2026 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+[Unit]
+Description=httpdirfs Service
+
+# Don't leave failed units behind, systemd does not clean them up!
+CollectMode=inactive-or-failed
+
+[Service]
+Type=exec
+ExecStart=/@BINDIR@/httpdirfs
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
+# Some network access
+ProtectHostname=true
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
+#SystemCallFilter=~@privileged	# not sure why this breaks http??
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
diff --git a/src/main.c b/src/main.c
index c93162a9bf4129..4c23d4e5d4419f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -16,7 +16,7 @@ void parse_config_file(char ***argv, int *argc);
 
 static char *config_path = NULL;
 
-int main(int argc, char **argv)
+static int __main(int argc, char **argv)
 {
     /*
      * Automatically print help if not enough arguments are supplied
@@ -114,6 +114,11 @@ activate Sonic mode.\n");
     return 0;
 }
 
+int main(int argc, char *argv[])
+{
+	return fuse_local_main(argc, argv, __main);
+}
+
 static char *get_XDG_CONFIG_HOME(void)
 {
     const char *default_config_subdir = "/.config";
