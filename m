From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 8/8] ext4: use ext4_data_block_valid() in ext4_free_blocks()
Date: Sun, 22 Nov 2009 21:18:30 -0500
Message-ID: <1258942710-31930-9-git-send-email-tytso@mit.edu>
References: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48726 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbZKWCS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Nov 2009 21:18:29 -0500
In-Reply-To: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block validity framework does a more comprehensive set of checks,
and it saves object code space to use the ext4_data_block_valid() than
the limited open-coded version that had been in ext4_free_blocks().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 78de5d3..ab2dad1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4463,9 +4463,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 	es = EXT4_SB(sb)->s_es;
-	if (block < le32_to_cpu(es->s_first_data_block) ||
-	    block + count < block ||
-	    block + count > ext4_blocks_count(es)) {
+	if (!ext4_data_block_valid(sbi, block, count)) {
 		ext4_error(sb, __func__,
 			    "Freeing blocks not in datazone - "
 			    "block = %llu, count = %lu", block, count);
-- 
1.6.5.216.g5288a.dirty

