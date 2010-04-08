From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 08 Apr 2010 15:10:58 -0400
Message-ID: <x497hohpxod.fsf@segfault.boston.devel.redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	<20100408110045.GJ10103@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Vivek Goyal <vgoyal@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100408110045.GJ10103@kernel.dk> (Jens Axboe's message of "Thu,
	8 Apr 2010 13:00:45 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> @@ -2065,7 +2065,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>>  	cfqd->serving_group = cfqg;
>>  
>>  	/* Restore the workload type data */
>> -	if (cfqg->saved_workload_slice) {
>> +	if (cfqg && cfqg->saved_workload_slice) {
>>  		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
>>  		cfqd->serving_type = cfqg->saved_workload;
>>  		cfqd->serving_prio = cfqg->saved_serving_prio;
>
> Unrelated change?

Probably not needed for this incarnation of the patch, though previous
iterations would Oops on boot w/o this.  If you look through all of the
code in this code path, cfqg == NULL seems to be handled, so it's
probably safe to take this.  I'll pull it out of this patch, though.

>> +static void cfq_yield(struct request_queue *q)
>> +{
>> +	struct cfq_data *cfqd = q->elevator->elevator_data;
>> +	struct cfq_io_context *cic;
>> +	struct cfq_queue *cfqq;
>> +	unsigned long flags;
>> +
>> +	cic = cfq_cic_lookup(cfqd, current->io_context);
>> +	if (!cic)
>> +		return;
>> +
>> +	spin_lock_irqsave(q->queue_lock, flags);
>
> spin_lock_irq() is sufficient here.

OK, thanks!

Jeff
