From: akpm@linux-foundation.org
Subject: - ext4-use-ext4_get_group_desc.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:16 -0800
Message-ID: <200802272217.m1RMHGjM000800@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759444AbYB0WRg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: use ext4_get_group_desc()
has been removed from the -mm tree.  Its filename was
     ext4-use-ext4_get_group_desc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: use ext4_get_group_desc()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext4_get_group_desc()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff -puN fs/ext4/inode.c~ext4-use-ext4_get_group_desc fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-use-ext4_get_group_desc
+++ a/fs/ext4/inode.c
@@ -2613,12 +2613,10 @@ out_stop:
 static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
 		unsigned long ino, struct ext4_iloc *iloc)
 {
-	unsigned long desc, group_desc;
 	ext4_group_t block_group;
 	unsigned long offset;
 	ext4_fsblk_t block;
-	struct buffer_head *bh;
-	struct ext4_group_desc * gdp;
+	struct ext4_group_desc *gdp;
 
 	if (!ext4_valid_inum(sb, ino)) {
 		/*
@@ -2630,22 +2628,10 @@ static ext4_fsblk_t ext4_get_inode_block
 	}
 
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
-	if (block_group >= EXT4_SB(sb)->s_groups_count) {
-		ext4_error(sb,"ext4_get_inode_block","group >= groups count");
+	gdp = ext4_get_group_desc(sb, block_group, NULL);
+	if (!gdp)
 		return 0;
-	}
-	smp_rmb();
-	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
-	desc = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
-	bh = EXT4_SB(sb)->s_group_desc[group_desc];
-	if (!bh) {
-		ext4_error (sb, "ext4_get_inode_block",
-			    "Descriptor not loaded");
-		return 0;
-	}
 
-	gdp = (struct ext4_group_desc *)((__u8 *)bh->b_data +
-		desc * EXT4_DESC_SIZE(sb));
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
