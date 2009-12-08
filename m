From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/4] ext4: fix reserved space transferring on chown()
 [V2]
Date: Tue, 08 Dec 2009 15:06:37 -0800
Message-ID: <1260313597.4206.1492.camel@mingming-laptop>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
	 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:46780 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935887AbZLHXGj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 18:06:39 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nB8N1sIl030032
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 16:01:54 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id nB8N6dRH191414
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 16:06:39 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB8N6c65008705
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 16:06:39 -0700
In-Reply-To: <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-11-25 at 09:57 +0300, Dmitry Monakhov wrote:
> Currently all quota's functions except vfs_dq_reserve_block()
> called without i_block_reservation_lock. This result in
> ext4_reservation vs quota_reservation inconsistency which provoke
> incorrect reservation transfer ==> incorrect quota after transfer.
> 
> Race (1)
> | Task 1 (chown)                 | Task 2 (truncate)                    |
> | dquot_transfer                 |                                      |
> | ->down_write(dqptr_sem)        | ext4_da_release_spac                 |
> | -->dquot_get_reserved_space    | ->lock(i_block_reservation_lock)     |
> | --->get_reserved_space         | /* decrement reservation */          |
> | ---->ext4_get_reserved_space   | ->unlock(i_block_reservation_lock)   |
> | ----->lock(i_block_rsv_lock)   | /* During this time window           |
> | /* Read ext4_rsv from inode */ | * fs's reservation not equals        |
> | /* transfer it to new quota */ | * to quota's */                      |
> | ->up_write(dqptr_sem)          | ->vfs_dq_release_reservation_block() |
> |                                | /* quota_rsv goes negative here */   |
> |                                |                                      |
> 

it seems to me the issue is quota_rsv goes negative here. hmm, but we
could still possible ge negative quota rsv with chown and truncate
serialized, no? I am still not very clear how could the locking reorder
will protect not getting negative quota reservation?


> Race (2)
> | Task 1 (chown)                | Task 2 (flush-8:16)             |
> | dquot_transfer()              | ext4_mb_mark_diskspace_used()   |
> | ->down_write(dqptr_sem)       | ->vfs_dq_claim_block()          |
> | --->get_reserved_space()      | /* After this moment         */ |
> | --->ext4_get_reserved_space() | /* ext4_rsv != quota_ino_rsv */ |
> | /* Read rsv from inode which  |                                 |
> | ->dquot_free_reserved_space() |                                 |
> | /* quota_rsv goes negative */ |                                 |
> |                               |                                 |
> |                               | dquot_free_reserved_space()     |
> |                               | /* finally dec ext4_ino_rsv */  |
> 
> So, in order to protect us from this type of races we always have to
> provides ext4_ino_rsv == quot_ino_rsv guarantee. And this is only
> possible then i_block_reservation_lock is taken before entering any
> quota operations.
> 
> In fact i_block_reservation_lock is held by ext4_da_reserve_space()
> while calling vfs_dq_reserve_block(). Lock are held in following order
> i_block_reservation_lock > dqptr_sem
> 
> This may result in deadlock because of different lock ordering:
> ext4_da_reserve_space()             dquot_transfer()
> lock(i_block_reservation_lock)	     down_write(dqptr_sem)
>   down_write(dqptr_sem)		     lock(i_block_reservation_lock)
> 
> But this not happen only because both callers must have i_mutex so
> serialization happens on i_mutex.
> 

yes, the i_mutex lock is there to prevent the deadlock.

> To prevent ext4_reservation vs dquot_reservation inconsistency we
> have to make following changes
> - Reorganize locking ordering like follows:
>   i_block_reservation_lock > dqptr_sem
>   This means what all functions which call vfs_dq_XXX must acquire
>   i_block_reservation_lock before.
> 
> - Move space claiming to ext4_da_update_reserve_space()
>   Only here we do know what we are dealing with data or metadata
> 
> - Delay dquot_claim for metadata before it until proper moment(
>   until we are allowed to decrement inodes->i_reserved_meta_blocks)
> 

