From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Fri, 7 Dec 2007 09:52:12 -0600
Message-ID: <20071207095212.037ca68a@gara>
References: <20071206161045.1054bbe7@gara>
	<20071207101428.GE3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:34836 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbXLGPwj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2007 10:52:39 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB7Ep073014446
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 09:51:00 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB7FqKM0104376
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 08:52:27 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB7FqIjJ032140
	for <linux-ext4@vger.kernel.org>; Fri, 7 Dec 2007 08:52:19 -0700
In-Reply-To: <20071207101428.GE3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 7 Dec 2007 03:14:28 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Dec 06, 2007  16:10 -0600, Jose R. Santos wrote:
> > @@ -600,6 +600,7 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
> >  	struct ext4_sb_info *sbi;
> >  	int err = 0, ret;
> >  	ext4_grpblk_t group_freed;
> > +	ext4_group_t flex_group;
> >  
> >  	*pdquot_freed_blocks = 0;
> >  	sbi = EXT4_SB(sb);
> > @@ -745,6 +746,14 @@ do_more:
> >  	spin_unlock(sb_bgl_lock(sbi, block_group));
> >  	percpu_counter_add(&sbi->s_freeblocks_counter, count);
> >  
> > +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> > +	    sbi->s_groups_per_flex_shift) {
> > +		flex_group = ext4_flex_group(sbi, block_group);
> > +		spin_lock(sb_bgl_lock(sbi, flex_group));
> > +		sbi->s_flex_groups[flex_group].free_blocks += count;
> > +		spin_unlock(sb_bgl_lock(sbi, flex_group));
> > +	}
> 
> In general, I prefer to keep variables in as local a scope as possible.
> In this case, flex_group could be declared inside the "if (EXT4_HAS_INCOMPAT"
> check.

Ok.

> > +#define free_block_ratio 10
> > +
> > +int find_group_flex(struct super_block *sb, struct inode *parent)
> > +{
> > +	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) / flex_size;
> > +	best_flex = parent_fbg_group;
> > +
> > +find_close_to_parent:
> > +	flex_freeb_ratio = flex_group[best_flex].free_blocks*100/blocks_per_flex;
> 
> There is no particular reason that this ratio needs to be "*100", it could
> just as easily be a fraction of 256 and make the multiply into a shift.
> The free_block_ratio would be 26 in that case.

The idea here is to reserve 10% (free_block_ratio) of free blocks in a
flexbg for allocation of new files and expansion of existing one.  The
"*100" make the math here easy but this still something that need to be
tune further.  I'm sure we can do this in a series of shifts, just
haven't spent the time thinking of a clever way to do this.

Although, given all the multiplies, divides, endian changes that occur
while using Orlov, I'm not so concern about this right now.

> > +	for (i = 0; i < n_fbg_groups; i++) {
> > +		if (i == parent_fbg_group || i == parent_fbg_group - 1)
> > +			continue;
> 
> It seems this scans flex groups the way we used to scan groups?

No.  It does something slightly different, the scan does not start from
the parent group forward.  This help compress data as much as possible
in the disk and helps avoid large seeks.  Reclaiming as much used
groups as possible will also help uninitialized block groups by avoiding
using groups when there is perfectly good unused space at the beginning
of the disk.  Currently the search starts at the first flexbg but for
very large filesystems, this should be tune to start at a location
closer to the parents flex group.  This is another area where the patch
needs more tuning, but I was hopping people would give this patch a
try to see what deficiencies they find before going into lengthy disk
testing/tuning cycle.

> > +found_flexbg:
> > +	for (i = best_flex * flex_size; i < ngroups &&
> > +		     i < (best_flex + 1) * flex_size; i++) {
> 
> And now that we've found a suitable flex group, we need to find which
> block group therein has some free inodes...

Yes, but we treat all inode tables in a flex group as one giant table
to improve locality and reduce initialization of inode tables to
improve fsck time.

> 
> > +static int ext4_fill_flex_info(struct super_block *sb)
> > +{
> 
> It still seems desirable to have a single per-group array instead of

?
 
> > @@ -622,7 +631,9 @@ struct ext4_super_block {
> >  	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
> >  	__le64  s_mmp_block;            /* Block for multi-mount protection */
> >  	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> > -	__u32   s_reserved[163];        /* Padding to the end of the block */
> > +	__le16	s_flex_bg_size;		/* FLEX_BG group size */
> 
> Shouldn't this be "s_flex_bg_bits"?

I debated whether to store this as the s_flex_bg_size and calculate the
bits during the filesystem mount time or just stored the bit in the
super block to begging with.  The reason I stored the size is that it
seemed more in line with the other fields in the super block.  I don't
mind either way since this is more of a style issue, although saving an
extra 8bits in the super block may be good enough reason to change it. 

> > +{
> > +	return block_group >> sbi->s_groups_per_flex_shift;
> > +}
> > +
> > +static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
> > +{
> > +	return 1 << sbi->s_groups_per_flex_shift;
> > +}
> > +
> >  #define ext4_std_error(sb, errno)				\
> >  do {								\
> >  	if ((errno))						\
> 
> > diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> > --- a/lib/ext2fs/alloc_tables.c
> > +++ b/lib/ext2fs/alloc_tables.c
> > +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
> > +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) 
> > +		ext2fs_allocate_flex_groups(fs);
> > +	
> > +	else {
> > +		for (i = 0; i < fs->group_desc_count; i++) {
> > +			retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
> > +			if (retval)
> > +				return retval;
> > +		}
> >  	}
> 
> My preference would be to have "if (EXT2_HAS_INCOMPAT...) { ... } else {"
> (i.e. add { } for the first part) since there are { } on the second part,
> and it is just easier to read.

Mine too, but checkpatch complained about this. :)

> 
> > @@ -1045,6 +1046,19 @@ static void PRS(int argc, char *argv[])
> > +			if ((flex_bg_size & (flex_bg_size-1)) != 0) {
> > +				com_err(program_name, 0,
> > +					_("Flex_BG size must be a power of 2"));
> > +				exit(1);
> 
> If flex_bg_size is a power of two then there isn't any need to store anything
> except __u8 s_flex_bg_bits in the superblock.

Agree.
 
> > @@ -1444,6 +1458,10 @@ static void PRS(int argc, char *argv[])
> > +	if(flex_bg_size) {
> > +		fs_param.s_flex_bg_size = ext2fs_swab16(flex_bg_size);
> > +	}
> 
> Space between if and (, and no need for braces for a single line body.

This patch is intended for testing and need a lot of work. I still
haven't looked at any of the styling issues, but I'm surprise this is
the only one you found. :)

> It would also be nice to get a m_flexbg test case along with this patch
> that (at minimum) creates a filesystem with flexbg enabled, and then
> runs e2fsck on it.  This was broken for the lazy_bg feature for a long
> time, so it makes sense to add a test to verify each new feature has
> some basic functionality.  If the f_random_corruption test is in the
> git tree, it would be good to add the flex_bg option to the list of
> possible feature combinations to test.

Yes, it's on my todo list.  First I need to get a patch that meta-data
allocation patch that Ted is willing to put into the e2fsprog's next
branch.  After that, I will add test case for the feature.

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

Thanks

-JRS
