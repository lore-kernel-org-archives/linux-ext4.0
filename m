From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Fix 32-bit overflow problems: dgrp_t * s_blocks_per_group
Date: Fri, 04 Jan 2013 11:21:18 -0600
Message-ID: <50E70F8E.7050607@redhat.com>
References: <50E5AA43.2080200@redhat.com> <1357239476-19820-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab3ADRyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2013 12:54:54 -0500
In-Reply-To: <1357239476-19820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/3/13 12:57 PM, Theodore Ts'o wrote:
> There are a number of places where we multiply a dgrp_t with
> s_blocks_per_group expecting that we will get a blk64_t.  This
> requires a cast, or using the convenience function
> ext2fs_group_first_block2().
> 
> This audit was suggested by Eric Sandeen.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks Ted, didn't exactly mean to assign you work ;)

> ---
>  e2fsck/super.c         |  6 +++---
>  lib/ext2fs/alloc.c     |  6 ++----
>  lib/ext2fs/extent.c    |  3 +--
>  lib/ext2fs/mkjournal.c |  4 +---
>  resize/resize2fs.c     | 10 ++++------
>  5 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index 160991d..b4b5bff 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -317,7 +317,8 @@ void check_resize_inode(e2fsck_t ctx)
>  	struct problem_context	pctx;
>  	int		i, gdt_off, ind_off;
>  	dgrp_t		j;
> -	blk64_t		blk, pblk, expect;
> +	blk64_t		blk, pblk;
> +	blk_t		expect;

this is ok because resize-inode-land is all < 32 bits I guess, right?
A comment might help, but *shrug*

The rest:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Wish the were a way to enforce use of the helper function, these
may well creep back in.

-Eric

>  	__u32 		*dind_buf = 0, *ind_buf;
>  	errcode_t	retval;
>  
> @@ -914,8 +915,7 @@ int check_backup_super_block(e2fsck_t ctx)
>  		if (!ext2fs_bg_has_super(fs, g))
>  			continue;
>  
> -		sb = fs->super->s_first_data_block +
> -			(g * fs->super->s_blocks_per_group);
> +		sb = ext2fs_group_first_block2(fs, g);
>  
>  		retval = io_channel_read_blk(fs->io, sb, -SUPERBLOCK_SIZE,
>  					     buf);
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 775dfcc..0c829ed 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -41,8 +41,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
>  	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
>  		return;
>  
> -	blk = (group * fs->super->s_blocks_per_group) +
> -		fs->super->s_first_data_block;
> +	blk = ext2fs_group_first_block2(fs, group);
>  
>  	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
>  				  &old_desc_blk, &new_desc_blk, 0);
> @@ -56,8 +55,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
>  	for (i=0; i < fs->super->s_blocks_per_group; i++, blk++)
>  		ext2fs_fast_unmark_block_bitmap2(map, blk);
>  
> -	blk = (group * fs->super->s_blocks_per_group) +
> -		fs->super->s_first_data_block;
> +	blk = ext2fs_group_first_block2(fs, group);
>  	for (i=0; i < fs->super->s_blocks_per_group; i++, blk++) {
>  		if ((blk == super_blk) ||
>  		    (old_desc_blk && old_desc_blocks &&
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index 4d6af88..9cc7cba 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -934,8 +934,7 @@ errcode_t ext2fs_extent_node_split(ext2_extent_handle_t handle)
>  
>  		if (log_flex)
>  			group = group & ~((1 << (log_flex)) - 1);
> -		goal_blk = (group * handle->fs->super->s_blocks_per_group) +
> -			handle->fs->super->s_first_data_block;
> +		goal_blk = ext2fs_group_first_block2(handle->fs, group);
>  	}
>  	retval = ext2fs_alloc_block2(handle->fs, goal_blk, block_buf,
>  				    &new_node_pblk);
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index c154d91..c636a97 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -358,9 +358,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
>  		    ext2fs_bg_free_blocks_count(fs, group))
>  			group = i;
>  
> -	es.goal = (fs->super->s_blocks_per_group * group) +
> -		fs->super->s_first_data_block;
> -
> +	es.goal = ext2fs_group_first_block2(fs, group);
>  	retval = ext2fs_block_iterate3(fs, journal_ino, BLOCK_FLAG_APPEND,
>  				       0, mkjournal_proc, &es);
>  	if (es.err) {
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index ac965ee..8fdf35c 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -492,9 +492,8 @@ retry:
>  	/*
>  	 * Initialize the new block group descriptors
>  	 */
> -	group_block = fs->super->s_first_data_block +
> -		old_fs->group_desc_count * fs->super->s_blocks_per_group;
> -
> +	group_block = ext2fs_group_first_block2(fs,
> +						old_fs->group_desc_count);
>  	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>  					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
>  	if (access("/sys/fs/ext4/features/lazy_itable_init", F_OK) == 0)
> @@ -651,9 +650,8 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
>  		goto errout;
>  
>  	memset(rfs->itable_buf, 0, fs->blocksize * fs->inode_blocks_per_group);
> -	group_block = fs->super->s_first_data_block +
> -		rfs->old_fs->group_desc_count * fs->super->s_blocks_per_group;
> -
> +	group_block = ext2fs_group_first_block2(fs,
> +						rfs->old_fs->group_desc_count);
>  	adj = rfs->old_fs->group_desc_count;
>  	max_group = fs->group_desc_count - adj;
>  	if (rfs->progress) {
> 

