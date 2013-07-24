From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 4/5] ext4: Mark block group as corrupt on inode bitmap
 error
Date: Wed, 24 Jul 2013 15:22:52 +0800
Message-ID: <20130724072252.GA3685@gmail.com>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235559.24017.72336.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33543 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3GXHW6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jul 2013 03:22:58 -0400
Received: by mail-pd0-f174.google.com with SMTP id 10so65799pdc.5
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jul 2013 00:22:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130719235559.24017.72336.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:55:59PM -0700, Darrick J. Wong wrote:
> If we detect either a discrepancy between the inode bitmap and the inode counts
> or the inode bitmap fails to pass validation checks, mark the block group
> corrupt and refuse to allocate or deallocate inodes from the group.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/ext4.h   |    3 +++
>  fs/ext4/ialloc.c |   29 +++++++++++++++++++++++++----
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 45cc955..b8ac53d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2449,11 +2449,14 @@ struct ext4_group_info {
>  #define EXT4_GROUP_INFO_NEED_INIT_BIT		0
>  #define EXT4_GROUP_INFO_WAS_TRIMMED_BIT		1
>  #define EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT	2
> +#define EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT	4
>  
>  #define EXT4_MB_GRP_NEED_INIT(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
>  #define EXT4_MB_GRP_BBITMAP_CORRUPT(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
> +#define EXT4_MB_GRP_IBITMAP_CORRUPT(grp)	\
> +	(test_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
>  
>  #define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index f03598c..08c7fa7 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -117,6 +117,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
>  	struct ext4_group_desc *desc;
>  	struct buffer_head *bh = NULL;
>  	ext4_fsblk_t bitmap_blk;
> +	struct ext4_group_info *grp;
>  
>  	desc = ext4_get_group_desc(sb, block_group, NULL);
>  	if (!desc)
> @@ -185,6 +186,8 @@ verify:
>  		put_bh(bh);
>  		ext4_error(sb, "Corrupt inode bitmap - block_group = %u, "
>  			   "inode_bitmap = %llu", block_group, bitmap_blk);
> +		grp = ext4_get_group_info(sb, block_group);
> +		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
>  		return NULL;
>  	}
>  	ext4_unlock_group(sb, block_group);
> @@ -221,6 +224,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
>  	struct ext4_super_block *es;
>  	struct ext4_sb_info *sbi;
>  	int fatal = 0, err, count, cleared;
> +	struct ext4_group_info *grp;
>  
>  	if (!sb) {
>  		printk(KERN_ERR "EXT4-fs: %s:%d: inode on "
> @@ -266,7 +270,9 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
>  	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
>  	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
>  	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
> -	if (!bitmap_bh)
> +	/* Don't bother if the inode bitmap is corrupt. */
> +	grp = ext4_get_group_info(sb, block_group);
> +	if (unlikely(EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) || !bitmap_bh)
>  		goto error_return;

It seems that this is a duplicated check.  If we encounters a currupted
inode bitmap, ext4_read_inode_bitmap() will return null.

>  
>  	BUFFER_TRACE(bitmap_bh, "get_write_access");
> @@ -315,8 +321,10 @@ out:
>  		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
>  		if (!fatal)
>  			fatal = err;
> -	} else
> +	} else {
>  		ext4_error(sb, "bit already cleared for inode %lu", ino);
> +		set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, &grp->bb_state);
> +	}
>  
>  error_return:
>  	brelse(bitmap_bh);
> @@ -652,6 +660,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  	struct inode *ret;
>  	ext4_group_t i;
>  	ext4_group_t flex_group;
> +	struct ext4_group_info *grp;
>  
>  	/* Cannot create files in a deleted directory */
>  	if (!dir || !dir->i_nlink)
> @@ -725,10 +734,22 @@ got_group:
>  			continue;
>  		}
>  
> +		grp = ext4_get_group_info(sb, group);
> +		/* Skip groups with already-known suspicious inode tables */
> +		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
> +			if (++group == ngroups)
> +				group = 0;
> +			continue;
> +		}
> +
>  		brelse(inode_bitmap_bh);
>  		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
> -		if (!inode_bitmap_bh)
> -			goto out;
> +		/* Skip groups with suspicious inode tables */
> +		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp) || !inode_bitmap_bh) {
> +			if (++group == ngroups)
> +				group = 0;
> +			continue;
> +		}

The same as above.

                                                - Zheng

>  
>  repeat_in_this_group:
>  		ino = ext4_find_next_zero_bit((unsigned long *)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
