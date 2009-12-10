From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] quota: decouple fs reserved space from quota
 reservation. [V3]
Date: Thu, 10 Dec 2009 16:02:04 +0100
Message-ID: <20091210150203.GC3696@quack.suse.cz>
References: <1260447952-6201-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	jack@suse.cz, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbZLKUpN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Dec 2009 15:45:13 -0500
Content-Disposition: inline
In-Reply-To: <1260447952-6201-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 10-12-09 15:25:51, Dmitry Monakhov wrote:
> Currently inode_reservation is managed by fs itself and this
> reservation is transfered on dquot_transfer(). This means what
> inode_reservation must always be in sync with
> dquot->dq_dqb.dqb_rsvspace. Otherwise dquot_transfer() will result
> in incorrect quota(WARN_ON in dquot_claim_reserved_space() will be
> triggered)
> This is not easy because of complex locking order issues
> for example http://bugzilla.kernel.org/show_bug.cgi?id=14739
> 
> The patch introduce quota reservation field for each fs-inode
> (fs specific inode is used in order to prevent bloating generic
> vfs inode). This reservation is managed by quota code internally
> similar to i_blocks/i_bytes and may not be always in sync with
> internal fs reservation.
> 
> Also perform some code rearrangement:
> - Unify dquot_reserve_space() and dquot_reserve_space()
> - Unify dquot_release_reserved_space() and dquot_free_space()
> - Also this patch add missing warning update to release_rsv()
>   dquot_release_reserved_space() must call flush_warnings() as
>   dquot_free_space() does.
> 
> Changes from V1:
> - move qutoa_reservation field from vfs_inode to fs_inode
> - account reservation in bytes instead of blocks.
  Thanks for looking into this! I have some comments to the patch below
but generally I like it.

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/quota/dquot.c      |  219 ++++++++++++++++++++++++++++---------------------
>  include/linux/quota.h |    5 +-
>  2 files changed, 127 insertions(+), 97 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 39b49c4..66221f8 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1388,6 +1388,71 @@ void vfs_dq_drop(struct inode *inode)
>  EXPORT_SYMBOL(vfs_dq_drop);
>  
>  /*
> + * inode_reserved_space is managed internally by quota, and protected by
> + * i_lock similar to i_blocks+i_bytes.
> + */
> +static qsize_t* inode_reserved_space(struct inode * inode)
                 ^^ it should be "qsize_t *"
> +{
> +	/* Filesystem must explicitly define it's own method in order to use
> +	 * quota reservation interface */
> +	BUG_ON(!inode->i_sb->dq_op->get_reserved_space);
> +	return inode->i_sb->dq_op->get_reserved_space(inode);
> +}
> +
> +static void inode_add_rsv_space(struct inode *inode, qsize_t number)
> +{
> +	spin_lock(&inode->i_lock);
> +	*inode_reserved_space(inode) += number;
> +	spin_unlock(&inode->i_lock);
> +}
> +
  Hmm, I think I have a better solution for this: Each inode will have a
pointer to "inode features" table. That table will contain offsets of
general structures (e.g. things needed for quotas) embedded inside
fs-specific inode. That way we can later move similar structures out of
general VFS inode to inodes of filesystems that need it. When a filesystem
creates an inode, it fills in a proper pointer to the table... That should
allow generic code access data in fs-specific part of inode structure,
we don't have to add functions returning pointers, etc.
  But for now I'd go with your solution since mine will require more
widespread changes to quota code and we need to fix that bug.

> +static void inode_claim_rsv_space(struct inode *inode, qsize_t number)
> +{
> +	spin_lock(&inode->i_lock);
> +	*inode_reserved_space(inode) -= number;
> +	inode->i_blocks += number >> 9;
> +	number &= 511;
> +	inode->i_bytes += number;
> +	if (inode->i_bytes >= 512) {
> +		inode->i_blocks++;
> +		inode->i_bytes -= 512;
> +	}
> +	spin_unlock(&inode->i_lock);
> +}
  Please add variant of inode_add_bytes() which does not acquire
inode->i_lock and use it here. I'd suggest __inode_add_bytes and rename
__inode_add_bytes below to something more appropriate like
inode_alloc_reserve_bytes or so.

...
> @@ -1426,64 +1506,32 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
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
  You have to unlock dq_data_lock before mark_dquot_dirty as it can sleep.

>  out_unlock:
>  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  out:
>  	return ret;
>  }
...
> @@ -1854,6 +1882,7 @@ const struct dquot_operations dquot_operations = {
>  	.write_info	= dquot_commit_info,
>  	.alloc_dquot	= dquot_alloc,
>  	.destroy_dquot	= dquot_destroy,
> +
>  };
  I guess the above is a mistake...

> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 78c4889..40845f1 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -313,8 +313,9 @@ struct dquot_operations {
>  	int (*claim_space) (struct inode *, qsize_t);
>  	/* release rsved quota for delayed alloc */
>  	void (*release_rsv) (struct inode *, qsize_t);
> -	/* get reserved quota for delayed alloc */
> -	qsize_t (*get_reserved_space) (struct inode *);
> +	/* get reserved quota for delayed alloc, value returned is managed by
> +	 * quota code only */
> +	qsize_t* (*get_reserved_space) (struct inode *);
  I think proper coding style is "qsize_t *(*get_reserved_space) (...)"

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
