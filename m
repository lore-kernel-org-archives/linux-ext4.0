From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext4: Use page_mkwrite vma_operations to get mmap write notification.
Date: Tue,  4 Mar 2008 18:12:22 +0530
Message-ID: <1204634542-16599-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:35592 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755957AbYCDMmY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:42:24 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m24CgMbh012577
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:12:22 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m24CgMAO970788
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:12:22 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m24CgMLY032341
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 12:42:22 GMT
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
 fs/ext4/file.c          |   19 ++++++++++++++++++-
 fs/ext4/inode.c         |   15 +++++++++++++++
 include/linux/ext4_fs.h |    1 +
 3 files changed, 34 insertions(+), 1 deletions(-)

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
index 0f86bbb..42bc666 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3493,3 +3493,18 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	/*
+	 * if ext4_get_block resulted in a split of an uninitialized extent,
+	 * in file system full case, we will have to take the journal write
+	 * access and zero out the page. The journal handle get initialized
+	 * in ext4_get_block.
+	 */
+	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
+	 * it has a circular locking dependency with DIO. But migrate expect
+	 * i_mutex to ensure no i_data changes
+	 */
+	return block_page_mkwrite(vma, page, ext4_get_block);
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
1.5.4.3.422.g34cd6.dirty

