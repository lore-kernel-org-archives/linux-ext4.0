From: Ted Ts'o <tytso@mit.edu>
Subject: [tytso@mit.edu: Re: [PATCH-v5 1/5] vfs: add support for a lazytime
 mount option]
Date: Fri, 28 Nov 2014 13:37:13 -0500
Message-ID: <20141128183713.GA24586@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:60348 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaK1ShP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Nov 2014 13:37:15 -0500
Received: by mail-ig0-f202.google.com with SMTP id hn18so741339igb.3
        for <linux-ext4@vger.kernel.org>; Fri, 28 Nov 2014 10:37:14 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, sorry, responding from a different computer from what I normally
use due to Thanksgiving.

					- Ted

----- Forwarded message from Ted Ts'o <tytso@mit.edu> -----

Date: Fri, 28 Nov 2014 13:14:21 -0500
From: Ted Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v5 1/5] vfs: add support for a lazytime mount option
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Nov 28, 2014 at 06:23:23PM +0100, Jan Kara wrote:
> Hum, when someone calls fsync() for an inode, you likely want to sync
> timestamps to disk even if everything else is clean. I think that doing
> what you did in last version:
> 	dirty = inode->i_state & I_DIRTY_INODE;
> 	inode->i_state &= ~I_DIRTY_INODE;
> 	spin_unlock(&inode->i_lock);
> 	if (dirty & I_DIRTY_TIME)
> 		mark_inode_dirty_sync(inode);
> looks better to me. IMO when someone calls __writeback_single_inode() we
> should write whatever we have...

Yes, but we also have to distinguish between what happens on an
fsync() versus what happens on a periodic writeback if I_DIRTY_PAGES
(but not I_DIRTY_SYNC or I_DIRTY_DATASYNC) is set.  So there is a
check in the fsync() code path to handle the concern you raised above.

> > +EXPORT_SYMBOL(inode_requeue_dirtytime);
> > +
>   This function has a single call site - update_time(). I'd prefer to
> handle this as a special case of __mark_inode_dirty() to have all the dirty
> queueing in one place...

It was originally also called by the ext4 optimization earlier; but
now that we've dropped it, sure, we can fold this back in.

> > +/*
> > + * Take all of the indoes on the dirty_time list, and mark them as
> > + * dirty, so they will be written out.
> > + */
> > +static void flush_sb_dirty_time(struct super_block *sb)
> > +{
> > +	struct bdi_writeback *wb = &sb->s_bdi->wb;
> > +	LIST_HEAD(tmp);
> > +
> > +	spin_lock(&wb->list_lock);
> > +	list_cut_position(&tmp, &wb->b_dirty_time, wb->b_dirty_time.prev);
> > +	while (!list_empty(&tmp)) {
> > +		struct inode *inode = wb_inode(tmp.prev);
> > +
> > +		list_del_init(&inode->i_wb_list);
> > +		spin_unlock(&wb->list_lock);
> > +		if (inode->i_state & I_DIRTY_TIME)
> > +			mark_inode_dirty_sync(inode);
> > +		spin_lock(&wb->list_lock);
> > +	}
> > +	spin_unlock(&wb->list_lock);
> > +}
> > +
>   This shouldn't be necessary when you somewhat tweak what you do in
> queue_io().

Right, I can key off of wb->reason == WB_REASON_SYNC.  Will fix next
time out.

					- Ted

> > -		if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock))
> > -			iput_final(inode);
> > +	if (!inode)
> > +		return;
> > +	BUG_ON(inode->i_state & I_CLEAR);
> > +retry:
> > +	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
> > +		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
> > +			atomic_inc(&inode->i_count);
> > +			inode->i_state &= ~I_DIRTY_TIME;
> > +			spin_unlock(&inode->i_lock);
> > +			mark_inode_dirty_sync(inode);
> > +			goto retry;
> > +		}
> > +		iput_final(inode);
>   How about my suggestion from previous version to avoid the retry loop by
> checking I_DIRTY_TIME before atomic_dec_and_lock()?

I looked at doing "if ((atomic_read(&inode->i_count) == 1 && (i_state
& I_DIRTY_TIME)))" but that's vulerable to racing calls to iput(), and
if the inode then gets evicted, we could end up losing the timestamp
update.  For my use cases, I really couldn't care less, but for
correctness's sake, it seemed better to keep the retry loop and deal
with the test under the lock.

						- Ted

----- End forwarded message -----
