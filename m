From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] ext4: Add BUG_ON debugging checks to noalloc_get_block_write()
Date: Tue, 12 May 2009 18:48:52 -0400
Message-ID: <1242168532-1063-7-git-send-email-tytso@mit.edu>
References: <1242168532-1063-1-git-send-email-tytso@mit.edu>
 <1242168532-1063-2-git-send-email-tytso@mit.edu>
 <1242168532-1063-3-git-send-email-tytso@mit.edu>
 <1242168532-1063-4-git-send-email-tytso@mit.edu>
 <1242168532-1063-5-git-send-email-tytso@mit.edu>
 <1242168532-1063-6-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44290 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZELWs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:48:56 -0400
In-Reply-To: <1242168532-1063-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enforce that noalloc_get_block_write() is only called to map one block
at a time, and that it always is successful in finding a mapping for
given an inode's logical block block number if it is called with
create == 1.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9431d50..114fa4f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2413,11 +2413,14 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
+	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
+
 	/*
 	 * we don't want to do block allocation in writepage
 	 * so call get_block_wrap with create = 0
 	 */
 	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks, bh_result, 0);
+	BUG_ON(create && ret == 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
-- 
1.6.3.rc4.1.g3e14.dirty

