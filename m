Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729147AbeK0UZ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 15:25:56 -0500
Date: Tue, 27 Nov 2018 10:28:36 +0100
From: Jan Kara <jack@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: clean up indentation issues, remove extraneous tabs
Message-ID: <20181127092836.GD16301@quack2.suse.cz>
References: <20181123163043.14178-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181123163043.14178-1-colin.king@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-11-18 16:30:43, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are several lines that are indented too far, clean these
> up by removing the tabs.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/migrate.c | 12 ++++++------
>  fs/ext4/super.c   |  2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 61a9d1927817..5ae61cd8c5c9 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -535,22 +535,22 @@ int ext4_ext_migrate(struct inode *inode)
>  	if (i_data[EXT4_IND_BLOCK]) {
>  		retval = update_ind_extent_range(handle, tmp_inode,
>  				le32_to_cpu(i_data[EXT4_IND_BLOCK]), &lb);
> -			if (retval)
> -				goto err_out;
> +		if (retval)
> +			goto err_out;
>  	} else
>  		lb.curr_block += max_entries;
>  	if (i_data[EXT4_DIND_BLOCK]) {
>  		retval = update_dind_extent_range(handle, tmp_inode,
>  				le32_to_cpu(i_data[EXT4_DIND_BLOCK]), &lb);
> -			if (retval)
> -				goto err_out;
> +		if (retval)
> +			goto err_out;
>  	} else
>  		lb.curr_block += max_entries * max_entries;
>  	if (i_data[EXT4_TIND_BLOCK]) {
>  		retval = update_tind_extent_range(handle, tmp_inode,
>  				le32_to_cpu(i_data[EXT4_TIND_BLOCK]), &lb);
> -			if (retval)
> -				goto err_out;
> +		if (retval)
> +			goto err_out;
>  	}
>  	/*
>  	 * Build the last extent
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 5603a4a1a864..15fc71398747 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1940,7 +1940,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  #ifdef CONFIG_FS_DAX
>  		ext4_msg(sb, KERN_WARNING,
>  		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> -			sbi->s_mount_opt |= m->mount_opt;
> +		sbi->s_mount_opt |= m->mount_opt;
>  #else
>  		ext4_msg(sb, KERN_INFO, "dax option not supported");
>  		return -1;
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
