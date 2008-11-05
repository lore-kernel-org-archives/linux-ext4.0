From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 2/3] quota: Add quota claim and release reserved
 quota blocks operations
Date: Tue, 4 Nov 2008 17:23:09 -0800
Message-ID: <20081104172309.b0abc24b.akpm@linux-foundation.org>
References: <1225488446.7600.13.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbYKEBXS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 20:23:18 -0500
In-Reply-To: <1225488446.7600.13.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 31 Oct 2008 14:27:26 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> quota: Add quota reservation claim and released operations
> 
> Reserved quota will be claimed at the block allocation time. Over-booked
> quota could be returned back with the release callback function.
> 
> --- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-10-30 14:41:35.000000000 -0700
> +++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-10-30 14:42:00.000000000 -0700
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
> +	if (sb_any_quota_active(inode->i_sb)){
> +		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
> +			return 1;
> +	}
> +	else
> +		inode_add_bytes(inode, nr);
> +
> +	mark_inode_dirty(inode);
> +	return 0;
> +}

The amount of inlining in this code is, umm, suboptimal.

Thankfully there only appears to be a single DQUOT_CLAIM_BLOCK()
callsite at this stage.

I blame Jan ;)

> +/*
> + * Release reserved (in-memory) quotas
> + */
> +static inline void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
> +{
> +	if (sb_any_quota_active(inode->i_sb))
> +		inode->i_sb->dq_op->release_rsv(inode, nr);
> +}
> +
>  static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
>  {
>  	if (sb_any_quota_active(inode->i_sb))
> @@ -342,6 +372,16 @@ static inline int vfs_dq_reserve_space(s
>  	return 0;
>  }
>  
> +static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
> +{
> +	return vfs_dq_alloc_space(inode, nr);
> +}
> +
> +static inline int vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
> +{
> +	return 0;
> +}
> +
>  static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
>  {
>  	inode_sub_bytes(inode, nr);
> @@ -386,6 +426,17 @@ static inline int vfs_dq_reserve_block(s
>  			nr << inode->i_sb->s_blocksize_bits);
>  }
>  
> +static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
> +{
> +	return vfs_dq_claim_space(inode,
> +			nr << inode->i_sb->s_blocksize_bits);
> +}
> +
> +static inline void vfs_dq_release_reservation(struct inode *inode, qsize_t nr)
> +{
> +	vfs_dq_release_reservation_space(inode, nr << inode->i_sb->s_blocksize_bits);

I think you'll find that inode->i_blkbits contains the same
information.  Accessing that is faster and will emit less code.

It appears that this optimisation can be made in several places in the
quota code.


> +}
> +
>  static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
>  {
>  	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
> @@ -415,6 +466,8 @@ static inline void vfs_dq_free_block(str
>  				vfs_dq_alloc_block_nodirty(inode, nr)
>  #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
>  #define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode, nr)
> +#define DQUOT_CLAIM_BLOCK(inode, nr) vfs_dq_claim_block(inode, nr)
> +#define DQUOT_RELEASE_RSV_BLOCK(inode, nr) vfs_dq_release_reservation(inode, nr)

erk.  I blame him for this too.

>  #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
>  #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
>  				vfs_dq_free_space_nodirty(inode, nr)
> Index: linux-2.6.28-rc2/fs/dquot.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-10-30 14:41:50.000000000 -0700
> +++ linux-2.6.28-rc2/fs/dquot.c	2008-10-31 13:27:20.000000000 -0700
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
> +		printk("WARNING: reserved quota %llu is not enough for"
> +			"request %llu bytes\n",
> +			dquot->dq_dqb.dqb_rsvspace, number);

Nope.

You cannot print a u64 - you do not know what type it has.  It must be
typecast to a known type for printing purposes.

This mistake seems to be happening a lot in ext4 world.  People, please
remember this!  You might want to have a think about your compilation
test coverage also.  powerpc and sparc64 are good ones to use.

> +		return 1;
> +	}
> +
> +	dquot->dq_dqb.dqb_curspace += number;
> +	dquot->dq_dqb.dqb_rsvspace -= number;
> +	return 0;
> +}
> +
>  static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
>  {
>  	if (dquot->dq_dqb.dqb_curinodes > number)
> @@ -1325,6 +1343,71 @@ int dquot_reserve_space(struct inode *in
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
> +	/* Dirtify all the dquots - this can block when journalling */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> +		if (inode->i_dquot[cnt])
> +			mark_dquot_dirty(inode->i_dquot[cnt]);
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +
> +	/* Update inode bytes */
> +	inode_add_bytes(inode, number);
> +	return ret;
> +}

Didn't I just review that function?  I might have got my patches confused.


> +/*
> + * Release reserved quota space
> + */
> +void dquot_release_reserved_space(struct inode *inode, qsize_t number)
> +{
> +	int cnt;
> +	struct dquot *dquot;
> +
> +	if (IS_NOQUOTA(inode))
> +		return;
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))	{
> +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		return;
> +	}

again, `goto out' will yield more maintainable and perhaps more
efficient code here.

> +	/* Release reserved dquots */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		if (inode->i_dquot[cnt] != NODQUOT) {
> +			dquot = inode->i_dquot[cnt];
> +			dquot->dq_dqb.dqb_rsvspace -= number;
> +		}
> +	}
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +}
> +
>  /*
>   * This operation can block, but only after everything is updated
>   */
> @@ -2350,6 +2433,8 @@ EXPORT_SYMBOL(dquot_alloc_inode);
>  EXPORT_SYMBOL(dquot_free_space);
>  EXPORT_SYMBOL(dquot_free_inode);
>  EXPORT_SYMBOL(dquot_reserve_space);
> +EXPORT_SYMBOL(dquot_claim_space);
> +EXPORT_SYMBOL(dquot_release_reserved_space);

I blame him for that too.

>  EXPORT_SYMBOL(dquot_transfer);
>  EXPORT_SYMBOL(vfs_dq_transfer);
>  EXPORT_SYMBOL(vfs_dq_quota_on_remount);
> 
