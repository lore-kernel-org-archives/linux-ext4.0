From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3 v2] quota: avoid unnecessary dqget()/dqput() calls
Date: Mon, 2 Jun 2014 09:42:45 +0200
Message-ID: <20140602074245.GB3224@quack.suse.cz>
References: <537DD5BA.1050105@gmail.com>
 <538464AD.6050407@gmail.com>
 <20140527101219.GA28035@infradead.org>
 <538541A3.2060102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaFBHmr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 03:42:47 -0400
Content-Disposition: inline
In-Reply-To: <538541A3.2060102@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-05-14 09:53:39, Niu Yawei wrote:
> Avoid unnecessary dqget()/dqput() calls in __dquot_initialize(),
> that will introduce global lock contention otherwise.
  The patch looks good. Just two minor nits below.

								Honza
 
> Signed-off-by: Lai Siyao <lai.siyao@intel.com>
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>
> ---
>  fs/quota/dquot.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 9cd5f63..dc6f711 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1400,7 +1400,7 @@ static int dquot_active(const struct inode *inode)
>   */
>  static void __dquot_initialize(struct inode *inode, int type)
>  {
> -	int cnt;
> +	int cnt, dq_get = 0;
>  	struct dquot *got[MAXQUOTAS];
>  	struct super_block *sb = inode->i_sb;
>  	qsize_t rsv;
> @@ -1416,6 +1416,13 @@ static void __dquot_initialize(struct inode *inode, int type)
>  		got[cnt] = NULL;
>  		if (type != -1 && cnt != type)
>  			continue;
> +		/* the i_dquot should have been initialized in most case,
							      cases ^^^
> +		 * we check it without locking here to avoid unnecessary
> +		 * dqget()/dqput() calls. */
  Please fix the comment style - scripts/checkpatch.pl is your friend.

> +		if (inode->i_dquot[cnt])
> +			continue;
> +		dq_get = 1;
  init_needed or something like that would be a better name I think.

> +
>  		switch (cnt) {
>  		case USRQUOTA:
>  			qid = make_kqid_uid(inode->i_uid);
> @@ -1427,6 +1434,10 @@ static void __dquot_initialize(struct inode *inode, int type)
>  		got[cnt] = dqget(sb, qid);
>  	}
>  
> +	/* all required i_dquot has been initialized */
> +	if (!dq_get)
> +		return;
> +
>  	down_write(&sb_dqopt(sb)->dqptr_sem);
>  	if (IS_NOQUOTA(inode))
>  		goto out_err;
> -- 
> 1.7.1
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
