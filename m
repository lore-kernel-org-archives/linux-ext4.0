From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] blkid detection for ZFS
Date: Thu, 21 Feb 2008 02:20:26 -0700
Message-ID: <20080221092026.GW3029@webber.adilger.int>
References: <20080215010740.GZ3029@webber.adilger.int>
 <20080220125743.GA29298@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49916 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbYBUJU3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2008 04:20:29 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1L9KSo4015272
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 01:20:28 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWL00B010ETLO00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 21 Feb 2008 01:20:28 -0800 (PST)
In-reply-to: <20080220125743.GA29298@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 20, 2008  07:57 -0500, Theodore Ts'o wrote:
> On Thu, Feb 14, 2008 at 06:07:40PM -0700, Andreas Dilger wrote:
> > Some input is welcome here also...  There is a UUID (GUID) for the whole
> > "pool" (aggregation of devices that ZFS filesystems might live on), a
> > UUID for the "virtual device" (vdev) (akin to MD RAID set) that a disk
> > is part of and also a separate UUID for each device.  There is a LABEL
> > (pool name) for the whole pool, but not one for an individual filesystem.
> 
> Are there devices for that are made available for the vdev and the
> pool?  I assume not for the pool since that's a filesystem entity, but
> what about the vdev?
> 
> In general, blkid is all about mapping the UUID of what lives on the
> device to the device filename, for the benefit of programs like mount
> and fsck.
> 
> I don't know enough about ZFS in terms of how you would mount a
> filesystem which is part of a pool.  How is the filesystem specified
> to the "mount" command?

Good question.  For Lustre (linux or Solaris), we want to be able to find
the pool by name, and then use ZFS tools to "import" the pool and make the
filesystems available to Lustre.  The current ZFS tools (as ported to
Linux) scan all of /dev/* directly, but I'd much prefer to use libblkid
for that since it knows about PVs, RAID devices, etc.

Filesystems in a ZFS pool are specified via "{poolname}/{fsname}", but
to get "fsname" from disk is much more involved than I want to get,
since it almost involves importing the pool and parsing a whole tree
of parameters and indexes.

I'd be pretty happy to just know from "blkid" that a given device is
used by ZFS for "lustrepool" or "fusepool" or whatever it is called.

> So it would seem to me that it would be better to make the UUID be for
> a particular ZFS physical disk be the UUID for that disk, and not for
> the whole pool.  The question really, though, is what actually would
> be most useful --- who is going to actually use blkid on a Solaris
> system with ZFS?  It may be that the right answer is to put the pool
> UUID as a separate tag; blkid supports more than just the standard
> LABEL, UUID, TYPE, etc. tags.  You could easily stash the pool UUID in
> a POOL_GUID tag, if it would be useful for some blkid callers.

OK, maybe I'll go that route, since I won't stricly be having UUIDs
or LABELs that directly map to filesystems.
> 
> > On a related note - on Solaris the ZFS filesystems always live in a GPT
> > partition table, and I note that libblkid doesn't identify this.  Is that
> > something we want to start adding to libblkid (e.g. GPT, DOS, LVM, etc)?
> 
> What do you mean by not identifying the GPT partition table?  At the
> moment we haven't been identifying the whole disk partition tables,
> mainly becuase there isn't much use for it especially for the DOS MBR
> (no uuid or label to speak of).
> 
> I just checked in a patch from Eric to detect LVM2 PV's, because it
> was useful for the Anaconda developers.  I wouldn't have any
> objections accepting a patch which detected the whole-disk device and
> returned the GPT label/UUID information, but I probably wouldn't code
> it myself.  Still, if it someone thought it was *useful* and would use
> it, and thus felt called to write a patch, I'd certainly accept it.

That was my question.  I didn't see the LVM2 identification patch until
after my email, but this makes it fairly clear that identification of
block devices isn't verboten.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
