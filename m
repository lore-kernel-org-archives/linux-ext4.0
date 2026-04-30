Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7B42FE066;
	Thu, 30 Apr 2026 21:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583843; cv=none; b=efPh9GvvPb6l/KPNZanCiDriDxpPaFmnSB/xqo05SqJ9ixZaDqpQ0jSa6EWIlv1hCgshIHRjOVA6NH/0t0tmUquzDAtTk02WVK+DPtAjkV61ngUMDrtVU0c0HyVFkgs+PDmCJVLZPZGLLCutqyImJfd06xWMEJfXJqV09t3yGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583843; c=relaxed/simple;
	bh=7lvNUn1N13PUSzQsaq7P25Kqokw4Uulf0kfs9uTn9mI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqL5tvRAlzlVqU3d0FPsIsUNSV5kNjD9DKSLXgNENtVoiQQuANN2cKAGf+T+6imaINszTLsSWrnXAOzJoCqUjHn/Ff1Zf7YO3bLNPL9TmW+T5oNzkjxYXuh0mesGXH1Ji5L2vSg4uLfThYgYUtEzMWccxUvgSmJkOApPWT94p68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxCsw/Jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxCsw/Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27EDC2BCB3;
	Thu, 30 Apr 2026 21:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583842;
	bh=7lvNUn1N13PUSzQsaq7P25Kqokw4Uulf0kfs9uTn9mI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZxCsw/JpwR8uU4wZNyyakh7P/5K/K7DbIrWDxGtSODE5NJklr/0AE8rtOI6ek2yFA
	 jjzifrOafjrZjTujmJwIo2Yz7eUGxXggJIuj+tUOjHFXDyN6bELNdGaFPFIgmRgpc1
	 rWQEk14F77ipXlwdMepy3MYdYLL3muAoraNxaBUMcEbDfA6/CN+qtmRdSK4PXhLMli
	 9RByD6+irolwAm3Ruj0MCqXvjJVTWHOgDrpKilevlDtMwSwGROxutrqEInpUjOPnVA
	 ahnhxXQzOOQGqGK0+U9PdzjaFvwluZnb/78tp6+Q7BW83BvhSyeiUlYFpMBVNJ9Yzr
	 eGYHjBC9MaRtw==
Date: Thu, 30 Apr 2026 14:17:22 -0700
Subject: [PATCH 09/13] mount.fuse3: integrate systemd service startup
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363694.1314717.18298115158990525436.stgit@frogsfrogsfrogs>
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

Teach mount.fuse3 how to start fuse via systemd service, if present.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 util/mount_service.h  |    9 +++
 doc/fuservicemount3.8 |   10 +++
 meson.build           |    3 +
 util/fuservicemount.c |   47 +++++++++++++
 util/meson.build      |   14 +++-
 util/mount.fuse.c     |  171 +++++++++++++++++++++++++++++++++++++++++++------
 util/mount_service.c  |   43 ++++++++++++
 7 files changed, 270 insertions(+), 27 deletions(-)


diff --git a/util/mount_service.h b/util/mount_service.h
index a0b952a15dacf3..ec8008a7f53942 100644
--- a/util/mount_service.h
+++ b/util/mount_service.h
@@ -37,4 +37,13 @@ int mount_service_main(int argc, char *argv[]);
  */
 const char *mount_service_subtype(const char *fstype);
 
+/**
+ * Discover if there is a fuse service socket for the given fuse filesystem type.
+ * The type must not contain a path separator.
+ *
+ * @param fstype the type of a fuse filesystem type (e.g. fuse.Y, fuseblk.Y, or Y)
+ * @return true if available, false if not
+ */
+bool mount_service_present(const char *fstype);
+
 #endif /* MOUNT_SERVICE_H_ */
diff --git a/doc/fuservicemount3.8 b/doc/fuservicemount3.8
index e45d6a89c8b81a..aa2167cb4872c6 100644
--- a/doc/fuservicemount3.8
+++ b/doc/fuservicemount3.8
@@ -7,12 +7,20 @@ .SH SYNOPSIS
 .B mountpoint
 .BI -t " fstype"
 [
-.I options
+.BI -o " options"
 ]
+
+.B fuservicemount3
+.BI -t " fstype"
+.B --check
+
 .SH DESCRIPTION
 Mount a filesystem using a FUSE server that runs as a socket service.
 These servers can be contained using the platform's service management
 framework.
+
+The second form checks if there is a FUSE service available for the given
+filesystem type.
 .SH "AUTHORS"
 .LP
 The author of the fuse socket service code is Darrick J. Wong <djwong@kernel.org>.
