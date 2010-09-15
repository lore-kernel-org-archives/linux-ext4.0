From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/6] Use sb_issue_zeroout in setup_new_group_blocks
Date: Wed, 15 Sep 2010 18:36:06 +0200
Message-ID: <1284568568-13637-5-git-send-email-lczerner@redhat.com>
References: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0IOQga (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 12:36:30 -0400
In-Reply-To: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use sn_issue_discard to zero out inode table and descriptor table
blocks instead of old approach which involves journaling.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/resize.c |   44 +++++++++++---------------------------------
 1 files changed, 11 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 6df797e..60161bc 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -226,23 +226,12 @@ static int setup_new_group_blocks(struct super_block *sb,
 	}
 
 	/* Zero out all of the reserved backup group descriptor table blocks */
-	for (i = 0, bit = gdblocks + 1, block = start + bit;
-	     i < reserved_gdb; i++, block++, bit++) {
-		struct buffer_head *gdb;
-
-		ext4_debug("clear reserved block %#04llx (+%d)\n", block, bit);
-
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
-			goto exit_bh;
+	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
+			block, sbi->s_itb_per_group);
+	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb);
+	if (err)
+		goto exit_journal;
 
-		if (IS_ERR(gdb = bclean(handle, sb, block))) {
-			err = PTR_ERR(gdb);
-			goto exit_bh;
-		}
-		ext4_handle_dirty_metadata(handle, NULL, gdb);
-		ext4_set_bit(bit, bh->b_data);
-		brelse(gdb);
-	}
 	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
 		   input->block_bitmap - start);
 	ext4_set_bit(input->block_bitmap - start, bh->b_data);
@@ -251,23 +240,12 @@ static int setup_new_group_blocks(struct super_block *sb,
 	ext4_set_bit(input->inode_bitmap - start, bh->b_data);
 
 	/* Zero out all of the inode table blocks */
-	for (i = 0, block = input->inode_table, bit = block - start;
-	     i < sbi->s_itb_per_group; i++, bit++, block++) {
-		struct buffer_head *it;
-
-		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);
-
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
-			goto exit_bh;
