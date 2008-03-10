From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] JBD ordered mode rewrite
Date: Mon, 10 Mar 2008 19:00:39 +0100
Message-ID: <20080310180039.GG30435@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz> <20080307013427.GG12440@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mark Fasheh <mark.fasheh@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37846 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751274AbYCJSAl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Mar 2008 14:00:41 -0400
Content-Disposition: inline
In-Reply-To: <20080307013427.GG12440@ca-server1.us.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 06-03-08 17:34:27, Mark Fasheh wrote:
> On Thu, Mar 06, 2008 at 06:42:09PM +0100, Jan Kara wrote:
> >   Below is my rewrite of ordered mode in JBD. Now we don't have a list of
> > data buffers that need syncing on transaction commit but a list of inodes
> > that need writeout during commit. This brings all sorts of advantages such
> > as possibility to get rid of journal heads and buffer heads for data
> > buffers in ordered mode, better ordering of writes on transaction commit,
> > simplification of some JBD code, no more anonymous pages when truncate of
> > data being committed happens.
> 
> There's a lot of JBD code which gets removed by this patch - cool :)
> 
> 
> > The patch has survived some light testing but it still has some potential
> > of eating your data so beware :)
> 
> Looking through the patch, I don't see how you solve the page lock /
> transaction ordering issues. I see that you avoid starting a handle in
> ->writepage during transaction commit, but what about another process which
> starts a handle under page lock and needs to wait for transactions to be
> written out before continuing?
  Ho, hum, drat. I think you're right. And I don't see a way around this
besides reversing the order of page_lock and transaction start in the whole
ext3/4 :(... I'll think how we could solve this problem but I'm afraid
the rewrite is the easiest one.


> > I've run dbench to see whether we didn't decrease performance by different
> > handling of truncate and the throughput I'm getting on my machine is the
> > same (OK, is lower by 0.5%) if I disable the code in truncate waiting for
> > commit to finish...
> > Also the throughput of dbench is about 2% better with my patch than with
> > current JBD.
> >   Any comments or testing most welcome.
> 
> My attempt at helpful review follows.
> 
> 
> > @@ -1465,15 +1444,11 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> >   * We don't honour synchronous mounts for writepage().  That would be
> >   * disastrous.  Any write() or metadata operation will sync the fs for
> >   * us.
> > - *
> > - * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
> > - * we don't need to open a transaction here.
> >   */
> >  static int ext3_ordered_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> >  	struct inode *inode = page->mapping->host;
> > -	struct buffer_head *page_bufs;
> >  	handle_t *handle = NULL;
> >  	int ret = 0;
> >  	int err;
> > @@ -1487,46 +1462,49 @@ static int ext3_ordered_writepage(struct page *page,
> >  	if (ext3_journal_current_handle())
> >  		goto out_fail;
> >  
> > -	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
> > -
> > -	if (IS_ERR(handle)) {
> > -		ret = PTR_ERR(handle);
> > -		goto out_fail;
> > +	/*
> > +	 * Now there are two different reasons why we can be called:
> > +	 *   1) write out during commit
> > +	 *   2) fsync / writeout to free memory
> > +	 *
> > +	 * In the first case, we just need to write the buffer to disk, in the
> > +	 * second case we may need to do hole filling and attach the inode to
> > +	 * the transaction. Note that even in the first case, we may get an
> > +	 * unmapped buffer (hole fill with data via mmap) but we don't have to
> > +	 * write it - actually, we can't because from a transaction commit we
> > +	 * cannot start a new transaction or we could deadlock.
> 
> What happens to the data if we get here under the 1st case with a hole? Do
> we eventually fill the hole (with correct data) via some mechanism I don't
> see here?
  Yes, eventually pdflush will find the page, call writepage() and that
will fill the hole. 

> <snip>
> 
> 
> > +/*
> > + * This function must be called when inode is journaled in ordered mode
> > + * before truncation happens. It starts writeout of truncated part in
> > + * case it is in the committing transaction so that we stand to ordered
> > + * mode consistency guarantees.
> > + */
> > +int journal_begin_ordered_truncate(struct jbd_inode *inode, loff_t new_size)
> > +{
> > +	journal_t *journal;
> > +	transaction_t *commit_trans;
> > +	int ret = 0;
> > +
> > +	if (!inode->i_transaction && !inode->i_next_transaction)
> > +		goto out;
> > +	journal = inode->i_transaction->t_journal;
> > +	spin_lock(&journal->j_state_lock);
> > +	commit_trans = journal->j_committing_transaction;
> > +	spin_unlock(&journal->j_state_lock);
> > +	if (inode->i_transaction == commit_trans) {
> 
> AFAICT, this is called in ext3 before a handle is started for truncate. Is
> it possible for the current running transaction to become the new committing
> transaction shortly after the spinlock is dropped, but before the truncate
> transaction starts? Could this lead to ordered data not being written out if
> the inode is part of the current running transaction but not part of the
> committing transaction?
  Good catch.  Actually, the problem isn't in
journal_begin_ordered_truncate() but you are right that we should call this
function only after we add the inode to the orphan list. That way we know
that if the current running transaction commits, the inode will be
truncated at least during journal replay and thus we are safe from the
races you describe above. Fixed.

> > +		ret = __filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
> > +			new_size, LLONG_MAX, WB_SYNC_ALL);
> > +		if (ret)
> > +			journal_abort(journal, ret);
> > +	}
> > +out:
> > +	return ret;
> > +}
> > diff --git a/fs/mpage.c b/fs/mpage.c
> > index 235e4d3..4f66bae 100644
> > --- a/fs/mpage.c
> > +++ b/fs/mpage.c
> > @@ -527,7 +527,10 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
> >  
> >  		map_bh.b_state = 0;
> >  		map_bh.b_size = 1 << blkbits;
> > -		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
> > +		if (mpd->get_block(inode, block_in_file, &map_bh,
> > +				   !wbc->skip_unmapped))
> > +			goto confused;
> > +		if (!buffer_mapped(&map_bh))
> >  			goto confused;
> >  		if (buffer_new(&map_bh))
> >  			unmap_underlying_metadata(map_bh.b_bdev,
> > diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> > index 36c5403..7aa8327 100644
> > --- a/include/linux/ext3_fs.h
> > +++ b/include/linux/ext3_fs.h
> > @@ -826,6 +826,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
> >  extern struct inode *ext3_iget(struct super_block *, unsigned long);
> >  extern int  ext3_write_inode (struct inode *, int);
> >  extern int  ext3_setattr (struct dentry *, struct iattr *);
> > +extern void ext3_drop_inode (struct inode *);
> 
> Not sure what this is here for...
  Removed - it was left there from the previous version of the patch.

  Thanks for a really helpful review.

										Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
