From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3 v2] quota: remove dqptr_sem
Date: Mon, 2 Jun 2014 10:34:36 +0200
Message-ID: <20140602083436.GC3224@quack.suse.cz>
References: <537DD5BA.1050105@gmail.com>
 <538464AD.6050407@gmail.com>
 <20140527101219.GA28035@infradead.org>
 <538541FE.3070203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaFBIem (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 04:34:42 -0400
Content-Disposition: inline
In-Reply-To: <538541FE.3070203@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-05-14 09:55:10, Niu Yawei wrote:
> Remove dqptr_sem to make quota code scalable: Remove the dqptr_sem,
> accessing inode->i_dquot now protected by dquot_srcu, and changing
> inode->i_dquot is now serialized by dq_data_lock.
  The patch is mostly fine. Just some minor comments below.

								Honza
 
> Signed-off-by: Lai Siyao <lai.siyao@intel.com>
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>
> ---
>  fs/quota/dquot.c      |  105 +++++++++++++++++++------------------------------
>  fs/super.c            |    1 -
>  include/linux/quota.h |    1 -
>  3 files changed, 41 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index dc6f711..b86c88b 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -96,13 +96,15 @@
>   * Note that some things (eg. sb pointer, type, id) doesn't change during
>   * the life of the dquot structure and so needn't to be protected by a lock
>   *
> - * Any operation working on dquots via inode pointers must hold dqptr_sem.  If
> - * operation is just reading pointers from inode (or not using them at all) the
> - * read lock is enough. If pointers are altered function must hold write lock.
> + * Operation accessing dquots via inode pointers are protected by dquot_srcu.
> + * Operation of reading pointer needs srcu_read_lock(&dquot_srcu), and
> + * synchronize_srcu(&dquot_srcu) is called before clear pointers to avoid
  This is not actually precise. It should be:
and synchronize_srcu(&dquot_srcu) is called after clearing pointers from
inode and before dropping dquot references to avoid use of dquots after
they are freed.

Now that we have the rule spelled out exactly, I think we should update
what remove_inode_dquot_ref() does. It should do something like:

if (list_empty(&dquot->dq_free)) {
	spin_lock(&dq_list_lock);
	/*
	 * The inode still has reference to dquot so it can't be in the
	 * free list
	 */
	list_add(&dquot->dq_free, tofree_head);
	spin_unlock(&dq_list_lock);
} else {
	/*
	 * Dquot is already in a list to put so we won't drop the last
	 * reference here.
	 */
	dqput(dquot);
}

Although in practice this should be mostly the same as the current code
this makes it more obvious we keep one reference to each dquot from inodes
until after we call synchronize_srcu(). And you can make this change as a
separate patch before the dqptr_sem removal.

> + * use after free. dq_data_lock is used to serialize the pointer setting and
> + * clearing operations.
>   * Special care needs to be taken about S_NOQUOTA inode flag (marking that
>   * inode is a quota file). Functions adding pointers from inode to dquots have
> - * to check this flag under dqptr_sem and then (if S_NOQUOTA is not set) they
> - * have to do all pointer modifications before dropping dqptr_sem. This makes
> + * to check this flag under dq_data_lock and then (if S_NOQUOTA is not set) they
> + * have to do all pointer modifications before dropping dq_data_lock. This makes
>   * sure they cannot race with quotaon which first sets S_NOQUOTA flag and
>   * then drops all pointers to dquots from an inode.
>   *
...
> @@ -1485,12 +1473,13 @@ static void __dquot_drop(struct inode *inode)
>  	int cnt;
>  	struct dquot *put[MAXQUOTAS];
>  
> -	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	spin_lock(&dq_data_lock);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		put[cnt] = inode->i_dquot[cnt];
>  		inode->i_dquot[cnt] = NULL;
>  	}
> -	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	spin_unlock(&dq_data_lock);
> +	synchronize_srcu(&dquot_srcu);
>  	dqput_all(put);
>  }
  You don't have to call sychronize_srcu() here. There can be no other
users of the inode when __dquot_drop() is called. So noone should be using
inode dquot pointers as well. Probably we should document this assumption
before dquot_drop().
  
> @@ -1868,12 +1847,12 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  		warn_from_inodes[cnt].w_type = QUOTA_NL_NOWARN;
>  		warn_from_space[cnt].w_type = QUOTA_NL_NOWARN;
>  	}
> -	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +
> +	spin_lock(&dq_data_lock);
>  	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
> -		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		spin_unlock(&dq_data_lock);
>  		return 0;
>  	}
> -	spin_lock(&dq_data_lock);
>  	cur_space = inode_get_bytes(inode);
>  	rsv_space = inode_get_rsv_space(inode);
>  	space = cur_space + rsv_space;
> @@ -1927,7 +1906,6 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  		inode->i_dquot[cnt] = transfer_to[cnt];
>  	}
>  	spin_unlock(&dq_data_lock);
> -	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  
>  	mark_all_dquot_dirty(transfer_from);
>  	mark_all_dquot_dirty(transfer_to);
> @@ -1941,7 +1919,6 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  	return 0;
>  over_quota:
>  	spin_unlock(&dq_data_lock);
> -	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  	flush_warnings(warn_to);
>  	return ret;
  Hum, you are missing srcu protection in __dquot_transfer()... Now we are
holding extra dquot references here so we are fine but it really deserves a
comment somewhere in the header before the function.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
