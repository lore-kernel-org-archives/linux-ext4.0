From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/3] ext4: use ext4_grp_offs_to_block
Date: Wed,  3 Mar 2010 23:40:45 +0900
Message-ID: <1267627246-12863-2-git-send-email-akinobu.mita@gmail.com>
References: <1267627246-12863-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55030 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0CCOlr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 09:41:47 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so57421bwz.21
        for <linux-ext4@vger.kernel.org>; Wed, 03 Mar 2010 06:41:46 -0800 (PST)
In-Reply-To: <1267627246-12863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext4_grp_offs_to_block() to calculate the first block number of the
free extent.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 0babffd..5196a8c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2697,9 +2697,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (err)
 		goto out_err;
 
-	block = ac->ac_b_ex.fe_group * EXT4_BLOCKS_PER_GROUP(sb)
-		+ ac->ac_b_ex.fe_start
-		+ le32_to_cpu(es->s_first_data_block);
+	block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
 
 	len = ac->ac_b_ex.fe_len;
 	if (!ext4_data_block_valid(sbi, block, len)) {
@@ -3155,9 +3153,7 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 
-	goal_block = ac->ac_g_ex.fe_group * EXT4_BLOCKS_PER_GROUP(ac->ac_sb) +
-		     ac->ac_g_ex.fe_start +
-		     le32_to_cpu(EXT4_SB(ac->ac_sb)->s_es->s_first_data_block);
+	goal_block = ext4_grp_offs_to_block(ac->ac_sb, &ac->ac_g_ex);
 	/*
 	 * search for the prealloc space that is having
 	 * minimal distance from the goal block.
-- 
1.6.0.6

