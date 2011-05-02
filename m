From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] ext3: Implement per-cpu counters for delayed
 allocation
Date: Mon, 2 May 2011 14:08:19 -0700
Message-ID: <20110502140819.380ae7fb.akpm@linux-foundation.org>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
	<1304369816-14545-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab1EBVIX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 17:08:23 -0400
In-Reply-To: <1304369816-14545-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon,  2 May 2011 22:56:55 +0200
Jan Kara <jack@suse.cz> wrote:

> Implement free blocks and reserved blocks counters for delayed allocation.
> These counters are reliable in the sence that when they return success, the
> subsequent conversion from reserved to allocated blocks always succeeds (see
> comments in the code for details). This is useful for ext3 filesystem to
> implement delayed allocation in particular for allocation in page_mkwrite.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/delalloc_counter.c |  109 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext3/delalloc_counter.h |   73 +++++++++++++++++++++++++++++
>  2 files changed, 182 insertions(+), 0 deletions(-)
>  create mode 100644 fs/ext3/delalloc_counter.c
>  create mode 100644 fs/ext3/delalloc_counter.h
> 
> diff --git a/fs/ext3/delalloc_counter.c b/fs/ext3/delalloc_counter.c
> new file mode 100644
> index 0000000..b584961
> --- /dev/null
> +++ b/fs/ext3/delalloc_counter.c
> @@ -0,0 +1,109 @@
> +/*
> + *  Per-cpu counters for delayed allocation
> + */
> +#include <linux/percpu_counter.h>
> +#include <linux/module.h>
> +#include <linux/log2.h>
> +#include "delalloc_counter.h"
> +
> +static long dac_error(struct delalloc_counter *c)
> +{
> +#ifdef CONFIG_SMP
> +	return c->batch * nr_cpu_ids;
> +#else
> +	return 0;
> +#endif
> +}

This function needs a comment please.

The use of nr_cpu_ids was a surprise.  Why not num_online_cpus() or
num_possible_cpus()?  Please change the code so that readers can
understand the reasoning here.

> +/*
> + * Reserve blocks for delayed allocation
> + *
> + * This code is subtle because we want to avoid synchronization of processes
> + * doing allocation in the common case when there's plenty of space in the
> + * filesystem.
> + *
> + * The code maintains the following property: Among all the calls to
> + * dac_reserve() that return 0 there exists a simple sequential ordering of
> + * these calls such that the check (free - reserved >= limit) in each call
> + * succeeds. This guarantees that we never reserve blocks we don't have.
> + *
> + * The proof of the above invariant: The function can return 0 either when the
> + * first if succeeds or when both ifs fail. To the first type of callers we
> + * assign the time of read of c->reserved in the first if, to the second type
> + * of callers we assign the time of read of c->reserved in the second if. We
> + * order callers by their assigned time and claim that this is the ordering
> + * required by the invariant. Suppose that a check (free - reserved >= limit)
> + * fails for caller C in the proposed ordering. We distinguish two cases:
> + * 1) function called by C returned zero because the first if succeeded - in
> + *  this case reads of counters in the first if must have seen effects of
> + *  __percpu_counter_add of all the callers before C (even their condition
> + *  evaluation happened before our). The errors accumulated in cpu-local
> + *  variables are clearly < dac_error(c) and thus the condition should fail.
> + *  Contradiction.
> + * 2) function called by C returned zero because the second if failed - again
> + *  the read of the counters must have seen effects of __percpu_counter_add of
> + *  all the callers before C and thus the condition should have succeeded.
> + *  Contradiction.
> + */

Geeze.  I'll believe you :)

> +EXPORT_SYMBOL(dac_reserve);
> +EXPORT_SYMBOL(dac_alloc_reserved);
> +EXPORT_SYMBOL(dac_init);
> +EXPORT_SYMBOL(dac_destroy);

I'm not sure that these are needed?
