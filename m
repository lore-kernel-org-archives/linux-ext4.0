From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Tue, 3 Jun 2008 22:23:56 -0400
Message-ID: <20080604022356.GA7094@mit.edu>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43959 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbYFDCY2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 22:24:28 -0400
Content-Disposition: inline
In-Reply-To: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2008 at 02:04:22AM +0530, Aneesh Kumar K.V wrote:
> When mouting ext4 with -o noextents, request for
> file data blocks from inode prealloc space.

Aneesh, can you expand on this patch set?  Why is this important?
What was it doing beforehand?  Is this to replace the use of the block
reservations code that had been introduced by Mingming in ext3?  Or is
that a long-term goal?

Also, it would be nice to add some comments at the beginning of the
changed functions, explaining what the functions do, what they are
intended for, what they assumptions they make (i.e., do they assume
that certain locks are taken), any side effects they make (i.e., this
function calls get_bh or put_bh to change the refcount on a passed-in
buffer head).   

I assume there was a good reason that you renamed the function
ext4_new_block() to ext4_fsblk_t ext4_new_meta_block(), but why?  Some
comments would really be useful.

I asked Mingming what this patch did when I was reviewing it this
afternoon, since we were both in New Hampshire at the btrfs
conference.  I couldn't parse the english for the comments, and after
looking at the patch, it wasn't at all obvious what the patch was
trying to accomplish.  Even though Mingming had reviewed it maybe two
weeks ago, she couldn't figure it out completely after looking over
the patch.  Consider how a someone who isn't intimately familiar with
the code would be able to figure out either (a) the code, or (b)
looking over the changeset.  Good code has to be long-term
maintainable, and some comments would really help in this department.

