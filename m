From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] fsstress: Add fallocate collapse range operation
Date: Wed,  2 Apr 2014 17:33:20 +0200
Message-ID: <1396452800-25775-2-git-send-email-lczerner@redhat.com>
References: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This commit adds collapse operation support for fsstress, which is
meant to exercise fallocate FALLOC_FL_COLLAPSE_RANGE support.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index fd258bf..1eec11a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -71,6 +71,7 @@ typedef enum {
 	OP_MKNOD,
 	OP_PUNCH,
 	OP_ZERO,
+	OP_COLLAPSE,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -168,6 +169,7 @@ void	mkdir_f(int, long);
 void	mknod_f(int, long);
 void	punch_f(int, long);
 void	zero_f(int, long);
+void	collapse_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -206,6 +208,7 @@ opdesc_t	ops[] = {
 	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
 	{ OP_ZERO, "zero", zero_f, 1, 1 },
+	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -2173,6 +2176,7 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
+	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ -1, NULL}
 };
 
@@ -2223,6 +2227,14 @@ do_fallocate(int opno, long r, int mode)
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
+	/*
+	 * Collapse range requires off and len to be block aligned, make it
+	 * more likely to be the case.
+	 */
+	if (FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
+		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
+		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
+	}
 	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
 	if (v)
@@ -2637,6 +2649,14 @@ zero_f(int opno, long r)
 }
 
 void
+collapse_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, FALLOC_FL_COLLAPSE_RANGE);
+#endif
+}
+
+void
 read_f(int opno, long r)
 {
 	char		*buf;
-- 
1.8.3.1

