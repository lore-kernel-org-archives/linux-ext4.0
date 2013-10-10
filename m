From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 17/31] libext2fs: Refactor u32-list to handle 32 and
 64-bit data types
Date: Thu, 10 Oct 2013 16:46:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310101537440.1925@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012831.28415.54890.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3JJOqc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Oct 2013 10:46:32 -0400
In-Reply-To: <20131001012831.28415.54890.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Sep 2013, Darrick J. Wong wrote:

> Date: Mon, 30 Sep 2013 18:28:31 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 17/31] libext2fs: Refactor u32-list to handle 32 and 64-bit
>     data types
> 
> The curernt ext2_u32_list implementation manages a sorted sparse list of 32-bit
> numbers.  This is currently used to collect directory inodes for rehashing in
> e2fsck, and creating a list of bad blocks for mkfs.  However, block numbers are
> now 64-bit, so we need to refactor the sparse list to be able to handle both 32
> and 64-bit numbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/badblocks.c |  271 +++++++++++++++++++++++++++++++++++++-----------
>  lib/ext2fs/ext2fs.h    |   23 +++-
>  lib/ext2fs/ext2fsP.h   |   13 +-
>  lib/ext2fs/inode.c     |   12 +-
>  4 files changed, 237 insertions(+), 82 deletions(-)
> 

-- snip --

