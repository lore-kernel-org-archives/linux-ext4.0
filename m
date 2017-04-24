From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: set an error code in ext4_quota_off()
Date: Mon, 24 Apr 2017 16:46:34 +0200
Message-ID: <20170424144634.GE23988@quack2.suse.cz>
References: <20170421105345.slxfkl3jf2ucq6h7@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170421105345.slxfkl3jf2ucq6h7@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 21-04-17 13:53:45, Dan Carpenter wrote:
> We accidentally return success instead of a negative error code on these
> paths.
> 
> Fixes: 957153fce8d2 ("ext4: Set flags on quota files directly")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

So actually this is deliberate. Although setting inode flags fails, we have
already enabled / disabled quotas and so we just return success. Failing to
set the flags is just a loss of safety measure but not a hard failure...
But I guess it deserves a comment so I'll add it.

								Honza

> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4a32c9279f35..735adca37fdf 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5377,8 +5377,10 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  
>  		inode_lock(inode);
>  		handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
> -		if (IS_ERR(handle))
> +		if (IS_ERR(handle)) {
> +			err = PTR_ERR(handle);
>  			goto unlock_inode;
> +		}
>  		EXT4_I(inode)->i_flags |= EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL;
>  		inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
>  				S_NOATIME | S_IMMUTABLE);
> @@ -5478,8 +5480,10 @@ static int ext4_quota_off(struct super_block *sb, int type)
>  	/* Update modification times of quota files when userspace can
>  	 * start looking at them */
>  	handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
> -	if (IS_ERR(handle))
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
>  		goto out_unlock;
> +	}
>  	EXT4_I(inode)->i_flags &= ~(EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL);
>  	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
>  	inode->i_mtime = inode->i_ctime = current_time(inode);
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
