Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727136AbeIYBia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Sep 2018 21:38:30 -0400
Date: Mon, 24 Sep 2018 21:34:43 +0200
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: remove redundant building macro check
Message-ID: <20180924193443.GA4841@quack2.suse.cz>
References: <20180924061015.30976-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924061015.30976-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-09-18 14:10:15, Chengguang Xu wrote:
> If macro CONFIG_QUOTA is not enabled then mount option flag
> of usrquota/grpquota will not be set, so we can remove some
> building macro check safely in ext2_shwo_options().
> Additionally, I think it's better to define EXT2_MOUNT_DAX
> regardless macro CONFIG_FS_DAX is enabled just like acl/xattr.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Looks like a nice cleanup. Applied. Thanks.

								Honza

> ---
>  fs/ext2/ext2.h  | 4 ----
>  fs/ext2/super.c | 5 +----
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 00e759f05161..e770cd100a6a 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -390,11 +390,7 @@ struct ext2_inode {
>  #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
>  #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
>  #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
> -#ifdef CONFIG_FS_DAX
>  #define EXT2_MOUNT_DAX			0x100000  /* Direct Access */
> -#else
> -#define EXT2_MOUNT_DAX			0
> -#endif
>  
>  
>  #define clear_opt(o, opt)		o &= ~EXT2_MOUNT_##opt
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 73bd58fa13de..cb91baa4275d 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -309,20 +309,17 @@ static int ext2_show_options(struct seq_file *seq, struct dentry *root)
>  	if (test_opt(sb, NOBH))
>  		seq_puts(seq, ",nobh");
>  
> -#if defined(CONFIG_QUOTA)
>  	if (sbi->s_mount_opt & EXT2_MOUNT_USRQUOTA)
>  		seq_puts(seq, ",usrquota");
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_GRPQUOTA)
>  		seq_puts(seq, ",grpquota");
> -#endif
>  
> -#ifdef CONFIG_FS_DAX
>  	if (sbi->s_mount_opt & EXT2_MOUNT_XIP)
>  		seq_puts(seq, ",xip");
> +
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX)
>  		seq_puts(seq, ",dax");
> -#endif
>  
>  	if (!test_opt(sb, RESERVATION))
>  		seq_puts(seq, ",noreservation");
> -- 
> 2.17.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
