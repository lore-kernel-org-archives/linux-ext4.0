From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 8 Apr 2010 13:00:45 +0200
Message-ID: <20100408110045.GJ10103@kernel.dk>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Vivek Goyal <vgoyal@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57755 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab0DHLAr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 07:00:47 -0400
Content-Disposition: inline
In-Reply-To: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07 2010, Jeff Moyer wrote:
> Hi again,
> 
> So, here's another stab at fixing this.  This patch is very much an RFC,
> so do not pull it into anything bound for Linus.  ;-)  For those new to
> this topic, here is the original posting:  http://lkml.org/lkml/2010/4/1/344
> 
> The basic problem is that, when running iozone on smallish files (up to
> 8MB in size) and including fsync in the timings, deadline outperforms
> CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
> files.  From examining the blktrace data, it appears that iozone will
> issue an fsync() call, and will have to wait until it's CFQ timeslice
> has expired before the journal thread can run to actually commit data to
> disk.
> 
> The approach below puts an explicit call into the filesystem-specific
> fsync code to yield the disk so that the jbd[2] process has a chance to
> issue I/O.  This bring performance of CFQ in line with deadline.
> 
> There is one outstanding issue with the patch that Vivek pointed out.
> Basically, this could starve out the sync-noidle workload if there is a
> lot of fsync-ing going on.  I'll address that in a follow-on patch.  For
> now, I wanted to get the idea out there for others to comment on.
> 
> Thanks a ton to Vivek for spotting the problem with the initial
> approach, and for his continued review.

I like the concept, it's definitely useful (and your results amply
demonstrate that). I was thinking if there was a way in through the ioc
itself, rather than bdi -> queue and like you are doing. But I can't
think of a nice way to do it, so this is probably as good as it gets.

> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dee9d93..a76ccd1 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2065,7 +2065,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>  	cfqd->serving_group = cfqg;
>  
>  	/* Restore the workload type data */
> -	if (cfqg->saved_workload_slice) {
> +	if (cfqg && cfqg->saved_workload_slice) {
>  		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
>  		cfqd->serving_type = cfqg->saved_workload;
>  		cfqd->serving_prio = cfqg->saved_serving_prio;

Unrelated change?

> +static void cfq_yield(struct request_queue *q)
> +{
> +	struct cfq_data *cfqd = q->elevator->elevator_data;
> +	struct cfq_io_context *cic;
> +	struct cfq_queue *cfqq;
> +	unsigned long flags;
> +
> +	cic = cfq_cic_lookup(cfqd, current->io_context);
> +	if (!cic)
> +		return;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);

spin_lock_irq() is sufficient here.

-- 
Jens Axboe

