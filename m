From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Fri, 19 Nov 2010 16:10:04 +1100
Message-ID: <20101119051004.GD3284@amd>
References: <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
 <20101118081822.GA9186@amd>
 <20101118095831.b9331e93.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:31283 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab0KSFKL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 00:10:11 -0500
Content-Disposition: inline
In-Reply-To: <20101118095831.b9331e93.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 09:58:31AM -0800, Andrew Morton wrote:
> On Thu, 18 Nov 2010 19:18:22 +1100 Nick Piggin <npiggin@kernel.dk> wrote:
> 
> > On Wed, Nov 17, 2010 at 10:28:34PM -0800, Andrew Morton wrote:
> >  
> > > Logically I'd expect i_mutex to nest inside s_umount.  Because s_umount
> > > is a per-superblock thing, and i_mutex is a per-file thing, and files
> > > live under superblocks.  Nesting s_umount outside i_mutex creates
> > > complex deadlock graphs between the various i_mutexes, I think.
> > 
> > You mean i_mutex outside s_umount?
> > 
> 
> Nope.  i_mutex should nest inside s_umount.  Just as inodes nest inside
> superblocks!  Seems logical to me ;)

Right, but your last sentence seemed to suggest that the natural
ordering creates deadlocks :)

 
> > > And why _do_ we need to hold s_umount during the bdi_queue_work()
> > > handover?  Would simply bumping s_count suffice?
> > 
> > s_count just prevents it from going away, but s_umount is still needed
> > to keep umount, remount,ro, freezing etc activity away. I don't think
> > there is an easy way to do it.
> > 
> > Perhaps filesystem should have access to the dirty throttling path, kick
> > writeback or delayed allocation etc as needed, and throttle against
> > outstanding work that needs to be done, going through the normal
> > writeback paths?
> 
> I just cannot believe that we need s_mount inside ->write_begin.  Is it
> really the case that someone can come along and unmount or remount or
> freeze our filesystem while some other process is down performing a
> ->write_begin against one of its files?  Kidding?

Not for the work handoff either? If that is all waited on synchronously
before ->write_end returns, then no we shouldn't need any more locks
of course.

But asynch writeout needs a mutex rather than refcount so the umount
has something to block against and not just fail.

