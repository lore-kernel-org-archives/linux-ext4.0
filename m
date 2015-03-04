From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix bh leak on error paths in ext4_rename() and
 ext4_cross_rename()
Date: Wed, 4 Mar 2015 16:03:39 +0100
Message-ID: <20150304150339.GB32219@quack.suse.cz>
References: <20150303111719.26916.92177.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150303111719.26916.92177.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 03-03-15 14:17:19, Konstantin Khlebnikov wrote:
> Release references to buffer-heads if ext4_journal_start() fails.
  Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: 5b61de757535 ("ext4: start handle at least possible moment when renaming files")
> ---
>  fs/ext4/namei.c |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 28fe71a2904c..8110dd20ad3f 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3264,12 +3264,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
>  	if (!(flags & RENAME_WHITEOUT)) {
>  		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
> -		if (IS_ERR(handle))
> -			return PTR_ERR(handle);
> +		if (IS_ERR(handle)) {
> +			retval = PTR_ERR(handle);
> +			handle = NULL;
> +			goto end_rename;
> +		}
>  	} else {
>  		whiteout = ext4_whiteout_for_rename(&old, credits, &handle);
> -		if (IS_ERR(whiteout))
> -			return PTR_ERR(whiteout);
> +		if (IS_ERR(whiteout)) {
> +			retval = PTR_ERR(whiteout);
> +			whiteout = NULL;
> +			goto end_rename;
> +		}
>  	}
>  
>  	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
> @@ -3433,8 +3439,11 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
>  		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
>  		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		retval = PTR_ERR(handle);
> +		handle = NULL;
> +		goto end_rename;
> +	}
>  
>  	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
>  		ext4_handle_sync(handle);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
