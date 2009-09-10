From: Mingming <cmm@us.ibm.com>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 13:14:46 -0700
Message-ID: <1252613686.7006.5.camel@mingming-laptop>
References: <20090908132601.GA17778@duck.suse.cz>
	 <20090910064605.GA8690@skywalker.linux.vnet.ibm.com>
	 <20090910085056.GA607@duck.suse.cz>
	 <20090910090449.GA11418@skywalker.linux.vnet.ibm.com>
	 <20090910091551.GB11418@skywalker.linux.vnet.ibm.com>
	 <20090910105216.GG607@duck.suse.cz>
	 <20090910110455.GA17531@skywalker.linux.vnet.ibm.com>
	 <20090910131007.GC31907@mit.edu>  <20090910140636.GJ607@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:51799 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZIJUOp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 16:14:45 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8AKDqQv005006
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:13:52 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8AKEl1Q252428
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:14:47 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8AKElUF025118
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:14:47 -0600
In-Reply-To: <20090910140636.GJ607@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-09-10 at 16:06 +0200, Jan Kara wrote:
> On Thu 10-09-09 09:10:07, Theodore Tso wrote:
> > On Thu, Sep 10, 2009 at 04:34:55PM +0530, Aneesh Kumar K.V wrote:
> > > mark_buffer_dirty -> __set_page_dirty -> __mark_inode_dirty
> > 
> > We need to be careful here.  First of all, mark_buffer_dirty() on the
> > code paths you are talking about is being passed a metadata buffer
> > head.  As such, has Jan has pointed out, the bh is part of the buffer
> > cache, so the page->mapping of associated with bh->b_page is the inode
> > of the block device --- *not* the ext4 inode.
> > 
> > Secondly, __set_page_dirty calls __mark_inode_dirty passing in
> > I_DIRTY_PAGES --- which should be a hint.  What Jan is talking about
> > is where we set the inode flags I_DIRTY_SYNC and I_DIRTY_DATASYNC:
> > 
> >  * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
> >  *			fdatasync().  i_atime is the usual cause.
> >  * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
> >  *			these changes separately from I_DIRTY_SYNC so that we
> >  *			don't have to write inode on fdatasync() when only
> >  *			mtime has changed in it.
> > 
> > This is important because ext4_sync_file() (which is called by fsync()
> > and fdatasync()) uses this logic to determine whether or not to call
> > sync_inode(), which is what will force a commit when wbc.sync_mode is
> > set to WB_SYNC_ALL.
>   Yes, this is exactly what I was trying to point out.
> 
> > In fact, I think the problem is worse than Jan is pointing out,
> > because it's not enough that vfs_fq_alloc_space() is calling
> > mark_inode_dirty(), since that only sets I_DIRTY_SYNC.  When we touch
> > i_size or i_block[], we need to make sure that I_DIRTY_DATASYNC is
> > set, so that fdatasync() will force a commit.
>   Actually no. mark_inode_dirty() dirties inode with I_DIRTY ==
> (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES) so it happens to work.
> The fact that quota *could* dirty the inode with I_DIRTY_SYNC only
> is right but that's a separate issue.
> 
> > I think the right thing to do is to create an
> > _ext[34]_mark_inode_dirty() which takes an extra argument, which
> > controls whether or not we set I_DIRTY_SYNC or I_DIRTY_DATASYNC.  In
> > fact, most of the time, we want to be setting I_DIRTY_DATASYNC, so we
> > should probably have ext[34]_mark_inode_dirty() call
> > _ext[34]_mark_inode_dirty() with I_DIRTY_DATASYNC, and then create a
> > ext[34]_mark_inode_nodatasync() version passes in I_DIRTY_SYNC.
> > 
> > This will cause pdflush to call ext4_write_inode() more frequently,
> > but pdflush calls write_inode with wait=0, and ext4_write_inode() is a
> > no-op in that case.
>   Thinking about it, it won't work so easily. The problem is that when
> pdflush decides to write the inode, it unconditionally clears dirty flags.
> We could redirty the inode in write_inode() but that's IMHO too ugly to
> bear it.

I am a little confused here, so pdflush could found the dirty inodes
(due to quota) but it doesn't force journal comminit and write the inode
to disk? 

Mingming