Since neither of us couldn't figure it out what the motivation of this
patch, we've decided to move it to the unstable portion of the patch
since without some better comments, it's probably not a good idea to
push it to Linus in this form.

						- Ted

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/balloc.c  |   36 +++++++++++++++++++++++++-
>  fs/ext4/ext4.h    |    7 +++-
>  fs/ext4/extents.c |    2 +-
>  fs/ext4/inode.c   |   72 +++++++++++++++++++++++++++++++++++++++-------------
>  fs/ext4/xattr.c   |    2 +-
>  5 files changed, 95 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 30494c5..bc7e1cd 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1862,7 +1862,7 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
>  	return 0;
>  }
>  
> -ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
> +ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
>  		ext4_fsblk_t goal, int *errp)
>  {
>  	struct ext4_allocation_request ar;
> @@ -1881,9 +1881,29 @@ ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
>  	ret = ext4_mb_new_blocks(handle, &ar, errp);
>  	return ret;
>  }
> +ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
> +		ext4_fsblk_t goal, unsigned long *count, int *errp)
> +{
> +	struct ext4_allocation_request ar;
> +	ext4_fsblk_t ret;
> +
> +	if (!test_opt(inode->i_sb, MBALLOC)) {
> +		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
> +		return ret;
> +	}
> +
> +	memset(&ar, 0, sizeof(ar));
> +	ar.inode = inode;
> +	ar.goal = goal;
> +	ar.len = *count;
> +	ret = ext4_mb_new_blocks(handle, &ar, errp);
> +	*count = ar.len;
> +	return ret;
> +}
>  
>  ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
> -		ext4_fsblk_t goal, unsigned long *count, int *errp)
> +				ext4_lblk_t iblock, ext4_fsblk_t goal,
> +				unsigned long *count, int *errp)
>  {
>  	struct ext4_allocation_request ar;
>  	ext4_fsblk_t ret;
> @@ -1894,9 +1914,21 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
>  	}
>  
>  	memset(&ar, 0, sizeof(ar));
> +	/* Fill with neighbour allocated blocks */
> +	ar.lleft  = 0;
> +	ar.pleft  = 0;
> +	ar.lright = 0;
> +	ar.pright = 0;
> +
>  	ar.inode = inode;
>  	ar.goal = goal;
>  	ar.len = *count;
> +	ar.logical = iblock;
> +	if (S_ISREG(inode->i_mode))
> +		ar.flags = EXT4_MB_HINT_DATA;
> +	else
> +		/* disable in-core preallocation for non-regular files */
> +		ar.flags = 0;
>  	ret = ext4_mb_new_blocks(handle, &ar, errp);
>  	*count = ar.len;
>  	return ret;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8158083..899406b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -958,10 +958,13 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
>  extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
>  extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
>  			ext4_group_t group);
> -extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
> +extern ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, int *errp);
> -extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
> +extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
> +extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
> +					ext4_lblk_t iblock, ext4_fsblk_t goal,
> +					unsigned long *count, int *errp);
>  extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
>  extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 47929c4..5ba81b3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -188,7 +188,7 @@ ext4_ext_new_block(handle_t *handle, struct inode *inode,
>  	ext4_fsblk_t goal, newblock;
>  
>  	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
> -	newblock = ext4_new_block(handle, inode, goal, err);
> +	newblock = ext4_new_meta_block(handle, inode, goal, err);
>  	return newblock;
>  }
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8d97077..3f4182f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -508,11 +508,12 @@ static int ext4_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
>   *		direct blocks
>   */
>  static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
> -			ext4_fsblk_t goal, int indirect_blks, int blks,
> -			ext4_fsblk_t new_blocks[4], int *err)
> +				ext4_lblk_t iblock, ext4_fsblk_t goal,
> +				int indirect_blks, int blks,
> +				ext4_fsblk_t new_blocks[4], int *err)
>  {
>  	int target, i;
> -	unsigned long count = 0;
> +	long count = 0, blk_allocated = 0;
>  	int index = 0;
>  	ext4_fsblk_t current_block = 0;
>  	int ret = 0;
> @@ -525,12 +526,13 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>  	 * the first direct block of this branch.  That's the
>  	 * minimum number of blocks need to allocate(required)
>  	 */
> -	target = blks + indirect_blks;
> -
> -	while (1) {
> +	/* first we try to allocate the indirect blocks */
> +	target = indirect_blks;
> +	while (target > 0) {
>  		count = target;
>  		/* allocating blocks for indirect blocks and direct blocks */
> -		current_block = ext4_new_blocks(handle,inode,goal,&count,err);
> +		current_block = ext4_new_meta_blocks(handle, inode,
> +							goal, &count, err);
>  		if (*err)
>  			goto failed_out;
>  
> @@ -540,16 +542,48 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>  			new_blocks[index++] = current_block++;
>  			count--;
>  		}
> -
> -		if (count > 0)
> +		if (count > 0) {
> +			/*
> +			 * save the new block number
> +			 * for the first direct block
> +			 */
> +			new_blocks[index] = current_block;
> +			printk(KERN_INFO "%s returned more blocks than "
> +						"requested\n", __func__);
> +			WARN_ON(1);
>  			break;
> +		}
>  	}
>  
> -	/* save the new block number for the first direct block */
> -	new_blocks[index] = current_block;
> -
> +	target = blks - count ;
> +	blk_allocated = count;
> +	if (!target)
> +		goto allocated;
> +	/* Now allocate data blocks */
> +	count = target;
> +	/* allocating blocks for indirect blocks and direct blocks */
> +	current_block = ext4_new_blocks(handle, inode, iblock,
> +						goal, &count, err);
> +	if (*err && (target == blks)) {
> +		/*
> +		 * if the allocation failed and we didn't allocate
> +		 * any blocks before
> +		 */
> +		goto failed_out;
> +	}
> +	if (!*err) {
> +		if (target == blks) {
> +		/*
> +		 * save the new block number
> +		 * for the first direct block
> +		 */
> +			new_blocks[index] = current_block;
> +		}
> +		blk_allocated += count;
> +	}
> +allocated:
>  	/* total number of blocks allocated for direct blocks */
> -	ret = count;
> +	ret = blk_allocated;
>  	*err = 0;
>  	return ret;
>  failed_out:
> @@ -584,8 +618,9 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>   *	as described above and return 0.
>   */
>  static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
> -			int indirect_blks, int *blks, ext4_fsblk_t goal,
> -			ext4_lblk_t *offsets, Indirect *branch)
> +				ext4_lblk_t iblock, int indirect_blks,
> +				int *blks, ext4_fsblk_t goal,
> +				ext4_lblk_t *offsets, Indirect *branch)
>  {
>  	int blocksize = inode->i_sb->s_blocksize;
>  	int i, n = 0;
> @@ -595,7 +630,7 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
>  	ext4_fsblk_t new_blocks[4];
>  	ext4_fsblk_t current_block;
>  
> -	num = ext4_alloc_blocks(handle, inode, goal, indirect_blks,
> +	num = ext4_alloc_blocks(handle, inode, iblock, goal, indirect_blks,
>  				*blks, new_blocks, &err);
>  	if (err)
>  		return err;
> @@ -855,8 +890,9 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
>  	/*
>  	 * Block out ext4_truncate while we alter the tree
>  	 */
> -	err = ext4_alloc_branch(handle, inode, indirect_blks, &count, goal,
> -				offsets + (partial - chain), partial);
> +	err = ext4_alloc_branch(handle, inode, iblock, indirect_blks,
> +					&count, goal,
> +					offsets + (partial - chain), partial);
>  
>  	/*
>  	 * The ext4_splice_branch call will free and forget any buffers
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index ff08633..93c5fdc 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -810,7 +810,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			/* We need to allocate a new block */
>  			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
>  						EXT4_I(inode)->i_block_group);
> -			ext4_fsblk_t block = ext4_new_block(handle, inode,
> +			ext4_fsblk_t block = ext4_new_meta_block(handle, inode,
>  							goal, &error);
>  			if (error)
>  				goto cleanup;
> -- 
> 1.5.5.1.211.g65ea3.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
