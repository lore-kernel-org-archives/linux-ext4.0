From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Performance testing of various barrier reduction patches [was:
	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Thu, 23 Sep 2010 16:25:27 -0700
Message-ID: <20100923232527.GB25624@tux1.beaverton.ibm.com>
References: <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35335 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0IWXZ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Sep 2010 19:25:29 -0400
Content-Disposition: inline
In-Reply-To: <20100823183119.GA28105@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I just retested with 2.6.36-rc5 and the same set of patches as before
(flush_fua, fsync_coordination, etc) and have an even larger spreadsheet:
http://bit.ly/ahdhyk

This time, however, I instrumented the kernel to report the amount of time it
takes to complete the flush operation.  The test setups elm3a63, elm3c44_sas,
and elm3c71_sas are all arrays that have battery backed write-back cache; it
should not be a huge shock that the average flush time generally stays under
8ms for these setups.  elm3c65 and elm3c75_ide are single disk SAS and IDE
disks (no write cache), and the other setups all feature md-raids backed by
SCSI disks (also no write cache).  The flush_times tab in the spreadsheet lists
average, max, and min sync times.

Turning to the ffsb scores, I can see some of the same results that I saw while
testing 2.6.36-rc1 a few weeks ago.  Now that I've had the time to look at how
the code works and evaluate a lot more setups, I think I can speculate further
about the cause of the regression that I see with the fsync coordination patch.
Because I'm testing the effects of varying the fsync_delay values, I've bolded
the highest score for each unique (directio, nojan, nodj) configuration, and it
appears that the most winning cases are fsync_delay=0 which corresponds to the
old fsync behavior (every caller issues a flush), and fsync_delay=-1 which
corresponds to a coordination delay equal to the average flush duration.

To try to find an explanation, I started looking for connections between fsync
delay values and average flush times.  I noticed that the setups with low (<
8ms) flush times exhibit better performance when fsync coordination is not
attempted, and the setups with higher flush times exhibit better performance
when fsync coordination happens.  This also is no surprise, as it seems
perfectly reasonable that the more time consuming a flush is, the more desirous
it is to spend a little time coordinating those flushes across CPUs.

I think a reasonable next step would be to alter this patch so that
ext4_sync_file always measures the duration of the flushes that it issues, but
only enable the coordination steps if it detects the flushes taking more than
about 8ms.  One thing I don't know for sure is whether 8ms is a result of 2*HZ
(currently set to 250) or if 8ms is a hardware property.

As for safety testing, I've been running power-fail tests on the single-disk
systems with the same ffsb profile.  So far I've observed a lot of fsck
complaints about orphaned inodes being truncated ("Truncating orphaned inode
1352607 (uid=0, gid=0, mode=0100700, size=4096)") though this happens
regardless of whether I run with this 2.6.36 test kernel of mine or a plain
vanilla 2.6.35 configuration.  I've not seen any serious corruption yet.

So, what do people think of these latest results?

--D

On Mon, Aug 23, 2010 at 11:31:19AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I retested the ext4 barrier mitigation patchset against a base of 2.6.36-rc1 +
> Tejun's flush_fua tree + Christoph's patches to change FS barrier semantics,
> and came up with this new spreadsheet:
> http://bit.ly/bWpbsT
> 
> Here are the previous 2.6.35 results for convenience: http://bit.ly/c22grd
> 
> The machine configurations are the same as with the previous (2.6.35)
> spreadsheet.  It appears to be the case that Tejun and Christoph's patches to
> change barrier use into simpler cache flushes generally improve the speed of
> the fsync-happy workload in buffered I/O mode ... if you have a bunch of
> spinning disks.  Results for the SSD array (elm3c44) and the single disk
> systems (elm3c65/elm3c75) decreased slightly.  For the case where direct I/O
> was used, the patchset improved the results in nearly all cases.  The speed
> with barriers on is getting closer to the speed with barriers off, thankfully!
> 
> Unfortunately, one thing that became /much/ less clear in these new results is
> the impact of the other patch sets that we've been working on to make ext4
> smarter with regards to barrier/flush use.  In most cases I don't really see
> the fsync-delay patch having much effect for directio, and it seems to have
> wild effects when buffered mode is used.  Jan Kara's barrier generation patch
> still generally helps with directio loads.  I've also concluded that my really
> old dirty-flag patchset from ages ago no longer has any effect.
> 
> What does everyone else think of these results?
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
