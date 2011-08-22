From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Tue, 23 Aug 2011 09:13:48 +1000
Message-ID: <20110822231348.GS3162@dastard>
References: <201108112329.23043.rjw@sisk.pl>
 <201108112331.13241.rjw@sisk.pl>
 <20110815122218.GB6971@quack.suse.cz>
 <201108152009.13776.rjw@sisk.pl>
 <20110815205807.GC16369@quack.suse.cz>
 <20110816000916.GH26978@dastard>
 <20110822130045.GC11264@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34798 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1HVXNx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Aug 2011 19:13:53 -0400
Content-Disposition: inline
In-Reply-To: <20110822130045.GC11264@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 22, 2011 at 03:00:45PM +0200, Pavel Machek wrote:
> Hi!
> 
> > >   What's exactly the problem? Memory preallocation enters direct reclaim
> > > and that deadlocks in the filesystem?
> > 
> > Well, that's one possible manifestation. The problem is that the
> > current hibernate code still assumes that sys_sync() results in an
> > idle filesystem that will not change after the call if nothing is
> > dirty.
> > 
> > The result is that when the large memory allocation occurs for the
> > hibernate image (after the sys_sync() call) then the shrink_slab()
> > tends to be called. The XFS shrinkers are capable of dirtying inodes
> > and the backing buffers of inodes that are in the reclaimable state.
> > But those buffers cannot be flushed to disk because hibernate has
> > already frozen the xfsbufd threads, so the shrinker doing inode
> > reclaim hangs up on locks waiting for the buffers to be written.
> > This either leads to deadlock or hibernate image allocation failure.
> > 
> > Far worse, IMO, is the case where is -doesn't- deadlock, because the
> > filesystem state can still changing after the allocation has
> > finished due to async metadata IO completions. That has the
> > potential to cause filesystem corruption as after resume the on-disk
> > state may not match what is written from memory to the hibernate
> > image.
> > 
> > The problem really isn't XFS specific, nor is it new - the fact is
> > that any filesystem that has registered a shrinker or can do async
> > work in the background post-sync is vulnerable to this problem. It's
> 
> Should we avoid calling shrinkers while hibernating?

If you like getting random OOM problems when hibernating, then go
for it.  Besides, shrinkers are used for more than just filesystems,
so you might find you screw entire classes of users by doing this
(eg everyone using intel graphics and 3D).

> Or put BUG_ON()s into filesystem shrinkers so that this can not
> happen?

Definitely not. If your concern is filesystem shrinkers and you want
a large hammer to hit the problem with then do your hibernate
image allocation wih GFP_NOFS and the filesystem shrinkers will
abort without doing anything.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
