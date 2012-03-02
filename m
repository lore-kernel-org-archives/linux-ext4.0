From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: don't forget to discard last block in a group
Date: Fri, 2 Mar 2012 11:42:11 +0100
Message-ID: <20120302104211.GE1744@quack.suse.cz>
References: <1330609207-11755-1-git-send-email-lczerner@redhat.com>
 <1330609207-11755-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab2CBKmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 05:42:12 -0500
Content-Disposition: inline
In-Reply-To: <1330609207-11755-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-03-12 14:40:07, Lukas Czerner wrote:
> Currently we might omit to discard the last block in the group (max)
> because of off-by-one condition error. This commit fixes the condition
> so we always discard the whole range if possible.
  I think this is actually caused by your previous patch because before it,
max would be end_block+1 despite its name. So just fold this patch into the
previous one please.

								Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext3/balloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index e3a8d9e..997da27 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1970,7 +1970,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
>  	sbi = EXT3_SB(sb);
>  
>  	 /* Walk through the whole group */
> -	while (start < max) {
> +	while (start <= max) {
>  		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
>  		if (start < 0)
>  			break;
> @@ -1980,7 +1980,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
>  		 * Allocate contiguous free extents by setting bits in the
>  		 * block bitmap
>  		 */
> -		while (next < max
> +		while (next <= max
>  			&& claim_block(sb_bgl_lock(sbi, group),
>  					next, bitmap_bh)) {
>  			next++;
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
