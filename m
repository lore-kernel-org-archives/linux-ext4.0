From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix bitmap position validation
Date: Mon, 30 Apr 2018 10:24:53 +0200
Message-ID: <20180430082453.c7b6lihc6v46jyfe@rh_laptop>
References: <1524567414-19046-1-git-send-email-lczerner@redhat.com>
 <20180424154329.GB30619@thunk.org>
 <20180425073929.egtd5ucpmdn2jbs2@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180425073929.egtd5ucpmdn2jbs2@rh_laptop>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 25, 2018 at 09:39:29AM +0200, Lukas Czerner wrote:
> On Tue, Apr 24, 2018 at 11:43:30AM -0400, Theodore Y. Ts'o wrote:
> > On Tue, Apr 24, 2018 at 12:56:54PM +0200, Lukas Czerner wrote:
> > > @@ -354,8 +356,8 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
> > >  	/* check whether the inode table block number is set */
> > >  	blk = ext4_inode_table(sb, desc);
> > >  	offset = blk - group_first_block;
> > > -	if (offset < 0 || EXT4_B2C(sbi, offset) >= sb->s_blocksize ||
> > > -	    EXT4_B2C(sbi, offset + sbi->s_itb_per_group) >= sb->s_blocksize)
> > > +	if (offset < 0 || EXT4_B2C(sbi, offset + sbi->s_itb_per_group) >=
> > > +				   EXT4_CLUSTERS_PER_GROUP(sb))
> > >  		return blk;
> > >  	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
> > >  			EXT4_B2C(sbi, offset + sbi->s_itb_per_group),
> > 
> > The two checks of offset and offset + sbi->s_itb_per_group are
> > necessary because a maliciously crafted file system can take advantage
> > of unsigned integer overflow such that offset is a very large number,
> > but offset + sbi->s_itb_per_group is a legal offset.  So we have ot
> > keep both checks.  As it happens I was working on a similar patch (but
> > was slowed down by my attendance at LSF/Mm).  So I've combined your
> > patch with mine, and came up with this.
> 
> Hi Ted,
> 
> maybe I am missing something but offset is signed int, but
> s_itb_per_group is unsigned long, so if I recall the arithmetic
> conversions correctly the offset will be converted to unsigned long and
> the restult will be unsigned long.
> Moreover s_itb_per_group value is sanitized when read and can't be very
> big so the restult will always fit into unsigned long hence no overflow
> is possible. Anyway that was my thought process when I removed the
> additional check.
> 
> However it we have a maliciously created fs then
> 
> blk = ext4_inode_table(sb, desc);
> 
> might be either too big or too small and so
> 
> offset = blk - group_first_block;
> 
> might over/underflow giving us wrong offset that still by chance can land
> into the block group. So maybe we need to check that blk is within the file
> system and/or that offset does not overflow. Maybe making offset type
> ext4_fsblk_t and checking that the result satisfies (offset <= blk) will
> be enough ?
> 
> Have fun at LSF/MM :)
> 
> -Lukas

Well, so much for a discussion :-/ The patch is upstream now...

> 
> > 
> > 					- Ted
> > 
> > From 33444e3f7da8ae9840286732c0d7bbf8f9d8471b Mon Sep 17 00:00:00 2001
> > From: Lukas Czerner <lczerner@redhat.com>
> > Date: Tue, 24 Apr 2018 11:31:44 -0400
> > Subject: [PATCH] ext4: fix bitmap position validation
> > 
> > Currently in ext4_valid_block_bitmap() we expect the bitmap to be
> > positioned anywhere between 0 and s_blocksize clusters, but that's
> > wrong because the bitmap can be placed anywhere in the block group. This
> > causes false positives when validating bitmaps on perfectly valid file
> > system layouts. Fix it by checking whether the bitmap is within the group
> > boundary.
> > 
> > The problem can be reproduced using the following
> > 
> > mkfs -t ext3 -E stride=256 /dev/vdb1
> > mount /dev/vdb1 /mnt/test
> > cd /mnt/test
> > wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.3.tar.xz
> > tar xf linux-4.16.3.tar.xz
> > 
> > This will result in the warnings in the logs
> > 
> > EXT4-fs error (device vdb1): ext4_validate_block_bitmap:399: comm tar: bg 84: block 2774529: invalid block bitmap
> > 
> > [ Changed slightly for clarity and to not drop a overflow test -- TYT ]
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Reported-by: Ilya Dryomov <idryomov@gmail.com>
> > Fixes: 7dac4a1726a9 ("ext4: add validity checks for bitmap block numbers")
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/ext4/balloc.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> > index a33d8fb1bf2a..508b905d744d 100644
> > --- a/fs/ext4/balloc.c
> > +++ b/fs/ext4/balloc.c
> > @@ -321,6 +321,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
> >  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> >  	ext4_grpblk_t offset;
> >  	ext4_grpblk_t next_zero_bit;
> > +	ext4_grpblk_t max_bit = EXT4_CLUSTERS_PER_GROUP(sb);
> >  	ext4_fsblk_t blk;
> >  	ext4_fsblk_t group_first_block;
> >  
> > @@ -338,7 +339,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
> >  	/* check whether block bitmap block number is set */
> >  	blk = ext4_block_bitmap(sb, desc);
> >  	offset = blk - group_first_block;
> > -	if (offset < 0 || EXT4_B2C(sbi, offset) >= sb->s_blocksize ||
> > +	if (offset < 0 || EXT4_B2C(sbi, offset) >= max_bit ||
> >  	    !ext4_test_bit(EXT4_B2C(sbi, offset), bh->b_data))
> >  		/* bad block bitmap */
> >  		return blk;
> > @@ -346,7 +347,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
> >  	/* check whether the inode bitmap block number is set */
> >  	blk = ext4_inode_bitmap(sb, desc);
> >  	offset = blk - group_first_block;
> > -	if (offset < 0 || EXT4_B2C(sbi, offset) >= sb->s_blocksize ||
> > +	if (offset < 0 || EXT4_B2C(sbi, offset) >= max_bit ||
> >  	    !ext4_test_bit(EXT4_B2C(sbi, offset), bh->b_data))
> >  		/* bad block bitmap */
> >  		return blk;
> > @@ -354,8 +355,8 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct super_block *sb,
> >  	/* check whether the inode table block number is set */
> >  	blk = ext4_inode_table(sb, desc);
> >  	offset = blk - group_first_block;
> > -	if (offset < 0 || EXT4_B2C(sbi, offset) >= sb->s_blocksize ||
> > -	    EXT4_B2C(sbi, offset + sbi->s_itb_per_group) >= sb->s_blocksize)
> > +	if (offset < 0 || EXT4_B2C(sbi, offset) >= max_bit ||
> > +	    EXT4_B2C(sbi, offset + sbi->s_itb_per_group) >= max_bit)
> >  		return blk;
> >  	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
> >  			EXT4_B2C(sbi, offset + sbi->s_itb_per_group),
> > -- 
> > 2.16.1.72.g5be1f00a9a
> > 
