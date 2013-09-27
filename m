From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] ext4: Spot-check block group sub-table locations
Date: Fri, 27 Sep 2013 10:57:55 -0700
Message-ID: <20130927175755.GC10392@birch.djwong.org>
References: <20130927000321.17889.68250.stgit@birch.djwong.org>
 <20130927000334.17889.54958.stgit@birch.djwong.org>
 <20130927054055.GB23428@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3I0R6A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Sep 2013 13:58:00 -0400
Content-Disposition: inline
In-Reply-To: <20130927054055.GB23428@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 27, 2013 at 01:40:55PM +0800, Zheng Liu wrote:
> On Thu, Sep 26, 2013 at 05:03:34PM -0700, Darrick J. Wong wrote:
> > Perform a quick sanity check of bitmap and inode table block numbers when
> > loading them, and if there's something suspicious, mark the block group
> > corrupt.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/ext4/balloc.c |    5 +++++
> >  fs/ext4/ext4.h   |    2 ++
> >  fs/ext4/ialloc.c |    4 ++++
> >  fs/ext4/inode.c  |    6 ++++++
> >  fs/ext4/super.c  |   21 +++++++++++++++++++++
> >  5 files changed, 38 insertions(+)
> > 
> > 
> > diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> > index 4390f9f..3d79bfe 100644
> > --- a/fs/ext4/balloc.c
> > +++ b/fs/ext4/balloc.c
> > @@ -396,11 +396,16 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
> >  	struct ext4_group_desc *desc;
> >  	struct buffer_head *bh;
> >  	ext4_fsblk_t bitmap_blk;
> > +	struct ext4_group_info *grp;
> >  
> >  	desc = ext4_get_group_desc(sb, block_group, NULL);
> >  	if (!desc)
> >  		return NULL;
> >  	bitmap_blk = ext4_block_bitmap(sb, desc);
> > +	if (!ext4_is_sane_bgdata_location(sb, block_group, bitmap_blk)) {
> > +		grp = ext4_get_group_info(sb, block_group);
> > +		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
> 
> Why don't return NULL directly?  If we found that the location of bitmap
> is insane, we shouldn't read this bitmap.
> 
>                                                 - Zheng
> 
> > +	}
> >  	bh = sb_getblk(sb, bitmap_blk);
> >  	if (unlikely(!bh)) {
> >  		ext4_error(sb, "Cannot get buffer for block bitmap - "

I thought it was fine in the event of an insane blockno to fall through to this
error message.  I could make that more explicit, though.

--D

> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index af815ea..afb1bb2 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2531,6 +2531,8 @@ static inline void ext4_unlock_group(struct super_block *sb,
> >  	spin_unlock(ext4_group_lock_ptr(sb, group));
> >  }
> >  
> > +int ext4_is_sane_bgdata_location(struct super_block *sb, ext4_group_t grp,
> > +				 ext4_fsblk_t blk);
> >  /*
> >   * Block validity checking
> >   */
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 137193f..242250d 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -122,6 +122,10 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> >  		return NULL;
> >  
> >  	bitmap_blk = ext4_inode_bitmap(sb, desc);
> > +	if (!ext4_is_sane_bgdata_location(sb, block_group, bitmap_blk)) {
> > +		grp = ext4_get_group_info(sb, block_group);
> > +		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
> > +	}
> >  	bh = sb_getblk(sb, bitmap_blk);
> >  	if (unlikely(!bh)) {
> >  		ext4_error(sb, "Cannot read inode bitmap - "
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 0d424d7..c5af22e 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3795,6 +3795,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
> >  	struct super_block	*sb = inode->i_sb;
> >  	ext4_fsblk_t		block;
> >  	int			inodes_per_block, inode_offset;
> > +	struct ext4_group_info	*grp;
> >  
> >  	iloc->bh = NULL;
> >  	if (!ext4_valid_inum(sb, inode->i_ino))
> > @@ -3814,6 +3815,11 @@ static int __ext4_get_inode_loc(struct inode *inode,
> >  	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
> >  	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
> >  
> > +	if (!ext4_is_sane_bgdata_location(sb, iloc->block_group, block)) {
> > +		grp = ext4_get_group_info(sb, iloc->block_group);
> > +		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
> > +		return -EIO;
> > +	}
> >  	bh = sb_getblk(sb, block);
> >  	if (unlikely(!bh))
> >  		return -ENOMEM;
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 2c2e6cb..d22248e 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -2049,6 +2049,27 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
> >  	gdp->bg_checksum = ext4_group_desc_csum(EXT4_SB(sb), block_group, gdp);
> >  }
> >  
> > +/* returns 1 if the location of a blockgroup data item seems sane */
> > +int ext4_is_sane_bgdata_location(struct super_block *sb, ext4_group_t grp,
> > +				 ext4_fsblk_t blk)
> > +{
> > +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > +	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
> > +	ext4_fsblk_t last_block;
> > +
> > +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > +		last_block = ext4_blocks_count(sbi->s_es) - 1;
> > +	else {
> > +		first_block += grp * sbi->s_blocks_per_group;
> > +		last_block = first_block + (EXT4_BLOCKS_PER_GROUP(sb) - 1);
> > +	}
> > +
> > +	if (last_block >= ext4_blocks_count(sbi->s_es))
> > +		last_block = ext4_blocks_count(sbi->s_es) - 1;
> > +
> > +	return blk >= first_block && blk <= last_block;
> > +}
> > +
> >  /* Called at mount-time, super-block is locked */
> >  static int ext4_check_descriptors(struct super_block *sb,
> >  				  ext4_group_t *first_not_zeroed)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
