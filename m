From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add cond_resched() to ext4_free_blocks() & ext4_mb_regular_allocator()
Date: Wed, 12 Jun 2013 11:49:16 -0400
Message-ID: <1371052156-4821-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57302 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab3FLPtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 11:49:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For a file systems with a very large number of block groups, if all of
the block group bitmaps are in memory and the file system is
relatively badly fragmented, it's possible ext4_mb_regular_allocator()
to take a long time trying to find a good match.  This is especially
true if the tuning parameter mb_max_to_scan has been sent to a very
large number.  So add a cond_resched() to avoid soft lockup warnings
and to provide better system responsiveness.

For ext4_free_blocks(), if we are deleting a large range of blocks,
and data=journal is enabled so that EXT4_FREE_BLOCKS_FORGET is passed,
the loop to call sb_find_get_block() and to call ext4_forget() can
take over 10-15 milliseocnds or more.  So it's better to add a
cond_resched() here a well.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index def8408..1a9c22b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2105,6 +2105,7 @@ repeat:
 		group = ac->ac_g_ex.fe_group;
 
 		for (i = 0; i < ngroups; group++, i++) {
+			cond_resched();
 			/*
 			 * Artificially restricted ngroups for non-extent
 			 * files makes group > ngroups possible on first loop.
@@ -4612,10 +4613,11 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		BUG_ON(bh && (count > 1));
 
 		for (i = 0; i < count; i++) {
+			cond_resched();
 			if (!bh)
 				tbh = sb_find_get_block(inode->i_sb,
 							block + i);
-			if (unlikely(!tbh))
+			if (!tbh)
 				continue;
 			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
 				    inode, tbh, block + i);
-- 
1.7.12.rc0.22.gcdd159b

