From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
 by fsync
Date: Mon, 29 Nov 2010 18:48:25 -0500
Message-ID: <4CF43BC9.8040603@redhat.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab0K2XrR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 18:47:17 -0500
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/29/2010 05:05 PM, Darrick J. Wong wrote:
> On certain types of hardware, issuing a write cache flush takes a considerable
> amount of time.  Typically, these are simple storage systems with write cache
> enabled and no battery to save that cache after a power failure.  When we
> encounter a system with many I/O threads that write data and then call fsync
> after more transactions accumulate, ext4_sync_file performs a data-only flush,
> the performance of which is suboptimal because each of those threads issues its
> own flush command to the drive instead of trying to coordinate the flush,
> thereby wasting execution time.
>
> Instead of each fsync call initiating its own flush, there's now a flag to
> indicate if (0) no flushes are ongoing, (1) we're delaying a short time to
> collect other fsync threads, or (2) we're actually in-progress on a flush.
>
> So, if someone calls ext4_sync_file and no flushes are in progress, the flag
> shifts from 0->1 and the thread delays for a short time to see if there are any
> other threads that are close behind in ext4_sync_file.  After that wait, the
> state transitions to 2 and the flush is issued.  Once that's done, the state
> goes back to 0 and a completion is signalled.
>
> Those close-behind threads see the flag is already 1, and go to sleep until the
> completion is signalled.  Instead of issuing a flush themselves, they simply
> wait for that first thread to do it for them.  If they see that the flag is 2,
> they wait for the current flush to finish, and start over.
>
> However, there are a couple of exceptions to this rule.  First, there exist
> high-end storage arrays with battery-backed write caches for which flush
> commands take very little time (<  2ms); on these systems, performing the
> coordination actually lowers performance.  Given the earlier patch to the block
> layer to report low-level device flush times, we can detect this situation and
> have all threads issue flushes without coordinating, as we did before.  The
> second case is when there's a single thread issuing flushes, in which case it
> can skip the coordination.
>
> This author of this patch is aware that jbd2 has a similar flush coordination
> scheme for journal commits.  An earlier version of this patch simply created a
> new empty journal transaction and committed it, but that approach was shown to
> increase the amount of write traffic heading towards the disk, which in turn
> lowered performance considerably, especially in the case where directio was in
> use.  Therefore, this patch adds the coordination code directly to ext4.

Hi Darrick,

Just curious why we would need to have batching in both places? Doesn't your 
patch set make the jbd2 transaction batching redundant?

I noticed that the patches have a default delay and a mount option to override 
that default. The jbd2 code today tries to measure the average time needed in a 
transaction and automatically tune itself. Can't we do something similar with 
your patch set? (I hate to see yet another mount option added!)

Regards,

Ric


