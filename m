From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] percpu_counter: use local_t and atomic_long_t if
 possible
Date: Fri, 12 Dec 2008 12:29:37 +0100
Message-ID: <1229081377.12883.134.camel@twins>
References: <4936D287.6090206@cosmosbay.com>
	 <20081209214921.b3944687.akpm@linux-foundation.org>
	 <49404925.7090902@cosmosbay.com> <200812121847.06432.rusty@rustcorp.com.au>
	 <49424637.3010107@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <cl@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757712AbYLLL3y@vger.kernel.org>
In-Reply-To: <49424637.3010107@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-12-12 at 12:08 +0100, Eric Dumazet wrote:
> After discussions on percpu_counter subject, I cooked following patch
> 
> My goals were :
> 
> - IRQ safe percpu_counter (needed for net-next-2.6)
> z- 64bit platforms can avoid spin_lock and reduce size of percpu_counter
> - No increase of API
> 
> Final result, on x86_64, __percpu_counter_add() is really fast and irq safe :

> Changes are :
> 
> We use local_t instead of s32 for the local storage (for each cpu)

do enough arches have a sane enough local_t implementation so this
doesn't make things worse for them?

> We use atomic_long_t instead of s64 on 64bit arches, to avoid spin_lock.
> 
> On 32bit arches, we guard the shared s64 value with an irqsafe spin_lock.
> As this spin_lock is not taken in fast path, this should not make a real
> difference.

Cycles are cycles, and spin_lock_irqsave is more expensive than
spin_lock_irq is more expensive than spin_lock, but sure, it looks good.

I really like the code, however my worry is that we don't regress weird
archs too much.

> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  include/linux/percpu_counter.h |   38 +++++++++--
>  lib/percpu_counter.c           |  104 ++++++++++++++++++-------------
>  2 files changed, 94 insertions(+), 48 deletions(-)
> 
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index 9007ccd..f5133ce 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -12,16 +12,42 @@
>  #include <linux/threads.h>
>  #include <linux/percpu.h>
>  #include <linux/types.h>
> +#include <asm/local.h>
>  
>  #ifdef CONFIG_SMP
>  
> +#ifdef CONFIG_64BIT
> +struct s64_counter {
> +	atomic_long_t val;
> +};
> +
> +static inline s64 s64c_read(struct s64_counter *c)
> +{
> +	return atomic_long_read(&c->val);
> +}
> +#else
> +struct s64_counter {
> +	spinlock_t	lock;
> +	s64		val;
> +};
> +
> +static inline s64 s64c_read(struct s64_counter *c)
> +{
> +	/*
> +	 * Previous percpu_counter implementation used to
> +	 * read s64 without locking. Thats racy.
> +	 */

Does this comment have any value besides archelogical? but yeah, that
was a known issue, there were some seqlock patches floating around
trying to address this.

Here I'd suggest taking that lock and fixing that race.

> +	return c->val;
> +}
> +
> +#endif

> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index b255b93..6ef4a44 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -14,35 +14,58 @@ static LIST_HEAD(percpu_counters);
>  static DEFINE_MUTEX(percpu_counters_lock);
>  #endif
>  
> +#ifdef CONFIG_64BIT
> +static inline void s64c_add(s64 amount, struct s64_counter *c)
> +{
> +	atomic_long_add(amount, &c->val);
> +}
> +
> +static inline void s64c_set(struct s64_counter *c, s64 amount)
> +{
> +	atomic_long_set(&c->val, amount);
> +}
> +
> +#else
> +
> +static inline void s64c_add(s64 amount, struct s64_counter *c)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&c->lock, flags);
> +	c->val += amount;
> +	spin_unlock_irqrestore(&c->lock, flags);
> +}
> +
> +static inline void s64c_set(struct s64_counter *c, s64 amount)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&c->lock, flags);
> +	c->val = amount;
> +	spin_unlock_irqrestore(&c->lock, flags);
> +}
> +#endif /* CONFIG_64BIT */

Since they're inline's anyway, does it look better to stick them in the
header along with s64c_read() ?

>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
>  {
>  	int cpu;
>  
> +	for_each_possible_cpu(cpu)
> +		local_set(per_cpu_ptr(fbc->counters, cpu), 0);
> +	s64c_set(&fbc->counter, amount);
>  }

Did we document somewhere that this function is racy and only meant as
initialization?

> +void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch)
>  {
> +	long count;
> +	local_t *pcount;
> +
> +	pcount = per_cpu_ptr(fbc->counters, get_cpu());
> +	count = local_add_return(amount, pcount);
> +	if (unlikely(count >= batch || count <= -batch)) {
> +		local_sub(count, pcount);
> +		s64c_add(count, &fbc->counter);
>  	}
>  	put_cpu();
>  }

very neat.


> @@ -91,8 +111,13 @@ int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
>  	int err;
>  
>  	err = percpu_counter_init(fbc, amount);
> -	if (!err)
> -		lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
> +#ifndef CONFIG_64BIT
> +	if (!err) {
> +		static struct lock_class_key percpu_counter_irqsafe;
> +
> +		lockdep_set_class(&fbc->counter.lock, &percpu_counter_irqsafe);
> +	}
> +#endif

Since they're all irqsafe can this be removed?

>  	return err;
>  }
