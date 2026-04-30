Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A0539A7E5;
	Thu, 30 Apr 2026 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583718; cv=none; b=aDypkFCeeT2aTan9knwOmHqnuqDjbuTpQIxjIVJtGxJzfnsWtvdn4aNO0dYjrYITC4kXIi82H4MIO2jIXHqWV9IIZRMcuu/1zObuLkWUAcAQOYuun0rAn/tBZv0rZDSAgctRfx0caHJsPJpSOjnjSbm+o0mX+aXlV6fyHrU9KRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583718; c=relaxed/simple;
	bh=EOymO4oY61WWpzMPS6eh41i6TXvJ89URZSns2tmAPJk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mw9MVqfFsMa3HNwZ2pKaT2FSQ0Z+VzUGjEThEs8PZFEA/O3zsLTgIInA/efpmKGGuRSqEJ2EEBUWGqiBh+3dGTWsqQRdRJB3PNm+XIaPHSzXXhkOvHlsgvpg0Xw64Hi2PgszAbxCzYXmksWBW8Tye9gpKm8pXxxVRQ4hvJTwPVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3sCIWar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3sCIWar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3BCC2BCB3;
	Thu, 30 Apr 2026 21:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583717;
	bh=EOymO4oY61WWpzMPS6eh41i6TXvJ89URZSns2tmAPJk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B3sCIWarHW64fPwvz0M55mUM6tLsDlqoyKbrBrLkPa8R5hqx2V7XmsaSfoYtJGIgf
	 TkO303b0IwzCPbsz4/FF7MbCJSc13FDOfxB2g4ATYWf8iWZ6ynB3ne07lg95UQ7Dng
	 h5LKBK+EH3vkgYGfhEbxdzoLc0+4CW0NKIqWWWiGDZlv6dvXfl5+pTPdA+FnwqJdYR
	 8zQ96yorNeCGlldHx2uuSMoISmLBKL95lA8sqwvnaurQxFob1woAG5I4owM0fInN7q
	 ttMXOduFhJ++B6QheJ3vc98NroEJWpGpWBA+3FpNh9Mlt08njAR+uKffBlwE0FZ8nG
	 FhVPQFscpT2Og==
Date: Thu, 30 Apr 2026 14:15:17 -0700
Subject: [PATCH 01/13] Refactor mount code / move common functions to
 mount_util.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363550.1314717.5871127121158541585.stgit@frogsfrogsfrogs>
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

From: Bernd Schubert <bernd@bsbernd.com>

Also create the new "mount_i.h", which is independent of the
the rest of libfuse.

This is preparation for the new mount API, which goes into a new file.

This is to allow fusermount to use the code from mount_fsmount.c.
I.e. avoid code dup and add just re-use the new linux api mount
functions from that file for fusermount.

Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
[djwong: extract only the parts we need for mount services]
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/mount_common_i.h |   18 +++++++++++++++++
 lib/mount_util.h     |    8 ++++++++
 lib/mount.c          |   53 ++++++++++++++++++++++++++++++++++++--------------
 lib/mount_util.c     |    9 ++++++++
 util/fusermount.c    |    5 +----
 5 files changed, 74 insertions(+), 19 deletions(-)
 create mode 100644 lib/mount_common_i.h


diff --git a/lib/mount_common_i.h b/lib/mount_common_i.h
new file mode 100644
index 00000000000000..6bcb055ff1c23f
--- /dev/null
+++ b/lib/mount_common_i.h
@@ -0,0 +1,18 @@
+/*
+ *  FUSE: Filesystem in Userspace
+ *  Copyright (C) 2001-2007  Miklos Szeredi <miklos@szeredi.hu>
+ *                2026 Bernd Schubert <bernd@bsbernd.com>
+ *
+ *  This program can be distributed under the terms of the GNU LGPLv2.
+ *  See the file LGPL2.txt
+ */
+
+#ifndef FUSE_MOUNT_COMMON_I_H_
+#define FUSE_MOUNT_COMMON_I_H_
+
+struct mount_opts;
+
+char *fuse_mnt_build_source(const struct mount_opts *mo);
+char *fuse_mnt_build_type(const struct mount_opts *mo);
+
+#endif /* FUSE_MOUNT_COMMON_I_H_ */
diff --git a/lib/mount_util.h b/lib/mount_util.h
index 9cb9077dd17738..b54392abb8b07d 100644
--- a/lib/mount_util.h
+++ b/lib/mount_util.h
@@ -6,6 +6,9 @@
   See the file LGPL2.txt.
 */
 
