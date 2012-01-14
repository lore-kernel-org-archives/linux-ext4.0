From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: remove block bitmap initialization in ext4_new_inode()
Date: Fri, 13 Jan 2012 22:02:46 -0700
Message-ID: <00C2AC6D-7D45-4FFF-B509-77BFD21BC093@dilger.ca>
References: <1326490249-1685-1-git-send-email-tytso@mit.edu> <1326490249-1685-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20829 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2ANFCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jan 2012 00:02:48 -0500
In-Reply-To: <1326490249-1685-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-13, at 2:30 PM, Theodore Ts'o wrote:
> We don't need to initialize the block bitmap when we allocate a new
> inode.

The reason the block bitmap is initialized when an inode is allocated
in that group is to indicate that the inode bitmap is in use, and the
inode table blocks are also in use.

> This is old code from the very early days that is just
> confusing things, and also has the problem of modifying the block
> group descriptor without obeying the ext4_journal_get_write_access() /
> ext4_handle_dirty_metadata() modification protocols.

The group descriptor was already modified earlier on when the inode was
being allocated from the group, so the group descriptor block was already
accounted for in the transaction credits after "repeat_in_this_group:"

repeat_in_this_group:
                ino = ext4_find_next_zero_bit((unsigned long *)
                                              inode_bitmap_bh->b_data,
                                              EXT4_INODES_PER_GROUP(sb), ino);

                if (ino < EXT4_INODES_PER_GROUP(sb)) {

                        BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
                        err = ext4_journal_get_write_access(handle,
                                                            inode_bitmap_bh);
                        if (err)
                                goto fail;

                        BUFFER_TRACE(group_desc_bh, "get_write_access");
*****>>>>>              err = ext4_journal_get_write_access(handle,
                                                            group_desc_bh);

That is why ext4_handle_dirty_metadata() isn't called until after the group
descriptor is modified during the block bitmap initialization.


I'm not wholly against removing this code, but we have to do it with the
clear understanding that we will have inodes in use for which the block
bitmap is showing that the in-use blocks are free.  This doesn't seem like
a great situation to me.


> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> fs/ext4/ialloc.c |   31 -------------------------------
> 1 files changed, 0 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 72fc989..a4ce10f 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -807,37 +807,6 @@ repeat_in_this_group:
> 	goto out;
> 
> got:
> -	/* We may have to initialize the block bitmap if it isn't already */
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
> -	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> -		struct buffer_head *block_bitmap_bh;
> -
> -		block_bitmap_bh = ext4_read_block_bitmap(sb, group);
> -		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
> -		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
> -		if (err) {
> -			brelse(block_bitmap_bh);
> -			goto fail;
> -		}
> -
> -		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
> -		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
> -		brelse(block_bitmap_bh);
> -
> -		/* recheck and clear flag under lock if we still need to */
> -		ext4_lock_group(sb, group);
> -		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> -			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
> -			ext4_free_group_clusters_set(sb, gdp,
> -				ext4_free_clusters_after_init(sb, group, gdp));
> -			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
> -								gdp);
> -		}
> -		ext4_unlock_group(sb, group);
> -
> -		if (err)
> -			goto fail;
> -	}
> 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
> 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
> 	if (err)
> -- 
> 1.7.8.11.gefc1f.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





