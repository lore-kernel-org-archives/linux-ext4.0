From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] Add macro to enable collecting bitmap statistics
Date: Fri, 18 Mar 2011 11:23:10 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103181113130.4087@dhcp-27-109.brq.redhat.com>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com> <1300387821-21705-5-git-send-email-lczerner@redhat.com> <F0C2C526-39CC-4832-A418-9028996B9CEE@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab1CRKXS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2011 06:23:18 -0400
In-Reply-To: <F0C2C526-39CC-4832-A418-9028996B9CEE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Mar 2011, Andreas Dilger wrote:

> On 2011-03-17, at 12:50 PM, Lukas Czerner wrote:
> > This commit adds a new preprocessor macro BMAP_STATS, which can be
> > defined in ext2fs.h. Setting this macro, the code for statistic
> > collection of bitmap handling is enabled and once the bitmap shall be
> > freed collected information is printed to the stderr.
> > 
> > This feature is especially useful for better understanding how e2fsprogs
> > tools (mainly e2fsck) treats bitmaps and what bitmap backend can be most
> > suitable for particular bitmap. Backend itself (if implemented) can
> > provide statistics of its own as well.
> > 
> > I was thinking about enabling this feature simply by setting program
> > parameter, however collecting of the statistic, even conditional, means
> > unnecessary overhead. And since information provided is usually relevant
> > only for e2fsprogs developers, I decided to use preprocessor macro
> > instead.
> 
> Being able to turn this on/off at runtime without needing to recompile is pretty important.  It is fine to allow it to be #ifdef out entirely, but if it is enabled it is good to be able to turn it on/off via the command-line.

The downside of this is that bitmaps are used by many tools, so it would
require change in all of those tools to use command-line option.

> 
> > @@ -245,8 +260,8 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
> > 
> > 	retval = bitmap->bitmap_ops->new_bmap(fs, bitmap);
> > 	if (retval) {
> > -		ext2fs_free_mem(&bitmap);
> > 		ext2fs_free_mem(&bitmap->description);
> > +		ext2fs_free_mem(&bitmap);
> 
> This looks like a bug in the upstream code that should be submitted separately.  However, I don't see this bug in my tree (it is correctly ordered already), and I don't see it being introduced by your patches...  It again makes me wonder which branch these patches are against.

I can see this bug in master branch
git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

so I'll send it separately.

> 
> > +	fprintf(stderr, "\n[+] %s bitmap\n", bmap_defs[stats->type].descr);
> > +	fprintf(stderr, "=================================================\n");
> > +	fprintf(stderr, "%16d type\n%16d backend\n",
> > +		stats->type, bmap_defs[stats->type].backend);
> > +	fprintf(stderr, "%16d bits long\n",
> > +		bitmap->real_end - bitmap->start);
> > +	fprintf(stderr, "%16lu copy_bmap\n%16lu resize_bmap\n",
> > +		stats->copy_count, stats->resize_count);
> > +	fprintf(stderr, "%16lu mark bmap\n%16lu unmark_bmap\n",
> > +		stats->mark_count, stats->unmark_count);
> > +	fprintf(stderr, "%16lu test_bmap\n%16lu mark_bmap_extent\n",
> > +		stats->test_count, stats->mark_ext_count);
> > +	fprintf(stderr, "%16lu unmark_bmap_extent\n"
> > +		"%16lu test_clear_bmap_extent\n",
> > +		stats->unmark_ext_count, stats->test_ext_count);
> > +	fprintf(stderr, "%16lu set_bmap_range\n%16lu set_bmap_range\n",
> > +		stats->set_range_count, stats->get_range_count);
> > +	fprintf(stderr, "%16lu clear_bmap\n%16lu contiguous bit test (%.2f%)\n",
> > +		stats->clear_count, stats->test_seq, test_seq_perc);
> > +	fprintf(stderr, "%16lu contiguous bit mark (%.2f%)\n"
> > +		"%16lu bits tested backwards (%.2f%)\n",
> > +		stats->mark_seq, mark_seq_perc,
> > +		stats->test_back, test_back_perc);
> > +	fprintf(stderr, "%16lu bits marked backwards (%.2f%)\n"
> > +		"%16.2f seconds in use\n",
> > +		stats->mark_back, mark_back_perc, inuse);
> > +}
> 
> This should include the amount of memory used by the bitmap, which is one of the most important stats for this code.

Yes, it is the most important, however at this level we can not know
this kind of bitmap backend specific information. That's why there is
new bitmap operation print_stats() which is called right after
ext2fs_print_bmap_statistics() and should provide additional bitmap
backed specific information. Rbtree and bitarray does that with this
commit.

