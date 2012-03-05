From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4 v2] ext4: Always set then trimmed blocks count into
 len
Date: Mon, 5 Mar 2012 13:38:39 +0100
Message-ID: <20120305123839.GF6643@quack.suse.cz>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab2CEMil (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 07:38:41 -0500
Content-Disposition: inline
In-Reply-To: <1330690318-22627-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 02-03-12 13:11:57, Lukas Czerner wrote:
> Currently if the range to trim is too small, for example on 1K fs
> the request to trim the first block, then the 'range->len' is not set
> reporting wrong number of discarded block to the caller.
> 
> Fix this by always setting the 'range->len' before we return. Note that
> when there is a failure (-EINVAL) caller can not depend on 'range->len'
> being set properly.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: nothing changed
> 
>  fs/ext4/mballoc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index f20688e..8f817f2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -5092,11 +5092,11 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  		 */
>  		first_cluster = 0;
>  	}
> -	range->len = trimmed * sb->s_blocksize;
>  
>  	if (!ret)
>  		atomic_set(&EXT4_SB(sb)->s_last_trim_minblks, minlen);
>  
>  out:
> +	range->len = trimmed * sb->s_blocksize;
>  	return ret;
>  }
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
