From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: cleanup the confused goto label
Date: Wed, 27 Jun 2012 18:29:55 +0200
Message-ID: <20120627162955.GD5387@quack.suse.cz>
References: <1340506303-31723-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2F0Q35 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 12:29:57 -0400
Content-Disposition: inline
In-Reply-To: <1340506303-31723-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 24-06-12 10:51:43, Wanlong Gao wrote:
> Cleanup the confused goto label in ext2_fill_super.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  fs/ext2/super.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index b3621cb..301379d 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -771,14 +771,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	err = -ENOMEM;
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
> -		goto failed_unlock;
> +		goto failed;
  This change is OK...

>  
>  	sbi->s_blockgroup_lock =
>  		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
> -	if (!sbi->s_blockgroup_lock) {
> -		kfree(sbi);
> -		goto failed_unlock;
> -	}
> +	if (!sbi->s_blockgroup_lock)
> +		goto failed_sbi;
> +
  ... but this and all the changes below really look like an unnecessary
code churn. So please just submit that one change. Thanks.

										Honza

>  	sb->s_fs_info = sbi;
>  	sbi->s_sb_block = sb_block;
>  
> @@ -794,7 +793,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
>  	if (!blocksize) {
>  		ext2_msg(sb, KERN_ERR, "error: unable to set blocksize");
> -		goto failed_sbi;
> +		goto failed_bg_lock;
>  	}
>  
>  	/*
> @@ -810,7 +809,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (!(bh = sb_bread(sb, logic_sb_block))) {
>  		ext2_msg(sb, KERN_ERR, "error: unable to read superblock");
> -		goto failed_sbi;
> +		goto failed_bg_lock;
>  	}
>  	/*
>  	 * Note: s_es must be initialized as soon as possible because
> @@ -905,7 +904,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		if (!sb_set_blocksize(sb, blocksize)) {
>  			ext2_msg(sb, KERN_ERR,
>  				"error: bad blocksize %d", blocksize);
> -			goto failed_sbi;
> +			goto failed_bg_lock;
>  		}
>  
>  		logic_sb_block = (sb_block*BLOCK_SIZE) / blocksize;
> @@ -914,7 +913,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		if(!bh) {
>  			ext2_msg(sb, KERN_ERR, "error: couldn't read"
>  				"superblock on 2nd try");
> -			goto failed_sbi;
> +			goto failed_bg_lock;
>  		}
>  		es = (struct ext2_super_block *) (((char *)bh->b_data) + offset);
>  		sbi->s_es = es;
> @@ -1126,11 +1125,12 @@ failed_mount_group_desc:
>  	kfree(sbi->s_debts);
>  failed_mount:
>  	brelse(bh);
> -failed_sbi:
> +failed_bg_lock:
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
> +failed_sbi:
>  	kfree(sbi);
> -failed_unlock:
> +failed:
>  	return ret;
>  }
>  
> -- 
> 1.7.11.rc0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