diff --git a/meson.build b/meson.build
index c8326b79fcee8f..827ec45ad3ad75 100644
--- a/meson.build
+++ b/meson.build
@@ -83,7 +83,8 @@ private_cfg.set('FUSE_SERVICE_SOCKET_PERMS', service_socket_perms)
 # Test for presence of some functions
 test_funcs = [ 'fork', 'fstatat', 'openat', 'readlinkat', 'pipe2',
                'splice', 'vmsplice', 'posix_fallocate', 'fdatasync',
-               'utimensat', 'copy_file_range', 'fallocate', 'fspacectl' ]
+               'utimensat', 'copy_file_range', 'fallocate', 'fspacectl',
+               'faccessat' ]
 foreach func : test_funcs
     private_cfg.set('HAVE_' + func.to_upper(),
         cc.has_function(func, prefix: include_default, args: args_default))
diff --git a/util/fuservicemount.c b/util/fuservicemount.c
index 9c694a4290f94e..4d4cad6cb9253c 100644
--- a/util/fuservicemount.c
+++ b/util/fuservicemount.c
@@ -9,10 +9,57 @@
  * This program wraps the mounting of FUSE filesystems that run in systemd
  */
 #define _GNU_SOURCE
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
 #include "fuse_config.h"
 #include "mount_service.h"
 
+static int check_service(const char *fstype)
+{
+	if (!fstype) {
+		fprintf(stderr,
+			"fuservicemount: expected fs type for --check\n");
+		return EXIT_FAILURE;
+	}
+
+	return mount_service_present(fstype) ? EXIT_SUCCESS : EXIT_FAILURE;
+}
+
 int main(int argc, char *argv[])
 {
+	char *fstype = NULL;
+	bool check = false;
+	int i;
+
+	/*
+	 * If the user passes us exactly the args -t FSTYPE --check then
+	 * we'll just check if there's a service for the FSTYPE fuse server.
+	 * This doesn't tell us if the listening socket is actually connected
+	 * to anything.
+	 */
+	for (i = 1; i < argc; i++) {
+		if (!strcmp(argv[i], "--check")) {
+			if (check) {
+				check = false;
+				break;
+			}
+			check = true;
+		} else if (!strcmp(argv[i], "-t") && i + 1 < argc) {
+			if (fstype) {
+				check = false;
+				break;
+			}
+			fstype = argv[i + 1];
+			i++;
+		} else {
+			check = false;
+			break;
+		}
+	}
+	if (check)
+		return check_service(fstype);
+
 	return mount_service_main(argc, argv);
 }
diff --git a/util/meson.build b/util/meson.build
index aa646ef3c77d16..85b54d5d322dcb 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -6,21 +6,27 @@ executable('fusermount3', ['fusermount.c', '../lib/mount_util.c', '../lib/util.c
            install_dir: get_option('bindir'),
            c_args: '-DFUSE_CONF="@0@"'.format(fuseconf_path))
 
+mount_service_sources = []
+mount_service_cflags = []
 if private_cfg.get('HAVE_SERVICEMOUNT', false)
-  executable('fuservicemount3', ['mount_service.c', 'fuservicemount.c', '../lib/mount_util.c', 'fuser_conf.c'],
+  mount_service_sources += ['mount_service.c', '../lib/mount_util.c', 'fuser_conf.c']
+  mount_service_cflags += ['-DFUSE_CONF="@0@"'.format(fuseconf_path)]
+  fuservicemount_path = join_paths(get_option('prefix'), get_option('sbindir'))
+  mount_service_cflags += ['-DFUSERVICEMOUNT_DIR="@0@"'.format(fuservicemount_path)]
+  executable('fuservicemount3', ['fuservicemount.c'] + mount_service_sources,
              include_directories: include_dirs,
              link_with: [ libfuse ],
              install: true,
              install_dir: get_option('sbindir'),
-             c_args: ['-DFUSE_USE_VERSION=319', '-DFUSE_CONF="@0@"'.format(fuseconf_path)])
+             c_args: ['-DFUSE_USE_VERSION=319'] + mount_service_cflags)
 endif
 
-executable('mount.fuse3', ['mount.fuse.c'],
+executable('mount.fuse3', ['mount.fuse.c'] + mount_service_sources,
            include_directories: include_dirs,
            link_with: [ libfuse ],
            install: true,
            install_dir: get_option('sbindir'),
-           c_args: '-DFUSE_USE_VERSION=317')
+           c_args: ['-DFUSE_USE_VERSION=319'] + mount_service_cflags)
 
 
 udevrulesdir = get_option('udevrulesdir')
diff --git a/util/mount.fuse.c b/util/mount.fuse.c
index 382f77165a903c..802d7f99fe7815 100644
--- a/util/mount.fuse.c
+++ b/util/mount.fuse.c
@@ -6,6 +6,9 @@
   See the file GPL2.txt.
 */
 
+/* For environ */
+#define _GNU_SOURCE
+
 #include "fuse_config.h"
 
 #include <stdio.h>
@@ -17,6 +20,9 @@
 #include <fcntl.h>
 #include <pwd.h>
 #include <sys/wait.h>
+#ifdef HAVE_SERVICEMOUNT
+#include <spawn.h>
+#endif
 
 #ifdef linux
 #include <sys/prctl.h>
@@ -49,6 +55,9 @@
 #endif
 
 #include "fuse.h"
+#ifdef HAVE_SERVICEMOUNT
+# include "mount_service.h"
+#endif
 
 static char *progname;
 
@@ -233,6 +242,107 @@ static void drop_and_lock_capabilities(void)
 }
 #endif
 
