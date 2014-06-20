From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
Date: Fri, 20 Jun 2014 13:28:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406201222310.7385@localhost.localdomain>
References: <1403192228-25771-1-git-send-email-lczerner@redhat.com> <20140619174541.GB20194@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966658AbaFTL2Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jun 2014 07:28:16 -0400
In-Reply-To: <20140619174541.GB20194@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 19 Jun 2014, Jan Kara wrote:

> Date: Thu, 19 Jun 2014 19:45:41 +0200
> From: Jan Kara <jack@suse.cz>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
> Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
> 
> On Thu 19-06-14 17:37:08, Lukas Czerner wrote:
> > Currently punch hole code on files with direct/indirect mapping has some
> > problems which may lead to a data loss. For example (from Jan Kara):
> > 
> > fallocate -n -p 10240000 4096
> > 
> > will punch the range 10240000 - 12632064 instead of the range 1024000 -
> > 10244096.
> > 
> > Also the code is a bit weird and it's not using infrastructure provided
> > by indirect.c, but rather creating it's own way.
> > 
> > This patch fixes the issues as well as making the operation to run 4
> > times faster from my testing (punching out 60GB file). It uses similar
> > approach used in ext4_ind_truncate() which takes advantage of
> > ext4_free_branches() function.
> > 
> > Also rename the ext4_free_hole_blocks() to something more sensible, like
> > the equivalent we have for extent mapped files. Call it
> > ext4_ind_remove_space().
> > 
> > This has been tested mostly with fsx and some xfstests which are testing
> > punch hole but does not require unwritten extents which are not
> > supported with direct/indirect mapping. Not problems showed up even with
> > 1024k block size.
>   Hum, so I agree current code could use more of the truncate
> infrastructure and be faster (especially the all_zeroes() checks are
> presumably rather expensive) but frankly I find your version harder to read
> than the original code was :-|.

Oh yeah, it's not easy to read as well as the rest of the code in indirect.c
:). But the idea is actually quite simple:

1. If the hole cover only direct level ... easy
2. If the hole covers multiple levels, free partial blocks on both
  sides, and the rest to the end/beginning if the level
3. If we're at the same level, free partial blocks and the rest in
  between
4. Free the interior level covering the hole

Maybe we can alter the indirect.c infrastructure a bit so it's more
convenient to use for things like punch hole, but I am not sure how
useful it'll be.

Thanks!
-Lukas


