From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/12] ext4: start handle at the last possible moment
 in ext4_rmdir()
Date: Mon, 11 Feb 2013 17:22:56 +0100
Message-ID: <20130211162256.GK5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-9-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab3BKQW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 11:22:57 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-9-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:48, Ted Tso wrote:
> Don't start the jbd2 transaction handle until after the directory
> entry has been found, to minimize the amount of time that a handle is
> held active.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/namei.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a27069..36a4afd 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2725,26 +2725,18 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	struct inode *inode;
>  	struct buffer_head *bh;
>  	struct ext4_dir_entry_2 *de;
> -	handle_t *handle;
> +	handle_t *handle = NULL;
>  
>  	/* Initialize quotas before so that eventual writes go in
>  	 * separate transaction */
>  	dquot_initialize(dir);
>  	dquot_initialize(dentry->d_inode);
>  
> -	handle = ext4_journal_start(dir, EXT4_HT_DIR,
> -				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> -
>  	retval = -ENOENT;
>  	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
>  	if (!bh)
>  		goto end_rmdir;
>  
> -	if (IS_DIRSYNC(dir))
> -		ext4_handle_sync(handle);
> -
>  	inode = dentry->d_inode;
>  
>  	retval = -EIO;
> @@ -2755,6 +2747,17 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	if (!empty_dir(inode))
>  		goto end_rmdir;
>  
> +	handle = ext4_journal_start(dir, EXT4_HT_DIR,
> +				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> +	if (IS_ERR(handle)) {
> +		retval = PTR_ERR(handle);
> +		handle = NULL;
> +		goto end_rmdir;
> +	}
> +
> +	if (IS_DIRSYNC(dir))
> +		ext4_handle_sync(handle);
> +
>  	retval = ext4_delete_entry(handle, dir, de, bh);
>  	if (retval)
>  		goto end_rmdir;
> @@ -2776,8 +2779,9 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	ext4_mark_inode_dirty(handle, dir);
>  
>  end_rmdir:
> -	ext4_journal_stop(handle);
>  	brelse(bh);
> +	if (handle)
> +		ext4_journal_stop(handle);
>  	return retval;
>  }
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
