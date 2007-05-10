From: Theodore Tso <tytso@mit.edu>
Subject: Re: poor performance of mount due to libblkid
Date: Thu, 10 May 2007 02:44:48 -0400
Message-ID: <20070510064448.GA13450@thunk.org>
References: <20070509170646.C12805@cbr.shaptech.com> <20070510003005.GV6375@schatzie.adilger.int> <20070509234532.D12805@cbr.shaptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Shapor Naghibzadeh <shapor@shapor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48712 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756AbXEJGoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 May 2007 02:44:55 -0400
Content-Disposition: inline
In-Reply-To: <20070509234532.D12805@cbr.shaptech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 09, 2007 at 11:45:32PM -0500, Shapor Naghibzadeh wrote:
> This issue came up while doing development work on a snapshot and remote
> replication project called zumastor (http://zumastor.googlepages.com).  Every
> snapshot is assigned a new snapshot id, and over time the blkid.tab gets
> polluted with device mapper devices of snapshots that no longer exist named
> /dev/mapper/vol(n), where n is the snapshot id.  

OK, this was not a use case we had anticipated --- that there would be
a large number of throwaway devices which would appear and then
disappear, never to be seen again.  Normally device names don't change
like this, which is why blkid doesn't end up recording "the volume
label of any usb storage device ever connected to the machine", as you
put it.  The device names of USB storage devices end up getting
reused, so in practice what is in blkid.tab is merely the last storage
device that was plugged in, not every single one going back forever.
The problem is that zumastor is creating names that aren't being
reused, and creating more and more of them.  That's clearly a problem.

One easy way of solving this problem is when we're parsing the file,
try to stat the device file, and if it doesn't exist, to skip parsing
the line together.  This would prevent blkid.tab from growing without
bound given your workload.

> Sure.  As blkid_read_cache reads the blkid.tab file, it ends up
> calling blkid_get_dev for every device name it parses.
> blkid_get_dev does a linear search on the blkid_cache using strcmp()
> on each existing entry before adding the new one, hence the
> n-squared running time.  The graph I generated visualizes this quite
> nicely.

Yes, we need to add a better in-memory representation for the
blkid.tab file so we don't have to do a linear scan to do the insert.

> > The reason for libblkid is twofold:
> > - centralize the detection of filesystem types into one library
> 
> > - allow userspace applications to find device content type without needing
> >   root or read access to the device (hence reason for /etc/blkid.tab)

Actually, Andreas missed the most important reason for libblkid, which
was to speed up mount-by-label.  Before libblkid, if you have 300
filesystems in /etc/fstab all with individual mount labels --- which
might be the case if you had a large storage array hooked up to your
system, for example --- there mount -a would be an n**2 operation
since the mount command for each filesystem would proceed to search
all devices looking for the matching label, since the volume label for
each device was not being cached.

So yes, the O(n**2) of memory operations was bad, but that didn't show
up in the case of a few hundred filesystems --- especially compared to
the old behavior of where it was O(n**2) disk operations to probe
multiple potential superblock locations for each filesyustem.  So
blkid was solving a very real problem.

The whole point of blkid.tab file was so that having searched all of
the devices to find the particular filesystem with a specified volume
label or UUID, that all of the information that was gathered doesn't
have to be searched a next time you need to do a mount-by-uuid or
mount-by-label.  And if you have a large number of disks that you
might have to potentially spin up, you definitely want to keep this
cache across boots, which is why we store it in /etc/blkid.tab.

> The problem is that libblkid doesn't provide that without a n^2
> worst case (see above).  If the goal is to centralize the detection
> of filesystem types, it must be used by mount and shouldn't do
> anything else unless specifically asked to.

The goal of libblkid is a lot more than that.  You're right though, it
would have been better if mount only tried to read in the blkid cache
file if it needs to do a mount-by-label.  If it is just trying to do a
probe of the filesystem type, the cache doesn't actually help that
much.  If the last modified entry in the cache is very recent, it will
skip revalidation of the entry, but most of the time we always
revalidate the cache information before we return it to the user.  (It
does take less work to revalidate a cache entry, since we don't have
to try all possible filesystem types, but instead we only need to
verify that the information in the blkid cache file is correct.)

> > > 3) The use of XML in /etc is not very unixy.  It is difficult for both
> > > computers and humans to parse.

The reason why I chose XML was that I wanted a format which was
relatively easily extensible.  In fact the XML parser used by blkid is
actually pretty lightweight.  I don't particularly care about whether
or not humans can parse it easily, since programmatically users should
always be going through the blkid library so it can verify the data in
the cache as being correct before returning it to the application.


So it sounds like the short-term fix is to simply add a test so that
if the device isn't present, we should just ignore the entry when we
read it into memory.  The longer-term fix is use a more sophisticated
in-core representation which doesn't have a linear search time, and so
that algorithms to detect multiple lines referring to the same device
don't take O(n**2).  We should also fix mount to avoid having it
unconditionally read in the blkid.tab file.  The assumption was the
overhead for doing so should not be measurable.

We could add functions to allow a particular entry to be removed from
blkid.tab, but I'd much rather to have that garbage collection be
automatically handled without needing any manual calls to specific
APi's.

Regards,

					- Ted