>  
> @@ -105,64 +129,107 @@ errcode_t ext2fs_badblocks_copy(ext2_badblocks_list src,
>  /*
>   * This procedure adds a block to a badblocks list.
>   */
> -errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk)
> +static int compare32(const void *a, const void *b)
> +{
> +	__u32 i, j;
> +	i = *(__u32 *)a;
> +	j = *(__u32 *)b;
> +
> +	return i - j;
> +}
> +
> +static int compare64(const void *a, const void *b)
> +{
> +	__u64 i, j;
> +	i = *(__u64 *)a;
> +	j = *(__u64 *)b;
> +
> +	return i - j;

Hmm this does not seem right. What if:

i = 4294967296
j = 8589934592

then you would return 0 even though the two block numbers differs.
The problem here is that even though you compare __u64 you return
int.

Thanks!
-Lukas

> +}
> +
> +static errcode_t sparse_list_add(struct ext2_sparse_list *bb, void *item)
>  {
>  	errcode_t	retval;
> -	int		i, j;
> +	int		i, j, k;
>  	unsigned long	old_size;
> +	int (*cmp)	(const void *a, const void *b);
>  
>  	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
>  
>  	if (bb->num >= bb->size) {
> -		old_size = bb->size * sizeof(__u32);
> +		old_size = bb->size * bb->item_size;
>  		bb->size += 100;
> -		retval = ext2fs_resize_mem(old_size, bb->size * sizeof(__u32),
> +		retval = ext2fs_resize_mem(old_size, bb->size * bb->item_size,
>  					   &bb->list);
>  		if (retval) {
>  			bb->size -= 100;
>  			return retval;
>  		}
>  	}
> -
> +	if (bb->item_size == sizeof(__u32))
> +		cmp = compare32;
> +	else if (bb->item_size == sizeof(__u64))
> +		cmp = compare64;
> +	else
> +		return EXT2_ET_INVALID_ARGUMENT;
>  	/*
>  	 * Add special case code for appending to the end of the list
>  	 */
>  	i = bb->num-1;
> -	if ((bb->num != 0) && (bb->list[i] == blk))
> +	if ((bb->num != 0) && cmp(LIST_ITEM(bb, i), item) == 0)
>  		return 0;
> -	if ((bb->num == 0) || (bb->list[i] < blk)) {
> -		bb->list[bb->num++] = blk;
> +	if ((bb->num == 0) || cmp(LIST_ITEM(bb, i), item) < 0) {
> +		memcpy(LIST_ITEM(bb, bb->num++), item, bb->item_size);
>  		return 0;
>  	}
>  
>  	j = bb->num;
>  	for (i=0; i < bb->num; i++) {
> -		if (bb->list[i] == blk)
> +		k = cmp(LIST_ITEM(bb, i), item);
> +		if (k == 0)
>  			return 0;
> -		if (bb->list[i] > blk) {
> +		if (k > 0) {

Since you're possibly comparing 64bit numbers and return int this
would not work very well at all.

>  			j = i;
>  			break;
>  		}
>  	}
> -	for (i=bb->num; i > j; i--)
> -		bb->list[i] = bb->list[i-1];
> -	bb->list[j] = blk;
> +	memmove(LIST_ITEM(bb, i + 1), LIST_ITEM(bb, i),
> +		(bb->num - j) * bb->item_size);
> +	memcpy(LIST_ITEM(bb, j), item, bb->item_size);

What is the difference between j and i here ? I've got the feeling
that both should be the same ?

Thanks!
-Lukas

>  	bb->num++;
>  	return 0;
>  }
>  
> +errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk)
> +{
> +	return sparse_list_add(bb, &blk);
> +}
> +
> +errcode_t ext2fs_badblocks_list_add2(ext2_badblocks_list bb, blk64_t blk)
> +{
> +	return sparse_list_add(bb, &blk);
> +}
> +
>  errcode_t ext2fs_badblocks_list_add(ext2_badblocks_list bb, blk_t blk)
>  {
> -	return ext2fs_u32_list_add((ext2_u32_list) bb, (__u32) blk);
> +	return ext2fs_badblocks_list_add2(bb, blk);
>  }
>  
>  /*
>   * This procedure finds a particular block is on a badblocks
>   * list.
>   */
> -int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
> +static int sparse_list_find(struct ext2_sparse_list *bb, void *item)
>  {
> -	int	low, high, mid;
> +	int	low, high, mid, k;
> +	int (*cmp)	(const void *a, const void *b);
> +
> +	if (bb->item_size == sizeof(__u32))
> +		cmp = compare32;
> +	else if (bb->item_size == sizeof(__u64))
> +		cmp = compare64;
> +	else
> +		return EXT2_ET_INVALID_ARGUMENT;
>  
>  	if (bb->magic != EXT2_ET_MAGIC_BADBLOCKS_LIST)
>  		return -1;
> @@ -172,18 +239,19 @@ int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
>  
>  	low = 0;
>  	high = bb->num-1;
> -	if (blk == bb->list[low])
> +	if (cmp(LIST_ITEM(bb, low), item) == 0)
>  		return low;
> -	if (blk == bb->list[high])
> +	if (cmp(LIST_ITEM(bb, high), item) == 0)
>  		return high;
>  
>  	while (low < high) {
>  		mid = ((unsigned)low + (unsigned)high)/2;
>  		if (mid == low || mid == high)
>  			break;
> -		if (blk == bb->list[mid])
> +		k = cmp(item, LIST_ITEM(bb, mid));
> +		if (k == 0)
>  			return mid;
> -		if (blk < bb->list[mid])
> +		if (k < 0)
>  			high = mid;
>  		else
>  			low = mid;
> @@ -191,13 +259,26 @@ int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
>  	return -1;
>  }
>  
> +int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
> +{
> +	return sparse_list_find(bb, &blk);
> +}
> +
>  /*
>   * This procedure tests to see if a particular block is on a badblocks
>   * list.
>   */
>  int ext2fs_u32_list_test(ext2_u32_list bb, __u32 blk)
>  {
> -	if (ext2fs_u32_list_find(bb, blk) < 0)
> +	if (sparse_list_find(bb, &blk) < 0)
> +		return 0;
> +	else
> +		return 1;
> +}
> +
> +int ext2fs_badblocks_list_test2(ext2_badblocks_list bb, blk64_t blk)
> +{
> +	if (sparse_list_find(bb, &blk) < 0)
>  		return 0;
>  	else
>  		return 1;
> @@ -205,65 +286,83 @@ int ext2fs_u32_list_test(ext2_u32_list bb, __u32 blk)
>  
>  int ext2fs_badblocks_list_test(ext2_badblocks_list bb, blk_t blk)
>  {
> -	return ext2fs_u32_list_test((ext2_u32_list) bb, (__u32) blk);
> +	return ext2fs_badblocks_list_test2(bb, blk);
>  }
>  
>  
>  /*
>   * Remove a block from the badblock list
>   */
> -int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk)
> +static int sparse_list_del(struct ext2_sparse_list *bb, void *item)
>  {
> -	int	remloc, i;
> +	int	remloc;
>  
>  	if (bb->num == 0)
>  		return -1;
>  
> -	remloc = ext2fs_u32_list_find(bb, blk);
> +	remloc = sparse_list_find(bb, item);
>  	if (remloc < 0)
>  		return -1;
>  
> -	for (i = remloc ; i < bb->num-1; i++)
> -		bb->list[i] = bb->list[i+1];
> +	memmove(LIST_ITEM(bb, remloc), LIST_ITEM(bb, remloc + 1),
> +		(bb->num - remloc - 1) * bb->item_size);
>  	bb->num--;
>  	return 0;
>  }
>  
> +int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk)
> +{
> +	return sparse_list_del(bb, &blk);
> +}
> +
> +void ext2fs_badblocks_list_del2(ext2_u32_list bb, blk64_t blk)
> +{
> +	sparse_list_del(bb, &blk);
> +}
> +
>  void ext2fs_badblocks_list_del(ext2_u32_list bb, __u32 blk)
>  {
> -	ext2fs_u32_list_del(bb, blk);
> +	ext2fs_badblocks_list_del(bb, blk);
>  }
>  
> -errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
> -					ext2_u32_iterate *ret)
> +static errcode_t sparse_list_iterate_begin(struct ext2_sparse_list *bb,
> +					   struct ext2_sparse_list_iterate **r)
>  {
> -	ext2_u32_iterate iter;
> +	struct ext2_sparse_list_iterate *iter;
>  	errcode_t		retval;
>  
>  	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
>  
> -	retval = ext2fs_get_mem(sizeof(struct ext2_struct_u32_iterate), &iter);
> +	retval = ext2fs_get_mem(sizeof(struct ext2_sparse_list_iterate),
> +				&iter);
>  	if (retval)
>  		return retval;
>  
>  	iter->magic = EXT2_ET_MAGIC_BADBLOCKS_ITERATE;
>  	iter->bb = bb;
>  	iter->ptr = 0;
> -	*ret = iter;
> +	*r = iter;
>  	return 0;
>  }
>  
> +errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
> +					ext2_u32_iterate *ret)
> +{
> +	return sparse_list_iterate_begin(bb, ret);
> +}
> +
>  errcode_t ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
>  					      ext2_badblocks_iterate *ret)
>  {
> -	return ext2fs_u32_list_iterate_begin((ext2_u32_list) bb,
> -					      (ext2_u32_iterate *) ret);
> +	return sparse_list_iterate_begin((ext2_u32_list) bb,
> +					 (ext2_u32_iterate *) ret);
>  }
>  
>  
> -int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk)
> +static int sparse_list_iterate(struct ext2_sparse_list_iterate *iter,
> +			       void *item)
>  {
> -	ext2_u32_list	bb;
> +	struct ext2_sparse_list	*bb;
>  
>  	if (iter->magic != EXT2_ET_MAGIC_BADBLOCKS_ITERATE)
>  		return 0;
> @@ -274,21 +373,35 @@ int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk)
>  		return 0;
>  
>  	if (iter->ptr < bb->num) {
> -		*blk = bb->list[iter->ptr++];
> +		memcpy(item, LIST_ITEM(bb, iter->ptr++), bb->item_size);
>  		return 1;
>  	}
> -	*blk = 0;
> +	memset(item, 0, bb->item_size);
>  	return 0;
>  }
>  
> +int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk)
> +{
> +	return sparse_list_iterate(iter, blk);
> +}
> +
> +int ext2fs_badblocks_list_iterate2(ext2_badblocks_iterate iter, blk64_t *blk)
> +{
> +	return sparse_list_iterate(iter, blk);
> +}
> +
>  int ext2fs_badblocks_list_iterate(ext2_badblocks_iterate iter, blk_t *blk)
>  {
> -	return ext2fs_u32_list_iterate((ext2_u32_iterate) iter,
> -				       (__u32 *) blk);
> +	blk64_t x;
> +	int ret;
> +
> +	ret = ext2fs_badblocks_list_iterate2(iter, &x);
> +	*blk = x;
> +	return ret;
>  }
>  
>  
> -void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter)
> +static void sparse_list_iterate_end(struct ext2_sparse_list_iterate *iter)
>  {
>  	if (!iter || (iter->magic != EXT2_ET_MAGIC_BADBLOCKS_ITERATE))
>  		return;
> @@ -297,13 +410,19 @@ void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter)
>  	ext2fs_free_mem(&iter);
>  }
>  
> +void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter)
> +{
> +	sparse_list_iterate_end(iter);
> +}
> +
>  void ext2fs_badblocks_list_iterate_end(ext2_badblocks_iterate iter)
>  {
> -	ext2fs_u32_list_iterate_end((ext2_u32_iterate) iter);
> +	sparse_list_iterate_end(iter);
>  }
>  
>  
> -int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
> +static int sparse_list_equal(struct ext2_sparse_list *bb1,
> +			     struct ext2_sparse_list *bb2)
>  {
>  	EXT2_CHECK_MAGIC(bb1, EXT2_ET_MAGIC_BADBLOCKS_LIST);
>  	EXT2_CHECK_MAGIC(bb2, EXT2_ET_MAGIC_BADBLOCKS_LIST);
> @@ -311,18 +430,46 @@ int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
>  	if (bb1->num != bb2->num)
>  		return 0;
>  
> -	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(blk_t)) != 0)
> +	if (bb1->item_size != bb2->item_size)
> +		return 0;
> +
> +	if (memcmp(bb1->list, bb2->list, bb1->num * bb1->item_size) != 0)
>  		return 0;
>  	return 1;
>  }
>  
> +int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
> +{
> +	return sparse_list_equal(bb1, bb2);
> +}
> +
>  int ext2fs_badblocks_equal(ext2_badblocks_list bb1, ext2_badblocks_list bb2)
>  {
> -	return ext2fs_u32_list_equal((ext2_u32_list) bb1,
> -				     (ext2_u32_list) bb2);
> +	return sparse_list_equal(bb1, bb2);
>  }
>  
> -int ext2fs_u32_list_count(ext2_u32_list bb)
> +static unsigned int sparse_list_count(struct ext2_sparse_list *bb)
>  {
> +	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
>  	return bb->num;
>  }
> +
> +int ext2fs_u32_list_count(ext2_u32_list bb)
> +{
> +	return sparse_list_count(bb);
> +}
> +
> +unsigned int ext2fs_badblocks_count(ext2_badblocks_list bb)
> +{
> +	return sparse_list_count(bb);
> +}
> +
> +blk64_t ext2fs_badblocks_get(ext2_badblocks_list bb, unsigned int i)
> +{
> +	blk64_t x;
> +
> +	if (i < 0 || i >= bb->num)
> +		return 0;
> +	memcpy(&x, LIST_ITEM(bb, i), bb->item_size);
> +	return x;
> +}
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d5d8d03..b4ba421 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -111,15 +111,15 @@ typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;
>   * Badblocks list definitions
>   */
>  
> -typedef struct ext2_struct_u32_list *ext2_badblocks_list;
> -typedef struct ext2_struct_u32_iterate *ext2_badblocks_iterate;
> +typedef struct ext2_sparse_list *ext2_badblocks_list;
> +typedef struct ext2_sparse_list_iterate *ext2_badblocks_iterate;
>  
> -typedef struct ext2_struct_u32_list *ext2_u32_list;
> -typedef struct ext2_struct_u32_iterate *ext2_u32_iterate;
> +typedef struct ext2_sparse_list *ext2_u32_list;
> +typedef struct ext2_sparse_list_iterate *ext2_u32_iterate;
>  
>  /* old */
> -typedef struct ext2_struct_u32_list *badblocks_list;
> -typedef struct ext2_struct_u32_iterate *badblocks_iterate;
> +typedef struct ext2_sparse_list *badblocks_list;
> +typedef struct ext2_sparse_list_iterate *badblocks_iterate;
>  
>  #define BADBLOCKS_FLAG_DIRTY	1
>  
> @@ -702,6 +702,8 @@ extern int ext2fs_u32_list_iterate(ext2_u32_iterate iter, blk_t *blk);
>  extern void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter);
>  extern errcode_t ext2fs_u32_copy(ext2_u32_list src, ext2_u32_list *dest);
>  extern int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2);
> +extern int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk);
> +extern int ext2fs_u32_list_count(ext2_u32_list bb);
>  
>  extern errcode_t ext2fs_badblocks_list_create(ext2_badblocks_list *ret,
>  					    int size);
> @@ -709,7 +711,6 @@ extern errcode_t ext2fs_badblocks_list_add(ext2_badblocks_list bb,
>  					   blk_t blk);
>  extern int ext2fs_badblocks_list_test(ext2_badblocks_list bb,
>  				    blk_t blk);
> -extern int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk);
>  extern void ext2fs_badblocks_list_del(ext2_u32_list bb, __u32 blk);
>  extern errcode_t
>  	ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
> @@ -721,7 +722,13 @@ extern errcode_t ext2fs_badblocks_copy(ext2_badblocks_list src,
>  				       ext2_badblocks_list *dest);
>  extern int ext2fs_badblocks_equal(ext2_badblocks_list bb1,
>  				  ext2_badblocks_list bb2);
> -extern int ext2fs_u32_list_count(ext2_u32_list bb);
> +extern errcode_t ext2fs_badblocks_list_add2(ext2_badblocks_list bb,
> +					    blk64_t blk);
> +extern int ext2fs_badblocks_list_test2(ext2_badblocks_list bb, blk64_t blk);
> +extern void ext2fs_badblocks_list_del2(ext2_u32_list bb, blk64_t blk);
> +extern int ext2fs_badblocks_list_iterate2(ext2_badblocks_iterate iter,
> +					  blk64_t *blk);
> +extern blk64_t ext2fs_badblocks_get(ext2_badblocks_list bb, unsigned int i);
>  
>  /* bb_compat */
>  extern errcode_t badblocks_list_create(badblocks_list *ret, int size);
> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index 80d2d0a..592527c 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -16,17 +16,18 @@
>  /*
>   * Badblocks list
>   */
> -struct ext2_struct_u32_list {
> +struct ext2_sparse_list {
>  	int	magic;
> -	int	num;
> -	int	size;
> -	__u32	*list;
> +	unsigned int	num;
> +	unsigned int	size;
> +	unsigned int	item_size;
> +	void	*list;
>  	int	badblocks_flags;
>  };
>  
> -struct ext2_struct_u32_iterate {
> +struct ext2_sparse_list_iterate {
>  	int			magic;
> -	ext2_u32_list		bb;
> +	struct ext2_sparse_list	*bb;
>  	int			ptr;
>  };
>  
> diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
> index 46c1c58..6579512 100644
> --- a/lib/ext2fs/inode.c
> +++ b/lib/ext2fs/inode.c
> @@ -313,8 +313,8 @@ static errcode_t check_for_inode_bad_blocks(ext2_inode_scan scan,
>  	 * is no longer the case.  If we run out of bad blocks, then
>  	 * we don't need to do any more checking!
>  	 */
> -	while (blk > bb->list[scan->bad_block_ptr]) {
> -		if (++scan->bad_block_ptr >= bb->num) {
> +	while (blk > ext2fs_badblocks_get(bb, scan->bad_block_ptr)) {
> +		if (++scan->bad_block_ptr >= ext2fs_badblocks_count(bb)) {
>  			scan->scan_flags &= ~EXT2_SF_CHK_BADBLOCKS;
>  			return 0;
>  		}
> @@ -328,10 +328,10 @@ static errcode_t check_for_inode_bad_blocks(ext2_inode_scan scan,
>  	 * expense of a huge expense of code complexity, and for an
>  	 * uncommon case at that.)
>  	 */
> -	if (blk == bb->list[scan->bad_block_ptr]) {
> +	if (blk == ext2fs_badblocks_get(bb, scan->bad_block_ptr)) {
>  		scan->scan_flags |= EXT2_SF_BAD_INODE_BLK;
>  		*num_blocks = 1;
> -		if (++scan->bad_block_ptr >= bb->num)
> +		if (++scan->bad_block_ptr >= ext2fs_badblocks_count(bb))
>  			scan->scan_flags &= ~EXT2_SF_CHK_BADBLOCKS;
>  		return 0;
>  	}
> @@ -342,8 +342,8 @@ static errcode_t check_for_inode_bad_blocks(ext2_inode_scan scan,
>  	 * don't read in the bad block.  (Then the next block to read
>  	 * will be the bad block, which is handled in the above case.)
>  	 */
> -	if ((blk + *num_blocks) > bb->list[scan->bad_block_ptr])
> -		*num_blocks = (int) (bb->list[scan->bad_block_ptr] - blk);
> +	if ((blk + *num_blocks) > ext2fs_badblocks_get(bb, scan->bad_block_ptr))
> +		*num_blocks = (int)(ext2fs_badblocks_get(bb, scan->bad_block_ptr) - blk);
>  
>  	return 0;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
