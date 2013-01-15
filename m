From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V2 1/2] Ext2: return ENOMEM rather than EIO if
 sb_getblk fails
Date: Tue, 15 Jan 2013 14:30:44 +0100
Message-ID: <20130115133044.GA4631@quack.suse.cz>
References: <50F6384A.1070909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3AONap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 08:30:45 -0500
Content-Disposition: inline
In-Reply-To: <50F6384A.1070909@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-01-13 21:19:06, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> As the only reason that sb_getblks fails is that allocation fails.
> It will be better to use ENOMEM rather than EIO.
  Thanks, I've merged the patch to my tree.

								Honza

> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/xattr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 06209ec..2d7557d 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -665,7 +665,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
>  			if (unlikely(!new_bh)) {
>  				ext2_free_blocks(inode, block, 1);
>  				mark_inode_dirty(inode);
> -				error = -EIO;
> +				error = -ENOMEM;
>  				goto cleanup;
>  			}
>  			lock_buffer(new_bh);
> -- 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