> I'll try to read your code again with fresh
> mind and either decide it's good enough that I can give my reviewed-by or
> I can try to come up with something simpler...
> 
> 								Honza
> 
> > CC: stable@vger.kernel.org
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/ext4.h     |   4 +-
> >  fs/ext4/indirect.c | 277 +++++++++++++++++++++++++++++++++++++++--------------
> >  fs/ext4/inode.c    |   2 +-
> >  3 files changed, 207 insertions(+), 76 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 1479e2a..22113a73 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2145,8 +2145,8 @@ extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
> >  extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
> >  extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
> >  extern void ext4_ind_truncate(handle_t *, struct inode *inode);
> > -extern int ext4_free_hole_blocks(handle_t *handle, struct inode *inode,
> > -				 ext4_lblk_t first, ext4_lblk_t stop);
> > +extern int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
> > +				 ext4_lblk_t start, ext4_lblk_t end);
> >  
> >  /* ioctl.c */
> >  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
> > diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> > index 594009f..adae538 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -1291,89 +1291,220 @@ do_indirects:
> >  	}
> >  }
> >  
> > -static int free_hole_blocks(handle_t *handle, struct inode *inode,
> > -			    struct buffer_head *parent_bh, __le32 *i_data,
> > -			    int level, ext4_lblk_t first,
> > -			    ext4_lblk_t count, int max)
> > +/**
> > + *	ext4_ind_remove_space - remove space from the range
> > + *	@handle: JBD handle for this transaction
> > + *	@inode:	inode we are dealing with
> > + *	@start:	First block to remove
> > + *	@end:	One block after the last block to remove (exclusive)
> > + *
> > + *	Free the blocks in the defined range (end is exclusive endpoint of
> > + *	range). This is used by ext4_punch_hole().
> > + */
> > +int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
> > +			  ext4_lblk_t start, ext4_lblk_t end)
> >  {
> > -	struct buffer_head *bh = NULL;
> > +	struct ext4_inode_info *ei = EXT4_I(inode);
> > +	__le32 *i_data = ei->i_data;
> >  	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> > -	int ret = 0;
> > -	int i, inc;
> > -	ext4_lblk_t offset;
> > -	__le32 blk;
> > -
> > -	inc = 1 << ((EXT4_BLOCK_SIZE_BITS(inode->i_sb) - 2) * level);
> > -	for (i = 0, offset = 0; i < max; i++, i_data++, offset += inc) {
> > -		if (offset >= count + first)
> > -			break;
> > -		if (*i_data == 0 || (offset + inc) <= first)
> > -			continue;
> > -		blk = *i_data;
> > -		if (level > 0) {
> > -			ext4_lblk_t first2;
> > -			bh = sb_bread(inode->i_sb, le32_to_cpu(blk));
> > -			if (!bh) {
> > -				EXT4_ERROR_INODE_BLOCK(inode, le32_to_cpu(blk),
> > -						       "Read failure");
> > -				return -EIO;
> > +	ext4_lblk_t offsets[4], offsets2[4];
> > +	Indirect chain[4], chain2[4];
> > +	Indirect *partial, *partial2;
> > +	ext4_lblk_t max_block;
> > +	__le32 nr = 0, nr2 = 0;
> > +	int n = 0, n2 = 0;
> > +	unsigned blocksize = inode->i_sb->s_blocksize;
> > +
> > +	max_block = (EXT4_SB(inode->i_sb)->s_bitmap_maxbytes + blocksize-1)
> > +					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
> > +	if (end >= max_block)
> > +		end = max_block;
> > +	if ((start >= end) || (start > max_block))
> > +		return 0;
> > +
> > +	n = ext4_block_to_path(inode, start, offsets, NULL);
> > +	n2 = ext4_block_to_path(inode, end, offsets2, NULL);
> > +
> > +	BUG_ON(n > n2);
> > +
> > +	if ((n == 1) && (n == n2)) {
> > +		/* We're punching only within direct block range */
> > +		ext4_free_data(handle, inode, NULL, i_data + offsets[0],
> > +			       i_data + offsets2[0]);
> > +		return 0;
> > +	} else if (n2 > n) {
> > +		/*
> > +		 * Start and end are on a different levels so we're going to
> > +		 * free partial block at start, and partial block at end of
> > +		 * the range. If there are some levels in between then
> > +		 * do_indirects label will take care of that.
> > +		 */
> > +
> > +		if (n == 1) {
> > +			/*
> > +			 * Start is at the direct block level, free
> > +			 * everything to the end of the level.
> > +			 */
> > +			ext4_free_data(handle, inode, NULL, i_data + offsets[0],
> > +				       i_data + EXT4_NDIR_BLOCKS);
> > +			goto end_range;
> > +		}
> > +
> > +
> > +		partial = ext4_find_shared(inode, n, offsets, chain, &nr);
> > +		if (nr) {
> > +			if (partial == chain) {
> > +				/* Shared branch grows from the inode */
> > +				ext4_free_branches(handle, inode, NULL,
> > +					   &nr, &nr+1, (chain+n-1) - partial);
> > +				*partial->p = 0;
> > +			} else {
> > +				/* Shared branch grows from an indirect block */
> > +				BUFFER_TRACE(partial->bh, "get_write_access");
> > +				ext4_free_branches(handle, inode, partial->bh,
> > +					partial->p,
> > +					partial->p+1, (chain+n-1) - partial);
> >  			}
> > -			first2 = (first > offset) ? first - offset : 0;
> > -			ret = free_hole_blocks(handle, inode, bh,
> > -					       (__le32 *)bh->b_data, level - 1,
> > -					       first2, count - offset,
> > -					       inode->i_sb->s_blocksize >> 2);
> > -			if (ret) {
> > -				brelse(bh);
> > -				goto err;
> > +		}
> > +
> > +		/*
> > +		 * Clear the ends of indirect blocks on the shared branch
> > +		 * at the start of the range
> > +		 */
> > +		while (partial > chain) {
> > +			ext4_free_branches(handle, inode, partial->bh,
> > +				partial->p + 1,
> > +				(__le32 *)partial->bh->b_data+addr_per_block,
> > +				(chain+n-1) - partial);
> > +			BUFFER_TRACE(partial->bh, "call brelse");
> > +			brelse(partial->bh);
> > +			partial--;
> > +		}
> > +
> > +end_range:
> > +		partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
> > +		if (nr2) {
> > +			if (partial2 == chain2) {
> > +				/*
> > +				 * Remember, end is exclusive so here we're at
> > +				 * the start of the next level we're not going
> > +				 * to free. Everything was covered by the start
> > +				 * of the range.
> > +				 */
> > +				return 0;
> > +			} else {
> > +				/* Shared branch grows from an indirect block */
> > +				partial2--;
> >  			}
> > +		} else {
> > +			/*
> > +			 * ext4_find_shared returns Indirect structure which
> > +			 * points to the last element which should not be
> > +			 * removed by truncate. But this is end of the range
> > +			 * in punch_hole so we need to point to the next element
> > +			 */
> > +			partial2->p++;
> >  		}
> > -		if (level == 0 ||
> > -		    (bh && all_zeroes((__le32 *)bh->b_data,
> > -				      (__le32 *)bh->b_data + addr_per_block))) {
> > -			ext4_free_data(handle, inode, parent_bh, &blk, &blk+1);
> > -			*i_data = 0;
> > +
> > +		/*
> > +		 * Clear the ends of indirect blocks on the shared branch
> > +		 * at the end of the range
> > +		 */
> > +		while (partial2 > chain2) {
> > +			ext4_free_branches(handle, inode, partial2->bh,
> > +					   (__le32 *)partial2->bh->b_data,
> > +					   partial2->p,
> > +					   (chain2+n2-1) - partial2);
> > +			BUFFER_TRACE(partial2->bh, "call brelse");
> > +			brelse(partial2->bh);
> > +			partial2--;
> >  		}
> > -		brelse(bh);
> > -		bh = NULL;
> > +		goto do_indirects;
> >  	}
> >  
> > -err:
> > -	return ret;
> > -}
> > -
> > -int ext4_free_hole_blocks(handle_t *handle, struct inode *inode,
> > -			  ext4_lblk_t first, ext4_lblk_t stop)
> > -{
> > -	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> > -	int level, ret = 0;
> > -	int num = EXT4_NDIR_BLOCKS;
> > -	ext4_lblk_t count, max = EXT4_NDIR_BLOCKS;
> > -	__le32 *i_data = EXT4_I(inode)->i_data;
> > -
> > -	count = stop - first;
> > -	for (level = 0; level < 4; level++, max *= addr_per_block) {
> > -		if (first < max) {
> > -			ret = free_hole_blocks(handle, inode, NULL, i_data,
> > -					       level, first, count, num);
> > -			if (ret)
> > -				goto err;
> > -			if (count > max - first)
> > -				count -= max - first;
> > -			else
> > -				break;
> > -			first = 0;
> > -		} else {
> > -			first -= max;
> > +	/* Punch happened within the same level (n == n2) */
> > +	partial = ext4_find_shared(inode, n, offsets, chain, &nr);
> > +	partial2 = ext4_find_shared(inode, n2, offsets2, chain2, &nr2);
> > +	/*
> > +	 * ext4_find_shared returns Indirect structure which
> > +	 * points to the last element which should not be
> > +	 * removed by truncate. But this is end of the range
> > +	 * in punch_hole so we need to point to the next element
> > +	 */
> > +	partial2->p++;
> > +	while ((partial > chain) || (partial2 > chain2)) {
> > +		/* We're at the same block, so we're almost finished */
> > +		if ((partial->bh && partial2->bh) &&
> > +		    (partial->bh->b_blocknr == partial2->bh->b_blocknr)) {
> > +			if ((partial > chain) && (partial2 > chain2)) {
> > +				ext4_free_branches(handle, inode, partial->bh,
> > +						   partial->p + 1,
> > +						   partial2->p,
> > +						   (chain+n-1) - partial);
> > +				BUFFER_TRACE(partial->bh, "call brelse");
> > +				brelse(partial->bh);
> > +				BUFFER_TRACE(partial2->bh, "call brelse");
> > +				brelse(partial2->bh);
> > +			}
> > +			return 0;
> >  		}
> > -		i_data += num;
> > -		if (level == 0) {
> > -			num = 1;
> > -			max = 1;
> > +		/*
> > +		 * Clear the ends of indirect blocks on the shared branch
> > +		 * at the start of the range
> > +		 */
> > +		if (partial > chain) {
> > +			ext4_free_branches(handle, inode, partial->bh,
> > +				   partial->p + 1,
> > +				   (__le32 *)partial->bh->b_data+addr_per_block,
> > +				   (chain+n-1) - partial);
> > +			BUFFER_TRACE(partial->bh, "call brelse");
> > +			brelse(partial->bh);
> > +			partial--;
> > +		}
> > +		/*
> > +		 * Clear the ends of indirect blocks on the shared branch
> > +		 * at the end of the range
> > +		 */
> > +		if (partial2 > chain2) {
> > +			ext4_free_branches(handle, inode, partial2->bh,
> > +					   (__le32 *)partial2->bh->b_data,
> > +					   partial2->p,
> > +					   (chain2+n-1) - partial2);
> > +			BUFFER_TRACE(partial2->bh, "call brelse");
> > +			brelse(partial2->bh);
> > +			partial2--;
> >  		}
> >  	}
> >  
> > -err:
> > -	return ret;
> > +do_indirects:
> > +	/* Kill the remaining (whole) subtrees */
> > +	switch (offsets[0]) {
> > +	default:
> > +		if (++n >= n2)
> > +			return 0;
> > +		nr = i_data[EXT4_IND_BLOCK];
> > +		if (nr) {
> > +			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
> > +			i_data[EXT4_IND_BLOCK] = 0;
> > +		}
> > +	case EXT4_IND_BLOCK:
> > +		if (++n >= n2)
> > +			return 0;
> > +		nr = i_data[EXT4_DIND_BLOCK];
> > +		if (nr) {
> > +			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
> > +			i_data[EXT4_DIND_BLOCK] = 0;
> > +		}
> > +	case EXT4_DIND_BLOCK:
> > +		if (++n >= n2)
> > +			return 0;
> > +		nr = i_data[EXT4_TIND_BLOCK];
> > +		if (nr) {
> > +			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
> > +			i_data[EXT4_TIND_BLOCK] = 0;
> > +		}
> > +	case EXT4_TIND_BLOCK:
> > +		;
> > +	}
> > +	return 0;
> >  }
> > -
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 7fcd68e..a5adc09 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3626,7 +3626,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
> >  		ret = ext4_ext_remove_space(inode, first_block,
> >  					    stop_block - 1);
> >  	else
> > -		ret = ext4_free_hole_blocks(handle, inode, first_block,
> > +		ret = ext4_ind_remove_space(handle, inode, first_block,
> >  					    stop_block);
> >  
> >  	up_write(&EXT4_I(inode)->i_data_sem);
> > -- 
> > 1.8.3.1
> > 
> 
