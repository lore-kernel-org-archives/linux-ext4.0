Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbeK0UlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 15:41:20 -0500
Date: Tue, 27 Nov 2018 10:43:58 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove redundant condition check
Message-ID: <20181127094358.GE16301@quack2.suse.cz>
References: <20181113232448.11071-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113232448.11071-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-11-18 07:24:48, Chengguang Xu wrote:
> ext4_xattr_destroy_cache() can handle NULL pointer correctly,
> so there is no need to check NULL pointer before calling
> ext4_xattr_destroy_cache().
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 53ff6c2a26ed..30d4a4e69de8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1000,14 +1000,13 @@ static void ext4_put_super(struct super_block *sb)
>  		invalidate_bdev(sbi->journal_bdev);
>  		ext4_blkdev_remove(sbi);
>  	}
> -	if (sbi->s_ea_inode_cache) {
> -		ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
> -		sbi->s_ea_inode_cache = NULL;
> -	}
> -	if (sbi->s_ea_block_cache) {
> -		ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
> -		sbi->s_ea_block_cache = NULL;
> -	}
> +
> +	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
> +	sbi->s_ea_inode_cache = NULL;
> +
> +	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
> +	sbi->s_ea_block_cache = NULL;
> +
>  	if (sbi->s_mmp_tsk)
>  		kthread_stop(sbi->s_mmp_tsk);
>  	brelse(sbi->s_sbh);
> @@ -4522,14 +4521,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (EXT4_SB(sb)->rsv_conversion_wq)
>  		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
>  failed_mount_wq:
> -	if (sbi->s_ea_inode_cache) {
> -		ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
> -		sbi->s_ea_inode_cache = NULL;
> -	}
> -	if (sbi->s_ea_block_cache) {
> -		ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
> -		sbi->s_ea_block_cache = NULL;
> -	}
> +	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
> +	sbi->s_ea_inode_cache = NULL;
> +
> +	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
> +	sbi->s_ea_block_cache = NULL;
> +
>  	if (sbi->s_journal) {
>  		jbd2_journal_destroy(sbi->s_journal);
>  		sbi->s_journal = NULL;
> -- 
> 2.17.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
