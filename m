From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 09:10:07 -0400
Message-ID: <20090910131007.GC31907@mit.edu>
References: <20090908132601.GA17778@duck.suse.cz> <20090910064605.GA8690@skywalker.linux.vnet.ibm.com> <20090910085056.GA607@duck.suse.cz> <20090910090449.GA11418@skywalker.linux.vnet.ibm.com> <20090910091551.GB11418@skywalker.linux.vnet.ibm.com> <20090910105216.GG607@duck.suse.cz> <20090910110455.GA17531@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44622 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbZIJNKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 09:10:13 -0400
Content-Disposition: inline
In-Reply-To: <20090910110455.GA17531@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 04:34:55PM +0530, Aneesh Kumar K.V wrote:
> mark_buffer_dirty -> __set_page_dirty -> __mark_inode_dirty

We need to be careful here.  First of all, mark_buffer_dirty() on the
code paths you are talking about is being passed a metadata buffer
head.  As such, has Jan has pointed out, the bh is part of the buffer
cache, so the page->mapping of associated with bh->b_page is the inode
of the block device --- *not* the ext4 inode.

Secondly, __set_page_dirty calls __mark_inode_dirty passing in
I_DIRTY_PAGES --- which should be a hint.  What Jan is talking about
is where we set the inode flags I_DIRTY_SYNC and I_DIRTY_DATASYNC:

 * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
 *			fdatasync().  i_atime is the usual cause.
 * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
 *			these changes separately from I_DIRTY_SYNC so that we
 *			don't have to write inode on fdatasync() when only
 *			mtime has changed in it.

This is important because ext4_sync_file() (which is called by fsync()
and fdatasync()) uses this logic to determine whether or not to call
sync_inode(), which is what will force a commit when wbc.sync_mode is
set to WB_SYNC_ALL.

In fact, I think the problem is worse than Jan is pointing out,
because it's not enough that vfs_fq_alloc_space() is calling
mark_inode_dirty(), since that only sets I_DIRTY_SYNC.  When we touch
i_size or i_block[], we need to make sure that I_DIRTY_DATASYNC is
set, so that fdatasync() will force a commit.

I think the right thing to do is to create an
_ext[34]_mark_inode_dirty() which takes an extra argument, which
controls whether or not we set I_DIRTY_SYNC or I_DIRTY_DATASYNC.  In
fact, most of the time, we want to be setting I_DIRTY_DATASYNC, so we
should probably have ext[34]_mark_inode_dirty() call
_ext[34]_mark_inode_dirty() with I_DIRTY_DATASYNC, and then create a
ext[34]_mark_inode_nodatasync() version passes in I_DIRTY_SYNC.

This will cause pdflush to call ext4_write_inode() more frequently,
but pdflush calls write_inode with wait=0, and ext4_write_inode() is a
no-op in that case.

BTW, while I was looking into this, I noted that the comments ahead of
ext[34]_mark_inode_dirty are out of date; they date back to a time
when when prune_icache actually was responsible for cleaning dirty
inodes; these days, that honor is owned by fs-writeback.c and
pdflush.)  Also, the second half of the comments in
ext4_write_inode(), where they reference mark_inode_dirty() are also
painfully out of date, and somewhat misleading as a result.

Does this make sense to every one?

					- Ted
