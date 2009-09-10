From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: fsync on ext[34] working only by an accident
Date: Thu, 10 Sep 2009 21:55:13 +0530
Message-ID: <20090910162513.GB5321@skywalker.linux.vnet.ibm.com>
References: <20090908132601.GA17778@duck.suse.cz>
 <20090910064605.GA8690@skywalker.linux.vnet.ibm.com>
 <20090910085056.GA607@duck.suse.cz>
 <20090910090449.GA11418@skywalker.linux.vnet.ibm.com>
 <20090910091551.GB11418@skywalker.linux.vnet.ibm.com>
 <20090910105216.GG607@duck.suse.cz>
 <20090910110455.GA17531@skywalker.linux.vnet.ibm.com>
 <20090910131007.GC31907@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:42397 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZIJQZW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 12:25:22 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8AGPMTR011634
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 21:55:22 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8AGPMif2748464
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 21:55:22 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8AGPMQG024749
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 02:25:22 +1000
Content-Disposition: inline
In-Reply-To: <20090910131007.GC31907@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 09:10:07AM -0400, Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 04:34:55PM +0530, Aneesh Kumar K.V wrote:
> > mark_buffer_dirty -> __set_page_dirty -> __mark_inode_dirty
> 
> We need to be careful here.  First of all, mark_buffer_dirty() on the
> code paths you are talking about is being passed a metadata buffer
> head.  As such, has Jan has pointed out, the bh is part of the buffer
> cache, so the page->mapping of associated with bh->b_page is the inode
> of the block device --- *not* the ext4 inode.
> 
> Secondly, __set_page_dirty calls __mark_inode_dirty passing in
> I_DIRTY_PAGES --- which should be a hint.  What Jan is talking about
> is where we set the inode flags I_DIRTY_SYNC and I_DIRTY_DATASYNC:
> 
>  * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
>  *			fdatasync().  i_atime is the usual cause.
>  * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
>  *			these changes separately from I_DIRTY_SYNC so that we
>  *			don't have to write inode on fdatasync() when only
>  *			mtime has changed in it.
> 
> This is important because ext4_sync_file() (which is called by fsync()
> and fdatasync()) uses this logic to determine whether or not to call
> sync_inode(), which is what will force a commit when wbc.sync_mode is
> set to WB_SYNC_ALL.
> 
> In fact, I think the problem is worse than Jan is pointing out,
> because it's not enough that vfs_fq_alloc_space() is calling
> mark_inode_dirty(), since that only sets I_DIRTY_SYNC.  When we touch
> i_size or i_block[], we need to make sure that I_DIRTY_DATASYNC is
> set, so that fdatasync() will force a commit.
> 

That explained it pretty nicely. Thanks

-aneesh
