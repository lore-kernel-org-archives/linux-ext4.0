From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/49] misc: fix header complaints and resource leaks in
 e2fsprogs
Date: Mon, 10 Mar 2014 23:55:53 -0700
Message-ID: <20140311065553.30585.86527.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaCKGz5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:57 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a few minor bugs that cppcheck complained about.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c   |    1 +
 debugfs/util.c      |    2 +-
 e2fsck/unix.c       |    1 +
 lib/ext2fs/icount.c |    2 ++
 util/subst.c        |    3 +++
 5 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index a10446d..72ab040 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -657,6 +657,7 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 	}
 	if (printed)
 		fprintf(f, "\n");
+	ext2fs_extent_free(handle);
 }
 
 static void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num)
diff --git a/debugfs/util.c b/debugfs/util.c
index 9ddfe0b..5cc4e22 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -201,7 +201,7 @@ char *time_to_string(__u32 cl)
 		tz = ss_safe_getenv("TZ");
 		if (!tz)
 			tz = "";
-		do_gmt = !strcmp(tz, "GMT") | !strcmp(tz, "GMT0");
+		do_gmt = !strcmp(tz, "GMT") || !strcmp(tz, "GMT0");
 	}
 
 	return asctime((do_gmt) ? gmtime(&t) : localtime(&t));
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b39383d..11c2693 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1016,6 +1016,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 			strcat(newpath, oldpath);
 		}
 		putenv(newpath);
+		free(newpath);
 	}
 #ifdef CONFIG_JBD_DEBUG
 	jbd_debug = getenv("E2FSCK_JBD_DEBUG");
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index a3b20f0..7d1b3d5 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -198,6 +198,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	fd = mkstemp(fn);
 	if (fd < 0) {
 		retval = errno;
+		ext2fs_free_mem(&fn);
 		goto errout;
 	}
 	umask(save_umask);
@@ -216,6 +217,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	close(fd);
 	if (icount->tdb == NULL) {
 		retval = errno;
+		ext2fs_free_mem(&fn);
 		goto errout;
 	}
 	*ret = icount;
diff --git a/util/subst.c b/util/subst.c
index 2ea16d9..32d5293 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -17,6 +17,9 @@
 #include <fcntl.h>
 #include <time.h>
 #include <utime.h>
+#ifdef HAVE_SYS_TIME_H
+#include <sys/time.h>
+#endif
 
 #ifdef HAVE_GETOPT_H
 #include <getopt.h>

