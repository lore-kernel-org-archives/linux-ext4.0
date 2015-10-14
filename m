From: Jan Kara <jack@suse.com>
Subject: [PATCH 1/6] ext4: Fix races between page faults and hole punching
Date: Wed, 14 Oct 2015 13:30:22 +0200
Message-ID: <1444822227-29984-2-git-send-email-jack@suse.com>
References: <1444822227-29984-1-git-send-email-jack@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbbJNLan (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Oct 2015 07:30:43 -0400
In-Reply-To: <1444822227-29984-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, page faults and hole punching are completely unsynchronized.
This can result in page fault faulting in a page into a range that we
are punching after truncate_pagecache_range() has been called and thus
we can end up with a page mapped to disk blocks that will be shortly
freed. Filesystem corruption will shortly follow. Note that the same
race is avoided for truncate by checking page fault offset against
i_size but there isn't similar mechanism available for punching holes.

Fix the problem by creating new rw semaphore i_mmap_sem in inode and
grab it for writing over truncate and hole punching and for read over
page faults. We cannot easily use i_data_sem for this since that ranks
below transaction start and we need something ranking above it so that
it can be held over the whole truncate / hole punching operation.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/ext4.h  | 10 +++++++++
 fs/ext4/file.c  | 66 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/inode.c | 27 +++++++++++++++++++----
 fs/ext4/super.c |  1 +
 4 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fd1f28be5296..c19ff61ccbdf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -869,6 +869,15 @@ struct ext4_inode_info {
 	 * by other means, so we have i_data_sem.
 	 */
 	struct rw_semaphore i_data_sem;
+	/*
+	 * i_mmap_sem is for serializing page faults with truncate / punch hole
+	 * operations. We have to make sure that new page cannot be faulted in
+	 * a section of the inode that is being punched. We cannot easily use
+	 * i_data_sem for this since we need protection for the whole punch
+	 * operation and i_data_sem ranks below transaction start so we have
+	 * to occasionally drop it.
+	 */
+	struct rw_semaphore i_mmap_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
 
@@ -2316,6 +2325,7 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 113837e7ba98..0d24ebcd7c9e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -209,15 +209,18 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	int result;
 	handle_t *handle = NULL;
-	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+	struct inode *inode = file_inode(vma->vm_file);
+	struct super_block *sb = inode->i_sb;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
+		down_read(&EXT4_I(inode)->i_mmap_sem);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 						EXT4_DATA_TRANS_BLOCKS(sb));
-	}
+	} else
+		down_read(&EXT4_I(inode)->i_mmap_sem);
 
 	if (IS_ERR(handle))
 		result = VM_FAULT_SIGBUS;
@@ -228,8 +231,10 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (write) {
 		if (!IS_ERR(handle))
 			ext4_journal_stop(handle);
+		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
-	}
+	} else
+		up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return result;
 }
@@ -246,10 +251,12 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vma->vm_file);
+		down_read(&EXT4_I(inode)->i_mmap_sem);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 				ext4_chunk_trans_blocks(inode,
 							PMD_SIZE / PAGE_SIZE));
-	}
+	} else
+		down_read(&EXT4_I(inode)->i_mmap_sem);
 
 	if (IS_ERR(handle))
 		result = VM_FAULT_SIGBUS;
@@ -260,30 +267,71 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	if (write) {
 		if (!IS_ERR(handle))
 			ext4_journal_stop(handle);
+		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
-	}
+	} else
+		up_read(&EXT4_I(inode)->i_mmap_sem);
 
 	return result;
 }
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block_dax,
-				ext4_end_io_unwritten);
+	int err;
+	struct inode *inode = file_inode(vma->vm_file);
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vma->vm_file);
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	err = __dax_mkwrite(vma, vmf, ext4_get_block_dax,
+			    ext4_end_io_unwritten);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+	sb_end_pagefault(inode->i_sb);
+
+	return err;
+}
+
+/*
+ * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_mkwrite()
+ * handler we check for races agaist truncate. Note that since we cycle through
+ * i_mmap_sem, we are sure that also any hole punching that began before we
+ * were called is finished by now and so if it included part of the file we
+ * are working on, our pte will get unmapped and the check for pte_same() in
+ * wp_pfn_shared() fails. Thus fault gets retried and things work out as
+ * desired.
+ */
+static int ext4_dax_pfn_mkwrite(struct vm_area_struct *vma,
+				struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct super_block *sb = inode->i_sb;
+	int ret = VM_FAULT_NOPAGE;
+	loff_t size;
+
+	sb_start_pagefault(sb);
+	file_update_time(vma->vm_file);
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		ret = VM_FAULT_SIGBUS;
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+	sb_end_pagefault(sb);
+
+	return ret;
 }
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
 	.pmd_fault	= ext4_dax_pmd_fault,
 	.page_mkwrite	= ext4_dax_mkwrite,
-	.pfn_mkwrite	= dax_pfn_mkwrite,
+	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
 };
 #else
 #define ext4_dax_vm_ops	ext4_file_vm_ops
 #endif
 
 static const struct vm_operations_struct ext4_file_vm_ops = {
-	.fault		= filemap_fault,
+	.fault		= ext4_filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite   = ext4_page_mkwrite,
 };
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 612fbcf76b5c..9b20563e10f2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3581,6 +3581,11 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 
 	}
 
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
+	down_write(&EXT4_I(inode)->i_mmap_sem);
 	first_block_offset = round_up(offset, sb->s_blocksize);
 	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
 
@@ -3589,10 +3594,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
 
-	/* Wait all existing dio workers, newcomers will block on i_mutex */
-	ext4_inode_block_unlocked_dio(inode);
-	inode_dio_wait(inode);
-
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		credits = ext4_writepage_trans_blocks(inode);
 	else
@@ -3648,6 +3649,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
@@ -4784,6 +4786,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			} else
 				ext4_wait_for_tail_page_commit(inode);
 		}
+		down_write(&EXT4_I(inode)->i_mmap_sem);
 		/*
 		 * Truncate pagecache after we've waited for commit
 		 * in data=journal mode to make pages freeable.
@@ -4791,6 +4794,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		truncate_pagecache(inode, inode->i_size);
 		if (shrink)
 			ext4_truncate(inode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
 	}
 
 	if (!rc) {
@@ -5239,6 +5243,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -5308,6 +5314,19 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
+
+int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	int err;
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	err = filemap_fault(vma, vmf);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+
+	return err;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a63c7b0a10cf..61fad9e33bb9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -955,6 +955,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&ei->i_orphan);
 	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
+	init_rwsem(&ei->i_mmap_sem);
 	inode_init_once(&ei->vfs_inode);
 }
 
-- 
2.1.4

