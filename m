From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: get rid of code duplication
Date: Tue, 23 Sep 2014 11:54:37 +0200
Message-ID: <20140923095437.GC2359@quack.suse.cz>
References: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
 <1411455752-2332-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbaIWJyl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 05:54:41 -0400
Content-Disposition: inline
In-Reply-To: <1411455752-2332-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 23-09-14 11:02:31, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 65cca28..eab825f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3155,9 +3155,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  			 "start %lu, size %lu, fe_logical %lu",
>  			 (unsigned long) start, (unsigned long) size,
>  			 (unsigned long) ac->ac_o_ex.fe_logical);
> +		BUG();
>  	}
> -	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
> -			start > ac->ac_o_ex.fe_logical);
>  	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
>  
>  	/* now prepare goal request */
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
