From: Rakesh Pandit <rakesh@tuxera.com>
Subject: [PATCH] filefrag: fix block size value
Date: Thu, 24 Jul 2014 14:38:51 +0300
Message-ID: <20140724113850.GA14140@hercules.tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:46379 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbaGXLiz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 07:38:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ioctl(FIGETBSZ) was used to get block size earlier but 2508eaa7
(filefrag: improvements to filefrag FIEMAP handling) moved to fstatfs
f_bsize which doesn't work well for many files systems.

Block size returned using fstatfs isn't block size but "optimal
transfer block size" as per man page. Even stat st_blksize is
"preferred I/O block size" and in may file systems it may even vary
from file to file (POSIX). This patch returns back usage of FIGETBSZ
to get block size. For file systems which don't support FIEMAP, this
fixes the number of FIBMAP ioctl calls required.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 misc/filefrag.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index bb060b6..21de136 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -351,6 +351,7 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 static int frag_report(const char *filename)
 {
 	static struct statfs fsinfo;
+	static unsigned int blksize;
 	ext2fs_struct_stat st;
 	int		blk_shift;
 	long		fd;
@@ -381,22 +382,25 @@ static int frag_report(const char *filename)
 #endif
 		rc = -errno;
 		perror("stat");
-		close(fd);
-		return rc;
+		goto out_close;
 	}
 
 	if (last_device != st.st_dev) {
 		if (fstatfs(fd, &fsinfo) < 0) {
 			rc = -errno;
 			perror("fstatfs");
-			close(fd);
-			return rc;
+			goto out_close;
+		}
+		if (ioctl(fd, FIGETBSZ, &blksize) < 0) {
+			rc = -errno;
+			perror("FIGETBSZ");
+			goto out_close;
 		}
 		if (verbose)
 			printf("Filesystem type is: %lx\n",
 			       (unsigned long)fsinfo.f_type);
 	}
-	st.st_blksize = fsinfo.f_bsize;
+	st.st_blksize = blksize;
 	if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
 		flags = 0;
 	if (!(flags & EXT4_EXTENTS_FL) &&
@@ -405,13 +409,13 @@ static int frag_report(const char *filename)
 		is_ext2++;
 
 	if (is_ext2) {
-		long cylgroups = div_ceil(fsinfo.f_blocks, fsinfo.f_bsize * 8);
+		long cylgroups = div_ceil(fsinfo.f_blocks, blksize * 8);
 
 		if (verbose && last_device != st.st_dev)
 			printf("Filesystem cylinder groups approximately %ld\n",
 			       cylgroups);
 
-		data_blocks_per_cyl = fsinfo.f_bsize * 8 -
+		data_blocks_per_cyl = blksize * 8 -
 					(fsinfo.f_files / 8 / cylgroups) - 3;
 	}
 	last_device = st.st_dev;
@@ -420,11 +424,11 @@ static int frag_report(const char *filename)
 	if (width > physical_width)
 		physical_width = width;
 
-	numblocks = (st.st_size + fsinfo.f_bsize - 1) / fsinfo.f_bsize;
+	numblocks = (st.st_size + blksize - 1) / blksize;
 	if (blocksize != 0)
 		blk_shift = int_log2(blocksize);
 	else
-		blk_shift = int_log2(fsinfo.f_bsize);
+		blk_shift = int_log2(blksize);
 
 	width = int_log10(numblocks);
 	if (width > logical_width)
@@ -432,7 +436,7 @@ static int frag_report(const char *filename)
 	if (verbose)
 		printf("File size of %s is %llu (%llu block%s of %d bytes)\n",
 		       filename, (unsigned long long)st.st_size,
-		       numblocks * fsinfo.f_bsize >> blk_shift,
+		       numblocks * blksize >> blk_shift,
 		       numblocks == 1 ? "" : "s", 1 << blk_shift);
 
 	if (!force_bmap) {
-- 
1.9.3

