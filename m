From: Theodore Tso <tytso@mit.edu>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 20:55:03 -0400
Message-ID: <20090911005503.GI6705@mit.edu>
References: <200909101455.38400.coolo@suse.de> <20090910202927.GK23700@mit.edu> <200909102257.54889.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Scott James Remnant <scott@canonical.com>
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34014 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZIKAzH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 20:55:07 -0400
Content-Disposition: inline
In-Reply-To: <200909102257.54889.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 10:57:54PM +0200, Stephan Kulow wrote:
> 
> The work flow is as such:
> - boot into live cd, live cd thinks system is UTC, mounts sda1 (ro) 
>   at 9am, umounts cleanly, updates mount time to 11am (hardware clock)

That doesn't make any sense.  The mount time is only set if the
filesystem is mounted read/write.  So if you only mounted the
filesystem read/only, the mount time wouldn't be changed.  Watch:

# dumpe2fs -h /dev/closure/test | grep time:
dumpe2fs 1.41.9 (22-Aug-2009)
Last mount time:          Tue Sep  1 00:00:00 2009
Last write time:          Tue Sep  1 00:00:00 2009
# mount -t ext3 -o ro /dev/closure/test /mnt
# umount /mnt
# dumpe2fs -h /dev/closure/test | grep time:
dumpe2fs 1.41.9 (22-Aug-2009)
Last mount time:          Tue Sep  1 00:00:00 2009
Last write time:          Tue Sep  1 00:00:00 2009
# mount -t ext4 -o ro /dev/closure/test /mnt
# umount /mnt
# dumpe2fs -h /dev/closure/test | grep time:
dumpe2fs 1.41.9 (22-Aug-2009)
Last mount time:          Tue Sep  1 00:00:00 2009
Last write time:          Tue Sep  1 00:00:00 2009
# date
Thu Sep 10 20:51:48 EDT 2009

See?

Now, if the Live CD is going to be repairing a filesystem, it should
mount the root filesystem read/only, extract the time zone, fix the
system clock, and only then mount the filesystem read/write.

Or the Live CD should fix the system clock over the network before it
tries mounting any hard drives.  The point is, there are ways for the
Live CD to do the right thing.  If it's not willing to do that, then
its init scripts are buggy.  :-)

					- Ted
