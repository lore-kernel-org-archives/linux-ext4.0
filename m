From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 09/53] ext4: Fix accounting of reserved metadata blocks
Date: Sun, 30 May 2010 22:49:22 -0400
Message-ID: <1275274206-3900-9-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44552 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit ee5f4d9cdf32fd99172d11665c592a288c2b1ff4 upstream (as of v2.6.33-rc3)

Commit 0637c6f had a typo which caused the reserved metadata blocks to
not be released correctly.   Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ffbe4a..533bb84 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1118,9 +1118,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		mdb_free = ei->i_allocated_meta_blocks;
+		mdb_free = ei->i_reserved_meta_blocks;
+		ei->i_reserved_meta_blocks = 0;
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
-		ei->i_allocated_meta_blocks = 0;
 	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
@@ -1931,8 +1931,8 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
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
1.6.6.1.1.g974db.dirty

