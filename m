From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext3: Use page_mkwrite vma_operations to get mmap write notification.
Date: Fri,  6 Jun 2008 23:54:49 +0530
Message-ID: <1212776693-435-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212776693-435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:33351 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYFFSZV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:25:21 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m56IOkDN024842
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:24:46 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56ITU71283838
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:29:31 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56IPJOp031714
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:20 +1000
In-Reply-To: <1212776693-435-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We would like to get notified when we are doing a write on mmap section.
The changes are needed to handle ENOSPC when writing to an mmap section
of files with holes.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/file.c          |   19 +++++++++++-
 fs/ext3/inode.c         |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ext3_fs.h |    1 +
 3 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index acc4913..09e22e4 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -106,6 +106,23 @@ ext3_file_write(struct kiocb *iocb, const struct iovec *iov,
 	return ret;
 }
 
+static struct vm_operations_struct ext3_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite   = ext3_page_mkwrite,
+};
+
+static int ext3_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext3_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext3_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -116,7 +133,7 @@ ext3_file_write(struct kiocb *iocb, const struct iovec *iov,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext3_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 6ae4ecf..c8261f0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3295,3 +3295,79 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+static int ext3_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
+{
+	if (!buffer_mapped(bh)) {
+		/*
+		 * Mark buffer as dirty so that
+		 * block_write_full_page() writes it
+		 */
+		set_buffer_dirty(bh);
+	}
+	return 0;
+}
+
+static int ext3_bh_unmapped(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh);
+}
+
+int ext3_page_mkwrite(struct vm_area_struct *vma, struct page *page)
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
+				       ext3_bh_unmapped))
+			goto out_unlock;
+		/*
+		 * Now mark all the  buffer head dirty so
+		 * that writepage can write it
+		 */
+		walk_page_buffers(NULL, page_buffers(page), 0, len,
+					NULL, ext3_bh_prepare_fill);
+	}
+	/*
+	 * OK, we need to fill the hole... Lock the page and do writepage.
+	 * We can't do write_begin and write_end here because we don't
+	 * have inode_mutex and that allow parallel write_begin, write_end call.
+	 * (lock_page prevent this from happening on the same page though)
+	 */
+	lock_page(page);
+	wbc.range_start = page_offset(page);
+	wbc.range_end = page_offset(page) + len;
+	ret = mapping->a_ops->writepage(page, &wbc);
+	/* writepage unlocks the page */
+out_unlock:
+	up_read(&inode->i_alloc_sem);
+	return ret;
+}
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..715c35e 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -836,6 +836,7 @@ extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
+extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-- 
1.5.5.1.357.g1af8b.dirty

