From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily
 give up the I/O scheduler.
Date: Fri, 25 Jun 2010 16:02:03 -0400
Message-ID: <20100625200203.GF3351@redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
 <1277242502-9047-2-git-send-email-jmoyer@redhat.com>
 <20100624004622.GA3297@redhat.com>
 <x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0FYUCE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jun 2010 16:02:04 -0400
Content-Disposition: inline
In-Reply-To: <x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 25, 2010 at 12:51:58PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Jun 22, 2010 at 05:35:00PM -0400, Jeff Moyer wrote:
> >
> > [..]
> >> @@ -1614,6 +1620,15 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >>  	cfq_clear_cfqq_wait_request(cfqq);
> >>  	cfq_clear_cfqq_wait_busy(cfqq);
> >>  
> >> +	if (!cfq_cfqq_yield(cfqq)) {
> >> +		struct cfq_rb_root *st;
> >> +		st = service_tree_for(cfqq->cfqg,
> >> +				      cfqq_prio(cfqq), cfqq_type(cfqq));
> >> +		st->last_expiry = jiffies;
> >> +		st->last_pid = cfqq->pid;
> >> +	}
> >> +	cfq_clear_cfqq_yield(cfqq);
> >
> > Jeff, I think cfqq is still on service tree at this point of time. If yes,
> > then we can simply use cfqq->service_tree, instead of calling
> > service_tree_for().
> 
> Yup.
> 
> > No clearing of cfqq->yield_to field?
> 
> Nope.  Again, it's not required, but if you really want me to, I'll add
> it.

I think clearing up is better as it leaves no scope for confusion.

Thanks
Vivek
