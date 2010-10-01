From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/6 fixed] Use sb_issue_zeroout in setup_new_group_blocks
Date: Fri, 1 Oct 2010 18:00:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010011759060.2854@dhcp-lab-213.englab.brq.redhat.com>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com> <1284641251-24531-5-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1009291608061.25427@dhcp-lab-213.englab.brq.redhat.com>
 <alpine.LFD.2.00.1009291612270.25427@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0JAQAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Oct 2010 12:00:42 -0400
In-Reply-To: <alpine.LFD.2.00.1009291612270.25427@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use sb_issue_zeroout to zero out inode table and descriptor table
blocks instead of old approach which involves journaling.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/resize.c |   47 +++++++++++++++--------------------------------
 1 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ca5c8aa..49c8aff 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -226,23 +226,16 @@ static int setup_new_group_blocks(struct super_block *sb,
 	}
 
 	/* Zero out all of the reserved backup group descriptor table blocks */
-	for (i = 0, bit = gdblocks + 1, block = start + bit;
-	     i < reserved_gdb; i++, block++, bit++) {
-		struct buffer_head *gdb;
-
-		ext4_debug("clear reserved block %#04llx (+%d)\n", block, bit);
+	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
+			block, sbi->s_itb_per_group);
+	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
+			       GFP_NOFS, BLKDEV_IFL_WAIT);
+	if (err)
+		goto exit_bh;
 
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
-			goto exit_bh;
+	if ((err = extend_or_restart_transaction(handle, 1, bh)))
+		goto exit_bh;
 
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
@@ -251,23 +244,13 @@ static int setup_new_group_blocks(struct super_block *sb,
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
