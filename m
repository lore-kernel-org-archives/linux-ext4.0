From: Niu Yawei <yawei.niu@gmail.com>
Subject: Re: [PATCH 3/3 v2] quota: remove dqptr_sem
Date: Wed, 28 May 2014 10:01:12 +0800
Message-ID: <53854368.6050306@gmail.com>
References: <537DD5BA.1050105@gmail.com> <538464AD.6050407@gmail.com> <20140527101219.GA28035@infradead.org> <538541FE.3070203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Christoph Hellwig <hch@infradead.org>, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59305 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaE1CBG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2014 22:01:06 -0400
In-Reply-To: <538541FE.3070203@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The v2 patchset just removed dqptr_sem totally (not like v1 keeping it
in quota_info), and I measured
performance of both v1 & v2 patches,  the improvements are same as the
first big-one patch I sent.
> Remove dqptr_sem to make quota code scalable: Remove the dqptr_sem,
> accessing inode->i_dquot now protected by dquot_srcu, and changing
> inode->i_dquot is now serialized by dq_data_lock.
>
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
> @@ -116,21 +118,15 @@
>   * spinlock to internal buffers before writing.
>   *
>   * Lock ordering (including related VFS locks) is the following:
> - *   dqonoff_mutex > i_mutex > journal_lock > dqptr_sem > dquot->dq_lock >
> - *   dqio_mutex
> + *   dqonoff_mutex > i_mutex > journal_lock > dquot->dq_lock > dqio_mutex
>   * dqonoff_mutex > i_mutex comes from dquot_quota_sync, dquot_enable, etc.
> - * The lock ordering of dqptr_sem imposed by quota code is only dqonoff_sem >
> - * dqptr_sem. But filesystem has to count with the fact that functions such as
> - * dquot_alloc_space() acquire dqptr_sem and they usually have to be called
> - * from inside a transaction to keep filesystem consistency after a crash. Also
> - * filesystems usually want to do some IO on dquot from ->mark_dirty which is
> - * called with dqptr_sem held.
>   */
>  
>  static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_list_lock);
>  static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_state_lock);
>  __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
>  EXPORT_SYMBOL(dq_data_lock);
> +DEFINE_STATIC_SRCU(dquot_srcu);
>  
>  void __quota_error(struct super_block *sb, const char *func,
>  		   const char *fmt, ...)
> @@ -974,7 +970,6 @@ static inline int dqput_blocks(struct dquot *dquot)
>  /*
>   * Remove references to dquots from inode and add dquot to list for freeing
>   * if we have the last reference to dquot
> - * We can't race with anybody because we hold dqptr_sem for writing...
>   */
>  static int remove_inode_dquot_ref(struct inode *inode, int type,
>  				  struct list_head *tofree_head)
> @@ -1035,13 +1030,15 @@ static void remove_dquot_ref(struct super_block *sb, int type,
>  		 *  We have to scan also I_NEW inodes because they can already
>  		 *  have quota pointer initialized. Luckily, we need to touch
>  		 *  only quota pointers and these have separate locking
> -		 *  (dqptr_sem).
> +		 *  (dq_data_lock).
>  		 */
> +		spin_lock(&dq_data_lock);
>  		if (!IS_NOQUOTA(inode)) {
>  			if (unlikely(inode_get_rsv_space(inode) > 0))
>  				reserved = 1;
>  			remove_inode_dquot_ref(inode, type, tofree_head);
>  		}
> +		spin_unlock(&dq_data_lock);
>  	}
>  	spin_unlock(&inode_sb_list_lock);
>  #ifdef CONFIG_QUOTA_DEBUG
> @@ -1059,9 +1056,8 @@ static void drop_dquot_ref(struct super_block *sb, int type)
>  	LIST_HEAD(tofree_head);
>  
>  	if (sb->dq_op) {
> -		down_write(&sb_dqopt(sb)->dqptr_sem);
>  		remove_dquot_ref(sb, type, &tofree_head);
> -		up_write(&sb_dqopt(sb)->dqptr_sem);
> +		synchronize_srcu(&dquot_srcu);
>  		put_dquot_list(&tofree_head);
>  	}
>  }
> @@ -1392,9 +1388,6 @@ static int dquot_active(const struct inode *inode)
>  /*
>   * Initialize quota pointers in inode
>   *
> - * We do things in a bit complicated way but by that we avoid calling
> - * dqget() and thus filesystem callbacks under dqptr_sem.
> - *
>   * It is better to call this function outside of any transaction as it
>   * might need a lot of space in journal for dquot structure allocation.
>   */
> @@ -1405,8 +1398,6 @@ static void __dquot_initialize(struct inode *inode, int type)
>  	struct super_block *sb = inode->i_sb;
>  	qsize_t rsv;
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
>  	if (!dquot_active(inode))
>  		return;
>  
> @@ -1438,7 +1429,7 @@ static void __dquot_initialize(struct inode *inode, int type)
>  	if (!dq_get)
>  		return;
>  
> -	down_write(&sb_dqopt(sb)->dqptr_sem);
> +	spin_lock(&dq_data_lock);
>  	if (IS_NOQUOTA(inode))
>  		goto out_err;
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> @@ -1458,15 +1449,12 @@ static void __dquot_initialize(struct inode *inode, int type)
>  			 * did a write before quota was turned on
>  			 */
>  			rsv = inode_get_rsv_space(inode);
> -			if (unlikely(rsv)) {
> -				spin_lock(&dq_data_lock);
> +			if (unlikely(rsv))
>  				dquot_resv_space(inode->i_dquot[cnt], rsv);
> -				spin_unlock(&dq_data_lock);
> -			}
>  		}
>  	}
>  out_err:
> -	up_write(&sb_dqopt(sb)->dqptr_sem);
> +	spin_unlock(&dq_data_lock);
>  	/* Drop unused references */
>  	dqput_all(got);
>  }
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
>  
> @@ -1608,15 +1597,11 @@ static void inode_decr_space(struct inode *inode, qsize_t number, int reserve)
>   */
>  int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
>  {
> -	int cnt, ret = 0;
> +	int cnt, ret = 0, index;
>  	struct dquot_warn warn[MAXQUOTAS];
>  	struct dquot **dquots = inode->i_dquot;
>  	int reserve = flags & DQUOT_SPACE_RESERVE;
>  
> -	/*
> -	 * First test before acquiring mutex - solves deadlocks when we
> -	 * re-enter the quota code and are already holding the mutex
> -	 */
>  	if (!dquot_active(inode)) {
>  		inode_incr_space(inode, number, reserve);
>  		goto out;
> @@ -1625,7 +1610,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
>  		warn[cnt].w_type = QUOTA_NL_NOWARN;
>  
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	index = srcu_read_lock(&dquot_srcu);
>  	spin_lock(&dq_data_lock);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		if (!dquots[cnt])
> @@ -1652,7 +1637,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
>  		goto out_flush_warn;
>  	mark_all_dquot_dirty(dquots);
>  out_flush_warn:
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	srcu_read_unlock(&dquot_srcu, index);
>  	flush_warnings(warn);
>  out:
>  	return ret;
> @@ -1664,17 +1649,16 @@ EXPORT_SYMBOL(__dquot_alloc_space);
>   */
>  int dquot_alloc_inode(const struct inode *inode)
>  {
> -	int cnt, ret = 0;
> +	int cnt, ret = 0, index;
>  	struct dquot_warn warn[MAXQUOTAS];
>  	struct dquot * const *dquots = inode->i_dquot;
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
>  	if (!dquot_active(inode))
>  		return 0;
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
>  		warn[cnt].w_type = QUOTA_NL_NOWARN;
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +
> +	index = srcu_read_lock(&dquot_srcu);
>  	spin_lock(&dq_data_lock);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		if (!dquots[cnt])
> @@ -1694,7 +1678,7 @@ warn_put_all:
>  	spin_unlock(&dq_data_lock);
>  	if (ret == 0)
>  		mark_all_dquot_dirty(dquots);
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	srcu_read_unlock(&dquot_srcu, index);
>  	flush_warnings(warn);
>  	return ret;
>  }
> @@ -1705,14 +1689,14 @@ EXPORT_SYMBOL(dquot_alloc_inode);
>   */
>  int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
>  {
> -	int cnt;
> +	int cnt, index;
>  
>  	if (!dquot_active(inode)) {
>  		inode_claim_rsv_space(inode, number);
>  		return 0;
>  	}
>  
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	index = srcu_read_lock(&dquot_srcu);
>  	spin_lock(&dq_data_lock);
>  	/* Claim reserved quotas to allocated quotas */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> @@ -1724,7 +1708,7 @@ int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
>  	inode_claim_rsv_space(inode, number);
>  	spin_unlock(&dq_data_lock);
>  	mark_all_dquot_dirty(inode->i_dquot);
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	srcu_read_unlock(&dquot_srcu, index);
>  	return 0;
>  }
>  EXPORT_SYMBOL(dquot_claim_space_nodirty);
> @@ -1734,14 +1718,14 @@ EXPORT_SYMBOL(dquot_claim_space_nodirty);
>   */
>  void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
>  {
> -	int cnt;
> +	int cnt, index;
>  
>  	if (!dquot_active(inode)) {
>  		inode_reclaim_rsv_space(inode, number);
>  		return;
>  	}
>  
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	index = srcu_read_lock(&dquot_srcu);
>  	spin_lock(&dq_data_lock);
>  	/* Claim reserved quotas to allocated quotas */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> @@ -1753,7 +1737,7 @@ void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
>  	inode_reclaim_rsv_space(inode, number);
>  	spin_unlock(&dq_data_lock);
>  	mark_all_dquot_dirty(inode->i_dquot);
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	srcu_read_unlock(&dquot_srcu, index);
>  	return;
>  }
>  EXPORT_SYMBOL(dquot_reclaim_space_nodirty);
> @@ -1766,16 +1750,14 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
>  	unsigned int cnt;
>  	struct dquot_warn warn[MAXQUOTAS];
>  	struct dquot **dquots = inode->i_dquot;
> -	int reserve = flags & DQUOT_SPACE_RESERVE;
> +	int reserve = flags & DQUOT_SPACE_RESERVE, index;
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
>  	if (!dquot_active(inode)) {
>  		inode_decr_space(inode, number, reserve);
>  		return;
>  	}
>  
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	index = srcu_read_lock(&dquot_srcu);
>  	spin_lock(&dq_data_lock);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		int wtype;
> @@ -1798,7 +1780,7 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
>  		goto out_unlock;
>  	mark_all_dquot_dirty(dquots);
>  out_unlock:
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	srcu_read_unlock(&dquot_srcu, index);
>  	flush_warnings(warn);
>  }
>  EXPORT_SYMBOL(__dquot_free_space);
> @@ -1811,13 +1793,12 @@ void dquot_free_inode(const struct inode *inode)
>  	unsigned int cnt;
>  	struct dquot_warn warn[MAXQUOTAS];
>  	struct dquot * const *dquots = inode->i_dquot;
> +	int index;
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
>  	if (!dquot_active(inode))
>  		return;
>  
> -	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	index = srcu_read_lock(&dquot_srcu);
>  	spin_lock(&dq_data_lock);
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		int wtype;
> @@ -1832,7 +1813,7 @@ void dquot_free_inode(const struct inode *inode)
>  	}
>  	spin_unlock(&dq_data_lock);
>  	mark_all_dquot_dirty(dquots);
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	srcu_read_unlock(&dquot_srcu, index);
>  	flush_warnings(warn);
>  }
>  EXPORT_SYMBOL(dquot_free_inode);
> @@ -1858,8 +1839,6 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
>  	struct dquot_warn warn_from_inodes[MAXQUOTAS];
>  	struct dquot_warn warn_from_space[MAXQUOTAS];
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
>  	if (IS_NOQUOTA(inode))
>  		return 0;
>  	/* Initialize the arrays */
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
>  }
> diff --git a/fs/super.c b/fs/super.c
> index 48377f7..a97aecf 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -214,7 +214,6 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
>  	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
>  	mutex_init(&s->s_dquot.dqio_mutex);
>  	mutex_init(&s->s_dquot.dqonoff_mutex);
> -	init_rwsem(&s->s_dquot.dqptr_sem);
>  	s->s_maxbytes = MAX_NON_LFS;
>  	s->s_op = &default_op;
>  	s->s_time_gran = 1000000000;
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index cc7494a..a1358ce 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -389,7 +389,6 @@ struct quota_info {
>  	unsigned int flags;			/* Flags for diskquotas on this device */
>  	struct mutex dqio_mutex;		/* lock device while I/O in progress */
>  	struct mutex dqonoff_mutex;		/* Serialize quotaon & quotaoff */
> -	struct rw_semaphore dqptr_sem;		/* serialize ops using quota_info struct, pointers from inode to dquots */
>  	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
>  	struct mem_dqinfo info[MAXQUOTAS];	/* Information for each quota type */
>  	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */

