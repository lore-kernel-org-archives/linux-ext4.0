From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Avoid issuing unnecessary barriers
Date: Mon, 16 Nov 2009 11:29:10 +0100
Message-ID: <20091116102910.GA23231@duck.suse.cz>
References: <20091116004757.GN4323@mit.edu> <1258339242-2028-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZKPK3H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 05:29:07 -0500
Content-Disposition: inline
In-Reply-To: <1258339242-2028-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 15-11-09 21:40:42, Theodore Ts'o wrote:
> We don't to issue an I/O barrier on an error or if we force commit
> because we are doing data journaling.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> ---
> This patch should be equivalent to Jan's "ext4: Avoid issuing barriers
> on error recovery path", but it removes more lines than it adds.  :-)
  Yeah, it looks fine. Acked-by: Jan Kara <jack@suse.cz>

									Honza
> 
>  fs/ext4/fsync.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 2b15312..a3c2507 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -60,7 +60,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
>  
>  	ret = flush_aio_dio_completed_IO(inode);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  	/*
>  	 * data=writeback:
>  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> @@ -79,10 +79,8 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
>  	 *  (they were dirtied by commit).  But that's OK - the blocks are
>  	 *  safe in-journal, which is all fsync() needs to ensure.
>  	 */
> -	if (ext4_should_journal_data(inode)) {
> -		ret = ext4_force_commit(inode->i_sb);
> -		goto out;
> -	}
> +	if (ext4_should_journal_data(inode))
> +		return ext4_force_commit(inode->i_sb);
>  
>  	if (!journal)
>  		ret = sync_mapping_buffers(inode->i_mapping);
> -- 
> 1.6.5.216.g5288a.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
