From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 01/42] percpu counter: clean up
	percpu_counter_sum_and_set()
Date: Thu, 09 Oct 2008 10:52:52 +0200
Message-ID: <1223542372.7382.30.camel@lappy.programming.kicks-ass.net>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
	 <1223525160-9887-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYJIIyR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 04:54:17 -0400
In-Reply-To: <1223525160-9887-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-10-09 at 00:05 -0400, Theodore Ts'o wrote:
> From: Mingming Cao <cmm@us.ibm.com>
> 
> percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
> the former updates the global counter after accounting.  Since we are
> taking the fbc->lock to calculate the precise value of the counter in
> percpu_counter_sum() anyway, it should simply set fbc->count too, as the
> percpu_counter_sum_and_set() does.
> 
> This patch merge these two interfaces into one.

I totally missed the patch introducing this _and_set() horror, but this
does look like a good cleanup.

Thanks Mingming!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/balloc.c               |    2 +-
>  include/linux/percpu_counter.h |   12 +++---------
>  lib/percpu_counter.c           |    8 +++-----
>  3 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index e9fa960..00a94d5 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1624,7 +1624,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
>  #ifdef CONFIG_SMP
>  	if (free_blocks - root_blocks < FBC_BATCH)
>  		free_blocks =
> -			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
> +			percpu_counter_sum(&sbi->s_freeblocks_counter);
>  #endif
>  	if (free_blocks <= root_blocks)
>  		/* we don't have free space */
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index 2083888..9007ccd 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
>  void percpu_counter_destroy(struct percpu_counter *fbc);
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
> -s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
> +s64 __percpu_counter_sum(struct percpu_counter *fbc);
>  
>  static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>  {
> @@ -44,19 +44,13 @@ static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>  
>  static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
>  {
> -	s64 ret = __percpu_counter_sum(fbc, 0);
> +	s64 ret = __percpu_counter_sum(fbc);
>  	return ret < 0 ? 0 : ret;
>  }
>  
> -static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
> -{
> -	return __percpu_counter_sum(fbc, 1);
> -}
> -
> -
>  static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
>  {
> -	return __percpu_counter_sum(fbc, 0);
> +	return __percpu_counter_sum(fbc);
>  }
>  
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index 4a8ba4b..a866389 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
>   * Add up all the per-cpu counts, return the result.  This is a more accurate
>   * but much slower version of percpu_counter_read_positive()
>   */
> -s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
> +s64 __percpu_counter_sum(struct percpu_counter *fbc)
>  {
>  	s64 ret;
>  	int cpu;
> @@ -62,11 +62,9 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
>  	for_each_online_cpu(cpu) {
>  		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
>  		ret += *pcount;
> -		if (set)
> -			*pcount = 0;
> +		*pcount = 0;
>  	}
> -	if (set)
> -		fbc->count = ret;
> +	fbc->count = ret;
>  
>  	spin_unlock(&fbc->lock);
>  	return ret;

