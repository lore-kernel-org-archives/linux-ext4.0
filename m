From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V4 1/3] quota: Add reservation support for delayed
	block allocation
Date: Mon, 15 Dec 2008 14:16:08 +0100
Message-ID: <20081215131608.GC15464@duck.suse.cz>
References: <1229114856.7646.25.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37393 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753322AbYLONQL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 08:16:11 -0500
Content-Disposition: inline
In-Reply-To: <1229114856.7646.25.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Minming,

On Fri 12-12-08 12:47:36, Mingming Cao wrote:
> Quota: Add quota reservation support
> 
> Delayed allocation defers the block allocation at the dirty pages
> flush-out time, doing quota charge/check at that time is too late.
> But we can't charge the quota blocks until blocks are really allocated,
> otherwise users could get overcharged after reboot from system crash.
> 
> This patch adds quota reservation for delayed llocation. Quota blocks
> are reserved in memory, inode and quota won't gets dirtied until later
> block allocation time.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> 
> ---
>  fs/dquot.c               |  109 +++++++++++++++++++++++++++++++++--------------
>  include/linux/quota.h    |    2 
>  include/linux/quotaops.h |   22 +++++++++
>  3 files changed, 102 insertions(+), 31 deletions(-)
> 
> Index: linux-2.6.28-rc2/fs/dquot.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-11-06 13:36:21.000000000 -0800
> +++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:20:45.000000000 -0800
<snip>
> @@ -1227,49 +1237,85 @@ void vfs_dq_drop(struct inode *inode)
>  /*
>   * This operation can block, but only after everything is updated
>   */
> -int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> +int __dquot_alloc_space(struct inode *inode, qsize_t number,
> +			int warn, int reserve)
>  {
> -	int cnt, ret = NO_QUOTA;
> +	int cnt, ret = QUOTA_OK;
>  	char warntype[MAXQUOTAS];
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
> -	if (IS_NOQUOTA(inode)) {
> -out_add:
> -		inode_add_bytes(inode, number);
> -		return QUOTA_OK;
> -	}
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
>  		warntype[cnt] = QUOTA_NL_NOWARN;
>  
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -	if (IS_NOQUOTA(inode)) {	/* Now we can do reliable test... */
> -		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -		goto out_add;
> -	}
>  	spin_lock(&dq_data_lock);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		if (inode->i_dquot[cnt] == NODQUOT)
>  			continue;
> -		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt) == NO_QUOTA)
> -			goto warn_put_all;
> +		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
> +		    == NO_QUOTA) {
> +			ret = NO_QUOTA;
> +			goto out_unlock;
> +		}
>  	}
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		if (inode->i_dquot[cnt] == NODQUOT)
>  			continue;
> -		dquot_incr_space(inode->i_dquot[cnt], number);
> +		if (reserve)
> +			dquot_resv_space(inode->i_dquot[cnt], number);
> +		else{
                    ^ here is missing space

> +			dquot_incr_space(inode->i_dquot[cnt], number);
> +			inode_add_bytes(inode, number);
> +		}
>  	}
> -	inode_add_bytes(inode, number);
> -	ret = QUOTA_OK;
> -warn_put_all:
> -	spin_unlock(&dq_data_lock);
> -	if (ret == QUOTA_OK)
> -		/* Dirtify all the dquots - this can block when journalling */
> -		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> -			if (inode->i_dquot[cnt])
> -				mark_dquot_dirty(inode->i_dquot[cnt]);
> +out_unlock:
>  	flush_warnings(inode->i_dquot, warntype);
> +	spin_unlock(&dq_data_lock);
  We can't do flush_warnings() inside the spinlock - that function can
sleep. Please move the call outside the lock.

> +	return ret;
> +}
> +
> +int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> +{
> +	int cnt, ret = QUOTA_OK;
> +
> +	/*
> +	 * First test before acquiring mutex - solves deadlocks when we
> +	 * re-enter the quota code and are already holding the mutex
> +	 */
> +	if (IS_NOQUOTA(inode))
> +		goto out;
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))
> +		goto out_unlock;
> +
> +	ret = __dquot_alloc_space(inode, number, warn, 0);
> +	if (ret == NO_QUOTA)
> +		goto out_unlock;
> +
> +	/* Dirtify all the dquots - this can block when journalling */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> +		if (inode->i_dquot[cnt])
> +			mark_dquot_dirty(inode->i_dquot[cnt]);
> +out_unlock:
>  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +out:
> +	return ret;
> +}
> +
> +int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
> +{
> +	int ret = QUOTA_OK;
> +
> +	if (IS_NOQUOTA(inode))
> +		goto out;
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))
> +		goto out_unlock;
> +
> +	ret = __dquot_alloc_space(inode, number, warn, 1);
> +out_unlock:
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +out:
>  	return ret;
>  }
  <snip>

  And one global comment: I see you haven't still resolved the problem
with dquot_transfer(). I've been thinking about it a bit and I realized you
really cannot increase i_blocks already when reserving space as I suggested
because then i_blocks would be inconsistent after the crash.
  Thus the only correct possibility is to keep amount of space reserved for
an inode (which ext4 already does) and when dquot_transfer() is called,
transfer this amount of quota reservation from a source user to a target
user.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
