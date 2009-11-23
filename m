From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/4] ext4: delalloc quota fixes
Date: Tue, 24 Nov 2009 01:43:58 +0300
Message-ID: <87bpissvyp.fsf@openvz.org>
References: <877hthytz0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:55588 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZKWWnx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 17:43:53 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTL00D9B3CTE510@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 24 Nov 2009 01:48:32 +0300 (MSK)
In-reply-to: <877hthytz0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:
> @@ -1119,8 +1121,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
> -	EXT4_I(inode)->i_reserved_data_blocks -= used;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
^^^^^^^^^^ OOps... i've just deleted spin_unlock, but it supposed to
           be moved down. And appear again in second patch ;(
           Seem what i've mistyped during patch splitting. Please ignore
           this version, i'll send new version in a minute. 

> + 	EXT4_I(inode)->i_reserved_data_blocks -= used;
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
> +	vfs_dq_claim_block(inode, used + mdb_claim);
>  
>  	/*
>  	 * free those over-booking quota for metadata blocks
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
