From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v1 0/9] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
Date: Tue, 20 Nov 2012 09:23:18 -0500
Message-ID: <x49pq38jquh.fsf@segfault.boston.devel.redhat.com>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab2KTOXn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 09:23:43 -0500
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org> (Darrick
	J. Wong's message of "Mon, 19 Nov 2012 23:41:16 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> Hi everybody,
>
> On March 29th, Jeff Moyer posted to lkml a patchset with this note:
>
>> Currently, AIO+DIO+O_SYNC writes are not actually sync'd (for xfs), or they
>> are sync'd before the I/O is actually issued (everybody else).  The following
>> patch series fixes this in two parts.  First, for the file systems that use
>> the generic routines, Jan has provided some generic infrastructure to perform
>> the syncs after the I/O is completed.  Second, for those file systems which
>> require some endio processing of their own for O_DIRECT writes (xfs and
>> ext4), [Jeff] implemented file system specific syncing.  This passes the
>> updated xfs-tests 113 test [Jeff] posted earlier, as well as all of the tests
>> in the aio group.  [Jeff] tested ext3, ext4, xfs, and btrfs only.
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

Hi, Darrick,

I just finished testing my version of this patch set on ext4 and xfs
(btrfs is next), but you beat me to the posting!  Sorry, I should have
been more clear when I said I would see about refreshing the series.

How have you tested these patches?  You just said "lightly", and I'm
afraid I don't know what that means.  xfstests?  You should at least run
them through test 113.

Would you like to push the set in, or should I post the patches I've
got?  Doesn't matter to me, just let me know.

Cheers,
Jeff
