From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739
Date: Thu, 10 Dec 2009 17:15:53 +0100
Message-ID: <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47486 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZLJQPr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 11:15:47 -0500
Content-Disposition: inline
In-Reply-To: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> drop i_block_reservation_lock before vfs_dq_reserve_block().
> this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Sorry if someone already refused this (I didn't follow the previous
discussion too closely) but: Looking at the code I see no reason why
ext4_claim_free_blocks needs i_block_reservation_lock. In fact mballoc
calls this function without the lock. So could not we just compute
'total' under the lock, release it, reserve quota and then claim free
blocks? You'd get rid of undoing the block reservation and obtain quota
and blocks in the usual order...

								Honza

> ---
>  fs/ext4/inode.c |   29 ++++++++++++++++-------------
>  1 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 942e183..f693768 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1852,19 +1852,8 @@ repeat:
>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total = md_needed + nrblocks;
>  
> -	/*
> -	 * Make quota reservation here to prevent quota overflow
> -	 * later. Real quota accounting is done at pages writeout
> -	 * time.
> -	 */
> -	if (vfs_dq_reserve_block(inode, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -		return -EDQUOT;
> -	}
> -
>  	if (ext4_claim_free_blocks(sbi, total)) {
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -		vfs_dq_release_reservation_block(inode, total);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
> @@ -1872,10 +1861,24 @@ repeat:
>  		return -ENOSPC;
>  	}
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> -	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
> +	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
> +	/*
> +	 * Make quota reservation here to prevent quota overflow
> +	 * later. Real quota accounting is done at pages writeout
> +	 * time.
> +	 */
> +	if (!vfs_dq_reserve_block(inode, total))
> +		return 0;       /* success */
>  
> +	/* Quota reservation has failed, revert inode's reservation */
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, total);
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +	EXT4_I(inode)->i_reserved_data_blocks -= nrblocks;
> +	EXT4_I(inode)->i_reserved_meta_blocks -= md_needed;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -	return 0;       /* success */
> +	return -EDQUOT;
>  }
>  
>  static void ext4_da_release_space(struct inode *inode, int to_free)
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
