From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Add journal error check into
 ext3_delete_entry()
Date: Mon, 22 Nov 2010 18:55:41 +0100
Message-ID: <20101122175541.GD5012@quack.suse.cz>
References: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab0KVRzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 12:55:42 -0500
Content-Disposition: inline
In-Reply-To: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 19-11-10 16:28:35, Namhyung Kim wrote:
> Check return value of ext3_journal_get_write_access() and
> ext3_journal_dirty_metadata().
  Thanks, merged.

								Honza

> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/namei.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 03fccc5..672cea1 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1644,8 +1644,13 @@ static int ext3_delete_entry (handle_t *handle,
>  		if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
>  			return -EIO;
>  		if (de == de_del)  {
> +			int err;
> +
>  			BUFFER_TRACE(bh, "get_write_access");
> -			ext3_journal_get_write_access(handle, bh);
> +			err = ext3_journal_get_write_access(handle, bh);
> +			if (err)
> +				goto journal_error;
> +
>  			if (pde)
>  				pde->rec_len = ext3_rec_len_to_disk(
>  					ext3_rec_len_from_disk(pde->rec_len) +
> @@ -1654,7 +1659,12 @@ static int ext3_delete_entry (handle_t *handle,
>  				de->inode = 0;
>  			dir->i_version++;
>  			BUFFER_TRACE(bh, "call ext3_journal_dirty_metadata");
> -			ext3_journal_dirty_metadata(handle, bh);
> +			err = ext3_journal_dirty_metadata(handle, bh);
> +			if (err) {
> +journal_error:
> +				ext3_std_error(dir->i_sb, err);
> +				return err;
> +			}
>  			return 0;
>  		}
>  		i += ext3_rec_len_from_disk(de->rec_len);
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
