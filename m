From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext3: Allow quota file use root reservation
Date: Wed, 19 Oct 2011 14:16:23 +0400
Message-ID: <1319019383-12603-2-git-send-email-dmonakhov@openvz.org>
References: <1319019383-12603-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53743 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1JSKQe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 06:16:34 -0400
Received: by bkbzt19 with SMTP id zt19so1902941bkb.19
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2011 03:16:33 -0700 (PDT)
In-Reply-To: <1319019383-12603-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quota file is fs's metadata, so it is reasonable  to permit use
root resevation if necessary. This patch fix 265'th xfstest failure

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/balloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 6386d76..5430559 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1440,14 +1440,14 @@ out:
  *
  * Check if filesystem has at least 1 free block available for allocation.
  */
-static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
+static int ext3_has_free_blocks(struct ext3_sb_info *sbi, int use_reservation)
 {
 	ext3_fsblk_t free_blocks, root_blocks;
 
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current_fsuid() &&
+		!use_reservation && sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
@@ -1468,7 +1468,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  */
 int ext3_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext3_has_free_blocks(EXT3_SB(sb)) || (*retries)++ > 3)
+	if (!ext3_has_free_blocks(EXT3_SB(sb), 0) || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
@@ -1546,7 +1546,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext3_has_free_blocks(sbi)) {
+	if (!ext3_has_free_blocks(sbi, IS_NOQUOTA(inode))) {
 		*errp = -ENOSPC;
 		goto out;
 	}
-- 
1.7.1

