From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 1/4] ext4: delalloc quota fixes
Date: Mon, 07 Dec 2009 16:00:33 -0800
Message-ID: <1260230433.4206.81.camel@mingming-laptop>
References: <877hthytz0.fsf@openvz.org>
	 <1259017138-19165-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44058 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935217AbZLHAAy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 19:00:54 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nB7NmUD7006008
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 16:48:30 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB800e9t096868
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 17:00:40 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB800ahD006459
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 17:00:36 -0700
In-Reply-To: <1259017138-19165-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-11-24 at 01:58 +0300, Dmitry Monakhov wrote:
> This patch fix most visible problems with delalloc+quota issues
> - ext4_get_reserved_space() must return bytes instead of blocks.
> - Claim allocated meta blocks. Do it as we do for data blocks
>   but delay it untill proper moment.
> - Move space claiming to ext4_da_update_reserve_space()
>   Only here we do know what we are dealing with data or metadata
> 

Thanks for sending the first fix, I am actually surprisely to know the
fix didn't get merged before, as Jan has pointed this out when he review
the original patch and I have get this fixed...somehow the latest patch
wasn't being picked at the end.

here it is.
http://marc.info/?l=linux-ext4&m=123185939602949&w=2


About the second and third issue you are trying to fix here... I think
the current code does what you want already.

The current code does reserve quota for metadata blocks at
ext4_da_update_reserve_space() already and delay the quota claim at the
later time when metadata blocks are really allocated (via
ext4_mb_mark_diskspace_used), extra reserved quota for metadata blocks
will get freed at ext4_da_update_reserve_space().
ext4_mb_mark_diskspace_used() is called for every block allocation
including medatadata allocation, so we won't miss quota claim for
metadata there.

The reason that I keep all quota claim immediately at the block
allocation time via ext4_mb_mark_diskspace_used() is to keep the block
allocation space accounting/dirty/delayed block space accounting/quota
accounting in the same place; Plus, when ext4_da_update_reserve_space()
called, the number of blocks passed is the number of blocks mapped, may
not necessarilly the the number of blocks just new allocated.

cheers,
Mingming

 put the space claiming under 
> The most useful test case for delalloc+quota is concurent tasks
> with write+truncate vs chown for a same file.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c   |   12 ++++++++----
>  fs/ext4/mballoc.c |    6 ------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ab22297..e642cdb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1057,7 +1057,7 @@ qsize_t ext4_get_reserved_space(struct inode *inode)
>  		EXT4_I(inode)->i_reserved_meta_blocks;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 
> -	return total;
> +	return (total << inode->i_blkbits);
>  }



>  /*
>   * Calculate the number of metadata blocks need to reserve
> @@ -1096,7 +1096,7 @@ static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
>  static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	int total, mdb, mdb_free;
> +	int total, mdb, mdb_free, mdb_claim = 0;
> 
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	/* recalculate the number of metablocks still need to be reserved */
> @@ -1109,7 +1109,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
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
> @@ -1119,7 +1121,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
> 
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
> -	EXT4_I(inode)->i_reserved_data_blocks -= used;
> + 	EXT4_I(inode)->i_reserved_data_blocks -= used;
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
> +	vfs_dq_claim_block(inode, used + mdb_claim);
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 
>  	/*
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
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi,


