From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext3: fix start and len arguments handling in
 ext3_trim_fs()
Date: Wed, 21 Mar 2012 16:11:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203211611120.13665@dhcp-27-109.brq.redhat.com>
References: <1330690145-21464-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1203211341480.13665@dhcp-27-109.brq.redhat.com> <20120321145401.GA24330@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2CUPMJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 11:12:09 -0400
In-Reply-To: <20120321145401.GA24330@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 Mar 2012, Jan Kara wrote:

> On Wed 21-03-12 13:54:12, Lukas Czerner wrote:
> > On Fri, 2 Mar 2012, Lukas Czerner wrote:
> > 
> > > The overflow might happen when passing blocknr into
> > > ext3_get_group_no_and_offset(), because it expects type ext3_fsblk_t
> > > which might be smaller than uint64_t. This will most likely happen when
> > > calling FITRIM with the default argument len = ULLONG_MAX.
> > > 
> > > Fix this by using "end" variable instead of "start+len" as it is easier
> > > to get right and specifically check that the end is not beyond the end
> > > of the file system, so we are sure that the result of
> > > get_group_no_and_offset() will not overflow. Otherwise truncate it to
> > > the size of the file system.
> > 
> > ping
>   Hmm, maybe I forgot to send email but the patch is in my for_next branch
> and I'll send it to Linus in this merge window.
> 
> 								Honza

Thanks Honzo

-Lukas

> 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > ---
> > > v2: Squash the 'don't forget to discard last block in a group' into this one
> > >     since this is the commit which reveals the bug.
> > > 
> > >  fs/ext3/balloc.c |   77 +++++++++++++++++++++++++++--------------------------
> > >  1 files changed, 39 insertions(+), 38 deletions(-)
> > > 
> > > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > > index a203892..997da27 100644
> > > --- a/fs/ext3/balloc.c
> > > +++ b/fs/ext3/balloc.c
> > > @@ -1970,7 +1970,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
> > >  	sbi = EXT3_SB(sb);
> > >  
> > >  	 /* Walk through the whole group */
> > > -	while (start < max) {
> > > +	while (start <= max) {
> > >  		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
> > >  		if (start < 0)
> > >  			break;
> > > @@ -1980,7 +1980,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
> > >  		 * Allocate contiguous free extents by setting bits in the
> > >  		 * block bitmap
> > >  		 */
> > > -		while (next < max
> > > +		while (next <= max
> > >  			&& claim_block(sb_bgl_lock(sbi, group),
> > >  					next, bitmap_bh)) {
> > >  			next++;
> > > @@ -2091,73 +2091,74 @@ err_out:
> > >   */
> > >  int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
> > >  {
> > > -	ext3_grpblk_t last_block, first_block, free_blocks;
> > > -	unsigned long first_group, last_group;
> > > -	unsigned long group, ngroups;
> > > +	ext3_grpblk_t last_block, first_block;
> > > +	unsigned long group, first_group, last_group;
> > >  	struct ext3_group_desc *gdp;
> > >  	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
> > > -	uint64_t start, len, minlen, trimmed;
> > > +	uint64_t start, minlen, end, trimmed = 0;
> > > +	ext3_fsblk_t first_data_blk =
> > > +			le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block);
> > >  	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
> > >  	int ret = 0;
> > >  
> > > -	start = (range->start >> sb->s_blocksize_bits) +
> > > -		le32_to_cpu(es->s_first_data_block);
> > > -	len = range->len >> sb->s_blocksize_bits;
> > > +	start = range->start >> sb->s_blocksize_bits;
> > > +	end = start + (range->len >> sb->s_blocksize_bits) - 1;
> > >  	minlen = range->minlen >> sb->s_blocksize_bits;
> > > -	trimmed = 0;
> > >  
> > > -	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
> > > +	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)) ||
> > > +	    unlikely(start >= max_blks))
> > >  		return -EINVAL;
> > > -	if (start >= max_blks)
> > > -		return -EINVAL;
> > > -	if (start + len > max_blks)
> > > -		len = max_blks - start;
> > > +	if (end >= max_blks)
> > > +		end = max_blks - 1;
> > > +	if (end <= first_data_blk)
> > > +		goto out;
> > > +	if (start < first_data_blk)
> > > +		start = first_data_blk;
> > >  
> > > -	ngroups = EXT3_SB(sb)->s_groups_count;
> > >  	smp_rmb();
> > >  
> > >  	/* Determine first and last group to examine based on start and len */
> > >  	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) start,
> > >  				     &first_group, &first_block);
> > > -	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) (start + len),
> > > +	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) end,
> > >  				     &last_group, &last_block);
> > > -	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
> > > -	last_block = EXT3_BLOCKS_PER_GROUP(sb);
> > >  
> > > -	if (first_group > last_group)
> > > -		return -EINVAL;
> > > +	/* end now represents the last block to discard in this group */
> > > +	end = EXT3_BLOCKS_PER_GROUP(sb) - 1;
> > >  
> > >  	for (group = first_group; group <= last_group; group++) {
> > >  		gdp = ext3_get_group_desc(sb, group, NULL);
> > >  		if (!gdp)
> > >  			break;
> > >  
> > > -		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> > > -		if (free_blocks < minlen)
> > > -			continue;
> > > -
> > >  		/*
> > >  		 * For all the groups except the last one, last block will
> > > -		 * always be EXT3_BLOCKS_PER_GROUP(sb), so we only need to
> > > -		 * change it for the last group in which case first_block +
> > > -		 * len < EXT3_BLOCKS_PER_GROUP(sb).
> > > +		 * always be EXT3_BLOCKS_PER_GROUP(sb)-1, so we only need to
> > > +		 * change it for the last group, note that last_block is
> > > +		 * already computed earlier by ext3_get_group_no_and_offset()
> > >  		 */
> > > -		if (first_block + len < EXT3_BLOCKS_PER_GROUP(sb))
> > > -			last_block = first_block + len;
> > > -		len -= last_block - first_block;
> > > +		if (group == last_group)
> > > +			end = last_block;
> > >  
> > > -		ret = ext3_trim_all_free(sb, group, first_block,
> > > -					last_block, minlen);
> > > -		if (ret < 0)
> > > -			break;
> > > +		if (le16_to_cpu(gdp->bg_free_blocks_count) >= minlen) {
> > > +			ret = ext3_trim_all_free(sb, group, first_block,
> > > +						 end, minlen);
> > > +			if (ret < 0)
> > > +				break;
> > > +			trimmed += ret;
> > > +		}
> > >  
> > > -		trimmed += ret;
> > > +		/*
> > > +		 * For every group except the first one, we are sure
> > > +		 * that the first block to discard will be block #0.
> > > +		 */
> > >  		first_block = 0;
> > >  	}
> > >  
> > > -	if (ret >= 0)
> > > +	if (ret > 0)
> > >  		ret = 0;
> > > -	range->len = trimmed * sb->s_blocksize;
> > >  
> > > +out:
> > > +	range->len = trimmed * sb->s_blocksize;
> > >  	return ret;
> > >  }
> > > 
> > 
> > -- 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
