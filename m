Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727752AbeKGXUq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 18:20:46 -0500
Date: Wed, 7 Nov 2018 14:50:16 +0100
From: Jan Kara <jack@suse.cz>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH 6/7] ext4: lost brelse in ext4_xattr_move_to_block()
Message-ID: <20181107135016.GE25758@quack2.suse.cz>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <76da5ae3-274d-efa4-58bb-6cd280763a37@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76da5ae3-274d-efa4-58bb-6cd280763a37@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 31-10-18 22:13:00, Vasily Averin wrote:
> Fixes 3f2571c1f91f ("ext4: factor out xattr moving")
> cc: Jan Kara <jack@suse.cz>
> however issue was present in original ext4_expand_extra_isize_ea()
> Fixes 6dd4ee7cab7e ("ext4: Expand extra_inodes space per ...") # 2.6.23
> cc: Kalpak Shah <kalpak@clusterfs.com>
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Good catch. Thanks for the fix. The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 07b9a335c8eb..5c9bc0d85cc0 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2617,6 +2617,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
>  	kfree(buffer);
>  	if (is)
>  		brelse(is->iloc.bh);
> +	if (bs)
> +		brelse(bs->bh);
>  	kfree(is);
>  	kfree(bs);
>  
> -- 
> 2.17.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
