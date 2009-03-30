From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Avoid false EIO errors
Date: Mon, 30 Mar 2009 12:32:48 +0200
Message-ID: <20090330103248.GB18833@duck.suse.cz>
References: <1238091711-23464-1-git-send-email-jack@suse.cz> <20090327180806.GB2810@skywalker> <20090327202421.GB31071@duck.suse.cz> <20090330082532.GA15488@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZC3Kc5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 06:32:57 -0400
Content-Disposition: inline
In-Reply-To: <20090330082532.GA15488@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 30-03-09 13:55:32, Aneesh Kumar K.V wrote:
> On Fri, Mar 27, 2009 at 09:24:21PM +0100, Jan Kara wrote:
> > On Fri 27-03-09 23:38:06, Aneesh Kumar K.V wrote:
> > > On Thu, Mar 26, 2009 at 07:21:51PM +0100, Jan Kara wrote:
> > > > Sometimes block_write_begin() can map buffers in a page but later we fail to
> > > > copy data into those buffers (because the source page has been paged out in the
> > > > mean time). We then end up with !uptodate mapped buffers. To add a bit more to
> > > > the confusion, block_write_end() does not commit any data (and thus does not
> > > > any mark buffers as uptodate) if we didn't succeed with copying all the data.
> > > > 
> > > > Commit f4fc66a894546bdc88a775d0e83ad20a65210bcb (ext3: convert to new aops)
> > > > missed these cases and thus we were inserting non-uptodate buffers to
> > > > transaction's list which confuses JBD code and it reports IO errors, aborts
> > > > a transaction and generally makes users afraid about their data ;-P.
> > > > 
> > > > This patch fixes the problem by reorganizing ext3_..._write_end() code to
> > > > first call block_write_end() to mark buffers with valid data uptodate and
> > > > after that we file only uptodate buffers to transaction's lists. Also
> > > > fix a problem where we could leave blocks allocated beyond i_size (i_disksize
> > > > in fact).
> > > > 
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > >  fs/ext3/inode.c |   99 +++++++++++++++++++++++-------------------------------
> > > >  1 files changed, 42 insertions(+), 57 deletions(-)
> > > > 
> > > >   As a side note, ext4 / JBD2 only needs the "proper i_disksize update"
> > > > part of the fix (we got rid of special handling of ordered mode buffers
> > > > there). But I have to first figure out how to properly do it...
> > > >   Andrew, would you please merge the patch? Thanks.
> > > > 
> > > > 									Honza
> > > > 
> > > > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > > > index 5fa453b..e230f7a 100644
> > > > --- a/fs/ext3/inode.c
> > > > +++ b/fs/ext3/inode.c
> > > > @@ -1211,6 +1211,18 @@ int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
> > > >  	return err;
> > > >  }
> > > > 
> > > > +/* For ordered writepage and write_end functions */
> > > > +static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> > > > +{
> > > > +	/*
> > > > +	 * Write could have mapped the buffer but it didn't copy the data in
> > > > +	 * yet. So avoid filing such buffer into a transaction.
> > > > +	 */
> > > > +	if (buffer_mapped(bh) && buffer_uptodate(bh))
> > > > +		return ext3_journal_dirty_data(handle, bh);
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  /* For write_end() in data=journal mode */
> > > >  static int write_end_fn(handle_t *handle, struct buffer_head *bh)
> > > >  {
> > > > @@ -1221,26 +1233,29 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
> > > >  }
> > > > 
> > > >  /*
> > > > - * Generic write_end handler for ordered and writeback ext3 journal modes.
> > > > - * We can't use generic_write_end, because that unlocks the page and we need to
> > > > - * unlock the page after ext3_journal_stop, but ext3_journal_stop must run
> > > > - * after block_write_end.
> > > > + * This is nasty and subtle: ext3_write_begin() could have allocated blocks
> > > > + * for the whole page but later we failed to copy the data in. So the disk
> > > > + * size we really have allocated is pos + len (block_write_end() has zeroed
> > > > + * the freshly allocated buffers so we aren't going to write garbage). But we
> > > > + * want to keep i_size at the place where data copying finished so that we
> > > > + * don't confuse readers. The worst what can happen is that we expose a page
> > > > + * of zeros at the end of file after a crash...
> > > >   */
> > > > -static int ext3_generic_write_end(struct file *file,
> > > > -				struct address_space *mapping,
> > > > -				loff_t pos, unsigned len, unsigned copied,
> > > > -				struct page *page, void *fsdata)
> > > > +static void update_file_sizes(struct inode *inode, loff_t pos, unsigned len,
> > > > +			      unsigned copied)
> > > >  {
> > > > -	struct inode *inode = file->f_mapping->host;
> > > > -
> > > > -	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
> > > > +	int mark_dirty = 0;
> > > > 
> > > > -	if (pos+copied > inode->i_size) {
> > > > -		i_size_write(inode, pos+copied);
> > > > -		mark_inode_dirty(inode);
> > > > +	if (pos + len > EXT3_I(inode)->i_disksize) {
> > > > +		mark_dirty = 1;
> > > > +		EXT3_I(inode)->i_disksize = pos + len;
> > > >  	}
> > > 
> > > Won't this result in file having wrong contents if we failed to copy
> > > the contents from user space? Now if we successfully allocated
> > > blocks and we failed to copy the contents from user space, the above
> > > would result in update of i_disksize and a mark_inode_dirty. Doesn't
> > > that imply we have wrong contents in those block for which we failed to
> > > copy the contents from user space ?
> >   block_write_end() zeros all new buffers. So yes, if we crash after
> > this transaction commits but before we manage to redo the write, then user
> > could see zeros at the end of file (previously inode could have blocks
> > allocated beyond EOF).
> >   I was also thinking about truncating the newly created buffers but it's a
> > bit tricky. We need to do it in the same transaction (otherwise the race
> > would be still there) but standard truncate path would like to add inode
> > to the orphan list, lock pages etc and we have no credits for that and also
> > lock ordering might be troublesome. So I've chosen the simple path.
> > 
> We do a vmtruncate if we failed to allocate blocks in
> ext3_write_begin. That is done after the closing the current
> transaction. If we crash in between (ie, after committing the
> transaction allocating blocks and before committing the transaction that
> is doing truncate) we would only have  some data blocks leaking. But
> that would be better than user seeing zero's in the file ?. Also if we
> happen to add the inode to the orphan list and crash, the recovery would
> truncate it properly. So by doing a vmtruncate I guess the window would be
> small and we are already doing that in ext3_write_begin.
  Hmm, are you sure some assertion would not fire if we find allocated
blocks beyond i_size (which could happen with the old code)? Frankly, I
prefer user seeing zeros at the end of file (so that he can come and yell
at me ;) rather than silently leaking blocks, getting inode into an
unexpected state and then debug some mysterious problem. But hopefully this
problem has a solution which can make both of us happy ;): We can reserve
enough credits (actually just one block more) and when we see we need to
do truncate because of failed write, we first add inode to the orphan list
before stopping the current handle (so that if we crash it gets properly
truncated) and then truncate the blocks in a separate transaction. Does it
sound good to you?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
