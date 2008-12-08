From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: remove ext4_new_meta_block()
Date: Sun, 07 Dec 2008 19:30:45 -0600
Message-ID: <493C78C5.8080805@redhat.com>
References: <1228678434-14707-1-git-send-email-tytso@mit.edu> <1228678434-14707-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYLHBbI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Dec 2008 20:31:08 -0500
In-Reply-To: <1228678434-14707-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> There were only two one callers of the function ext4_new_meta_block(),
> which just a very simpler wrapper function around
> ext4_new_meta_blocks().  Change those two functions to call
> ext4_new_meta_blocks() directly, to save code and stack space usage.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Looks like a good idea to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/balloc.c  |   17 -----------------
>  fs/ext4/ext4.h    |    2 --
>  fs/ext4/extents.c |    3 ++-
>  fs/ext4/xattr.c   |    5 +++--
>  4 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 02e8ce4..47cf25d 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -724,23 +724,6 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  	return ret;
>  }
>  
> -/*
> - * ext4_new_meta_block() -- allocate block for meta data (indexing) blocks
> - *
> - * @handle:             handle to this transaction
> - * @inode:              file inode
> - * @goal:               given target block(filesystem wide)
> - * @errp:               error code
> - *
> - * Return allocated block number on success
> - */
> -ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
> -		ext4_fsblk_t goal, int *errp)
> -{
> -	unsigned long count = 1;
> -	return ext4_new_meta_blocks(handle, inode, goal, &count, errp);
> -}
> -
>  /**
>   * ext4_count_free_blocks() -- count filesystem free blocks
>   * @sb:		superblock
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 74cb395..ac8551e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -998,8 +998,6 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
>  extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
>  extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
>  			ext4_group_t group);
> -extern ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
> -			ext4_fsblk_t goal, int *errp);
>  extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
>  extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ea2ce3c..e5b169b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -189,9 +189,10 @@ ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
>  			struct ext4_extent *ex, int *err)
>  {
>  	ext4_fsblk_t goal, newblock;
> +	unsigned long count = 1;
>  
>  	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
> -	newblock = ext4_new_meta_block(handle, inode, goal, err);
> +	newblock = ext4_new_meta_blocks(handle, inode, goal, &count, err);
>  	return newblock;
>  }
>  
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 80626d5..f896e2c 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -689,6 +689,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  		     struct ext4_xattr_info *i,
>  		     struct ext4_xattr_block_find *bs)
>  {
> +	unsigned long count = 1;
>  	struct super_block *sb = inode->i_sb;
>  	struct buffer_head *new_bh = NULL;
>  	struct ext4_xattr_search *s = &bs->s;
> @@ -810,8 +811,8 @@ inserted:
>  			/* We need to allocate a new block */
>  			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
>  						EXT4_I(inode)->i_block_group);
> -			ext4_fsblk_t block = ext4_new_meta_block(handle, inode,
> -							goal, &error);
> +			ext4_fsblk_t block = ext4_new_meta_blocks(handle, inode,
> +						  goal, &count, &error);
>  			if (error)
>  				goto cleanup;
>  			ea_idebug(inode, "creating block %d", block);

