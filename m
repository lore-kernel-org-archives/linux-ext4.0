From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: refactor duplicated block placement code
Date: Wed, 22 Jun 2011 21:16:33 -0600
Message-ID: <B29561D4-6D3C-4991-AB6E-6F8C2D701D67@dilger.ca>
References: <4E023652.2010903@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:59910 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab1FWDQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 23:16:39 -0400
In-Reply-To: <4E023652.2010903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-22, at 12:37 PM, Eric Sandeen wrote:
> I found that ext4_ext_find_goal() and ext4_find_near()
> share the same code for returning a coloured start block
> based on i_block_group.
> 
> We can refactor this into a common function so that they
> don't diverge in the future.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> ext4.h    |    1 
> extents.c |   37 ---------------------------------
> inode.c   |   69 +++++++++++++++++++++++++++++++++++++-------------------------
> 3 files changed, 44 insertions(+), 63 deletions(-)
> 
> I don't know that I like the new function name too much,
> I'm open to suggestions...

What about ext4_goal_block_from_inode() or ext4_start_block_from_inode() or
ext4_inode_to_{goal,start}_block()?  One of last ones might be good since
it makes it clear this function is related to other ext4_inode_*() functions.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1921392..1d79fbc 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1812,6 +1812,7 @@ extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> 				struct kstat *stat);
> extern void ext4_evict_inode(struct inode *);
> extern void ext4_clear_inode(struct inode *);
> +ext4_fsblk_t ext4_inode_group_start(struct inode *);
> extern int  ext4_sync_inode(handle_t *, struct inode *);
> extern void ext4_dirty_inode(struct inode *, int);
> extern int ext4_change_inode_journal_flag(struct inode *, int);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5199bac..23cf7dd 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -114,12 +114,6 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
> 			      struct ext4_ext_path *path,
> 			      ext4_lblk_t block)
> {
> -	struct ext4_inode_info *ei = EXT4_I(inode);
> -	ext4_fsblk_t bg_start;
> -	ext4_fsblk_t last_block;
> -	ext4_grpblk_t colour;
> -	ext4_group_t block_group;
> -	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
> 	int depth;
> 
> 	if (path) {
> @@ -161,36 +155,7 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
> 	}
> 
> 	/* OK. use inode's group */
> -	block_group = ei->i_block_group;
> -	if (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) {
> -		/*
> -		 * If there are at least EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME
> -		 * block groups per flexgroup, reserve the first block
> -		 * group for directories and special files.  Regular
> -		 * files will start at the second block group.  This
> -		 * tends to speed up directory access and improves
> -		 * fsck times.
> -		 */
> -		block_group &= ~(flex_size-1);
> -		if (S_ISREG(inode->i_mode))
> -			block_group++;
> -	}
> -	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
> -	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
> -
> -	/*
> -	 * If we are doing delayed allocation, we don't need take
> -	 * colour into account.
> -	 */
> -	if (test_opt(inode->i_sb, DELALLOC))
> -		return bg_start;
> -
> -	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
> -		colour = (current->pid % 16) *
> -			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
> -	else
> -		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
> -	return bg_start + colour + block;
> +	return ext4_inode_group_start(inode);
> }
> 
> /*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a5763e3..5784809 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -466,6 +466,47 @@ no_block:
> 	return p;
> }
> 
> +ext4_fsblk_t ext4_inode_group_start(struct inode *inode)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	ext4_group_t block_group;
> +	ext4_grpblk_t colour;
> +	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
> +	ext4_fsblk_t bg_start;
> +	ext4_fsblk_t last_block;
> +
> +	block_group = ei->i_block_group;
> +	if (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) {
> +		/*
> +		 * If there are at least EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME
> +		 * block groups per flexgroup, reserve the first block
> +		 * group for directories and special files.  Regular
> +		 * files will start at the second block group.  This
> +		 * tends to speed up directory access and improves
> +		 * fsck times.
> +		 */
> +		block_group &= ~(flex_size-1);
> +		if (S_ISREG(inode->i_mode))
> +			block_group++;
> +	}
> +	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
> +	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
> +
> +	/*
> +	 * If we are doing delayed allocation, we don't need take
> +	 * colour into account.
> +	 */
> +	if (test_opt(inode->i_sb, DELALLOC))
> +		return bg_start;
> +
> +	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
> +		colour = (current->pid % 16) *
> +			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
> +	else
> +		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
> +	return bg_start + colour;
> +}
> +
> /**
> *	ext4_find_near - find a place for allocation with sufficient locality
> *	@inode: owner
> @@ -491,11 +532,6 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
> 	struct ext4_inode_info *ei = EXT4_I(inode);
> 	__le32 *start = ind->bh ? (__le32 *) ind->bh->b_data : ei->i_data;
> 	__le32 *p;
> -	ext4_fsblk_t bg_start;
> -	ext4_fsblk_t last_block;
> -	ext4_grpblk_t colour;
> -	ext4_group_t block_group;
> -	int flex_size = ext4_flex_bg_size(EXT4_SB(inode->i_sb));
> 
> 	/* Try to find previous block */
> 	for (p = ind->p - 1; p >= start; p--) {
> @@ -511,28 +547,7 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
> 	 * It is going to be referred to from the inode itself? OK, just put it
> 	 * into the same cylinder group then.
> 	 */
> -	block_group = ei->i_block_group;
> -	if (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) {
> -		block_group &= ~(flex_size-1);
> -		if (S_ISREG(inode->i_mode))
> -			block_group++;
> -	}
> -	bg_start = ext4_group_first_block_no(inode->i_sb, block_group);
> -	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
> -
> -	/*
> -	 * If we are doing delayed allocation, we don't need take
> -	 * colour into account.
> -	 */
> -	if (test_opt(inode->i_sb, DELALLOC))
> -		return bg_start;
> -
> -	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
> -		colour = (current->pid % 16) *
> -			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
> -	else
> -		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
> -	return bg_start + colour;
> +	return ext4_inode_group_start(inode);
> }
> 
> /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





