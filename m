From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] ext4: Simplify function signature for ext4_da_get_block_write()
Date: Tue, 12 May 2009 18:48:47 -0400
Message-ID: <1242168532-1063-2-git-send-email-tytso@mit.edu>
References: <1242168532-1063-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44286 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZELWs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:48:56 -0400
In-Reply-To: <1242168532-1063-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function ext4_da_get_block_write() is called in exactly one write,
and the last argument, create, is always 1.  Remove it to simplify the
code slightly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4909d3d..0968e6d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1994,7 +1994,7 @@ static void ext4_print_free_blocks(struct inode *inode)
 
 #define		EXT4_DELALLOC_RSVED	1
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
-				   struct buffer_head *bh_result, int create)
+				   struct buffer_head *bh_result)
 {
 	int ret;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
@@ -2004,7 +2004,7 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle = ext4_journal_current_handle();
 	BUG_ON(!handle);
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
+				   bh_result, 1, 0, EXT4_DELALLOC_RSVED);
 	if (ret <= 0)
 		return ret;
 
@@ -2069,7 +2069,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if (!new.b_size)
 		return 0;
 
-	err = ext4_da_get_block_write(mpd->inode, next, &new, 1);
+	err = ext4_da_get_block_write(mpd->inode, next, &new);
 	if (err) {
 		/*
 		 * If get block returns with error we simply
-- 
1.6.3.rc4.1.g3e14.dirty

