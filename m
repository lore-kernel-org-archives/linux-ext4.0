From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Replace tests of write IO errors using buffer_uptodate
Date: Thu, 26 Jan 2012 23:01:58 +0100
Message-ID: <1327615318-18674-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab2AZWCG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 17:02:06 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 49ABB8FE69
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jan 2012 23:02:04 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    5 ++---
 fs/ext2/xattr.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

  I plan to put this minor cleanup into my tree for the next merge window.

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 740cad8..f832a4c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1501,11 +1501,10 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
 	if (do_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
+		err = sync_dirty_buffer(bh);
+		if (err) {
 			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
 				sb->s_id, (unsigned long) ino);
-			err = -EIO;
 		}
 	}
 	ei->i_state &= ~EXT2_STATE_NEW;
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 6dcafc7..f3dfb27 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -679,9 +679,8 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		}
 		mark_buffer_dirty(new_bh);
 		if (IS_SYNC(inode)) {
-			sync_dirty_buffer(new_bh);
-			error = -EIO;
-			if (buffer_req(new_bh) && !buffer_uptodate(new_bh))
+			error = sync_dirty_buffer(new_bh);
+			if (error)
 				goto cleanup;
 		}
 	}
-- 
1.7.1

