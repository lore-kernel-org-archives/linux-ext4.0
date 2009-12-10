From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/3] quota: convert to generic reserved space management
Date: Wed, 09 Dec 2009 16:19:20 -0800
Message-ID: <1260404360.4018.550.camel@mingming-laptop>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
	 <1260324686-15863-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57694 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbZLJATj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Dec 2009 19:19:39 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nBA0HIWl031328
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 17:17:18 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBA0JOv9162488
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 17:19:28 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBA0JMpB032051
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 17:19:24 -0700
In-Reply-To: <1260324686-15863-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-12-09 at 05:11 +0300, Dmitry Monakhov wrote:
> Before this patch fs_rsv_space must be always equals to
> quot_rsv_space all the time. Otherwise dquot_transfer()
> will result in incorrect quota(because fs_rsv_space is used
> on transfer).

By incorrect quota I assume you mean nagetive reserved quota?

I have asked Jan before whether we should transfer the reserved
quota...I still not quit sure..in fact the more I am thinking, I think
the reserved quota should not transfered until they are claimed.

I am going to cook a patch for this...

After that patch, we shall not see the negative quota reservation
values. 

>  This result in complex locking order issues
> aka http://bugzilla.kernel.org/show_bug.cgi?id=14739
> After this patch quot_rsv_space will be transferred on
> dquot_transfer(), this automatically solves locking issues.
> 

This bug could be easily fixed by just drop the i_block_reservation lock
before release reserved quota.

