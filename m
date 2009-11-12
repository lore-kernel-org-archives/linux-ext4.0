From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH v2][64-bit e2fsprogs] 64-bit block number truncated in e2sck
 pass2.
Date: Thu, 12 Nov 2009 01:01:58 -0500
Message-ID: <10898.1258005718@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173003pub.verizon.net ([206.46.173.3]:52621 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZKLHBa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Nov 2009 02:01:30 -0500
Received: from gamaville.dokosmarshall.org ([173.76.32.106])
 by vms173003.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KSZ007CJFEAD4C4@vms173003.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Thu, 12 Nov 2009 00:01:34 -0600 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The first version of this patch (see
http://marc.info/?l=linux-ext4&m=125682539524168&w=2) dealt with the
problem of a directory whose blocks were beyond the 32-bit
boundary. e2fsck was truncating the block number in pass 2 and
generating spurious errors. The fix was to replace a call to
ext2fs_read_dir_block() by the corresponding 64-bit safe call to
ext2fs_read_dir_block3().

However, there is another call to ext2fs_read_dir_block() in 
pass 1, specifically in the routine check_is_really_dir(),
a routine with a question mark over its head. Andreas Dilger
recommended that the routine should stay, so I've gone ahead
and fixed it up to deal with extent-mapped inodes as well.
I also added some comments reflecting my (possibly faulty)
understanding of what the routine is trying to do, so I'd
appreciate comments/corrections. In particular, I don't
quite understand why the relevant index for deciding whether
something can or cannot be a device file is 4, so I've left
it unchanged.

I'll follow up with another email that contains a couple
of test cases.

Thanks,
Nick

>From 44de200d84379ed6debb1bf054de57a8828a9e0d Mon Sep 17 00:00:00 2001
From: Nick Dokos <nicholas.dokos@hp.com>
Date: Wed, 11 Nov 2009 21:21:36 -0500
Subject: [PATCH] Deal with 64-bit block numbers in directory.

e2fsck was truncating the (> 2^32) block number of a directory in pass 2
and generating spurious errors. The fix is to replace a call to
ext2fs_read_dir_block() by the corresponding 64-bit safe call to
ext2fs_read_dir_block3().

The pass1 check_is_really_dir() function (which uses the above function,
and therefore needs the same fix) needs additional changes to deal with
extent-mapped inodes.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 e2fsck/pass1.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-----------
 e2fsck/pass2.c |    2 +-
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 557d642..fcae923 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -405,34 +405,71 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	errcode_t		retval;
 	blk64_t			blk;
 	unsigned int		i, rec_len, not_device = 0;
+	int			extent_fs;
 
+	/* If the mode looks OK, we believe it.  If the first block in
+	 * the i_block array is 0, this cannot be a directory. If the
+	 * inode is extent-mapped, it is still the case that the latter
+	 * cannot be 0 - the magic number in the extent header would make
+	 * it nonzero.
+	 */
 	if (LINUX_S_ISDIR(inode->i_mode) || LINUX_S_ISREG(inode->i_mode) ||
 	    LINUX_S_ISLNK(inode->i_mode) || inode->i_block[0] == 0)
 		return;
 
-	for (i=0; i < EXT2_N_BLOCKS; i++) {
-		blk = inode->i_block[i];
-		if (!blk)
-			continue;
-		if (i >= 4)
-			not_device++;
+	/* Check the block numbers in the i_block array for validity:
+	 * zero blocks are skipped (but the first one cannot be zero - see above),
+	 * other blocks are checked against the first and max data blocks (from the
+	 * the superblock) and against the block bitmap. Any invalid block found
+	 * means this cannot be a directory.
+	 * 
+	 * If there are non-zero blocks past the fourth entry, then this cannot be
+	 * a device file: we remember that for the next check.
+	 *
+	 * For extent mapped files, we don't do any sanity checking: just try to
+	 * get the phys block of logical block 0 and run with it.
+	 */
+	extent_fs = (ctx->fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
+		/* extent mapped */
+		if  (ext2fs_bmap2(ctx->fs, pctx->ino, inode, 0, 0, 0, 0, &blk))
+			return;
+		/* device files are never extent mapped */
+		not_device++;
+	} else {
+		for (i=0; i < EXT2_N_BLOCKS; i++) {
+			blk = inode->i_block[i];
+			if (!blk)
+				continue;
+			if (i >= 4)
+				not_device++;
 
-		if (blk < ctx->fs->super->s_first_data_block ||
-		    blk >= ext2fs_blocks_count(ctx->fs->super) ||
-		    ext2fs_fast_test_block_bitmap2(ctx->block_found_map, blk))
-			return;	/* Invalid block, can't be dir */
+			if (blk < ctx->fs->super->s_first_data_block ||
+			    blk >= ext2fs_blocks_count(ctx->fs->super) ||
+			    ext2fs_fast_test_block_bitmap2(ctx->block_found_map, blk))
+				return;	/* Invalid block, can't be dir */
+		}
+		blk = (blk64_t) inode->i_block[0];
 	}
 
+	/* If the mode says this is a device file and the i_links_count field
+	 * is sane and we have not ruled it out as a device file previously,
+	 * we declare it a device file, not a directory.
+	 */
 	if ((LINUX_S_ISCHR(inode->i_mode) || LINUX_S_ISBLK(inode->i_mode)) &&
 	    (inode->i_links_count == 1) && !not_device)
 		return;
 
+	/* read the first block */
 	old_op = ehandler_operation(_("reading directory block"));
-	retval = ext2fs_read_dir_block(ctx->fs, inode->i_block[0], buf);
+	retval = ext2fs_read_dir_block3(ctx->fs, blk, buf, ctx->fs->flags);
 	ehandler_operation(0);
 	if (retval)
 		return;
 
+	/* the rest is independent of whether this is block-mapped or
+	 * extent-mapped, so it can remain untouched.
+	 */
 	dirent = (struct ext2_dir_entry *) buf;
 	retval = ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (retval)
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index b757131..7b75f83 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -780,7 +780,7 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	old_op = ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block(fs, block_nr, buf);
+	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, fs->flags);
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
-- 
1.6.0.6

