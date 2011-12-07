From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: replace ll_rw_block with other functions
Date: Thu, 8 Dec 2011 00:24:08 +0100
Message-ID: <20111207232408.GS4622@quack.suse.cz>
References: <1322191841-9444-1-git-send-email-wenqing.lz@taobao.com>
 <1323071711-4663-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1LGXYK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Dec 2011 18:24:10 -0500
Content-Disposition: inline
In-Reply-To: <1323071711-4663-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 05-12-11 15:55:11, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> ll_rw_block() is deprecated. Thus we replace it with other functions.
  Thanks. I've merged the patch into my tree.

								Honza
> 
> CC: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> Hi Jan,
> 
> Sorry for the delay. This patch replaces ll_rw_block() with other functions in 
> ext3. Please review it. Thank you.
> 
> Regards,
> Zheng
> 
>  fs/ext3/inode.c |   14 +++++++-------
>  fs/ext3/namei.c |    9 ++++++---
>  fs/ext3/super.c |   10 +++++-----
>  3 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 85fe655..7aff502 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1132,9 +1132,11 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
>  	bh = ext3_getblk(handle, inode, block, create, err);
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
> @@ -2064,12 +2066,10 @@ static int ext3_block_truncate_page(struct inode *inode, loff_t from)
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
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 642dc6d..337c3f3 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -921,9 +921,12 @@ restart:
>  				num++;
>  				bh = ext3_getblk(NULL, dir, b++, 0, &err);
>  				bh_use[ra_max] = bh;
> -				if (bh)
> -					ll_rw_block(READ | REQ_META | REQ_PRIO,
> -						    1, &bh);
> +				if (bh && !bh_uptodate_or_lock(bh)) {
> +					get_bh(bh);
> +					bh->b_end_io = end_buffer_read_sync;
> +					submit_bh(READ | REQ_META | REQ_PRIO,
> +						  bh);
> +				}
>  			}
>  		}
>  		if ((bh = bh_use[ra_ptr++]) == NULL)
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 922d289..d1aefe9 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2230,11 +2230,11 @@ static journal_t *ext3_get_dev_journal(struct super_block *sb,
>  		goto out_bdev;
>  	}
>  	journal->j_private = sb;
> -	ll_rw_block(READ, 1, &journal->j_sb_buffer);
> -	wait_on_buffer(journal->j_sb_buffer);
> -	if (!buffer_uptodate(journal->j_sb_buffer)) {
> -		ext3_msg(sb, KERN_ERR, "I/O error on journal device");
> -		goto out_journal;
> +	if (!bh_uptodate_or_lock(journal->j_sb_buffer)) {
> +		if (bh_submit_read(journal->j_sb_buffer)) {
> +			ext3_msg(sb, KERN_ERR, "I/O error on journal device");
> +			goto out_journal;
> +		}
>  	}
>  	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
>  		ext3_msg(sb, KERN_ERR,
> -- 
> 1.7.4.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
