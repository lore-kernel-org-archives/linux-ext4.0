From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] quota: Generate warnings for DQUOT_SPACE_NOFAIL
 allocations
Date: Tue, 10 Oct 2017 22:20:16 +0800
Message-ID: <20171010142016.GM10593@eguan.usersys.redhat.com>
References: <20171010125724.14156-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755688AbdJJOUS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 10 Oct 2017 10:20:18 -0400
Content-Disposition: inline
In-Reply-To: <20171010125724.14156-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 10, 2017 at 02:57:24PM +0200, Jan Kara wrote:
> Eryu has reported that since commit 7b9ca4c61bc2 "quota: Reduce
> contention on dq_data_lock" test generic/233 occasionally fails. This is
> caused by the fact that since that commit we don't generate warning and
> set grace time for quota allocations that have DQUOT_SPACE_NOFAIL set
> (these are for example some metadata allocations in ext4). We need these
> allocations to behave regularly wrt warning generation and grace time
> setting so fix the code to return to the original behavior.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>

With this patch applied, I ran generic/233 on ext4 for 150 iterations
without hitting a failure. Thanks!

Tested-by: Eryu Guan <eguan@redhat.com>

> CC: stable@vger.kernel.org
> Fixes: 7b9ca4c61bc278b771fb57d6290a31ab1fc7fdac
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/quota/dquot.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> I plan to queue this patch into my tree and send it to Linus for -rc5.
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 50b0556a124f..52ad15192e72 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1297,21 +1297,18 @@ static int dquot_add_space(struct dquot *dquot, qsize_t space,
>  	spin_lock(&dquot->dq_dqb_lock);
>  	if (!sb_has_quota_limits_enabled(sb, dquot->dq_id.type) ||
>  	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
> -		goto add;
> +		goto finish;
>  
>  	tspace = dquot->dq_dqb.dqb_curspace + dquot->dq_dqb.dqb_rsvspace
>  		+ space + rsv_space;
>  
> -	if (flags & DQUOT_SPACE_NOFAIL)
> -		goto add;
> -
>  	if (dquot->dq_dqb.dqb_bhardlimit &&
>  	    tspace > dquot->dq_dqb.dqb_bhardlimit &&
>              !ignore_hardlimit(dquot)) {
>  		if (flags & DQUOT_SPACE_WARN)
>  			prepare_warning(warn, dquot, QUOTA_NL_BHARDWARN);
>  		ret = -EDQUOT;
> -		goto out;
> +		goto finish;
>  	}
>  
>  	if (dquot->dq_dqb.dqb_bsoftlimit &&
> @@ -1322,7 +1319,7 @@ static int dquot_add_space(struct dquot *dquot, qsize_t space,
>  		if (flags & DQUOT_SPACE_WARN)
>  			prepare_warning(warn, dquot, QUOTA_NL_BSOFTLONGWARN);
>  		ret = -EDQUOT;
> -		goto out;
> +		goto finish;
>  	}
>  
>  	if (dquot->dq_dqb.dqb_bsoftlimit &&
> @@ -1338,13 +1335,21 @@ static int dquot_add_space(struct dquot *dquot, qsize_t space,
>  			 * be always printed
>  			 */
>  			ret = -EDQUOT;
> -			goto out;
> +			goto finish;
>  		}
>  	}
> -add:
> -	dquot->dq_dqb.dqb_rsvspace += rsv_space;
> -	dquot->dq_dqb.dqb_curspace += space;
> -out:
> +finish:
> +	/*
> +	 * We have to be careful and go through warning generation & grace time
> +	 * setting even if DQUOT_SPACE_NOFAIL is set. That's why we check it
> +	 * only here...
> +	 */
> +	if (flags & DQUOT_SPACE_NOFAIL)
> +		ret = 0;
> +	if (!ret) {
> +		dquot->dq_dqb.dqb_rsvspace += rsv_space;
> +		dquot->dq_dqb.dqb_curspace += space;
> +	}
>  	spin_unlock(&dquot->dq_dqb_lock);
>  	return ret;
>  }
> -- 
> 2.12.3
> 
