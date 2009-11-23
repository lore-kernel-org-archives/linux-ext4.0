From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/8] ext4: add check for wraparound in ext4_data_block_valid()
Date: Sun, 22 Nov 2009 21:18:29 -0500
Message-ID: <1258942710-31930-8-git-send-email-tytso@mit.edu>
References: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48725 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbZKWCS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Nov 2009 21:18:29 -0500
In-Reply-To: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/block_validity.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index dc79b75..4df8621 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -228,6 +228,7 @@ int ext4_data_block_valid(struct ext4_sb_info *sbi, ext4_fsblk_t start_blk,
 	struct rb_node *n = sbi->system_blks.rb_node;
 
 	if ((start_blk <= le32_to_cpu(sbi->s_es->s_first_data_block)) ||
+	    (start_blk + count < start_blk) ||
 	    (start_blk + count > ext4_blocks_count(sbi->s_es)))
 		return 0;
 	while (n) {
-- 
1.6.5.216.g5288a.dirty

