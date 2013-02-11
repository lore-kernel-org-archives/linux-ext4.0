From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/12] ext4: fix the number of credits needed for
 ext4_unlink() and ext4_rmdir()
Date: Mon, 11 Feb 2013 17:28:30 +0100
Message-ID: <20130211162830.GM5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-11-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab3BKQ2c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 11:28:32 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:50, Ted Tso wrote:
> The ext4_unlink() and ext4_rmdir() don't actually release the blocks
> associated with the file/directory.  This gets done in a separate jbd2
> handle called via ext4_evict_inode().  Thus, we don't need to reserve
> lots of journal credits for the truncate.
> 
> Note that using too many journal credits is non-optimal because it can
> leading to the journal transmit getting closed too early, before it is
> strictly necessary.
  Nice spotting. The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4_jbd2.h | 6 ------
>  fs/ext4/namei.c     | 4 ++--
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 302814b..c1fc2dc 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -59,12 +59,6 @@
>  #define EXT4_META_TRANS_BLOCKS(sb)	(EXT4_XATTR_TRANS_BLOCKS + \
>  					EXT4_MAXQUOTAS_TRANS_BLOCKS(sb))
>  
> -/* Delete operations potentially hit one directory's namespace plus an
> - * entire inode, plus arbitrary amounts of bitmap/indirection data.  Be
> - * generous.  We can grow the delete transaction later if necessary. */
> -
> -#define EXT4_DELETE_TRANS_BLOCKS(sb)	(2 * EXT4_DATA_TRANS_BLOCKS(sb) + 64)
> -
>  /* Define an arbitrary limit for the amount of data we will anticipate
>   * writing to any given transaction.  For unbounded transactions such as
>   * write(2) and truncate(2) we can write more than this, but we always
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 36a4afd..5f3d2b5 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2748,7 +2748,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  		goto end_rmdir;
>  
>  	handle = ext4_journal_start(dir, EXT4_HT_DIR,
> -				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> +				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle)) {
>  		retval = PTR_ERR(handle);
>  		handle = NULL;
> @@ -2811,7 +2811,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  		goto end_unlink;
>  
>  	handle = ext4_journal_start(dir, EXT4_HT_DIR,
> -				    EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
> +				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle)) {
>  		retval = PTR_ERR(handle);
>  		handle = NULL;
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
