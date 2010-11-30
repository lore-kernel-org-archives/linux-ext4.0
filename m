From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] dm: Compute average flush time from component devices
Date: Tue, 30 Nov 2010 00:21:09 -0500
Message-ID: <20101130052108.GA2107@redhat.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
 <20101129220558.12401.95229.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0K3FVm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 00:21:42 -0500
Content-Disposition: inline
In-Reply-To: <20101129220558.12401.95229.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29 2010 at  5:05pm -0500,
Darrick J. Wong <djwong@us.ibm.com> wrote:

> For dm devices which are composed of other block devices, a flush is mapped out
> to those other block devices.  Therefore, the average flush time can be
> computed as the average flush time of whichever device flushes most slowly.

I share Neil's concern about having to track such fine grained
additional state in order to make the FS behave somewhat better.  What
are the _real_ fsync-happy workloads which warrant this optimization?

That concern aside, my comments on your proposed DM changes are inlined below.

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7cb1352..62aeeb9 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -846,12 +846,38 @@ static void start_queue(struct request_queue *q)
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  
> +static void measure_flushes(struct mapped_device *md)
> +{
> +	struct dm_table *t;
> +	struct dm_dev_internal *dd;
> +	struct list_head *devices;
> +	u64 max = 0, samples = 0;
> +
> +	t = dm_get_live_table(md);
> +	devices = dm_table_get_devices(t);
> +	list_for_each_entry(dd, devices, list) {
> +		if (dd->dm_dev.bdev->bd_disk->avg_flush_time_ns <= max)
> +			continue;
> +		max = dd->dm_dev.bdev->bd_disk->avg_flush_time_ns;
> +		samples = dd->dm_dev.bdev->bd_disk->flush_samples;
> +	}
> +	dm_table_put(t);
> +
> +	spin_lock(&md->disk->flush_time_lock);
> +	md->disk->avg_flush_time_ns = max;
> +	md->disk->flush_samples = samples;
> +	spin_unlock(&md->disk->flush_time_lock);
> +}
> +

You're checking all devices in a table rather than all devices that will
receive a flush.  The devices that will receive a flush is left for each
target to determine (target exposes num_flush_requests).  I'd prefer to
see a more controlled .iterate_devices() based iteration of devices in
each target.

dm-table.c:dm_calculate_queue_limits() shows how iterate_devices can be
used to combine device specific data using a common callback and a data
pointer -- for that data pointer we'd need a local temporary structure
with your 'max' and 'samples' members.

>  static void dm_done(struct request *clone, int error, bool mapped)
>  {
>  	int r = error;
>  	struct dm_rq_target_io *tio = clone->end_io_data;
>  	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
>  
> +	if (clone->cmd_flags & REQ_FLUSH)
> +		measure_flushes(tio->md);
> +
>  	if (mapped && rq_end_io)
>  		r = rq_end_io(tio->ti, clone, error, &tio->info);
>  
> @@ -2310,6 +2336,8 @@ static void dm_wq_work(struct work_struct *work)
>  		if (dm_request_based(md))
>  			generic_make_request(c);
>  		else
> +			if (c->bi_rw & REQ_FLUSH)
> +				measure_flushes(md);
>  			__split_and_process_bio(md, c);
>  
>  		down_read(&md->io_lock);
> 

You're missing important curly braces for the else in your dm_wq_work()
change...

But the bio-based call to measure_flushes() (dm_wq_work's call) should
be pushed into __split_and_process_bio() -- and maybe measure_flushes()
could grow a 'struct dm_table *table' argument that, if not NULL, avoids
getting the reference that __split_and_process_bio() already has on the
live table.

Mike
