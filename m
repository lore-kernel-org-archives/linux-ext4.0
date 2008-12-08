From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: FBC_BATCH should be a variable
Date: Mon, 8 Dec 2008 00:19:40 -0800
Message-ID: <20081208001940.94737420.akpm@linux-foundation.org>
References: <4939513C.3090101@cosmosbay.com>
	<493B9699.8080603@cosmosbay.com>
	<20081207090918.595627b2.akpm@linux-foundation.org>
	<493C1632.2000901@cosmosbay.com>
	<20081207203244.10372834.akpm@linux-foundation.org>
	<493CD530.4020808@cosmosbay.com>
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
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbYLHIT6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 03:19:58 -0500
In-Reply-To: <493CD530.4020808@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 08 Dec 2008 09:05:04 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Andrew Morton a __crit :
> > On Sun, 07 Dec 2008 19:30:10 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> >>> Do
> >>>
> >>> 	$EDITOR  $(grep -l hotcpu_notifier */*.c)
> >>>
> >>> and you'll see lots of code gets it right, and lots of code gets it wrong.
> >> I see nothing interesting, I must be blind.
> >>
> >> lib/percpu_counter.c: In function 'percpu_counter_startup':
> >> lib/percpu_counter.c:158: error: 'percpu_counter_hotcpu_callback' undeclared (first use in this function)
> >> lib/percpu_counter.c:158: error: (Each undeclared identifier is reported only once
> >> lib/percpu_counter.c:158: error: for each function it appears in.)
> >> make[1]: *** [lib/percpu_counter.o] Error 1
> > 
> > Perhaps you still had percpu_counter_hotcpu_callback inside #ifdef.
> > 
> > That a look at kernel/workqueue.c, fs/buffer.c.  No #ifdef CONFIG_HOTPLUG_CPU
> > needed at all.
> 
> We still need some #ifdef or we also must also delete them around "struct list_head list"
> in include/linux/percpu_counter.h and grow struct percpu_counter.
> 
> lib/percpu_counter.c: In function 'percpu_counter_hotcpu_callback':
> lib/percpu_counter.c:137: error: 'struct percpu_counter' has no member named 'list'
> lib/percpu_counter.c:137: warning: type defaults to 'int' in declaration of '__mptr'
> lib/percpu_counter.c:137: warning: initialization from incompatible pointer type
> ...
> 

Yes, this conditionality:

struct percpu_counter {
	spinlock_t lock;
	s64 count;
#ifdef CONFIG_HOTPLUG_CPU
	struct list_head list;	/* All percpu_counters are on a list */
#endif
	s32 *counters;
};

mucked up our nice scheme.  Oh well.

> +static void compute_batch_value(void)
> +{
> +	int nr = num_online_cpus();
> +
> +	percpu_counter_batch = max(32, nr*2);
> +}
> +
>  static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  					unsigned long action, void *hcpu)
>  {
> +#ifdef CONFIG_HOTPLUG_CPU
>  	unsigned int cpu;
>  	struct percpu_counter *fbc;
>  
> +	compute_batch_value();
>  	if (action != CPU_DEAD)
>  		return NOTIFY_OK;
>  
> @@ -137,13 +146,14 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  		spin_unlock_irqrestore(&fbc->lock, flags);
>  	}
>  	mutex_unlock(&percpu_counters_lock);
> +#endif
>  	return NOTIFY_OK;
>  }
>  
>  static int __init percpu_counter_startup(void)
>  {
> +	compute_batch_value();
>  	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
>  	return 0;
>  }
>  module_init(percpu_counter_startup);

compute_batch_value() can be __cpuinit, but I think we're close enough
here ;)

