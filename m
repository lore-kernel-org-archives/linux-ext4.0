From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH V2] ext4: increase the protection of drop nlink and
 ext4 inode destroy
Date: Wed, 4 Jan 2017 17:29:23 +0100
Message-ID: <20170104162923.GC3607@quack2.suse.cz>
References: <1482994539-48559-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
To: yi zhang <yi.zhang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482994539-48559-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 29-12-16 14:55:39, yi zhang wrote:
> Because of the disk and hardware issue, the ext4 filesystem have 
> many errors, the inode->i_nlink of ext4 becomes zero abnormally 
> but the dentry is still positive, it will cause memory corruption 
> after the following process:
> 
>  1) Due to the inode->i_nlink is 0, this inode will be added into
> the orhpan list,
>  2) ext4_rename() cover this inode, and drop_nlink() will reverse
> the inode->i_nlink to 0xFFFFFFFF,
>  3) iput() add this inode to LRU,
>  4) evict() will call destroy_inode() to destroy this inode but
> skip removing it from the orphan list,
>  5) after this, the inode's memory address space will be used by
> other module, when the ext4 filesystem change the orphan list, it will
> trample other module's data and then may cause oops.
> 
> Although we cannot avoid hardware and disk errors, we can control the
> softwore error in the ext4 module, do not affect other modules and
> increase the difficulty of locating problems.
> 
> This patch avoid inode->i_nlink reverse and remove the inode from the
> orphan list when destroy it if the list is not empty.
> 
> changes since: v1
>  - correct a spelling mistake.
>  - change the style of the WARN string.
> 
> Signed-off-by: yi zhang <yi.zhang@huawei.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 1 +
>  fs/inode.c      | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 52b0530..617327e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -975,6 +975,7 @@ static void ext4_destroy_inode(struct inode *inode)
>  				EXT4_I(inode), sizeof(struct ext4_inode_info),
>  				true);
>  		dump_stack();
> +		ext4_orphan_del(NULL, inode);
>  	}
>  	call_rcu(&inode->i_rcu, ext4_i_callback);
>  }
> diff --git a/fs/inode.c b/fs/inode.c
> index 88110fd..079d383 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -279,7 +279,10 @@ static void destroy_inode(struct inode *inode)
>   */
>  void drop_nlink(struct inode *inode)
>  {
> -	WARN_ON(inode->i_nlink == 0);
> +	if (WARN(inode->i_nlink == 0,
> +		"inode %lu nlink is already 0", inode->i_ino))
> +		return;
> +
>  	inode->__i_nlink--;
>  	if (!inode->i_nlink)
>  		atomic_long_inc(&inode->i_sb->s_remove_count);
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
