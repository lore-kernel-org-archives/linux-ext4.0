From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use page_mkwrite vma_operations to get mmap write notification.
Date: Wed, 21 May 2008 23:14:19 +0530
Message-ID: <1211391859-17399-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1211391859-17399-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:36703 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936246AbYEURpY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 13:45:24 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4LHjCwV022183
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:15:12 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHj0Yi1454100
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:15:00 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4LHitjh018745
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:56 +0530
In-Reply-To: <1211391859-17399-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We would like to get notified when we are doing a write on mmap section.
This is needed with respect to preallocated area. We split the preallocated
area into initialzed extent and uninitialzed extent in the call back. This
let us handle ENOSPC better. Otherwise we get ENOSPC in the writepage and
that would result in data loss. The changes are also needed to handle ENOSPC
when writing to an mmap section of files with holes.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/file.c  |   19 +++++++++++++++++-
 fs/ext4/inode.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6605076..77cbb28 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1053,6 +1053,7 @@ extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from);
+extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 4159be6..b9510ba 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -123,6 +123,23 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	return ret;
 }
 
+static struct vm_operations_struct ext4_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite   = ext4_page_mkwrite,
+};
+
+static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext4_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext4_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -133,7 +150,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext4_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4a7ed29..d361693 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3555,3 +3555,61 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh);
+}
+
+int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	loff_t size;
+	unsigned long len;
+	int ret = -EINVAL;
+	struct file *file = vma->vm_file;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	struct writeback_control wbc = { .sync_mode = WB_SYNC_NONE,
+					 .nr_to_write = 1 };
+
+	/*
+	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
+	 * get i_mutex because we are already holding mmap_sem.
+	 */
+	down_read(&inode->i_alloc_sem);
+	size = i_size_read(inode);
+	if (page->mapping != mapping || size <= page_offset(page)
+	    || !PageUptodate(page)) {
+		/* page got truncated from under us? */
+		goto out_unlock;
+	}
+	ret = 0;
+	if (PageMappedToDisk(page))
+		goto out_unlock;
+
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+
+	if (page_has_buffers(page)) {
+		/* return if we have all the buffers mapped */
+		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				       ext4_bh_unmapped))
+			goto out_unlock;
+	}
+	/*
+	 * OK, we need to fill the hole... Lock the page and do writepage.
+	 * We can't do write_begin and write_end here because we don't
+	 * have inode_mutex and that allow parallel write_begin, write_end call.
+	 * (lock_page prevent this from happening on the same page though)
+	 */
+	lock_page(page);
+	wbc.range_start = page_offset(page);
+	wbc.range_end = page_offset(page) + PAGE_CACHE_SIZE;
+	ret = mapping->a_ops->writepage(page, &wbc);
+	/* writepage unlocks the page */
+out_unlock:
+	up_read(&inode->i_alloc_sem);
+	return ret;
+}
-- 
1.5.5.1.211.g65ea3.dirty

