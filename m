Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730050AbeK0UMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 15:12:10 -0500
Date: Tue, 27 Nov 2018 10:14:53 +0100
From: Jan Kara <jack@suse.cz>
To: Pan Bian <bianpan2016@163.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix possible use after free in ext4_quota_enable
Message-ID: <20181127091453.GA16301@quack2.suse.cz>
References: <1543202466-68277-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543202466-68277-1-git-send-email-bianpan2016@163.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-11-18 11:21:06, Pan Bian wrote:
> The function frees qf_inode via iput but then pass qf_inode to
> lockdep_set_quota_inode on the failure path. This may result in a
> use-after-free bug. The patch frees df_inode only when it is never used.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> Fixes: daf647d2dd5("ext4: add lockdep annotations for i_data_sem")

Thanks for the fix! The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 53ff6c2..35689eb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5690,9 +5690,9 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
>  	qf_inode->i_flags |= S_NOQUOTA;
>  	lockdep_set_quota_inode(qf_inode, I_DATA_SEM_QUOTA);
>  	err = dquot_enable(qf_inode, type, format_id, flags);
> -	iput(qf_inode);
>  	if (err)
>  		lockdep_set_quota_inode(qf_inode, I_DATA_SEM_NORMAL);
> +	iput(qf_inode);
>  
>  	return err;
>  }
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
