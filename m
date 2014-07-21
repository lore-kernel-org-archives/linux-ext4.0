From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: use correct depth value
Date: Mon, 21 Jul 2014 21:48:37 +0200
Message-ID: <20140721194837.GB19942@quack.suse.cz>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
 <1405955089-12777-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaGUTsk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2014 15:48:40 -0400
Content-Disposition: inline
In-Reply-To: <1405955089-12777-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-07-14 19:04:48, Dmitry Monakhov wrote:
> Inode's depth can be changed from here:
> ext4_ext_try_to_merge() ->ext4_ext_try_to_merge_up()
> We must use correct value.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ee93f82..6950bab 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3254,7 +3254,7 @@ out:
>  
>  fix_extent_len:
>  	ex->ee_len = orig_ex.ee_len;
> -	ext4_ext_dirty(handle, inode, path + depth);
> +	ext4_ext_dirty(handle, inode, path + path->p_depth);
>  	return err;
>  }
>  
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
