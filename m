From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Wed, 29 Apr 2009 22:04:12 +0200
Message-ID: <20090429200412.GA27924@duck.suse.cz>
References: <1240941840.15136.44.camel@think.oraclecorp.com> <20090429085632.GA18273@duck.suse.cz> <1241014093.20099.28.camel@think.oraclecorp.com> <20090429191533.GB22936@duck.suse.cz> <1241034089.20099.60.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZD2UEO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 16:04:14 -0400
Content-Disposition: inline
In-Reply-To: <1241034089.20099.60.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 29-04-09 15:41:29, Chris Mason wrote:
> On Wed, 2009-04-29 at 21:15 +0200, Jan Kara wrote:
> > On Wed 29-04-09 10:08:13, Chris Mason wrote:
> > > On Wed, 2009-04-29 at 10:56 +0200, Jan Kara wrote:
> > > 
> > > > > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > > > > index fcfa243..1e90107 100644
> > > > > --- a/fs/ext3/inode.c
> > > > > +++ b/fs/ext3/inode.c
> > > > > @@ -38,6 +38,7 @@
> > > > >  #include <linux/bio.h>
> > > > >  #include <linux/fiemap.h>
> > > > >  #include <linux/namei.h>
> > > > > +#include <linux/workqueue.h>
> > > > >  #include "xattr.h"
> > > > >  #include "acl.h"
> > > > >  
> > > > > @@ -179,6 +180,105 @@ static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
> > > > >  }
> > > > >  
> > > > >  /*
> > > > > + * after a data=guarded IO is done, we need to update the
> > > > > + * disk i_size to reflect the data we've written.  If there are
> > > > > + * no more ordered data extents left in the tree, we need to
> > > >                                            ^^^^^^^^ the list
> > > > > + * get rid of the orphan entry making sure the file's
> > > > > + * block pointers match the i_size after a crash
> > > > > + *
> > > > > + * When we aren't in data=guarded mode, this just does an ext3_orphan_del.
> > > > > + *
> > > > > + * It returns the result of ext3_orphan_del.
> > > > > + *
> > > > > + * handle may be null if we are just cleaning up the orphan list in
> > > > > + * memory.
> > > > > + *
> > > > > + * pass must_log == 1 when the inode must be logged in order to get
> > > > > + * an i_size update on disk
> > > > > + */
> > > > > +static int ordered_orphan_del(handle_t *handle, struct inode *inode,
> > > > > +			      int must_log)
> > > > > +{
> > > >   I'm afraid this function is racy.
> > > > 1) We probably need i_mutex to protect against unlink happening in parallel
> > > >    (after we check i_nlink but before we all ext3_orphan_del).
> > > 
> > > This would mean IO completion (clearing PG_writeback) would have to wait
> > > on the inode mutex, which we can't quite do in O_SYNC and O_DIRECT.
> > > But, what I can do is check i_nlink after the ext3_orphan_del call and
> > > put the inode back on the orphan list if it has gone to zero.
> >   Ah, good point. But doing it without i_mutex is icky. Strictly speaking
> > you should have memory barriers in the code to make sure that you fetch
> > a recent value of i_nlink (although other locking around those places
> > probably does the work for you but *proving* the correctness is complex).
> >   Hmm, I can't help but the idea of updating i_disksize and calling
> > end_page_writeback() directly from end_io handler and doing just
> > mark_inode_dirty() and orphan deletion from the workqueue still returns to
> > me ;-) It would solve this problem as well. We just have to somehow pin the
> > inode so that VFS cannot remove it before we manage to file i_disksize
> > update into the transaction, which, I agree, has some issues as well as you
> > wrote in some email... The main advantage of the current scheme probably is
> > that PG_writeback bit naturally tells VM that we have still some pinned
> > resources and so it throttles writers if needed... But still, I find my
> > better ;).
> >  
> I think my latest patch has this nailed down without the mutex.
> Basically it checks i_nlink with super lock held and then calls
> ext3_orphan_del.  If we race with unlink, we'll either find the new
> nlink count and skip the orphan del or unlink will come in after us and
> add the orphan back.
  Ah, OK. That should reasonably work.

