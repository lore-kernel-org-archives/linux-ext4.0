From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 14:33:52 -0600
Message-ID: <20080910203352.GP3086@webber.adilger.int>
References: <20080825202250.GY3392@webber.adilger.int>
 <20080910124005.GA4563@wotan.suse.de> <20080910124934.GB4563@wotan.suse.de>
 <20080910134727.GA17498@infradead.org> <20080910140719.GQ21071@mit.edu>
 <20080910141102.GA22654@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46725 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYIJUef (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 16:34:35 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8AKYPU2000052
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 13:34:26 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6Z00C01VXB2A00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 10 Sep 2008 13:34:25 -0700 (PDT)
In-reply-to: <20080910141102.GA22654@infradead.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 10, 2008  10:11 -0400, Christoph Hellwig wrote:
> On Wed, Sep 10, 2008 at 05:49:34AM -0700, Mark Fasheh wrote:
> > * FIEMAP_FLAG_XATTR
> > If this flag is set, the extents returned will describe the inodes
> > extended attribute lookup tree, instead of it's data tree.
> 
> So does this actually make sense for any filesystem but XFS?  Still
> seems like a not too useful option for a highlevel generic interface.

You are being mislead by the use of "tree" in the description here.
Both ext3 and ext4 can already have 2 places to store xattr data (in
the inode and in a separate block).  It is likely that ext4 will add
the ability to store more xattr data in the future.  Would it be better
to just remove the use of "tree" and write:

* FIEMAP_FLAG_XATTR
If this flag is set, the extents returned will describe the inode's
extended attribute data, instead of the regular file data.

> > 	__u32	fe_device;   /* device number for extent */
> 
> As sayd before please kill thise one.  It doesn't make any sense at all
> for any merged or near mainline FS.  It'd be an utterly stupid
> lustre-specific hack that still doesn't make much sense.

I think this is short sighted.  Lustre is only one of several filesystems
that aggregate multiple underlying devices into a single filesystem.
Others include XFS, NFSv4, ZFS, chunkfs.  It would even be possible to
have FIEMAP return the underlying mapping for "normal" filesystems on
MD/LVM devices, but there are already endless roadblocks to the current
basic functionality that I didn't want to get that mixed in as well.

Even for "normal" filesystems that don't map multiple block devices,
having the fe_device field returned with FIEMAP makes sense for
applications like LILO that need it.

Just because we don't have (m)any filesystems using 64-bit inodes does
that mean we shouldn't have a stat() interface that supports it?

It's true that we started with FIEMAP for Lustre, and thought it would
be helpful to Linux as a whole (better than Solaris SEEK_HOLE/SEEK_DATA,
IMHO) and made sure we got input from many of the filesystem developers
during the design, and now it seems you want to rip out everything
that makes it useful to Lustre and any "future" filesystems that aren't
plain-old block-based filesystems.

> > * FIEMAP_EXTENT_NO_BYPASS
> > Direct access to the data in this extent is illegal or will have
> > undefined results.
> 
> Huh?  What is direct access?  Direct access as in bypassing the
> filesystem and writing to the blockdev directly always has undefined
> results.

Sure, but LILO still does it, as does dump(8).  There were a bunch of
people commenting on previous FIEMAP discussions that want to do this,
because it is "safe" according to their environment/usage/definition
of safe.  Just because you don't need to do it (nor do I, for that matter)
it doesn't mean that other people do not.

> > * FIEMAP_EXTENT_SECONDARY
> > The data for this extent is in secondary storage (e.g. HSM).  If the
> > data is not also in the filesystem, then FIEMAP_EXTENT_NO_BYPASS
> > should also be set.
> 
> No HSM in mainline, so please drop it.  We can add it once we get HSM
> support.

This was added because XFS_BMAP had it, and XFS is using HSM in some
environments as you well know.  #defining a flag that isn't used by the
core Linux code isn't going to kill anyone, and makes life a tiny bit
easier for Dave at zero cost to anyone else.

> > * FIEMAP_EXTENT_NET
> >   - This will also set FIEMAP_EXTENT_NO_BYPASS
> > The data for this extent is not stored in a locally-accessible device.
> 
> Doesn't make any sense currently, please drop.

Again, it doesn't hurt anyone to include this flag.  Filesystems like
CRFS will likely want to use this, in addition to Lustre of course.
It will likel also be useful for NFSv4.

You seem to think that the lack of any current in-kernel users means that
the API should be dumbed down until there is no room to grow, while I'd
prefer to design it in a way that ensures it won't be obsolete as soon
as someone thinks outside the "single local block device" box.

> > * FIEMAP_EXTENT_DATA_COMPRESSED
> >   - This will also set FIEMAP_EXTENT_NO_BYPASS
> > The data in this extent has been compressed by the file system.
> 
> Add once we have users for it.

A bunch of the cramfs/logfs/etc filesystems have compression support.
There were ext2/3 patches for compressed filesystems, and may be in
the future for btrfs as well.  It doesn't seem at all unreasonable to
define this.

> On Wed, Sep 10, 2008 at 10:07:19AM -0400, Theodore Tso wrote:
> > Interface minimalism to allow for flexibility later is one thing; but
> > taken to extremes, it it's just stupid.  For example, if we didn't
> > have any filesystems that needed 64-bit fields in mainline, would that
> > be a justification for making data structures to use 32-bit fields and
> > forcing a flag data interface change in the future.  Sometimes we can
> > look ahead just a little bit and design interfaces which are foward
> > compatible.  And it's pretty clear that btrfs will need something like
> > fe_device, although whether it should be a 32-bit index or something
> > else like a 128-bit UUID admittedly might not be clear at the moment.
> > But leaving room in the data structure for future growth is just a
> > intelligent thing to do.
> 
> No, if you look at btrfs or the not public bit for mirrored allocations
> groups in XFS you'll notice that an extent can be happily on more than
> once device.  So to support this we'd need a list of device plus a field
> for the algorithm how to balance it over the devices.

Actually, you misunderstand how the API is designed to be used.

Instead of having to return a list of devices for a single extent,
it would return an extent per device.  That is especially important
because the logical->physical mapping may be different for every extent.

Having simple flags for "RAID1", "RAID5", "RAID6" would cover most of
the cases, and in all cases setting NO_BYPASS for complex layouts
would avoid non-broken applications trying to access the data directly.
The majority of FIEMAP users will only be filefrag and other tools that
want to know relative locations of file data and some information about
the block layout (e.g. filesystem developers, performance tuning, etc),
they won't be trying to read from the raw block device.


To be honest, I don't know why there is such a huge objection to this
patch.  First it was ext4/Lustre specific, then people said "this is
generic stuff that should go into the VFS" and now people say "this
is too complex to be in the VFS as-is, let's make it dumb".  People
didn't present such an uproar when blktrace was added to the kernel,
people didn't complain about the EXT2_GETFLAGS ioctl that migrated
over to the VFS, even though it has flags not applicable to all
filesystems (or even applicable to ext* like NOTAIL, which was added
to e2fsprogs just for Reiserfs).

It's just an ioctl, folks.  We've spent 1000's of collective hours arguing
about minor changes in semantics, as if we were rewriting the whole VFS.
Christoph, if you really hate FIEMAP that much, it can just lose the
VFS changes entirely, and be implemented in ext4 as we like it and other
filesystem maintainers that want e2fsprogs filefrag to provide the improved
information can follow the implementation there if they want.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

