From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH] Inverse locking order of page_lock and transaction start
Date: Fri, 4 Apr 2008 13:03:19 +0200
Message-ID: <20080404110319.GD477@atrey.karlin.mff.cuni.cz>
References: <20080327162742.GC32534@duck.suse.cz> <20080403164920.GA7960@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37994 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYDDLDU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 07:03:20 -0400
Content-Disposition: inline
In-Reply-To: <20080403164920.GA7960@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

> On Thu, Mar 27, 2008 at 05:27:42PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> >   below is the first version of the patch that reverses locking order of
> > page_lock and transaction start. I have tested it with fsx-linux, ltp DIO
> > tests etc. and lockdep didn't complain so hopefully I got it mostly right
> > but review is definitely needed. Especially I'd like to know what people
> > think about the way I've implemented ext3_page_mkwrite() - ext4 has
> > an incorrect code AFAICT because in ordered and journaled modes we should
> > write block of zeros and properly journal it (and no, block_page_mkwrite()
> > doesn't do it). We could implement ext3/4_page_mkwrite() in a similar way
> > we currently implement writepage calls but calling write_begin + write_end
> > does the job and should be only a tiny bit slower...
> >   If nobody finds a serious flaw in the approach, I'll rediff the patch
> > against ext4 (I'll also try to convert delayed-alloc path - from a quick
> > look converting da_writepages path is going to be interesting).
> >   I'm looking forward to your comments :)
> > 
> > 								Honza
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > 
> > ---
> > 
> > Reverse locking order of page lock and transaction start in ext3  (i.e., page
> > lock now comes after the transaction start). Needed changes are:
> >   1) Simply swap the order in ext3_write_begin() and ext3_..._write_end()
> >      (allows removal of ext3_generic_write_end())
> >   2) Implement ext3_page_mkwrite() to fill holes.
> >   3) Change ext3_writeback_writepage() not to start a transaction at all,
> >      ext3_ordered_writepage() starts a transaction only after unlocking
> >      the page in block_write_full_page() (to attach buffers to the transaction),
> >      ext3_journaled_writepage() gets references to buffers in the page, unlocks
> >      the page and then starts a transaction.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > ---
> >  fs/ext3/file.c          |   19 ++++-
> >  fs/ext3/inode.c         |  236 +++++++++++++++++++++++++----------------------
> >  include/linux/ext3_fs.h |    1 +
> >  3 files changed, 145 insertions(+), 111 deletions(-)
> > 
> 
> ....
> 
> > +
> > +static int ext3_bh_mapped(handle_t *handle, struct buffer_head *bh)
> > +{
> > +	return !buffer_mapped(bh);
> > +}
> > +
> > +int ext3_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> > +{
> > +	struct file *file = vma->vm_file;
> > +	struct inode *inode = file->f_path.dentry->d_inode;
> > +	struct address_space *mapping = inode->i_mapping;
> > +	unsigned long len;
> > +	loff_t size;
> > +	int ret = -EINVAL;
> > +
> > +	/*
> > +	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
> > +	 * get i_mutex because we are already holding mmap_sem. This makes
> > +	 * it possible for write_begin and write_end to run concurrently
> > +	 * on a single file (not on a single page because of page_lock).
> > +	 * We seem to handle this just fine...
> > +	 */
> > +	down_read(&inode->i_alloc_sem);
> > +	size = i_size_read(inode);
> > +	if (page->mapping != mapping || size <= page_offset(page)
> > +	    || !PageUptodate(page)) {
> > +		/* page got truncated from under us? */
> > +		goto out_unlock;
> > +	}
> > +	ret = 0;
> > +	if (PageMappedToDisk(page))
> > +		goto out_unlock;
> > +
> > +	if (page->index == size >> PAGE_CACHE_SHIFT)
> > +		len = size & ~PAGE_CACHE_MASK;
> > +	else
> > +		len = PAGE_CACHE_SIZE;
> > +
> > +	if (page_has_buffers(page)) {
> > +		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> > +				       ext3_bh_mapped))
> > +			goto out_unlock;
> > +	}
> > +
> > +	/* OK, we need to fill the hole... We simply write the page. */
> > +	printk(KERN_INFO "Writing page %lu of ino %lu\n", page->index, inode->i_ino);
> > +	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
> > +		len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
> > +	if (ret < 0)
> > +		goto out_unlock;
> > +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page), len,
> > +		len, page, NULL);
> > +	if (ret < 0)
> > +		goto out_unlock;
> > +	ret = 0;
> > +out_unlock:
> > +	up_read(&inode->i_alloc_sem);
> > +	return ret;
> > +}
> > diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> > index 36c5403..715c35e 100644
> > --- a/include/linux/ext3_fs.h
> > +++ b/include/linux/ext3_fs.h
> > @@ -836,6 +836,7 @@ extern void ext3_truncate (struct inode *);
> >  extern void ext3_set_inode_flags(struct inode *);
> >  extern void ext3_get_inode_flags(struct ext3_inode_info *);
> >  extern void ext3_set_aops(struct inode *inode);
> > +extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct page *page);
> > 
> >  /* ioctl.c */
> >  extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
> 
> The comments on block_page_mkwrite says taking a lock on page protect it
> against truncate. Why do we need to take i_alloc_sem ? Is it because
> after changing the locking order we can't any more take the page lock
> here because we need to take it after the transaction is started ?
  Well, there are few things which lead to the locking I do:
1) We need to issue data write - actually comments in
http://article.gmane.org/gmane.comp.file-systems.ext4/5201 are partly
incorrect. For ordered and journal data mode we must write zeros to the
file if we fill in holes (which is what should be in the page) -
otherwise if we crash before the writepage call (which can go to the
next transaction), we would see uninitialized data in the file.
2) I didn't want to reimplement writepage calls for writeback, ordered
and journal so I've used write_begin and write_end calls. These calls
take page_lock themselves so we cannot take it in page_mkwrite().
3) We need to be protected against truncate (normally, i_mutex does this
but we cannot take it in page_mkwrite() due to lock ordering issues). So
we use i_alloc_sem for this.

  But looking at the code with a fresh look (it's always good to look at
the code a week after you've written it whether you still like it ;),
I think I could try to move writepage() code into helper functions
and use these functions from writepage() and page_mkwrite(). That
wouldn't have problems with code duplication and the result would be
hopefully nicer than it is now.

> My patch to use page_mkwrite on ext3 resulted in this discussion.
> http://article.gmane.org/gmane.comp.file-systems.ext4/5731
  Thanks for the pointer.

> Does the above means that it will call page_mkwrite with page lock held.
> That would imply that we can't start transaction inside page_mkwrite
  We could always unlock the page and then lock it again. But other
journaling filesystems (e.g. OCFS2) also need to start a transaction in
page_mkwrite so I'm not sure the change Nick suggests will ever happen.

> Why do you think that current Ext4 code page_mkwrite is wrong ?
> We just need to reserve space for the page we are dirtying right.
  Well, that gets rid of the ENOSPC problem but as I explain above, you
also need to write zeros to the file in can you allocate a new block.

> I have tried a similar change and later dropped it because we didn't
> had much anything to journal 
> http://article.gmane.org/gmane.comp.file-systems.ext4/5201
> This had the inode_lock taken which lockdep complained about.
> 
> ext4_get_blocks create a journal handle for all meta update if we don't
> have one.
  Yes, but when we reverse the lock ordering of page_lock and
transaction start, we have to start a transaction before we take the
page_lock... So ext4_get_blocks() is too late to start a transaction at
least for page_mkwrite().

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
