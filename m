From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/17] ext2: Update comment about generic_osync_inode
Date: Wed, 19 Aug 2009 18:04:35 +0200
Message-ID: <1250697884-22288-9-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752844AbZHSQFG@vger.kernel.org>
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We rely on generic_write_sync() now.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e271303..1c1638f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -482,7 +482,7 @@ static int ext2_alloc_branch(struct inode *inode,
 		unlock_buffer(bh);
 		mark_buffer_dirty_inode(bh, inode);
 		/* We used to sync bh here if IS_SYNC(inode).
-		 * But we now rely upon generic_osync_inode()
+		 * But we now rely upon generic_write_sync()
 		 * and b_inode_buffers.  But not for directories.
 		 */
 		if (S_ISDIR(inode->i_mode) && IS_DIRSYNC(inode))
-- 
1.6.0.2
