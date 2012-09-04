From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: serialize unlocked dio reads with truncate
Date: Tue, 4 Sep 2012 15:52:14 +0200
Message-ID: <20120904135214.GB8656@quack.suse.cz>
References: <1346690448-16917-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2IDNwR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Sep 2012 09:52:17 -0400
Content-Disposition: inline
In-Reply-To: <1346690448-16917-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 03-09-12 20:40:48, Dmitry Monakhov wrote:
> Current serialization will works only for DIO which holds
> i_mutex, but nonlocked DIO following race is possable:
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
  Right, that looks like a bug. Just isn't the "unlocked DIO" also
problematic because if we have enough aggressive readers, callers doing
inode_dio_wait() are waiting forever (I've just tried that with the value
of forever == several minutes).

  Also there is similar data exposure possible when direct IO read races
with block allocation, isn't it?

  Hum, and there seems to be also potential data corruption issue with
direct IO overwrites racing with truncate:
Like:
 dio write                      truncate_task
 ->ext4_ext_direct_IO
  ->overwrite == 1
   ->down_read(&EXT4_I(inode)->i_data_sem);
   ->mutex_unlock(&inode->i_mutex);
 				->ext4_setattr()
 				 ->inode_dio_wait()
 				 ->truncate_setsize()
 				 ->ext4_truncate()
				  ->down_write(&EXT4_I(inode)->i_data_sem);
   ->__blockdev_direct_IO
    ->ext4_get_block
    ->submit_io()
   ->up_read(&EXT4_I(inode)->i_data_sem);
 				  # truncate data blocks, allocate them to
 				  # other inode - bad stuff happens because
				  # dio is still in flight.

  Anyway your patch makes things better so I'm fine with it (feel free to
add Reviewed-by: Jan Kara <jack@suse.cz>). Just it seems direct IO locking
is rather broken in general...

								Honza

> In order to serialize with unlocked DIO reads we have to
> rearange wait sequance
  ^^^ rearrange  ^^^ sequence

> 1) update i_size first
> 2) wait for outstanding DIO requests
> 3) and only after that truncate inode blocks
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d12d30e..ee534ab 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4304,8 +4304,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> -		inode_dio_wait(inode);
> -
>  		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
>  			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  
> @@ -4355,6 +4353,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	if (attr->ia_valid & ATTR_SIZE) {
>  		if (attr->ia_size != i_size_read(inode))
>  			truncate_setsize(inode, attr->ia_size);
> +		inode_dio_wait(inode);
>  		ext4_truncate(inode);
>  	}
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
