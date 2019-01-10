Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbfAJK2v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 05:28:51 -0500
Date: Thu, 10 Jan 2019 11:28:50 +0100
From: Jan Kara <jack@suse.cz>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, miaoxie@huawei.com
Subject: Re: [PATCH 2/2] ext4: fix compile error when using BUFFER_TRACE
Message-ID: <20190110102850.GE15790@quack2.suse.cz>
References: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
 <1547100399-127915-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1547100399-127915-3-git-send-email-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-01-19 14:06:39, zhangyi (F) wrote:
> Fix compile error below when using BUFFER_TRACE.
> 
> fs/ext4/inode.c: In function ‘ext4_expand_extra_isize’:
> fs/ext4/inode.c:5979:19: error: request for member ‘bh’ in something not a structure or union
>   BUFFER_TRACE(iloc.bh, "get_write_access");
> 
> Fixes: c03b45b853f58 ("ext4, project: expand inode extra size if possible")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d81..b7384d5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5976,7 +5976,7 @@ int ext4_expand_extra_isize(struct inode *inode,
>  
>  	ext4_write_lock_xattr(inode, &no_expand);
>  
> -	BUFFER_TRACE(iloc.bh, "get_write_access");
> +	BUFFER_TRACE(iloc->bh, "get_write_access");
>  	error = ext4_journal_get_write_access(handle, iloc->bh);
>  	if (error) {
>  		brelse(iloc->bh);
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
