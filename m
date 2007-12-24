From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patch queue update
Date: Mon, 24 Dec 2007 12:00:30 +0530
Message-ID: <20071224063030.GB7132@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:38545 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbXLXGbS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2007 01:31:18 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBO6VvTW010129
	for <linux-ext4@vger.kernel.org>; Mon, 24 Dec 2007 17:31:57 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBO6Yqnj271336
	for <linux-ext4@vger.kernel.org>; Mon, 24 Dec 2007 17:34:52 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBO6V0IG006132
	for <linux-ext4@vger.kernel.org>; Mon, 24 Dec 2007 17:31:00 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming,

I have placed the updated patch queue at

http://www.radian.org/~kvaneesh/ext4/dec-24-2007/

The .tar can be found at

http://www.radian.org/~kvaneesh/ext4/dec-24-2007/patch-series.tar

The changes involve the below attached diff. I also updated the commit message
of mballoc core patch.

a) remove the ext-truncate-mutex.patch
b) Add the truncate mutex to read write semaphore conversion patch set.
    This is added at the top of unstable series expecting that it can be
    pushed to stable soon. 
c) Update mballoc and migrate patch to use i_data_sem.
d) mballoc soft lockup fix.
e) update mballoc core patch commit message.
f) Update enable-delalloc-and-mballoc.patch patch to enabled write back
   mode by default. Delalloc only support write back.


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index abc8900..643046b 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -526,7 +526,7 @@ static inline int rsv_is_empty(struct ext4_reserve_window *rsv)
  * when setting the reservation window size through ioctl before the file
  * is open for write (needs block allocation).
  *
- * Needs truncate_mutex protection prior to call this function.
+ * Needs down_write(i_data_sem) protection prior to call this function.
  */
 void ext4_init_block_alloc_info(struct inode *inode)
 {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ff83982..99e539d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1706,7 +1706,7 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
  * This routine returns max. credits that the extent tree can consume.
  * It should be OK for low-performance paths like ->writepage()
  * To allow many writing processes to fit into a single transaction,
- * the caller should calculate credits under truncate_mutex and
+ * the caller should calculate credits under i_data_sem and
  * pass the actual path.
  */
 int ext4_ext_calc_credits_for_insert(struct inode *inode,
@@ -2272,7 +2272,8 @@ out:
 
 /*
  * Need to be called with
- * mutex_lock(&EXT4_I(inode)->truncate_mutex);
+ * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
+ * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
  */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
@@ -2514,7 +2515,7 @@ void ext4_ext_truncate(struct inode * inode, struct page *page)
 	if (page)
 		ext4_block_truncate_page(handle, page, mapping, inode->i_size);
 
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_ext_invalidate_cache(inode);
 
 	ext4_mb_discard_inode_preallocations(inode);
@@ -2552,7 +2553,7 @@ out_stop:
 	if (inode->i_nlink)
 		ext4_orphan_del(handle, inode);
 
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	up_write(&EXT4_I(inode)->i_data_sem);
 	ext4_journal_stop(handle);
 }
 
@@ -2616,6 +2617,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
 	 */
 	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
+	down_write((&EXT4_I(inode)->i_data_sem));
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
@@ -2672,6 +2674,7 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
+	up_write((&EXT4_I(inode)->i_data_sem));
 	/*
 	 * Time to update the file size.
 	 * Update only when preallocation was requested beyond the file size.
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a6b2aa1..ac35ec5 100644
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
index caec966..33018a5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -346,7 +346,7 @@ static int ext4_block_to_path(struct inode *inode,
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
  *
  *      Need to be called with
- *      mutex_lock(&EXT4_I(inode)->truncate_mutex)
+ *      down_read(&EXT4_I(inode)->i_data_sem)
  */
 static Indirect *ext4_get_branch(struct inode *inode, int depth,
 				 ext4_lblk_t  *offsets,
@@ -778,7 +778,8 @@ err_out:
  *
  *
  * Need to be called with
- * mutex_lock(&EXT4_I(inode)->truncate_mutex)
+ * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
+ * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
  */
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		ext4_lblk_t iblock, unsigned long maxblocks,
@@ -866,7 +867,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		err = ext4_splice_branch(handle, inode, iblock,
 					partial, indirect_blks, count);
 	/*
-	 * i_disksize growing is protected by truncate_mutex.  Don't forget to
+	 * i_disksize growing is protected by i_data_sem.  Don't forget to
 	 * protect it if you're about to implement concurrent
 	 * ext4_get_block() -bzzz
 	*/
@@ -896,6 +897,46 @@ out:
 
 #define DIO_CREDITS (EXT4_RESERVE_TRANS_BLOCKS + 32)
 
+int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
+			unsigned long max_blocks, struct buffer_head *bh,
+			int create, int extend_disksize)
+{
+	int retval;
+	/*
+	 * Try to see if we can get  the block without requesting
+	 * for new file system block.
+	 */
+	down_read((&EXT4_I(inode)->i_data_sem));
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
+				bh, 0, 0);
+	} else {
+		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks,
+				bh, 0, 0);
+	}
+	up_read((&EXT4_I(inode)->i_data_sem));
+	if (!create || (retval > 0))
+		return retval;
+
+	/*
+	 * We need to allocate new blocks which will result
+	 * in i_data update
+	 */
+	down_write((&EXT4_I(inode)->i_data_sem));
+	/*
+	 * We need to check for EXT4 here because migrate
+	 * could have changed the inode type in between
+	 */
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
+				bh, create, extend_disksize);
+	} else {
+		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks,
+				bh, create, extend_disksize);
+	}
+	up_write((&EXT4_I(inode)->i_data_sem));
+	return retval;
+}
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
@@ -1386,10 +1427,10 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 			/*
 			 * XXX: replace with spinlock if seen contended -bzzz
 			 */
