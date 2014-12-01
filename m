From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Mon, 1 Dec 2014 10:04:50 -0500
Message-ID: <20141201150450.GA3337@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
 <20141127144116.GA14091@thunk.org>
 <20141127153315.GC14091@thunk.org>
 <20141127164952.GA1622@infradead.org>
 <20141127202731.GG14091@thunk.org>
 <20141201092810.GA5538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141201092810.GA5538@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 01, 2014 at 01:28:10AM -0800, Christoph Hellwig wrote:
> 
> The ->is_readonly method seems like a clear winner to me, I'm all for
> adding it, and thus suggested moving it first in the series.

It's a real winner for me as well, but the reason why I dropped it is
because if btrfs() has to keep its ->update_time function, we wouldn't
actually have a user for is_readonly().  I suppose we could have
update_time() call ->is_readonly() and then ->update_time() if they
exist, but it only seemed to add an extra call and a bit of extra
overhead without really simplifying things for btrfs.

If there were other users of ->is_readonly, then it would make sense,
but it seemed better to move into a separate code refactoring series.

> I've read a bit more through the series and would like to suggest
> the following approach for the rest:
> 
>  - convert ext3/4 to use ->update_time instead of the ->dirty_time
>    callout so it gets and exact notifications (preferably the few
>    remaining filesystems as well, although that shouldn't really be a
>    blocker)

We could do that, although ext3/4's ->update_time() would be exactly
the same as the generic update_time() function, so there would be code
duplication.  If the goal is to get rid of the magic in
-->dirty_inode() being used to work around how the VFS makes changes
to fields that end up in the on-disk inode, we would need to audit a
lot of extra code paths; at the very least, in how the generic quota
code handles updates to i_size and i_blocks (for example).

And BTW, we don't actually have a dirty_time() function any more in
the current patch series.  update_time() is currently looking like
this:

static int update_time(struct inode *inode, struct timespec *time, int flags)
{
	if (inode->i_op->update_time)
		return inode->i_op->update_time(inode, time, flags);

	if (flags & S_ATIME)
		inode->i_atime = *time;
	if (flags & S_VERSION)
		inode_inc_iversion(inode);
	if (flags & S_CTIME)
		inode->i_ctime = *time;
	if (flags & S_MTIME)
		inode->i_mtime = *time;

	if ((inode->i_sb->s_flags & MS_LAZYTIME) && !(flags & S_VERSION) &&
	    !(inode->i_state & I_DIRTY))
		__mark_inode_dirty(inode, I_DIRTY_TIME);
	else
		__mark_inode_dirty(inode, I_DIRTY_SYNC);
	return 0;
}

>  - Convert xfs, btrfs and the remaining filesystes using ->dirty_inode
>    incrementally.

Right, so xfs and btrfs (which are the two file systems that have
update_time at the moment) can just drop update_time() and then check
the ->dirty_time() for (flags & I_DIRTY_TIME).  Hmm, I suspect this
might be better for xfs, yes?

	if ((inode->i_sb->s_flags & MS_LAZYTIME) && !(flags & S_VERSION) &&
	    !(inode->i_state & I_DIRTY))
		__mark_inode_dirty(inode, I_DIRTY_TIME);
	else
		__mark_inode_dirty(inode, I_DIRTY_SYNC | I_DIRTY_TIME);

XFS doesn't have a ->dirty_time yet, but that way XFS would be able to
use the I_DIRTY_TIME flag to log the journal timestamps if it so
desires, and perhaps drop the need for it to use update_time().  (And
with XFS doing logical journalling, it may be that you might want to
include the timestamp update in the journal if you have a journal
transaction open already, so the disk is spun up or likely to be spin
up anyway, right?)

						- Ted
