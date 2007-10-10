From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: patch queue updated
Date: Wed, 10 Oct 2007 09:00:53 -0700
Message-ID: <1192032053.3880.11.camel@localhost.localdomain>
References: <470CBFFF.3080308@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:50935 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbXJJQGr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 12:06:47 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9AG6kWF032375
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 12:06:46 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9AG6CVN345674
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:06:45 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9AG0tlX018960
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 10:00:56 -0600
In-Reply-To: <470CBFFF.3080308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-10-10 at 17:35 +0530, Aneesh Kumar K.V wrote:
> I have updated the patch queue at 
> 
> http://www.radian.org/~kvaneesh/ext4/patch-series/
> 
> http://www.radian.org/~kvaneesh/ext4/patch-series/ext4-patch-queue.tar
> 
> Changes:
> a) Add large-file-blocktype.patch  large-file.patch patch.

Could you send them out separately? I noticed that your queue is not
based on the last ext4 patch queue. You modified mballoc-core.patch
directly with large file block type changes...but your updated
mballoc-core.patch doesn't have the latest proc fs fix from Ted. 

I would appreciate if you separete the largeblocktype changes for
mballoc out of the core mballoc changes, as that patch is getting really
big already.

> b) Add the stable-boundary-patch with dummy change
> c) Add stable-boundary-undo.patch which undo the above dummy change.

The stable-boundary patch is being removed from ext4 patch queue,as some
tools expect a meaning code diff to apply any patch.

> d) Update the series to point to the right file name ext4_grpnum_t_int_fix.patch
>   instead of ext4_grpnum_t_negative_value_fix.patch
> 
Fixed it in ext4-patch-queue.Thanks,

