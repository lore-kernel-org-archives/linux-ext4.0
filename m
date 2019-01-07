Return-Path: <SRS0=AOtw=PP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbfAGQpH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Jan 2019 11:45:07 -0500
Date: Mon, 7 Jan 2019 17:45:06 +0100
From: Jan Kara <jack@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: set proper return code
Message-ID: <20190107164506.GC30327@quack2.suse.cz>
References: <20190101133028.18021-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190101133028.18021-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-01-19 21:30:28, Chengguang Xu wrote:
> Set proper return code when failing from allocating
> memory in ext2_fill_super().
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/ext2/super.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks, I've added the patch to my tree.

								Honza


> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 73b2d528237f..b6d8402f5c62 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1087,12 +1087,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  					   sizeof(struct buffer_head *),
>  					   GFP_KERNEL);
>  	if (sbi->s_group_desc == NULL) {
> +		ret = -ENOMEM;
>  		ext2_msg(sb, KERN_ERR, "error: not enough memory");
>  		goto failed_mount;
>  	}
>  	bgl_lock_init(sbi->s_blockgroup_lock);
>  	sbi->s_debts = kcalloc(sbi->s_groups_count, sizeof(*sbi->s_debts), GFP_KERNEL);
>  	if (!sbi->s_debts) {
> +		ret = -ENOMEM;
>  		ext2_msg(sb, KERN_ERR, "error: not enough memory");
>  		goto failed_mount_group_desc;
>  	}
> @@ -1148,6 +1150,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	sbi->s_ea_block_cache = ext2_xattr_create_cache();
>  	if (!sbi->s_ea_block_cache) {
> +		ret = -ENOMEM;
>  		ext2_msg(sb, KERN_ERR, "Failed to create ea_block_cache");
>  		goto failed_mount3;
>  	}
> -- 
> 2.17.2
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
