From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC][PATCH 1/2] Start converting libext2fs to handle blk64_t.
Date: Fri, 11 Apr 2008 11:35:10 -0400
Message-ID: <20080411153510.GA32661@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760824AbYDKPn2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 11:43:28 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I figured I'd give this another go now that I understand a little bit more about
what you are looking for.  I've built and ran make check with both of these
patches to make sure they are working properly, they both pass make check with 0
failed tests.  I mostly want to see if my approach is acceptable, and if so I'm
going to keep going through every file until everything is converted over, and
then change the utilities one by one to use the blk64_t interfaces, and
hopefully be able to mkfs my 20tb volume sometime in the next month.  BTW I'm
also expirementing with using git instead of quilt, so feel free to comment on
how I'm building the patches as well.  Thanks much,

Josef


commit 7355024eb95a4f360830e547f42ffacd4ed8d043
Author: Josef Bacik <jbacik@redhat.com>
Date:   Fri Apr 11 17:57:37 2008 -0400

    Added 64bit equivalent to common inline functions.  Ran make check to make
    sure nothing died.
    
    Signed-off-by: Josef Bacik <jbacik@redhat.com>

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1a7cb86..a60e28b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1188,6 +1188,8 @@ _INLINE_ errcode_t ext2fs_resize_mem(unsigned long EXT2FS_ATTR((unused)) old_siz
 }
 #endif	/* Custom memory routines */
 
+_INLINE_ int ext2fs_group_of_blk64(ext2_filsys fs, blk64_t blk);
+
 /*
  * Mark a filesystem superblock as dirty
  */
@@ -1273,8 +1275,7 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys fs)
  */
 _INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
 {
-	return (blk - fs->super->s_first_data_block) /
-		fs->super->s_blocks_per_group;
+	return ext2fs_group_of_blk64(fs, blk);
 }
 
 /*
@@ -1321,6 +1322,69 @@ _INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+/*
+ * 64 bit helper functions
+ */
+
+/*
+ * Return the group # of a 64bit block
+ */
+_INLINE_ int ext2fs_group_of_blk64(ext2_filsys fs, blk64_t blk)
+{
+	return (blk - fs->super->s_first_data_block) /
+		fs->super->s_blocks_per_group;
+}
+
+/*
+ * Return the last 64bit block (inclusive) in a group
+ */
+_INLINE_ blk64_t ext2fs_group_last_block64(ext2_filsys fs, dgrp_t group)
+{
+	blk64_t ret = 0;
+
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) {
+		blk64_t blks;
+
+		blks = ((blk64_t)fs->super->s_blocks_count_hi << 32) |
+			fs->super->s_blocks_count;
+
+		ret = (group == fs->group_desc_count - 1 ? blks - 1 :
+			ext2fs_group_first_block(fs, group) +
+				(fs->super->s_blocks_per_group - 1));
+	} else {
+		ret = (group == fs->group_desc_count - 1 ?
+		       fs->super->s_blocks_count - 1 :
+		       ext2fs_group_first_block(fs, group) +
+			(fs->super->s_blocks_per_group - 1));
+	}
+
+	return ret;
+}
+
+/*
+ * Return number of data blocks in an inode
+ */
+_INLINE_ blk64_t ext2fs_inode_data_blocks64(ext2_filsys fs,
+					    struct ext2_inode *inode)
+{
+	blk64_t ret = 0;
+
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
+	    (fs->super->s_creator_os == EXT2_OS_LINUX)) {
+		blk64_t iblocks;
+
+		iblocks = ((blk64_t)inode->osd2.linux2.l_i_blocks_hi << 32) |
+			  inode->i_blocks;
+		ret = iblocks - (inode->i_file_acl ? fs->blocksize >> 9 : 0);
+	} else {
+		ret = inode->i_blocks -
+		      (inode->i_file_acl ? fs->blocksize >> 9 : 0);
+	}
+
+	return ret;
+}
+
 #undef _INLINE_
 #endif
 
