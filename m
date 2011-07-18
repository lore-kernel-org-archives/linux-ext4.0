From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
Date: Mon, 18 Jul 2011 00:19:19 -0600
Message-ID: <36AA4B27-92AE-4984-8002-3410C6109F15@dilger.ca>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com> <1310957555-15617-6-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19737 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRGTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:19:24 -0400
In-Reply-To: <1310957555-15617-6-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-17, at 8:52 PM, Yongqiang Yang wrote:
> This patch lets ext4_group_add_blocks() return an error code if it fails,
> so that upper functions can handle error correctly.

This patch is somewhat incorrect, though it seems the existing code is
also incorrect, which isn't the fault of this patch, but should be
fixed if this code is being reworked.

When this code was originally written, this code could not fail
unless the filesystem had been marked read-only or the journal was
aborted.  It only freed blocks using ext3_free_blocks_sb(), which
only had error paths calling ext3_error().

It was purposely done that way because all of the failure cases
(e.g. not being able to read the block bitmap) were checked in
advance, before modifying any of the filesystem metadata.

In the case of this patch, ext4_blocks_count_set() is called to
add the new blocks to the total in the superblock.  If this code
fails, it doesn't try to reset the total number of blocks in the
superblock, which can cause e2fsck to be unhappy.

Looking at this code more closely, it seems that ext4_group_add_blocks()
(formerly ext4_add_groupblocks()) is now only used by the resize code,
which IMHO is wrong.  What it was doing in the past was using existing
code to "free" the blocks at the end of the block bitmap, as if a file
had just been deleted.  As it is now, it seems to be duplicating a lot
of what is in ext4_free_blocks().

It probably makes sense to try and get some consolidated helper
function that includes nearly all of the code in ext4_free_blocks between
"do_more:" and "error_return:" (all of the work of verifying the blocks
to be freed, updating the block bitmap and the buddy bitmap, updates the
group descriptors and superblock, and marks the blocks dirty in the
journal), but not the code that checks the writeback mode, updates quota,
or any of that (since this isn't really using an inode).

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> fs/ext4/ext4.h    |    2 +-
> fs/ext4/mballoc.c |   19 +++++++++++++------
> fs/ext4/resize.c  |   10 +++++++---
> 3 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bbe81db..da7ab48 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1799,7 +1799,7 @@ extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
> 			     unsigned long count, int flags);
> extern int ext4_mb_add_groupinfo(struct super_block *sb,
> 		ext4_group_t i, struct ext4_group_desc *desc);
> -extern void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> +extern int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> 				ext4_fsblk_t block, unsigned long count);
> extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ea80c0b..33c41e6 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4664,7 +4664,7 @@ error_return:
>  *
>  * This marks the blocks as free in the bitmap and buddy.
>  */
> -void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> +int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> 			 ext4_fsblk_t block, unsigned long count)
> {
> 	struct buffer_head *bitmap_bh = NULL;
> @@ -4685,15 +4685,21 @@ void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> 	 * Check to see if we are freeing blocks across a group
> 	 * boundary.
> 	 */
> -	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb))
> -		goto error_return;
> +	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
> +		ext4_warning(sb, "too much blocks added to group %u\n",
> +			     block_group);
> +		return -EINVAL;
> +	}
> 
> 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
> 	if (!bitmap_bh)
> -		goto error_return;
> +		return -EIO;
> +
> 	desc = ext4_get_group_desc(sb, block_group, &gd_bh);
> -	if (!desc)
> +	if (!desc) {
> +		err = -EIO;
> 		goto error_return;
> +	}
> 
> 	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
> 	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
> @@ -4703,6 +4709,7 @@ void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> 		ext4_error(sb, "Adding blocks in system zones - "
> 			   "Block = %llu, count = %lu",
> 			   block, count);
> +		err = -EINVAL;
> 		goto error_return;
> 	}
> 
> @@ -4771,7 +4778,7 @@ void ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> error_return:
> 	brelse(bitmap_bh);
> 	ext4_std_error(sb, err);
> -	return;
> +	return err;
> }
> 
> /**
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 374fd1c..2e63376 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -990,7 +990,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
> 	ext4_grpblk_t add;
> 	struct buffer_head *bh;
> 	handle_t *handle;
> -	int err;
> +	int err, err2;
> 	ext4_group_t group;
> 
> 	o_blocks_count = ext4_blocks_count(es);
> @@ -1066,11 +1066,15 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
> 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
> 		   o_blocks_count + add);
> 	/* We add the blocks to the bitmap and set the group need init bit */
> -	ext4_group_add_blocks(handle, sb, o_blocks_count, add);
> +	err = ext4_group_add_blocks(handle, sb, o_blocks_count, add);
> 	ext4_handle_dirty_super(handle, sb);
> 	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
> 		   o_blocks_count + add);
> -	if ((err = ext4_journal_stop(handle)))
> +	err2 = ext4_journal_stop(handle);
> +	if (!err && err2)
> +		err = err2;
> +
> +	if (err)
> 		goto exit_put;
> 
> 	if (test_opt(sb, DEBUG))
> -- 
> 1.7.5.1
> 


Cheers, Andreas





