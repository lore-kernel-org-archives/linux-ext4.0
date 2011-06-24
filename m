From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/9] ext4: Rewrite ext4_page_mkwrite() to use generic helpers
Date: Fri, 24 Jun 2011 14:29:41 -0400
Message-ID: <20110624183207.141170484@bombadil.infradead.org>
References: <20110624182939.401012221@bombadil.infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org, Jan Kara <jack@suse.cz>
To: viro@zeniv.linux.org.uk, tglx@linutronix.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56819
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab1FXScO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 14:32:14 -0400
Content-Disposition: inline; filename=ext4-rewrite-page_mkwrite
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From:	Jan Kara <jack@suse.cz>

Rewrite ext4_page_mkwrite() to use __block_page_mkwrite() helper. This
removes the need of using i_alloc_sem to avoid races with truncate which
seems to be the wrong locking order according to lock ordering documented in
mm/rmap.c. Also calling ext4_da_write_begin() as used by the old code seems to
be problematic because we can decide to flush delay-allocated blocks which
will acquire s_umount semaphore - again creating unpleasant lock dependency
if not directly a deadlock.

Also add a check for frozen filesystem so that we don't busyloop in page fault
when the filesystem is frozen.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |  106 ++++++++++++++++++++++++++++--------------------------
 1 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3126c0..bd30976 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5843,80 +5843,84 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
-	int ret = -EINVAL;
-	void *fsdata;
+	int ret;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
+	handle_t *handle;
+	get_block_t *get_block;
+	int retries = 0;
 
 	/*
-	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
-	 * get i_mutex because we are already holding mmap_sem.
+	 * This check is racy but catches the common case. We rely on
+	 * __block_page_mkwrite() to do a reliable check.
 	 */
-	down_read(&inode->i_alloc_sem);
-	size = i_size_read(inode);
-	if (page->mapping != mapping || size <= page_offset(page)
-	    || !PageUptodate(page)) {
-		/* page got truncated from under us? */
-		goto out_unlock;
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	/* Delalloc case is easy... */
+	if (test_opt(inode->i_sb, DELALLOC) &&
+	    !ext4_should_journal_data(inode) &&
+	    !ext4_nonda_switch(inode->i_sb)) {
+		do {
+			ret = __block_page_mkwrite(vma, vmf,
+						   ext4_da_get_block_prep);
+		} while (ret == -ENOSPC &&
+		       ext4_should_retry_alloc(inode->i_sb, &retries));
+		goto out_ret;
 	}
-	ret = 0;
 
 	lock_page(page);
-	wait_on_page_writeback(page);
-	if (PageMappedToDisk(page)) {
-		up_read(&inode->i_alloc_sem);
-		return VM_FAULT_LOCKED;
+	size = i_size_read(inode);
+	/* Page got truncated from under us? */
+	if (page->mapping != mapping || page_offset(page) > size) {
+		unlock_page(page);
+		ret = VM_FAULT_NOPAGE;
+		goto out;
 	}
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
-
 	/*
-	 * return if we have all the buffers mapped. This avoid
-	 * the need to call write_begin/write_end which does a
-	 * journal_start/journal_stop which can block and take
-	 * long time
+	 * Return if we have all the buffers mapped. This avoids the need to do
+	 * journal_start/journal_stop which can block and take a long time
 	 */
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
-			up_read(&inode->i_alloc_sem);
-			return VM_FAULT_LOCKED;
+			/* Wait so that we don't change page under IO */
+			wait_on_page_writeback(page);
+			ret = VM_FAULT_LOCKED;
+			goto out;
 		}
 	}
 	unlock_page(page);
-	/*
-	 * OK, we need to fill the hole... Do write_begin write_end
-	 * to do block allocation/reservation.We are not holding
-	 * inode.i__mutex here. That allow * parallel write_begin,
-	 * write_end call. lock_page prevent this from happening
-	 * on the same page though
-	 */
-	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
-			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
-	if (ret < 0)
-		goto out_unlock;
-	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
-			len, len, page, fsdata);
-	if (ret < 0)
-		goto out_unlock;
-	ret = 0;
-
-	/*
-	 * write_begin/end might have created a dirty page and someone
-	 * could wander in and start the IO.  Make sure that hasn't
-	 * happened.
-	 */
-	lock_page(page);
-	wait_on_page_writeback(page);
-	up_read(&inode->i_alloc_sem);
-	return VM_FAULT_LOCKED;
-out_unlock:
-	if (ret)
+	/* OK, we need to fill the hole... */
+	if (ext4_should_dioread_nolock(inode))
+		get_block = ext4_get_block_write;
+	else
+		get_block = ext4_get_block;
+retry_alloc:
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
 		ret = VM_FAULT_SIGBUS;
-	up_read(&inode->i_alloc_sem);
+		goto out;
+	}
+	ret = __block_page_mkwrite(vma, vmf, get_block);
+	if (!ret && ext4_should_journal_data(inode)) {
+		if (walk_page_buffers(handle, page_buffers(page), 0,
+			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
+			unlock_page(page);
+			ret = VM_FAULT_SIGBUS;
+			goto out;
+		}
+		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
+	}
+	ext4_journal_stop(handle);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry_alloc;
+out_ret:
+	ret = block_page_mkwrite_return(ret);
+out:
 	return ret;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


