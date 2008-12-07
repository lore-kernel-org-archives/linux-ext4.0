From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, take2] percpu_counter: FBC_BATCH might be too big
Date: Sun, 7 Dec 2008 09:09:18 -0800
Message-ID: <20081207090918.595627b2.akpm@linux-foundation.org>
References: <4939513C.3090101@cosmosbay.com>
	<493B9699.8080603@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Travis <travis@sgi.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbYLGRKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 12:10:03 -0500
In-Reply-To: <493B9699.8080603@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 07 Dec 2008 10:25:45 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> In this second version I guarded hotcpu_notifier() call by
> a #ifdef CONFIG_HOTPLUG_CPU
> 
> I wonder why hotcpu_notifier() is not a null op if !CONFIG_HOTPLUG_CPU
> 
> Thank you
> 
> [PATCH] percpu_counter: FBC_BATCH might be too big
> 
> For NR_CPUS >= 16 values, FBC_BATCH is 2*NR_CPUS
> 
> Considering more and more distros are using high NR_CPUS values,
> it makes sense to use a more sensible value for FBC_BATCH.
> 
> A sensible value is 2*num_online_cpus(), with a minimum value of 32
> (This minimum value helps branch prediction in __percpu_counter_add())
> 
> We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamically.

Yup, anything using NR_CPUS is probably wrong.

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

y:/usr/src/linux-2.6.28-rc7> grep -r FBC_BATCH . | wc -l
7

Can we fix this properly please?  It should now become lower case, and
it was a pretty dopey name anyway - now would be a good time to improve
it. `percpu_counter_batch'?

>  int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
>  int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index a866389..e21ce7c 100644
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
> @@ -139,11 +150,14 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  	mutex_unlock(&percpu_counters_lock);
>  	return NOTIFY_OK;
>  }
> +#endif
>  
>  static int __init percpu_counter_startup(void)
>  {
> +	compute_batch_value();
> +#ifdef CONFIG_HOTPLUG_CPU
>  	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
> +#endif
>  	return 0;
>  }
>  module_init(percpu_counter_startup);
> -#endif

hm, now what's going on in there?  We should be able to drop the #ifdef
CONFIG_HOTPLUG_CPU from lib/percpu_counter.c altogether. 
hotcpu_notifier() will do the right thing, and the compiler should
generate no code for percpu_counter_hotcpu_callback() if
CONFIG_HOTPLUG_CPU=n.  

Do

	$EDITOR  $(grep -l hotcpu_notifier */*.c)

and you'll see lots of code gets it right, and lots of code gets it wrong.
