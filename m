From: Pavan Kondeti <pkondeti@codeaurora.org>
Subject: Re: [PATCH 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Thu, 3 Nov 2016 21:03:45 +0530
Message-ID: <CAEU1=P=xnwZwqZE_XLF2b5ZOv_iPwQWYmXBwpvgEVn3_EckhSA@mail.gmail.com>
References: <1477673892-28940-1-git-send-email-tj@kernel.org> <1477673892-28940-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        axboe@kernel.dk, tytso@mit.edu, jack@suse.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingbo@fb.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477673892-28940-2-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Tejun,

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 94732d1..f6baa38 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3336,11 +3336,17 @@ static void __sched notrace __schedule(bool preempt)
>         unsigned long *switch_count;
>         struct pin_cookie cookie;
>         struct rq *rq;
> -       int cpu;
> +       int cpu, in_iowait;
>
>         cpu = smp_processor_id();
>         rq = cpu_rq(cpu);
>         prev = rq->curr;
> +       in_iowait = prev->in_iowait;
> +
> +       if (in_iowait) {
> +               delayacct_blkio_start();
> +               atomic_inc(&rq->nr_iowait);
> +       }
>
>         schedule_debug(prev);
>
> @@ -3406,6 +3412,11 @@ static void __sched notrace __schedule(bool preempt)
>         }
>
>         balance_callback(rq);
> +
> +       if (in_iowait) {
> +               atomic_dec(&rq->nr_iowait);
> +               delayacct_blkio_end();
> +       }
>  }

I think, the nr_iowait update can go wrong here.

When the task migrates to a different CPU upon wakeup, this rq points
to a different CPU from the one on which nr_iowait is incremented
before.

Thanks,
Pavan

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
Linux Foundation Collaborative Project
