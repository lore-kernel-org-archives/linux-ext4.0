From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: cleanup the confused goto label
Date: Wed, 27 Jun 2012 19:19:07 +0200
Message-ID: <20120627171907.GF5387@quack.suse.cz>
References: <20120627162955.GD5387@quack.suse.cz>
 <1340815784-6028-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab2F0RTJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 13:19:09 -0400
Content-Disposition: inline
In-Reply-To: <1340815784-6028-1-git-send-email-gaowanlong@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-06-12 00:49:44, Wanlong Gao wrote:
> Cleanup the confused goto label, since the big lock has been removed.
  Thanks! Merged.

									Honza
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  fs/ext2/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index b3621cb..c8e4979 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -771,13 +771,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	err = -ENOMEM;
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
> -		goto failed_unlock;
> +		goto failed;
>  
>  	sbi->s_blockgroup_lock =
>  		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
>  	if (!sbi->s_blockgroup_lock) {
>  		kfree(sbi);
> -		goto failed_unlock;
> +		goto failed;
>  	}
>  	sb->s_fs_info = sbi;
>  	sbi->s_sb_block = sb_block;
> @@ -1130,7 +1130,7 @@ failed_sbi:
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
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
