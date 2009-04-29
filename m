From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Wed, 29 Apr 2009 10:08:13 -0400
Message-ID: <1241014093.20099.28.camel@think.oraclecorp.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
	 <20090429085632.GA18273@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:43879 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZD2OJS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 10:09:18 -0400
In-Reply-To: <20090429085632.GA18273@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-04-29 at 10:56 +0200, Jan Kara wrote:

> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index fcfa243..1e90107 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -38,6 +38,7 @@
> >  #include <linux/bio.h>
> >  #include <linux/fiemap.h>
> >  #include <linux/namei.h>
> > +#include <linux/workqueue.h>
> >  #include "xattr.h"
> >  #include "acl.h"
> >  
> > @@ -179,6 +180,105 @@ static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
> >  }
> >  
> >  /*
> > + * after a data=guarded IO is done, we need to update the
> > + * disk i_size to reflect the data we've written.  If there are
> > + * no more ordered data extents left in the tree, we need to
>                                            ^^^^^^^^ the list
> > + * get rid of the orphan entry making sure the file's
> > + * block pointers match the i_size after a crash
> > + *
> > + * When we aren't in data=guarded mode, this just does an ext3_orphan_del.
> > + *
> > + * It returns the result of ext3_orphan_del.
> > + *
> > + * handle may be null if we are just cleaning up the orphan list in
> > + * memory.
> > + *
> > + * pass must_log == 1 when the inode must be logged in order to get
> > + * an i_size update on disk
> > + */
> > +static int ordered_orphan_del(handle_t *handle, struct inode *inode,
> > +			      int must_log)
> > +{
>   I'm afraid this function is racy.
> 1) We probably need i_mutex to protect against unlink happening in parallel
>    (after we check i_nlink but before we all ext3_orphan_del).

This would mean IO completion (clearing PG_writeback) would have to wait
on the inode mutex, which we can't quite do in O_SYNC and O_DIRECT.
But, what I can do is check i_nlink after the ext3_orphan_del call and
put the inode back on the orphan list if it has gone to zero.

> 2) We need superblock lock for the check list_empty(&EXT3_I(inode)->i_orphan).

How about I take the guarded spinlock when doing the list_add instead?
I'm trying to avoid the superblock lock as much as I can.

> 3) The function should rather have name ext3_guarded_orphan_del()... At
>   least "ordered" is really confusing (that's the case for a few other
>   structs / variables as well).

My long term plan was to replaced ordered with guarded, but I can rename
this one to guarded if you think it'll make it more clear.

