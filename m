From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix return value of ext4_do_update_inode
Date: Mon, 29 Sep 2014 13:30:41 +0200
Message-ID: <20140929113041.GB2738@quack.suse.cz>
References: <1411955914-550-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaI2Lar (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Sep 2014 07:30:47 -0400
Content-Disposition: inline
In-Reply-To: <1411955914-550-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-09-14 09:58:34, Li Xi wrote:
> When ext4_do_update_inode() gets error from ext4_inode_blocks_set(),
> error number should be returned.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
>  fs/ext4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d5dd7d4..03ddfd7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4204,7 +4204,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
>  	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
>  
> -	if (ext4_inode_blocks_set(handle, raw_inode, ei)) {
> +	err = ext4_inode_blocks_set(handle, raw_inode, ei);
> +	if (err) {
>  		spin_unlock(&ei->i_raw_lock);
>  		goto out_brelse;
>  	}
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
