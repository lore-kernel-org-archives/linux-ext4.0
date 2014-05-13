From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 1/2] ext4: introduce new i_write_mutex to protect fallocate
Date: Tue, 13 May 2014 09:19:17 +0900
Message-ID: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41079 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaEMATU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2014 20:19:20 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N5H008BXKW6PJ70@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 13 May 2014 09:19:18 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce new i_write_mutex to protect new writes from coming while doing
fallocate operations. Also, get rid of aio_mutex as it is covered by
i_write_mutex.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/ext4.h    |  6 +++---
 fs/ext4/extents.c | 18 +++++++++++++++---
 fs/ext4/file.c    | 18 +++++++++++-------
 fs/ext4/inode.c   |  7 ++++++-
 fs/ext4/super.c   |  3 +--
 5 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6b45afa..77e5705 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -943,6 +943,9 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+
+	/* protects fallocate operations racing with new writes */
+	struct mutex i_write_mutex;
 };
 
 /*
@@ -2827,10 +2830,7 @@ static inline void ext4_inode_resume_unlocked_dio(struct inode *inode)
 #define EXT4_WQ_HASH_SZ		37
 #define ext4_ioend_wq(v)   (&ext4__ioend_wq[((unsigned long)(v)) %\
 					    EXT4_WQ_HASH_SZ])
-#define ext4_aio_mutex(v)  (&ext4__aio_mutex[((unsigned long)(v)) %\
-					     EXT4_WQ_HASH_SZ])
 extern wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
-extern struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
 
 #define EXT4_RESIZING	0
 extern int ext4_resize_begin(struct super_block *sb);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 086baa9..5262750 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4741,6 +4741,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
+	mutex_lock(&EXT4_I(inode)->i_write_mutex);
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
@@ -4748,8 +4750,10 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 		ret = filemap_write_and_wait_range(mapping, offset,
 						   offset + len - 1);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 			return ret;
+		}
 	}
 
 	/*
@@ -4761,8 +4765,10 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	start = round_up(offset, 1 << blkbits);
 	end = round_down((offset + len), 1 << blkbits);
 
-	if (start < offset || end > offset + len)
+	if (start < offset || end > offset + len) {
+		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 		return -EINVAL;
+	}
 	partial = (offset + len) & ((1 << blkbits) - 1);
 
 	lblk = start >> blkbits;
@@ -4859,6 +4865,7 @@ out_dio:
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 	return ret;
 }
 
@@ -5428,11 +5435,15 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
 	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
 
+	mutex_lock(&EXT4_I(inode)->i_write_mutex);
+
 	/* Call ext4_force_commit to flush all data in case of data=journal. */
 	if (ext4_should_journal_data(inode)) {
 		ret = ext4_force_commit(inode->i_sb);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 			return ret;
+		}
 	}
 
 	/*
@@ -5518,5 +5529,6 @@ out_dio:
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 	return ret;
 }
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 708aad7..557b4ac 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -93,7 +93,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct mutex *aio_mutex = NULL;
+	bool unaligned_direct_aio = false;
 	struct blk_plug plug;
 	int o_direct = file->f_flags & O_DIRECT;
 	int overwrite = 0;
@@ -101,6 +101,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	loff_t pos = iocb->ki_pos;
 
+	mutex_lock(&EXT4_I(inode)->i_write_mutex);
+
 	/*
 	 * Unaligned direct AIO must be serialized; see comment above
 	 * In the case of O_APPEND, assume that we must always serialize
@@ -110,8 +112,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	    !is_sync_kiocb(iocb) &&
 	    (file->f_flags & O_APPEND ||
 	     ext4_unaligned_aio(inode, from, pos))) {
-		aio_mutex = ext4_aio_mutex(inode);
-		mutex_lock(aio_mutex);
+		unaligned_direct_aio = true;
 		ext4_unwritten_wait(inode);
 	}
 
@@ -143,8 +144,9 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		iocb->private = &overwrite;
 
 		/* check whether we do a DIO overwrite or not */
-		if (ext4_should_dioread_nolock(inode) && !aio_mutex &&
-		    !file->f_mapping->nrpages && pos + length <= i_size_read(inode)) {
+		if (ext4_should_dioread_nolock(inode) &&
+		    !unaligned_direct_aio && !file->f_mapping->nrpages &&
+		    pos + length <= i_size_read(inode)) {
 			struct ext4_map_blocks map;
 			unsigned int blkbits = inode->i_blkbits;
 			int err, len;
@@ -174,6 +176,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	ret = __generic_file_write_iter(iocb, from);
 	mutex_unlock(&inode->i_mutex);
+	if (!unaligned_direct_aio)
+		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 
 	if (ret > 0) {
 		ssize_t err;
@@ -186,8 +190,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		blk_finish_plug(&plug);
 
 errout:
-	if (aio_mutex)
-		mutex_unlock(aio_mutex);
+	if (unaligned_direct_aio)
+		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 	return ret;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b1dc334..d804120 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3528,6 +3528,8 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
+	mutex_lock(&EXT4_I(inode)->i_write_mutex);
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
@@ -3535,8 +3537,10 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 		ret = filemap_write_and_wait_range(mapping, offset,
 						   offset + length - 1);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 			return ret;
+		}
 	}
 
 	mutex_lock(&inode->i_mutex);
@@ -3637,6 +3641,7 @@ out_dio:
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 	return ret;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1f8cb18..e236c85 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -904,6 +904,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
+	mutex_init(&ei->i_write_mutex);
 
 	return &ei->vfs_inode;
 }
@@ -5505,7 +5506,6 @@ static void ext4_exit_feat_adverts(void)
 
 /* Shared across all ext4 file systems */
 wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
-struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
 
 static int __init ext4_init_fs(void)
 {
@@ -5518,7 +5518,6 @@ static int __init ext4_init_fs(void)
 	ext4_check_flag_values();
 
 	for (i = 0; i < EXT4_WQ_HASH_SZ; i++) {
-		mutex_init(&ext4__aio_mutex[i]);
 		init_waitqueue_head(&ext4__ioend_wq[i]);
 	}
 
-- 
1.7.11-rc0

