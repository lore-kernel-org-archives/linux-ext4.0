From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Thu, 13 Jan 2011 11:42:40 +0100
Message-ID: <20110113104240.GA30719@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1AMKmu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 05:42:50 -0500
Content-Disposition: inline
In-Reply-To: <20110113025646.GB27381@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, Darrick.

On Wed, Jan 12, 2011 at 06:56:46PM -0800, Darrick J. Wong wrote:
> On certain types of storage hardware, flushing the write cache takes a
> considerable amount of time.  Typically, these are simple storage systems with
> write cache enabled and no battery to save that cache during a power failure.
> When we encounter a system with many I/O threads that try to flush the cache,
> performance is suboptimal because each of those threads issues its own flush
> command to the drive instead of trying to coordinate the flushes, thereby
> wasting execution time.
> 
> Instead of each thread initiating its own flush, we now try to detect the
> situation where multiple threads are issuing flush requests.  The first thread
> to enter blkdev_issue_flush becomes the owner of the flush, and all threads
> that enter blkdev_issue_flush before the flush finishes are queued up to wait
> for the next flush.  When that first flush finishes, one of those sleeping
> threads is woken up to perform the next flush and then wake up the other
> threads which are asleep waiting for the second flush to finish.

Nice work.  :-)

>  block/blk-flush.c     |  137 +++++++++++++++++++++++++++++++++++++++++--------
>  block/genhd.c         |   12 ++++
>  include/linux/genhd.h |   15 +++++
>  3 files changed, 143 insertions(+), 21 deletions(-)
> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 2402a34..d6c9931 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -201,6 +201,60 @@ static void bio_end_flush(struct bio *bio, int err)
>  	bio_put(bio);
>  }
>  
> +static int blkdev_issue_flush_now(struct block_device *bdev,
> +		gfp_t gfp_mask, sector_t *error_sector)
> +{
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct bio *bio;
> +	int ret = 0;
> +
> +	bio = bio_alloc(gfp_mask, 0);
> +	bio->bi_end_io = bio_end_flush;
> +	bio->bi_bdev = bdev;
> +	bio->bi_private = &wait;
> +
> +	bio_get(bio);
> +	submit_bio(WRITE_FLUSH, bio);
> +	wait_for_completion(&wait);
> +
> +	/*
> +	 * The driver must store the error location in ->bi_sector, if
> +	 * it supports it. For non-stacked drivers, this should be
> +	 * copied from blk_rq_pos(rq).
> +	 */
> +	if (error_sector)
> +		*error_sector = bio->bi_sector;
> +
> +	if (!bio_flagged(bio, BIO_UPTODATE))
> +		ret = -EIO;
> +
> +	bio_put(bio);
> +	return ret;
> +}

But wouldn't it be better to implement this directly in the flush
machinary instead of as blkdev_issue_flush() wrapper?  We have all the
information at the request queue level so we can easily detect whether
flushes can be merged or not and whether something is issued by
blkdev_issue_flush() or by directly submitting bio wouldn't matter at
all.  Am I missing something?

Thanks.

-- 
tejun
