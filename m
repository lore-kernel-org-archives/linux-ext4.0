From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent by fsync
Date: Mon, 29 Nov 2010 14:05:36 -0800
Message-ID: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>,
	"Darrick J.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:46111 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0K2WFo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 17:05:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On certain types of hardware, issuing a write cache flush takes a considerable
amount of time.  Typically, these are simple storage systems with write cache
enabled and no battery to save that cache after a power failure.  When we
encounter a system with many I/O threads that write data and then call fsync
after more transactions accumulate, ext4_sync_file performs a data-only flush,
the performance of which is suboptimal because each of those threads issues its
own flush command to the drive instead of trying to coordinate the flush,
thereby wasting execution time.

Instead of each fsync call initiating its own flush, there's now a flag to
indicate if (0) no flushes are ongoing, (1) we're delaying a short time to
collect other fsync threads, or (2) we're actually in-progress on a flush.

So, if someone calls ext4_sync_file and no flushes are in progress, the flag
shifts from 0->1 and the thread delays for a short time to see if there are any
other threads that are close behind in ext4_sync_file.  After that wait, the
state transitions to 2 and the flush is issued.  Once that's done, the state
goes back to 0 and a completion is signalled.

Those close-behind threads see the flag is already 1, and go to sleep until the
completion is signalled.  Instead of issuing a flush themselves, they simply
wait for that first thread to do it for them.  If they see that the flag is 2,
they wait for the current flush to finish, and start over.

However, there are a couple of exceptions to this rule.  First, there exist
high-end storage arrays with battery-backed write caches for which flush
commands take very little time (< 2ms); on these systems, performing the
coordination actually lowers performance.  Given the earlier patch to the block
layer to report low-level device flush times, we can detect this situation and
have all threads issue flushes without coordinating, as we did before.  The
second case is when there's a single thread issuing flushes, in which case it
can skip the coordination.

This author of this patch is aware that jbd2 has a similar flush coordination
scheme for journal commits.  An earlier version of this patch simply created a
new empty journal transaction and committed it, but that approach was shown to
increase the amount of write traffic heading towards the disk, which in turn
lowered performance considerably, especially in the case where directio was in
use.  Therefore, this patch adds the coordination code directly to ext4.

To test the performance and safety of this patchset, I crafted an ffsb profile
named fsync-happy that performs a bunch of disk I/O with periodic fsync()s to
flush the data out to disk.  Performance results can be seen here:
http://bit.ly/fYAclV

The data presented in blue text represent results obtained on high performance
disk arrays that have battery-backed write cache enabled.  Red results on the
"speed differences" page represent performance regressions, of course.
Descriptions of the disk hardware tested are on the rightmost page.  In no case
were any of the benchmarks CPU-bound.

The speed differences page shows some interesting results.  Before Tejun Heo's
barrier -> flush conversion in 2.6.37-rc1, we saw that enabling barriers caused
between a 30-80 percent performance regression on a fairly large variety of
test programs; generally, the more fsyncs, the bigger the drop; if one never
fsyncs any data, the only flushes that ever happen are during the periodic
journal commits.  Now we see that the cost of enabling flushes in ext4 on the
fsync-happy workload has dropped from about 80 percent to about 25-30 percent.
With this fsync coordination patch, that drop becomes about 5-14 percent.

I see some small performance (< 1 percent) regressions for some hardware.  This is
generally acceptable because I see larger variances from repeatedly running
fsync-happy.  The two larger regressions (elm3a4_ipr_nowc and
elm3c44_sata_nowc) are a somewhat questionable case because those two disks
have no write cache yet ext4 was not properly detecting this and setting
barrier=0.  That bug will be addressed separately.

In terms of data safety, I've been performing power failure testing with a
bunch of blades that have slow IDE disks with fairly large write caches.  So
far I haven't seen any more FS errors after reset than I see with 2.6.36.

This patchset consists of four patches.  The first adds to the block layer the
ability to measure the amount of time it takes for a lower-level block device
to issue and complete a flush command.  The middle two patches add to md and
dm, respectively, the ability to report the component devices' flush times.
For 2.6.37-rc3, the md patch also requires my earlier patch to md to enable
REQ_FLUSH support.  The fourth patch adds the auto-tuning fsync flush
coordination to ext4.

To everyone who has reviewed this patch set so far, thank you for your help!
As usual, I welcome any questions or comments.

--D
