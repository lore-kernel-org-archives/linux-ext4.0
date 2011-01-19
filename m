From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext3: fix trim length underflow with small trim
 length.
Date: Wed, 19 Jan 2011 11:42:50 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101191125120.2686@dhcp-lab-213.englab.brq.redhat.com>
References: <1295430550-8978-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1ASKm4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jan 2011 05:42:56 -0500
In-Reply-To: <1295430550-8978-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 19 Jan 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> We adjust 'len' with s_first_data_block - start in case of start is less
> than s_first_data_block, but it could underflow in case blocksize=1K, while
> fstrim_range.len=512 and fstrim_range.start = 0. In this case len happens
> to be underflow and in the end, although we are safe that last_group check
> will limit the trim to the whole volume, I am afraid that isn't what the user
> really want.
> 
> So this patch fix it. It also adds a new variable s_first_data_block so that
> the 4 le32_to_cpu can be replaced with 1.

Well, I just realized that what are we doing is not exactly what will
user expect. User does not really care where the first data block is.
What the user will expect is, to trim let's say first one gigabyte
of his filesystem, not gigabyte - first data block.

So what I suggest is to always add first_data_block to
fstrim_range.start and do all the necessary checks for overflow. If no
one has any objections I'll put it to the patch.

Thanks!
-Lukas

> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext3/balloc.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 045995c..ee7e0f3 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -2088,6 +2088,7 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
>  	uint64_t start, len, minlen, trimmed;
>  	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
> +	ext3_fsblk_t first_data_block = le32_to_cpu(es->s_first_data_block);
>  	int ret = 0;
>  
>  	start = range->start >> sb->s_blocksize_bits;
> @@ -2097,11 +2098,11 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  
>  	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
>  		return -EINVAL;
> -	if (start >= max_blks)
> +	if (start >= max_blks || start + len <= first_data_block)
>  		goto out;
> -	if (start < le32_to_cpu(es->s_first_data_block)) {
> -		len -= le32_to_cpu(es->s_first_data_block) - start;
> -		start = le32_to_cpu(es->s_first_data_block);
> +	if (start < first_data_block) {
> +		len -= first_data_block - start;
> +		start = first_data_block;
>  	}
>  	if (start + len > max_blks)
>  		len = max_blks - start;
> 

-- 
