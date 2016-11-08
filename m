From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Tue, 8 Nov 2016 17:51:02 -0500
Message-ID: <20161108225102.GA6460@htj.duckdns.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
 <CAEU1=P=xnwZwqZE_XLF2b5ZOv_iPwQWYmXBwpvgEVn3_EckhSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        axboe@kernel.dk, tytso@mit.edu, jack@suse.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingbo@fb.com
To: Pavan Kondeti <pkondeti@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEU1=P=xnwZwqZE_XLF2b5ZOv_iPwQWYmXBwpvgEVn3_EckhSA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Thu, Nov 03, 2016 at 09:03:45PM +0530, Pavan Kondeti wrote:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 94732d1..f6baa38 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -3336,11 +3336,17 @@ static void __sched notrace __schedule(bool preempt)
> >         unsigned long *switch_count;
> >         struct pin_cookie cookie;
> >         struct rq *rq;
> > -       int cpu;
> > +       int cpu, in_iowait;
> >
> >         cpu = smp_processor_id();
> >         rq = cpu_rq(cpu);
> >         prev = rq->curr;
> > +       in_iowait = prev->in_iowait;
> > +
> > +       if (in_iowait) {
> > +               delayacct_blkio_start();
> > +               atomic_inc(&rq->nr_iowait);
> > +       }
> >
> >         schedule_debug(prev);
> >
> > @@ -3406,6 +3412,11 @@ static void __sched notrace __schedule(bool preempt)
> >         }
> >
> >         balance_callback(rq);
> > +
> > +       if (in_iowait) {
> > +               atomic_dec(&rq->nr_iowait);
> > +               delayacct_blkio_end();
> > +       }
> >  }
> 
> I think, the nr_iowait update can go wrong here.
> 
> When the task migrates to a different CPU upon wakeup, this rq points
> to a different CPU from the one on which nr_iowait is incremented
> before.

Ah, you're right, it should remember the original rq.

Thanks.

-- 
tejun
