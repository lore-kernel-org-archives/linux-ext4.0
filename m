From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 12:52:01 -0400
Message-ID: <20090910165201.GA23700@mit.edu>
References: <20090908132601.GA17778@duck.suse.cz> <20090910064605.GA8690@skywalker.linux.vnet.ibm.com> <20090910085056.GA607@duck.suse.cz> <20090910090449.GA11418@skywalker.linux.vnet.ibm.com> <20090910091551.GB11418@skywalker.linux.vnet.ibm.com> <20090910105216.GG607@duck.suse.cz> <20090910110455.GA17531@skywalker.linux.vnet.ibm.com> <20090910131007.GC31907@mit.edu> <20090910140636.GJ607@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45577 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZIJQwL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 12:52:11 -0400
Content-Disposition: inline
In-Reply-To: <20090910140636.GJ607@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 04:06:36PM +0200, Jan Kara wrote:
> > In fact, I think the problem is worse than Jan is pointing out,
> > because it's not enough that vfs_fq_alloc_space() is calling
> > mark_inode_dirty(), since that only sets I_DIRTY_SYNC.  When we touch
> > i_size or i_block[], we need to make sure that I_DIRTY_DATASYNC is
> > set, so that fdatasync() will force a commit.
>   Actually no. mark_inode_dirty() dirties inode with I_DIRTY ==
> (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES) so it happens to work.
> The fact that quota *could* dirty the inode with I_DIRTY_SYNC only
> is right but that's a separate issue.

Oops, you're right.  I mixed up I_DIRTY and I_DIRTY_SYNC.  Hmm, what's
actually a bit surprising is that we don't have a
mark_inode_dirty_datasync() which only sets I_DIRTY_DATASYNC.

And shouldn't quota be dirtying the inode using I_DIRTY_DATASYNC only?
After, all the reason why we need to do this is because it's messing
with i_size, right?

>   Thinking about it, it won't work so easily. The problem is that when
> pdflush decides to write the inode, it unconditionally clears dirty flags.
> We could redirty the inode in write_inode() but that's IMHO too ugly to
> bear it.

Hmm, yes.  I wonder if this is something we should change, and make it
be the responsibility of the filesystem's write_inode method function
to clear I_DIRTY_SYNC and I_DIRTY_DATASYNC flags.  That would allow
the file system to refuse to clean the inode for whatever reason the
file system saw fit.  That would require sweeping through all of the
file systems, but it might be useful for more file systems other than
ext3/ext4.

The problem is it's a little late, given that 2.6.31 has already been
released, to try to get consensus on that way of doing things.
Tracking the TID is probably the best short-term way of handling this
problem, although it means bloating the in-core inode by another four
bytes, which is a bit of a shame.

       	     				- Ted
