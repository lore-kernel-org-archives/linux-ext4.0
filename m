From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext3: Adjust trim start with first_data_block.
Date: Fri, 21 Jan 2011 16:00:01 +0100
Message-ID: <20110121150001.GD5302@quack.suse.cz>
References: <20110119113921.GA4246@quack.suse.cz>
 <1295578376-3914-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46385 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1AUPAD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 10:00:03 -0500
Content-Disposition: inline
In-Reply-To: <1295578376-3914-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 21-01-11 10:52:56, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> As we have make the consense in the e-mail[1], the trim start should
> be added with first_data_block. So this patch fulfill it and remove
> the check for start < first_data_block.
> 
> [1] http://www.spinics.net/lists/linux-ext4/msg22737.html
  Thanks. Merged.

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext3/balloc.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 971e1bd..13bfebe 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -2091,7 +2091,8 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
>  	int ret = 0;
>  
> -	start = range->start >> sb->s_blocksize_bits;
> +	start = (range->start >> sb->s_blocksize_bits) +
> +		le32_to_cpu(es->s_first_data_block);
>  	len = range->len >> sb->s_blocksize_bits;
>  	minlen = range->minlen >> sb->s_blocksize_bits;
>  	trimmed = 0;
> @@ -2100,10 +2101,6 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  		return -EINVAL;
>  	if (start >= max_blks)
>  		goto out;
> -	if (start < le32_to_cpu(es->s_first_data_block)) {
> -		len -= le32_to_cpu(es->s_first_data_block) - start;
> -		start = le32_to_cpu(es->s_first_data_block);
> -	}
>  	if (start + len > max_blks)
>  		len = max_blks - start;
>  
> -- 
> 1.6.3.GIT
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