+#ifndef FUSE_MOUNT_UTIL_H_
+#define FUSE_MOUNT_UTIL_H_
+
 #include <sys/types.h>
 
 int fuse_mnt_add_mount(const char *progname, const char *fsname,
@@ -16,3 +19,8 @@ int fuse_mnt_umount(const char *progname, const char *abs_mnt,
 char *fuse_mnt_resolve_path(const char *progname, const char *orig);
 int fuse_mnt_check_fuseblk(void);
 int fuse_mnt_parse_fuse_fd(const char *mountpoint);
+
+/* Helper functions for mount operations */
+const char *fuse_mnt_get_devname(void);
+
+#endif /* FUSE_MOUNT_UTIL_H_ */
diff --git a/lib/mount.c b/lib/mount.c
index c56a9da1fe8014..2397c3fb2aa26b 100644
--- a/lib/mount.c
+++ b/lib/mount.c
@@ -31,6 +31,7 @@
 #include <sys/wait.h>
 
 #include "fuse_mount_compat.h"
+#include "mount_common_i.h"
 
 #ifdef __NetBSD__
 #include <perfuse.h>
@@ -49,7 +50,6 @@
 #define FUSERMOUNT_PROG		"fusermount3"
 #define FUSE_COMMFD_ENV		"_FUSE_COMMFD"
 #define FUSE_COMMFD2_ENV	"_FUSE_COMMFD2"
-#define FUSE_KERN_DEVICE_ENV	"FUSE_KERN_DEVICE"
 
 #ifndef MS_DIRSYNC
 #define MS_DIRSYNC 128
@@ -510,7 +510,7 @@ static int fuse_mount_sys(const char *mnt, struct mount_opts *mo,
 			  const char *mnt_opts)
 {
 	char tmp[128];
-	const char *devname = getenv(FUSE_KERN_DEVICE_ENV) ?: "/dev/fuse";
+	const char *devname = fuse_mnt_get_devname();
 	char *source = NULL;
 	char *type = NULL;
 	struct stat stbuf;
@@ -550,24 +550,13 @@ static int fuse_mount_sys(const char *mnt, struct mount_opts *mo,
 	if (res == -1)
 		goto out_close;
 
-	source = malloc((mo->fsname ? strlen(mo->fsname) : 0) +
-			(mo->subtype ? strlen(mo->subtype) : 0) +
-			strlen(devname) + 32);
-
-	type = malloc((mo->subtype ? strlen(mo->subtype) : 0) + 32);
+	source = fuse_mnt_build_source(mo);
+	type = fuse_mnt_build_type(mo);
 	if (!type || !source) {
 		fuse_log(FUSE_LOG_ERR, "fuse: failed to allocate memory\n");
 		goto out_close;
 	}
 
-	strcpy(type, mo->blkdev ? "fuseblk" : "fuse");
-	if (mo->subtype) {
-		strcat(type, ".");
-		strcat(type, mo->subtype);
-	}
-	strcpy(source,
-	       mo->fsname ? mo->fsname : (mo->subtype ? mo->subtype : devname));
-
 	res = mount(source, mnt, type, mo->flags, mo->kernel_opts);
 	if (res == -1 && errno == ENODEV && mo->subtype) {
 		/* Probably missing subtype support */
@@ -727,3 +716,37 @@ int fuse_kern_mount(const char *mountpoint, struct mount_opts *mo)
 	free(mnt_opts);
 	return res;
 }
+
+char *fuse_mnt_build_source(const struct mount_opts *mo)
+{
+	const char *devname = fuse_mnt_get_devname();
+	char *source;
+
+	source = malloc((mo->fsname ? strlen(mo->fsname) : 0) +
+			(mo->subtype ? strlen(mo->subtype) : 0) +
+			strlen(devname) + 32);
+	if (!source)
+		return NULL;
+
+	strcpy(source,
+	       mo->fsname ? mo->fsname : (mo->subtype ? mo->subtype : devname));
+
+	return source;
+}
+
+char *fuse_mnt_build_type(const struct mount_opts *mo)
+{
+	char *type;
+
+	type = malloc((mo->subtype ? strlen(mo->subtype) : 0) + 32);
+	if (!type)
+		return NULL;
+
+	strcpy(type, mo->blkdev ? "fuseblk" : "fuse");
+	if (mo->subtype) {
+		strcat(type, ".");
+		strcat(type, mo->subtype);
+	}
+
+	return type;
+}
diff --git a/lib/mount_util.c b/lib/mount_util.c
index 5746e8ed06b736..bdafeda7567fbd 100644
--- a/lib/mount_util.c
+++ b/lib/mount_util.c
@@ -377,3 +377,12 @@ int fuse_mnt_parse_fuse_fd(const char *mountpoint)
 
 	return -1;
 }
+
+#define FUSE_KERN_DEVICE_ENV	"FUSE_KERN_DEVICE"
+
+const char *fuse_mnt_get_devname(void)
+{
+	const char *devname = getenv(FUSE_KERN_DEVICE_ENV);
+
+	return devname ? devname : "/dev/fuse";
+}
diff --git a/util/fusermount.c b/util/fusermount.c
index a5ed4d26dd4d27..68370468140a59 100644
--- a/util/fusermount.c
+++ b/util/fusermount.c
@@ -47,9 +47,6 @@
 #endif
 
 #define FUSE_COMMFD_ENV		"_FUSE_COMMFD"
-#define FUSE_KERN_DEVICE_ENV	"FUSE_KERN_DEVICE"
-
-#define FUSE_DEV "/dev/fuse"
 
 static const char *progname;
 
@@ -1262,7 +1259,7 @@ static int mount_fuse(const char *mnt, const char *opts, const char **type)
 {
 	int res;
 	int fd;
-	const char *dev = getenv(FUSE_KERN_DEVICE_ENV) ?: FUSE_DEV;
+	const char *dev = fuse_mnt_get_devname();
 	struct stat stbuf;
 	char *source = NULL;
 	char *mnt_opts = NULL;

