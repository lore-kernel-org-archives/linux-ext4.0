From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] percpu_counter: FBC_BATCH might be too big
Date: Fri, 05 Dec 2008 17:40:43 +0100
Message-ID: <1228495243.24126.1.camel@twins>
References: <4939513C.3090101@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Travis <travis@sgi.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752252AbYLEQlB@vger.kernel.org>
In-Reply-To: <4939513C.3090101@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-12-05 at 17:05 +0100, Eric Dumazet wrote:
> For NR_CPUS >= 16 values, FBC_BATCH is 2*NR_CPUS
> 
> Considering more and more distros are using high NR_CPUS values,
> it makes sense to use a more sensible value for FBC_BATCH.
> 
> A sensible value is 2*num_online_cpus(), with a minimum value of 32
> (This minimum value helps branch prediction in __percpu_counter_add())
> 
> We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamically.

Agreed, that is one of the reasons the proportion code doesn't use the
FBC_BATCH stuff.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  include/linux/percpu_counter.h |    6 +-----
>  lib/percpu_counter.c           |   14 +++++++++++++-
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index 9007ccd..c42a184 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -24,11 +24,7 @@ struct percpu_counter {
>  	s32 *counters;
>  };
>  
> -#if NR_CPUS >= 16
> -#define FBC_BATCH	(NR_CPUS*2)
> -#else
> -#define FBC_BATCH	(NR_CPUS*4)
> -#endif
> +extern int FBC_BATCH;
>  
>  int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
>  int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index a866389..2fcf943 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -114,6 +114,16 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
>  }
>  EXPORT_SYMBOL(percpu_counter_destroy);
>  
> +int FBC_BATCH __read_mostly = 32;
> +EXPORT_SYMBOL(FBC_BATCH);
> +
> +static void compute_batch_value(void)
> +{
> +	int nr = num_online_cpus();
> +
> +	FBC_BATCH = max(32, nr*2);
> +}
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  					unsigned long action, void *hcpu)
> @@ -121,6 +131,7 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  	unsigned int cpu;
>  	struct percpu_counter *fbc;
>  
> +	compute_batch_value();
>  	if (action != CPU_DEAD)
>  		return NOTIFY_OK;
>  
> @@ -139,11 +150,12 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  	mutex_unlock(&percpu_counters_lock);
>  	return NOTIFY_OK;
>  }
> +#endif
>  
>  static int __init percpu_counter_startup(void)
>  {
> +	compute_batch_value();
>  	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
>  	return 0;
>  }
>  module_init(percpu_counter_startup);
> -#endif
