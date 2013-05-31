From: Jan Kara <jack@suse.cz>
Subject: [PATCH 26/26] ext4: Remove ext4_ioend_wait()
Date: Fri, 31 May 2013 11:42:59 +0200
Message-ID: <1369993379-13017-27-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab3EaJnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:25 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we clear PageWriteback after extent conversion, there's no need
to wait for io_end processing in ext4_evict_inode(). Running AIO/DIO
keeps file reference until aio_complete() is called so ext4_evict_inode()
cannot be called. For io_end structures resulting from buffered IO
waiting is happening because we wait for PageWriteback in
truncate_inode_pages().

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  1 -
 fs/ext4/inode.c   |  5 +++--
 fs/ext4/page-io.c | 19 -------------------
 3 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c161746..cc4904d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2653,7 +2653,6 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
-extern void ext4_ioend_shutdown(struct inode *);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
 extern ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end);
 extern int ext4_put_io_end(ext4_io_end_t *io_end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c55b09a..ec12da2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -218,7 +218,8 @@ void ext4_evict_inode(struct inode *inode)
 			filemap_write_and_wait(&inode->i_data);
 		}
 		truncate_inode_pages(&inode->i_data, 0);
-		ext4_ioend_shutdown(inode);
+
+		WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 		goto no_delete;
 	}
 
@@ -228,8 +229,8 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
-	ext4_ioend_shutdown(inode);
 
+	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 	if (is_bad_inode(inode))
 		goto no_delete;
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 6ee5bd3..ce8c15a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -46,25 +46,6 @@ void ext4_exit_pageio(void)
 }
 
 /*
- * This function is called by ext4_evict_inode() to make sure there is
- * no more pending I/O completion work left to do.
- */
-void ext4_ioend_shutdown(struct inode *inode)
-{
-	wait_queue_head_t *wq = ext4_ioend_wq(inode);
-
-	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
-	/*
-	 * We need to make sure the work structure is finished being
-	 * used before we let the inode get destroyed.
-	 */
-	if (work_pending(&EXT4_I(inode)->i_rsv_conversion_work))
-		cancel_work_sync(&EXT4_I(inode)->i_rsv_conversion_work);
-	if (work_pending(&EXT4_I(inode)->i_unrsv_conversion_work))
-		cancel_work_sync(&EXT4_I(inode)->i_unrsv_conversion_work);
-}
