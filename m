From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V1 2/2] Ext3: return ENOMEM rather than EIO if
 sb_getblk fails
Date: Mon, 14 Jan 2013 15:29:25 +0100
Message-ID: <20130114142925.GG6597@quack.suse.cz>
References: <1358073895-1734-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab3ANO32 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 09:29:28 -0500
Content-Disposition: inline
In-Reply-To: <1358073895-1734-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 13-01-13 18:44:55, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> It will be better to have ENOMEM return rather than EIO,because
> the only reason that sb_getblk fails is allocation fails.
  Again one case is wrong. See below.

> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext3/inode.c  | 6 +++---
>  fs/ext3/resize.c | 6 +++---
>  fs/ext3/xattr.c  | 2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index c91f8bf..d5315d5 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1084,7 +1084,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
>  		struct buffer_head *bh;
>  		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
>  		if (unlikely(!bh)) {
> -			*errp = -EIO;
> +			*errp = -ENOMEM;
>  			goto err;
>  		}
>  		if (buffer_new(&dummy)) {
> @@ -2739,7 +2739,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
>  				"unable to read inode block - "
>  				"inode=%lu, block="E3FSBLK,
>  				 inode->i_ino, block);
> -		return -EIO;
> +		return -ENOMEM;
>  	}
>  	if (!buffer_uptodate(bh)) {
>  		lock_buffer(bh);
> @@ -2833,7 +2833,7 @@ make_io:
>  					"inode=%lu, block="E3FSBLK,
>  					inode->i_ino, block);
>  			brelse(bh);
> -			return -EIO;
> +			return -ENOMEM;
  This is wrong. Here we really failed because of IO error (buffer was not
uptodate).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
