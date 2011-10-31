From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] ext4: optimize locking for end_io extent conversion
Date: Mon, 31 Oct 2011 11:02:47 -0400
Message-ID: <1320073367-28916-3-git-send-email-tytso@mit.edu>
References: <20111031150206.GC16825@thunk.org>
 <1320073367-28916-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37933 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab1JaPCs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 11:02:48 -0400
In-Reply-To: <1320073367-28916-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we are doing the locking correctly, we need to grab the
i_completed_io_lock() twice per end_io.  We can clean this up by
removing the structure from the i_complted_io_list, and use this as
the locking mechanism to prevent ext4_flush_completed_IO() racing
against ext4_end_io_work(), instead of clearing the
EXT4_IO_END_UNWRITTEN in io->flag.

In addition, if the ext4_convert_unwritten_extents() returns an error,
we no longer keep the end_io structure on the linked list.  This
doesn't help, because it tends to lock up the file system and wedges
the system.  That's one way to call attention to the problem, but it
doesn't help the overall robustness of the system.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c   |    5 ++---
 fs/ext4/page-io.c |   37 +++++++++++--------------------------
 2 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 851ac5b..00a2cb7 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -88,6 +88,7 @@ int ext4_flush_completed_IO(struct inode *inode)
 	while (!list_empty(&ei->i_completed_io_list)){
 		io = list_entry(ei->i_completed_io_list.next,
 				ext4_io_end_t, list);
+		list_del_init(&io->list);
 		/*
 		 * Calling ext4_end_io_nolock() to convert completed
 		 * IO to written.
@@ -104,11 +105,9 @@ int ext4_flush_completed_IO(struct inode *inode)
 		 */
 		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 		ret = ext4_end_io_nolock(io);
-		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 		if (ret < 0)
 			ret2 = ret;
-		else
-			list_del_init(&io->list);
+		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	}
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 	return (ret2 < 0) ? ret2 : 0;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4fa1d70..7bacd27 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -99,28 +99,21 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
 
-	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
-		return ret;
-
 	ret = ext4_convert_unwritten_extents(inode, offset, size);
 	if (ret < 0) {
-		printk(KERN_EMERG "%s: failed to convert unwritten "
-			"extents to written extents, error is %d "
-			"io is still on inode %lu aio dio list\n",
-		       __func__, ret, inode->i_ino);
-		return ret;
+		ext4_msg(inode->i_sb, KERN_EMERG,
+			 "failed to convert unwritten extents to written "
+			 "extents -- potential data loss!  "
+			 "(inode %lu, offset %llu, size %d, error %d)",
+			 inode->i_ino, offset, size, ret);
 	}
 
 	if (io->iocb)
 		aio_complete(io->iocb, io->result, 0);
-	/* clear the DIO AIO unwritten flag */
-	if (io->flag & EXT4_IO_END_UNWRITTEN) {
-		io->flag &= ~EXT4_IO_END_UNWRITTEN;
-		/* Wake up anyone waiting on unwritten extent conversion */
-		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
-			wake_up_all(ext4_ioend_wq(io->inode));
-	}
 
+	/* Wake up anyone waiting on unwritten extent conversion */
+	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
+		wake_up_all(ext4_ioend_wq(io->inode));
 	return ret;
 }
 
@@ -133,16 +126,15 @@ static void ext4_end_io_work(struct work_struct *work)
 	struct inode		*inode = io->inode;
 	struct ext4_inode_info	*ei = EXT4_I(inode);
 	unsigned long		flags;
-	int			ret;
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	if (list_empty(&io->list)) {
 		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 		goto free;
 	}
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	if (!mutex_trylock(&inode->i_mutex)) {
+		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 		/*
 		 * Requeue the work instead of waiting so that the work
 		 * items queued after this can be processed.
@@ -159,16 +151,9 @@ static void ext4_end_io_work(struct work_struct *work)
 		io->flag |= EXT4_IO_END_QUEUED;
 		return;
 	}
-	ret = ext4_end_io_nolock(io);
-	if (ret < 0) {
-		mutex_unlock(&inode->i_mutex);
-		return;
-	}
