From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext3: Add journal error check into ext3_rename()
Date: Tue, 23 Nov 2010 13:58:50 +0100
Message-ID: <20101123125850.GF6113@quack.suse.cz>
References: <1290486633-4534-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0KWM6w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 07:58:52 -0500
Content-Disposition: inline
In-Reply-To: <1290486633-4534-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 23-11-10 13:30:33, Namhyung Kim wrote:
> Check return value of ext3_journal_get_write_access() and
> ext3_journal_dirty_metadata().
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
  Thanks. Merged.

								Honza

> ---
>  fs/ext3/namei.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 672cea1..c8415e7 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2371,7 +2371,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  			goto end_rename;
>  	} else {
>  		BUFFER_TRACE(new_bh, "get write access");
> -		ext3_journal_get_write_access(handle, new_bh);
> +		retval = ext3_journal_get_write_access(handle, new_bh);
> +		if (retval)
> +			goto journal_error;
>  		new_de->inode = cpu_to_le32(old_inode->i_ino);
>  		if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
>  					      EXT3_FEATURE_INCOMPAT_FILETYPE))
> @@ -2380,7 +2382,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  		new_dir->i_ctime = new_dir->i_mtime = CURRENT_TIME_SEC;
>  		ext3_mark_inode_dirty(handle, new_dir);
>  		BUFFER_TRACE(new_bh, "call ext3_journal_dirty_metadata");
> -		ext3_journal_dirty_metadata(handle, new_bh);
> +		retval = ext3_journal_dirty_metadata(handle, new_bh);
> +		if (retval)
> +			goto journal_error;
>  		brelse(new_bh);
>  		new_bh = NULL;
>  	}
> @@ -2429,10 +2433,17 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  	ext3_update_dx_flag(old_dir);
>  	if (dir_bh) {
>  		BUFFER_TRACE(dir_bh, "get_write_access");
> -		ext3_journal_get_write_access(handle, dir_bh);
> +		retval = ext3_journal_get_write_access(handle, dir_bh);
> +		if (retval)
> +			goto journal_error;
>  		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
>  		BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
> -		ext3_journal_dirty_metadata(handle, dir_bh);
> +		retval = ext3_journal_dirty_metadata(handle, dir_bh);
> +		if (retval) {
> +journal_error:
> +			ext3_std_error(new_dir->i_sb, retval);
> +			goto end_rename;
> +		}
>  		drop_nlink(old_dir);
>  		if (new_inode) {
>  			drop_nlink(new_inode);
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
