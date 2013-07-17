From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: Prevent massive fs corruption if verifying the
 block bitmap fails
Date: Wed, 17 Jul 2013 00:09:00 -0700
Message-ID: <20130717070900.GA5790@blackbox.djwong.org>
References: <20130717020209.GB5785@blackbox.djwong.org>
 <20130717030832.GB12908@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50043 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3GQHJF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jul 2013 03:09:05 -0400
Content-Disposition: inline
In-Reply-To: <20130717030832.GB12908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 16, 2013 at 11:08:32PM -0400, Theodore Ts'o wrote:
> On Tue, Jul 16, 2013 at 07:02:09PM -0700, Darrick J. Wong wrote:
> > The block bitmap verification code assumes that calling ext4_error() either
> > panics the system or makes the fs readonly.  However, this is not always true:
> > when 'errors=continue' is specified, an error is printed but we don't return
> > any indication of error to the caller, which is (probably) the block allocator,
> > which pretends that the crud we read in off the disk is a usable bitmap.  Yuck.
> > 
> > A block bitmap that fails the check should at least return no bitmap to the
> > caller.  The block allocator should be told to go look in a different group,
> > but that's a separate issue.
> > 
> > The easiest way to reproduce this is to modify bg_block_bitmap (on a ^flex_bg
> > fs) to point to a block outside the block group; or you can create a
> > metadata_csum filesystem and zero out the block bitmaps after copying files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Funny that you sent this.  I was just thinking about forward porting
> the following patch which allows us to better recover when a file
> system is mounted errors=continue, and we notice a file system
> corruption when freeing an already freed block.  We've had this in our
> tree for a while but we had never gotten around to get it upstream.
> This patch doesn't deal metadata checksum verification, but if we
> combine this patch and yours, I think it might be peanut butter and
> chocolate.  :-)

I think you're right.  The next patch I was going to write was one to teach
ext4 how to shut off dead blockgroups.  But I figured that the world might
appreciate having the "stop the bleeding" patch sooner than later, just in case
I got distracted.  Or something else blew up. :)

> One thing I like about Aditya's patch is that if we do detect a
> problem, we don't reflect an error (which in some cases with your
> patch would be the somewhat confusing errno of ENOMEM, although that's
> a pre-existing problem with the ext4_read_block_bitmap_nowait
> interface).  Instead, we just skip that block group and try to
> allocate somewhere else.

I like the idea of moving along too.  With my patch alone, mballoc will
stubbornly beat on dead block groups because it doesn't know the difference
between "not loaded" and "broken", and you can quite easily send the filesystem
into a tailspin.

I have a question though -- ext4_init_inode_bitmap (and the block bitmap
equivalent) contain code to detect a corrupt block group descriptor and "seal"
it off by setting the inode/block's free counts to zero and writing 1s to the
bitmap.  Does it make more sense to keep doing that, or to hook that up to this
EXT4_MB_GRP_CORRUPT mechanism?

(I suspect the latter but it's past midnight and I've been reading a certain
longish thread which curiously has had zero coverage on phoronix. ;))

--D

