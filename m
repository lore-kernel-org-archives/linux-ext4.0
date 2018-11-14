Return-Path: <SRS0=wBZF=NZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35346 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726823AbeKNWSh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 14 Nov 2018 17:18:37 -0500
Date: Wed, 14 Nov 2018 13:15:32 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: remove redundant condition check
Message-ID: <20181114121532.GA19383@quack2.suse.cz>
References: <20181113232353.11011-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113232353.11011-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-11-18 07:23:53, Chengguang Xu wrote:
> ext2_xattr_destroy_cache() can handle NULL pointer correctly,
> so there is no need to check NULL pointer before calling
> ext2_xattr_destroy_cache().
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Looks good. Applied. Thanks for the patch.

							Honza

> ---
>  fs/ext2/super.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index cb91baa4275d..e4351c280608 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -148,10 +148,9 @@ static void ext2_put_super (struct super_block * sb)
>  
>  	ext2_quota_off_umount(sb);
>  
> -	if (sbi->s_ea_block_cache) {
> -		ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
> -		sbi->s_ea_block_cache = NULL;
> -	}
> +	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
> +	sbi->s_ea_block_cache = NULL;
> +
>  	if (!sb_rdonly(sb)) {
>  		struct ext2_super_block *es = sbi->s_es;
>  
> @@ -1197,8 +1196,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  			sb->s_id);
>  	goto failed_mount;
>  failed_mount3:
> -	if (sbi->s_ea_block_cache)
> -		ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
> +	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
>  	percpu_counter_destroy(&sbi->s_freeblocks_counter);
>  	percpu_counter_destroy(&sbi->s_freeinodes_counter);
>  	percpu_counter_destroy(&sbi->s_dirs_counter);
> -- 
> 2.17.2
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
