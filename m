From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: optimize mark_dirty logic
Date: Wed, 31 Mar 2010 17:06:02 +0200
Message-ID: <20100331150601.GC3322@quack.suse.cz>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0CaPFy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Mar 2010 11:05:54 -0400
Content-Disposition: inline
In-Reply-To: <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Sat 27-03-10 15:15:38, Dmitry Monakhov wrote:
> - Skipp locking if quota is dirty already.
> - Return old quota state to help fs-specciffic implementation to optimize
>   case where quota was dirty already.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/quota/dquot.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index e0b870f..88a8ef2 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -319,14 +319,23 @@ static inline int mark_dquot_dirty(struct dquot *dquot)
>  	return dquot->dq_sb->dq_op->mark_dirty(dquot);
>  }
>  
> +/* Mark dquot dirty in atomic meaner, and return it's old dirty flag state */
>  int dquot_mark_dquot_dirty(struct dquot *dquot)
>  {
> +	int ret = 1;
> +
> +	/* If quota is dirtly already we don't have to acquire dq_list_lock */
> +	if (test_bit(DQ_MOD_B, &dquot->dq_flags))
> +		return 1;
> +
>  	spin_lock(&dq_list_lock);
> -	if (!test_and_set_bit(DQ_MOD_B, &dquot->dq_flags))
> +	if (!test_and_set_bit(DQ_MOD_B, &dquot->dq_flags)) {
>  		list_add(&dquot->dq_dirty, &sb_dqopt(dquot->dq_sb)->
>  				info[dquot->dq_type].dqi_dirty_list);
> +		ret = 0;
> +	}
>  	spin_unlock(&dq_list_lock);
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(dquot_mark_dquot_dirty);
  OK, this looks fine. Merged.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
