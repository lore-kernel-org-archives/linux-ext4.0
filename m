From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V5 2/5] quota: Add quota claim and release reserved
	quota blocks operations
Date: Tue, 6 Jan 2009 10:52:52 +0100
Message-ID: <20090106095252.GG10705@duck.suse.cz>
References: <1231216837.9267.24.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1231216837.9267.24.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

On Mon 05-01-09 20:40:37, Mingming Cao wrote:
> quota: Add quota reservation claim and released operations
> 
> Reserved quota will be claimed at the block allocation time. Over-booked
> quota could be returned back with the release callback function.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
  Just a few minor comments below.

> ---
>  fs/dquot.c               |  113 +++++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/quota.h    |    6 ++
>  include/linux/quotaops.h |   53 ++++++++++++++++++++++
>  3 files changed, 168 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.28-git7/include/linux/quota.h
> ===================================================================
> --- linux-2.6.28-git7.orig/include/linux/quota.h	2009-01-05 17:26:47.000000000 -0800
> +++ linux-2.6.28-git7/include/linux/quota.h	2009-01-05 17:26:48.000000000 -0800
> @@ -311,6 +311,12 @@ struct dquot_operations {
>  	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
>  	/* reserve quota for delayed block allocation */
>  	int (*reserve_space) (struct inode *, qsize_t, int);
> +	/* claim reserved quota for delayed alloc */
> +	int (*claim_space) (struct inode *, qsize_t);
> +	/* release rsved quota for delayed alloc */
> +	void (*release_rsv) (struct inode *, qsize_t);
> +	/* get reserved quota for delayed alloc */
> +	unsigned long long (*get_reserved_space) (struct inode *);
        ^^^ qsize_t would be more appropriate here IMO.


>  };
>  
>  /* Operations handling requests from userspace */
  <snip>

> Index: linux-2.6.28-git7/fs/dquot.c
> ===================================================================
> --- linux-2.6.28-git7.orig/fs/dquot.c	2009-01-05 17:26:47.000000000 -0800
> +++ linux-2.6.28-git7/fs/dquot.c	2009-01-05 20:06:23.000000000 -0800
> @@ -903,6 +903,23 @@ static inline void dquot_resv_space(stru
>  	dquot->dq_dqb.dqb_rsvspace += number;
>  }
>  
> +/*
> + * Claim reserved quota space
> + */
> +static void dquot_claim_reserved_space(struct dquot *dquot,
> +						qsize_t number)
> +{
> +	WARN_ON(dquot->dq_dqb.dqb_rsvspace < number);
> +	dquot->dq_dqb.dqb_curspace += number;
> +	dquot->dq_dqb.dqb_rsvspace -= number;
> +}
> +
> +static inline
> +void dquot_free_reserved_space(struct dquot *dquot, qsize_t number)
> +{
> +	dquot->dq_dqb.dqb_rsvspace -= number;
> +}
> +
>  static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
>  {
>  	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
> @@ -1432,6 +1449,75 @@ warn_put_all:
>  	return ret;
>  }
>  
> +int dquot_claim_space(struct inode *inode, qsize_t number)
> +{
> +	int cnt;
> +	int ret = QUOTA_OK;
> +
> +	if (IS_NOQUOTA(inode)) {
> +		inode_add_bytes(inode, number);
> +		goto out;
> +	}
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))	{
> +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		inode_add_bytes(inode, number);
> +		goto out;
> +	}
> +
> +	spin_lock(&dq_data_lock);
> +	/* Claim reserved quotas to allocated quotas */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		if (inode->i_dquot[cnt] != NODQUOT)
> +			dquot_claim_reserved_space(inode->i_dquot[cnt],
> +							number);
> +	}
> +	/* Update inode bytes */
> +	inode_add_bytes(inode, number);
> +	spin_unlock(&dq_data_lock);
> +	/* Dirtify all the dquots - this can block when journalling */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> +		if (inode->i_dquot[cnt])
> +			mark_dquot_dirty(inode->i_dquot[cnt]);
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +out:
> +	return ret;
> +}
> +EXPORT_SYMBOL(dquot_claim_space);
> +
> +/*
> + * Release reserved quota space
> + */
> +void dquot_release_reserved_space(struct inode *inode, qsize_t number)
> +{
> +	int cnt;
> +	struct dquot *dquot;
> +
> +	if (IS_NOQUOTA(inode))
> +		goto out;
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))
> +		goto out_unlock;
> +
> +	spin_lock(&dq_data_lock);
> +	/* Release reserved dquots */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		if (inode->i_dquot[cnt] != NODQUOT) {
> +			dquot = inode->i_dquot[cnt];
> +			dquot_free_reserved_space(dquot, number);
> +		}
> +	}
> +	spin_unlock(&dq_data_lock);
  Variable dquot seems to be quite useless here...

