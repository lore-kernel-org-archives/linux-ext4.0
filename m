From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
 range
Date: Thu, 27 Feb 2014 13:03:09 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402271257590.2247@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com> <1393355728-12056-6-git-send-email-lczerner@redhat.com> <20140225205349.GD13647@dastard> <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain> <20140225215011.GF13647@dastard>
 <alpine.LFD.2.00.1402261520070.2243@localhost.localdomain> <20140226220106.GC29907@dastard>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-458918293-1393502592=:2247"
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaB0MDQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 07:03:16 -0500
In-Reply-To: <20140226220106.GC29907@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-458918293-1393502592=:2247
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Feb 2014, Dave Chinner wrote:

> Date: Thu, 27 Feb 2014 09:01:06 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
>     range
> 
> On Wed, Feb 26, 2014 at 03:24:18PM +0100, Lukáš Czerner wrote:
> > On Wed, 26 Feb 2014, Dave Chinner wrote:
> > 
> > > Date: Wed, 26 Feb 2014 08:50:11 +1100
> > > From: Dave Chinner <david@fromorbit.com>
> > > To: Lukáš Czerner <lczerner@redhat.com>
> > > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> > > Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
> > >     range
> > > 
> > > On Tue, Feb 25, 2014 at 10:01:06PM +0100, Lukáš Czerner wrote:
> > > > On Wed, 26 Feb 2014, Dave Chinner wrote:
> > > > 
> > > > > Date: Wed, 26 Feb 2014 07:53:49 +1100
> > > > > From: Dave Chinner <david@fromorbit.com>
> > > > > To: Lukas Czerner <lczerner@redhat.com>
> > > > > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> > > > > Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
> > > > >     range
> > > > > 
> > > > > On Tue, Feb 25, 2014 at 08:15:28PM +0100, Lukas Czerner wrote:
> > > > > > This is copy of xfs/242. However it's better to make it file system
> > > > > > specific because the range can be zeroes either directly by writing
> > > > > > zeroes, or converting to unwritten extent, so the actual result might
> > > > > > differ from file system to file system.
> > > > > 
> > > > > You could say the same thing about preallocation using unwritten
> > > > > extents. Yet, funnily enough, we have generic tests for them because
> > > > > all filesystems currently use unwritten extents for preallocation
> > > > > and behave identically....
> > > > > 
> > > > > This test is no different - all filesystems currently use unwritten
> > > > > extents, and so this test should be generic because all existing
> > > > > filesystems *should* behave the same.
> > > > > 
> > > > > When we get a filesystem that zeros rather uses unwritten extents,
> > > > > we can add a new *generic* test that tests for zeroed data extents
> > > > > rather than unwritten extents. All that we will need is a method of
> > > > > checking what behaviour the filesystem has and adding that to a
> > > > > _requires directive to ensure the correct generic fallocate tests
> > > > > are run...
> > > > 
> > > > Currently xfs/242 fails on xfs for me
> > > 
> > > Really? Where's the bug report? I haven't seen a failure on xfs/242
> > > on any of my test machines for at least a year, even on 1k block
> > > size filesystems...
> > > 
> > > $ sudo ./check xfs/242
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 test2 3.14.0-rc3-dgc+
> > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> > > MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> > > 
> > > xfs/242 1s ... 0s
> > > Ran: xfs/242
> > > Passed all 1 tests
> > > $
> > 
> > Here it is.
> > 
> > xfs/242 fails on ppc64 with latest linus tree
> 
> OK, that's a different kettle of fish. It's using 64k pages, right?

64k pages, yes.

> 
> > # uname -a
> > Linux ibm-p740-01-lp4.rhts.eng.bos.redhat.com 3.14.0-rc4+ #1 SMP Wed
> > Feb 26 08:59:48 EST 2014 ppc64 ppc64 ppc64 GNU/Linux
> > 
> > # ./check xfs/242
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/ppc64 ibm-p740-01-lp4 3.14.0-rc4+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/test2
> > 
> > xfs/242  - output mismatch (see /root/xfstests/results//xfs/242.out.bad)
> >     --- tests/xfs/242.out       2014-02-26 05:51:16.602579462 -0500
> >     +++ /root/xfstests/results//xfs/242.out.bad 2014-02-26 09:20:55.585396040 -0500
> >     @@ -1,76 +1,71 @@
> >      QA output created by 242
> >         1. into a hole
> >      0: [0..7]: hole
> >     -1: [8..23]: unwritten
> >     +1: [8..23]: data
> >      2: [24..39]: hole
> >      daa100df6e6711906b61c9ab5aa16032
> 
> So the data is correct, but the range got zeroes written to it
> rather than an unwritten extent.
> 
> >     (Run 'diff -u tests/xfs/242.out /root/xfstests/results//xfs/242.out.bad'  to see the entire diff)
> > Ran: xfs/242
> > Failures: xfs/242
> > Failed 1 of 1 tests
> > 
> > 
> > Here is 242.out.bad
> 
> The diff would have been better.
> 
> /me goes off to diff the output
> 
> Yeah, ok, the data in all the files is correct - the md5sums all
> match. What's different? Just about all unwritten extents are now
> written (i.e. data) or contain some portion of written extents.
> 
> So, ZERO_RANGE has the following size threshold for converting
> blocks to unwritten extents vs just zeroing them:
> 
> 	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> 
> So if this is a 64k page size machine, it's going to have different
> extent layout compared to a 4k page size machine. The file data will
> still be the same, the difference will be zeroed blocks instead of
> unwritten blocks, and that's exactly what we see.
> 
> IOWs, the result in terms of data the application sees is correct,
> just the extent layout representing that zeroed data is different.

Ok, so that's yet another difference between xfs and ext4 code which
makes having generic test even more complicated. So as I said before
I'll make the generic test (using _filter_hole_fiemap) and then ext4
specific test as well to really make sure that the extent
manipulation is right.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-458918293-1393502592=:2247--
