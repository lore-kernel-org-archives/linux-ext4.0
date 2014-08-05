From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/21] e2fuzz: fix build problems on macosx and i386 linux
Date: Mon, 04 Aug 2014 18:05:04 -0700
Message-ID: <20140805010504.2611.14307.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44110 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaHEBFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:09 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix clang warnings about forgotten header files, dead code, and pwrite
support on OS X.  The unistd.h inclusion also fixes a parameter
truncation bug on i386.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2fuzz.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)


diff --git a/misc/e2fuzz.c b/misc/e2fuzz.c
index 8c989dd..91aafe5 100644
--- a/misc/e2fuzz.c
+++ b/misc/e2fuzz.c
@@ -18,6 +18,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <stdint.h>
+#include <unistd.h>
 #ifdef HAVE_GETOPT_H
 #include <getopt.h>
 #endif
@@ -31,6 +32,16 @@ static int metadata_only = 1;
 static unsigned long long user_corrupt_bytes = 0;
 static double user_corrupt_pct = 0.0;
 
+#ifndef HAVE_PWRITE
+ssize_t pwrite(int fd, const void *buf, size_t count, off_t offset)
+{
+	if (lseek(fd, offset, SEEK_SET) < 0)
+		return 0;
+
+	return write(fd, buf, count);
+}
+#endif /* HAVE_PWRITE */
+
 int getseed(void)
 {
 	int r;
@@ -70,7 +81,7 @@ errcode_t find_metadata_blocks(ext2_filsys fs, ext2fs_block_bitmap bmap,
 			       off_t *corrupt_bytes)
 {
 	dgrp_t i;
-	blk64_t b, c, d, j, old_desc_blocks;
+	blk64_t b, c;
 	ext2_inode_scan scan;
 	ext2_ino_t ino;
 	struct ext2_inode inode;
@@ -79,12 +90,6 @@ errcode_t find_metadata_blocks(ext2_filsys fs, ext2fs_block_bitmap bmap,
 
 	*corrupt_bytes = 0;
 	fb.corrupt_blocks = 0;
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT2_FEATURE_INCOMPAT_META_BG))
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks +
-				  fs->super->s_reserved_gdt_blocks;
 
 	/* Construct bitmaps of super/descriptor blocks */
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -271,7 +276,7 @@ int process_fs(const char *fsname)
 			       off % fs->blocksize, off / fs->blocksize, c);
 		if (dryrun)
 			continue;
-		if (pwrite64(fd, &c, sizeof(c), off) != sizeof(c)) {
+		if (pwrite(fd, &c, sizeof(c), off) != sizeof(c)) {
 			perror(fsname);
 			goto fail3;
 		}

