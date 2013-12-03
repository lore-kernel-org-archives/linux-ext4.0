From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/10] libext2fs: add explicit casts to ext2fs.h
Date: Tue,  3 Dec 2013 00:10:13 -0500
Message-ID: <1386047418-32431-6-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35872 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab3LCFKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:31 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add some explicit casts to silence some -Wconversion noise.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b7a784e..eb1901e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1673,14 +1673,14 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys fs)
 /*
  * Return the group # of a block
  */
-_INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
+_INLINE_ dgrp_t ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
 {
 	return ext2fs_group_of_blk2(fs, blk);
 }
 /*
  * Return the group # of an inode number
  */
-_INLINE_ int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino)
+_INLINE_ dgrp_t ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino)
 {
 	return (ino - 1) / fs->super->s_inodes_per_group;
 }
@@ -1690,7 +1690,7 @@ _INLINE_ int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino)
  */
 _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
 {
-	return ext2fs_group_first_block2(fs, group);
+	return (blk_t) ext2fs_group_first_block2(fs, group);
 }
 
 /*
@@ -1698,13 +1698,13 @@ _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
  */
 _INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
 {
-	return ext2fs_group_last_block2(fs, group);
+	return (blk_t) ext2fs_group_last_block2(fs, group);
 }
 
 _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
-	return ext2fs_inode_data_blocks2(fs, inode);
+	return (blk_t) ext2fs_inode_data_blocks2(fs, inode);
 }
 
 /*
-- 
1.8.5.rc3.362.gdf10213

