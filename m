From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 02/11] ext4: give i_aiodio_unwritten more appropriate name
Date: Fri, 28 Sep 2012 19:44:02 +0400
Message-ID: <1348847051-6746-3-git-send-email-dmonakhov@openvz.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35250 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab2I1PoV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 11:44:21 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so3591549bkc.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2012 08:44:20 -0700 (PDT)
In-Reply-To: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

AIO/DIO prefix is wrong because it account unwritten extents which
also may be scheduled from buffered write endio

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    4 ++--
 fs/ext4/file.c    |    6 +++---
 fs/ext4/page-io.c |    2 +-
 fs/ext4/super.c   |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42be3ae..0d393dc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -917,7 +917,7 @@ struct ext4_inode_info {
 	struct list_head i_completed_io_list;
 	spinlock_t i_completed_io_lock;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
-	atomic_t i_aiodio_unwritten; /* Nr. of inflight conversions pending */
+	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
 
 	spinlock_t i_block_reservation_lock;
 
@@ -1337,7 +1337,7 @@ static inline void ext4_set_io_unwritten_flag(struct inode *inode,
 {
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		io_end->flag |= EXT4_IO_END_UNWRITTEN;
-		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+		atomic_inc(&EXT4_I(inode)->i_unwritten);
 	}
 }
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cfdf774..40c02c6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -55,11 +55,11 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static void ext4_aiodio_wait(struct inode *inode)
+static void ext4_unwritten_wait(struct inode *inode)
 {
 	wait_queue_head_t *wq = ext4_ioend_wq(inode);
 
-	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_aiodio_unwritten) == 0));
+	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_unwritten) == 0));
 }
 
 /*
@@ -116,7 +116,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 				 "performance will be poor.",
 				 inode->i_ino, current->comm);
 		mutex_lock(ext4_aio_mutex(inode));
-		ext4_aiodio_wait(inode);
+		ext4_unwritten_wait(inode);
 	}
 
 	BUG_ON(iocb->ki_pos != pos);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dcdeef1..de77e31 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -113,7 +113,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	if (io->flag & EXT4_IO_END_DIRECT)
 		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
-	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
+	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
 		wake_up_all(ext4_ioend_wq(io->inode));
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b5dfff8..f2d928c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -970,7 +970,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
-	atomic_set(&ei->i_aiodio_unwritten, 0);
+	atomic_set(&ei->i_unwritten, 0);
 
 	return &ei->vfs_inode;
 }
-- 
1.7.7.6

