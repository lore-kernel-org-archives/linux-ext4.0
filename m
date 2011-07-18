From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 08/12] ext4: let setup_new_group_blocks set multi-bits each time
Date: Mon, 18 Jul 2011 10:52:31 +0800
Message-ID: <1310957555-15617-9-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1GRC5E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:57:04 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so2719031iwn.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:57:03 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a function - ext4_set_btis() which can set multi-bits
each time, and lets setup_new_group_blocks() use ext4_set_bits().

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/mballoc.c |    5 +++++
 fs/ext4/resize.c  |   18 +++++++-----------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index da7ab48..43e7448 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -940,6 +940,7 @@ struct ext4_inode_info {
 #define ext4_find_next_zero_bit		find_next_zero_bit_le
 #define ext4_find_next_bit		find_next_bit_le
 
+extern void ext4_set_bits(void *bm, int cur, int len);
 /*
  * Maximal mount counts between two filesystem checks
  */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a2af35b..971137d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1299,6 +1299,11 @@ static void mb_set_bits(void *bm, int cur, int len)
 	}
 }
 
+void ext4_set_bits(void *bm, int cur, int len)
+{
+	mb_set_bits(bm, cur, len);
+}
+
 static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
 {
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 4089642..c91653c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -227,11 +227,6 @@ static int setup_new_group_blocks(struct super_block *sb,
 		goto exit_journal;
 	}
 
-	if (ext4_bg_has_super(sb, input->group)) {
-		ext4_debug("mark backup superblock %#04llx (+0)\n", start);
-		ext4_set_bit(0, bh->b_data);
-	}
-
 	/* Copy all of the GDT blocks into the backup in this group */
 	for (i = 0, bit = 1, block = start + 1;
 	     i < gdblocks; i++, block++, bit++) {
@@ -260,7 +255,6 @@ static int setup_new_group_blocks(struct super_block *sb,
 			brelse(gdb);
 			goto exit_bh;
 		}
-		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
 
@@ -271,8 +265,11 @@ static int setup_new_group_blocks(struct super_block *sb,
 			       GFP_NOFS);
 	if (err)
 		goto exit_bh;
-	for (i = 0, bit = gdblocks + 1; i < reserved_gdb; i++, bit++)
-		ext4_set_bit(bit, bh->b_data);
+
+	if (ext4_bg_has_super(sb, input->group)) {
+		ext4_debug("mark backup group tables %#04llx (+0)\n", start);
+		ext4_set_bits(bh->b_data, 0, gdblocks + reserved_gdb + 1);
+	}
 
 	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
 		   input->block_bitmap - start);
@@ -288,9 +285,8 @@ static int setup_new_group_blocks(struct super_block *sb,
 	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
 	if (err)
 		goto exit_bh;
-	for (i = 0, bit = input->inode_table - start;
-	     i < sbi->s_itb_per_group; i++, bit++)
-		ext4_set_bit(bit, bh->b_data);
+	ext4_set_bits(bh->b_data, input->inode_table - start,
+		      sbi->s_itb_per_group);
 
 	if ((err = extend_or_restart_transaction(handle, 2, bh)))
 		goto exit_bh;
-- 
1.7.5.1