> +
> +out_unlock:
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +out:
> +	return;
> +}
> +EXPORT_SYMBOL(dquot_release_reserved_space);
> +
>  /*
>   * This operation can block, but only after everything is updated
>   */
> @@ -1507,6 +1593,19 @@ int dquot_free_inode(const struct inode 
>  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  	return QUOTA_OK;
>  }
  Empty line here?

> +/*
> + * call back function, get reserved quota space from underlying fs
> + */
> +qsize_t dquot_get_reserved_space(struct inode *inode)
> +{
> +	qsize_t reserved_space = 0;
> +
> +	if (sb_any_quota_active(inode->i_sb) &&
> +	    inode->i_sb->dq_op->get_reserved_space)
> +		reserved_space = inode->i_sb->dq_op->get_reserved_space(inode)
> +					<< inode->i_blkbits;
> +	return reserved_space;
> +}
  The function should really return number of bytes as its name suggests.
In principle there's no reason why inode could not have 5 bytes reserved
:).
  Hmm, sorry for my comment to ext4 patch. That is correct given what is
written here. I was just confused by the name of the callback.

>  /*
>   * Transfer the number of inode and blocks from one diskquota to an other.
> @@ -1516,7 +1615,8 @@ int dquot_free_inode(const struct inode 
>   */
>  int dquot_transfer(struct inode *inode, struct iattr *iattr)
>  {
> -	qsize_t space;
> +	qsize_t space, cur_space;
> +	qsize_t rsv_space = 0;
>  	struct dquot *transfer_from[MAXQUOTAS];
>  	struct dquot *transfer_to[MAXQUOTAS];
>  	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
> @@ -1557,7 +1657,9 @@ int dquot_transfer(struct inode *inode, 
>  		}
>  	}
>  	spin_lock(&dq_data_lock);
> -	space = inode_get_bytes(inode);
> +	cur_space = inode_get_bytes(inode);
> +	rsv_space = dquot_get_reserved_space(inode);
> +	space = cur_space + rsv_space;
>  	/* Build the transfer_from list and check the limits */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		if (transfer_to[cnt] == NODQUOT)
> @@ -1586,11 +1688,14 @@ int dquot_transfer(struct inode *inode, 
>  			warntype_from_space[cnt] =
>  				info_bdq_free(transfer_from[cnt], space);
>  			dquot_decr_inodes(transfer_from[cnt], 1);
> -			dquot_decr_space(transfer_from[cnt], space);
> +			dquot_decr_space(transfer_from[cnt], cur_space);
> +			dquot_free_reserved_space(transfer_from[cnt],
> +						  rsv_space);
>  		}
>  
>  		dquot_incr_inodes(transfer_to[cnt], 1);
> -		dquot_incr_space(transfer_to[cnt], space);
> +		dquot_incr_space(transfer_to[cnt], cur_space);
> +		dquot_resv_space(transfer_to[cnt], rsv_space);
>  
>  		inode->i_dquot[cnt] = transfer_to[cnt];
>  	}

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