Now these make sense to me, you are trying to keep the reserved quota
and reserved blocks consistant all the time. However the issue is
dquot_tranfer() only tranfers the reserved quotas, but not dec the
reserved data/metadata blocks for delalloc. so we will end up nega
values too...I don't see how is help.

Perhaps we shall not transfer the quota reservation to another inode?
Only those claimed quotas? I actually wondered whether we need to
transfer the quota reservation at the first time. Now it seems to me the
right thing to do is not transfer the reserved quota before they are
really claimed. This will make it keep consistant with the reserved
delalloc blocks possible.... CCing Jan who might have some good ideas...

> The most useful test case for delalloc+quota is concurrent tasks
> with write+truncate vs chown for the same file.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c   |   33 ++++++++++++++++++++++++---------
>  fs/ext4/mballoc.c |    6 ------
>  2 files changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cc4737e..979362d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1047,16 +1047,23 @@ cleanup:
>  out:
>  	return err;
>  }
> +/*
> + * Quota_transfer callback.
> + * During quota transfer we have to transfer rsv-blocks from one dquot to
> + * another. inode must be protected from concurrent reservation/reclamation.
> + * Locking ordering for all space reservation code:
> + *  i_block_reservation_lock > dqptr_sem
> + * This is differ from i_block,i_lock locking ordering, but this is the
> + * only possible way.
> + * NOTE: Caller must hold i_block_reservation_lock.
> + */
> 
>  qsize_t ext4_get_reserved_space(struct inode *inode)
>  {
>  	unsigned long long total;
> 
> -	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	total = EXT4_I(inode)->i_reserved_data_blocks +
>  		EXT4_I(inode)->i_reserved_meta_blocks;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -
>  	return (total << inode->i_blkbits);
>  }
>  /*
> @@ -1096,7 +1103,7 @@ static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
>  static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	int total, mdb, mdb_free;
> +	int total, mdb, mdb_free, mdb_claim = 0;
> 
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	/* recalculate the number of metablocks still need to be reserved */
> @@ -1109,7 +1116,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
> 
>  	if (mdb_free) {
>  		/* Account for allocated meta_blocks */
> -		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
> +		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
> +		BUG_ON(mdb_free < mdb_claim);
> +		mdb_free -= mdb_claim;
> 
>  		/* update fs dirty blocks counter */
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
> @@ -1119,14 +1128,16 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
> 
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
> -	EXT4_I(inode)->i_reserved_data_blocks -= used;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> + 	EXT4_I(inode)->i_reserved_data_blocks -= used;
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
> +	vfs_dq_claim_block(inode, used + mdb_claim);
> 
>  	/*
>  	 * free those over-booking quota for metadata blocks
>  	 */
>  	if (mdb_free)
>  		vfs_dq_release_reservation_block(inode, mdb_free);
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 
>  	/*
>  	 * If we have done all the pending block allocations and if
> @@ -1863,8 +1874,8 @@ repeat:
>  	}
> 
>  	if (ext4_claim_free_blocks(sbi, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		vfs_dq_release_reservation_block(inode, total);
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
> @@ -1921,9 +1932,9 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
> 
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 
>  	vfs_dq_release_reservation_block(inode, release);
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
> 
>  static void ext4_da_page_release_reservation(struct page *page,
> @@ -5433,7 +5444,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  			error = PTR_ERR(handle);
>  			goto err_out;
>  		}
> +		/* i_block_reservation must being held in order to avoid races
> +		 * with concurent block reservation. */
> +		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  		error = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		if (error) {
>  			ext4_journal_stop(handle);
>  			return error;
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bba1282..d4c52db 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2750,12 +2750,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
>  		/* release all the reserved blocks if non delalloc */
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
> -	else {
> -		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> -						ac->ac_b_ex.fe_len);
> -		/* convert reserved quota blocks to real quota blocks */
> -		vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
> -	}
> 

I'd prefer to keep the percpu_counter_sub(&sbi->s_dirtyblocks_counter,
used + mdb_claim); here, to stay together with no dellaoc case. Agree
that the quota claim could be defered and moved to
ext4_da_update_reserve_space()as you proposed.


>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi,


