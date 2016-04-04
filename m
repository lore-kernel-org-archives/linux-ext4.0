From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Mon, 4 Apr 2016 10:36:09 +0300
Message-ID: <57021969.8050504@kyup.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
 <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:34946 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbcDDHgO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2016 03:36:14 -0400
Received: by mail-lf0-f50.google.com with SMTP id c126so37084972lfb.2
        for <linux-ext4@vger.kernel.org>; Mon, 04 Apr 2016 00:36:12 -0700 (PDT)
In-Reply-To: <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 04/02/2016 06:09 AM, Waiman Long wrote:
> This patch introduces a set of simple per-cpu statictics count helper
> functions that can be used by other kernel subsystems for keeping
> track of the number of events that happens. It is per-cpu based to
> reduce overhead and improve accuracy of the counter. Using per-cpu
> counter is usually overkill for such purpose.
> 
> The following APIs are provided:
> 
>  - int percpu_stats_init(struct percpu_stats *pcs, int num)
>    Initialize the per-cpu statictics counts structure which should have
>    the given number of statistics counts. Return -ENOMEM on error.
> 
>  - void percpu_stats_destroy(struct percpu_stats *pcs)
>    Free the percpu memory allocated.
> 
>  - void percpu_stats_inc(struct percpu_stats *pcs, int stat)
>    void percpu_stats_dec(struct percpu_stats *pcs, int stat)
>    Increment and decrement the given per-cpu statistics count.
> 
>  - unsigned long percpu_stats_sum(struct percpu_stats *pcs, int stat)
>    Return the current aggregated sum of the given statistics count.
> 
>  - void percpu_stats_reset(struct percpu_stats *pcs)
>    Clear all the statistics counts defined in the given percpu_stats
>    structure.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
> ---
>  include/linux/percpu_stats.h |  103 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 103 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/percpu_stats.h

Just one minor nit below.
[..]
> +static inline void
> +__percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
> +{
> +	unsigned long *pstat;
> +
> +	if ((unsigned int)stat >= pcs->nstats)
> +		return;
> +	preempt_disable();
> +	pstat = this_cpu_ptr(&pcs->stats[stat]);
> +	*pstat += cnt;
> +	preempt_enable();
> +}

pstat = get_cpu_ptr(&pcs->stats[stat]);
*pstat += cnt;
put_cpu_ptr(&pcs->stats[stat]);

It will generate identical code but this one uses APIs, making the
intention clearer. But as I said this is just a minor nit.

you can add my Reviewed-by: Nikolay Borisov <kernel@kyup.com> for this
particular patch.
