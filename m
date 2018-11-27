Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730087AbeK0URA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 15:17:00 -0500
Date: Tue, 27 Nov 2018 10:19:43 +0100
From: Jan Kara <jack@suse.cz>
To: Pan Bian <bianpan2016@163.com>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: fix potential use after free
Message-ID: <20181127091943.GB16301@quack2.suse.cz>
References: <1543107482-97334-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543107482-97334-1-git-send-email-bianpan2016@163.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 25-11-18 08:58:02, Pan Bian wrote:
> The function ext2_xattr_set calls brelse(bh) to drop the reference count
> of bh. After that, bh may be freed. However, following brelse(bh),
> it reads bh->b_data via macro HDR(bh). This may result in a
> use-after-free bug. This patch moves brelse(bh) after reading field.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Thanks for the fix! I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 62d9a659a..dd8f10d 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -612,9 +612,9 @@ bad_block:		ext2_error(sb, "ext2_xattr_set",
>  	}
>  
>  cleanup:
> -	brelse(bh);
>  	if (!(bh && header == HDR(bh)))
>  		kfree(header);
> +	brelse(bh);
>  	up_write(&EXT2_I(inode)->xattr_sem);
>  
>  	return error;
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
