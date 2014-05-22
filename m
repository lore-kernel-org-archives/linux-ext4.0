From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: remove dqptr_sem for scalability
Date: Thu, 22 May 2014 15:25:56 +0200
Message-ID: <20140522132556.GE7999@quack.suse.cz>
References: <537DD5BA.1050105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <537DD5BA.1050105@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  thanks for the work! I have some comments below.

On Thu 22-05-14 18:47:22, Niu Yawei wrote:
> There are several global locks in the VFS quota code which hurts
> performance a lot when quota accounting enabled, dqptr_sem is the major one.
> 
> This patch tries to make the VFS quota code scalable with minimal changes.
> 
> Following tests (mdtest & dbench) were running over ext4 fs in a
> centos6.5 vm (8 cpus, 4G mem, kenrel: 3.15.0-rc5+), and the result shows
> the patch relieved the lock congestion a lot.
> 
Snipped performance results - thanks for those but first let's concentrate
on correctness side of things.

> [PATCH] quota: remove dqptr_sem for scalability
> 
> Remove dqptr_sem (but kept in struct quota_info to keep kernel ABI
> unchanged), and the functionality of this lock is implemented by
> other locks:
> * i_dquot is protected by i_lock, however only this pointer, the
>   content of this struct is by dq_data_lock.
> * Q_GETFMT is now protected with dqonoff_mutex instead of dqptr_sem.
> * Small changes in __dquot_initialize() to avoid unnecessary
>   dqget()/dqput() calls.
  Each of these three steps should be a separate patch please.

  Now regarding each of these steps: Using i_lock for protection of dquot
pointers doesn't quite work. You have e.g.:
> @@ -1636,12 +1646,12 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
>  	}
>  	inode_incr_space(inode, number, reserve);
>  	spin_unlock(&dq_data_lock);
> +	spin_unlock(&inode->i_lock);
>  
>  	if (reserve)
>  		goto out_flush_warn;
>  	mark_all_dquot_dirty(dquots);
>  out_flush_warn:
> -	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
>  	flush_warnings(warn);
>  out:
>  	return ret;
  So you release protection of dquot pointers from inode before calling
mark_all_dquot_dirty(). So dquot pointers can be removed by
remove_inode_dquot_ref() while mark_all_dquot_dirty() works on them. That's
wrong and can lead to use after free.

Quota code uses dqptr_sem to provide exclusion for three cases:
* dquot_init()
* dquot_transfer()
* various places just reading dquot pointers to update allocation
  information
* remove_dquot_ref() (called from quotaoff code)

Now exclusion against remove_dquot_ref() is relatively easy to deal with.
We can create srcu for dquots, whoever looks at dquot pointers from inode
takes srcu_read_lock() (so you basically convert read side of dqptr_sem 
and write side in dquot_init() and dquot_transfer() to that) and use
synchronize_srcu() in remove_dquot_ref() to make sure all users are done
before starting to remove dquot pointers. You'll need to move
dquot_active() checks inside srcu_read_lock() to make this reliable but that
should be easy.

What remains to deal with is an exclusion between the remaining places.
dquot_init(). dq_data_lock spinlock should already provide the necessary
exclusion between readers of allocation pointers and dquot_transfer() (that
spinlock would actually be a good candidate to a conversion to per-inode
one - using i_lock for this should noticeably reduce the contention - but
that's the next step). dquot_init() doesn't take the spinlock so far but
probably we can make it to take it for simplicity for now.

>  static void __dquot_initialize(struct inode *inode, int type)
>  {
> -	int cnt;
> -	struct dquot *got[MAXQUOTAS];
> +	int cnt, dq_get = 0;
> +	struct dquot *got[MAXQUOTAS] = { NULL, NULL };
>  	struct super_block *sb = inode->i_sb;
>  	qsize_t rsv;
>  
> -	/* First test before acquiring mutex - solves deadlocks when we
> -         * re-enter the quota code and are already holding the mutex */
>  	if (!dquot_active(inode))
>  		return;
>  
> -	/* First get references to structures we might need. */
> +	/* In most case, the i_dquot should have been initialized, except
> +	 * the newly allocated one. We'd always try to skip the dqget() and
> +	 * dqput() calls to avoid unnecessary global lock contention. */
> +	if (!(inode->i_state & I_NEW))
> +		goto init_idquot;
  The optimization is a good idea but dquot_init() is often called for
!I_NEW inodes when the initialization is necessary. So I'd rather first
check whether relevant i_dquot[] pointers are != NULL before taking any
lock. If yes, we are done, otherwise we grab pointers to dquots, take the
lock and update the pointers.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
