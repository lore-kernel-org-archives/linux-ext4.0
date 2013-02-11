From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/12] ext4: start handle at the last possible moment
 in ext4_unlink()
Date: Mon, 11 Feb 2013 17:21:33 +0100
Message-ID: <20130211162133.GJ5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab3BKQVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 11:21:36 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:47, Ted Tso wrote:
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
> index 5184103..4a27069 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2787,7 +2787,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  	struct inode *inode;
>  	struct buffer_head *bh;
>  	struct ext4_dir_entry_2 *de;
> -	handle_t *handle;
> +	handle_t *handle = NULL;
>  
>  	trace_ext4_unlink_enter(dir, dentry);
>  	/* Initialize quotas before so that eventual writes go
> @@ -2795,14 +2795,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  	dquot_initialize(dir);
>  	dquot_initialize(dentry->d_inode);
>  
> -	handle = ext4_journal_start(dir, EXT4_HT_DIR,
> -				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> -
> -	if (IS_DIRSYNC(dir))
> -		ext4_handle_sync(handle);
> -
>  	retval = -ENOENT;
>  	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
>  	if (!bh)
> @@ -2814,6 +2806,17 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  	if (le32_to_cpu(de->inode) != inode->i_ino)
>  		goto end_unlink;
>  
> +	handle = ext4_journal_start(dir, EXT4_HT_DIR,
> +				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> +	if (IS_ERR(handle)) {
> +		retval = PTR_ERR(handle);
> +		handle = NULL;
> +		goto end_unlink;
> +	}
> +
> +	if (IS_DIRSYNC(dir))
> +		ext4_handle_sync(handle);
> +
>  	if (!inode->i_nlink) {
>  		ext4_warning(inode->i_sb,
>  			     "Deleting nonexistent file (%lu), %d",
> @@ -2834,8 +2837,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  	retval = 0;
>  
>  end_unlink:
> -	ext4_journal_stop(handle);
>  	brelse(bh);
> +	if (handle)
> +		ext4_journal_stop(handle);
>  	trace_ext4_unlink_exit(dentry, retval);
>  	return retval;
>  }
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
