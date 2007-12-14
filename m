From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ext4: Convert truncate_mutex to read write semaphore.
Date: Fri, 14 Dec 2007 21:18:16 +0530
Message-ID: <1197647297-7009-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1197647297-7009-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1197647297-7009-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:45713 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbXLNPsu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2007 10:48:50 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBEFnNSF017114
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:49:23 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBEFmmEe2150616
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:48:48 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBEFmUj2014835
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:48:31 +1100
In-Reply-To: <1197647297-7009-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are currently taking the truncate_mutex for every read. This would have
performance impact on large CPU configuration. Convert the lock to read write
semaphore and take read lock when we are trying to read the file.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c          |    2 +-
 fs/ext4/extents.c         |   13 +++++++------
 fs/ext4/file.c            |    4 ++--
 fs/ext4/inode.c           |   39 ++++++++++++++++++++++++++++++++-------
 fs/ext4/ioctl.c           |    4 ++--
 fs/ext4/super.c           |    2 +-
 include/linux/ext4_fs.h   |   22 +++-------------------
 include/linux/ext4_fs_i.h |    6 +++---
 8 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 71ee95e..4eca63d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -463,7 +463,7 @@ static inline int rsv_is_empty(struct ext4_reserve_window *rsv)
  * when setting the reservation window size through ioctl before the file
  * is open for write (needs block allocation).
  *
- * Needs truncate_mutex protection prior to call this function.
+ * Needs down_write(i_data_sem) protection prior to call this function.
  */
 void ext4_init_block_alloc_info(struct inode *inode)
 {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 98ef84d..3513301 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1666,7 +1666,7 @@ int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
  * This routine returns max. credits that the extent tree can consume.
  * It should be OK for low-performance paths like ->writepage()
  * To allow many writing processes to fit into a single transaction,
- * the caller should calculate credits under truncate_mutex and
+ * the caller should calculate credits under i_data_sem and
  * pass the actual path.
  */
 int ext4_ext_calc_credits_for_insert(struct inode *inode,
@@ -2227,7 +2227,8 @@ out:
 
 /*
  * Need to be called with
- * mutex_lock(&EXT4_I(inode)->truncate_mutex);
+ * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
+ * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
  */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t iblock,
@@ -2446,7 +2447,7 @@ void ext4_ext_truncate(struct inode * inode, struct page *page)
 	if (page)
 		ext4_block_truncate_page(handle, page, mapping, inode->i_size);
 
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_ext_invalidate_cache(inode);
 
 	/*
@@ -2482,7 +2483,7 @@ out_stop:
 	if (inode->i_nlink)
 		ext4_orphan_del(handle, inode);
 
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	up_write(&EXT4_I(inode)->i_data_sem);
 	ext4_journal_stop(handle);
 }
 
@@ -2545,7 +2546,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
 	 */
 	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
-	mutex_lock(&EXT4_I(inode)->truncate_mutex)
+	down_write((&EXT4_I(inode)->i_data_sem));
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
@@ -2602,7 +2603,7 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex)
+	up_write((&EXT4_I(inode)->i_data_sem));
 	/*
 	 * Time to update the file size.
 	 * Update only when preallocation was requested beyond the file size.
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 1a81cd6..ba4cf05 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -37,9 +37,9 @@ static int ext4_release_file (struct inode * inode, struct file * filp)
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1))
 	{
-		mutex_lock(&EXT4_I(inode)->truncate_mutex);
+		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_reservation(inode);
-		mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+		up_write(&EXT4_I(inode)->i_data_sem);
 	}
 	if (is_dx(inode) && filp->private_data)
 		ext4_htree_free_dir_info(filp->private_data);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9cf37b2..669d560 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -341,7 +341,7 @@ static int ext4_block_to_path(struct inode *inode,
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
  *
  *      Need to be called with
- *      mutex_lock(&EXT4_I(inode)->truncate_mutex)
+ *      down_read(&EXT4_I(inode)->i_data_sem)
  */
 static Indirect *ext4_get_branch(struct inode *inode, int depth, int *offsets,
 				 Indirect chain[4], int *err)
@@ -772,7 +772,8 @@ err_out:
  *
  *
  * Need to be called with
- * mutex_lock(&EXT4_I(inode)->truncate_mutex)
+ * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
+ * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
  */
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		sector_t iblock, unsigned long maxblocks,
@@ -794,7 +795,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
 	J_ASSERT(handle != NULL || create == 0);
-	depth = ext4_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
+	depth = ext4_block_to_path(inode, iblock, offsets, &blocks_to_boundary);
 
 	if (depth == 0)
 		goto out;
@@ -859,7 +860,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		err = ext4_splice_branch(handle, inode, iblock,
 					partial, indirect_blks, count);
 	/*
-	 * i_disksize growing is protected by truncate_mutex.  Don't forget to
+	 * i_disksize growing is protected by i_data_sem.  Don't forget to
 	 * protect it if you're about to implement concurrent
 	 * ext4_get_block() -bzzz
 	*/
@@ -889,6 +890,30 @@ out:
 
 #define DIO_CREDITS (EXT4_RESERVE_TRANS_BLOCKS + 32)
 
+int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
+			unsigned long max_blocks, struct buffer_head *bh,
+			int create, int extend_disksize)
+{
+	int retval;
+	if (create) {
+		down_write((&EXT4_I(inode)->i_data_sem));
+	} else {
+		down_read((&EXT4_I(inode)->i_data_sem));
+	}
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
+				bh, create, extend_disksize);
+	} else {
+		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks,
+				bh, create, extend_disksize);
+	}
+	if (create) {
+		up_write((&EXT4_I(inode)->i_data_sem));
+	} else {
+		up_read((&EXT4_I(inode)->i_data_sem));
+	}
+	return retval;
+}
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
@@ -1393,7 +1418,7 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
  *	ext4_file_write() -> generic_file_write() -> __alloc_pages() -> ...
  *
  * Same applies to ext4_get_block().  We will deadlock on various things like