> > > > 2) We need superblock lock for the check
> > > > list_empty(&EXT3_I(inode)->i_orphan).
> > > 
> > > How about I take the guarded spinlock when doing the list_add instead?
> > > I'm trying to avoid the superblock lock as much as I can.
> >   Well, ext3_orphan_del() takes it anyway so it's not like you introduce a
> > new lock dependency. Actually in the code I wrote you have exactly as many
> > superblock locking as there is now. So IMO this is not an issue if we
> > somehow solve problem 1).
> > 
> 
> Yeah, I agree.
> 
> > > > 3) The function should rather have name ext3_guarded_orphan_del()... At
> > > >   least "ordered" is really confusing (that's the case for a few other
> > > >   structs / variables as well).
> > > 
> > > My long term plan was to replaced ordered with guarded, but I can rename
> > > this one to guarded if you think it'll make it more clear.
> >   Ah, OK. My feeling is that there's going to be at least some time of
> > coexstence of these two modes (also because the perfomance numbers for
> > ordered mode were considerably better in some loads) so I'd vote for
> > clearly separating their names.
> > 
> > > > >  	if (err)
> > > > >  		ext3_journal_abort_handle(__func__, __func__,
> > > > >  						bh, handle, err);
> > > > > @@ -1231,6 +1440,89 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> > > > >  	return 0;
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * Walk the buffers in a page for data=guarded mode.  Buffers that
> > > > > + * are not marked as datanew are ignored.
> > > > > + *
> > > > > + * New buffers outside i_size are sent to the data guarded code
> > > > > + *
> > > > > + * We must do the old data=ordered mode when filling holes in the
> > > > > + * file, since i_size doesn't protect these at all.
> > > > > + */
> > > > > +static int journal_dirty_data_guarded_fn(handle_t *handle,
> > > > > +					 struct buffer_head *bh)
> > > > > +{
> > > > > +	u64 offset = page_offset(bh->b_page) + bh_offset(bh);
> > > > > +	struct inode *inode = bh->b_page->mapping->host;
> > > > > +	int ret = 0;
> > > > > +
> > > > > +	/*
> > > > > +	 * Write could have mapped the buffer but it didn't copy the data in
> > > > > +	 * yet. So avoid filing such buffer into a transaction.
> > > > > +	 */
> > > > > +	if (!buffer_mapped(bh) || !buffer_uptodate(bh))
> > > > > +		return 0;
> > > > > +
> > > > > +	if (test_clear_buffer_datanew(bh)) {
> > > >   Hmm, if we just extend the file inside the block (e.g. from 100 bytes to
> > > > 500 bytes), then we won't do the write guarded. But then if we crash before
> > > > the block really gets written, user will see zeros at the end of file
> > > > instead of data... 
> > > 
> > > You see something like this:
> > > 
> > > create(file)
> > > write(file, 100 bytes) # create guarded IO
> > > fsync(file)
> > > write(file, 400 more bytes) # buffer isn't guarded, i_size goes to 500
> >   Yes.
> > 
> > > > I don't think we should let this happen so I'd think we
> > > > have to guard all the extending writes regardless whether they allocate new
> > > > block or not. 
> > > 
> > > My main concern was avoiding stale data from the disk after a crash,
> > > zeros from partially written blocks are not as big a problem.  But,
> > > you're right that we can easily avoid this, so I'll update the patch to
> > > do all extending writes as guarded.
> >   Yes, ext3 actually does some work to avoid exposing zeros at the
> > end of file when we fail to copy in new data (source page was swapped out
> > in the mean time) and we crash before we manage to swap the page in again.
> > So it would be stupid to introduce the same problem here again...
> 
> This should be fixed in my current version as well.  The buffer is
> likely to be added as an ordered buffer in that case, but either way
> there won't be zeros.
> 
> > 
> > > > Which probably makes the buffer_datanew() flag unnecessary
> > > > because we just guard all the buffers from max(start of write, i_size) to
> > > > end of write.
> > > 
> > > But, we still want buffer_datanew to decide when writes that fill holes
> > > should go through data=ordered.
> >   See below.
> > 
> > > > > +/*
> > > > > + * Walk the buffers in a page for data=guarded mode for writepage.
> > > > > + *
> > > > > + * We must do the old data=ordered mode when filling holes in the
> > > > > + * file, since i_size doesn't protect these at all.
> > > > > + *
> > > > > + * This is actually called after writepage is run and so we can't
> > > > > + * trust anything other than the buffer head (which we have pinned).
> > > > > + *
> > > > > + * Any datanew buffer at writepage time is filling a hole, so we don't need
> > > > > + * extra tests against the inode size.
> > > > > + */
> > > > > +static int journal_dirty_data_guarded_writepage_fn(handle_t *handle,
> > > > > +					 struct buffer_head *bh)
> > > > > +{
> > > > > +	int ret = 0;
> > > > > +
> > > > > +	/*
> > > > > +	 * Write could have mapped the buffer but it didn't copy the data in
> > > > > +	 * yet. So avoid filing such buffer into a transaction.
> > > > > +	 */
> > > > > +	if (!buffer_mapped(bh) || !buffer_uptodate(bh))
> > > > > +		return 0;
> > > > > +
> > > > > +	if (test_clear_buffer_datanew(bh))
> > > > > +		ret = ext3_journal_dirty_data(handle, bh);
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > >   Hmm, here we use the datanew flag as well. But it's probably not worth
> > > > keeping it just for this case. Ordering data in all cases when we get here
> > > > should be fine since if the block is already allocated we should not get
> > > > here (unless somebody managed to strip buffers from the page but kept the
> > > > page but that should be rare enough).
> > > > 
> > > 
> > > I'd keep it for the common case of filling holes with write(), so then
> > > the code in writepage is gravy.
> >   I'm not sure I understand. I wanted to suggest to change
> > if (test_clear_buffer_datanew(bh))
> > 	ret = ext3_journal_dirty_data(handle, bh);
> >   to
> > ret = ext3_journal_dirty_data(handle, bh);
> > 
> > So to always order the data. Actually the only case when we would get to
> > journal_dirty_data_guarded_writepage_fn() and buffer_datanew() is not set
> > would be when
> >   a) blocksize < pagesize, page already has some blocks allocated and we
> >    add more blocks to we fill the hole. Then with your code we would not order
> >    all blocks in the page, with my code we would. But I don't think it makes a
> >    big difference.
> >   b) someone removed buffers from the page.
> > In all other cases we should take the fast path in writepage and submit the
> > IO without starting the transaction.
> >   So IMO datanew can be removed...
> 
> What we don't want to do is have a call to write() over existing blocks
> in the file add new things to the data=ordered list.  I don't see how we
> can avoid that without datanew.
  Yes, what I suggest would do exactly that:
In ordered_writepage() in the beginning we do:
  page_bufs = page_buffers(page);
  if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
                         NULL, buffer_unmapped)) {
  	return block_write_full_page(page, NULL, wbc);
  }
So we only get to starting a transaction and file some buffers if some buffer
in the page is unmapped. Write() maps / allocates all buffers in write_begin()
so they are never added to ordered lists in writepage(). We rely on write_end
to do it. So the only case where not all buffers in the page are mapped is
when we have to allocate in writepage() (mmaped write) or the two cases I
describe above.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
