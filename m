From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/6] tune2fs: Zero inode table when removing checksums
Date: Wed, 28 Aug 2013 17:44:17 -0700
Message-ID: <20130829004417.3190.38773.stgit@blackbox.djwong.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27004 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab3H2AoW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 20:44:22 -0400
In-Reply-To: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When disabling group checksums, we have to initialize the inode table.  Right
now tune2fs doesn't do this; it merely punts to e2fsck to clean up the mess.
Unfortunately, if the "uninitialized" inode table contains things that look
like inodes (i_link_count > 0, specifically), the e2fsck tries to recover these
inodes.  This leads to it misinterpreting i_blocks as a block map, at which
point it needlessly resurrects phantom inodes and crosslinked file repairs.  As
part of initializing the block bitmaps, we must also mark block group metadata
blocks in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 100 insertions(+), 13 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c38711d..ddf3259 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -614,12 +614,13 @@ static errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
 static void rewrite_inodes(ext2_filsys fs)
 {
 	int length = EXT2_INODE_SIZE(fs->super);
-	struct ext2_inode *inode;
+	struct ext2_inode *inode, *zero;
 	char		*ea_buf;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
 	blk64_t		file_acl_block;
+	int		inode_dirty;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX)
 		return;
@@ -636,6 +637,12 @@ static void rewrite_inodes(ext2_filsys fs)
 		exit(1);
 	}
 
+	retval = ext2fs_get_memzero(length, &zero);
+	if (retval) {
+		com_err("set_csum", retval, "while allocating memory");
+		exit(1);
+	}
+
 	retval = ext2fs_get_mem(fs->blocksize, &ea_buf);
 	if (retval) {
 		com_err("set_csum", retval, "while allocating memory");
@@ -650,11 +657,25 @@ static void rewrite_inodes(ext2_filsys fs)
 		}
 		if (!ino)
 			break;
+		if (ext2fs_test_inode_bitmap2(fs->inode_map, ino)) {
+			inode_dirty = 1;
+		} else {
+			if (memcmp(inode, zero, length) != 0) {
+				memset(inode, 0, length);
+				inode_dirty = 1;
+			} else {
+				inode_dirty = 0;
+			}
+		}
 
-		retval = ext2fs_write_inode_full(fs, ino, inode, length);
-		if (retval) {
-			com_err("set_csum", retval, "while writing inode");
-			exit(1);
+		if (inode_dirty) {
+			retval = ext2fs_write_inode_full(fs, ino, inode,
+							 length);
+			if (retval) {
+				com_err("set_csum", retval, "while writing "
+					"inode");
+				exit(1);
+			}
 		}
 
 		retval = rewrite_extents(fs, ino, inode);
@@ -691,6 +712,7 @@ static void rewrite_inodes(ext2_filsys fs)
 		}
 	} while (ino);
 
+	ext2fs_free_mem(&zero);
 	ext2fs_free_mem(&inode);
 	ext2fs_free_mem(&ea_buf);
 	ext2fs_close_inode_scan(scan);
@@ -704,8 +726,8 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_init_csum_seed(fs);
 	for (i = 0; i < fs->group_desc_count; i++)
 		ext2fs_group_desc_csum_set(fs, i);
-	rewrite_inodes(fs);
 	ext2fs_read_bitmaps(fs);
+	rewrite_inodes(fs);
 	ext2fs_mark_ib_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 	ext2fs_mmp_update2(fs, 1);
@@ -733,10 +755,50 @@ static void enable_uninit_bg(ext2_filsys fs)
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 }
 
+static errcode_t zero_empty_inodes(ext2_filsys fs)
+{
+	int length = EXT2_INODE_SIZE(fs->super);
+	struct ext2_inode *inode;
+	ext2_inode_scan	scan;
+	errcode_t	retval;
+	ext2_ino_t	ino;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_get_mem(length, &inode);
+	if (retval)
+		goto out;
+
+	do {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
+		if (retval)
+			goto out;
+		if (!ino)
+			break;
+		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino)) {
+			memset(inode, 0, length);
+			retval = ext2fs_write_inode_full(fs, ino, inode,
+							 length);
+			if (retval)
+				goto out;
+		}
+	} while (1);
+
+out:
+	ext2fs_free_mem(&inode);
+	ext2fs_close_inode_scan(scan);
+	return retval;
+}
+
 static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 {
 	struct ext2_group_desc *gd;
 	dgrp_t i;
+	errcode_t retval;
+	blk64_t b, c, d;
+	int has_super;
 
 	/* Load bitmaps to ensure that the uninit ones get written out */
 	fs->super->s_feature_ro_compat |= csum_feature_flag;
@@ -745,21 +807,46 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 	ext2fs_mark_bb_dirty(fs);
 	fs->super->s_feature_ro_compat &= ~csum_feature_flag;
 
+	/* If we're only turning off uninit_bg, zero the inodes */
+	if (csum_feature_flag == EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		retval = zero_empty_inodes(fs);
+		if (retval) {
+			com_err("disable_uninit_bg", retval,
+				"while zeroing unused inodes");
+			request_fsck_afterwards(fs);
+		}
+	}
+
+	/* The bbitmap is zeroed; we must mark group metadata blocks in use */
 	for (i = 0; i < fs->group_desc_count; i++) {
-		gd = ext2fs_group_desc(fs, fs->group_desc, i);
-		if ((gd->bg_flags & EXT2_BG_INODE_ZEROED) == 0) {
-			/*
-			 * XXX what we really should do is zap
-			 * uninitialized inode tables instead.
-			 */
+		b = ext2fs_block_bitmap_loc(fs, i);
+		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, b));
+		b = ext2fs_inode_bitmap_loc(fs, i);
+		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, b));
+
+		retval = ext2fs_super_and_bgd_loc2(fs, i, &b, &c, &d, NULL);
+		if (retval == 0 && b)
+			ext2fs_mark_block_bitmap2(fs->block_map,
+						  EXT2FS_B2C(fs, b));
+		if (retval == 0 && c)
+			ext2fs_mark_block_bitmap2(fs->block_map,
+						  EXT2FS_B2C(fs, c));
+		if (retval == 0 && d)
+			ext2fs_mark_block_bitmap2(fs->block_map,
+						  EXT2FS_B2C(fs, d));
+		if (retval) {
+			com_err("disable_uninit_bg", retval,
+				"while initializing block bitmaps");
 			request_fsck_afterwards(fs);
-			break;
 		}
+
+		gd = ext2fs_group_desc(fs, fs->group_desc, i);
 		gd->bg_itable_unused = 0;
 		gd->bg_flags = 0;
 		ext2fs_group_desc_csum_set(fs, i);
 	}
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_super_dirty(fs);
 }
 
 /*