- * lock_journal and i_truncate_mutex.
+ * lock_journal and i_data_sem
  *
  * Setting PF_MEMALLOC here doesn't work - too many internal memory
  * allocations fail.
@@ -2316,7 +2341,7 @@ void ext4_truncate(struct inode *inode)
 	 * From here we block out all ext4_get_block() callers who want to
 	 * modify the block allocation tree.
 	 */
-	mutex_lock(&ei->truncate_mutex);
+	down_write(&ei->i_data_sem);
 
 	if (n == 1) {		/* direct blocks */
 		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
@@ -2380,7 +2405,7 @@ do_indirects:
 
 	ext4_discard_reservation(inode);
 
-	mutex_unlock(&ei->truncate_mutex);
+	up_write(&ei->i_data_sem);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e7f894b..c0e5b8c 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -199,7 +199,7 @@ flags_err:
 		 * need to allocate reservation structure for this inode
 		 * before set the window size
 		 */
-		mutex_lock(&ei->truncate_mutex);
+		down_write(&ei->i_data_sem);
 		if (!ei->i_block_alloc_info)
 			ext4_init_block_alloc_info(inode);
 
@@ -207,7 +207,7 @@ flags_err:
 			struct ext4_reserve_window_node *rsv = &ei->i_block_alloc_info->rsv_window_node;
 			rsv->rsv_goal_size = rsv_window_size;
 		}
-		mutex_unlock(&ei->truncate_mutex);
+		up_write(&ei->i_data_sem);
 		return 0;
 	}
 	case EXT4_IOC_GROUP_EXTEND: {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8031dc0..a55866f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -533,7 +533,7 @@ static void init_once(struct kmem_cache *cachep, void *foo)
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 	init_rwsem(&ei->xattr_sem);
 #endif
-	mutex_init(&ei->truncate_mutex);
+	init_rwsem(&ei->i_data_sem);
 	inode_init_once(&ei->vfs_inode);
 }
 
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 7f84645..69e9b75 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -1056,25 +1056,9 @@ extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
-static inline int
-ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
-			unsigned long max_blocks, struct buffer_head *bh,
-			int create, int extend_disksize)
-{
-	int retval;
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
-		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-					bh, create, extend_disksize);
-	} else {
-		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
-					create, extend_disksize);
-	}
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
-	return retval;
-}
-
-
+extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
+			sector_t block, unsigned long max_blocks,
+			struct buffer_head *bh, int create, int extend_disksize);
 #endif	/* __KERNEL__ */
 
 #endif	/* _LINUX_EXT4_FS_H */
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 86ddfe2..55e185b 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -134,16 +134,16 @@ struct ext4_inode_info {
 	__u16 i_extra_isize;
 
 	/*
-	 * truncate_mutex is for serialising ext4_truncate() against
+	 * i_data_sem is for serialising ext4_truncate() against
 	 * ext4_getblock().  In the 2.4 ext2 design, great chunks of inode's
 	 * data tree are chopped off during truncate. We can't do that in
 	 * ext4 because whenever we perform intermediate commits during
 	 * truncate, the inode and all the metadata blocks *must* be in a
 	 * consistent state which allows truncation of the orphans to restart
 	 * during recovery.  Hence we must fix the get_block-vs-truncate race
-	 * by other means, so we have truncate_mutex.
+	 * by other means, so we have i_data_sem.
 	 */
-	struct mutex truncate_mutex;
+	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 
 	unsigned long i_ext_generation;
-- 
1.5.4.rc0-dirty
