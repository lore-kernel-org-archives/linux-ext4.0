From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] ext4: don't return VM_FAULT_SIGBUS if the page was truncated
Date: Mon, 18 Jul 2011 12:06:17 -0400
Message-ID: <1311005177-15214-1-git-send-email-josef@redhat.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab1GRQGV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jul 2011 12:06:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a page is truncated out from underneath us it is not nice to segfault.  Other
fs's just returm VM_FAULT_NOPAGE which will make userspace retry the fault.  If
you are doing O_DIRECT to the same file which you are mmap'ing you will get
segfaults because sometims O_DIRECT will invalidate the mapping pages which will
make it disappear in the middle of the fault, which on ext4 will result in a
segfault, but everybody else this works fine.  Fixing this makes the
O_DIRECT/mmap test not crash.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/inode.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1ad7d10..16d727c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5843,7 +5843,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE;
+	int err;
 	void *fsdata;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -5862,13 +5863,11 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		/* page got truncated from under us? */
 		goto out_unlock;
 	}
-	ret = 0;
 
+	ret = VM_FAULT_LOCKED;
 	wait_on_page_writeback(page);
-	if (PageMappedToDisk(page)) {
-		up_read(&inode->i_alloc_sem);
-		return VM_FAULT_LOCKED;
-	}
+	if (PageMappedToDisk(page))
+		goto out_unlock;
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -5883,10 +5882,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_unmapped)) {
-			up_read(&inode->i_alloc_sem);
-			return VM_FAULT_LOCKED;
-		}
+					ext4_bh_unmapped))
+			goto out_unlock;
 	}
 	unlock_page(page);
 	/*
@@ -5896,28 +5893,25 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * write_end call. lock_page prevent this from happening
 	 * on the same page though
 	 */
-	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
+	ret = VM_FAULT_SIGBUS;
+	err = mapping->a_ops->write_begin(file, mapping, page_offset(page),
 			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
-	if (ret < 0)
+	if (err < 0)
 		goto out_unlock;
-	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
+	err = mapping->a_ops->write_end(file, mapping, page_offset(page),
 			len, len, page, fsdata);
-	if (ret < 0)
+	if (err < 0)
 		goto out_unlock;
-	ret = 0;
 
 	/*
 	 * write_begin/end might have created a dirty page and someone
 	 * could wander in and start the IO.  Make sure that hasn't
 	 * happened.
 	 */
+	ret = VM_FAULT_LOCKED;
 	lock_page(page);
 	wait_on_page_writeback(page);
-	up_read(&inode->i_alloc_sem);
-	return VM_FAULT_LOCKED;
 out_unlock:
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
 	up_read(&inode->i_alloc_sem);
 	return ret;
 }
-- 
1.7.5.2

