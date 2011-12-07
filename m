From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: replace ll_rw_block with other functions
Date: Thu, 8 Dec 2011 00:20:20 +0100
Message-ID: <20111207232020.GR4622@quack.suse.cz>
References: <1322191841-9444-1-git-send-email-wenqing.lz@taobao.com>
 <1323071779-4697-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab1LGXUW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Dec 2011 18:20:22 -0500
Content-Disposition: inline
In-Reply-To: <1323071779-4697-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 05-12-11 15:56:19, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> ll_rw_block() is deprecated. Thus we replace it with other functions.
  You should have CC'd Ted Tso <tytso@mit.edu> on this one since he is the
ext4 maintainer. Otherwise the patch looks good. You can add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> CC: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/inode.c |   22 ++++++++++------------
>  fs/ext4/namei.c |    9 ++++++---
>  fs/ext4/super.c |   11 ++++++-----
>  3 files changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index fffec40..2892d52 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -697,9 +697,11 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
>  	bh = ext4_getblk(handle, inode, block, create, err);
>  	if (!bh)
>  		return bh;
> -	if (buffer_uptodate(bh))
> +	if (bh_uptodate_or_lock(bh))
>  		return bh;
> -	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
> +	get_bh(bh);
> +	bh->b_end_io = end_buffer_read_sync;
> +	submit_bh(READ | REQ_META | REQ_PRIO, bh);
>  	wait_on_buffer(bh);
>  	if (buffer_uptodate(bh))
>  		return bh;
> @@ -3301,12 +3303,10 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
>  		if (PageUptodate(page))
>  			set_buffer_uptodate(bh);
>  
> -		if (!buffer_uptodate(bh)) {
> -			err = -EIO;
> -			ll_rw_block(READ, 1, &bh);
> -			wait_on_buffer(bh);
> +		if (!bh_uptodate_or_lock(bh)) {
> +			err = bh_submit_read(bh);
>  			/* Uhhuh. Read error. Complain and punt.*/
> -			if (!buffer_uptodate(bh))
> +			if (err)
>  				goto next;
>  		}
>  
> @@ -3423,12 +3423,10 @@ int ext4_block_zero_page_range(handle_t *handle,
>  	if (PageUptodate(page))
>  		set_buffer_uptodate(bh);
>  
> -	if (!buffer_uptodate(bh)) {
> -		err = -EIO;
> -		ll_rw_block(READ, 1, &bh);
> -		wait_on_buffer(bh);
> +	if (!bh_uptodate_or_lock(bh)) {
> +		err = bh_submit_read(bh);
>  		/* Uhhuh. Read error. Complain and punt. */
> -		if (!buffer_uptodate(bh))
> +		if (err)
>  			goto unlock;
>  	}
>  
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index aa4c782..35301bc 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -921,9 +921,12 @@ restart:
>  				num++;
>  				bh = ext4_getblk(NULL, dir, b++, 0, &err);
>  				bh_use[ra_max] = bh;
> -				if (bh)
> -					ll_rw_block(READ | REQ_META | REQ_PRIO,
> -						    1, &bh);
> +				if (bh && !bh_uptodate_or_lock(bh)) {
> +					get_bh(bh);
> +					bh->b_end_io = end_buffer_read_sync;
> +					submit_bh(READ | REQ_META | REQ_PRIO,
> +							bh);
> +				}
>  			}
>  		}
>  		if ((bh = bh_use[ra_ptr++]) == NULL)
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3858767..13a3259 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4011,11 +4011,12 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
>  		goto out_bdev;
>  	}
>  	journal->j_private = sb;
> -	ll_rw_block(READ, 1, &journal->j_sb_buffer);
> -	wait_on_buffer(journal->j_sb_buffer);
> -	if (!buffer_uptodate(journal->j_sb_buffer)) {
> -		ext4_msg(sb, KERN_ERR, "I/O error on journal device");
> -		goto out_journal;
> +	if (!bh_uptodate_or_lock(journal->j_sb_buffer)) {
> +		if (bh_submit_read(journal->j_sb_buffer)) {
> +			ext4_msg(sb, KERN_ERR,
> +				"I/O error on journal device");
> +			goto out_journal;
> +		}
>  	}
>  	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
>  		ext4_msg(sb, KERN_ERR, "External journal has more than one "
> -- 
> 1.7.4.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
