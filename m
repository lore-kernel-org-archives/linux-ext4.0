From: Shapor Naghibzadeh <shapor@shapor.com>
Subject: Re: poor performance of mount due to libblkid
Date: Wed, 9 May 2007 23:45:32 -0500
Message-ID: <20070509234532.D12805@cbr.shaptech.com>
References: <20070509170646.C12805@cbr.shaptech.com> <20070510003005.GV6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cbr.shaptech.com ([64.246.26.67]:53510 "EHLO cbr.shaptech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbXEJEhe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 May 2007 00:37:34 -0400
Content-Disposition: inline
In-Reply-To: <20070510003005.GV6375@schatzie.adilger.int>; from adilger@clusterfs.com on Wed, May 09, 2007 at 05:30:05PM -0700
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 09, 2007 at 05:30:05PM -0700, Andreas Dilger wrote:
> Is there something unusual about your system or startup scripts that is
> causing so many entries in /etc/blkid.tab file?

This issue came up while doing development work on a snapshot and remote
replication project called zumastor (http://zumastor.googlepages.com).  Every
snapshot is assigned a new snapshot id, and over time the blkid.tab gets
polluted with device mapper devices of snapshots that no longer exist named
/dev/mapper/vol(n), where n is the snapshot id.  It is perfectly reasonable
to be able to create, mount, umount, and remove devices without anything left
behind.  See the shell script at http://www.shapor.com/libblkid/ for a watered
down 10 line test case (using dm-linear).

> > libblkid api nor blkid command line appear to even provide a facility for
> > removing entries if you wanted to do so manually on device removal.
> 
> Using "blkid -c /dev/null" skips the cache load, but I also see it doesn't
> write out a new /etc/blkid.tab file.

At that point you might as well rm /etc/blkid.tab.  If removing the file
randomly has no effect on anything, just do without it.  Its pretty obvious
that it doesn't save I/O or cpu cycles.

> > Combined with no (reasonable) bound on the size of the blkid.tab file, this
> > causes the mount command to get slower over time.  To make matters worse, the
> > cost of reading the file in to memory is n-squared (which happens every time
> > the mount command is run, even with "-h" for help!).
> 
> I hadn't looked at that previously (it's been a long time since I looked
> at the blkid code), and I also don't have the mount code handy.  Can you
> be more specific? 

Sure.  As blkid_read_cache reads the blkid.tab file, it ends up calling
blkid_get_dev for every device name it parses.  blkid_get_dev does a linear
search on the blkid_cache using strcmp() on each existing entry before adding
the new one, hence the n-squared running time.  The graph I generated visualizes
this quite nicely.

> The reason for libblkid is twofold:
> - centralize the detection of filesystem types into one library

Sounds like a good idea, but it attempts to do far more.

> - allow userspace applications to find device content type without needing
>   root or read access to the device (hence reason for /etc/blkid.tab)

A quick 'apt-cache rdepends libblkid1' on Ubuntu returns only the following:
pysdm loop-aes-utils dump ocfs2console mount libblkid-dev e2fsprogs
I don't think any of those are intended to be used by anyone other than root.

Why not just look in /proc/mounts anyway?  If its an unmounted device, you
must be root in order to do anything with it.  The corner-case of a normal
user wanting to know the type of filesystem located on a device which was
once mounted doesn't make it worth it.  It sounds like a solution for a
non-problem.

It also has the potential to introduce security issues.  Its now possible for
any user to know the volume label of any usb storage device ever connected to
the machine, for example.  I doubt users or administrators expect such
behavior.

> > It doesn't even seem to
> > help the normal case, and really hurts the worst case badly.  If mount is to
> > use the file, it should scan through it only in the case it is actually
> > trying to detect the filesystem type, and stop when it finds the entry.
> 
> That makes a lot of sense, but that should be sent to the mount(8) maintainer.

The problem is that libblkid doesn't provide that without a n^2 worst case (see
above).  If the goal is to centralize the detection of filesystem types, it
must be used by mount and shouldn't do anything else unless specifically asked
to.

> > 3) The use of XML in /etc is not very unixy.  It is difficult for both
> > computers and humans to parse.
> 
> Yeah, but when I wrote it that was what people told me to use.  I guess the
> late 90's was the time when XML was cool.  I don't think people would complain
> too loudly if the blkid code was changed to have a plain-text formatted file,
> so long as that was not initially the default, and the XML parsing support was
> kept around for a while to allow apps which are statically linked to libblkid
> to continue working.

XML was never cool in my book, especially not anywhere in /etc. ;)  I don't
see a compelling reason to keep the file around in any format.  Switching to
plain text doesn't address garbage collecting of removed devices.

This definitely worth fixing.  I'd be willing to help rid the Linux world of
this unix philosophy atrocity.

Shapor
