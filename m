From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use page_mkwrite vma_operations to get mmap write notification.
Date: Fri, 22 Feb 2008 20:09:16 +0530
Message-ID: <1203691158-6788-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:54501 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYBVOjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 09:39:24 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1MEd0LY031186
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:39:00 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MEh0V6261510
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:43:00 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MEdLU1024411
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:39:22 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We would like to get notified when we are doing a write on mmap section.
This is needed with respect to preallocated area. We split the preallocated
area into initialzed extent and uninitialzed extent in the call back. This
let us handle ENOSPC better. Otherwise we get ENOSPC in the writepage and
that would result in data loss. The changes are also needed to handle ENOSPC
when writing to an mmap section of files with holes.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/file.c          |   19 ++++++++++++++-
 fs/ext4/inode.c         |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ext4_fs.h |    1 +
 3 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 20507a2..77341c1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -123,6 +123,23 @@ force_commit:
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
@@ -133,7 +150,7 @@ const struct file_operations ext4_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext4_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5b5d63d..00af97d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3490,3 +3490,63 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	unsigned long end;
+	loff_t size;
+	handle_t *handle;
+	int ret = -EINVAL, needed_blocks;
+	struct file *file   = vma->vm_file;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	needed_blocks = ext4_writepage_trans_blocks(inode);
+	/* We need to take inode mutex to prevent parallel write */
+	mutex_lock(&inode->i_mutex);
+	lock_page(page);
+	size = i_size_read(inode);
+	if ((page->mapping != inode->i_mapping) ||
+	    (page_offset(page) > size)) {
+		/* page got truncated out from underneath us */
+		goto out_unlock;
+	}
+
+	/* page is wholly or partially inside EOF */
+	if (((page->index + 1) << PAGE_CACHE_SHIFT) > size)
+		end = size & ~PAGE_CACHE_MASK;
+	else
+		end = PAGE_CACHE_SIZE;
+
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_unlock;
+	}
+	/* Will zero out the pages if buffer is marked new */
+	ret = block_prepare_write(page, 0, end, ext4_get_block);
+
+	if (!ret && ext4_should_journal_data(inode)) {
+		ret = walk_page_buffers(handle, page_buffers(page),
+				0, end, NULL, do_journal_get_write_access);
+		if (!ret)
+			ret = walk_page_buffers(handle, page_buffers(page),
+						0, end, NULL, write_end_fn);
+		/*
+		 * we don't want to call block_commit_write in journalled mode
+		 */
+		ext4_journal_stop(handle);
+		goto out_unlock;
+	}
+	if (!ret && ext4_should_order_data(inode)) {
+		ret = walk_page_buffers(handle, page_buffers(page),
+					0, end, NULL, ext4_journal_dirty_data);
+	}
+	if (!ret)
+		ret = block_commit_write(page, 0, end);
+
+	ext4_journal_stop(handle);
+out_unlock:
+	unlock_page(page);
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 22810b1..8f5a563 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -1059,6 +1059,7 @@ extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from);
+extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
-- 
1.5.4.1.97.g40aab-dirty
