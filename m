From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 0/9] fs: fix up AIO+DIO+O_SYNC to actually do the sync
 part
Date: Tue, 20 Nov 2012 00:38:36 -0800
Message-ID: <20121120083836.GA11842@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com,
	jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk,
	jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49210 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2KTIiv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 03:38:51 -0500
Content-Disposition: inline
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Apologies for the garbage emails.  The corporate email server lost its mind,
and I'm well on my way to losing mine.... <grumble> <shakes fist>

They at least were so garbled that they're not attached to this thread.

--D

> Hi everybody,
> 
> On March 29th, Jeff Moyer posted to lkml a patchset with this note:
> 
> > Currently, AIO+DIO+O_SYNC writes are not actually sync'd (for xfs), or they
> > are sync'd before the I/O is actually issued (everybody else).  The following
> > patch series fixes this in two parts.  First, for the file systems that use
> > the generic routines, Jan has provided some generic infrastructure to perform
> > the syncs after the I/O is completed.  Second, for those file systems which
> > require some endio processing of their own for O_DIRECT writes (xfs and
> > ext4), [Jeff] implemented file system specific syncing.  This passes the
> > updated xfs-tests 113 test [Jeff] posted earlier, as well as all of the tests
> > in the aio group.  [Jeff] tested ext3, ext4, xfs, and btrfs only.
> 
> Since the original post a few months ago, this patchset doesn't seem to have
> made any progress.  An internal testing team here discovered that the issue
> also affects O_SYNC+AIO+DIO writes to block devices.  Worse yet, since the
> flushes were being issued (and waited upon) directly in the io_submit call
> graph, the io_submit calls themselves would take a very long time to complete.
> Therefore, I added another patch to move the flush to the io_end processing.
> 
> The blockdev patch was written by me.  The ext4 patch had to be updated to
> accomodate a rework of the ext4 endio code that landed since March.  Everything
> else has been passed through from Jeff's March 30th resend, with few changes.
> 
> This patchset has been tested (albeit lightly) against 3.7-rc6 on x64, with
> ext4, xfs, btrfs, vfat, jfs, hfsplus, ext2, ext3, and raw block devices.
> 
> Comments and questions are, as always, welcome.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
