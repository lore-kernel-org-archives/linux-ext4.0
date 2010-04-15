From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/4] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Thu, 15 Apr 2010 11:49:22 -0400
Message-ID: <x49fx2wemwt.fsf@segfault.boston.devel.redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
	<1271279826-30294-3-git-send-email-jmoyer@redhat.com>
	<20100414214654.GD3167@redhat.com> <20100415103323.GW27497@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0DOPt1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 11:49:27 -0400
In-Reply-To: <20100415103323.GW27497@kernel.dk> (Jens Axboe's message of "Thu,
	15 Apr 2010 12:33:23 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Axboe <jens.axboe@oracle.com> writes:

> On Wed, Apr 14 2010, Vivek Goyal wrote:

>> > @@ -1887,6 +1891,9 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>> >  
>> >  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
>> >  	cfqq->nr_sectors += blk_rq_sectors(rq);
>> > +
>> > +	if (cfq_cfqq_yield(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
>> > +		cfq_yield_cfqq(cfqd, cfqq);
>> 
>> Jeff,
>> 
>> I am wondering if cfq_select_queue() will be a better place for yielding
>> the queue.
>> 
>> 	if (cfq_cfqq_yield(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
>> 			goto expire;
>> 
>> We can avoid one unnecessary __blk_run_queue().
>
> Agree, doing it on insert is not the right place.

I see where you're coming from, but that makes things quite a bit
trickier.  I look forward to the review of *that* patch.  ;-)

Cheers,
Jeff
