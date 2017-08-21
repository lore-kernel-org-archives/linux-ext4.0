From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: cleanup goto next group
Date: Mon, 21 Aug 2017 09:58:31 +0200
Message-ID: <20170821075831.GA20202@quack2.suse.cz>
References: <20170820115325.57015-1-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
        wshilong@ddn.com
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751916AbdHUH6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Aug 2017 03:58:33 -0400
Content-Disposition: inline
In-Reply-To: <20170820115325.57015-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 20-08-17 19:53:25, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> avoid duplicated codes, also we need goto
> next group in case we found reserved inode.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ialloc.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 0d03e73..9e6eb1c 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -892,19 +892,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  		/*
>  		 * Check free inodes count before loading bitmap.
>  		 */
> -		if (ext4_free_inodes_count(sb, gdp) == 0) {
> -			if (++group == ngroups)
> -				group = 0;
> -			continue;
> -		}
> +		if (ext4_free_inodes_count(sb, gdp) == 0)
> +			goto next_group;
>  
>  		grp = ext4_get_group_info(sb, group);
>  		/* Skip groups with already-known suspicious inode tables */
> -		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
> -			if (++group == ngroups)
> -				group = 0;
> -			continue;
> -		}
> +		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
> +			goto next_group;
>  
>  		brelse(inode_bitmap_bh);
>  		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
> @@ -912,9 +906,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp) ||
>  		    IS_ERR(inode_bitmap_bh)) {
>  			inode_bitmap_bh = NULL;
> -			if (++group == ngroups)
> -				group = 0;
> -			continue;
> +			goto next_group;
>  		}
>  
>  repeat_in_this_group:
> @@ -926,7 +918,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
>  			ext4_error(sb, "reserved inode found cleared - "
>  				   "inode=%lu", ino + 1);
> -			continue;
> +			goto next_group;
>  		}
>  		if ((EXT4_SB(sb)->s_journal == NULL) &&
>  		    recently_deleted(sb, group, ino)) {
> -- 
> 2.9.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
