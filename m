From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Tue, 16 Aug 2011 20:20:07 +0200
Message-ID: <201108162020.07344.rjw@sisk.pl>
References: <201108112329.23043.rjw@sisk.pl> <20110815205807.GC16369@quack.suse.cz> <20110816000916.GH26978@dastard>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45540 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HPSSX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 14:18:23 -0400
In-Reply-To: <20110816000916.GH26978@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, August 16, 2011, Dave Chinner wrote:
> On Mon, Aug 15, 2011 at 10:58:07PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> > On Mon 15-08-11 20:09:13, Rafael J. Wysocki wrote:
> > > On Monday, August 15, 2011, Jan Kara wrote:
> > > >   BTW,  filesystem freezing never really worked for mmaped writes under
> > > > ext3 - ext3 would have to implement page_mkwrite() callback for that - so
> > > > if you want to rely on it for suspending, this will be non-trivial.
> > > 
> > > At this point the purpose of freezing filesystems is basically to
> > > prevent XFS from deadlocking with hibernation's memory preallocation.
> > > For other filesystems it may or may not make a difference depending on
> > > their implementation of freeze/unfreeze_super().
> >   What's exactly the problem? Memory preallocation enters direct reclaim
> > and that deadlocks in the filesystem?
> 
> Well, that's one possible manifestation. The problem is that the
> current hibernate code still assumes that sys_sync() results in an
> idle filesystem that will not change after the call if nothing is
> dirty.
> 
> The result is that when the large memory allocation occurs for the
> hibernate image (after the sys_sync() call) then the shrink_slab()
> tends to be called. The XFS shrinkers are capable of dirtying inodes
> and the backing buffers of inodes that are in the reclaimable state.
> But those buffers cannot be flushed to disk because hibernate has
> already frozen the xfsbufd threads, so the shrinker doing inode
> reclaim hangs up on locks waiting for the buffers to be written.
> This either leads to deadlock or hibernate image allocation failure.
> 
> Far worse, IMO, is the case where is -doesn't- deadlock, because the
> filesystem state can still changing after the allocation has
> finished due to async metadata IO completions. That has the
> potential to cause filesystem corruption as after resume the on-disk
> state may not match what is written from memory to the hibernate
> image.
> 
> The problem really isn't XFS specific, nor is it new - the fact is
> that any filesystem that has registered a shrinker or can do async
> work in the background post-sync is vulnerable to this problem. It's
> just that XFS is the filesystem that usually exposes such issues, so
> it gets blamed for causing the problem....

I'm not saying it's XFS' fault.  It's just that XFS tends to do things
that other filesystems don't do and that expose the problem in the
hibernate code.

Thanks,
Rafael
