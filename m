From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Tue, 3 May 2011 17:19:48 +0200
Message-ID: <20110503151948.GB6009@quack.suse.cz>
References: <4D9AEE28.4000003@jp.fujitsu.com>
 <20110405225428.GD8531@quack.suse.cz>
 <4D9BF57A.6030705@jp.fujitsu.com>
 <20110406055708.GB23285@quack.suse.cz>
 <4D9C18DF.90803@jp.fujitsu.com>
 <20110406174617.GC28689@quack.suse.cz>
 <4DA84A7B.3040403@jp.fujitsu.com>
 <20110415171310.GB5432@quack.suse.cz>
 <4DABFEBD.7030102@jp.fujitsu.com>
 <4DBFE09E.5070805@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51983 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1ECPTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 11:19:51 -0400
Content-Disposition: inline
In-Reply-To: <4DBFE09E.5070805@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 03-05-11 14:01:50, Surbhi Palande wrote:
> On 04/18/2011 12:05 PM, Toshiyuki Okajima wrote:
> >(2011/04/16 2:13), Jan Kara wrote:
> >>Hello,
> >>
> >>On Fri 15-04-11 22:39:07, Toshiyuki Okajima wrote:
> >>>>For ext3 or ext4 without delayed allocation we block inside writepage()
> >>>>function. But as I wrote to Dave Chinner, ->page_mkwrite() should
> >>>>probably
> >>>>get modified to block while minor-faulting the page on frozen fs
> >>>>because
> >>>>when blocks are already allocated we may skip starting a transaction
> >>>>and so
> >>>>we could possibly modify the filesystem.
> >>>OK. I think ->page_mkwrite() should also block writing the
> >>>minor-faulting pages.
> >>>
> >>>(minor-pagefault)
> >>>-> do_wp_page()
> >>>-> page_mkwrite(= ext4_mkwrite())
> >>>=> BLOCK!
> >>>
> >>>(major-pagefault)
> >>>-> do_liner_fault()
> >>>-> page_mkwrite(= ext4_mkwrite())
> >>>=> BLOCK!
> >>>
> >>>>
> >>>>>>>Mizuma-san's reproducer also writes the data which maps to the
> >>>>>>>file (mmap).
> >>>>>>>The original problem happens after the fsfreeze operation is done.
> >>>>>>>I understand the normal write operation (not mmap) can be blocked
> >>>>>>>while
> >>>>>>>fsfreezing. So, I guess we don't always block all the write
> >>>>>>>operation
> >>>>>>>while fsfreezing.
> >>>>>>Technically speaking, we block all the transaction starts which
> >>>>>>means we
> >>>>>>end up blocking all the writes from going to disk. But that does
> >>>>>>not mean
> >>>>>>we block all the writes from going to in-memory cache - as you
> >>>>>>properly
> >>>>>>note the mmap case is one of such exceptions.
> >>>>>Hm, I also think we can allow the writes to in-memory cache but we
> >>>>>can't allow
> >>>>>the writes to disk while fsfreezing. I am considering that mmap
> >>>>>path can
> >>>>>write to disk while fsfreezing because this deadlock problem
> >>>>>happens after
> >>>>>fsfreeze operation is done...
> >>>>I'm sorry I don't understand now - are you speaking about the case
> >>>>above
> >>>>when writepage() does not wait for filesystem being frozen or something
> >>>>else?
> >>>Sorry, I didn't understand around the page fault path.
> >>>So, I had read the kernel source code around it, then I maybe
> >>>understand...
> >>>
> >>>I worry whether we can update the file data in mmap case while
> >>>fsfreezing.
> >>>Of course, I understand that we can write to in-memory cache, and it
> >>>is not a
> >>>problem. However, if we can write to disk while fsfreezing, it is a
> >>>problem.
> >>>So, I summarize the cases whether we can write to disk or not.
> >>>
> >>>--------------------------------------------------------------------------
> >>>
> >>>Cases (Whether we can write the data mmapped to the file on the disk
> >>>while fsfreezing)
> >>>
> >>>[1] One of the page which has been mmapped is not bound. And
> >>>the page is not allocated yet. (major fault?)
> >>>
> >>>(1) user dirtys a page
> >>>(2) a page fault occurs (do_page_fault)
> >>>(3) __do_falut is called.
> >>>(4) ext4_page_mkwrite is called
> >>>(5) ext4_write_begin is called
> >>>(6) ext4_journal_start_sb => We can STOP!
> >>>
> >>>[2] One of the page which has been mmapped is not bound. But
> >>>the page is already allocated, and the buffer_heads of the page
> >>>are not mapped (BH_Mapped). (minor fault?)
> >>>
> >>>(1) user dirtys a page
> >>>(2) a page fault occurs (do_page_fault)
> >>>(3) do_wp_page is called.
> >>>(4) ext4_page_mkwrite is called
> >>>(5) ext4_write_begin is called
> >>>(6) ext4_journal_start_sb => We can STOP!
> 
> What happens in the case as follows:
> 
> Task 1: Mmapped writes
> t1)ext4_page_mkwrite()
>   t2) ext4_write_begin() (FS is thawed so we proceed)
>   t3) ext4_write_end() (journal is stopped now)
> -----Pre-empted-----
> 
> 
> Task 2: Freeze Task
> t4) freezes the super block...
> ...(continues)....
> tn) the page cache is clean and the F.S is frozen. Freeze has
> completed execution.
> 
> Task 1: Mmapped writes
> tn+1) ext4_page_mkwrite() returns 0.
> tn+2) __do_fault() gets control, code gets executed.
> tn+3) _do_fault() marks the page dirty if the intent is to write to
> a file based page which faulted.
> 
> So you end up dirtying the page cache when the F.S is frozen? No?
  You are right ext4_page_mkrite() as currently implemented has problems.