> 
> > +#endif
> > +
> > void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
> > {
> > 	if (!bmap)
> > @@ -267,6 +338,16 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return;
> > 
> > +#ifdef BMAP_STATS
> > +	if (gettimeofday(&bmap->stats.destroyed,
> > +			 (struct timezone *) NULL) == -1) {
> > +		perror("gettimeofday");
> > +		return;
> > +	}
> > +	ext2fs_print_bmap_statistics(bmap);
> > +	bmap->bitmap_ops->print_stats(bmap);
> > +#endif
> > +
> > 	bmap->bitmap_ops->free_bmap(bmap);
> > 
> > 	if (bmap->description) {
> > @@ -300,6 +381,17 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
> > 		return retval;
> > 	memset(new_bmap, 0, sizeof(struct ext2fs_struct_generic_bitmap));
> > 
> > +
> > +#ifdef BMAP_STATS
> > +	src->stats.copy_count++;
> > +	if (gettimeofday(&new_bmap->stats.created,
> > +			 (struct timezone *) NULL) == -1) {
> > +		perror("gettimeofday");
> > +		return 1;
> > +	}
> > +	new_bmap->stats.type = src->stats.type;
> > +#endif
> > +
> > 	/* Copy all the high-level parts over */
> > 	new_bmap->magic = src->magic;
> > 	new_bmap->fs = src->fs;
> > @@ -346,6 +438,8 @@ errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap bmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return EINVAL;
> > 
> > +	INC_STAT(bmap, resize_count);
> > +
> > 	return bmap->bitmap_ops->resize_bmap(bmap, new_end, new_real_end);
> > }
> > 
> > @@ -432,6 +526,15 @@ int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap bitmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bitmap))
> > 		return 0;
> > 
> > +#ifdef BMAP_STATS
> > +	if (arg == bitmap->stats.last_marked + 1)
> > +		bitmap->stats.mark_seq++;
> > +	if (arg < bitmap->stats.last_marked)
> > +		bitmap->stats.mark_back++;
> > +	bitmap->stats.last_marked = arg;
> > +	bitmap->stats.mark_count++;
> > +#endif
> > +
> > 	if ((arg < bitmap->start) || (arg > bitmap->end)) {
> > 		warn_bitmap(bitmap, EXT2FS_MARK_ERROR, arg);
> > 		return 0;
> > @@ -458,6 +561,8 @@ int ext2fs_unmark_generic_bmap(ext2fs_generic_bitmap bitmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bitmap))
> > 		return 0;
> > 
> > +	INC_STAT(bitmap, unmark_count);
> > +
> > 	if ((arg < bitmap->start) || (arg > bitmap->end)) {
> > 		warn_bitmap(bitmap, EXT2FS_UNMARK_ERROR, arg);
> > 		return 0;
> > @@ -484,6 +589,15 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap bitmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bitmap))
> > 		return 0;
> > 
> > +#ifdef BMAP_STATS
> > +	bitmap->stats.test_count++;
> > +	if (arg == bitmap->stats.last_tested + 1)
> > +		bitmap->stats.test_seq++;
> > +	if (arg < bitmap->stats.last_tested)
> > +		bitmap->stats.test_back++;
> > +	bitmap->stats.last_tested = arg;
> > +#endif
> > +
> > 	if ((arg < bitmap->start) || (arg > bitmap->end)) {
> > 		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, arg);
> > 		return 0;
> > @@ -512,6 +626,8 @@ errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap bmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return EINVAL;
> > 
> > +	INC_STAT(bmap, set_range_count);
> > +
> > 	return bmap->bitmap_ops->set_bmap_range(bmap, start, num, in);
> > }
> > 
> > @@ -535,6 +651,8 @@ errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap bmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return EINVAL;
> > 
> > +	INC_STAT(bmap, get_range_count);
> > +
> > 	return bmap->bitmap_ops->get_bmap_range(bmap, start, num, out);
> > }
> > 
> > @@ -606,6 +724,8 @@ int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap bmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return EINVAL;
> > 
> > +	INC_STAT(bmap, test_ext_count);
> > +
> > 	return bmap->bitmap_ops->test_clear_bmap_extent(bmap, block, num);
> > }
> > 
> > @@ -628,6 +748,8 @@ void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return;
> > 
> > +	INC_STAT(bmap, mark_ext_count);
> > +
> > 	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
> > 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_MARK, block,
> > 				   bmap->description);
> > @@ -656,6 +778,8 @@ void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bmap,
> > 	if (!EXT2FS_IS_64_BITMAP(bmap))
> > 		return;
> > 
> > +	INC_STAT(bmap, unmark_ext_count);
> > +
> > 	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
> > 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_UNMARK, block,
> > 				   bmap->description);
> > -- 
> > 1.7.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 

Thanks!
-Lukas
