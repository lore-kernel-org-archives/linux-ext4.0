From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext2: Use page_mkwrite vma_operations to get mmap write notification.
Date: Thu,  5 Jun 2008 22:35:12 +0530
Message-ID: <1212685513-32237-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:59840 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYFERFd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 13:05:33 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m55H5Jsw001596
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 22:35:19 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55H4m4I688178
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 22:34:48 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m55H5InT019366
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 22:35:19 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We would like to get notified when we are doing a write on mmap
section.  The changes are needed to handle ENOSPC when writing to an
mmap section of files with holes.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext2/ext2.h  |    1 +
 fs/ext2/file.c  |   21 ++++++++++++++++++++-
 fs/ext2/inode.c |    5 +++++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 47d88da..cc2e106 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -136,6 +136,7 @@ extern void ext2_get_inode_flags(struct ext2_inode_info *);
 int __ext2_write_begin(struct file *file, struct address_space *mapping,
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata);
+extern int ext2_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
 extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 5f2fa9c..d539dcf 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -18,6 +18,7 @@
  * 	(jj@sunsite.ms.mff.cuni.cz)
  */
 
+#include <linux/mm.h>
 #include <linux/time.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -38,6 +39,24 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+static struct vm_operations_struct ext2_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite   = ext2_page_mkwrite,
+};
+
+static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext2_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the ext2 filesystem.
@@ -52,7 +71,7 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext2_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_sync_file,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 384fc0d..d4c5c23 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1443,3 +1443,8 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 		error = ext2_acl_chmod(inode);
 	return error;
 }
+
+int ext2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	return block_page_mkwrite(vma, page, ext2_get_block);
+}
-- 
1.5.5.1.357.g1af8b.dirty

