From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: fix incorrect locking in move_extent_per_page
Date: Mon, 21 Jul 2014 21:51:02 +0200
Message-ID: <20140721195102.GC19942@quack.suse.cz>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
 <1405955089-12777-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaGUTvI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2014 15:51:08 -0400
Content-Disposition: inline
In-Reply-To: <1405955089-12777-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-07-14 19:04:49, Dmitry Monakhov wrote:
> If we have to copy data we must drop i_data_sem because of
> get_blocks() will be called inside mext_page_mkuptodate(), but later we must
> reacquire it again because we are about to change extent's tree
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/move_extent.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 2484c7e..671a74b 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -1013,10 +1013,11 @@ data_copy:
>  		*err = -EBUSY;
>  		goto unlock_pages;
>  	}
> -
> +	ext4_double_down_write_data_sem(orig_inode, donor_inode);
>  	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
>  					       orig_blk_offset,
>  					       block_len_in_page, err);
> +	ext4_double_up_write_data_sem(orig_inode, donor_inode);
>  	if (*err) {
>  		if (replaced_count) {
>  			block_len_in_page = replaced_count;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
