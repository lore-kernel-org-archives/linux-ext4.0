From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Fri, 22 Apr 2011 15:58:39 +0900
Message-ID: <20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
References: <4D946DAB.3010107@jp.fujitsu.com>
	<4D9AEE28.4000003@jp.fujitsu.com>
	<20110405225428.GD8531@quack.suse.cz>
	<4D9BF57A.6030705@jp.fujitsu.com>
	<20110406055708.GB23285@quack.suse.cz>
	<4D9C18DF.90803@jp.fujitsu.com>
	<20110406174617.GC28689@quack.suse.cz>
	<4DA84A7B.3040403@jp.fujitsu.com>
	<20110415171310.GB5432@quack.suse.cz>
	<4DABFEBD.7030102@jp.fujitsu.com>
	<20110418105105.GB5557@quack.suse.cz>
	<4DAD5934.1030901@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com, toshi.okajima@jp.fujitsu.com
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DAD5934.1030901@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Tue, 19 Apr 2011 18:43:16 +0900
Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> Hi,
> 
> (2011/04/18 19:51), Jan Kara wrote:
> > On Mon 18-04-11 18:05:01, Toshiyuki Okajima wrote:
> >>> On Fri 15-04-11 22:39:07, Toshiyuki Okajima wrote:
> >>>>>    For ext3 or ext4 without delayed allocation we block inside writepage()
> >>>>> function. But as I wrote to Dave Chinner, ->page_mkwrite() should probably
> >>>>> get modified to block while minor-faulting the page on frozen fs because
> >>>>> when blocks are already allocated we may skip starting a transaction and so
> >>>>> we could possibly modify the filesystem.
> >>>> OK. I think ->page_mkwrite() should also block writing the minor-faulting pages.
> >>>>
> >>>> (minor-pagefault)
> >>>> ->   do_wp_page()
> >>>>     ->   page_mkwrite(= ext4_mkwrite())
> >>>>        =>   BLOCK!
> >>>>
> >>>> (major-pagefault)
> >>>> ->   do_liner_fault()
> >>>>     ->   page_mkwrite(= ext4_mkwrite())
> >>>>        =>   BLOCK!
> >>>>
> >>>>>
> >>>>>>>> Mizuma-san's reproducer also writes the data which maps to the file (mmap).
> >>>>>>>> The original problem happens after the fsfreeze operation is done.
> >>>>>>>> I understand the normal write operation (not mmap) can be blocked while
> >>>>>>>> fsfreezing. So, I guess we don't always block all the write operation
> >>>>>>>> while fsfreezing.
> >>>>>>>    Technically speaking, we block all the transaction starts which means we
> >>>>>>> end up blocking all the writes from going to disk. But that does not mean
> >>>>>>> we block all the writes from going to in-memory cache - as you properly
> >>>>>>> note the mmap case is one of such exceptions.
> >>>>>> Hm, I also think we can allow the writes to in-memory cache but we can't allow
> >>>>>> the writes to disk while fsfreezing. I am considering that mmap path can
> >>>>>> write to disk while fsfreezing because this deadlock problem happens after
> >>>>>> fsfreeze operation is done...
> >>>>>    I'm sorry I don't understand now - are you speaking about the case above
> >>>>> when writepage() does not wait for filesystem being frozen or something
> >>>>> else?
> >>>> Sorry, I didn't understand around the page fault path.
> >>>> So, I had read the kernel source code around it, then I maybe understand...
> >>>>
> >>>> I worry whether we can update the file data in mmap case while fsfreezing.
> >>>> Of course, I understand that we can write to in-memory cache, and it is not a
> >>>> problem. However, if we can write to disk while fsfreezing, it is a problem.
> >>>> So, I summarize the cases whether we can write to disk or not.
> >>>>
> >>>> --------------------------------------------------------------------------
> >>>> Cases (Whether we can write the data mmapped to the file on the disk
> >>>> while fsfreezing)
> >>>>
> >>>> [1] One of the page which has been mmapped is not bound. And
> >>>>   the page is not allocated yet. (major fault?)
> >>>>
> >>>>     (1) user dirtys a page
> >>>>     (2) a page fault occurs (do_page_fault)
> >>>>     (3) __do_falut is called.
> >>>>     (4) ext4_page_mkwrite is called
> >>>>     (5) ext4_write_begin is called
> >>>>     (6) ext4_journal_start_sb       =>   We can STOP!
> >>>>
> >>>> [2] One of the page which has been mmapped is not bound. But
> >>>>   the page is already allocated, and the buffer_heads of the page
> >>>>   are not mapped (BH_Mapped).  (minor fault?)
> >>>>
> >>>>     (1) user dirtys a page
> >>>>     (2) a page fault occurs (do_page_fault)
> >>>>     (3) do_wp_page is called.
> >>>>     (4) ext4_page_mkwrite is called
> >>>>     (5) ext4_write_begin is called
> >>>>     (6) ext4_journal_start_sb       =>   We can STOP!
> >>>>
> >>>> [3] One of the page which has been mmapped is not bound. But
> >>>>   the page is already allocated, and the buffer_heads of the page
> >>>>   are mapped (BH_Mapped).  (minor fault?)
> >>>>
> >>>>     (1) user dirtys a page
> >>>>     (2) a page fault occurs (do_page_fault)
> >>>>     (3) do_wp_page is called.
> >>>>     (4) ext4_page_mkwrite is called
> >>>>     * Cannot block the dirty page to be written because all bh is mapped.
> >>>>     (5) user munmaps the page (munmap)
> >>>>     (6) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
> >>>>     (7) writeback thread writes the page (struct page) to disk
> >>>>                                             =>   We cannot STOP!
> >>>>
> >>>> [4] One of the page which has been mmapped is bound. And
> >>>>   the page is already allocated.
> >>>>
> >>>>     (1) user dirtys a page
> >>>>     ( ) no page fault occurs
> >>>>     (2) user munmaps the page (munmap)
> >>>>     (3) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
> >>>>     (4) writeback thread writes the page (struct page) to disk
> >>>>                                             =>   We cannot STOP!
> >>>> --------------------------------------------------------------------------
> >>>>
> >>>> So, we can block the cases [1], [2].
> >>>> But I think we cannot block the cases [3], [4] now.
> >>>> If fixing the page_mkwrite, we can also block the case [3].
> >>>> But the case [4] is not blocked because no page fault occurs
> >>>> when we dirty the mmapped page.
> >>>>
> >>>> Therefore, to repair this problem, we need to fix the cases [3], [4].
> >>>> I think we must modify the writeback thread to fix the case [4].
> >>>    The trick here is that when we write a page to disk, we write-protect
> >>> the page (you seem to call this that "the page is bound", I'm not sure why).
> >> Hm, I want to understand how to write-protect the page under fsfreezing.
> >    Look at what page_mkclean() called from clear_page_dirty_for_io() does...
> Thanks. I'll read that.
> 
> >
> >> But, anyway, I understand we don't need to consider the case [4].
> >    Yes.
> >
> >>> So we are guaranteed to receive a minor fault (case [3]) if user tries to
> >>> modify a page after we finish writeback while freezing the filesystem.
> >>> So principially all we need to do is just wait in ext4_page_mkwrite().
> >> OK. I understand.
> >> Are there any concrete ideas to fix this?
> >> For ext4, we can rescue from the case [3] by modifying ext4_page_mkwrite().
> >    Yes.
> >
> >> But for ext3 or other FSs, we must implement ->page_mkwrite() to prevent it?
> >    Sadly I don't see a simple way to fix this issue for all filesystems at
> > once. Implementing proper wait in block_page_mkwrite() should fix the issue
> > for xfs. Other filesystems like GFS2 or Btrfs will have to be fixed
> > separately as ext4. For ext3, we'd have to add ->page_mkwrite() support. I
> > have patches for this already for some time but I have to get to properly
> > testing them in more exotic conditions like 64k pages...
> OK. I understand the current status of your works to fix the problem which
> can be written with some data at mmap path while fsfreezing.
I have confirmed that the following patch works fine while my or
Mizuma-san's reproducer is running. Therefore,
 we can block to write the data, which is mmapped to a file, into a disk
by a page-fault while fsfreezing. 

I think this patch fixes the following two problems:
- A deadlock occurs between ext4_da_writepages() (called from
writeback_inodes_wb) and thaw_super(). (reported by Mizuma-san)
- We can also write the data, which is mmapped to a file,
  into a disk while fsfreezing (ext3/ext4).
                                       (reported by me)

Please examine this patch.

Thanks,
Toshiyuki Okajima
---
 fs/ext3/file.c          |   19 ++++++++++++-
 fs/ext3/inode.c         |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c         |    4 ++-
 include/linux/ext3_fs.h |    1 +
 4 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index f55df0e..6d376ef 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -52,6 +52,23 @@ static int ext3_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+static const struct vm_operations_struct ext3_file_vm_ops = {
+	.fault          = filemap_fault,
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
@@ -62,7 +79,7 @@ const struct file_operations ext3_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext3_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 68b2e43..66c31dd 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3496,3 +3496,74 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+	loff_t size;
+	unsigned long len;
+	int ret = -EINVAL;
+	void *fsdata;
+	struct file *file = vma->vm_file;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+
+	/*
+	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
+	 * get i_mutex because we are already holding mmap_sem.
+	 */
+	down_read(&inode->i_alloc_sem);
+	size = i_size_read(inode);
+	if (page->mapping != mapping || size <= page_offset(page)
+	   || !PageUptodate(page)) {
+		/* page got truncated from under us? */
+		goto out_unlock;
+	}
+	ret = 0;
+	if (PageMappedToDisk(page))
+		goto out_frozen;
+
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+
+	lock_page(page);
+	/*
+	 * return if we have all the buffers mapped. This avoid
+	 * the need to call write_begin/write_end which does a
+	 * journal_start/journal_stop which can block and take
+	 * long time
+	 */
+	if (page_has_buffers(page)) {
+		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+					buffer_unmapped)) {
+			unlock_page(page);
+out_frozen:
+			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+			goto out_unlock;
+		}
+	}
+	unlock_page(page);
+	/*
+	 * OK, we need to fill the hole... Do write_begin write_end
+	 * to do block allocation/reservation.We are not holding
+	 * inode.i__mutex here. That allow * parallel write_begin,
+	 * write_end call. lock_page prevent this from happening
+	 * on the same page though
+	 */
+	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
+			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+	if (ret < 0)
+		goto out_unlock;
+	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
+			len, len, page, fsdata);
+	if (ret < 0)
+		goto out_unlock;
+	ret = 0;
+out_unlock:
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
+	up_read(&inode->i_alloc_sem);
+	return ret;
+}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..44979ae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5812,7 +5812,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 	ret = 0;
 	if (PageMappedToDisk(page))
-		goto out_unlock;
+		goto out_frozen;
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -5830,6 +5830,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
 			unlock_page(page);
+out_frozen:
+			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 			goto out_unlock;
 		}
 	}
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 85c1d30..a0e39ca 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -919,6 +919,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 /* ioctl.c */
 extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
-- 
1.5.5.6
