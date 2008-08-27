From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH -v2] percpu_counters: make fbc->count read atomic on
 32 bit architecture
Date: Tue, 26 Aug 2008 17:26:58 -0700
Message-ID: <20080826172658.120144fa.akpm@linux-foundation.org>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbYH0Adz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2008 20:33:55 -0400
In-Reply-To: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Aug 2008 16:50:28 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> fbc->count is of type s64. The change was introduced by
> 0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
> from long to s64. Moving to s64 also means on 32 bit architectures
> we can get wrong values on fbc->count. Since fbc->count is read
> more frequently and updated rarely use seqlocks. This should
> reduce the impact of locking in the read path for 32bit arch.
> 
> percpu_counter_read is used within interrupt context also. So
> use the irq safe version of seqlock while reading
> 

The linux-ext4 list is not an appropriate place for discussing a
kernel-wide change.

>  include/linux/percpu_counter.h |   29 +++++++++++++++++++++++++----
>  lib/percpu_counter.c           |   20 ++++++++++----------
>  2 files changed, 35 insertions(+), 14 deletions(-)

Which this one surely is.  I added linux-kernel to cc.

> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index 9007ccd..36f3d2d 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -6,7 +6,7 @@
>   * WARNING: these things are HUGE.  4 kbytes per counter on 32-way P4.
>   */
>  
> -#include <linux/spinlock.h>
> +#include <linux/seqlock.h>
>  #include <linux/smp.h>
>  #include <linux/list.h>
>  #include <linux/threads.h>
> @@ -16,7 +16,7 @@
>  #ifdef CONFIG_SMP
>  
>  struct percpu_counter {
> -	spinlock_t lock;
> +	seqlock_t lock;
>  	s64 count;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	struct list_head list;	/* All percpu_counters are on a list */
> @@ -53,10 +53,31 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
>  	return __percpu_counter_sum(fbc);
>  }
>  
> -static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> +#if BITS_PER_LONG == 64
> +static inline s64 fbc_count(struct percpu_counter *fbc)
>  {
>  	return fbc->count;
>  }
> +#else
> +/* doesn't have atomic 64 bit operation */
> +static inline s64 fbc_count(struct percpu_counter *fbc)
> +{
> +	s64 ret;
> +	unsigned seq;
> +	unsigned long flags;
> +	do {
> +		seq = read_seqbegin_irqsave(&fbc->lock, flags);
> +		ret = fbc->count;
> +	} while(read_seqretry_irqrestore(&fbc->lock, seq, flags));
> +	return ret;
> +
> +}
> +#endif

The problem of atomically handling 64-bit quantities on 32-bit machines
is by no means unique to percpu_counters.  We sorta-solved it for
i_size and we continue to sorta-not-solve it for loff_t and surely
there are other places which already sorta-solve it and which will be
sorta-solved in the future.

All of which tells us that we need a real solution, at a lower level.

We already have a suitable type, really: atomic64_t.  But it's an
arch-private thing and is only implemented on 64-bit architectures.

Perhaps atomic64_t should be promoted to being a kernel-wide facility?

