From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] vfs: Block mmapped writes while the fs is frozen
Date: Wed, 18 May 2011 17:18:01 +0200
Message-ID: <1305731882-8334-3-git-send-email-jack@suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180Ab1ERPTF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 11:19:05 -0400
In-Reply-To: <1305731882-8334-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should not allow file modification via mmap while the filesystem is
frozen. So block in block_page_mkwrite() while the filesystem is frozen.
We cannot do the blocking wait in __block_page_mkwrite() since e.g. ext4
will want to call that function with transaction started in some cases
and that would deadlock. But we can at least do the non-blocking reliable
check in __block_page_mkwrite() which is the hardest part anyway.

We have to check for frozen filesystem with the page marked dirty and under
page lock with which we then return from ->page_mkwrite(). Only that way we
cannot race with writeback done by freezing code - either we mark the page
dirty after the writeback has started, see freezing in progress and block, or
writeback will wait for our page lock which is released only when the fault is
done and then writeback will writeout and writeprotect the page again.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 |   28 +++++++++++++++++++++++++++-
 include/linux/buffer_head.h |    2 ++
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9c5dd88..030f808 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2331,6 +2331,9 @@ EXPORT_SYMBOL(block_commit_write);
  * page lock we can determine safely if the page is beyond EOF. If it is not
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
+ *
+ * Direct callers of this function should call vfs_check_frozen() so that page
+ * fault does not busyloop until the fs is thawed.
  */
 int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 get_block_t get_block)
@@ -2363,6 +2366,22 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	if (unlikely(ret < 0))
 		unlock_page(page);
+	else {
+		/*
+		 * Freezing in progress? We check after the page is marked
+		 * dirty and with page lock held so if the test here fails, we
+		 * are sure freezing code will wait during syncing until the
+		 * page fault is done - at that point page will be dirty and
+		 * unlocked so freezing code will write it and writeprotect it
+		 * again.
+		 */
+		set_page_dirty(page);
+		if (inode->i_sb->s_frozen != SB_UNFROZEN) {
+			unlock_page(page);
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
 out:
 	return ret;
 }
@@ -2371,8 +2390,15 @@ EXPORT_SYMBOL(__block_page_mkwrite);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		   get_block_t get_block)
 {
-	int ret = __block_page_mkwrite(vma, vmf, get_block);
+	int ret;
+	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
 
+	/*
+	 * This check is racy but catches the common case. The check in
+	 * __block_page_mkwrite() is reliable.
+	 */
+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	ret = __block_page_mkwrite(vma, vmf, get_block);
 	return block_page_mkwrite_return(ret);
 }
 EXPORT_SYMBOL(block_page_mkwrite);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 2bf6a91..503c8a6 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -230,6 +230,8 @@ static inline int block_page_mkwrite_return(int err)
 		return VM_FAULT_NOPAGE;
 	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
+	if (err == -EAGAIN)
+		return VM_FAULT_RETRY;
 	/* -ENOSPC, -EDQUOT, -EIO ... */
 	return VM_FAULT_SIGBUS;
 }
-- 
1.7.1

