From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid detection for ZFS
Date: Wed, 20 Feb 2008 07:57:43 -0500
Message-ID: <20080220125743.GA29298@mit.edu>
References: <20080215010740.GZ3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60404 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763967AbYBTM5t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Feb 2008 07:57:49 -0500
Content-Disposition: inline
In-Reply-To: <20080215010740.GZ3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 14, 2008 at 06:07:40PM -0700, Andreas Dilger wrote:
> Some input is welcome here also...  There is a UUID (GUID) for the whole
> "pool" (aggregation of devices that ZFS filesystems might live on), a
> UUID for the "virtual device" (vdev) (akin to MD RAID set) that a disk
> is part of and also a separate UUID for each device.  There is a LABEL
> (pool name) for the whole pool, but not one for an individual filesystem.

Are there devices for that are made available for the vdev and the
pool?  I assume not for the pool since that's a filesystem entity, but
what about the vdev?

In general, blkid is all about mapping the UUID of what lives on the
device to the device filename, for the benefit of programs like mount
and fsck.

I don't know enough about ZFS in terms of how you would mount a
filesystem which is part of a pool.  How is the filesystem specified
to the "mount" command?

> I'm thinking of making the blkid UUID be the GUID of the whole pool, as
> any device in the pool would be sufficient to locate all of the component
> devices.  This means all devices in the same pool will return the same
> UUID, but for identification that should be fine I think...  I haven't
> checked for pathologies in libblkid regarding that yet.

What I did with the freshly checked in code to identify LVM2 volumes
is that if /dev/sda1 is part of a physical volume, then blkid returns
the UUID for the PV for /dev/sda1.  The filesystem UUID's end up
getting associated via blkid entries for /dev/mapper/FOO, and we don't
bother trying to associate the UUID for the raidset with anything,
since it's not really associated with a physical block device.

So it would seem to me that it would be better to make the UUID be for
a particular ZFS physical disk be the UUID for that disk, and not for
the whole pool.  The question really, though, is what actually would
be most useful --- who is going to actually use blkid on a Solaris
system with ZFS?  It may be that the right answer is to put the pool
UUID as a separate tag; blkid supports more than just the standard
LABEL, UUID, TYPE, etc. tags.  You could easily stash the pool UUID in
a POOL_GUID tag, if it would be useful for some blkid callers.

> On a related note - on Solaris the ZFS filesystems always live in a GPT
> partition table, and I note that libblkid doesn't identify this.  Is that
> something we want to start adding to libblkid (e.g. GPT, DOS, LVM, etc)?

What do you mean by not identifying the GPT partition table?  At the
moment we haven't been identifying the whole disk partition tables,
mainly becuase there isn't much use for it especially for the DOS MBR
(no uuid or label to speak of).

I just checked in a patch from Eric to detect LVM2 PV's, because it
was useful for the Anaconda developers.  I wouldn't have any
objections accepting a patch which detected the whole-disk device and
returned the GPT label/UUID information, but I probably wouldn't code
it myself.  Still, if it someone thought it was *useful* and would use
it, and thus felt called to write a patch, I'd certainly accept it.

Regards,

						- Ted
