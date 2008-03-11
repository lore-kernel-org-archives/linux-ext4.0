From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix the locking with respect to ext3 to ext4 migrate.
Date: Tue, 11 Mar 2008 11:16:53 +0530
Message-ID: <1205214413-8267-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:35125 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089AbYCKFqx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 01:46:53 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2B5kq6j030377
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 11:16:52 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B5kq2W1347676
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 11:16:52 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2B5kwjU022640
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 05:46:58 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext3 to Ext4 migrate takes inode->i_mutex lock to make sure write
and truncate of the original inode doesn't happen during the migrate.
But a write to mmap area mapping holes of the file can still happen.
Such writes results in new block allocation and changes to the i_data
field of inode. Add i_migrate_sem read write semaphore to protect against
this. The semaphore is taken in read mode when trying to write to the
mmap area. This happens only once via page_mkwrite call back. Taking
the semaphore in read mode ensures that multiple mmap write can still
happen. In the migrate code we take the semaphore in write mode.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c           |   17 +++++++++++++----
 fs/ext4/migrate.c         |    7 +++++++
 fs/ext4/super.c           |    1 +
 include/linux/ext4_fs_i.h |   12 ++++++++++++
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 059f2fc..4a61ce5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3496,15 +3496,24 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 
 int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
+	int retval;
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	/*
 	 * if ext4_get_block resulted in a split of an uninitialized extent,
 	 * in file system full case, we will have to take the journal write
 	 * access and zero out the page. The journal handle get initialized
 	 * in ext4_get_block.
 	 */
-	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
-	 * it has a circular locking dependency with DIO. But migrate expect
-	 * i_mutex to ensure no i_data changes
+	/* we need to make sure we don't allow migrate to happen. This is
+	 * needed because a write to area mapping holes can result in block
+	 * allocation and update of i_data field. We can't take inode->i_mutex
+	 * here because it changes the locking order with rspect to directIO.
+	 * directIO expect i_mutex -> mmap_sem. We are here already holding
+	 * mmap_sem
 	 */
-	return block_page_mkwrite(vma, page, ext4_get_block);
+	down_read(&(EXT4_I(inode)->i_migrate_sem));
+	retval =  block_page_mkwrite(vma, page, ext4_get_block);
+	up_read(&(EXT4_I(inode)->i_migrate_sem));
+
+	return retval;
 }
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 5c1e27d..a3fbd9f 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -508,6 +508,12 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 * switch the inode format to prevent read.
 	 */
 	mutex_lock(&(inode->i_mutex));
+	/*
+	 * prevent a mmap write to holes
+	 * i_mutex is ranked above i_migrate_sem.
+	 * The order is i_mutex -> mmap_sem -> i_migrate_sem
+	 */
+	down_write(&(EXT4_I(inode)->i_migrate_sem));
 	handle = ext4_journal_start(inode, 1);
 
 	ei = EXT4_I(inode);
@@ -593,6 +599,7 @@ err_out:
 	tmp_inode->i_nlink = 0;
 
 	ext4_journal_stop(handle);
+	up_write(&(EXT4_I(inode)->i_migrate_sem));
 	mutex_unlock(&(inode->i_mutex));
 
 	if (tmp_inode)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bc385c4..5d6e9b2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -599,6 +599,7 @@ static void init_once(struct kmem_cache *cachep, void *foo)
 #endif
 	init_rwsem(&ei->i_data_sem);
 	inode_init_once(&ei->vfs_inode);
+	init_rwsem(&ei->i_migrate_sem);
 }
 
 static int init_inodecache(void)
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index d5508d3..96c0b4f 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -162,6 +162,18 @@ struct ext4_inode_info {
 	/* mballoc */
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
+
+	/* When doing migrate we need to ensure that the i_data field
+	 * doesn't change. With respect to write and truncate we can ensure
+	 * the same by taking inode->i_mutex. But a write to mmap area
+	 * mapping holes doesn't take i_mutex since it doesn't change the
+	 * i_size. We also can't take i_data_sem because we would like to
+	 * extend/restart the journal and locking order prevents us from
+	 * restarting journal within i_data_sem. This will be taken in
+	 * page_mkwrite in the read mode and migrate will take it in the
+	 * write mode.
+	 */
+	struct rw_semaphore i_migrate_sem;
 };
 
 #endif	/* _LINUX_EXT4_FS_I */
-- 
1.5.4.4.481.g5075.dirty

