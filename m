From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Fri, 28 Oct 2016 20:27:12 +0200
Message-ID: <20161028182712.GM3142@twins.programming.kicks-ass.net>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, axboe@kernel.dk, tytso@mit.edu, jack@suse.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingbo@fb.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477673892-28940-2-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 28, 2016 at 12:58:09PM -0400, Tejun Heo wrote:
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3336,11 +3336,17 @@ static void __sched notrace __schedule(bool preempt)
>  	unsigned long *switch_count;
>  	struct pin_cookie cookie;
>  	struct rq *rq;
> -	int cpu;
> +	int cpu, in_iowait;
>  
>  	cpu = smp_processor_id();
>  	rq = cpu_rq(cpu);
>  	prev = rq->curr;
> +	in_iowait = prev->in_iowait;
> +
> +	if (in_iowait) {
> +		delayacct_blkio_start();
> +		atomic_inc(&rq->nr_iowait);
> +	}
>  
>  	schedule_debug(prev);
>  
> @@ -3406,6 +3412,11 @@ static void __sched notrace __schedule(bool preempt)
>  	}
>  
>  	balance_callback(rq);
> +
> +	if (in_iowait) {
> +		atomic_dec(&rq->nr_iowait);
> +		delayacct_blkio_end();
> +	}
>  }
>  
>  void __noreturn do_task_dead(void)

Urgh, can't say I like this much. It moves two branches into the
schedule path.

Nor do I really like the idea of having to annotate special mutexes for
the iowait crap.

I'll think more after KS/LPC etc..
