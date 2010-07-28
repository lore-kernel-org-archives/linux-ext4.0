From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] Add batched discard support for ext3
Date: Wed, 28 Jul 2010 11:13:40 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007281108160.3033@localhost>
References: <1280234514-10287-1-git-send-email-lczerner@redhat.com> <1280234514-10287-3-git-send-email-lczerner@redhat.com> <20100727154346.GB6820@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0G1JNs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jul 2010 05:13:48 -0400
In-Reply-To: <20100727154346.GB6820@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 27 Jul 2010, Jan Kara wrote:

> On Tue 27-07-10 14:41:53, Lukas Czerner wrote:
> > Walk through each allocation group and trim all free extents. It can be
> > invoked through TRIM ioctl on the file system. The main idea is to
> > provide a way to trim the whole file system if needed, since some SSD's
> > may suffer from performance loss after the whole device was filled (it
> > does not mean that fs is full!).
> > 
> > It search for free extents in each allocation group. When the free
> > extent is found, blocks are marked as used and then trimmed. Afterwards
> > these blocks are marked as free in per-group bitmap.
>   Thanks for the patch. It looks much better than the previous one. Some
> comments below.
> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext3/balloc.c        |  229 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ext3/super.c         |    1 +
> >  include/linux/ext3_fs.h |    1 +
> >  3 files changed, 231 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > index a177122..97c6867 100644
> > --- a/fs/ext3/balloc.c
> > +++ b/fs/ext3/balloc.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/ext3_jbd.h>
> >  #include <linux/quotaops.h>
> >  #include <linux/buffer_head.h>
> > +#include <linux/blkdev.h>
> >  
> >  /*
> >   * balloc.c contains the blocks allocation and deallocation routines
> > @@ -1876,3 +1877,231 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
> >  	return ext3_bg_num_gdb_meta(sb,group);
> >  
> >  }
> > +
> > +/**
> > + * ext3_trim_all_free -- function to trim all free space in alloc. group
> > + * @sb:			super block for file system
> > + * @group:		allocation group to trim
> > + * @gdp:		allocation group description structure
> > + * @minblocks:		minimum extent block count
> > + *
> > + * ext3_trim_all_free walks through group's block bitmap searching for free
> > + * blocks. When the free block is found, it tries to allocate this block and
> > + * consequent free block to get the biggest free extent possible, until it
> > + * reaches any used block. Then issue a TRIM command on this extent and free
> > + * the extent in the block bitmap. This is done until whole group is scanned.
> > + */
> > +ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
> > +			unsigned int group, ext3_grpblk_t minblocks)
> > +{
> > +	handle_t *handle;
> > +	ext3_grpblk_t max = EXT3_BLOCKS_PER_GROUP(sb);
> > +	ext3_grpblk_t next, count = 0, start, bit;
> > +	struct ext3_sb_info *sbi;
> > +	ext3_fsblk_t discard_block;
> > +	struct buffer_head *bitmap_bh = NULL;
> > +	struct buffer_head *gdp_bh;
> > +	ext3_grpblk_t free_blocks;
> > +	struct ext3_group_desc *gdp;
> > +	int err = 0, ret;
> > +	ext3_grpblk_t freed;
> > +
> > +	/**
> > +	 * We will update one block bitmap, and one group descriptor
> > +	 */
> > +	handle = ext3_journal_start_sb(sb, 2);
> > +	if (IS_ERR(handle)) {
> > +		err = PTR_ERR(handle);
> > +		ext3_warning(sb, __func__, "error %d on journal start", err);
>   I think there's no need to issue another warning here... When
> journal_start fails there should be notices about this in the log already.

That's right, thanks.

> 
> > +		return err;
> > +	}
> > +
> > +	bitmap_bh = read_block_bitmap(sb, group);
> > +	if (!bitmap_bh)
> > +		goto err_out;
> > +
> > +	BUFFER_TRACE(bitmap_bh, "getting undo access");
> > +	err = ext3_journal_get_undo_access(handle, bitmap_bh);
> > +	if (err)
> > +		goto err_out;
> > +
> > +	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
> > +	if (!gdp)
> > +		goto err_out;
> > +
> > +	BUFFER_TRACE(gd_bh, "get_write_access");
> > +	err = ext3_journal_get_write_access(handle, gdp_bh);
> > +	if (err)
> > +		goto err_out;
> > +
> > +	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> > +	sbi = EXT3_SB(sb);
> > +
> > +	 /* Walk through the whole group */
> > +	start = 0;
> > +	while (start < max) {
> > +
> > +		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
> > +		if (start < 0)
> > +			break;
> > +		next = start;
> > +
> > +		/**
>                 ^^^ Use just /*. /** is reserved for comments processed by
>   kernel documentation generator and they have to have special format...

Ok.

> 
> > +		 * Allocate contiguous free extents by setting bits in the
> > +		 * block bitmap
> > +		 */
> > +		while (next < max
> > +			&& claim_block(sb_bgl_lock(sbi, group),
> > +					next, bitmap_bh)) {
> > +			next++;
> > +		}
> > +
> > +		 /* We did not claimed any blocks */
>                                ^^^^ claim

Oh, that is my astonishing English skills ;). Thanks.

> 
> > +		if (next == start)
> > +			continue;
> > +
> > +		discard_block = (ext3_fsblk_t)start +
> > +				ext3_group_first_block_no(sb, group);
> > +
> > +		/* Update counters */
> > +		spin_lock(sb_bgl_lock(sbi, group));
> > +		le16_add_cpu(&gdp->bg_free_blocks_count, start - next);
> > +		spin_unlock(sb_bgl_lock(sbi, group));
> > +		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
> > +
> > +		/* Do not issue a TRIM on extents smaller than minblocks */
> > +		if ((next - start) < minblocks)
> > +			goto free_extent;
> > +
> > +		 /* Send the TRIM command down to the device */
> > +		sb_issue_discard(sb, discard_block, next - start);
> > +		count += (next - start);
> > +		cond_resched();
>   Maybe you could cond_resched() after freeing the blocks instead of here?
> So that we don't sleep with blocks unnecessarily allocated?

Of course, that would be better.

> 
> > +
> > +free_extent:
> > +
> > +		freed = 0;
> > +		jbd_lock_bh_state(bitmap_bh);
> > +
> > +		for (bit = start; bit < next; bit++) {
> > +
> > +			/**
> > +			 * @@@ This prevents newly-allocated data from being
> > +			 * freed and then reallocated within the same
> > +			 * transaction.
> > +			 */
> > +			BUFFER_TRACE(bitmap_bh, "set in b_committed_data");
> > +			J_ASSERT_BH(bitmap_bh,
> > +				bh2jh(bitmap_bh)->b_committed_data != NULL);
> > +			ext3_set_bit_atomic(sb_bgl_lock(sbi, group), bit,
> > +				bh2jh(bitmap_bh)->b_committed_data);
>   You don't have to do this. Since you didn't really allocate the blocks
> (you are actually never going to commit bitmap changes to the journal)
> blocks can be happily reallocated just after you clear the bits in the
> bitmap. There's no problem with that. Also you don't have to hold bh_state
> lock at all.

Thanks.

> 
> > +
> > +			/**
> > +			 * We clear the bit in the bitmap after setting the
> > +			 * committed data bit, because this is the reverse
> > +			 * order to that which the allocator uses.
> > +			 */
> > +			BUFFER_TRACE(bitmap_bh, "clear bit");
> > +			if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, group),
> > +						bit, bitmap_bh->b_data)) {
> > +				jbd_unlock_bh_state(bitmap_bh);
> > +				ext3_error(sb, __func__,
> > +					"bit already cleared for block "E3FSBLK,
> > +					 (unsigned long)bit);
> > +				jbd_lock_bh_state(bitmap_bh);
> > +				BUFFER_TRACE(bitmap_bh, "bit already cleared");
> > +			} else {
> > +				freed++;
> > +			}
> > +		}
> > +
> > +		jbd_unlock_bh_state(bitmap_bh);
> > +
> > +		/* Update couters */
> > +		spin_lock(sb_bgl_lock(sbi, group));
> > +		le16_add_cpu(&gdp->bg_free_blocks_count, freed);
> > +		spin_unlock(sb_bgl_lock(sbi, group));
> > +		percpu_counter_add(&sbi->s_freeblocks_counter, next - start);
> > +
> > +		start = next;
> > +
> > +		if (signal_pending(current)) {
> > +			count = -ERESTARTSYS;
> > +			break;
> > +		}
> > +
> > +		/* No more suitable extents */
> > +		if ((free_blocks - count) < minblocks)
> > +			break;
> > +	}
> > +
> > +	/* We dirtied the bitmap block */
> > +	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
> > +	err = ext3_journal_dirty_metadata(handle, bitmap_bh);
> > +
> > +	/* And the group descriptor block */
> > +	BUFFER_TRACE(gdp_bh, "dirtied group descriptor block");
> > +	ret = ext3_journal_dirty_metadata(handle, gdp_bh);
> > +	if (!err)
> > +		err = ret;
> > +
> > +	ext3_debug("trimmed %d blocks in the group %d\n",
> > +		count, group);
> > +
> > +err_out:
> > +	if (err) {
> > +		ext3_std_error(sb, err);
> > +		count = -err;
> > +	}
> > +
> > +	ext3_journal_stop(handle);
> > +	brelse(bitmap_bh);
> > +
> > +	return count;
> > +}
>   Otherwise the patch looks OK.

Great, thanks for looking at this. I will resend the patch shortly.

> 
> 								Honza
> 

-Lukas