> 
> 						- Ted
> 
> commit 1298d9e3d96aedde30d0302d696a540b72f61709
> Author: Aditya Kali <adityakali@google.com>
> Date:   Fri Nov 2 13:51:35 2012 -0700
> 
>     ext4: Mark block group as corrupt on bitmap error
>     
>     When we notice a block-bitmap corruption (because of device
>     failure or something else), we should mark this group as
>     corrupt and prevent further block allocations/deallocations
>     from it. Currently, we end up generating one error message
>     for every block in the bitmap. This potentially could make
>     the system unstable as noticed in some bugs. With this patch,
>     the error will be printed only the first time and mark the
>     entire block group as corrupted. This prevents future access
>     allocations/deallocaitons from it.
>     
>     Tested: FS-Smoke test & performance presubmit test.
>     Ran 3 test(s): 3 passing, 0 flaky, 0 failing, 0 with other errors; 0 test(s) were skipped
>     Also tested by corrupting the block
>     bitmap and forcefully introducing the mb_free_blocks error:
>     (1) create a largefile (2Gb)
>     $ dd if=/dev/zero of=largefile oflag=direct bs=10485760 count=200
>     (2) umount filesystem. use dumpe2fs to see which block-bitmaps
>     are in use by largefile and note their block numbers
>     (3) use dd to zero-out the used block bitmaps
>     $ dd if=/dev/zero of=/dev/hdc4 bs=4096 seek=14 count=8 oflag=direct
>     (4) mount the FS and delete the largefile.
>     (5) recreate the largefile. verify that the new largefile does not
>     get any blocks from the groups marked as bad.
>     Without the patch, we will see mb_free_blocks error for each bit in
>     each zero'ed out bitmap at (4). With the patch, we only see the error
>     once per blockgroup:
>     [  309.706803] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 15: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
>     [  309.720824] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 14: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
>     [  309.732858] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
>     [  309.748321] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 13: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
>     [  309.760331] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
>     [  309.769695] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 12: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
>     [  309.781721] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
>     [  309.798166] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 11: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
>     [  309.810184] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
>     [  309.819532] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 10: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
>     
>     Google-Bug-Id: 7258357
>     
>     Conflicts:
>     
>     	fs/ext4/ext4.h
>     
>     Rebase-Tested-v3.3: As Tested. PerfPresubmit:
>     Ran 3 test(s): 3 passing, 0 flaky, 0 failing, 0 with other errors; 0 test(s) were skipped
>     Effort: fs/ext4
>     Origin-2.6.34-SHA1: 684e8895c7aaa742657cfc9a5204f8ccdcd8e2e4
>     Change-Id: I9aa96598386d1c964afcd97231786237e5ea4915
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ee8e4f3..12d4be3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2289,9 +2289,12 @@ struct ext4_group_info {
>  
>  #define EXT4_GROUP_INFO_NEED_INIT_BIT		0
>  #define EXT4_GROUP_INFO_WAS_TRIMMED_BIT		1
> +#define EXT4_GROUP_INFO_CORRUPT_BIT		2
>  
>  #define EXT4_MB_GRP_NEED_INIT(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
> +#define EXT4_MB_GRP_CORRUPT(grp)	\
> +	(test_bit(EXT4_GROUP_INFO_CORRUPT_BIT, &((grp)->bb_state)))
>  
>  #define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 5b8eebc..31bbe44 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -742,13 +742,15 @@ void ext4_mb_generate_buddy(struct super_block *sb,
>  
>  	if (free != grp->bb_free) {
>  		ext4_grp_locked_error(sb, group, 0, 0,
> -				      "%u clusters in bitmap, %u in gd",
> +				      "%u clusters in bitmap, %u in gd. "
> +				      "blk grp corrupted.",
>  				      free, grp->bb_free);
>  		/*
>  		 * If we intent to continue, we consider group descritor
>  		 * corrupt and update bb_free using bitmap value
>  		 */
>  		grp->bb_free = free;
> +		set_bit(EXT4_GROUP_INFO_CORRUPT_BIT, &grp->bb_state);
>  	}
>  	mb_set_largest_free_order(sb, grp);
>  
> @@ -1276,6 +1278,10 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
>  
>  	BUG_ON(first + count > (sb->s_blocksize << 3));
>  	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
> +	/* Don't bother if the block group is corrupt. */
> +	if (unlikely(EXT4_MB_GRP_CORRUPT(e4b->bd_info)))
> +		return;
> +
>  	mb_check_buddy(e4b);
>  	mb_free_blocks_double(inode, e4b, first, count);
>  
> @@ -1307,7 +1313,12 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
>  					      inode ? inode->i_ino : 0,
>  					      blocknr,
>  					      "freeing already freed block "
> -					      "(bit %u)", block);
> +					      "(bit %u). blk group corrupted.",
> +					      block);
> +			/* Mark the block group as corrupt. */
> +			set_bit(EXT4_GROUP_INFO_CORRUPT_BIT,
> +				&e4b->bd_info->bb_state);
> +			return;
>  		}
>  		mb_clear_bit(block, EXT4_MB_BITMAP(e4b));
>  		e4b->bd_info->bb_counters[order]++;
> @@ -1681,6 +1692,11 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
>  	if (err)
>  		return err;
>  
> +	if (unlikely(EXT4_MB_GRP_CORRUPT(e4b->bd_info))) {
> +		ext4_mb_unload_buddy(e4b);
> +		return 0;
> +	}
> +
>  	ext4_lock_group(ac->ac_sb, group);
>  	max = mb_find_extent(e4b, 0, ac->ac_g_ex.fe_start,
>  			     ac->ac_g_ex.fe_len, &ex);
> @@ -1872,6 +1888,9 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
>  
>  	BUG_ON(cr < 0 || cr >= 4);
>  
> +	if (unlikely(EXT4_MB_GRP_CORRUPT(grp)))
> +		return 0;
> +
>  	/* We only do this if the grp has never been initialized */
>  	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>  		int ret = ext4_mb_init_group(ac->ac_sb, group);
> @@ -4600,6 +4619,10 @@ do_more:
>  	overflow = 0;
>  	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
>  
> +	if (unlikely(EXT4_MB_GRP_CORRUPT(
> +			ext4_get_group_info(sb, block_group))))
> +		return;
> +
>  	/*
>  	 * Check to see if we are freeing blocks across a group
>  	 * boundary.
