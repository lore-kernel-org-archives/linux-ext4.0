Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727553AbeKSUZ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Nov 2018 15:25:56 -0500
Date: Mon, 19 Nov 2018 11:02:46 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: surround xattr related code with macro
 CONFIG_EXT2_FS_XATTR
Message-ID: <20181119100246.GC16427@quack2.suse.cz>
References: <20181117125916.31461-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181117125916.31461-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 17-11-18 20:59:16, Chengguang Xu wrote:
> ext2_xattr_destroy_cache() is only needed when macro
> CONFIG_EXT2_FS_XATTR is enabled, so surround related
> code with the macro.

True but I prefer (and it is a general kernel practice) to avoid ifdef
in code if reasonably possible.

								Honza

> ---
>  fs/ext2/super.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index e4351c280608..67a71b0cb5e0 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -148,8 +148,10 @@ static void ext2_put_super (struct super_block * sb)
>  
>  	ext2_quota_off_umount(sb);
>  
> +#ifdef CONFIG_EXT2_FS_XATTR
>  	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
>  	sbi->s_ea_block_cache = NULL;
> +#endif
>  
>  	if (!sb_rdonly(sb)) {
>  		struct ext2_super_block *es = sbi->s_es;
> @@ -1196,7 +1198,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  			sb->s_id);
>  	goto failed_mount;
>  failed_mount3:
> +#ifdef CONFIG_EXT2_FS_XATTR
>  	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
> +#endif
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
