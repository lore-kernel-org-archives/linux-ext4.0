From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Remove useless spinlock in ext4_getattr()
Date: Tue,  2 Nov 2010 09:34:50 -0400
Message-ID: <1288704890-1858-1-git-send-email-tytso@mit.edu>
Cc: torvalds@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36820 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0KBNez (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 09:34:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus noted, and complained to me, that doing while lots of "git
diff"'s of kernel sources, these spinlocks were responsible for 27% of
the CPU on his two-processor system as reported by perf.

Git was doing lots of parallel stats, and this was putting a lot of
pressure on ext4_getattr().  A spinlock to protect a single
memory-to-memory copy is pointless, so remove it.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1916164..4d78342 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5410,9 +5410,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	 * will return the blocks that include the delayed allocation
 	 * blocks for this file.
 	 */
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
 	return 0;
-- 
1.7.3.1

