From: Shapor Naghibzadeh <shapor@shapor.com>
Subject: Re: poor performance of mount due to libblkid
Date: Mon, 14 May 2007 16:40:26 -0500
Message-ID: <20070514164026.E12805@cbr.shaptech.com>
References: <20070509170646.C12805@cbr.shaptech.com> <20070510003005.GV6375@schatzie.adilger.int> <20070509234532.D12805@cbr.shaptech.com> <20070510064448.GA13450@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@stusta.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cbr.shaptech.com ([64.246.26.67]:60175 "EHLO cbr.shaptech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbXENVbR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2007 17:31:17 -0400
Content-Disposition: inline
In-Reply-To: <20070510064448.GA13450@thunk.org>; from tytso@mit.edu on Thu, May 10, 2007 at 02:44:48AM -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 10, 2007 at 02:44:48AM -0400, Theodore Tso wrote:
> put it.  The device names of USB storage devices end up getting
> reused, so in practice what is in blkid.tab is merely the last storage
> device that was plugged in, not every single one going back forever.

My point with the USB example was that it keeps their labels around in a
world-readable cache infinitely (or until a device with the same name gets
mounted again).  Its probably not a security issue in most cases, but its
clutter which one doesn't expect to stick around.

> One easy way of solving this problem is when we're parsing the file,
> try to stat the device file, and if it doesn't exist, to skip parsing
> the line together.  This would prevent blkid.tab from growing without
> bound given your workload.

This idea of doing garbage collection every time blkid.tab is read destroys
the cache if, for example, you mount /usr or /var before other block devices
have been brought up.  AoE and nbd come to mind as a potentially large number
of devices that might not exist until later in the boot process.

> The whole point of blkid.tab file was so that having searched all of
> the devices to find the particular filesystem with a specified volume
> label or UUID, that all of the information that was gathered doesn't
> have to be searched a next time you need to do a mount-by-uuid or
> mount-by-label.  And if you have a large number of disks that you
> might have to potentially spin up, you definitely want to keep this
> cache across boots, which is why we store it in /etc/blkid.tab.

Ok, but why do we bother caching the filesystem type?  The desire to optimize
the scanning for UUIDs or labels is indeed a real problem, but caching the
filesystem type has the potential for introducing bugs and doesn't seem to
have any real payoff.  I for one have been bitten by the ext2 to ext3 upgrade
bug more than once.

There should be a better way of maintaining a UUID and label cache other than
having mount keep an XML cache in /etc (which seems to violate the Linux
filesystem hierarchy standard).  Certainly having it enabled by default when
there is no desire to mount by UUID or label is wasteful and probably the most
common case.

> So it sounds like the short-term fix is to simply add a test so that
> if the device isn't present, we should just ignore the entry when we
> read it into memory.  The longer-term fix is use a more sophisticated
> in-core representation which doesn't have a linear search time, and so
> that algorithms to detect multiple lines referring to the same device
> don't take O(n**2).  We should also fix mount to avoid having it
> unconditionally read in the blkid.tab file.  The assumption was the
> overhead for doing so should not be measurable.

The first and safest step would seem to be removing the use of blkid.tab from
mount except when trying to mount by UUID or volume label to prevent the
performance issue when the cache is large.  I think garbage collection is more
complex to do safely and the whole approach might some re-thinking.

Shapor
