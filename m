From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 7/9][e2fsprogs] Add new blk64_t handling inline functions
Date: Fri, 09 May 2008 11:40:12 -0500
Message-ID: <20080509164012.15484.60952.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47503 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763609AbYEIQjo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 12:39:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GagAr006921
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:36:42 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49Gdhq8087154
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:43 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49Gdg8e023612
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:43 -0600
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add new blk64_t handling inline functions

Introduce inline fuctions to handle blk64_t and low/high values in
super blocks and inodes.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h |   91 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f578c19..ed99901 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1135,10 +1135,21 @@ extern void ext2fs_mark_ib_dirty(ext2_filsys fs);
 extern void ext2fs_mark_bb_dirty(ext2_filsys fs);
 extern int ext2fs_test_ib_dirty(ext2_filsys fs);
 extern int ext2fs_test_bb_dirty(ext2_filsys fs);
+extern int ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
 extern int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk);
 extern int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino);
+extern blk64_t ext2fs_blocks_count(ext2_filsys fs);
+extern void ext2_blocks_count_set(ext2_filsys fs, blk64_t blk);
+extern blk64_t ext2_r_blocks_count(ext2_filsys fs);
+extern void ext2_r_blocks_count_set(ext2_filsys fs, blk64_t blk);
+extern blk64_t ext2_free_blocks_count(ext2_filsys fs);
+extern void ext2_free_blocks_count_set(ext2_filsys fs, blk64_t blk);
+extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group);
+extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group);
+extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
+					  struct ext2_inode *inode);
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 				      struct ext2_inode *inode);
 extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
@@ -1299,12 +1310,17 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys fs)
 /*
  * Return the group # of a block
  */
-_INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
+_INLINE_ int ext2fs_group_of_blk2(ext2_filsys fs, blk64_t blk)
 {
 	return (blk - fs->super->s_first_data_block) /
 		fs->super->s_blocks_per_group;
 }
 
+_INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
+{
+	return ext2fs_group_of_blk2(fs, blk);
+}
+
 /*
  * Return the group # of an inode number
  */
@@ -1313,31 +1329,91 @@ _INLINE_ int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino)
 	return (ino - 1) / fs->super->s_inodes_per_group;
 }
 
+_INLINE_ blk64_t ext2fs_blocks_count(ext2_filsys fs)
+{
+	return fs->super->s_blocks_count |
+		(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) fs->super->s_blocks_count_hi << 32 : 0);
+}
+
+_INLINE_ void ext2_blocks_count_set(ext2_filsys fs, blk64_t blk)
+{
+	fs->super->s_blocks_count = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		fs->super->s_blocks_count_hi = (__u64) blk >> 32;
+}
+
+_INLINE_ blk64_t ext2_r_blocks_count(ext2_filsys fs)
+{
+	return fs->super->s_r_blocks_count |
+		(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) fs->super->s_r_blocks_count_hi << 32 : 0);
+}
+
+_INLINE_ void ext2_r_blocks_count_set(ext2_filsys fs, blk64_t blk)
+{
+	fs->super->s_r_blocks_count = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		fs->super->s_r_blocks_count_hi = (__u64) blk >> 32;
+}
+
+_INLINE_ blk64_t ext2_free_blocks_count(ext2_filsys fs)
+{
+	return fs->super->s_free_blocks_count |
+		(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) fs->super->s_free_blocks_hi << 32 : 0);
+}
+
+_INLINE_ void ext2_free_blocks_count_set(ext2_filsys fs, blk64_t blk)
+{
+	fs->super->s_free_blocks_count = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		fs->super->s_free_blocks_hi = (__u64) blk >> 32;
+}
+
 /*
  * Return the first block (inclusive) in a group
  */
-_INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
+_INLINE_ blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group)
 {
 	return fs->super->s_first_data_block +
 		(group * fs->super->s_blocks_per_group);
 }
 
+_INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
+{
+	return ext2fs_group_first_block2(fs, group);
+}
+
 /*
  * Return the last block (inclusive) in a group
  */
-_INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
+_INLINE_ blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group)
 {
 	return (group == fs->group_desc_count - 1 ?
-		fs->super->s_blocks_count - 1 :
-		ext2fs_group_first_block(fs, group) +
+		ext2fs_blocks_count(fs) - 1 :
+		ext2fs_group_first_block2(fs, group) +
 			(fs->super->s_blocks_per_group - 1));
 }
 
+_INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
+{
+	return ext2fs_group_last_block2(fs, group);
+}
+
+_INLINE_ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
+					struct ext2_inode *inode)
+{
+	return (inode->i_blocks |
+		(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
+		(inode->i_file_acl ? fs->blocksize >> 9 : 0);
+}
+
 _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
-       return inode->i_blocks -
-              (inode->i_file_acl ? fs->blocksize >> 9 : 0);
+	return ext2fs_inode_data_blocks2(fs, inode);
 }
 
 /*
@@ -1349,6 +1425,7 @@ _INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
 #undef _INLINE_
 #endif
 