> The diff between the content of the current patch-queu and the this is below
> 
> -aneesh
> 
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 2ba49ff..9ffae96 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -124,7 +124,7 @@ static int ext4_readdir(struct file * filp,
> 	offset = filp->f_pos & (sb->s_blocksize - 1);
> 
> 	while (!error && !stored && filp->f_pos < inode->i_size) {
> -		unsigned long blk = filp->f_pos >> EXT4_BLOCK_SIZE_BITS(sb);
> +		ext4_lblk_t blk = filp->f_pos >> EXT4_BLOCK_SIZE_BITS(sb);
> 		struct buffer_head map_bh;
> 		struct buffer_head *bh = NULL;
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0ea6122..392b76e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -144,7 +144,7 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
> 
> static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
> 			      struct ext4_ext_path *path,
> -			      ext4_fsblk_t block)
> +			      ext4_lblk_t block)
> {
> 	struct ext4_inode_info *ei = EXT4_I(inode);
> 	ext4_fsblk_t bg_start;
> @@ -367,13 +367,14 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
>  * the header must be checked before calling this
>  */
> static void
> -ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int block)
> +ext4_ext_binsearch_idx(struct inode *inode,
> +			struct ext4_ext_path *path, ext4_lblk_t block)
> {
> 	struct ext4_extent_header *eh = path->p_hdr;
> 	struct ext4_extent_idx *r, *l, *m;
> 
> 
> -	ext_debug("binsearch for %d(idx):  ", block);
> +	ext_debug("binsearch for %lu(idx):  ", (unsigned long)block);
> 
> 	l = EXT_FIRST_INDEX(eh) + 1;
> 	r = EXT_LAST_INDEX(eh);
> @@ -425,7 +426,8 @@ ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int bloc
>  * the header must be checked before calling this
>  */
> static void
> -ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
> +ext4_ext_binsearch(struct inode *inode,
> +		struct ext4_ext_path *path, ext4_lblk_t block)
> {
> 	struct ext4_extent_header *eh = path->p_hdr;
> 	struct ext4_extent *r, *l, *m;
> @@ -438,7 +440,7 @@ ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
> 		return;
> 	}
> 
> -	ext_debug("binsearch for %d:  ", block);
> +	ext_debug("binsearch for %lu:  ", (unsigned long)block);
> 
> 	l = EXT_FIRST_EXTENT(eh) + 1;
> 	r = EXT_LAST_EXTENT(eh);
> @@ -494,7 +496,8 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
> }
> 
> struct ext4_ext_path *
> -ext4_ext_find_extent(struct inode *inode, int block, struct ext4_ext_path *path)
> +ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
> +					struct ext4_ext_path *path)
> {
> 	struct ext4_extent_header *eh;
> 	struct buffer_head *bh;
> @@ -979,8 +982,8 @@ repeat:
> 		/* refill path */
> 		ext4_ext_drop_refs(path);
> 		path = ext4_ext_find_extent(inode,
> -					    le32_to_cpu(newext->ee_block),
> -					    path);
> +				    (ext4_lblk_t )le32_to_cpu(newext->ee_block),
> +				    path);
> 		if (IS_ERR(path))
> 			err = PTR_ERR(path);
> 	} else {
> @@ -992,8 +995,8 @@ repeat:
> 		/* refill path */
> 		ext4_ext_drop_refs(path);
> 		path = ext4_ext_find_extent(inode,
> -					    le32_to_cpu(newext->ee_block),
> -					    path);
> +				   (ext4_lblk_t)le32_to_cpu(newext->ee_block),
> +				    path);
> 		if (IS_ERR(path)) {
> 			err = PTR_ERR(path);
> 			goto out;
> @@ -1023,7 +1026,7 @@ out:
>  */
> int
> ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
> -			ext4_fsblk_t *logical, ext4_fsblk_t *phys)
> +			ext4_lblk_t *logical, ext4_fsblk_t *phys)
> {
> 	struct ext4_extent_idx *ix;
> 	struct ext4_extent *ex;
> @@ -1066,7 +1069,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
>  */
> int
> ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
> -			ext4_fsblk_t *logical, ext4_fsblk_t *phys)
> +			ext4_lblk_t *logical, ext4_fsblk_t *phys)
> {
> 	struct buffer_head *bh = NULL;
> 	struct ext4_extent_header *eh;
> @@ -1196,7 +1199,7 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
>  * ext4_ext_next_leaf_block:
>  * returns first allocated block from next leaf or EXT_MAX_BLOCK
>  */
> -static unsigned ext4_ext_next_leaf_block(struct inode *inode,
> +static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
> 					struct ext4_ext_path *path)
> {
> 	int depth;
> @@ -1214,7 +1217,7 @@ static unsigned ext4_ext_next_leaf_block(struct inode *inode,
> 	while (depth >= 0) {
> 		if (path[depth].p_idx !=
> 				EXT_LAST_INDEX(path[depth].p_hdr))
> -		  return le32_to_cpu(path[depth].p_idx[1].ei_block);
> +		  return (ext4_lblk_t)le32_to_cpu(path[depth].p_idx[1].ei_block);
> 		depth--;
> 	}
> 
> @@ -1432,7 +1435,8 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
> 	struct ext4_extent *ex, *fex;
> 	struct ext4_extent *nearex; /* nearest extent */
> 	struct ext4_ext_path *npath = NULL;
> -	int depth, len, err, next;
> +	int depth, len, err;
> +	ext4_lblk_t next;
> 	unsigned uninitialized = 0;
> 
> 	BUG_ON(ext4_ext_get_actual_len(newext) == 0);
> @@ -1577,114 +1581,8 @@ cleanup:
> 	return err;
> }
> 
> -int ext4_ext_walk_space(struct inode *inode, unsigned long block,
> -			unsigned long num, ext_prepare_callback func,
> -			void *cbdata)
> -{
> -	struct ext4_ext_path *path = NULL;
> -	struct ext4_ext_cache cbex;
> -	struct ext4_extent *ex;
> -	unsigned long next, start = 0, end = 0;
> -	unsigned long last = block + num;
> -	int depth, exists, err = 0;
> -
> -	BUG_ON(func == NULL);
> -	BUG_ON(inode == NULL);
> -
> -	while (block < last && block != EXT_MAX_BLOCK) {
> -		num = last - block;
> -		/* find extent for this block */
> -		path = ext4_ext_find_extent(inode, block, path);
> -		if (IS_ERR(path)) {
> -			err = PTR_ERR(path);
> -			path = NULL;
> -			break;
> -		}
> -
> -		depth = ext_depth(inode);
> -		BUG_ON(path[depth].p_hdr == NULL);
> -		ex = path[depth].p_ext;
> -		next = ext4_ext_next_allocated_block(path);
> -
> -		exists = 0;
> -		if (!ex) {
> -			/* there is no extent yet, so try to allocate
> -			 * all requested space */
> -			start = block;
> -			end = block + num;
> -		} else if (le32_to_cpu(ex->ee_block) > block) {
> -			/* need to allocate space before found extent */
> -			start = block;
> -			end = le32_to_cpu(ex->ee_block);
> -			if (block + num < end)
> -				end = block + num;
> -		} else if (block >= le32_to_cpu(ex->ee_block)
> -					+ ext4_ext_get_actual_len(ex)) {
> -			/* need to allocate space after found extent */
> -			start = block;
> -			end = block + num;
> -			if (end >= next)
> -				end = next;
> -		} else if (block >= le32_to_cpu(ex->ee_block)) {
> -			/*
> -			 * some part of requested space is covered
> -			 * by found extent
> -			 */
> -			start = block;
> -			end = le32_to_cpu(ex->ee_block)
> -				+ ext4_ext_get_actual_len(ex);
> -			if (block + num < end)
> -				end = block + num;
> -			exists = 1;
> -		} else {
> -			BUG();
> -		}
> -		BUG_ON(end <= start);
> -
> -		if (!exists) {
> -			cbex.ec_block = start;
> -			cbex.ec_len = end - start;
> -			cbex.ec_start = 0;
> -			cbex.ec_type = EXT4_EXT_CACHE_GAP;
> -		} else {
> -			cbex.ec_block = le32_to_cpu(ex->ee_block);
> -			cbex.ec_len = ext4_ext_get_actual_len(ex);
> -			cbex.ec_start = ext_pblock(ex);
> -			cbex.ec_type = EXT4_EXT_CACHE_EXTENT;
> -		}
> -
> -		BUG_ON(cbex.ec_len == 0);
> -		err = func(inode, path, &cbex, cbdata);
> -		ext4_ext_drop_refs(path);
> -
> -		if (err < 0)
> -			break;
> -		if (err == EXT_REPEAT)
> -			continue;
> -		else if (err == EXT_BREAK) {
> -			err = 0;
> -			break;
> -		}
> -
> -		if (ext_depth(inode) != depth) {
> -			/* depth was changed. we have to realloc path */
> -			kfree(path);
> -			path = NULL;
> -		}
> -
> -		block = cbex.ec_block + cbex.ec_len;
> -	}
> -
> -	if (path) {
> -		ext4_ext_drop_refs(path);
> -		kfree(path);
> -	}
> -
> -	return err;
> -}
> -
> static void
> -ext4_ext_put_in_cache(struct inode *inode, __u32 block,
> +ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
> 			__u32 len, ext4_fsblk_t start, int type)
> {
> 	struct ext4_ext_cache *cex;
> @@ -1703,10 +1601,11 @@ ext4_ext_put_in_cache(struct inode *inode, __u32 block,
>  */
> static void
> ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
> -				unsigned long block)
> +				ext4_lblk_t block)
> {
> 	int depth = ext_depth(inode);
> -	unsigned long lblock, len;
> +	unsigned long len;
> +	ext4_lblk_t lblock;
> 	struct ext4_extent *ex;
> 
> 	ex = path[depth].p_ext;
> @@ -1743,7 +1642,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
> }
> 
> static int
> -ext4_ext_in_cache(struct inode *inode, unsigned long block,
> +ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
> 			struct ext4_extent *ex)
> {
> 	struct ext4_ext_cache *cex;
> @@ -2238,9 +2137,9 @@ void ext4_ext_release(struct super_block *sb)
>  *   b> Splits in two extents: Write is happening at either end of the extent
>  *   c> Splits in three extents: Somone is writing in middle of the extent
>  */
> -int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
> +static int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
> 					struct ext4_ext_path *path,
> -					ext4_fsblk_t iblock,
> +					ext4_lblk_t iblock,
> 					unsigned long max_blocks)
> {
> 	struct ext4_extent *ex, newex;
> @@ -2374,7 +2273,7 @@ out:
>  * mutex_lock(&EXT4_I(inode)->truncate_mutex);
>  */
> int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> -			ext4_fsblk_t iblock,
> +			ext4_lblk_t iblock,
> 			unsigned long max_blocks, struct buffer_head *bh_result,
> 			int create, int extend_disksize)
> {
> @@ -2387,8 +2286,9 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> 	struct ext4_allocation_request ar;
> 
> 	__clear_bit(BH_New, &bh_result->b_state);
> -	ext_debug("blocks %d/%lu requested for inode %u\n", (int) iblock,
> -			max_blocks, (unsigned) inode->i_ino);
> +	ext_debug("blocks %lu/%lu requested for inode %u\n",
> +			(unsigned long) iblock, max_blocks,
> +			(unsigned) inode->i_ino);
> 
> 	/* check in cache */
> 	goal = ext4_ext_in_cache(inode, iblock, &newex);
> @@ -2436,7 +2336,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> 
> 	ex = path[depth].p_ext;
> 	if (ex) {
> -		unsigned long ee_block = le32_to_cpu(ex->ee_block);
> +		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
> 		ext4_fsblk_t ee_start = ext_pblock(ex);
> 		unsigned short ee_len;
> 
> @@ -2686,7 +2586,8 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
> long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> {
> 	handle_t *handle;
> -	ext4_fsblk_t block, max_blocks;
> +	ext4_lblk_t block;
> +	unsigned long max_blocks;
> 	ext4_fsblk_t nblocks = 0;
> 	int ret = 0;
> 	int ret2 = 0;
> @@ -2731,8 +2632,9 @@ retry:
> 		if (!ret) {
> 			ext4_error(inode->i_sb, "ext4_fallocate",
> 				   "ext4_ext_get_blocks returned 0! inode#%lu"
> -				   ", block=%llu, max_blocks=%llu",
> -				   inode->i_ino, block, max_blocks);
> +				   ", block=%lu, max_blocks=%lu",
> +				   inode->i_ino, (unsigned long)block,
> +				   (unsigned long)max_blocks);
> 			ret = -EIO;
> 			ext4_mark_inode_dirty(handle, inode);
> 			ret2 = ext4_journal_stop(handle);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 33ffd14..ca4e125 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -107,7 +107,7 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
>  */
> static unsigned long blocks_for_truncate(struct inode *inode)
> {
> -	unsigned long needed;
> +	ext4_lblk_t needed;
> 
> 	needed = inode->i_blocks >> (inode->i_sb->s_blocksize_bits - 9);
> 
> @@ -277,7 +277,8 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
>  */
> 
> static int ext4_block_to_path(struct inode *inode,
> -			long i_block, int offsets[4], int *boundary)
> +			ext4_lblk_t i_block,
> +			ext4_lblk_t offsets[4], int *boundary)
> {
> 	int ptrs = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> 	int ptrs_bits = EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb);
> @@ -345,7 +346,8 @@ static int ext4_block_to_path(struct inode *inode,
>  *      Need to be called with
>  *      mutex_lock(&EXT4_I(inode)->truncate_mutex)
>  */
> -static Indirect *ext4_get_branch(struct inode *inode, int depth, int *offsets,
> +static Indirect *ext4_get_branch(struct inode *inode, int depth,
> +				 ext4_lblk_t  *offsets,
> 				 Indirect chain[4], int *err)
> {
> 	struct super_block *sb = inode->i_sb;
> @@ -434,7 +436,7 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
>  *	stores it in *@goal and returns zero.
>  */
> 
> -static ext4_fsblk_t ext4_find_goal(struct inode *inode, long block,
> +static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,
> 		Indirect chain[4], Indirect *partial)
> {
> 	struct ext4_block_alloc_info *block_i;
> @@ -579,7 +581,7 @@ failed_out:
>  */
> static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
> 			int indirect_blks, int *blks, ext4_fsblk_t goal,
> -			int *offsets, Indirect *branch)
> +			ext4_lblk_t *offsets, Indirect *branch)
> {
> 	int blocksize = inode->i_sb->s_blocksize;
> 	int i, n = 0;
> @@ -669,7 +671,7 @@ failed:
>  * chain to new block and return 0.
>  */
> static int ext4_splice_branch(handle_t *handle, struct inode *inode,
> -			long block, Indirect *where, int num, int blks)
> +			ext4_lblk_t block, Indirect *where, int num, int blks)
> {
> 	int i;
> 	int err = 0;
> @@ -777,12 +779,12 @@ err_out:
>  * mutex_lock(&EXT4_I(inode)->truncate_mutex)
>  */
> int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
> -		sector_t iblock, unsigned long maxblocks,
> +		ext4_lblk_t iblock, unsigned long maxblocks,
> 		struct buffer_head *bh_result,
> 		int create, int extend_disksize)
> {
> 	int err = -EIO;
> -	int offsets[4];
> +	ext4_lblk_t offsets[4];
> 	Indirect chain[4];
> 	Indirect *partial;
> 	ext4_fsblk_t goal;
> @@ -796,7 +798,8 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
> 
> 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
> 	J_ASSERT(handle != NULL || create == 0);
> -	depth = ext4_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
> +	depth = ext4_block_to_path(inode, iblock, offsets,
> +					&blocks_to_boundary);
> 
> 	if (depth == 0)
> 		goto out;
> @@ -945,7 +948,7 @@ get_block:
>  * `handle' can be NULL if create is zero
>  */
> struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
> -				long block, int create, int *errp)
> +				ext4_lblk_t block, int create, int *errp)
> {
> 	struct buffer_head dummy;
> 	int fatal = 0, err;
> @@ -1012,7 +1015,7 @@ err:
> }
> 
> struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
> -			       int block, int create, int *err)
> +			       ext4_lblk_t block, int create, int *err)
> {
> 	struct buffer_head * bh;
> 
> @@ -1869,7 +1872,8 @@ int ext4_block_truncate_page(handle_t *handle, struct page *page,
> {
> 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
> 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
> -	unsigned blocksize, iblock, length, pos;
> +	unsigned blocksize, length, pos;
> +	ext4_lblk_t iblock;
> 	struct inode *inode = mapping->host;
> 	struct buffer_head *bh;
> 	int err = 0;
> @@ -2005,7 +2009,7 @@ static inline int all_zeroes(__le32 *p, __le32 *q)
>  *			(no partially truncated stuff there).  */
> 
> static Indirect *ext4_find_shared(struct inode *inode, int depth,
> -			int offsets[4], Indirect chain[4], __le32 *top)
> +			ext4_lblk_t offsets[4], Indirect chain[4], __le32 *top)
> {
> 	Indirect *partial, *p;
> 	int k, err;
> @@ -2330,12 +2334,12 @@ void ext4_truncate(struct inode *inode)
> 	__le32 *i_data = ei->i_data;
> 	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> 	struct address_space *mapping = inode->i_mapping;
> -	int offsets[4];
> +	ext4_lblk_t offsets[4];
> 	Indirect chain[4];
> 	Indirect *partial;
> 	__le32 nr = 0;
> 	int n;
> -	long last_block;
> +	ext4_lblk_t last_block;
> 	unsigned blocksize = inode->i_sb->s_blocksize;
> 	struct page *page;
> 
> @@ -2710,6 +2714,7 @@ void ext4_read_inode(struct inode * inode)
> 	struct ext4_inode_info *ei = EXT4_I(inode);
> 	struct buffer_head *bh;
> 	int block;
> +	struct super_block *sb = inode->i_sb;
> 
> #ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
> 	ei->i_acl = EXT4_ACL_NOT_CACHED;
> @@ -2751,7 +2756,17 @@ void ext4_read_inode(struct inode * inode)
> 		 * recovery code: that's fine, we're about to complete
> 		 * the process of deleting those. */
> 	}
> -	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)) {
> +		/*
> +		 * The filesystem inode i_blocks is represented in terms of
> +		 * file system blocks size.
> +		 * vfs inode i_blocks = (x* filesystemblocksize)/512
> +		 */
> +		inode->i_blocks = (blkcnt_t)le32_to_cpu(raw_inode->i_blocks) <<
> +						(inode->i_blkbits - 9);
> +	} else {
> +		inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
> +	}
> 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
> 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
> 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> @@ -2860,6 +2875,7 @@ static int ext4_do_update_inode(handle_t *handle,
> 	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
> 	struct ext4_inode_info *ei = EXT4_I(inode);
> 	struct buffer_head *bh = iloc->bh;
> +	struct super_block *sb = inode->i_sb;
> 	int err = 0, rc, block;
> 
> 	/* For fields not not tracking in the in-memory inode,
> @@ -2901,7 +2917,12 @@ static int ext4_do_update_inode(handle_t *handle,
> 	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
> 	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
> 
> -	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)) {
> +		raw_inode->i_blocks = cpu_to_le32(inode->i_blocks >>
> +							(inode->i_blkbits - 9));
> +	} else {
> +		raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
> +	}
> 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
> 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
> 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index af21e35..ca10875 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -349,7 +349,7 @@ struct ext4_prealloc_space {
> 	atomic_t		pa_count;
> 	unsigned		pa_deleted;
> 	ext4_fsblk_t		pa_pstart;	/* phys. block */
> -	unsigned long		pa_lstart;	/* log. block */
> +	ext4_lblk_t		pa_lstart;	/* log. block */
> 	unsigned short		pa_len;		/* len of preallocated chunk */
> 	unsigned short		pa_free;	/* how many blocks are free */
> 	unsigned short		pa_linear;	/* consumed in one direction
> @@ -360,7 +360,7 @@ struct ext4_prealloc_space {
> 
> 
> struct ext4_free_extent {
> -	unsigned long fe_logical;
> +	ext4_lblk_t fe_logical;
> 	ext4_grpblk_t fe_start;
> 	ext4_grpnum_t fe_group;
> 	unsigned long fe_len;
> @@ -550,41 +550,6 @@ static inline void mb_clear_bit_atomic(int bit, void *addr)
> 	ext4_clear_bit_atomic(NULL, bit, addr);
> }
> 
> -static inline int mb_find_next_zero_bit(void *addr, int max, int start)
> -{
> -	int fix;
> -#if BITS_PER_LONG == 64
> -	fix = ((unsigned long) addr & 7UL) << 3;
> -	addr = (void *) ((unsigned long) addr & ~7UL);
> -#elif BITS_PER_LONG == 32
> -	fix = ((unsigned long) addr & 3UL) << 3;
> -	addr = (void *) ((unsigned long) addr & ~3UL);
> -#else
> -#error "how many bits you are?!"
> -#endif
> -	max += fix;
> -	start += fix;
> -	return ext4_find_next_zero_bit(addr, max, start) - fix;
> -}
> -
> -static inline int mb_find_next_bit(void *addr, int max, int start)
> -{
> -	int fix;
> -#if BITS_PER_LONG == 64
> -	fix = ((unsigned long) addr & 7UL) << 3;
> -	addr = (void *) ((unsigned long) addr & ~7UL);
> -#elif BITS_PER_LONG == 32
> -	fix = ((unsigned long) addr & 3UL) << 3;
> -	addr = (void *) ((unsigned long) addr & ~3UL);
> -#else
> -#error "how many bits you are?!"
> -#endif
> -	max += fix;
> -	start += fix;
> -
> -	return ext4_find_next_bit(addr, max, start) - fix;
> -}
> -
> static inline void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
> {
> 	char *bb;
> @@ -2062,13 +2027,13 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
> 			"%-5u %-5s %-5u %-6u\n";
> 		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
> 			hs->result.fe_start, hs->result.fe_len,
> -			hs->result.fe_logical);
> +			(unsigned long)hs->result.fe_logical);
> 		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
> 			hs->orig.fe_start, hs->orig.fe_len,
> -			hs->orig.fe_logical);
> +			(unsigned long)hs->orig.fe_logical);
> 		sprintf(buf3, "%lu/%d/%lu@%lu", hs->goal.fe_group,
> 			hs->goal.fe_start, hs->goal.fe_len,
> -			hs->goal.fe_logical);
> +			(unsigned long)hs->goal.fe_logical);
> 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, buf3, buf2,
> 				hs->found, hs->groups, hs->cr, hs->flags,
> 				hs->merged ? "M" : "", hs->tail,
> @@ -2077,10 +2042,10 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
> 		fmt = "%-5u %-8u %-23s %-23s %-23s\n";
> 		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
> 			hs->result.fe_start, hs->result.fe_len,
> -			hs->result.fe_logical);
> +			(unsigned long)hs->result.fe_logical);
> 		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
> 			hs->orig.fe_start, hs->orig.fe_len,
> -			hs->orig.fe_logical);
> +			(unsigned long)hs->orig.fe_logical);
> 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, "", buf2);
> 	} else if (hs->op == EXT4_MB_HISTORY_DISCARD) {
> 		sprintf(buf2, "%lu/%d/%lu", hs->result.fe_group,
> @@ -3075,17 +3040,14 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
> static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
> 				struct ext4_allocation_request *ar)
> {
> +	unsigned long wind;
> +	int bsbits, i;
> +	ext4_lblk_t end;
> +	struct list_head *cur;
> +	loff_t size, orig_size;
> +	ext4_lblk_t start, orig_start;
> 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
> 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
> -	loff_t start;
> -	loff_t end;
> -	loff_t size;
> -	loff_t orig_size;
> -	loff_t orig_start;
> -	loff_t wind;
> -	struct list_head *cur;
> -	int bsbits;
> -	int i;
> 
> 	/* do normalize only data requests, metadata requests
> 	   do not need preallocation */
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 3a306b8..b54c084 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -17,7 +17,7 @@
> #include <linux/ext4_fs_extents.h>
> 
> struct list_blocks_struct {
> -	int first_block, last_block;
> +	ext4_lblk_t first_block, last_block;
> 	ext4_fsblk_t first_pblock, last_pblock;
> };
> 
> @@ -85,7 +85,7 @@ err_out:
> 	return retval;
> }
> static int update_extent_range(handle_t *handle, struct inode *inode,
> -				ext4_fsblk_t pblock, int blk_num,
> +				ext4_fsblk_t pblock, ext4_lblk_t blk_num,
> 				struct list_blocks_struct *lb)
> {
> 	int retval;
> @@ -112,13 +112,13 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
> }
> 
> static int update_ind_extent_range(handle_t *handle, struct inode *inode,
> -					ext4_fsblk_t pblock, int *blk_nump,
> -					struct list_blocks_struct *lb)
> +				   ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
> +				   struct list_blocks_struct *lb)
> {
> 	struct buffer_head *bh;
> 	__le32 *i_data;
> 	int i, retval = 0;
> -	int blk_count = *blk_nump;
> +	ext4_lblk_t blk_count = *blk_nump;
> 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> 
> 	if (!pblock) {
> @@ -150,13 +150,13 @@ static int update_ind_extent_range(handle_t *handle, struct inode *inode,
> 
> }
> static int update_dind_extent_range(handle_t *handle, struct inode *inode,
> -					ext4_fsblk_t pblock, int *blk_nump,
> -					struct list_blocks_struct *lb)
> +				    ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
> +				    struct list_blocks_struct *lb)
> {
> 	struct buffer_head *bh;
> 	__le32 *i_data;
> 	int i, retval = 0;
> -	int blk_count = *blk_nump;
> +	ext4_lblk_t blk_count = *blk_nump;
> 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> 
> 	if (!pblock) {
> @@ -191,13 +191,13 @@ static int update_dind_extent_range(handle_t *handle, struct inode *inode,
> 
> }
> static int update_tind_extent_range(handle_t *handle, struct inode *inode,
> -					ext4_fsblk_t pblock, int *blk_nump,
> -					struct list_blocks_struct *lb)
> +				     ext4_fsblk_t pblock, ext4_lblk_t *blk_nump,
> +				     struct list_blocks_struct *lb)
> {
> 	struct buffer_head *bh;
> 	__le32 *i_data;
> 	int i, retval = 0;
> -	int blk_count = *blk_nump;
> +	ext4_lblk_t blk_count = *blk_nump;
> 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> 
> 	if (!pblock) {
> @@ -445,7 +445,7 @@ int ext4_ext_migrate(struct inode * inode, struct file * filp,
> 	handle_t *handle;
> 	int retval = 0, i;
> 	__le32 *i_data;
> -	int blk_count = 0;
> +	ext4_lblk_t blk_count = 0;
> 	struct ext4_inode_info *ei;
> 	struct inode *tmp_inode = NULL;
> 	struct list_blocks_struct lb;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index e0f5ba6..efc9625 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -51,7 +51,7 @@
> 
> static struct buffer_head *ext4_append(handle_t *handle,
> 					struct inode *inode,
> -					u32 *block, int *err)
> +					ext4_lblk_t *block, int *err)
> {
> 	struct buffer_head *bh;
> 
> @@ -144,8 +144,8 @@ struct dx_map_entry
> 	u16 size;
> };
> 
> -static inline unsigned dx_get_block (struct dx_entry *entry);
> -static void dx_set_block (struct dx_entry *entry, unsigned value);
> +static inline ext4_lblk_t dx_get_block (struct dx_entry *entry);
> +static void dx_set_block (struct dx_entry *entry, ext4_lblk_t value);
> static inline unsigned dx_get_hash (struct dx_entry *entry);
> static void dx_set_hash (struct dx_entry *entry, unsigned value);
> static unsigned dx_get_count (struct dx_entry *entries);
> @@ -166,7 +166,8 @@ static void dx_sort_map(struct dx_map_entry *map, unsigned count);
> static struct ext4_dir_entry_2 *dx_move_dirents (char *from, char *to,
> 		struct dx_map_entry *offsets, int count);
> static struct ext4_dir_entry_2* dx_pack_dirents (char *base, int size);
> -static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
> +static void dx_insert_block (struct dx_frame *frame,
> +					u32 hash, ext4_lblk_t block);
> static int ext4_htree_next_block(struct inode *dir, __u32 hash,
> 				 struct dx_frame *frame,
> 				 struct dx_frame *frames,
> @@ -181,12 +182,12 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  * Mask them off for now.
>  */
> 
> -static inline unsigned dx_get_block (struct dx_entry *entry)
> +static inline ext4_lblk_t dx_get_block (struct dx_entry *entry)
> {
> 	return le32_to_cpu(entry->block) & 0x00ffffff;
> }
> 
> -static inline void dx_set_block (struct dx_entry *entry, unsigned value)
> +static inline void dx_set_block (struct dx_entry *entry, ext4_lblk_t value)
> {
> 	entry->block = cpu_to_le32(value);
> }
> @@ -243,8 +244,8 @@ static void dx_show_index (char * label, struct dx_entry *entries)
> 	int i, n = dx_get_count (entries);
> 	printk("%s index ", label);
> 	for (i = 0; i < n; i++) {
> -		printk("%x->%u ", i? dx_get_hash(entries + i) :
> -				0, dx_get_block(entries + i));
> +		printk("%x->%lu ", i? dx_get_hash(entries + i) :
> +				0, (unsigned long)dx_get_block(entries + i));
> 	}
> 	printk("\n");
> }
> @@ -297,7 +298,8 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
> 	printk("%i indexed blocks...\n", count);
> 	for (i = 0; i < count; i++, entries++)
> 	{
> -		u32 block = dx_get_block(entries), hash = i? dx_get_hash(entries): 0;
> +		ext4_lblk_t block = dx_get_block(entries),
> +						hash = i? dx_get_hash(entries): 0;
> 		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
> 		struct stats stats;
> 		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
> @@ -560,7 +562,7 @@ static inline struct ext4_dir_entry_2 *ext4_next_entry(struct ext4_dir_entry_2 *
>  * into the tree.  If there is an error it is returned in err.
>  */
> static int htree_dirblock_to_tree(struct file *dir_file,
> -				  struct inode *dir, int block,
> +				  struct inode *dir, ext4_lblk_t block,
> 				  struct dx_hash_info *hinfo,
> 				  __u32 start_hash, __u32 start_minor_hash)
> {
> @@ -568,7 +570,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
> 	struct ext4_dir_entry_2 *de, *top;
> 	int err, count = 0;
> 
> -	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
> +	dxtrace(printk("In htree dirblock_to_tree: block %lu\n",
> +							(unsigned long)block));
> 	if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
> 		return err;
> 
> @@ -620,9 +623,9 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
> 	struct ext4_dir_entry_2 *de;
> 	struct dx_frame frames[2], *frame;
> 	struct inode *dir;
> -	int block, err;
> +	ext4_lblk_t block;
> 	int count = 0;
> -	int ret;
> +	int ret, err;
> 	__u32 hashval;
> 
> 	dxtrace(printk("In htree_fill_tree, start hash: %x:%x\n", start_hash,
> @@ -752,7 +755,7 @@ static void dx_sort_map (struct dx_map_entry *map, unsigned count)
> 	} while(more);
> }
> 
> -static void dx_insert_block(struct dx_frame *frame, u32 hash, u32 block)
> +static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
> {
> 	struct dx_entry *entries = frame->entries;
> 	struct dx_entry *old = frame->at, *new = old + 1;
> @@ -847,13 +850,14 @@ static struct buffer_head * ext4_find_entry (struct dentry *dentry,
> 	struct super_block * sb;
> 	struct buffer_head * bh_use[NAMEI_RA_SIZE];
> 	struct buffer_head * bh, *ret = NULL;
> -	unsigned long start, block, b;
> +	ext4_lblk_t start, block, b;
> 	int ra_max = 0;		/* Number of bh's in the readahead
> 				   buffer, bh_use[] */
> 	int ra_ptr = 0;		/* Current index into readahead
> 				   buffer */
> 	int num = 0;
> -	int nblocks, i, err;
> +	ext4_lblk_t  nblocks;
> +	int i, err;
> 	struct inode *dir = dentry->d_parent->d_inode;
> 	int namelen;
> 	const u8 *name;
> @@ -914,7 +918,7 @@ restart:
> 		if (!buffer_uptodate(bh)) {
> 			/* read error, skip block & hope for the best */
> 			ext4_error(sb, __FUNCTION__, "reading directory #%lu "
> -				   "offset %lu", dir->i_ino, block);
> +				   "offset %lu", dir->i_ino, (unsigned long)block);
> 			brelse(bh);
> 			goto next;
> 		}
> @@ -961,7 +965,7 @@ static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
> 	struct dx_frame frames[2], *frame;
> 	struct ext4_dir_entry_2 *de, *top;
> 	struct buffer_head *bh;
> -	unsigned long block;
> +	ext4_lblk_t block;
> 	int retval;
> 	int namelen = dentry->d_name.len;
> 	const u8 *name = dentry->d_name.name;
> @@ -1174,7 +1178,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> 	unsigned blocksize = dir->i_sb->s_blocksize;
> 	unsigned count, continued;
> 	struct buffer_head *bh2;
> -	u32 newblock;
> +	ext4_lblk_t newblock;
> 	u32 hash2;
> 	struct dx_map_entry *map;
> 	char *data1 = (*bh)->b_data, *data2;
> @@ -1221,8 +1225,9 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> 	split = count - move;
> 	hash2 = map[split].hash;
> 	continued = hash2 == map[split - 1].hash;
> -	dxtrace(printk("Split block %i at %x, %i/%i\n",
> -		dx_get_block(frame->at), hash2, split, count-split));
> +	dxtrace(printk("Split block %lu at %x, %i/%i\n",
> +			(unsigned long)dx_get_block(frame->at),
> +					hash2, split, count-split));
> 
> 	/* Fancy dance to stay within two buffers */
> 	de2 = dx_move_dirents(data1, data2, map + split, count - split);
> @@ -1373,7 +1378,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> 	int		retval;
> 	unsigned	blocksize;
> 	struct dx_hash_info hinfo;
> -	u32		block;
> +	ext4_lblk_t  block;
> 	struct fake_dirent *fde;
> 
> 	blocksize =  dir->i_sb->s_blocksize;
> @@ -1453,7 +1458,7 @@ static int ext4_add_entry (handle_t *handle, struct dentry *dentry,
> 	int	retval;
> 	int	dx_fallback=0;
> 	unsigned blocksize;
> -	u32 block, blocks;
> +	ext4_lblk_t block, blocks;
> 
> 	sb = dir->i_sb;
> 	blocksize = sb->s_blocksize;
> @@ -1530,7 +1535,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 		       dx_get_count(entries), dx_get_limit(entries)));
> 	/* Need to split index? */
> 	if (dx_get_count(entries) == dx_get_limit(entries)) {
> -		u32 newblock;
> +		ext4_lblk_t newblock;
> 		unsigned icount = dx_get_count(entries);
> 		int levels = frame - frames;
> 		struct dx_entry *entries2;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 5a68910..3d849e8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1506,14 +1506,44 @@ static void ext4_orphan_cleanup (struct super_block * sb,
>  * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
>  * We need to be 1 filesystem block less than the 2^32 sector limit.
>  */
> -static loff_t ext4_max_size(int bits)
> +static loff_t ext4_max_size(int bits, struct super_block *sb)
> {
> 	loff_t res = EXT4_NDIR_BLOCKS;
> +	int meta_blocks;
> 	/* This constant is calculated to be the largest file size for a
> -	 * dense, 4k-blocksize file such that the total number of
> +	 * dense file such that the total number of
> 	 * sectors in the file, including data and all indirect blocks,
> -	 * does not exceed 2^32. */
> -	const loff_t upper_limit = 0x1ff7fffd000LL;
> +	 * does not exceed 2^32 -1. */
> +	loff_t upper_limit;
> +
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)) {
> +		/*
> +		 * With __u32 i_blocks representing the total number of blocks
> +		 * of the file in file system block size, the max file size
> +		 * would be 2**(bits+32) - 1 - blocks taken by the meta data
> +		 * blocks multiplied by block size.
> +		 */
> +		/* total blocks in file system block size*/
> +		upper_limit = (1LL << 32) - 1;
> +
> +	} else {
> +		/* total blocks in 512 bytes */
> +		upper_limit = (1LL << 32) - 1;
> +		/* total blocks in file system block size */
> +		upper_limit >>= (bits - 9);
> +
> +		//upper_limit = 0x1ff7fffd000LL;
> +	}
> +
> +	/* indirect blocks */
> +	meta_blocks = 1;
> +	/* double indirect blocks */
> +	meta_blocks += 1 + (1LL << (bits-2));
> +	/* tripple indirect blocks */
> +	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
> +
> +	upper_limit -= meta_blocks;
> +	upper_limit <<= bits;
> 
> 	res += 1LL << (bits-2);
> 	res += 1LL << (2*(bits-2));
> @@ -1679,6 +1709,19 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
> 		       sb->s_id, le32_to_cpu(features));
> 		goto failed_mount;
> 	}
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)) {
> +		/*
> +		 * Large file size enabled file system can only be
> +		 * mount if kernel is build with CONFIG_LSF
> +		 */
> +		if (sizeof(root->i_blocks) < sizeof(u64)) {
> +			printk(KERN_ERR "EXT4-fs: %s: Unsupported large block "\
> +					"option with LSF disabled.\n", sb->s_id);
> +			goto failed_mount;
> +		}
> +
> +	}
> +
> 	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
> 
> 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
> @@ -1720,7 +1763,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
> 		}
> 	}
> 
> -	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits);
> +	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, sb);
> 
> 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
> 		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
> @@ -2873,7 +2916,7 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
> 			       size_t len, loff_t off)
> {
> 	struct inode *inode = sb_dqopt(sb)->files[type];
> -	sector_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
> +	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
> 	int err = 0;
> 	int offset = off & (sb->s_blocksize - 1);
> 	int tocopy;
> @@ -2911,7 +2954,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
> 				const char *data, size_t len, loff_t off)
> {
> 	struct inode *inode = sb_dqopt(sb)->files[type];
> -	sector_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
> +	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
> 	int err = 0;
> 	int offset = off & (sb->s_blocksize - 1);
> 	int tocopy;
> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
> index c0ad0fc..9cef9ed 100644
> --- a/include/linux/ext4_fs.h
> +++ b/include/linux/ext4_fs.h
> @@ -68,11 +68,11 @@
> 
> struct ext4_allocation_request {
> 	struct inode *inode;	/* target inode for block we're allocating */
> -	ext4_fsblk_t logical;	/* logical block in target inode */
> +	ext4_lblk_t logical;	/* logical block in target inode */
> 	ext4_fsblk_t goal;	/* phys. target (a hint) */
> -	ext4_fsblk_t lleft;	/* the closest logical allocated block to the left */
> +	ext4_lblk_t lleft;	/* the closest logical allocated block to the left */
> 	ext4_fsblk_t pleft;	/* phys. block for ^^^ */
> -	ext4_fsblk_t lright;	/* the closest logical allocated block to the right */
> +	ext4_lblk_t lright;	/* the closest logical allocated block to the right */
> 	ext4_fsblk_t pright;	/* phys. block for ^^^ */
> 	unsigned long len;	/* how many blocks we want to allocate */
> 	unsigned long flags;	/* flags. see above EXT4_MB_HINT_* */
> @@ -717,7 +717,9 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
> #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
> #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
> #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
> +#define EXT4_FEATURE_INCOMPAT_MMP               0x0100
> #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
> +#define EXT4_FEATURE_INCOMPAT_LARGE_BLOCK	0x0400
> 
> #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
> #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
> @@ -725,7 +727,9 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
> 					 EXT4_FEATURE_INCOMPAT_META_BG| \
> 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
> 					 EXT4_FEATURE_INCOMPAT_64BIT| \
> -					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
> +					 EXT4_FEATURE_INCOMPAT_MMP|\
> +					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
> +					 EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)
> #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
> 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
> @@ -964,10 +968,12 @@ extern void ext4_mb_free_blocks(handle_t *, struct inode *,
> /* inode.c */
> int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
> 		struct buffer_head *bh, ext4_fsblk_t blocknr);
> -struct buffer_head * ext4_getblk (handle_t *, struct inode *, long, int, int *);
> -struct buffer_head * ext4_bread (handle_t *, struct inode *, int, int, int *);
> +struct buffer_head * ext4_getblk(handle_t *, struct inode *,
> +						ext4_lblk_t, int, int *);
> +struct buffer_head * ext4_bread(handle_t *, struct inode *,
> +						ext4_lblk_t, int, int *);
> int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
> -	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
> +	ext4_lblk_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
> 	int create, int extend_disksize);
> 
> extern void ext4_read_inode (struct inode *);
> @@ -1100,7 +1106,7 @@ extern const struct inode_operations ext4_fast_symlink_inode_operations;
> extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
> extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
> extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> -			ext4_fsblk_t iblock,
> +			ext4_lblk_t iblock,
> 			unsigned long max_blocks, struct buffer_head *bh_result,
> 			int create, int extend_disksize);
> extern void ext4_ext_truncate(struct inode *, struct page *);
> @@ -1116,11 +1122,13 @@ ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> 	int retval;
> 	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
> -		retval = ext4_ext_get_blocks(handle, inode, block, max_blocks,
> -					bh, create, extend_disksize);
> +		retval = ext4_ext_get_blocks(handle, inode,
> +						(ext4_lblk_t)block, max_blocks,
> +						bh, create, extend_disksize);
> 	} else {
> -		retval = ext4_get_blocks_handle(handle, inode, block, max_blocks,
> -					bh, create, extend_disksize);
> +		retval = ext4_get_blocks_handle(handle, inode,
> +						(ext4_lblk_t)block, max_blocks,
> +						bh, create, extend_disksize);
> 	}
> 	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
> 
> diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
> index 149fd4b..36b9bb0 100644
> --- a/include/linux/ext4_fs_extents.h
> +++ b/include/linux/ext4_fs_extents.h
> @@ -124,20 +124,6 @@ struct ext4_ext_path {
> #define EXT4_EXT_CACHE_GAP	1
> #define EXT4_EXT_CACHE_EXTENT	2
> 
> -/*
> - * to be called by ext4_ext_walk_space()
> - * negative retcode - error
> - * positive retcode - signal for ext4_ext_walk_space(), see below
> - * callback must return valid extent (passed or newly created)
> - */
> -typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
> -					struct ext4_ext_cache *,
> -					void *);
> -
> -#define EXT_CONTINUE	0
> -#define EXT_BREAK	1
> -#define EXT_REPEAT	2
> -
> 
> #define EXT_MAX_BLOCK	0xffffffff
> 
> @@ -233,10 +219,11 @@ extern int ext4_ext_try_to_merge(struct inode *inode,
> 				 struct ext4_extent *);
> extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
> extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
> -extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
> -extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
> -
> -extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
> -extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
> +extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, ext4_lblk_t,
> +							struct ext4_ext_path *);
> +extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
> +						ext4_lblk_t *, ext4_fsblk_t *);
> +extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
> +						ext4_lblk_t *, ext4_fsblk_t *);
> #endif /* _LINUX_EXT4_EXTENTS */
> 
> diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
> index bf19a48..94baea0 100644
> --- a/include/linux/ext4_fs_i.h
> +++ b/include/linux/ext4_fs_i.h
> @@ -27,6 +27,9 @@ typedef int ext4_grpblk_t;
> /* data type for filesystem-wide blocks number */
> typedef unsigned long long ext4_fsblk_t;
> 
> +/* data type for file logical block number */
> +typedef __u32 ext4_lblk_t;
> +
> /* data type for block group number */
> typedef unsigned long ext4_grpnum_t;
> 
> @@ -51,7 +54,7 @@ struct ext4_block_alloc_info {
> 	 * most-recently-allocated block in this file.
> 	 * We use this for detecting linearly ascending allocation requests.
> 	 */
> -	__u32 last_alloc_logical_block;
> +	ext4_lblk_t last_alloc_logical_block;
> 	/*
> 	 * Was i_next_alloc_goal in ext4_inode_info
> 	 * is the *physical* companion to i_next_alloc_block.
> @@ -70,7 +73,7 @@ struct ext4_block_alloc_info {
>  */
> struct ext4_ext_cache {
> 	ext4_fsblk_t	ec_start;
> -	__u32		ec_block;
> +	ext4_lblk_t	ec_block;
> 	__u32		ec_len; /* must be 32bit to return holes */
> 	__u32		ec_type;
> };
> @@ -98,7 +101,7 @@ struct ext4_inode_info {
> 	/* block reservation info */
> 	struct ext4_block_alloc_info *i_block_alloc_info;
> 
> -	__u32	i_dir_start_lookup;
> +	ext4_lblk_t		i_dir_start_lookup;
> #ifdef CONFIG_EXT4DEV_FS_XATTR
> 	/*
> 	 * Extended attributes can be read independently of the main file
> 
