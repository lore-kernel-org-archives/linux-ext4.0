From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
	by fsync
Date: Tue, 30 Nov 2010 15:31:30 -0800
Message-ID: <20101130233130.GG18195@tux1.beaverton.ibm.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <20101130113906.176ffcad@notabene.brown>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56600 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0K3Xbb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 18:31:31 -0500
Content-Disposition: inline
In-Reply-To: <20101130113906.176ffcad@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 30, 2010 at 11:39:06AM +1100, Neil Brown wrote:
> On Mon, 29 Nov 2010 14:05:36 -0800 "Darrick J. Wong" <djwong@us.ibm.com>
> wrote:
> 
> > On certain types of hardware, issuing a write cache flush takes a considerable
> > amount of time.  Typically, these are simple storage systems with write cache
> > enabled and no battery to save that cache after a power failure.  When we
> > encounter a system with many I/O threads that write data and then call fsync
> > after more transactions accumulate, ext4_sync_file performs a data-only flush,
> > the performance of which is suboptimal because each of those threads issues its
> > own flush command to the drive instead of trying to coordinate the flush,
> > thereby wasting execution time.
> > 
> > Instead of each fsync call initiating its own flush, there's now a flag to
> > indicate if (0) no flushes are ongoing, (1) we're delaying a short time to
> > collect other fsync threads, or (2) we're actually in-progress on a flush.
> > 
> > So, if someone calls ext4_sync_file and no flushes are in progress, the flag
> > shifts from 0->1 and the thread delays for a short time to see if there are any
> > other threads that are close behind in ext4_sync_file.  After that wait, the
> > state transitions to 2 and the flush is issued.  Once that's done, the state
> > goes back to 0 and a completion is signalled.
> 
> I haven't seen any of the preceding discussion do I might be missing
> something important, but this seems needlessly complex and intrusive.
> In particular, I don't like adding code to md to propagate these timings up
> to the fs, and I don't the arbitrary '2ms' number.
> 
> Would it not be sufficient to simply gather flushes while a flush is pending.
> i.e
>   - if no flush is pending, set the 'flush pending' flag, submit a flush,
>     then clear the flag.
>   - if a flush is pending, then wait for it to complete, and then submit a
>     single flush on behalf of all pending flushes.
> 
> That way when flush is fast, you do a flush every time, and when it is slow
> you gather multiple flushes together.
> I think it would issues a few more flushes than your scheme, but it would be
> a much neater solution.  Have you tried that and found it to be insufficient?

Some time ago I actually did test the patchset with the schedule_hrtimeout
removed, which I think is fairly close to what you've suggested.  As I recall,
it did help a bit, though not as much as also instituting the wait to limit the
% of disk execution time spent on flushes.  That said, I think you might be
right about the completion races, so I'll try to code up your suggestion to
see what happens with a newer kernel.

--D
> 
> Thanks,
> NeilBrown
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