You have to return the page locked (and check for frozen fs with page lock
held) to avoid races.

If you check for frozen fs with page lock held, you are guaranteed that
freezing code must wait for the page to get unlocked before proceeding. And
before the page is unlocked, it is marked dirty by the pagefault code which
makes freezing code write the page and writeprotect it again. So everything
will be safe.

Doing this cleanly requires some cleanups to ext4_page_mkwrite() (but
stable pages during writeback need that as well so it's a reasonable thing
to do). So something like attached patches should do what's needed - it's
lightly tested with fsx in delalloc, nodelalloc, and data=journal configs.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--dDRMvlgZJXvWKvBx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-fs-Create-__block_page_mkwrite-helper-passing-error-.patch"

>From dc11ee148c44dda41c0c2315bdaf26b86f34b201 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 26 Apr 2011 21:12:53 +0200
Subject: [PATCH 1/3] fs: Create __block_page_mkwrite() helper passing error values back

Create __block_page_mkwrite() helper which does all what block_page_mkwrite()
does except that it passes back errors from __block_write_begin /
block_commit_write calls.

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


--dDRMvlgZJXvWKvBx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext4-Rewrite-ext4_page_mkwrite-to-return-locked-page.patch"

>From 6c333a1a5a577672f4ea0114e0fc430531097788 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 26 Apr 2011 20:48:13 +0200
Subject: [PATCH 2/3] ext4: Rewrite ext4_page_mkwrite() to return locked page

ext4_page_mkwrite() does not return page locked. This makes it hard
to avoid races with filesystem freezing code (so that we don't leave
writeable page on a frozen fs) or writeback code (so that we allow page
to be stable during writeback).

Also the current code uses i_alloc_sem to avoid races with truncate but that
seems to be the wrong locking order according to lock ordering documented in
mm/rmap.c.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |  101 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..377fed0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5788,40 +5788,53 @@ static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
 	return !buffer_mapped(bh);
 }
 
+static int ext4_journalled_fault_fn(handle_t *handle, struct buffer_head *bh)
+{
+	if (!buffer_dirty(bh))
+		return 0;
+	return ext4_handle_dirty_metadata(handle, NULL, bh);
+}
+
 int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
-	int ret = -EINVAL;
-	void *fsdata;
+	int ret;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
+	handle_t handle;
+	get_block_t get_block;
+	int retries = 0;
 
-	/*
-	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
-	 * get i_mutex because we are already holding mmap_sem.
-	 */
-	down_read(&inode->i_alloc_sem);
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
+	}
+
+	lock_page(page);
 	size = i_size_read(inode);
