From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] ext4: Add fdatasync scalability optimization
Date: Tue, 14 Oct 2014 14:03:55 +0400
Message-ID: <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If block device support flush epoch generation we can optimize fsync
by using following logic
1) track flush_idx on per-inode basis, update it inside end_io
2) During fsync we can compare inode's flush_idx and curent device's
   flush_idx. If device generation is newer than it means someone
   already flushed data from volatile cache to stable media, so
   we can avoid explicit barrier

This optimization works well for fsync intensitive workloads like:
1) mail-server
2) cloud/chunk server which mostly perfomes direct-io and fdatasync
3) fdatasync bunch of files requires only one barrier.

Patch was tested on real HW with power-loss test hwflush-check
(was submitted here http://patchwork.ozlabs.org/patch/244297/).
Following configurations was tested:
ext4.buf_noalloc_fsync                                    PASS
ext4.buf_noalloc_fdatasync                                PASS
ext4.buf_falloc_fsync                                     PASS
ext4.buf_falloc_fdatasync                                 PASS
ext4.buf_rewrite_fsync                                    PASS
ext4.buf_rewrite_fdatasync                                PASS
ext4.dio_noalloc_fsync                                    PASS
ext4.dio_noalloc_fdatasync                                PASS
ext4.dio_falloc_fsync                                     PASS
ext4.dio_falloc_fdatasync                                 PASS
ext4.dio_rewrite_fsync                                    PASS
ext4.dio_rewrite_fdatasync                                PASS

CC: linux-ext4@vger.kernel.org
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h              |    1 +
 fs/ext4/ext4_jbd2.h         |    9 +++++++++
 fs/ext4/fsync.c             |   22 ++++++++++++++++++----
 fs/ext4/ialloc.c            |    1 +
 fs/ext4/indirect.c          |   16 ++++++++++++++--
 fs/ext4/inode.c             |    4 ++++
 fs/ext4/page-io.c           |    1 +
 include/trace/events/ext4.h |   10 ++++++----
 8 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0c225c..46cb45a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -939,6 +939,7 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+	unsigned i_flush_idx;
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 17c00ff..06df47e 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -381,6 +381,15 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
 	}
 }
 
+static inline void ext4_update_inode_fsync_fid(struct inode *inode)
+{
+	struct request_queue *q = bdev_get_queue(inode->i_sb->s_bdev);
+
+	if (unlikely(!q))
+		return;
+	ACCESS_ONCE(EXT4_I(inode)->i_flush_idx) = blk_get_flush_idx(q, true);
+}
+
 /* super.c */
 int ext4_force_commit(struct super_block *sb);
 
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2b0fd69..59fe0d2 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -90,8 +90,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int ret = 0, err;
+	struct request_queue *q = bdev_get_queue(inode->i_sb->s_bdev);
+	int ret = 0, barrier_opt = 0, err;
 	tid_t commit_tid;
+	unsigned flush_idx;
 	bool needs_barrier = test_opt(inode->i_sb, BARRIER);
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
@@ -108,6 +110,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!journal) {
 		ret = __generic_file_fsync(file, start, end, datasync);
+		flush_idx = ACCESS_ONCE(ei->i_flush_idx);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
 		goto out_flush;
@@ -134,19 +137,30 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = ext4_force_commit(inode->i_sb);
 		goto out;
 	}
-
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
+	flush_idx = ACCESS_ONCE(ei->i_flush_idx);
 	if (needs_barrier &&
-	    jbd2_trans_will_send_data_barrier(journal, commit_tid))
+	    jbd2_trans_will_send_data_barrier(journal, commit_tid)) {
 		needs_barrier = false;
+		barrier_opt = 1;
+	}
 	ret = jbd2_complete_transaction(journal, commit_tid);
 out_flush:
+	/*
+	 * We MUST send a barrier unless we can guarantee that:
+	 * Latest write request for given inode was completed before
+	 * new flush request was QUEUED and COMPLETED by blkdev.
+	 */
+	if (needs_barrier && q && blk_flush_idx_is_stable(q, flush_idx)) {
+		needs_barrier = false;
+		barrier_opt = 2;
+	}
 	if (needs_barrier) {
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
 			ret = err;
 	}
 out:
-	trace_ext4_sync_file_exit(inode, ret);
+	trace_ext4_sync_file_exit(inode, ret, barrier_opt);
 	return ret;
 }
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 5b87fc3..91581d5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1052,6 +1052,7 @@ got:
 		}
 	}
 
+	ext4_update_inode_fsync_fid(inode);
 	if (ext4_handle_valid(handle)) {
 		ei->i_sync_tid = handle->h_transaction->t_tid;
 		ei->i_datasync_tid = handle->h_transaction->t_tid;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index e75f840..71a27a5 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -633,6 +633,14 @@ out:
 	return err;
 }
 
+static void ext4_ind_end_dio(struct kiocb *iocb, loff_t offset,
+			    ssize_t size, void *private)
+{
+	if (unlikely(!size))
+		return;
+	ext4_update_inode_fsync_fid(file_inode(iocb->ki_filp));
+}
+
 /*
  * O_DIRECT for ext3 (or indirect map) based files
  *
@@ -697,8 +705,12 @@ retry:
 		inode_dio_done(inode);
 	} else {
 locked:
-		ret = blockdev_direct_IO(rw, iocb, inode, iter,
-				 offset, ext4_get_block);
+		ret = __blockdev_direct_IO(rw, iocb, inode,
+					   inode->i_sb->s_bdev, iter,
+					   offset, ext4_get_block,
+					   (rw & WRITE) ? ext4_ind_end_dio :
+					   NULL, NULL,
+					   DIO_LOCKING | DIO_SKIP_HOLES);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9..9879634 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2940,6 +2940,9 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	iocb->private = NULL;
 	io_end->offset = offset;
 	io_end->size = size;
+	if (size)
+		ext4_update_inode_fsync_fid(io_end->inode);
+
 	ext4_put_io_end(io_end);
 }
 
@@ -4035,6 +4038,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ei->i_sync_tid = tid;
 		ei->i_datasync_tid = tid;
 	}
+	ext4_update_inode_fsync_fid(inode);
 
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		if (ei->i_extra_isize == 0) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b24a254..fef8b2e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -305,6 +305,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = 0;
 
+	ext4_update_inode_fsync_fid(io_end->inode);
 	if (error) {
 		struct inode *inode = io_end->inode;
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d4f70a7..4a1989a 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -857,26 +857,28 @@ TRACE_EVENT(ext4_sync_file_enter,
 );
 
 TRACE_EVENT(ext4_sync_file_exit,
-	TP_PROTO(struct inode *inode, int ret),
+	TP_PROTO(struct inode *inode, int ret, int barrier_opt),
 
-	TP_ARGS(inode, ret),
+	TP_ARGS(inode, ret, barrier_opt),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
 		__field(	int,	ret			)
+		__field(	int,	barrier_opt		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= inode->i_sb->s_dev;
 		__entry->ino		= inode->i_ino;
 		__entry->ret		= ret;
+		__entry->barrier_opt	= barrier_opt;
 	),
 
-	TP_printk("dev %d,%d ino %lu ret %d",
+	TP_printk("dev %d,%d ino %lu ret %d, barrier_opt %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
-		  __entry->ret)
+		  __entry->ret, __entry->barrier_opt)
 );
 
 TRACE_EVENT(ext4_sync_fs,
-- 
1.7.1
