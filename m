From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 09:58:31 -0800
Message-ID: <20101118095831.b9331e93.akpm@linux-foundation.org>
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
	<20101118081822.GA9186@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220Ab0KRSDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 13:03:04 -0500
In-Reply-To: <20101118081822.GA9186@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 18 Nov 2010 19:18:22 +1100 Nick Piggin <npiggin@kernel.dk> wrote:

> On Wed, Nov 17, 2010 at 10:28:34PM -0800, Andrew Morton wrote:
>  
> > Logically I'd expect i_mutex to nest inside s_umount.  Because s_umount
> > is a per-superblock thing, and i_mutex is a per-file thing, and files
> > live under superblocks.  Nesting s_umount outside i_mutex creates
> > complex deadlock graphs between the various i_mutexes, I think.
> 
> You mean i_mutex outside s_umount?
> 

Nope.  i_mutex should nest inside s_umount.  Just as inodes nest inside
superblocks!  Seems logical to me ;)

> > Someone tell me if btrfs has the same bug, via its call to
> > writeback_inodes_sb_nr_if_idle()?
> > 
> > I don't see why these functions need s_umount at all, if they're called
> > from within ->write_begin against an inode on that superblock.  If the
> > superblock can get itself disappeared while we're running ->write_begin
> > on it, we have problems, no?
> > 
> > In which case I'd suggest just removing the down_read(s_umount) and
> > specifying that the caller must pin the superblock via some means.
> > 
> > Only we can't do that because we need to hold s_umount until the
> > bdi_queue_work() worker has done its work.
> > 
> > The fact that a call to ->write_begin can randomly return with s_umount
> > held, to be randomly released at some random time in the future is a
> > bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
> > thing.
> 
> Yeah that whole writeback_inodes_if_idle is nasty
> 
>  
> > It'd be better if we pinned these superblocks via refcounting, not via
> > holding s_umount but even then, having ->write_begin randomly bump sb
> > refcounts for random periods of time is still pretty ugly.
> > 
> > What a pickle.
> > 
> > Can we just delete writeback_inodes_sb_nr_if_idle() and
> > writeback_inodes_sb_if_idle()?  The changelog for 17bd55d037a02 is
> > pretty handwavy - do we know that deleting these things would make a
> > jot of difference?
> > 
> > And why _do_ we need to hold s_umount during the bdi_queue_work()
> > handover?  Would simply bumping s_count suffice?
> 
> s_count just prevents it from going away, but s_umount is still needed
> to keep umount, remount,ro, freezing etc activity away. I don't think
> there is an easy way to do it.
> 
> Perhaps filesystem should have access to the dirty throttling path, kick
> writeback or delayed allocation etc as needed, and throttle against
> outstanding work that needs to be done, going through the normal
> writeback paths?

I just cannot believe that we need s_mount inside ->write_begin.  Is it
really the case that someone can come along and unmount or remount or
freeze our filesystem while some other process is down performing a
->write_begin against one of its files?  Kidding?
