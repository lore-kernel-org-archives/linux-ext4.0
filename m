From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Use printk_ratelimit() in
 journal_alloc_journal_head()
Date: Mon, 4 Oct 2010 11:43:32 +0200
Message-ID: <20101004094331.GC3589@quack.suse.cz>
References: <1286183834-10548-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab0JDJoZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Oct 2010 05:44:25 -0400
Content-Disposition: inline
In-Reply-To: <1286183834-10548-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 04-10-10 18:17:14, Namhyung Kim wrote:
>  #ifdef CONFIG_JBD_DEBUG
>  	atomic_inc(&nr_journal_heads);
> @@ -1726,11 +1725,10 @@ static struct journal_head *journal_alloc_journal_head(void)
>  	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
>  	if (ret == NULL) {
>  		jbd_debug(1, "out of memory for journal_head\n");
> -		if (time_after(jiffies, last_warning + 5*HZ)) {
> +		if (printk_ratelimit())
>  			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
>  			       __func__);
> -			last_warning = jiffies;
> -		}
> +
  OK, but can we convert this directly to printk_ratelimited please?
Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
