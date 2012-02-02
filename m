From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Don't call dquot_free_block() if we don't
 update anything
Date: Thu, 2 Feb 2012 17:01:18 +0100
Message-ID: <20120202160118.GI31730@quack.suse.cz>
References: <4F2657B5.9050100@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab2BBQBV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Feb 2012 11:01:21 -0500
Content-Disposition: inline
In-Reply-To: <4F2657B5.9050100@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 30-01-12 17:41:25, Kazuya Mio wrote:
> dquot_free_block() is called in the end of ext3_new_blocks() and updates
> information of the inode structure. However, this update is not necessary
> if the number of blocks we requested is equal to the number of
> allocated blocks.
  This is obviously correct thing to do so I've merged this patch into
my tree. Thanks.

								Honza
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>  fs/ext3/balloc.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index a203892..954a7d3 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1743,8 +1743,11 @@ allocated:
>  
>  	*errp = 0;
>  	brelse(bitmap_bh);
> -	dquot_free_block(inode, *count-num);
> -	*count = num;
> +
> +	if (num < *count) {
> +		dquot_free_block(inode, *count-num);
> +		*count = num;
> +	}
>  
>  	trace_ext3_allocate_blocks(inode, goal, num,
>  				   (unsigned long long)ret_block);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
