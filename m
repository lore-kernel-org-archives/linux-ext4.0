From: Jan Kara <jack@suse.cz>
Subject: [PATCH 29/29] ext4: Remove ext4_ioend_wait()
Date: Mon,  8 Apr 2013 23:32:34 +0200
Message-ID: <1365456754-29373-30-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936374Ab3DHVdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:09 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we clear PageWriteback after extent conversion, there's no need
to wait for io_end processing in ext4_evict_inode(). Running AIO/DIO
keeps file reference until aio_complete() is called so ext4_evict_inode()
cannot be called. For io_end structures resulting from buffered IO
waiting is happening because we wait for PageWriteback in
truncate_inode_pages().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |    1 -
 fs/ext4/inode.c   |    5 +++--
 fs/ext4/page-io.c |    7 -------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 859f235..b359aef 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2605,7 +2605,6 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
-extern void ext4_ioend_wait(struct inode *);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
 extern ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end);
 extern int ext4_put_io_end(ext4_io_end_t *io_end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f493ec2..1f88941 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -188,8 +188,6 @@ void ext4_evict_inode(struct inode *inode)
 
 	trace_ext4_evict_inode(inode);
 
-	ext4_ioend_wait(inode);
-
 	if (inode->i_nlink) {
 		/*
 		 * When journalling data dirty buffers are tracked only in the
@@ -219,6 +217,8 @@ void ext4_evict_inode(struct inode *inode)
 			filemap_write_and_wait(&inode->i_data);
 		}
 		truncate_inode_pages(&inode->i_data, 0);
+
+		WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 		goto no_delete;
 	}
 
@@ -229,6 +229,7 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
+	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 	if (is_bad_inode(inode))
 		goto no_delete;
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 1156b9f..e720d4e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -44,13 +44,6 @@ void ext4_exit_pageio(void)
 	kmem_cache_destroy(io_end_cachep);
 }
 
-void ext4_ioend_wait(struct inode *inode)
-{
-	wait_queue_head_t *wq = ext4_ioend_wq(inode);
-
-	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
-}