-	if (page->mapping != mapping || size <= page_offset(page)
-	    || !PageUptodate(page)) {
-		/* page got truncated from under us? */
-		goto out_unlock;
+	/* Page got truncated from under us? */
+	if (page->mapping != mapping || page_offset(page) > size) {
+		unlock_page(page);
+ 		ret = VM_FAULT_NOPAGE;
+		goto out;
 	}
-	ret = 0;
-	if (PageMappedToDisk(page))
-		goto out_unlock;
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
-
-	lock_page(page);
 	/*
-	 * return if we have all the buffers mapped. This avoid
+	 * Return if we have all the buffers mapped. This avoid
 	 * the need to call write_begin/write_end which does a
 	 * journal_start/journal_stop which can block and take
 	 * long time
@@ -5829,30 +5842,42 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
-			unlock_page(page);
-			goto out_unlock;
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
-out_unlock:
-	if (ret)
+	/* OK, we need to fill the hole... */
+	if (ext4_should_dioread_nolock(inode))
+		get_block = ext4_get_block_write;
+	else
+		get_block = ext4_get_block;
+retry:
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
 		ret = VM_FAULT_SIGBUS;
-	up_read(&inode->i_alloc_sem);
+		goto out;
+	}
+	ret = __block_page_mkwrite(vma, vmf, get_block);
+	if (ret == VM_FAULT_LOCKED && ext4_should_journal_data(inode)) {
+		if (walk_page_buffers(handle, page_buffers(page), 0,
+		 	  PAGE_CACHE_SIZE, NULL, ext4_journalled_fault_fn)) {
+			unlock_page(page);
+			ret = VM_FAULT_SIGBUS;
+			goto out;
+		}
+		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
+	}
+	ext4_journal_end(handle);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+out_ret:
+	if (ret < 0) {
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else
+			ret = VM_FAULT_SIGBUS;
+	}
+out:
 	return ret;
 }
-- 
1.7.1


--dDRMvlgZJXvWKvBx
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0003-ext4-Block-mmapped-writes-while-the-fs-is-frozen.patch"

>From ee1f2f8cdea23cf19b34e51b4f78e040ce898976 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 May 2011 17:00:35 +0200
Subject: [PATCH 3/3] ext4: Block mmapped writes while the fs is frozen

We should not allow file modification via mmap while the filesystem is
frozen. So block in ext4_page_mkwrite() while the filesystem is frozen.

We have to check for frozen filesystem under page lock with which we then
return from ext4_page_mkwrite(). Only that way we cannot race with writeback
done by freezing code - either we lock the page after the writeback has
started, see freezing in progress and block, or writeback will wait for our
page lock which is released only when the fault is done and then writeback
will writeout and writeprotect the page again.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 377fed0..6faadaf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5788,13 +5788,6 @@ static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
 	return !buffer_mapped(bh);
 }
 
-static int ext4_journalled_fault_fn(handle_t *handle, struct buffer_head *bh)
-{
-	if (!buffer_dirty(bh))
-		return 0;
-	return ext4_handle_dirty_metadata(handle, NULL, bh);
-}
-
 int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
@@ -5804,10 +5797,16 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
-	handle_t handle;
-	get_block_t get_block;
+	handle_t *handle;
+	get_block_t *get_block;
 	int retries = 0;
 
+restart:
+	/*
+	 * This check is racy but catches the common case. The check at the
+	 * end of this function is reliable.
+	 */
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -5834,10 +5833,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	else
 		len = PAGE_CACHE_SIZE;
 	/*
-	 * Return if we have all the buffers mapped. This avoid
-	 * the need to call write_begin/write_end which does a
-	 * journal_start/journal_stop which can block and take
-	 * long time
+	 * Return if we have all the buffers mapped. This avoids the need to do
+	 * journal_start/journal_stop which can block and take a long time
 	 */
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
@@ -5852,7 +5849,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		get_block = ext4_get_block_write;
 	else
 		get_block = ext4_get_block;
-retry:
+retry_alloc:
 	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = VM_FAULT_SIGBUS;
@@ -5861,16 +5858,16 @@ retry:
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	if (ret == VM_FAULT_LOCKED && ext4_should_journal_data(inode)) {
 		if (walk_page_buffers(handle, page_buffers(page), 0,
-		 	  PAGE_CACHE_SIZE, NULL, ext4_journalled_fault_fn)) {
+		 	  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
 			unlock_page(page);
 			ret = VM_FAULT_SIGBUS;
 			goto out;
 		}
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 	}
-	ext4_journal_end(handle);
+	ext4_journal_stop(handle);
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
+		goto retry_alloc;
 out_ret:
 	if (ret < 0) {
 		if (ret == -ENOMEM)
@@ -5879,5 +5876,15 @@ out_ret:
 			ret = VM_FAULT_SIGBUS;
 	}
 out:
+	/*
+	 * Freezing in progress? We check with page lock held so if the test
+	 * here fails, we are sure freezing code will wait until the page
+	 * fault is done - at that point page will be dirty and unlocked so
+	 * freezing code will writeprotect it again.
+	 */
+	if (ret == VM_FAULT_LOCKED && inode->i_sb->s_frozen != SB_UNFROZEN) {
+		unlock_page(page);
+		goto restart;
+	}
 	return ret;
 }
-- 
1.7.1


--dDRMvlgZJXvWKvBx--