-			mutex_lock(&EXT4_I(inode)->truncate_mutex);
+			down_write(&EXT4_I(inode)->i_data_sem);
 			if (disksize > EXT4_I(inode)->i_disksize)
 				EXT4_I(inode)->i_disksize = disksize;
-			mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+			up_write(&EXT4_I(inode)->i_data_sem);
 
 			if (EXT4_I(inode)->i_disksize == disksize) {
 				if (handle == NULL)
@@ -1540,7 +1581,7 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
  *	ext4_file_write() -> generic_file_write() -> __alloc_pages() -> ...
  *
  * Same applies to ext4_get_block().  We will deadlock on various things like
- * lock_journal and i_truncate_mutex.
+ * lock_journal and i_data_sem
  *
  * Setting PF_MEMALLOC here doesn't work - too many internal memory
  * allocations fail.
@@ -2484,7 +2525,7 @@ void ext4_truncate(struct inode *inode)
 	 * From here we block out all ext4_get_block() callers who want to
 	 * modify the block allocation tree.
 	 */
-	mutex_lock(&ei->truncate_mutex);
+	down_write(&ei->i_data_sem);
 
 	if (n == 1) {		/* direct blocks */
 		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
@@ -2548,7 +2589,7 @@ do_indirects:
 
 	ext4_discard_reservation(inode);
 
-	mutex_unlock(&ei->truncate_mutex);
+	up_write(&ei->i_data_sem);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3a5327e..2ed7c37 100644
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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 72e1920..cbc8143 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -131,7 +131,7 @@
  *      the simplest way would be to have buddy initialized by the discard
  *  - new PA vs.
  *    - use inode PA
- *      i_truncate_mutex serializes them
+ *      i_data_sem serializes them
  *    - discard inode PA
  *      discard process must wait until PA isn't used by another process
  *    - use locality group PA
@@ -140,7 +140,7 @@
  *      discard process must wait until PA isn't used by another process
  *  - use inode PA
  *    - use inode PA
- *      i_truncate_mutex or another mutex should serializes them
+ *      i_data_sem or another mutex should serializes them
  *    - discard inode PA
  *      discard process must wait until PA isn't used by another process
  *    - use locality group PA
@@ -3729,7 +3729,7 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
-	int busy;
+	int busy = 0;
 	int free = 0;
 
 	mb_debug("discard preallocation for group %lu\n", group);
@@ -3754,20 +3754,12 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	INIT_LIST_HEAD(&list);
 
 repeat:
-	busy = 0;
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
 		if (atomic_read(&pa->pa_count)) {
 			spin_unlock(&pa->pa_lock);
-			/* FIXME!!
-			 * It is quiet natural to have the pa being
-			 * used on other cpus when we are trying free
-			 * space
-			printk(KERN_ERR "uh! busy PA\n");
-			dump_stack();
-			*/
 			busy = 1;
 			continue;
 		}
@@ -3790,7 +3782,9 @@ repeat:
 
 	/* if we still need more blocks and some PAs were used, try again */
 	if (free < needed && busy) {
+		busy = 0;
 		ext4_unlock_group(sb, group);
+		schedule_timeout(HZ);
 		goto repeat;
 	}
 
@@ -3827,7 +3821,7 @@ out:
 /*
  * releases all non-used preallocated blocks for given inode
  *
- * It's important to discard preallocations under truncate_mutex
+ * It's important to discard preallocations under i_data_sem
  * We don't want another block to be served from the prealloc
  * space when we are discarding the inode prealloc space.
  *
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index b54c084..0e4bffe 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -463,7 +463,7 @@ int ext4_ext_migrate(struct inode * inode, struct file * filp,
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
 		return -EINVAL;
 
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	down_write(&EXT4_I(inode)->i_data_sem);
 
 
 	handle = ext4_journal_start(inode,
@@ -621,7 +621,7 @@ err_out:
 
 	ext4_journal_stop(handle);
 
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	up_write(&EXT4_I(inode)->i_data_sem);
 
 	if (tmp_inode)
 		iput(tmp_inode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 00e2cbb..ba4bac7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -596,7 +596,7 @@ static void init_once(struct kmem_cache *cachep, void *foo)
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 	init_rwsem(&ei->xattr_sem);
 #endif
-	mutex_init(&ei->truncate_mutex);
+	init_rwsem(&ei->i_data_sem);
 	inode_init_once(&ei->vfs_inode);
 }
 
@@ -1889,6 +1889,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 */
 	set_opt(sbi->s_mount_opt, EXTENTS);
 	set_opt(sbi->s_mount_opt, DELALLOC);
+	set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
 	set_opt(sbi->s_mount_opt, MBALLOC);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 95b4501..aff5868 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -1158,27 +1158,9 @@ extern void ext4_ext_init(struct super_block *);
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
-		retval = ext4_ext_get_blocks(handle, inode,
-						(ext4_lblk_t)block, max_blocks,
-						bh, create, extend_disksize);
-	} else {
-		retval = ext4_get_blocks_handle(handle, inode,
-						(ext4_lblk_t)block, max_blocks,
-						bh, create, extend_disksize);
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
index 7cba9c4..d5508d3 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -139,16 +139,16 @@ struct ext4_inode_info {
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
