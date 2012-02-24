From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: fix start and len arguments handling in ext3_trim_fs()
Date: Fri, 24 Feb 2012 13:51:07 -0600
Message-ID: <4F47EA2B.9070107@redhat.com>
References: <1330101181-26067-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab2BXTvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 14:51:10 -0500
In-Reply-To: <1330101181-26067-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/24/12 10:33 AM, Lukas Czerner wrote:
> The overflow can happen when we are calling get_group_no_and_offset()
> which stores the result of do_div() in 32 bit long type. However the
> result might be bigger than that if big blocknr is passed in. This will
> most likely happen when calling FITRIM with the default argument len =
> ULLONG_MAX.

So the real problem with this commit message is that we don't even call
do_div() in ext3_get_group_no_and_offset ;)

something somewhere can surely overflow though ;) and testing against
the end of the fs early makes sense.

I'll let you fix it up the comment as you see fit.  More comments below.

> Fix this by using "end" variable instead of "start+len" as it is easier
> to get right and specifically check that the end is not beyond the end
> of the file system, so we are sure that the result of
> get_group_no_and_offset() will not overflow. Otherwise truncate it to
> the size of the file system.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext3/balloc.c |   59 +++++++++++++++++++++++++++--------------------------
>  1 files changed, 30 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index a203892..2ad59c6 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -2091,71 +2091,72 @@ err_out:
>   */
>  int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  {
> -	ext3_grpblk_t last_block, first_block, free_blocks;
> -	unsigned long first_group, last_group;
> -	unsigned long group, ngroups;
> +	ext3_grpblk_t last_block, first_block;
> +	unsigned long group, first_group, last_group;
>  	struct ext3_group_desc *gdp;
>  	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
> -	uint64_t start, len, minlen, trimmed;
> +	uint64_t start, minlen, end, trimmed = 0;
> +	ext3_fsblk_t first_data_blk =
> +			le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block);
>  	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
>  	int ret = 0;
>  
> -	start = (range->start >> sb->s_blocksize_bits) +
> -		le32_to_cpu(es->s_first_data_block);
> -	len = range->len >> sb->s_blocksize_bits;
> +	start = range->start >> sb->s_blocksize_bits;
> +	end = start + (range->len >> sb->s_blocksize_bits) - 1;
>  	minlen = range->minlen >> sb->s_blocksize_bits;
> -	trimmed = 0;
>  
> -	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))

On ext3, we will _never_ have a free range > EXT3_BLOCKS_PER_GROUP
due to metadata in each group, right?  So should we just return success
with 0 bytes trimmed for this case rather than -EINVAL?

> +	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)) ||
> +	    unlikely(start >= max_blks))

this case should be -EINVAL though, agreed.

>  		return -EINVAL;
> -	if (start >= max_blks)
> -		return -EINVAL;
> -	if (start + len > max_blks)
> -		len = max_blks - start;
> +	if (unlikely(end >= max_blks))
> +		end = max_blks - 1;

isn't len = ULLONG_MAX by default?  So maybe this shouldn't be unlikely() but *shrug*

> +	if (end <= first_data_blk)
> +		return 0;

or EINVAL?  I guess it doesn't much matter.

> +	if (start < first_data_blk)
> +		start = first_data_blk;

ok by now we might have changed start & end, with range->len left unchanged,
but we don't read it after this ... so that's ok.

> -	ngroups = EXT3_SB(sb)->s_groups_count;
>  	smp_rmb();
>  
>  	/* Determine first and last group to examine based on start and len */

...comment needs to be fixed, we don't use "len" here anymore: s/len/end/

>  	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) start,
>  				     &first_group, &first_block);
> -	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) (start + len),
> +	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) end,
>  				     &last_group, &last_block);
> -	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
> -	last_block = EXT3_BLOCKS_PER_GROUP(sb);
>  
> -	if (first_group > last_group)
> -		return -EINVAL;
> +	/* The last block to discard in the group */

	/* end now represents the last block to discard in this group */

Worth explicitly stating that "end" isn't the end of the entire trim range anymore.

> +	end = EXT3_BLOCKS_PER_GROUP(sb);
>  
>  	for (group = first_group; group <= last_group; group++) {
>  		gdp = ext3_get_group_desc(sb, group, NULL);
>  		if (!gdp)
>  			break;
>  
> -		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> -		if (free_blocks < minlen)

		/* short circuit obvious no-op groups */
> +		if (le16_to_cpu(gdp->bg_free_blocks_count) < minlen)
>  			continue;
>  
>  		/*
>  		 * For all the groups except the last one, last block will
>  		 * always be EXT3_BLOCKS_PER_GROUP(sb), so we only need to
> -		 * change it for the last group in which case first_block +
> -		 * len < EXT3_BLOCKS_PER_GROUP(sb).
> +		 * change it for the last group, note that last_block is
> +		 * already computed earlier by ext3_get_group_no_and_offset()
>  		 */
> -		if (first_block + len < EXT3_BLOCKS_PER_GROUP(sb))
> -			last_block = first_block + len;
> -		len -= last_block - first_block;
> +		if (group == last_group)
> +			end = last_block;
>  
>  		ret = ext3_trim_all_free(sb, group, first_block,
> -					last_block, minlen);
> +					 end, minlen);
>  		if (ret < 0)
>  			break;
> -
>  		trimmed += ret;
> +
> +		/*
> +		 * For every group except the first one, we are sure
> +		 * that the first block to discard will be block #0.
> +		 */
>  		first_block = 0;
>  	}
>  
> -	if (ret >= 0)
> +	if (ret > 0)
>  		ret = 0;
>  	range->len = trimmed * sb->s_blocksize;
>  

