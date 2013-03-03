From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/2] filefrag: count a contiguous extent when both logical and physical blocks are contiguous
Date: Mon,  4 Mar 2013 00:26:18 +0800
Message-ID: <1362327978-30423-3-git-send-email-wenqing.lz@taobao.com>
References: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61263 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3CCQLY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2013 11:11:24 -0500
Received: by mail-pb0-f50.google.com with SMTP id up1so2615905pbc.37
        for <linux-ext4@vger.kernel.org>; Sun, 03 Mar 2013 08:11:24 -0800 (PST)
In-Reply-To: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit fixes a bug in filefrag that filefrag miss calculates
contiguous extent when physical blocks are contiguous but logical blocks
aren't.  This case can be created by xfstests #218 or the following
script.

	for I in `seq 0 2 31`; do
		dd if=/dev/zero of=$testfile bs=4k count=1 conv=notrunc \
			seek=$I oflag=sync &>/dev/null
	done

Meanwhile this commit prints expected logical block.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/filefrag.c | 49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index ee03a07..3af938f 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -116,16 +116,17 @@ static int get_bmap(int fd, unsigned long block, unsigned long *phy_blk)
 
 static void print_extent_header(void)
 {
-	printf(" ext: %*s %*s length: %*s flags:\n",
+	printf(" ext: %*s %*s length: %*s %*s flags:\n",
 	       logical_width * 2 + 3,
 	       "logical_offset:",
 	       physical_width * 2 + 3, "physical_offset:",
-	       physical_width + 1,
-	       "expected:");
+	       physical_width + 1, "log_expected:",
+	       physical_width + 1, "phy_expected:");
 }
 
 static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
-			      unsigned long long expected, int blk_shift,
+			      unsigned long long lexpected,
+			      unsigned long long pexpected, int blk_shift,
 			      ext2fs_struct_stat *st)
 {
 	unsigned long long physical_blk;
@@ -133,6 +134,8 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	unsigned long long ext_len;
 	unsigned long long ext_blks;
 	char flags[256] = "";
+	char logex_flags[32] = "";
+	char phyex_flags[32] = "";
 
 	/* For inline data all offsets should be in bytes, not blocks */
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
@@ -143,11 +146,20 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	logical_blk = fm_extent->fe_logical >> blk_shift;
 	physical_blk = fm_extent->fe_physical >> blk_shift;
 
-	if (expected)
-		sprintf(flags, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
-			physical_width, expected >> blk_shift);
+	if (lexpected)
+		sprintf(logex_flags, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
+			physical_width, lexpected >> blk_shift);
 	else
-		sprintf(flags, "%.*s  ", physical_width, "                   ");
+		sprintf(logex_flags, "%.*s  ", physical_width, "                   ");
+
+	if (pexpected)
+		sprintf(phyex_flags, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
+			physical_width, pexpected >> blk_shift);
+	else
+		sprintf(phyex_flags, "%.*s  ", physical_width, "                   ");
+
+	strcat(flags, logex_flags);
+	strcat(flags, phyex_flags);
 
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN)
 		strcat(flags, "unknown,");
@@ -188,7 +200,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
 	int count = (sizeof(buf) - sizeof(*fiemap)) /
 			sizeof(struct fiemap_extent);
-	unsigned long long expected = 0;
+	unsigned long long lexpected = 0, pexpected = 0;
 	unsigned long flags = 0;
 	unsigned int i;
 	static int fiemap_incompat_printed;
@@ -230,18 +242,21 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 
 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
 			if (fm_ext[i].fe_logical != 0 &&
-			    fm_ext[i].fe_physical != expected) {
+			    (fm_ext[i].fe_logical != lexpected ||
+			     fm_ext[i].fe_physical != pexpected)) {
 				tot_extents++;
 			} else {
-				expected = 0;
+				lexpected = 0;
+				pexpected = 0;
 				if (!tot_extents)
 					tot_extents = 1;
 			}
 			if (verbose)
-				print_extent_info(&fm_ext[i], n, expected,
-						  blk_shift, st);
+				print_extent_info(&fm_ext[i], n, lexpected,
+						  pexpected, blk_shift, st);
 
-			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
+			lexpected = fm_ext[i].fe_logical + fm_ext[i].fe_length;
+			pexpected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
 			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
 				last = 1;
 			n++;
@@ -308,7 +323,7 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 		if (force_extent && last_block != 0 &&
 		    (block != last_block + 1 ||
 		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
-			print_extent_info(&fm_ext, *num_extents - 1,
+			print_extent_info(&fm_ext, *num_extents - 1, logical,
 					  (last_block + 1) * st->st_blksize,
 					  blk_shift, st);
 			fm_ext.fe_logical = logical;
@@ -325,7 +340,7 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 	}
 
 	if (force_extent)
-		print_extent_info(&fm_ext, *num_extents - 1,
+		print_extent_info(&fm_ext, *num_extents - 1, logical,
 				  last_block * st->st_blksize, blk_shift, st);
 
 	return count;
@@ -339,7 +354,7 @@ static void frag_report(const char *filename)
 	long		fd;
 	unsigned long	numblocks;
 	int		data_blocks_per_cyl = 1;
-	int		num_extents = 1, expected = ~0;
+	int		num_extents = 1, expected = 0;
 	int		is_ext2 = 0;
 	static dev_t	last_device;
 	unsigned int	flags;
-- 
1.7.12.rc2.18.g61b472e

