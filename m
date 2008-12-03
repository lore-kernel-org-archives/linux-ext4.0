From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V3 2/3] quota: Add quota claim and release reserved
	quota
Date: Wed, 3 Dec 2008 20:06:46 +0100
Message-ID: <20081203190639.GD12803@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hmm, I can't find the email with this patch so I've just copied it from
some mail archive ;). Sorry if the CC's are wrong.

> quota: Add quota reservation claim and released operations
> 
> Reserved quota will be claimed at the block allocation time. Over-booked
> quota could be returned back with the release callback function.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/dquot.c               |   87 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/quota.h    |    4 +-
>  include/linux/quotaops.h |   55 +++++++++++++++++++++++++++++
>  3 files changed, 145 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.28-rc2/include/linux/quota.h
> ===================================================================
> --- linux-2.6.28-rc2.orig/include/linux/quota.h	2008-11-06 13:36:42.000000000 -0800
> +++ linux-2.6.28-rc2/include/linux/quota.h	2008-11-06 14:03:52.000000000 -0800
> @@ -292,7 +292,9 @@ struct dquot_operations {
>  	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
>  	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
>  	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
> -	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed block allocation */
> +	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed alloc */
> +	int (*claim_space) (struct inode *, qsize_t); /* claim reserved quota for delayed alloc */
> +	void (*release_rsv) (struct inode *, qsize_t); /* release rsved quota for delayed alloc */
>  };
>  
>  /* Operations handling requests from userspace */
> Index: linux-2.6.28-rc2/include/linux/quotaops.h
> ===================================================================
> --- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-11-06 13:37:04.000000000 -0800
> +++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-11-06 14:03:52.000000000 -0800
> @@ -28,6 +28,11 @@ int dquot_drop(struct inode *inode);
>  int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
>  int dquot_alloc_inode(const struct inode *inode, qsize_t number);
>  
> +int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
> +int dquot_claim_space(struct inode *inode, qsize_t number);
> +void dquot_release_reserved_space(struct inode *inode, qsize_t number);
> +
> +
>  int dquot_free_space(struct inode *inode, qsize_t number);
>  int dquot_free_inode(const struct inode *inode, qsize_t number);
>  
> @@ -196,6 +201,31 @@ static inline int vfs_dq_alloc_inode(str
>  	return 0;
>  }
>  
> +/*
> + * Convert in-memory reserved quotas to real consumed quotas
> + */
> +static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
> +{
> +	if (sb_any_quota_active(inode->i_sb)) {
> +		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
> +			return 1;
> +	} else
> +		inode_add_bytes(inode, nr);
> +
> +	mark_inode_dirty(inode);
> +	return 0;
> +}
> +
> +/*
> + * Release reserved (in-memory) quotas
> + */
> +static inline
> +void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
> +{
> +	if (sb_any_quota_active(inode->i_sb))
> +		inode->i_sb->dq_op->release_rsv(inode, nr);
> +}
> +
>  static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
>  {
>  	if (sb_any_quota_active(inode->i_sb))
> @@ -342,6 +372,17 @@ static inline int vfs_dq_reserve_space(s
>  	return 0;
>  }
>  
> +static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
> +{
> +	return vfs_dq_alloc_space(inode, nr);
> +}
> +
> +static inline
> +int vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
> +{
> +	return 0;
> +}
> +
>  static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
>  {
>  	inode_sub_bytes(inode, nr);
> @@ -386,6 +427,18 @@ static inline int vfs_dq_reserve_block(s
>  			nr << inode->i_blkbits);
>  }
>  
> +static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
> +{
> +	return vfs_dq_claim_space(inode,
> +			nr << inode->i_blkbits);
> +}
> +
> +static inline
> +void vfs_dq_release_reservation(struct inode *inode, qsize_t nr)
> +{
> +	vfs_dq_release_reservation_space(inode, nr << inode->i_blkbits);
> +}
> +
  I guess the function should be called like vfs_dq_release_reservation_block().
It's ugly long but we should not omit the "block" part. Maybe we could shorten
reservation everywhere in function names to rsv?

>  static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
>  {
>  	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
> @@ -415,6 +468,8 @@ static inline void vfs_dq_free_block(str
>  				vfs_dq_alloc_block_nodirty(inode, nr)
>  #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
>  #define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode, nr)
> +#define DQUOT_CLAIM_BLOCK(inode, nr) vfs_dq_claim_block(inode, nr)
> +#define DQUOT_RELEASE_RSV_BLOCK(inode, nr) vfs_dq_release_reservation(inode, nr)
  Please call lowercase variants from ext4 and don't define these functions.

>  #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
>  #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
>  				vfs_dq_free_space_nodirty(inode, nr)
> Index: linux-2.6.28-rc2/fs/dquot.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-11-06 13:37:04.000000000 -0800
> +++ linux-2.6.28-rc2/fs/dquot.c	2008-11-06 14:03:52.000000000 -0800
> @@ -846,6 +846,24 @@ static inline void dquot_resv_space(stru
>  	dquot->dq_dqb.dqb_rsvspace += number;
>  }
>  
> +/*
> + * Claim reserved quota space
> + */
> +static int dquot_claim_reserved_space(struct dquot *dquot,
> +						qsize_t number)
> +{
> +	if (dquot->dq_dqb.dqb_rsvspace < number) {
> +		printk(KERN_WARNING "Reserved quota %llu is not enough for"
> +			"request %llu bytes\n",
> +			(unsigned long long)dquot->dq_dqb.dqb_rsvspace, number);
> +		return 1;
  Wouldn't a WARN_ON here be more appropriate? It's a filesystem bug to cause
this AFAICS.

> +	}
> +
> +	dquot->dq_dqb.dqb_curspace += number;
> +	dquot->dq_dqb.dqb_rsvspace -= number;
> +	return 0;
> +}
  You should use dq_data_lock to protect these operations...

> +
>  static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
>  {
>  	if (dquot->dq_dqb.dqb_curinodes > number)
> @@ -1319,6 +1337,73 @@ out:
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
> +		return ret;
> +	}
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))	{
> +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		inode_add_bytes(inode, number);
> +		return ret;
> +	}
> +
> +	/* Claim reserved quotas to allocated quotas */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		if (inode->i_dquot[cnt] != NODQUOT)
> +			ret = dquot_claim_reserved_space(inode->i_dquot[cnt],
> +							number);
> +	}
> +	if (ret == NO_QUOTA) {
> +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		return ret;
> +	}
  It seems a bit silly to try to recover here from filesystem bugs. I'd just
