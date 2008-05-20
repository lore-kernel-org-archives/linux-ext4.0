From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] JBD: Fix DIO EIO error caused by race between free  buffer and commit trasanction
Date: Tue, 20 May 2008 11:30:21 +0200
Message-ID: <20080520093020.GL22369@kernel.dk>
References: <20080514170856.GH24363@duck.suse.cz> <1210786872.3657.48.camel@localhost.localdomain> <20080514181444.GI24363@duck.suse.cz> <1210947250.3608.18.camel@localhost.localdomain> <1210957976.4231.31.camel@badari-desktop> <1210971693.3608.46.camel@localhost.localdomain> <20080518223739.GB11006@atrey.karlin.mff.cuni.cz> <1211227158.3663.25.camel@localhost.localdomain> <20080519132553.de9b78b0.akpm@linux-foundation.org> <1211234829.3663.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	pbadari@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:5054 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYETJaZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 05:30:25 -0400
Content-Disposition: inline
In-Reply-To: <1211234829.3663.39.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 19 2008, Mingming Cao wrote:
> On Mon, 2008-05-19 at 13:25 -0700, Andrew Morton wrote:
> > On Mon, 19 May 2008 12:59:18 -0700
> > Mingming Cao <cmm@us.ibm.com> wrote:
> > 
> > > On Mon, 2008-05-19 at 00:37 +0200, Jan Kara wrote:
> > > >   Hi,
> > > > 
> > > > > This patch fixed a few races between direct IO and kjournald commit
> > > > > transaction.  An unexpected EIO error gets returned to direct IO
> > > > > caller when it failed to free those data buffers. This could be
> > > > > reproduced easily with parallel direct write and buffered write to the
> > > > > same file
> > > > > 
> > > > > More specific, those races could cause journal_try_to_free_buffers()
> > > > > fail to free the data buffers, when jbd is committing the transaction
> > > > > that has those data buffers on its t_syncdata_list or t_locked_list.
> > > > > journal_commit_transaction() still holds the reference to those
> > > > > buffers before data reach to disk and buffers are removed from the
> > > > > t_syncdata_list of t_locked_list. This prevent the concurrent
> > > > > journal_try_to_free_buffers() to free those buffers at the same time,
> > > > > but cause EIO error returns back to direct IO.
> > > > > 
> > > > > With this patch, in case of direct IO and when try_to_free_buffers() failed,
> > > > > let's waiting for journal_commit_transaction() to finish
> > > > > flushing the current committing transaction's data buffers to disk, 
> > > > > then try to free those buffers again.
> > > >   If Andrew or Christoph wouldn't beat you for "inventive use" of
> > > > gfp_mask, I'm fine with the patch as well ;). You can add
> > > >   Acked-by: Jan Kara <jack@suse.cz>
> > > > 
> > > 
> > > This is less intrusive way to fix this problem. The gfp_mask was marked
> > > as unused in try_to_free_page(). I looked at filesystems in the kernel,
> > > there is only a few defined releasepage() callback, and only xfs checks
> > > the flag(but not used). btrfs is actually using it though. I thought
> > > about the way you have suggested, i.e.clean up this gfp_mask and and
> > > replace with a flag.  I am not entirely sure if it we need to change the
> > > address_space_operations and fix all the filesystems for this matter.
> > > 
> > > Andrew, what do you think? Is this approach acceptable? 
> > > 
> > 
> > <wakes up>
> > 
> > Please ensure that the final patch is sufficiently well changelogged to
> > permit me to remain asleep ;)
> :-)
> > The ->releasepage semantics are fairly ad-hoc and have grown over time.
> > It'd be nice to prevent them from becoming vaguer than they are.
> > 
> > It has been (approximately?) the case that code paths which really care
> > about having the page released will set __GFP_WAIT (via GFP_KERNEL)
> > whereas code paths which are happy with best-effort will clear
> > __GFP_WAIT (with a "0').  And that's reasonsable - __GFP_WAIT here
> > means "be synchronous" whereas !__GFP_WAIT means "be non-blocking".
> > 
> 
> This make sense to me.
> 
> > Is that old convention not sufficient here as well?  Two problem areas
> > I see are mm/vmscan.c and fs/splice.c (there may be others).
> > 
> 
> > In mm/vmscan.c we probably don't want your new synchronous behaviour
> > and it might well be deadlockable anyway.  No probs, that's what
> > __GFP_FS is for.
> > 
> Sure. We could check __GFP_FS and __GFP_WAIT, and that make sense.
> 
> > In fs/splice.c, reading the comment there I have a feeling that you've
> > found another bug, and that splice _does_ want your new synchronous
> > behaviour?
> 
> Yes, it looks like page_cache_pipe_buf_steal() expects page is free
> before removeing it by passing the GFP_KERNEL flag, but currently ext3
> could fails to releasepage when it called. In fact
> try_to_release_page() return value is ignored in
> page_cache_pipe_buf_steal(), should probably checked the failure case.
> 
> 
> The other caller of try_to_release_page() in mm/splice.c is
> fallback_migrate_page(), which does want the synchronous behaviour to
> make sure buffers are dropped.

So something like this, then?

diff --git a/fs/splice.c b/fs/splice.c
index 7815003..e08a2f5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -58,8 +58,8 @@ static int page_cache_pipe_buf_steal(struct pipe_inode_info *pipe,
 		 */
 		wait_on_page_writeback(page);
 
-		if (PagePrivate(page))
-			try_to_release_page(page, GFP_KERNEL);
+		if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+			goto out_unlock;
 
 		/*
 		 * If we succeeded in removing the mapping, set LRU flag
@@ -75,6 +75,7 @@ static int page_cache_pipe_buf_steal(struct pipe_inode_info *pipe,
 	 * Raced with truncate or failed to remove page from current
 	 * address space, unlock and return failure.
 	 */
+out_unlock:
 	unlock_page(page);
 	return 1;
 }

-- 
Jens Axboe

