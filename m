From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix oops in ext3_try_to_allocate_with_rsv()
Date: Mon, 30 May 2011 15:08:22 +0200
Message-ID: <1306760902-16160-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Sage Weil <sage@newdream.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1E3NI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 May 2011 09:08:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Block allocation is called from two places: ext3_get_blocks_handle() and
ext3_xattr_block_set(). These two callers are not necessarily synchronized
because xattr code holds only xattr_sem and i_mutex, and
ext3_get_blocks_handle() may hold only truncate_mutex when called from
writepage() path. Block reservation code does not expect two concurrent
allocations to happen to the same inode and thus assertions can be triggered
or reservation structure corruption can occur.

Fix the problem by taking truncate_mutex in xattr code to serialize
allocations.

CC: Sage Weil <sage@newdream.net>
Reported-by: Fyodor Ustinov <ufm@ufm.su>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/xattr.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

 I plan to put this into my tree.

diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 32e6cc2..d565759 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -803,8 +803,16 @@ inserted:
 			/* We need to allocate a new block */
 			ext3_fsblk_t goal = ext3_group_first_block_no(sb,
 						EXT3_I(inode)->i_block_group);
-			ext3_fsblk_t block = ext3_new_block(handle, inode,
-							goal, &error);
+			ext3_fsblk_t block;
+
+			/*
+			 * Protect us agaist concurrent allocations to the
+			 * same inode from ext3_..._writepage(). Reservation
+			 * code does not expect racing allocations.
+			 */
+			mutex_lock(&EXT3_I(inode)->truncate_mutex);
+			block = ext3_new_block(handle, inode, goal, &error);
+			mutex_unlock(&EXT3_I(inode)->truncate_mutex);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);
-- 
1.7.1