> - Unify dquot_reserve_space() and dquot_reserve_space()
> - Unify dquot_release_reserved_space() and dquot_free_space()
> - Also this patch add missing warning update to release_rsv()
>   dquot_release_reserved_space() must call flush_warnings() as
>   dquot_free_space() does.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/quota/dquot.c      |  169 +++++++++++++++++++++---------------------------
>  include/linux/quota.h |    2 -
>  2 files changed, 74 insertions(+), 97 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 39b49c4..4bc5ac8 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1396,6 +1396,22 @@ EXPORT_SYMBOL(vfs_dq_drop);
>   * inode write go into the same transaction.
>   */
> 
> +static void __inode_add_bytes(struct inode *inode, qsize_t number, int reserve)
> +{
> +	if (reserve)
> +		inode_add_rsv_blocks(inode, number >> 9);
> +	else
> +		inode_add_bytes(inode, number);
> +}
> +
> +static void __inode_sub_bytes(struct inode *inode, qsize_t number, int reserve)
> +{
> +	if (reserve)
> +		inode_sub_rsv_blocks(inode, number >> 9);
> +	else
> +		inode_sub_bytes(inode, number);
> +}
> +
>  /*
>   * This operation can block, but only after everything is updated
>   */
> @@ -1405,6 +1421,21 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
>  	int cnt, ret = QUOTA_OK;
>  	char warntype[MAXQUOTAS];
> 
> +	/*
> +	 * First test before acquiring mutex - solves deadlocks when we
> +	 * re-enter the quota code and are already holding the mutex
> +	 */
> +	if (IS_NOQUOTA(inode)) {
> +		__inode_add_bytes(inode, number, reserve);
> +		goto out;
> +	}
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode)) {
> +		__inode_add_bytes(inode, number, reserve);
> +		goto out_unlock;
> +	}
> +
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
>  		warntype[cnt] = QUOTA_NL_NOWARN;
> 
> @@ -1415,7 +1446,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
>  		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
>  		    == NO_QUOTA) {
>  			ret = NO_QUOTA;
> -			goto out_unlock;
> +			goto out_data_unlock;
>  		}
>  	}
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> @@ -1426,64 +1457,32 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
>  		else
>  			dquot_incr_space(inode->i_dquot[cnt], number);
>  	}
> -	if (!reserve)
> -		inode_add_bytes(inode, number);
> -out_unlock:
> -	spin_unlock(&dq_data_lock);
> -	flush_warnings(inode->i_dquot, warntype);
> -	return ret;
> -}
> -
> -int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> -{
> -	int cnt, ret = QUOTA_OK;
> -
> -	/*
> -	 * First test before acquiring mutex - solves deadlocks when we
> -	 * re-enter the quota code and are already holding the mutex
> -	 */
> -	if (IS_NOQUOTA(inode)) {
> -		inode_add_bytes(inode, number);
> -		goto out;
> -	}
> -
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -	if (IS_NOQUOTA(inode)) {
> -		inode_add_bytes(inode, number);
> -		goto out_unlock;
> -	}
> -
> -	ret = __dquot_alloc_space(inode, number, warn, 0);
> -	if (ret == NO_QUOTA)
> -		goto out_unlock;
> +	__inode_add_bytes(inode, number, reserve);
> 
> +	if (reserve)
> +		goto out_data_unlock;
>  	/* Dirtify all the dquots - this can block when journalling */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
>  		if (inode->i_dquot[cnt])
>  			mark_dquot_dirty(inode->i_dquot[cnt]);
> +out_data_unlock:
> +	spin_unlock(&dq_data_lock);
> +	flush_warnings(inode->i_dquot, warntype);
>  out_unlock:
>  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  out:
>  	return ret;
>  }
> +
> +int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> +{
> +	return __dquot_alloc_space(inode, number, warn, 0);
> +}
>  EXPORT_SYMBOL(dquot_alloc_space);
> 
>  int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
>  {
> -	int ret = QUOTA_OK;
> -
> -	if (IS_NOQUOTA(inode))
> -		goto out;
> -
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -	if (IS_NOQUOTA(inode))
> -		goto out_unlock;
> -
> -	ret = __dquot_alloc_space(inode, number, warn, 1);
> -out_unlock:
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -out:
> -	return ret;
> +	return __dquot_alloc_space(inode, number, warn, 1);
>  }
>  EXPORT_SYMBOL(dquot_reserve_space);
> 
> @@ -1540,14 +1539,14 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
>  	int ret = QUOTA_OK;
> 
>  	if (IS_NOQUOTA(inode)) {
> -		inode_add_bytes(inode, number);
> +		inode_claim_rsv_blocks(inode, number >> 9);
>  		goto out;
>  	}
> 
>  	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  	if (IS_NOQUOTA(inode))	{
>  		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -		inode_add_bytes(inode, number);
> +		inode_claim_rsv_blocks(inode, number >> 9);
>  		goto out;
>  	}
> 
> @@ -1559,7 +1558,7 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
>  							number);
>  	}
>  	/* Update inode bytes */
> -	inode_add_bytes(inode, number);
> +	inode_claim_rsv_blocks(inode, number >> 9);
>  	spin_unlock(&dq_data_lock);
>  	/* Dirtify all the dquots - this can block when journalling */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> @@ -1572,38 +1571,9 @@ out:
>  EXPORT_SYMBOL(dquot_claim_space);
> 
>  /*
> - * Release reserved quota space
> - */
> -void dquot_release_reserved_space(struct inode *inode, qsize_t number)
> -{
> -	int cnt;
> -
> -	if (IS_NOQUOTA(inode))
> -		goto out;
> -
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -	if (IS_NOQUOTA(inode))
> -		goto out_unlock;
> -
> -	spin_lock(&dq_data_lock);
> -	/* Release reserved dquots */
> -	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> -		if (inode->i_dquot[cnt])
> -			dquot_free_reserved_space(inode->i_dquot[cnt], number);
> -	}
> -	spin_unlock(&dq_data_lock);
> -
> -out_unlock:
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> -out:
> -	return;
> -}
> -EXPORT_SYMBOL(dquot_release_reserved_space);
> -
> -/*
>   * This operation can block, but only after everything is updated
>   */
> -int dquot_free_space(struct inode *inode, qsize_t number)
> +int __dquot_free_space(struct inode *inode, qsize_t number, int reserve)
>  {
>  	unsigned int cnt;
>  	char warntype[MAXQUOTAS];
> @@ -1612,7 +1582,7 @@ int dquot_free_space(struct inode *inode, qsize_t number)
>           * re-enter the quota code and are already holding the mutex */
>  	if (IS_NOQUOTA(inode)) {
>  out_sub:
> -		inode_sub_bytes(inode, number);
> +		__inode_sub_bytes(inode, number, reserve);
>  		return QUOTA_OK;
>  	}
> 
> @@ -1627,21 +1597,43 @@ out_sub:
>  		if (!inode->i_dquot[cnt])
>  			continue;
>  		warntype[cnt] = info_bdq_free(inode->i_dquot[cnt], number);
> -		dquot_decr_space(inode->i_dquot[cnt], number);
> +		if (reserve)
> +			dquot_free_reserved_space(inode->i_dquot[cnt], number);
> +		else
> +			dquot_decr_space(inode->i_dquot[cnt], number);
>  	}
> -	inode_sub_bytes(inode, number);
> +	__inode_sub_bytes(inode, number, reserve);
>  	spin_unlock(&dq_data_lock);
> +
> +	if (reserve)
> +		goto out_unlock;
>  	/* Dirtify all the dquots - this can block when journalling */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
>  		if (inode->i_dquot[cnt])
>  			mark_dquot_dirty(inode->i_dquot[cnt]);
> +out_unlock:
>  	flush_warnings(inode->i_dquot, warntype);
>  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  	return QUOTA_OK;
>  }
> +
> +int dquot_free_space(struct inode *inode, qsize_t number)
> +{
> +	return  __dquot_free_space(inode, number, 0);
> +}
>  EXPORT_SYMBOL(dquot_free_space);
> 
>  /*
> + * Release reserved quota space
> + */
> +void dquot_release_reserved_space(struct inode *inode, qsize_t number)
> +{
> +	return (void )__dquot_free_space(inode, number, 1);
> +
> +}
> +EXPORT_SYMBOL(dquot_release_reserved_space);
> +
> +/*
>   * This operation can block, but only after everything is updated
>   */
>  int dquot_free_inode(const struct inode *inode, qsize_t number)
> @@ -1679,19 +1671,6 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
>  EXPORT_SYMBOL(dquot_free_inode);
> 
>  /*
> - * call back function, get reserved quota space from underlying fs
> - */
> -qsize_t dquot_get_reserved_space(struct inode *inode)
> -{
> -	qsize_t reserved_space = 0;
> -
> -	if (sb_any_quota_active(inode->i_sb) &&
> -	    inode->i_sb->dq_op->get_reserved_space)
> -		reserved_space = inode->i_sb->dq_op->get_reserved_space(inode);
> -	return reserved_space;
> -}
> -
> -/*
>   * Transfer the number of inode and blocks from one diskquota to an other.
>   *
>   * This operation can block, but only after everything is updated
> @@ -1734,7 +1713,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
>  	}
>  	spin_lock(&dq_data_lock);
>  	cur_space = inode_get_bytes(inode);
> -	rsv_space = dquot_get_reserved_space(inode);
> +	rsv_space = inode_get_rsv_blocks(inode) << 9;
>  	space = cur_space + rsv_space;
>  	/* Build the transfer_from list and check the limits */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 78c4889..daa6274 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -313,8 +313,6 @@ struct dquot_operations {
>  	int (*claim_space) (struct inode *, qsize_t);
>  	/* release rsved quota for delayed alloc */
>  	void (*release_rsv) (struct inode *, qsize_t);
> -	/* get reserved quota for delayed alloc */
> -	qsize_t (*get_reserved_space) (struct inode *);
>  };
> 
>  /* Operations handling requests from userspace */


