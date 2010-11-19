From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Fri, 19 Nov 2010 16:16:19 +1100
Message-ID: <20101119051619.GE3284@amd>
References: <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
 <20101119004552.GF5004@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@kernel.dk>, Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6694 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab0KSFQ0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 00:16:26 -0500
Content-Disposition: inline
In-Reply-To: <20101119004552.GF5004@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 01:45:52AM +0100, Jan Kara wrote:
> On Wed 17-11-10 22:28:34, Andrew Morton wrote:
> > The fact that a call to ->write_begin can randomly return with s_umount
> > held, to be randomly released at some random time in the future is a
> > bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
> > thing.
>   I guess you missed that writeback_inodes_sb_nr() (called from _if_idle
> variants) does:
>         bdi_queue_work(sb->s_bdi, &work);
>         wait_for_completion(&done);
>   So we return only after all the IO has been submitted and unlock s_umount
> in writeback_inodes_sb_if_idle(). And we cannot really submit the IO ourselves
> because we are holding i_mutex and we need to get and put references
> to other inodes while doing writeback (those would be really horrible lock
> dependencies - writeback thread can put the last reference to an unlinked
> inode...).

But if we're waiting for it, with the lock held, then surely it can
deadlock just the same as if we submit it ourself?

BTW. are you taking i_mutex inside writeback? I mutex can be held
while entering page reclaim, and thus writepage... so it could be a
bug too.
 

> In fact, as I'm speaking about it, pushing things to writeback thread and
> waiting on the work does not help a bit with the locking issues (we didn't
> wait for the work previously but that had other issues). Bug, sigh.
> 
> What might be better interface for usecases like above is to allow
> filesystem to kick flusher thread to start doing background writeback
> (regardless of dirty limits). Then the caller can wait for some delayed
> allocation reservations to get freed (easy enough to check in
> ->writepage() and wake the waiters) - possibly with a reasonable timeout
> so that we don't stall forever.

We really need to throttle the producer without any locks held, no?
So the filesystem would like to to hook into dirtying path somewhere
without i_mutex held (and without implementing your own .write). Eg.
around the dirty throttling calls somewhere I suppose.