make dquot_claim_reserved_space() void and ignore possible failure here.
We won't do anything harmful like loosing data. Just counters might become
out of sync but given there's a bug in fs anyway it does not matter much.

> +	/* Dirtify all the dquots - this can block when journalling */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> +		if (inode->i_dquot[cnt])
> +			mark_dquot_dirty(inode->i_dquot[cnt]);
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +
> +	/* Update inode bytes */
> +	inode_add_bytes(inode, number);
  And this should be called from under dq_data_lock from
dquot_claim_reserved_space().
  BTW: This reminds me that you should also modify dquot_transfer() function.
Because that should not only transfer i_blocks sectors from one user
to another but it has to also transfer the amount reserved for that inode...
I think the easiest way around this would be to change i_blocks already when
reservation is acquired (and than substract it when some of it is given back).

> +	return ret;
> +}
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
> +	/* Release reserved dquots */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		if (inode->i_dquot[cnt] != NODQUOT) {
> +			dquot = inode->i_dquot[cnt];
> +			dquot->dq_dqb.dqb_rsvspace -= number;
> +		}
> +	}
  Again dq_data_lock...

> +
> +out_unlock:
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +out:
> +	return;
> +}
> +
>  /*
>   * This operation can block, but only after everything is updated
>   */
> @@ -2344,6 +2429,8 @@ EXPORT_SYMBOL(dquot_alloc_inode);
>  EXPORT_SYMBOL(dquot_free_space);
>  EXPORT_SYMBOL(dquot_free_inode);
>  EXPORT_SYMBOL(dquot_reserve_space);
> +EXPORT_SYMBOL(dquot_claim_space);
> +EXPORT_SYMBOL(dquot_release_reserved_space);
>  EXPORT_SYMBOL(dquot_transfer);
>  EXPORT_SYMBOL(vfs_dq_transfer);
>  EXPORT_SYMBOL(vfs_dq_quota_on_remount);

										Honza
