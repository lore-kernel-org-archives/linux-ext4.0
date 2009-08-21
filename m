From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/17] ext2: Update comment about generic_osync_inode
Date: Fri, 21 Aug 2009 19:23:58 +0200
Message-ID: <1250875447-15622-9-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbZHURYI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:08 -0400
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

