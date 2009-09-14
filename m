From: Jan Kara <jack@suse.cz>
Subject: Re: fsync on ext[34] working only by an accident
Date: Mon, 14 Sep 2009 18:00:41 +0200
Message-ID: <20090914160041.GB25549@duck.suse.cz>
References: <20090908132601.GA17778@duck.suse.cz> <20090910064605.GA8690@skywalker.linux.vnet.ibm.com> <20090910085056.GA607@duck.suse.cz> <20090910090449.GA11418@skywalker.linux.vnet.ibm.com> <20090910091551.GB11418@skywalker.linux.vnet.ibm.com> <20090910105216.GG607@duck.suse.cz> <20090910110455.GA17531@skywalker.linux.vnet.ibm.com> <20090910131007.GC31907@mit.edu> <20090910140636.GJ607@duck.suse.cz> <20090910165201.GA23700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbZINQAj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Sep 2009 12:00:39 -0400
Content-Disposition: inline
In-Reply-To: <20090910165201.GA23700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-09-09 12:52:01, Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 04:06:36PM +0200, Jan Kara wrote:
> > > In fact, I think the problem is worse than Jan is pointing out,
> > > because it's not enough that vfs_fq_alloc_space() is calling
> > > mark_inode_dirty(), since that only sets I_DIRTY_SYNC.  When we touch
> > > i_size or i_block[], we need to make sure that I_DIRTY_DATASYNC is
> > > set, so that fdatasync() will force a commit.
> >   Actually no. mark_inode_dirty() dirties inode with I_DIRTY ==
> > (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES) so it happens to work.
> > The fact that quota *could* dirty the inode with I_DIRTY_SYNC only
> > is right but that's a separate issue.
> 
> Oops, you're right.  I mixed up I_DIRTY and I_DIRTY_SYNC.  Hmm, what's
> actually a bit surprising is that we don't have a
> mark_inode_dirty_datasync() which only sets I_DIRTY_DATASYNC.
  Yeah. But that's easy to fix ;).

> And shouldn't quota be dirtying the inode using I_DIRTY_DATASYNC only?
> After, all the reason why we need to do this is because it's messing
> with i_size, right?
  Quota does not touch i_size. It touches only i_blocks - that's why it
dirties the inode. Since i_blocks are not really needed to get to the data,
I think I_DIRTY_SYNC for quota is more appropriate.

> >   Thinking about it, it won't work so easily. The problem is that when
> > pdflush decides to write the inode, it unconditionally clears dirty flags.
> > We could redirty the inode in write_inode() but that's IMHO too ugly to
> > bear it.
> 
> Hmm, yes.  I wonder if this is something we should change, and make it
> be the responsibility of the filesystem's write_inode method function
> to clear I_DIRTY_SYNC and I_DIRTY_DATASYNC flags.  That would allow
> the file system to refuse to clean the inode for whatever reason the
> file system saw fit.  That would require sweeping through all of the
> file systems, but it might be useful for more file systems other than
> ext3/ext4.
  Possibly yes. But OTOH from the point of view of pdflush, the inode
actually is clean. It could be even evicted from memory when needed before
the transaction commits - which invalidates my approach to solving the
fsync() trouble. Nasty.
  Also just not clearing dirty bits in write_inode() would probably rather
confuse current writeback code because all inodes would stay dirty until
a transaction commit with no way of getting rid of them. So pdflush would
needlessly burn CPU cycles scanning them and trying to write them. Also
it's not completely clear how we would clear the dirty bits after the
transaction commits since during commit, it could become part of a freshly
started transaction.
  Sigh, it's rather convoluted. Probably we have to somehow pin the inode
in memory until the transaction commits to fix the "remember TID" approach.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
