From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/7] ext4: serialize unlocked dio reads with truncate
Date: Mon, 10 Sep 2012 11:54:50 +0200
Message-ID: <20120910095450.GG22903@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2IJJyw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 05:54:52 -0400
Content-Disposition: inline
In-Reply-To: <1347211634-11509-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 09-09-12 21:27:12, Dmitry Monakhov wrote:
> Current serialization will works only for DIO which holds
> i_mutex, but nonlocked DIO following race is possible:
> 
> dio_nolock_read_task            truncate_task
> 				->ext4_setattr()
> 				 ->inode_dio_wait()
> ->ext4_ext_direct_IO
>   ->ext4_ind_direct_IO
>     ->__blockdev_direct_IO
>       ->ext4_get_block
> 				 ->truncate_setsize()
> 				 ->ext4_truncate()
> 				 #alloc truncated blocks
> 				 #to other inode
>       ->submit_io()
>      #INFORMATION LEAK
> 
> In order to serialize with unlocked DIO reads we have to
> rearrange wait sequence
> 1) update i_size first
> 2) if i_size about to be reduced wait for outstanding DIO requests
> 3) and only after that truncate inode blocks
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ffb4a27..93e6b09 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4283,7 +4283,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> -		inode_dio_wait(inode);
>  
>  		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
>  			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> @@ -4332,8 +4331,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> -		if (attr->ia_size != i_size_read(inode))
> +		if (attr->ia_size != inode->i_size) {
>  			truncate_setsize(inode, attr->ia_size);
> +			/* Inode size will be reduced, wait for dio in flight */
> +			if (orphan)
> +				inode_dio_wait(inode);
> +		}
>  		ext4_truncate(inode);
>  	}
>  
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
