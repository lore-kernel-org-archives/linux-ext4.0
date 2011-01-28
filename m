From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHSET] Refactor barrier=/nobarrier flags from fs to block
 layer
Date: Fri, 28 Jan 2011 22:16:29 +1100
Message-ID: <20110128111629.GW21311@dastard>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <4D400A44.6030502@redhat.com>
 <4D404EBF.8020508@redhat.com>
 <20110126172413.GG32261@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>,
	Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
	tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, hch@lst.de, josef@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47846 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab1A1LQu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Jan 2011 06:16:50 -0500
Content-Disposition: inline
In-Reply-To: <20110126172413.GG32261@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 26, 2011 at 09:24:13AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 26, 2011 at 10:41:35AM -0600, Eric Sandeen wrote:
> > On 1/26/11 5:49 AM, Ric Wheeler wrote:
> > > On 01/26/2011 02:12 AM, Darrick J. Wong wrote:
> > >> Hello,
> > >>
> > >>  From what I can tell, most of the filesystems that know how to issue commands
> > >> to flush the write cache also have some mechanism for the user to override
> > >> whether or not the filesystem actually issues those flushes.  Unfortunately,
> > >> the term "barrier" is obsolete having been changed into flushes in 2.6.36, and
> > >> many of the filesystems implement the mount options with slightly different
> > >> syntaxes (barrier=[0|1|none|flush], nobarrier, etc).
> > >>
> > >> This patchset adds to the block layer a sysfs knob that an administrator can
> > >> use to disable flushes, and removes the mount options from the filesystem code.
> > >> As a starting point, I'm removing the mount options and flush toggle from
> > >> jbd2/ext4.
> > >>
> > >> Anyway, I'm looking for some feedback about refactoring the barrier/flush
> > >> control knob into the block layer.  It sounds like we want a knob that picks
> > >> the safest option (issue flushes when supported) unless the administrator
> > >> decides that it is appropriate to do otherwise.  I suspect that there are good
> > >> arguments for not having a knob at all, and good arguments for a safe knob.
> > >> However, since I don't see the barrier options being removed en masse, I'm
> > >> assuming that we still want a knob somewhere.  Do we need the ignore_fua knob
> > >> too?  Is this the proper way to deprecate mount options out of filesystems?
> > >>
> > >> --D
> > > 
> > > Just to be clear, I strongly object to remove the mount options.
> > 
> > Agreed, we are just finally, barely starting to win the education battle here.
> > Removing or changing the option now will just set us back.  It should at
> > LEAST remain as a deprecated option, with the deprecation message pointing
> > to crystal-clear documentation.
> 
> Ok, how about a second proposal:
> 
> 1. Put the sysfs knob and the toggle code in the block layer, similar to patch
> #1, only make it a per-bdev toggle so each mount can have its own override
> parameters.

A sysfs knob just seems wrong for this. What do you do with
filesystems or block devices that span multiple block devices,
either via md, dm, mount options (XFS - separate data, log and
realtime devices) or other means (btrfs w/ multiple devices)? 

IMO, the only sane way to control this sort of behaviour is from the
top down (i.e. from the filesystem) and not from the bottom up (i.e.
from the lowest level of block devices) because the cache flushes
are only useful to the filesystem if they are consistently
implemented from the top of the storage stack to the bottom...

Also, if you allow block devices at the bottom of the stack to be
configured to ignore flushes dynamically, we need some method to
inform the upper layers that this has happened. At minimum the
filesystem needs to log the fact that their crash/power fail
consistency guarantees have changed - there's no way I'm going to
assume that users won't do something stupid if there's a knob to
tweak....

> 2. Add some sort of "nocacheflush" option to the VFS layer to adjust the knob.
> With this we gain a consistent mount option syntax across all the filesystems,
> though what it means for a networked fs is questionable.  I guess you could
> reject the mount option if there's no block device under the fs.  Also, any fs
> that someday grows an issue-flush feature won't have to add its own option
> parsing code.

We already have a relatively widely implemented mount option pair -
barrier/nobarrier is supported by ext3, ext4, btrfs, gfs2, xfs,
hfsplus and nilfs2 - so I'd suggest that this is the best paaaaaaah
to take for implementing a generic mount option...

> At umount time, do we undo whatever overrides we set up at mount time?  Seems
> sane to me, just wanted to run it by everyone.

Does it really matter? The next mount will set it to whatever is
necessary...

> 3. Change the per-fs option handling code to call the same code as the VFS'
> nocacheflush option.  Any fs that wants to deprecate its per-fs option handler
> can do so.  Or they can stay forever.
> 
> 4. Remove all the flush conditionals from the fs code in favor of letting the
> block layer handle it.
>
> Hopefully "nocacheflush" is a little more obvious.

What cache does "nocacheflush" refer to? The page, inode, dentry, or
buffer caches? Or some other per filesystem cache? Perhaps the MD
stripe cache? Maybe something else? There are many different caches
in a storage system even before we consider hardware, so I think
"nocacheflush" is much more ambiguous than barrier/nobarrier...

Just my 2c worth....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
