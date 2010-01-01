From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: Fix accounting of reserved metadata blocks
Date: Fri,  1 Jan 2010 01:42:31 -0500
Message-ID: <1262328152-5657-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60733 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab0AAGmg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jan 2010 01:42:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 0637c6f had a typo which caused the reserved metadata blocks to
not be released correctly.   Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 84eeb8f..a26a0b4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1076,9 +1076,8 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		mdb_free = ei->i_allocated_meta_blocks;
-		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
-		ei->i_allocated_meta_blocks = 0;
+		mdb_free = ei->i_reserved_meta_blocks;
+		ei->i_reserved_meta_blocks = 0;
 	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
@@ -1889,8 +1888,8 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		to_free += ei->i_allocated_meta_blocks;
-		ei->i_allocated_meta_blocks = 0;
+		to_free += ei->i_reserved_meta_blocks;
+		ei->i_reserved_meta_blocks = 0;
 	}
 
 	/* update fs dirty blocks counter */
-- 
1.6.5.216.g5288a.dirty

