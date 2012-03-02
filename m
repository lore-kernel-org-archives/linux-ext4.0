From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext3: fix start and len arguments handling in
 ext3_trim_fs()
Date: Fri, 2 Mar 2012 11:52:10 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203021149430.5178@dhcp-27-109.brq.redhat.com>
References: <1330609207-11755-1-git-send-email-lczerner@redhat.com> <20120302103912.GD1744@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab2CBKwi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 05:52:38 -0500
In-Reply-To: <20120302103912.GD1744@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2 Mar 2012, Jan Kara wrote:

> On Thu 01-03-12 14:40:06, Lukas Czerner wrote:
> > The overflow might happen when passing blocknr into
> > ext3_get_group_no_and_offset(), because it expects type ext3_fsblk_t
> > which might be smaller than uint64_t. This will most likely happen when
> > calling FITRIM with the default argument len = ULLONG_MAX.
> > 
> > Fix this by using "end" variable instead of "start+len" as it is easier
> > to get right and specifically check that the end is not beyond the end
> > of the file system, so we are sure that the result of
> > get_group_no_and_offset() will not overflow. Otherwise truncate it to
> > the size of the file system.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>   Please CC me on ext3 patches. Thanks.

Sure, I forgot about that.

> 
> > ---
> >  fs/ext3/balloc.c |   73 +++++++++++++++++++++++++++--------------------------
> >  1 files changed, 37 insertions(+), 36 deletions(-)
> > 
> > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > index a203892..e3a8d9e 100644
> > --- a/fs/ext3/balloc.c
> > +++ b/fs/ext3/balloc.c
> > @@ -2091,73 +2091,74 @@ err_out:
> >   */
> >  int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >  {
> > -	ext3_grpblk_t last_block, first_block, free_blocks;
> > -	unsigned long first_group, last_group;
> > -	unsigned long group, ngroups;
> > +	ext3_grpblk_t last_block, first_block;
> > +	unsigned long group, first_group, last_group;
> >  	struct ext3_group_desc *gdp;
> >  	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
> > -	uint64_t start, len, minlen, trimmed;
> > +	uint64_t start, minlen, end, trimmed = 0;
> > +	ext3_fsblk_t first_data_blk =
> > +			le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block);
> >  	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
> >  	int ret = 0;
> >  
> > -	start = (range->start >> sb->s_blocksize_bits) +
> > -		le32_to_cpu(es->s_first_data_block);
> > -	len = range->len >> sb->s_blocksize_bits;
> > +	start = range->start >> sb->s_blocksize_bits;
> > +	end = start + (range->len >> sb->s_blocksize_bits) - 1;
> >  	minlen = range->minlen >> sb->s_blocksize_bits;
> > -	trimmed = 0;
> >  
> > -	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
> > +	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)) ||
> > +	    unlikely(start >= max_blks))
> >  		return -EINVAL;
> > -	if (start >= max_blks)
> > -		return -EINVAL;
> > -	if (start + len > max_blks)
> > -		len = max_blks - start;
> > +	if (end >= max_blks)
> > +		end = max_blks - 1;
> > +	if (end <= first_data_blk)
> > +		goto out;
> > +	if (start < first_data_blk)
> > +		start = first_data_blk;
>   Hmm, but this changed slighthly how trimming behaves with
> s_first_data_block > 0. Originally, if I submitted trim with start == 0,
> len == 1024, it would trim a single 1k block. Now it won't trim anything?
> I see ext4 does it this way as well and probably noone would notice but I
> want to have this clear...

Yes, it is changed. I wanted the ext4 and ext3 implementation to be as
close as possible.

Thanks for review.

-Lukas

> 
> > -	ngroups = EXT3_SB(sb)->s_groups_count;
> >  	smp_rmb();
> >  
> >  	/* Determine first and last group to examine based on start and len */
> >  	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) start,
> >  				     &first_group, &first_block);
> > -	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) (start + len),
> > +	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) end,
> >  				     &last_group, &last_block);
> > -	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
> > -	last_block = EXT3_BLOCKS_PER_GROUP(sb);
> >  
> > -	if (first_group > last_group)
> > -		return -EINVAL;
> > +	/* end now represents the last block to discard in this group */
> > +	end = EXT3_BLOCKS_PER_GROUP(sb) - 1;
> >  
> >  	for (group = first_group; group <= last_group; group++) {
> >  		gdp = ext3_get_group_desc(sb, group, NULL);
> >  		if (!gdp)
> >  			break;
> >  
> > -		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> > -		if (free_blocks < minlen)
> > -			continue;
> > -
> >  		/*
> >  		 * For all the groups except the last one, last block will
> > -		 * always be EXT3_BLOCKS_PER_GROUP(sb), so we only need to
> > -		 * change it for the last group in which case first_block +
> > -		 * len < EXT3_BLOCKS_PER_GROUP(sb).
> > +		 * always be EXT3_BLOCKS_PER_GROUP(sb)-1, so we only need to
> > +		 * change it for the last group, note that last_block is
> > +		 * already computed earlier by ext3_get_group_no_and_offset()
> >  		 */
> > -		if (first_block + len < EXT3_BLOCKS_PER_GROUP(sb))
> > -			last_block = first_block + len;
> > -		len -= last_block - first_block;
> > +		if (group == last_group)
> > +			end = last_block;
> >  
> > -		ret = ext3_trim_all_free(sb, group, first_block,
> > -					last_block, minlen);
> > -		if (ret < 0)
> > -			break;
> > +		if (le16_to_cpu(gdp->bg_free_blocks_count) >= minlen) {
> > +			ret = ext3_trim_all_free(sb, group, first_block,
> > +						 end, minlen);
> > +			if (ret < 0)
> > +				break;
> > +			trimmed += ret;
> > +		}
> >  
> > -		trimmed += ret;
> > +		/*
> > +		 * For every group except the first one, we are sure
> > +		 * that the first block to discard will be block #0.
> > +		 */
> >  		first_block = 0;
> >  	}
> >  
> > -	if (ret >= 0)
> > +	if (ret > 0)
> >  		ret = 0;
> > -	range->len = trimmed * sb->s_blocksize;
> >  
> > +out:
> > +	range->len = trimmed * sb->s_blocksize;
> >  	return ret;
> >  }
> > -- 
>   Otherwise the patch looks OK.
> 
> 								Honza
> 

-- 
