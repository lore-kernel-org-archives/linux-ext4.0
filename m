From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Add journal error check into ext3_rename()
Date: Mon, 22 Nov 2010 19:05:01 +0100
Message-ID: <20101122180501.GE5012@quack.suse.cz>
References: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
 <1290151716-4041-2-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53234 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0KVSFG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 13:05:06 -0500
Content-Disposition: inline
In-Reply-To: <1290151716-4041-2-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 19-11-10 16:28:36, Namhyung Kim wrote:
> Check return value of ext3_journal_get_write_access() and
> ext3_journal_dirty_metadata(). 'new_bh' should be kept in
> order to get revoked in case of journal error in dir_bh.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/namei.c |   27 +++++++++++++++++++++------
>  1 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 672cea1..8061281 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2371,7 +2371,9 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  			goto end_rename;
>  	} else {
>  		BUFFER_TRACE(new_bh, "get write access");
> -		ext3_journal_get_write_access(handle, new_bh);
> +		retval = ext3_journal_get_write_access(handle, new_bh);
> +		if (retval)
> +			goto journal_error1;
>  		new_de->inode = cpu_to_le32(old_inode->i_ino);
>  		if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
>  					      EXT3_FEATURE_INCOMPAT_FILETYPE))
> @@ -2380,9 +2382,12 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  		new_dir->i_ctime = new_dir->i_mtime = CURRENT_TIME_SEC;
>  		ext3_mark_inode_dirty(handle, new_dir);
>  		BUFFER_TRACE(new_bh, "call ext3_journal_dirty_metadata");
> -		ext3_journal_dirty_metadata(handle, new_bh);
> -		brelse(new_bh);
> -		new_bh = NULL;
> +		retval = ext3_journal_dirty_metadata(handle, new_bh);
> +		if (retval) {
> +journal_error1:
> +			ext3_std_error(new_dir->i_sb, retval);
> +			goto end_rename;
> +		}
>  	}
>  
>  	/*
> @@ -2429,10 +2434,20 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  	ext3_update_dx_flag(old_dir);
>  	if (dir_bh) {
>  		BUFFER_TRACE(dir_bh, "get_write_access");
> -		ext3_journal_get_write_access(handle, dir_bh);
> +		retval = ext3_journal_get_write_access(handle, dir_bh);
> +		if (retval)
> +			goto journal_error2;
>  		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
>  		BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
> -		ext3_journal_dirty_metadata(handle, dir_bh);
> +		retval = ext3_journal_dirty_metadata(handle, dir_bh);
> +		if (retval) {
> +journal_error2:
> +			if (new_bh)
> +				ext3_journal_revoke(handle, new_bh->b_blocknr,
> +						    new_bh);
  Uhuh, why ext3_journal_revoke()? I expect you want to cancel the changes
you possibly did to new_bh. ext3_journal_forget() is for that but even that
doesn't necessarily do what you want because it could cancel also changes
some unrelated operation did to the buffer. So the only way to really undo
the change is to set new_de->inode and new_de->file_type to original
values. Also since we already unlinked the inode from the old directory,
I'm not sure it's even beneficial to undo linking it to the new one. So I'd
just bail out as fast as we can and leave on fsck to handle the mess...

								Honza

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
