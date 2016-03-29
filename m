From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH e2fsprogs] include sys/sysmacros.h as needed
Date: Mon, 28 Mar 2016 20:42:48 -0400
Message-ID: <1459212168-25407-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41822 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbcC2Amx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2016 20:42:53 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 93D61340943
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 00:42:52 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The minor/major/makedev macros are not entirely standard.  glibc has had
the definitions in sys/sysmacros.h since the start, and wants to move away
from always defining them implicitly via sys/types.h (as this pollutes the
namespace in violation of POSIX).  Other C libraries have already dropped
them.  Since the configure script already checks for this header, use that
to pull in the header in files that use these macros.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 debugfs/debugfs.c      | 3 +++
 lib/blkid/devname.c    | 3 +++
 lib/blkid/devno.c      | 3 +++
 lib/ext2fs/finddev.c   | 3 +++
 lib/ext2fs/ismounted.c | 3 +++
 misc/create_inode.c    | 4 ++++
 misc/mk_hugefiles.c    | 3 +++
 7 files changed, 22 insertions(+)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 0cf0837..f8b30a2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -26,6 +26,9 @@ extern char *optarg;
 #include <errno.h>
 #endif
 #include <fcntl.h>
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 
 #include "debugfs.h"
 #include "uuid/uuid.h"
diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 3e2efa9..671e781 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -36,6 +36,9 @@
 #if HAVE_SYS_MKDEV_H
 #include <sys/mkdev.h>
 #endif
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 #include <time.h>
 
 #include "blkidP.h"
diff --git a/lib/blkid/devno.c b/lib/blkid/devno.c
index 479d977..61e6fc7 100644
--- a/lib/blkid/devno.c
+++ b/lib/blkid/devno.c
@@ -31,6 +31,9 @@
 #if HAVE_SYS_MKDEV_H
 #include <sys/mkdev.h>
 #endif
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 
 #include "blkidP.h"
 
diff --git a/lib/ext2fs/finddev.c b/lib/ext2fs/finddev.c
index 311608d..62fa0db 100644
--- a/lib/ext2fs/finddev.c
+++ b/lib/ext2fs/finddev.c
@@ -31,6 +31,9 @@
 #if HAVE_SYS_MKDEV_H
 #include <sys/mkdev.h>
 #endif
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index e0f69dd..7404996 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -49,6 +49,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
diff --git a/misc/create_inode.c b/misc/create_inode.c
index 0de5719..03a5ba9 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -22,6 +22,10 @@
 #include <attr/xattr.h>
 #endif
 #include <sys/ioctl.h>
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
+
 #include <ext2fs/ext2fs.h>
 #include <ext2fs/ext2_types.h>
 #include <ext2fs/fiemap.h>
diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 71a15c5..00e95cd 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -35,6 +35,9 @@ extern int optind;
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
 #include <libgen.h>
 #include <limits.h>
 #include <blkid/blkid.h>
-- 
2.7.4

