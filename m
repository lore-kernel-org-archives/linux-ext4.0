From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] fs: Create __block_page_mkwrite() helper passing error values back
Date: Wed, 18 May 2011 17:18:00 +0200
Message-ID: <1305731882-8334-2-git-send-email-jack@suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305731882-8334-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Create __block_page_mkwrite() helper which does all what block_page_mkwrite()
does except that it passes back errors from __block_write_begin /
block_commit_write calls.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 |   28 +++++++++++++++-------------
 include/linux/buffer_head.h |   14 ++++++++++++++
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..9c5dd88 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2332,21 +2332,21 @@ EXPORT_SYMBOL(block_commit_write);
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
  */
-int
-block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
-		   get_block_t get_block)
+int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+			 get_block_t get_block)
 {
 	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long end;
 	loff_t size;
-	int ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
+	int ret = 0;
 
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_offset(page) > size)) {
-		/* page got truncated out from underneath us */
+		/* We overload EFAULT to mean page got truncated */
+		ret = -EFAULT;
 		unlock_page(page);
 		goto out;
 	}
@@ -2361,18 +2361,20 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
 
-	if (unlikely(ret)) {
+	if (unlikely(ret < 0))
 		unlock_page(page);
-		if (ret == -ENOMEM)
-			ret = VM_FAULT_OOM;
-		else /* -ENOSPC, -EIO, etc */
-			ret = VM_FAULT_SIGBUS;
-	} else
-		ret = VM_FAULT_LOCKED;
-
 out:
 	return ret;
 }
+EXPORT_SYMBOL(__block_page_mkwrite);
+
+int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+		   get_block_t get_block)
+{
+	int ret = __block_page_mkwrite(vma, vmf, get_block);
+
+	return block_page_mkwrite_return(ret);
+}
 EXPORT_SYMBOL(block_page_mkwrite);
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f5df235..2bf6a91 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -217,8 +217,22 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
+int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+				get_block_t get_block);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
+/* Convert errno to return value from ->page_mkwrite() call */
+static inline int block_page_mkwrite_return(int err)
+{
+	if (err == 0)
+		return VM_FAULT_LOCKED;
+	if (err == -EFAULT)
+		return VM_FAULT_NOPAGE;
+	if (err == -ENOMEM)
+		return VM_FAULT_OOM;
+	/* -ENOSPC, -EDQUOT, -EIO ... */
+	return VM_FAULT_SIGBUS;
+}
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_write_begin(struct address_space *, loff_t, unsigned, unsigned,
-- 
1.7.1