> > +/*
> > + * Wrapper around ordered_orphan_del that starts a transaction
> > + */
> > +static void ordered_orphan_del_trans(struct inode *inode, int must_log)
> > +{
>   This function is going to be used only from one place, so consider
> opencoding it. I don't have a strong opinions


Yeah, I think it keeps the code a little more readable to have it
separate....gcc will inline the thing for us anyway.

> > +	 *
> > +	 * extend_disksize is only called for directories, and so
> > +	 * the are not using guarded buffer protection.
>            ^^^ The sentence is strange...

Thanks

> >  	*/
> > -	if (!err && extend_disksize && inode->i_size > ei->i_disksize)
> > -		ei->i_disksize = inode->i_size;
> > +	if (!err && extend_disksize)
> > +		maybe_update_disk_isize(inode, inode->i_size);
>   So do we really need to take the ordered lock for directories? We could
> just leave above two lines as they were.

Good point

> 
> >  	mutex_unlock(&ei->truncate_mutex);
> >  	if (err)
> >  		goto cleanup;
> >  
> >  	set_buffer_new(bh_result);
> > +	set_buffer_datanew(bh_result);
> >  got_it:
> >  	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
> >  	if (count > blocks_to_boundary)
> > @@ -1079,6 +1210,77 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * data=guarded updates are handled in a workqueue after the IO
> > + * is done.  This runs through the list of buffer heads that are pending
> > + * processing.
> > + */
> > +void ext3_run_guarded_work(struct work_struct *work)
> > +{
> > +	struct ext3_sb_info *sbi =
> > +		container_of(work, struct ext3_sb_info, guarded_work);
> > +	struct buffer_head *bh;
> > +	struct ext3_ordered_extent *ordered;
> > +	struct inode *inode;
> > +	struct page *page;
> > +	int must_log;
> > +
> > +	spin_lock_irq(&sbi->guarded_lock);
> > +	while (!list_empty(&sbi->guarded_buffers)) {
> > +		ordered = list_entry(sbi->guarded_buffers.next,
> > +				     struct ext3_ordered_extent, work_list);
> > +
> > +		list_del(&ordered->work_list);
> > +
> > +		bh = ordered->end_io_bh;
> > +		ordered->end_io_bh = NULL;
> > +		must_log = 0;
> > +
> > +		/* we don't need a reference on the buffer head because
> > +		 * it is locked until the end_io handler is called.
> > +		 *
> > +		 * This means the page can't go away, which means the
> > +		 * inode can't go away
> > +		 */
> > +		spin_unlock_irq(&sbi->guarded_lock);
> > +
> > +		page = bh->b_page;
> > +		inode = page->mapping->host;
> > +
> > +		ext3_ordered_lock(inode);
> > +		if (ordered->bh) {
> > +			/*
> > +			 * someone might have decided this buffer didn't
> > +			 * really need to be ordered and removed us from
> > +			 * the list.  They set ordered->bh to null
> > +			 * when that happens.
> > +			 */
> > +			ext3_remove_ordered_extent(inode, ordered);
> > +			must_log = ext3_ordered_update_i_size(inode);
> > +		}
> > +		ext3_ordered_unlock(inode);
> > +
> > +		/*
> > +		 * drop the reference taken when this ordered extent was
> > +		 * put onto the guarded_buffers list
> > +		 */
> > +		ext3_put_ordered_extent(ordered);
> > +
> > +		/*
> > +		 * maybe log the inode and/or cleanup the orphan entry
> > +		 */
> > +		ordered_orphan_del_trans(inode, must_log > 0);
> > +
> > +		/*
> > +		 * finally, call the real bh end_io function to do
> > +		 * all the hard work of maintaining page writeback.
> > +		 */
> > +		end_buffer_async_write(bh, buffer_uptodate(bh));
> > +		spin_lock_irq(&sbi->guarded_lock);
> > +	}
> > +	spin_unlock_irq(&sbi->guarded_lock);
> > +}
> > +
> >  static int walk_page_buffers(	handle_t *handle,
> >  				struct buffer_head *head,
> >  				unsigned from,
> > @@ -1185,6 +1387,7 @@ retry:
> >  		ret = walk_page_buffers(handle, page_buffers(page),
> >  				from, to, NULL, do_journal_get_write_access);
> >  	}
> > +
> >  write_begin_failed:
> >  	if (ret) {
> >  		/*
> > @@ -1212,7 +1415,13 @@ out:
> >  
> >  int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
> >  {
> > -	int err = journal_dirty_data(handle, bh);
> > +	int err;
> > +
> > +	/* don't take buffers from the data=guarded list */
> > +	if (buffer_dataguarded(bh))
> > +		return 0;
> > +
> > +	err = journal_dirty_data(handle, bh);
>   But this has a problem that if we do extending write (like from pos 1024
> to pos 2048) and then do write from 0 to 1024 and we hit the window while
> the buffer is on the work queue list, we won't order this write. Probably
> we don't care but I wanted to note this...

Yeah, in this case the guarded IO should protect i_size, and this write
won't really be ordered.  The block could have zeros from 0-1024 if we
crash.

> 
> >  	if (err)
> >  		ext3_journal_abort_handle(__func__, __func__,
> >  						bh, handle, err);
> > @@ -1231,6 +1440,89 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Walk the buffers in a page for data=guarded mode.  Buffers that
> > + * are not marked as datanew are ignored.
> > + *
> > + * New buffers outside i_size are sent to the data guarded code
> > + *
> > + * We must do the old data=ordered mode when filling holes in the
> > + * file, since i_size doesn't protect these at all.
> > + */
> > +static int journal_dirty_data_guarded_fn(handle_t *handle,
> > +					 struct buffer_head *bh)
> > +{
> > +	u64 offset = page_offset(bh->b_page) + bh_offset(bh);
> > +	struct inode *inode = bh->b_page->mapping->host;
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * Write could have mapped the buffer but it didn't copy the data in
> > +	 * yet. So avoid filing such buffer into a transaction.
> > +	 */
> > +	if (!buffer_mapped(bh) || !buffer_uptodate(bh))
> > +		return 0;
> > +
> > +	if (test_clear_buffer_datanew(bh)) {
>   Hmm, if we just extend the file inside the block (e.g. from 100 bytes to
> 500 bytes), then we won't do the write guarded. But then if we crash before
> the block really gets written, user will see zeros at the end of file
> instead of data... 

You see something like this:

create(file)
write(file, 100 bytes) # create guarded IO
fsync(file)
write(file, 400 more bytes) # buffer isn't guarded, i_size goes to 500


> I don't think we should let this happen so I'd think we
> have to guard all the extending writes regardless whether they allocate new
> block or not. 

My main concern was avoiding stale data from the disk after a crash,
zeros from partially written blocks are not as big a problem.  But,
you're right that we can easily avoid this, so I'll update the patch to
do all extending writes as guarded.

> Which probably makes the buffer_datanew() flag unnecessary
> because we just guard all the buffers from max(start of write, i_size) to
> end of write.

But, we still want buffer_datanew to decide when writes that fill holes
should go through data=ordered.

> > +/*
> > + * Walk the buffers in a page for data=guarded mode for writepage.
> > + *
> > + * We must do the old data=ordered mode when filling holes in the
> > + * file, since i_size doesn't protect these at all.
> > + *
> > + * This is actually called after writepage is run and so we can't
> > + * trust anything other than the buffer head (which we have pinned).
> > + *
> > + * Any datanew buffer at writepage time is filling a hole, so we don't need
> > + * extra tests against the inode size.
> > + */
> > +static int journal_dirty_data_guarded_writepage_fn(handle_t *handle,
> > +					 struct buffer_head *bh)
> > +{
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * Write could have mapped the buffer but it didn't copy the data in
> > +	 * yet. So avoid filing such buffer into a transaction.
> > +	 */
> > +	if (!buffer_mapped(bh) || !buffer_uptodate(bh))
> > +		return 0;
> > +
> > +	if (test_clear_buffer_datanew(bh))
> > +		ret = ext3_journal_dirty_data(handle, bh);
> > +	return ret;
> > +}
> > +
>   Hmm, here we use the datanew flag as well. But it's probably not worth
> keeping it just for this case. Ordering data in all cases when we get here
> should be fine since if the block is already allocated we should not get
> here (unless somebody managed to strip buffers from the page but kept the
> page but that should be rare enough).
> 

I'd keep it for the common case of filling holes with write(), so then
the code in writepage is gravy.

> > @@ -1300,6 +1590,68 @@ static int ext3_ordered_write_end(struct file *file,
> >  	return ret ? ret : copied;
> >  }
> >  
> > +static int ext3_guarded_write_end(struct file *file,
> > +				struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata)
> > +{
> > +	handle_t *handle = ext3_journal_current_handle();
> > +	struct inode *inode = file->f_mapping->host;
> > +	unsigned from, to;
> > +	int ret = 0, ret2;
> > +
> > +	copied = block_write_end(file, mapping, pos, len, copied,
> > +				 page, fsdata);
> > +
> > +	from = pos & (PAGE_CACHE_SIZE - 1);
> > +	to = from + copied;
> > +	ret = walk_page_buffers(handle, page_buffers(page),
> > +		from, to, NULL, journal_dirty_data_guarded_fn);
> > +
> > +	/*
> > +	 * we only update the in-memory i_size.  The disk i_size is done
> > +	 * by the end io handlers
> > +	 */
> > +	if (ret == 0 && pos + copied > inode->i_size) {
> > +		int must_log;
> > +
> > +		/* updated i_size, but we may have raced with a
> > +		 * data=guarded end_io handler.
> > +		 *
> > +		 * All the guarded IO could have ended while i_size was still
> > +		 * small, and if we're just adding bytes into an existing block
> > +		 * in the file, we may not be adding a new guarded IO with this
> > +		 * write.  So, do a check on the disk i_size and make sure it
> > +		 * is updated to the highest safe value.
> > +		 *
> > +		 * ext3_ordered_update_i_size tests inode->i_size, so we
> > +		 * make sure to update it with the ordered lock held.
> > +		 */
>   This can go away if we guard all the extending writes...

Yes, good point.

> 
> > +		ext3_ordered_lock(inode);
> > +		i_size_write(inode, pos + copied);
> > +
> > +		must_log = ext3_ordered_update_i_size(inode);
> > +		ext3_ordered_unlock(inode);
> > +		ordered_orphan_del_trans(inode, must_log > 0);
>   In case this needs to stay, here we have a transaction started so why not
> just directly call ordered_orphan_del()?
> 

Thanks

> > @@ -1747,7 +2238,14 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
> >  				goto out;
> >  			}
> >  			orphan = 1;
> > -			ei->i_disksize = inode->i_size;
> > +			/* in guarded mode, other code is responsible
> > +			 * for updating i_disksize.  Actually in
> > +			 * every mode, ei->i_disksize should be correct,
> > +			 * so I don't understand why it is getting updated
> > +			 * to i_size here.
> > +			 */
> > +			if (!ext3_should_guard_data(inode))
> > +				ei->i_disksize = inode->i_size;
>   Hmm, true. When we acquire i_mutex, i_size should be equal to i_disksize
> so this seems rather pointless. Probably worth a separate patch to remove
> it...

Yeah, I didn't want to go around messing with O_DIRECT in this
patchset ;)

> 
> >  			ext3_journal_stop(handle);
> >  		}
> >  	}
> > @@ -1768,11 +2266,20 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
> >  			ret = PTR_ERR(handle);
> >  			goto out;
> >  		}
> > +
> >  		if (inode->i_nlink)
> > -			ext3_orphan_del(handle, inode);
> > +			ordered_orphan_del(handle, inode, 0);
> > +
> >  		if (ret > 0) {
> >  			loff_t end = offset + ret;
> >  			if (end > inode->i_size) {
> > +				/* i_mutex keeps other file writes from
> > +				 * hopping in at this time, and we
> > +				 * know the O_DIRECT write just put all
> > +				 * those blocks on disk.  So, we can
> > +				 * safely update i_disksize here even
> > +				 * in guarded mode
> > +				 */
>   Not quite - there could be guarded blocks before the place where we did
> O_DIRECT write and we need to wait for them...

Hmmm, O_DIRECT is only waiting on the blocks it actually wrote isn't it.
Good point, will fix.

-chris