+#ifdef HAVE_SERVICEMOUNT
+#define FUSERVICEMOUNT_PROG	"fuservicemount3"
+
+static int mount_service_child(char **argv)
+{
+	const char *full_path = FUSERVICEMOUNT_DIR "/" FUSERVICEMOUNT_PROG;
+	pid_t child_pid;
+	int child_status;
+	int ret;
+
+	/*
+	 * First try the install path, then a system install, just like we do
+	 * for fusermount.  See man 7 environ for the global environ pointer.
+	 */
+	ret = posix_spawn(&child_pid, full_path, NULL, NULL,
+			  (char *const *)argv, environ);
+	if (ret)
+		ret = posix_spawnp(&child_pid, FUSERVICEMOUNT_PROG, NULL, NULL,
+				   (char * const *)argv, environ);
+	if (ret) {
+		fprintf(stderr, "%s: could not start %s helper: %s\n",
+			argv[0], FUSERVICEMOUNT_PROG, strerror(ret));
+		return MOUNT_SERVICE_FALLBACK_NEEDED;
+	}
+
+	do {
+		ret = waitpid(child_pid, &child_status, 0);
+	} while (ret < 0 && errno == EINTR);
+	if (ret < 0) {
+		fprintf(stderr, "%s: could not wait for %s helper: %s\n",
+			argv[0], FUSERVICEMOUNT_PROG, strerror(errno));
+		return MOUNT_SERVICE_FALLBACK_NEEDED;
+	}
+
+	if (WIFEXITED(child_status))
+		return WEXITSTATUS(child_status);
+
+	/* terminated due to signal or coredump */
+	return EXIT_FAILURE;
+}
+
+static int try_service_main(char *argv0, char *fstype, char *source,
+			    const char *mountpoint, char *options)
+{
+	char **argv;
+	char dash_o[] = "-o";
+	char dash_t[] = "-t";
+	char *mntpt;
+	int argc = 5; /* argv[0], -t type, mountpoint, and trailing NULL */
+	int i = 0;
+	int ret;
+
+	if (!mount_service_present(fstype))
+		return MOUNT_SERVICE_FALLBACK_NEEDED;
+
+	/* This can be an empty string if "mount.fuse3 null# /tmp/a" */
+	if (source && source[0] == 0)
+		source = NULL;
+
+	mntpt = strdup(mountpoint);
+	if (!mntpt) {
+		perror("mountpoint allocation");
+		return -1;
+	}
+
+	if (source)
+		argc++;
+	if (options)
+		argc += 2;
+
+	argv = calloc(argc, sizeof(char *));
+	if (!argv) {
+		perror("argv allocation");
+		free(mntpt);
+		return -1;
+	}
+
+	argv[i++] = argv0;
+	if (source)
+		argv[i++] = source;
+	argv[i++] = mntpt;
+	argv[i++] = dash_t;
+	argv[i++] = fstype;
+	if (options) {
+		argv[i++] = dash_o;
+		argv[i++] = options;
+	}
+	argv[i] = 0;
+
+	if (getuid() != 0) {
+		ret = mount_service_child(argv);
+	} else {
+		/* We're root, just do the mount directly. */
+		ret = mount_service_main(argc - 1, argv);
+	}
+	free(argv);
+	free(mntpt);
+	return ret;
+}
+#endif
+
 int main(int argc, char *argv[])
 {
 	char *type = NULL;
@@ -280,9 +390,7 @@ int main(int argc, char *argv[])
 	mountpoint = argv[2];
 
 	for (i = 3; i < argc; i++) {
-		if (strcmp(argv[i], "-v") == 0) {
-			continue;
-		} else if (strcmp(argv[i], "-t") == 0) {
+		if (strcmp(argv[i], "-t") == 0) {
 			i++;
 
 			if (i == argc) {
@@ -303,6 +411,30 @@ int main(int argc, char *argv[])
 					progname);
 				exit(1);
 			}
+		}
+	}
+
+	if (!type) {
+		if (source) {
+			dup_source = xstrdup(source);
+			type = dup_source;
+			source = strchr(type, '#');
+			if (source)
+				*source++ = '\0';
+			if (!type[0]) {
+				fprintf(stderr, "%s: empty filesystem type\n",
+					progname);
+				exit(1);
+			}
+		} else {
+			fprintf(stderr, "%s: empty source\n", progname);
+			exit(1);
+		}
+	}
+
+	for (i = 3; i < argc; i++) {
+		if (strcmp(argv[i], "-v") == 0) {
+			continue;
 		} else	if (strcmp(argv[i], "-o") == 0) {
 			char *opts;
 			const char *opt;
@@ -366,24 +498,6 @@ int main(int argc, char *argv[])
 	if (suid)
 		options = add_option("suid", options);
 
-	if (!type) {
-		if (source) {
-			dup_source = xstrdup(source);
-			type = dup_source;
-			source = strchr(type, '#');
-			if (source)
-				*source++ = '\0';
-			if (!type[0]) {
-				fprintf(stderr, "%s: empty filesystem type\n",
-					progname);
-				exit(1);
-			}
-		} else {
-			fprintf(stderr, "%s: empty source\n", progname);
-			exit(1);
-		}
-	}
-
 	if (setuid_name && setuid_name[0]) {
 #ifdef linux
 		if (drop_privileges) {
@@ -429,6 +543,21 @@ int main(int argc, char *argv[])
 		drop_and_lock_capabilities();
 	}
 #endif
+
+#ifdef HAVE_SERVICEMOUNT
+	/*
+	 * Now that we know the desired filesystem type, see if we can find
+	 * a socket service implementing that, if we haven't selected any weird
+	 * options that would prevent that.
+	 */
+	if (!pass_fuse_fd && !(setuid_name && setuid_name[0])) {
+		int ret = try_service_main(argv[0], type, source, mountpoint,
+					   options);
+		if (ret != MOUNT_SERVICE_FALLBACK_NEEDED)
+			return ret;
+	}
+#endif
+
 	add_arg(&command, type);
 	if (source)
 		add_arg(&command, source);
diff --git a/util/mount_service.c b/util/mount_service.c
index 95de56f2b625fe..bc5940bc900dad 100644
--- a/util/mount_service.c
+++ b/util/mount_service.c
@@ -2066,3 +2066,46 @@ int mount_service_main(int argc, char *argv[])
 	mount_service_destroy(&mo);
 	return ret;
 }
+
+bool mount_service_present(const char *fstype)
+{
+	struct sockaddr_un name;
+	struct stat stbuf;
+	char path[PATH_MAX];
+	const char *subtype;
+	ssize_t written;
+	int ret;
+
+	subtype = mount_service_subtype(fstype);
+	if (!subtype)
+		return false;
+
+	/*
+	 * The full path to the socket must fit within the AF_UNIX socket path
+	 * buffer, which is much shorter than PATH_MAX.
+	 */
+	written = snprintf(path, sizeof(path), FUSE_SERVICE_SOCKET_DIR "/%s",
+			   subtype);
+	if (written >= sizeof(name.sun_path) || written >= sizeof(path))
+		return false;
+
+	ret = stat(path, &stbuf);
+	if (ret)
+		return false;
+
+	if (!S_ISSOCK(stbuf.st_mode))
+		return false;
+
+#ifdef HAVE_FACCESSAT
+	/*
+	 * Can we write to the service socket with the real uid?  This accounts
+	 * for setuid and ACLs on the socket.  Note that we connect() to the
+	 * socket having dropped setuid privileges.
+	 */
+	ret = faccessat(AT_FDCWD, path, W_OK, 0);
+#else
+	/* Can we write to the service socket with the real uid? */
+	ret = access(path, W_OK);
+#endif
+	return ret == 0;
+}

