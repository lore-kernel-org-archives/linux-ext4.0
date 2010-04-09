From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond i_size
Date: Fri, 09 Apr 2010 21:18:18 +0400
Message-ID: <87mxxctuhx.fsf@openvz.org>
References: <1270833270-14087-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:44780 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0DIRSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Apr 2010 13:18:34 -0400
In-Reply-To: <1270833270-14087-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Fri, 9 Apr 2010 21:14:30 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 8bdee27..54a9b80 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1,3 +1,4 @@
> +
>  /*
>   * Copyright (c) 2003-2006, Cluster File Systems, Inc, info@clusterfs.com
>   * Written by Alex Tomas <alex@clusterfs.com>
> @@ -2540,9 +2541,11 @@ static void bi_complete(struct bio *bio, int error)
>  {
>  	complete((struct completion *)bio->bi_private);
>  }
> -
> +#define ext4_ext_zeroout(inode,ext_nn) \
> +	__ext4_ext_zeroout(inode, ext_nn, iblock, max_blocks)
>  /* FIXME!! we need to try to merge to left or right after zero-out  */
> -static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
> +static int __ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex,
> +			ext4_lblk_t iblock, unsigned int max_blocks)
Oops, sorry, wrong patch attached :).
>  {
>  	int ret;
>  	struct bio *bio;
> @@ -2560,6 +2563,12 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
>  	/* convert ee_pblock to 512 byte sectors */
>  	ee_pblock = ee_pblock << (blkbits - 9);
>  
> +	printk("%s inode:%lu ext:[%d:%d] iblock:%d max:%d i_sz:%lld expand:%d\n",
> +		__FUNCTION__, inode->i_ino,
> +		le32_to_cpu(ex->ee_block), ee_len,
> +		iblock, max_blocks, inode->i_size,
> +		((inode->i_size +blocksize -1) >> blkbits) < iblock + max_blocks);
> +
>  	while (ee_len > 0) {
>  
>  		if (ee_len > BIO_MAX_PAGES)
> @@ -2631,11 +2640,15 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	struct ext4_extent *ex2 = NULL;
>  	struct ext4_extent *ex3 = NULL;
>  	struct ext4_extent_header *eh;
> -	ext4_lblk_t ee_block;
> +	ext4_lblk_t ee_block, eof_block;
>  	unsigned int allocated, ee_len, depth;
>  	ext4_fsblk_t newblock;
>  	int err = 0;
>  	int ret = 0;
> +	int may_zeroout;
> +	ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
> +		"block %llu, max_blocks %u ",
> +		inode->i_ino, (unsigned long long)iblock, max_blocks);
>  
>  	depth = ext_depth(inode);
>  	eh = path[depth].p_hdr;
> @@ -2644,16 +2657,25 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	ee_len = ext4_ext_get_actual_len(ex);
>  	allocated = ee_len - (iblock - ee_block);
>  	newblock = iblock - ee_block + ext_pblock(ex);
> +	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> +		inode->i_sb->s_blocksize_bits;
>  	ex2 = ex;
>  	orig_ex.ee_block = ex->ee_block;
>  	orig_ex.ee_len   = cpu_to_le16(ee_len);
>  	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
>  
> +	/*
> +	 * It is safe to convert extent to initialized via explicit
> +	 * zeroout only if extent is fully insde i_size or new_size.
> +	 */
> +	may_zeroout = ee_block + ee_len <= iblock + max_blocks ||
> +		ee_block + ee_len <= eof_block;
> +
>  	err = ext4_ext_get_access(handle, inode, path + depth);
>  	if (err)
>  		goto out;
>  	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
> -	if (ee_len <= 2*EXT4_EXT_ZERO_LEN) {
> +	if (ee_len <= 2*EXT4_EXT_ZERO_LEN && may_zeroout) {
>  		err =  ext4_ext_zeroout(inode, &orig_ex);
>  		if (err)
>  			goto fix_extent_len;
> @@ -2684,7 +2706,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	if (allocated > max_blocks) {
>  		unsigned int newdepth;
>  		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
> -		if (allocated <= EXT4_EXT_ZERO_LEN) {
> +		if (allocated <= EXT4_EXT_ZERO_LEN && may_zeroout) {
>  			/*
>  			 * iblock == ee_block is handled by the zerouout
>  			 * at the beginning.
> @@ -2760,7 +2782,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
>  		ext4_ext_mark_uninitialized(ex3);
>  		err = ext4_ext_insert_extent(handle, inode, path, ex3, 0);
> -		if (err == -ENOSPC) {
> +		if (err == -ENOSPC && may_zeroout) {
>  			err =  ext4_ext_zeroout(inode, &orig_ex);
>  			if (err)
>  				goto fix_extent_len;
> @@ -2784,8 +2806,11 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		 * update the extent length after successful insert of the
>  		 * split extent
>  		 */
> -		orig_ex.ee_len = cpu_to_le16(ee_len -
> -						ext4_ext_get_actual_len(ex3));
> +		ee_len -= ext4_ext_get_actual_len(ex3);
> +		orig_ex.ee_len = cpu_to_le16(ee_len);
> +		may_zeroout = ee_block + ee_len <= iblock + max_blocks ||
> +			ee_block + ee_len <= eof_block;
> +
>  		depth = newdepth;
>  		ext4_ext_drop_refs(path);
>  		path = ext4_ext_find_extent(inode, iblock, path);
> @@ -2809,7 +2834,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		 * otherwise give the extent a chance to merge to left
>  		 */
>  		if (le16_to_cpu(orig_ex.ee_len) <= EXT4_EXT_ZERO_LEN &&
> -							iblock != ee_block) {
> +			iblock != ee_block && may_zeroout) {
>  			err =  ext4_ext_zeroout(inode, &orig_ex);
>  			if (err)
>  				goto fix_extent_len;
> @@ -2878,7 +2903,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	goto out;
>  insert:
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> -	if (err == -ENOSPC) {
> +	if (err == -ENOSPC && may_zeroout) {
>  		err =  ext4_ext_zeroout(inode, &orig_ex);
>  		if (err)
>  			goto fix_extent_len;
> @@ -2938,14 +2963,16 @@ static int ext4_split_unwritten_extents(handle_t *handle,
>  	struct ext4_extent *ex2 = NULL;
>  	struct ext4_extent *ex3 = NULL;
>  	struct ext4_extent_header *eh;
> -	ext4_lblk_t ee_block;
> +	ext4_lblk_t ee_block, eof_block;
>  	unsigned int allocated, ee_len, depth;
>  	ext4_fsblk_t newblock;
>  	int err = 0;
> +	int may_zeroout;
>  
>  	ext_debug("ext4_split_unwritten_extents: inode %lu,"
>  		  "iblock %llu, max_blocks %u\n", inode->i_ino,
>  		  (unsigned long long)iblock, max_blocks);
> +
>  	depth = ext_depth(inode);
>  	eh = path[depth].p_hdr;
>  	ex = path[depth].p_ext;
> @@ -2953,10 +2980,19 @@ static int ext4_split_unwritten_extents(handle_t *handle,
>  	ee_len = ext4_ext_get_actual_len(ex);
>  	allocated = ee_len - (iblock - ee_block);
>  	newblock = iblock - ee_block + ext_pblock(ex);
> +	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> +		inode->i_sb->s_blocksize_bits;
> +
>  	ex2 = ex;
>  	orig_ex.ee_block = ex->ee_block;
>  	orig_ex.ee_len   = cpu_to_le16(ee_len);
>  	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
> +	/*
> +	 * It is safe to convert extent to initialized via explicit
> +	 * zeroout only if extent is fully insde i_size or new_size.
> +	 */
> +	may_zeroout = ee_block + ee_len <= iblock + max_blocks ||
> +		ee_block + ee_len <= eof_block;
>  
>  	/*
>   	 * If the uninitialized extent begins at the same logical
> @@ -2992,7 +3028,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
>  		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
>  		ext4_ext_mark_uninitialized(ex3);
>  		err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
> -		if (err == -ENOSPC) {
> +		if (err == -ENOSPC && may_zeroout) {
>  			err =  ext4_ext_zeroout(inode, &orig_ex);
>  			if (err)
>  				goto fix_extent_len;
> @@ -3063,7 +3099,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
>  	goto out;
>  insert:
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> -	if (err == -ENOSPC) {
> +	if (err == -ENOSPC && may_zeroout) {
>  		err =  ext4_ext_zeroout(inode, &orig_ex);
>  		if (err)
>  			goto fix_extent_len;
