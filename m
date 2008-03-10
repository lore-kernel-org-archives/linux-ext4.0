From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] JBD ordered mode rewrite
Date: Mon, 10 Mar 2008 15:37:46 -0600
Message-ID: <20080310213746.GL5851@webber.adilger.int>
References: <20080306174209.GA14193@duck.suse.cz>
 <20080307235210.GM1881@webber.adilger.int>
 <20080310195440.GI30435@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61249 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCJVip (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Mar 2008 17:38:45 -0400
In-reply-to: <20080310195440.GI30435@duck.suse.cz>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 10, 2008  20:54 +0100, Jan Kara wrote:
> On Fri 07-03-08 16:52:10, Andreas Dilger wrote:
> > I'm looking at what implications this has for delayed allocation in ext4,
> > because the vast majority of file data will be unmapped in that case
> > and a journal commit in ordered mode will no longer cause the data to
> > be flushed to disk.
> > 
> > I _think_ is OK, because the pdflushd will now be totally in charge of
> > flushing the dirty pages to disk, instead of this previously being done
> > by ordered mode in the journal.  I know there have been some bugs in this
> > area in the past, but I guess it isn't much different than running in
> > writeback mode.  That said, I don't know how many users run in writeback
> > mode unless they are running a database, and the database is doing a lot
> > of explicit fsync of file data so there may still be bugs lurking...
>
>   Yes, they basically get guarantees as in writeback mode. As I wrote to
> Mingming, I'm not sure how that is handled with current ordered-mode
> handling because you cannot afford to do block allocation from the commit
> code anyway. We could possibly do the allocation if we were sure that we
> have enough credits in the transaction (but that currently isn't the case
> since we really count the number of buffers dirtied on the account of
> transaction handle and after the handle is dropped, we give back unused
> credits to the transaction).
 
Actually, I think this is the same semantics as the existing ordered mode,
as long as the on-disk inode is only changed as part of the transaction
that is allocating the pages (which is needed for correctness in any case).

The noticable difference will be that the new ordered mode will not force
out pending dirty pages, if it is run with delalloc.  This would be a big
improvement, because users of fsync() on a filesystem with another streaming
IO process have terrible latency problems with the current code.  So not
only does your patch reduce complexity, it allows ext4 delalloc to work
in ordered mode, and improves overall responsiveness as well.

I think in ext4 it makes sense to always be running in delalloc mode once
your patch is landed, as delalloc has improved performance greatly, and
one of the few reasons we haven't submitted it upstream was the lack of
ordered mode support.

As far as patching ext3/jbd vs. ext4/jbd2, I think it makes a lot more
sense to test this patch with ext4 first in -mm because people will not
expect as much stability with ext4 vs. ext3 and this will allow some time
to get testing on your changes, which affect a very core part of ext3/jbd.

> > Hmm, this is one area I'm a bit worried about.  In the old code the number
> > of buffers to sync for a transaction are bounded because they can only be
> > added to the transaction while it is open.  With this new inode-list code
> > there could be a process busily adding new dirty + mapped pages to the
> > inode(s) in the running transaction, while we are blocked here writing
> > out the pages in kjournald trying to commit the previous transaction.
>
>   Correct me if I'm wrong but as far as I look into the write-out code, we
> do just one-sweep scan of mapping when writing out dirty pages. So we could
> possibly write out more than we need but at most the whole file. Oh, ok,
> someone could be extending the file as well but we could fix that by
> setting .range_end to the current i_size - that's actually a nice
> optimization anyway so I've done that.

Yes, the continually-growing file livelock is a problem that hit fsync in
the past, and we need to avoid it here also.  Using .range_end is a good
way to avoid it, though it isn't 100% foolproof due to usage like:

	ftruncate(fd, LARGE_SIZE);
	write(fd, buf, LARGE_SIZE);

It will eventually end, but not for a long time.

> > > +	spin_lock(&journal->j_list_lock);
> > > +
> > > +	if (jinode->i_transaction == transaction ||
> > > +	    jinode->i_next_transaction == transaction)
> > > +		goto done;
> > 
> > Is it possible/safe to do the above check outside of the j_list_lock
> > as an optimization?  We will be calling this function for every page
> > that is dirtied and it will likely be quite highly contended.  It used
> > to be that we HAD to get this lock because we were almost certainly
> > adding the new buffers to the transaction list, but in this updated
> > code the common case is that the inode will already be on the list...
>
>   Probably we could do that - there are two places where we remove inode
> from a transaction list (and these are the only ones interesting for
> races). One is the commit code and the other one is
> journal_release_jbd_inode(). We are safe from the second one because we
> obviously hold a reference to the inode. The first one is more subtle but
> if jinode->i_transaction == transaction, it is filed on the running
> transaction's list from which we have handle and so commit code cannot
> touch it. If jinode->i_next_transaction == transaction, then commit code
> can change inode under us but it will file the inode to the running
> transaction's list anyway so there's nothing to lose.
>   Changed the code and added a big comment...

Great, thanks.  Avoiding lock contention is a big issue on many-way SMP
systems that are becoming much more common these days.

> > > +int journal_begin_ordered_truncate(struct jbd_inode *inode, loff_t new_size)
> > > +{
> > > +	journal_t *journal;
> > > +	transaction_t *commit_trans;
> > > +	int ret = 0;
> > > +
> > > +	if (!inode->i_transaction && !inode->i_next_transaction)
> > > +		goto out;
> > > +
> > > +	journal = inode->i_transaction->t_journal;
> > > +	spin_lock(&journal->j_state_lock);
> > > +	commit_trans = journal->j_committing_transaction;
> > > +	spin_unlock(&journal->j_state_lock);
> > > +	if (inode->i_transaction == commit_trans) {
> > > +		ret = __filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
> > > +			new_size, LLONG_MAX, WB_SYNC_ALL);
> > > +		if (ret)
> > > +			journal_abort(journal, ret);
> > > +	}
> > 
> > Is there any way here to entirely avoid writing blocks which were just
> > allocated during the current transaction (e.g. temp files during compile
> > or whatever)?  One possibility is to store the transaction number when
> > the inode was created (or first dirtied?) in ext3_inode_info and if that is
> > equal to the committing transaction then we don't need to write anything
> > at all?
>
>   Note that we write out blocks only if we truncate inode that is being
> currently committed. I.e., it has been created in the previous transaction
> and is truncated in the current one. Or did you mean something else?

OK, it seems very few files will span the truncate boundary (for compiles
likely only num_cpus) and if they can be truncated within the same transaction
without an IO that is fine.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

