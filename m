From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: don't use quota reservation for speculative
	metadata blocks
Date: Mon, 12 Apr 2010 15:36:12 +0200
Message-ID: <20100412133612.GF12238@atrey.karlin.mff.cuni.cz>
References: <4BBCFD10.3030504@redhat.com> <4BBCFF68.1060000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51897 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751967Ab0DLNgN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 09:36:13 -0400
Content-Disposition: inline
In-Reply-To: <4BBCFF68.1060000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Because we can badly over-reserve metadata when we
> calculate worst-case, it complicates things for quota, since
> we must reserve and then claim later, retry on EDQUOT, etc.
> Quota is also a generally smaller pool than fs free blocks,
> so this over-reservation hurts more, and more often.
> 
> I'm of the opinion that it's not the worst thing to allow
> metadata to push a user slightly over quota.  This simplifies
> the code and avoids the false quota rejections that result
> from worst-case speculation.
> 
> This patch stops the speculative quota-charging for
> worst-case metadata requirements, and just charges quota
> when the blocks are allocated at writeout.  It also is
> able to remove the try-again loop on EDQUOT.
> 
> This patch has been tested indirectly by running the xfstests
> suite with a hack to mount & enable quota prior to the test.
> 
> I also did a more specific test of fragmenting freespace
> and then doing a large delalloc write under quota; quota
> stopped me at the right amount of file IO, and then the
> writeout generated enough metadata (due to the fragmentation)
> that it put me slightly over quota, as expected.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  This patch looks good as well. Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
>  balloc.c |    5 ++--
>  inode.c  |   64 ++++++++++++++++++++-------------------------------------------
>  2 files changed, 24 insertions(+), 45 deletions(-)
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index d2f37a5..95b7594 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -591,14 +591,15 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  	ret = ext4_mb_new_blocks(handle, &ar, errp);
>  	if (count)
>  		*count = ar.len;
> -
>  	/*
> -	 * Account for the allocated meta blocks
> +	 * Account for the allocated meta blocks.  We will never
> +	 * fail EDQUOT for metdata, but we do account for it.
>  	 */
>  	if (!(*errp) && EXT4_I(inode)->i_delalloc_reserved_flag) {
>  		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +		dquot_alloc_block_nofail(inode, ar.len);
>  	}
>  	return ret;
>  }
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5381802..dba674a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1076,7 +1076,6 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> -	int mdb_free = 0, allocated_meta_blocks = 0;
>  
>  	spin_lock(&ei->i_block_reservation_lock);
>  	trace_ext4_da_update_reserve_space(inode, used);
> @@ -1091,11 +1090,10 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  
>  	/* Update per-inode reservations */
>  	ei->i_reserved_data_blocks -= used;
> -	used += ei->i_allocated_meta_blocks;
>  	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
> -	allocated_meta_blocks = ei->i_allocated_meta_blocks;
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> +			   used + ei->i_allocated_meta_blocks);
>  	ei->i_allocated_meta_blocks = 0;
> -	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used);
>  
>  	if (ei->i_reserved_data_blocks == 0) {
>  		/*
> @@ -1103,30 +1101,23 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  		 * only when we have written all of the delayed
>  		 * allocation blocks.
>  		 */
> -		mdb_free = ei->i_reserved_meta_blocks;
> +		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> +				   ei->i_reserved_meta_blocks);
>  		ei->i_reserved_meta_blocks = 0;
>  		ei->i_da_metadata_calc_len = 0;
> -		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
>  	}
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  
> -	/* Update quota subsystem */
> +	/* Update quota subsystem for data blocks */
>  	if (quota_claim) {
>  		dquot_claim_block(inode, used);
> -		if (mdb_free)
> -			dquot_release_reservation_block(inode, mdb_free);
>  	} else {
>  		/*
>  		 * We did fallocate with an offset that is already delayed
>  		 * allocated. So on delayed allocated writeback we should
> -		 * not update the quota for allocated blocks. But then
> -		 * converting an fallocate region to initialized region would
> -		 * have caused a metadata allocation. So claim quota for
> -		 * that
> +		 * not re-claim the quota for fallocated blocks.
>  		 */
> -		if (allocated_meta_blocks)
> -			dquot_claim_block(inode, allocated_meta_blocks);
> -		dquot_release_reservation_block(inode, mdb_free + used);
> +		dquot_release_reservation_block(inode, used);
>  	}
>  
>  	/*
> @@ -1860,7 +1851,7 @@ static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
>  	int retries = 0;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> -	unsigned long md_needed, md_reserved;
> +	unsigned long md_needed;
>  	int ret;
>  
>  	/*
> @@ -1870,22 +1861,24 @@ static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
>  	 */
>  repeat:
>  	spin_lock(&ei->i_block_reservation_lock);
> -	md_reserved = ei->i_reserved_meta_blocks;
>  	md_needed = ext4_calc_metadata_amount(inode, lblock);
>  	trace_ext4_da_reserve_space(inode, md_needed);
>  	spin_unlock(&ei->i_block_reservation_lock);
>  
>  	/*
> -	 * Make quota reservation here to prevent quota overflow
> -	 * later. Real quota accounting is done at pages writeout
> -	 * time.
> +	 * We will charge metadata quota at writeout time; this saves
> +	 * us from metadata over-estimation, though we may go over by
> +	 * a small amount in the end.  Here we just reserve for data.
>  	 */
> -	ret = dquot_reserve_block(inode, md_needed + 1);
> +	ret = dquot_reserve_block(inode, 1);
>  	if (ret)
>  		return ret;
> -
> +	/*
> +	 * We do still charge estimated metadata to the sb though;
> +	 * we cannot afford to run out of free blocks.
> +	 */
>  	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
> -		dquot_release_reservation_block(inode, md_needed + 1);
> +		dquot_release_reservation_block(inode, 1);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
> @@ -1932,12 +1925,13 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
>  		 * only when we have written all of the delayed
>  		 * allocation blocks.
>  		 */
> -		to_free += ei->i_reserved_meta_blocks;
> +		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> +				   ei->i_reserved_meta_blocks);
>  		ei->i_reserved_meta_blocks = 0;
>  		ei->i_da_metadata_calc_len = 0;
>  	}
>  
> -	/* update fs dirty blocks counter */
> +	/* update fs dirty data blocks counter */
>  	percpu_counter_sub(&sbi->s_dirtyblocks_counter, to_free);
>  
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> @@ -3076,7 +3070,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>  			       loff_t pos, unsigned len, unsigned flags,
>  			       struct page **pagep, void **fsdata)
>  {
> -	int ret, retries = 0, quota_retries = 0;
> +	int ret, retries = 0;
>  	struct page *page;
>  	pgoff_t index;
>  	unsigned from, to;
> @@ -3135,22 +3129,6 @@ retry:
>  
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
> -
> -	if ((ret == -EDQUOT) &&
> -	    EXT4_I(inode)->i_reserved_meta_blocks &&
> -	    (quota_retries++ < 3)) {
> -		/*
> -		 * Since we often over-estimate the number of meta
> -		 * data blocks required, we may sometimes get a
> -		 * spurios out of quota error even though there would
> -		 * be enough space once we write the data blocks and
> -		 * find out how many meta data blocks were _really_
> -		 * required.  So try forcing the inode write to see if
> -		 * that helps.
> -		 */
> -		write_inode_now(inode, (quota_retries == 3));
> -		goto retry;
> -	}
>  out:
>  	return ret;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
