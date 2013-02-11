From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/12] ext4: fix the number of credits needed for
 ext4_ext_migrate()
Date: Mon, 11 Feb 2013 17:26:37 +0100
Message-ID: <20130211162637.GL5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
 <1360446832-12724-10-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab3BKQ0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 11:26:40 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:49, Ted Tso wrote:
> The migration ioctl creates a temporary inode.  Since this inode is
> never linked to a directory, we don't need to reserve journal credits
> required for modifying the directory.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/migrate.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 4e4fcfd..480acf4 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -456,11 +456,14 @@ int ext4_ext_migrate(struct inode *inode)
>  		 */
>  		return retval;
>  
> +	/*
> +	 * Worst case we can touch the allocation bitmaps, a bgd
> +	 * block, and a block to link in the orphan list.  We do need
> +	 * need to worry about credits for modifying the quota inode.
> +	 */
>  	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE,
> -					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
> -					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
> -					+ 1);
> +		4 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
> +
>  	if (IS_ERR(handle)) {
>  		retval = PTR_ERR(handle);
>  		return retval;
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
