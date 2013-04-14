From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: Add fdatasync scalability optimization
Date: Sun, 14 Apr 2013 23:34:28 +0400
Message-ID: <1365968068-11766-2-git-send-email-dmonakhov@openvz.org>
References: <87wqs4kiyi.fsf@openvz.org>
 <1365968068-11766-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, axboe@kernel.dk,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365968068-11766-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Track blkdev's flush generation counter on per-inode basis and update
inside end_io. If inode's flush generation counter is older than current
blkdev's flush counter inode's data was already flushed to stable media,
so we can skip explicit barrier. Optimization is safe only when inode's
end_io was called before flush request was QUEUED and COMPLETED.

With that optimization we do not longer need jbd2 flush optimization.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h      |    1 +
 fs/ext4/ext4_jbd2.h |   10 +++++++++-
 fs/ext4/fsync.c     |   16 +++++++++++-----
 fs/ext4/inode.c     |    3 ++-
 fs/ext4/page-io.c   |    2 +-
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 75b2326..e2ec980 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -932,6 +932,7 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+	atomic_t i_flush_tag;
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index c8c6885..46943ed 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -365,7 +365,15 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
 		ei->i_sync_tid = handle->h_transaction->t_tid;
 		if (datasync)
 			ei->i_datasync_tid = handle->h_transaction->t_tid;
-	}
+	} else {
+		struct request_queue *q = bdev_get_queue(inode->i_sb->s_bdev);
+		if (q)
+			atomic_set(&EXT4_I(inode)->i_flush_tag,
+				   atomic_read(&q->flush_tag));
+		else
+			atomic_set(&EXT4_I(inode)->i_flush_tag, UINT_MAX);
+ 	}
+
 }
 
 /* super.c */
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8a0dee8..b02d1ec 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -116,10 +116,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	bool needs_barrier = journal->j_flags & JBD2_BARRIER;
+	struct request_queue *q = bdev_get_queue(inode->i_sb->s_bdev);
 	int ret, err;
 	tid_t commit_tid;
-	bool needs_barrier = false;
-
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
 	trace_ext4_sync_file_enter(file, datasync);
@@ -163,10 +163,16 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
-	if (journal->j_flags & JBD2_BARRIER &&
-	    !jbd2_trans_will_send_data_barrier(journal, &commit_tid))
-		needs_barrier = true;
 	ret = jbd2_complete_transaction(journal, commit_tid);
+	/*
+	 * We must send a barrier unless we can guarantee that:
+	 * Latest io-requst for given inode was completed before
+	 * new flush request was QUEUED and COMPLETED by blkdev.
+	 */
+	if (q && ((unsigned int)atomic_read(&q->flush_tag) & ~1U)
+	    > (((unsigned int)atomic_read(&ei->i_flush_tag) + 1U) & (~1U)))
+		needs_barrier = 0;
+
 	if (needs_barrier) {
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1be5827..761513c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3073,11 +3073,12 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 		  size);
 
 	iocb->private = NULL;
-
 	/* if not aio dio with unwritten extents, just free io and return */
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
 out:
+		if (size)
+			ext4_update_inode_fsync_trans(NULL, inode, 1);
 		inode_dio_done(inode);
 		if (is_async)
 			aio_complete(iocb, ret, 0);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 047a6de..8a2a09b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -282,7 +282,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 	}
 	io_end->num_io_pages = 0;
 	inode = io_end->inode;
-
+	ext4_update_inode_fsync_trans(NULL, inode, 1);
 	if (error) {
 		io_end->flag |= EXT4_IO_END_ERROR;
 		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
-- 
1.7.1
