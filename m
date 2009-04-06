From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 08:25:50 +0200
Message-ID: <20090406062549.GO5178@kernel.dk>
References: <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <20090405115629.521057fc@infradead.org> <alpine.LFD.2.00.0904051227120.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arjan van de Ven <arjan@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52730 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZDFGZw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 02:25:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904051227120.4023@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 05 2009, Linus Torvalds wrote:
> 
> 
> On Sun, 5 Apr 2009, Arjan van de Ven wrote:
> >
> > > See get_request():
> > 
> > our default number of requests is so low that we very regularly hit the
> > limit. In addition to setting kjournald to higher priority, I tend to
> > set the number of requests to 4096 or so to improve interactive
> > performance on my own systems. That way at least the elevator has a
> > chance to see the requests ;-)
> 
> That's insane. Long queues make the problem harder to hit, yes. But it 
> also tends to make the problem them a million times worse when you _do_ 
> hit it.

Unfortunately it is insane, because the vm will barf big time on that.
Perhaps when we do the "throttle at device IO rate" for dirtying of data
we can be more relaxed, but increasing nr_requests too much will just
cause the vm to go nuts.

> I would suggest looking instead at trying to have separate allocation 
> pools for bulk and "sync" IO. Instead of having just one rq->rq_pool, we 
> could easily have a rq->rq_bulk_pool and rq->rq_sync_pool.
> 
> We might even _save_ memory by having two pools simply because that may 
> make it much less important to have a big pool. Most subsystems don't 
> really need that many requests in flight anyway, and the advantage to the 
> elevator of huge pools is rather dubious.

The pools are not big, the number is just a maximum allocation number.
In reality we only store 4 requests in the mempool, and we should
probably just dump that down to 1.

-- 
Jens Axboe

