From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Fri, 19 Nov 2010 01:45:52 +0100
Message-ID: <20101119004552.GF5004@quack.suse.cz>
References: <20101116110058.GA4298@amd>
 <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0KSAp4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 19:45:56 -0500
Content-Disposition: inline
In-Reply-To: <20101117222834.2bb36ee1.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 17-11-10 22:28:34, Andrew Morton wrote:
> I'm not sure that s_umount versus i_mutex has come up before.
> 
> Logically I'd expect i_mutex to nest inside s_umount.  Because s_umount
> is a per-superblock thing, and i_mutex is a per-file thing, and files
> live under superblocks.  Nesting s_umount outside i_mutex creates
> complex deadlock graphs between the various i_mutexes, I think.
> 
> Someone tell me if btrfs has the same bug, via its call to
> writeback_inodes_sb_nr_if_idle()?
> 
> I don't see why these functions need s_umount at all, if they're called
> from within ->write_begin against an inode on that superblock.  If the
> superblock can get itself disappeared while we're running ->write_begin
> on it, we have problems, no?
  As I wrote to Chris, the function just needs exclusion from umount /
remount happening (and want to stop umount from returning EBUSY when
writeback thread is writing something out). When the function is called
from ->write_begin this is no issue as you properly noted so s_umount is
not needed in that particular case.

> In which case I'd suggest just removing the down_read(s_umount) and
> specifying that the caller must pin the superblock via some means.
  Possibly, but currently the advantage is that we can have WARN_ON in the
writeback code that complains if someone starts writeback without properly
pinned superblock and we cannot easily do that with your general rule. I'm
not saying that should stop us from changing the rule but it was kind of
nice.

> Only we can't do that because we need to hold s_umount until the
> bdi_queue_work() worker has done its work.
> 
> The fact that a call to ->write_begin can randomly return with s_umount
> held, to be randomly released at some random time in the future is a
> bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
> thing.
  I guess you missed that writeback_inodes_sb_nr() (called from _if_idle
variants) does:
        bdi_queue_work(sb->s_bdi, &work);
        wait_for_completion(&done);
  So we return only after all the IO has been submitted and unlock s_umount
in writeback_inodes_sb_if_idle(). And we cannot really submit the IO ourselves
because we are holding i_mutex and we need to get and put references
to other inodes while doing writeback (those would be really horrible lock
dependencies - writeback thread can put the last reference to an unlinked
inode...).

In fact, as I'm speaking about it, pushing things to writeback thread and
waiting on the work does not help a bit with the locking issues (we didn't
wait for the work previously but that had other issues). Bug, sigh.

What might be better interface for usecases like above is to allow
filesystem to kick flusher thread to start doing background writeback
(regardless of dirty limits). Then the caller can wait for some delayed
allocation reservations to get freed (easy enough to check in
->writepage() and wake the waiters) - possibly with a reasonable timeout
so that we don't stall forever.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
