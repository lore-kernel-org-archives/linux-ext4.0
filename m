From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: get rid of the duplicate code on ext3_fill_super
Date: Mon, 29 Oct 2012 11:39:50 +0100
Message-ID: <20121029103950.GA18767@quack.suse.cz>
References: <508E3007.1070902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2J2Kjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 06:39:53 -0400
Content-Disposition: inline
In-Reply-To: <508E3007.1070902@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-10-12 15:28:07, Zhao Hongjiang wrote:
> From: Zhao Hongjiang <zhaohongjiang@huawei.com>
> 
> Clean the duplicate code on ext3_fill_super cause the bellow
> also have it.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
  Thanks. I've merged the patch to my tree with somewhat updated changelog:
Setting s_mount_opt to 0 is unnecessary because we use kzalloc() for sb
allocation. s_resuid and s_resgid are set again few lines below based on
values in on disk superblock.

								Honza

> ---
>  fs/ext3/super.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 5366393..6e50223 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1661,9 +1661,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  		return -ENOMEM;
>  	}
>  	sb->s_fs_info = sbi;
> -	sbi->s_mount_opt = 0;
> -	sbi->s_resuid = make_kuid(&init_user_ns, EXT3_DEF_RESUID);
> -	sbi->s_resgid = make_kgid(&init_user_ns, EXT3_DEF_RESGID);
>  	sbi->s_sb_block = sb_block;
> 
>  	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
> -- 1.7.1
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
