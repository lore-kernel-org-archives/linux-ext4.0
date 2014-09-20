From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] generic: add mmap write vs truncate/remap test
Date: Sun, 21 Sep 2014 09:32:09 +1000
Message-ID: <20140920233209.GJ4267@dastard>
References: <1410918113-23516-1-git-send-email-david@fromorbit.com>
 <1410918113-23516-5-git-send-email-david@fromorbit.com>
 <541CC790.7060306@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15010 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbaITXcN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Sep 2014 19:32:13 -0400
Content-Disposition: inline
In-Reply-To: <541CC790.7060306@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2014 at 07:17:20PM -0500, Eric Sandeen wrote:
> On 9/16/14 8:41 PM, Dave Chinner wrote:
> > This test exposed a problem with mapped writes to the tail page of a
> > file in XFS and potentially ext4. Eric did all the hard work of
> > taking the bug report and generating the reproducable test case
> > on ext4, but I haven't been able to reproduce then problem on ext4.
> > 
> > Regardless, make it a generic test so that we can ensure that all
> > filesystems handle the case correctly.
> 
> Oof, kermit on #xfs points out that even this is sufficient to show
> a problem:
> 
>  mkfs.ext4 -b 1024 -F empty.img
>   mount -o loop empty.img mnt
>   sync
> 
> xfs_io -f -t \
> -c            "pwrite               0          0x210  "      \
> -c            "mmap      -rw        0          0xd08  "      \
> -c            "mwrite    -S         0x50       0x210  0xaf8"  \
> -c            "truncate                        0x1000"  \
> mnt/testfile

That's supposed to SIGBUS. From the mmap man page:

SIGBUS	Attempted  access to a portion of the buffer that does not
	correspond to the file (for example, beyond the end of the
	file, including the case where another process has truncated
	the file).

I'm not sure that can be fixed in the filesystem, though, because
after a page fault inside the valid file region we can't prevent
mmap from writing beyond EOF in the same page. It's one of those "we
can't really do anything sane here" interface problems.

However, the truncate up is supposed to leave the newly exposed
regions full of zeros and not expose stale data from beyond the old
EOF. XFS results in the correct output which is:

00000000  cd cd cd cd cd cd cd cd  cd cd cd cd cd cd cd cd |................|
*
00000210  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
*
00001000

Because it zeros allocated space between the old EOF and new EOF on
truncate up.

What is really interesting is this addition:

xfs_io -f -t \
-c            "pwrite               0          0x210  "      \
-c            "mmap      -rw        0          0xd08  "      \
-c            "mwrite    -S         0x50       0x210  0xaf8"  \
-c            "fsync" \
-c            "truncate                        0x1000"  \
mnt/testfile

Causes the ext4 data corruption goes away, probably because the act
of writing the page zeroes the tail blocks beyond EOF before writing
them. XFS has code to specifically do this in xfs_vm_writepage, and
I'm pretty sure we got that from ext4. So in the absence of ext4
zeroing on truncate up, I suspect it needs to write the tail page
at the old EOF on truncate up just like we have needed to add to
XFS to solve the other problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
