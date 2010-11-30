From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
 by fsync
Date: Tue, 30 Nov 2010 11:39:06 +1100
Message-ID: <20101130113906.176ffcad@notabene.brown>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 29 Nov 2010 14:05:36 -0800 "Darrick J. Wong" <djwong@us.ibm.com>
wrote:

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

I haven't seen any of the preceding discussion do I might be missing
something important, but this seems needlessly complex and intrusive.
In particular, I don't like adding code to md to propagate these timings up
to the fs, and I don't the arbitrary '2ms' number.

Would it not be sufficient to simply gather flushes while a flush is pending.
i.e
  - if no flush is pending, set the 'flush pending' flag, submit a flush,
    then clear the flag.
  - if a flush is pending, then wait for it to complete, and then submit a
    single flush on behalf of all pending flushes.

That way when flush is fast, you do a flush every time, and when it is slow
you gather multiple flushes together.
I think it would issues a few more flushes than your scheme, but it would be
a much neater solution.  Have you tried that and found it to be insufficient?

Thanks,
NeilBrown
