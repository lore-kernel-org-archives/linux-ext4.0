From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] fs: Create __block_page_mkwrite() helper passing error values back
Date: Wed, 11 May 2011 00:29:32 +0200
Message-ID: <1305066574-1573-2-git-send-email-jack@suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305066574-1573-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Create __block_page_mkwrite() helper which does all what block_page_mkwrite()
does except that it passes back errors from __block_write_begin /
block_commit_write calls. This is needed for some filesystems so that they
can detect errors such as ENOSPC and try harder.

CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 |   26 ++++++++++++++++++--------
 include/linux/buffer_head.h |    2 ++
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..469c832 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2333,7 +2333,7 @@ EXPORT_SYMBOL(block_commit_write);
  * unlock the page.
  */
 int
-block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+__block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		   get_block_t get_block)
 {
 	struct page *page = vmf->page;
@@ -2361,18 +2361,28 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
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
+	else
 		ret = VM_FAULT_LOCKED;
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
+	if (unlikely(ret < 0)) {
+		if (ret == -ENOMEM)
+			return VM_FAULT_OOM;
+		/* -ENOSPC, -EIO, etc */
+		return VM_FAULT_SIGBUS;
+	}
+	return ret;
+}
 EXPORT_SYMBOL(block_page_mkwrite);
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f5df235..0b719b0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -217,6 +217,8 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
+int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+				get_block_t get_block);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
-- 
1.7.1

