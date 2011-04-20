From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 2/3] ext4:Add two functions splitting an extent.
Date: Wed, 20 Apr 2011 10:21:57 -0700
Message-ID: <4DAF1635.7070406@linux.vnet.ibm.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com> <1302759651-21222-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37328 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1DTRWZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Apr 2011 13:22:25 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3KH68CG009290
	for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 11:06:08 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3KHM84h081228
	for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 11:22:09 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3KHR7VY025036
	for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 11:27:08 -0600
In-Reply-To: <1302759651-21222-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/13/2011 10:40 PM, Yongqiang Yang wrote:
> 1] Add a function named ext4_split_extent_at() which splits an extent
>     into two extents at given logical block.
> 
> 2] Add a function called ext4_split_extent() which splits an extent
>     into three extents.
> 
> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
> ---
>   fs/ext4/extents.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 200 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 11f30d2..1756e0f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2554,6 +2554,206 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
>   	return ret;
>   }
> 
> +/*
> + * used by extent splitting.
> + */
> +#define EXT4_EXT_MAY_ZEROOUT	0x1  /* safe to zeroout if split fails \
> +					due to ENOSPC */
> +#define EXT4_EXT_MARK_UNINIT1	0x2  /* mark first half uninitialized */
> +#define EXT4_EXT_MARK_UNINIT2	0x4  /* mark second half uninitialized */
> +
> +/*
> + * ext4_split_extent_at() splits an extent at given block.
> + *
> + * @handle: the journal handle
> + * @inode: the file inode
> + * @path: the path to the extent
> + * @split: the logical block where the extent is splitted.
> + * @split_flags: indicates if the extent could be zeroout if split fails, and
> + *		 the states(init or uninit) of new extents.
> + * @flags: flags used to insert new extent to extent tree.
> + *
> + *
> + * Splits extent [a, b] into two extents [a, @split) and [@split, b], states
> + * of which are deterimined by split_flag.
> + *
> + * There are two cases:
> + *  a>  the extent are splitted into two extent.
> + *  b>  split is not needed, and just mark the extent.
> + *
> + * return 0 on success.
> + */
> +static int ext4_split_extent_at(handle_t *handle,
> +			     struct inode *inode,
> +			     struct ext4_ext_path *path,
> +			     ext4_lblk_t split,
> +			     int split_flag,
> +			     int flags)
> +{
> +	ext4_fsblk_t newblock;
> +	ext4_lblk_t ee_block;
> +	struct ext4_extent_header *eh;
> +	struct ext4_extent *ex, newex, orig_ex;
> +	struct ext4_extent *ex2 = NULL;
> +	unsigned int ee_len, depth;
> +	int err = 0;
> +
> +	ext_debug("ext4_split_extents_at: inode %lu, logical"
> +		"block %llu\n", inode->i_ino, (unsigned long long)split);
> +
> +	ext4_ext_show_leaf(inode, path);
> +
> +	depth = ext_depth(inode);
> +	eh = path[depth].p_hdr;
> +	ex = path[depth].p_ext;
> +	ee_block = le32_to_cpu(ex->ee_block);
> +	ee_len = ext4_ext_get_actual_len(ex);
> +	newblock = split - ee_block + ext4_ext_pblock(ex);
> +
> +	BUG_ON(split<  ee_block || split>= (ee_block + ee_len));
> +
> +	err = ext4_ext_get_access(handle, inode, path + depth);
> +	if (err)
> +		goto out;
> +
> +	if (split == ee_block) {
> +		/*
> +		 * case b: block @split is the block that the extent begins with
> +		 * then we just change the state of the extent, and splitting
> +		 * is not needed.
> +		 */
> +		if (split_flag&  EXT4_EXT_MARK_UNINIT2)
> +			ext4_ext_mark_uninitialized(ex);
> +		else
> +			ext4_ext_mark_initialized(ex);
> +
> +		if (!(flags&  EXT4_GET_BLOCKS_PRE_IO))
> +			ext4_ext_try_to_merge(inode, path, ex);
> +
> +		err = ext4_ext_dirty(handle, inode, path + depth);
> +		goto out;
> +	}
> +
> +	/* case a */
> +	orig_ex.ee_block = ex->ee_block;
> +	orig_ex.ee_len   = ex->ee_len;
> +	ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
> +
> +	ex->ee_len = cpu_to_le16(split - ee_block);
> +	if (split_flag&  EXT4_EXT_MARK_UNINIT1)
> +		ext4_ext_mark_uninitialized(ex);
> +
> +	/*
> +	 * path may lead to new leaf, not to original leaf any more
> +	 * after ext4_ext_insert_extent() returns,
> +	 */
> +	err = ext4_ext_dirty(handle, inode, path + depth);
> +	if (err)
> +		goto fix_extent_len;
> +
> +	ex2 =&newex;
> +	ex2->ee_block = cpu_to_le32(split);
> +	ex2->ee_len   = cpu_to_le16(ee_len - (split - ee_block));
> +	ext4_ext_store_pblock(ex2, newblock);
> +	if (split_flag&  EXT4_EXT_MARK_UNINIT2)
> +		ext4_ext_mark_uninitialized(ex2);
> +
> +	err = ext4_ext_insert_extent(handle, inode, path,&newex, flags);
> +	if (err == -ENOSPC&&  (EXT4_EXT_MAY_ZEROOUT&  split_flag)) {
> +
> +		err = ext4_ext_zeroout(inode,&orig_ex);
> +		if (err)
> +			goto fix_extent_len;
> +		/* update the extent length and mark as initialized */
> +		ex->ee_block = orig_ex.ee_block;
> +		ex->ee_len   = orig_ex.ee_len;
> +		ext4_ext_mark_initialized(ex);
> +		ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> +		err = ext4_ext_dirty(handle, inode, path + depth);
> +		goto out;
> +	} else if (err)
> +		goto fix_extent_len;
> +
> +out:
> +	ext4_ext_show_leaf(inode, path);
> +	return err;
> +
> +fix_extent_len:
> +	ex->ee_block = orig_ex.ee_block;
> +	ex->ee_len   = orig_ex.ee_len;
> +	ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> +	ext4_ext_dirty(handle, inode, path + depth);
> +	return err;
> +}
> +
> +/*
> + * ext4_split_extents() splits an extent and mark extent which is covered
> + * by @map as split_flags indicates
> + *
> + * It may result in splitting the extent into multiple extents (upto three)
> + * There are three possibilities:
> + *   a>  There is no split required
> + *   b>  Splits in two extents: Split is happening at either end of the extent
> + *   c>  Splits in three extents: Somone is splitting in middle of the extent
> + *
> + */
> +static int ext4_split_extent(handle_t *handle,
> +			      struct inode *inode,
> +			      struct ext4_ext_path *path,
> +			      struct ext4_map_blocks *map,
> +			      int split_flag,
> +			      int flags)
> +{
> +	ext4_lblk_t ee_block;
> +	struct ext4_extent *ex;
> +	unsigned int ee_len, depth;
> +	int err = 0;
> +	int uninitialized;
> +	int split_flag1, flags1;
> +
> +	depth = ext_depth(inode);
> +	ex = path[depth].p_ext;
> +	ee_block = le32_to_cpu(ex->ee_block);
> +	ee_len = ext4_ext_get_actual_len(ex);
> +	uninitialized = ext4_ext_is_uninitialized(ex);
> +
> +	if (map->m_lblk + map->m_len<  ee_block + ee_len) {
> +		split_flag1 = 0;
> +		split_flag1 |= split_flag&  EXT4_EXT_MAY_ZEROOUT ?
> +			       EXT4_EXT_MAY_ZEROOUT : 0;
> +		flags1 = flags;
> +		flags1 |= EXT4_GET_BLOCKS_PRE_IO;
> +		if (uninitialized)
> +			split_flag1 |= EXT4_EXT_MARK_UNINIT1 |
> +				       EXT4_EXT_MARK_UNINIT2;
> +		err = ext4_split_extent_at(handle, inode, path,
> +				map->m_lblk + map->m_len, split_flag1, flags1);
> +	}
> +
> +	ext4_ext_drop_refs(path);
> +	path = ext4_ext_find_extent(inode, map->m_lblk, path);
> +	if (IS_ERR(path))
> +		return PTR_ERR(path);
> +
> +	if (map->m_lblk>= ee_block) {
> +		split_flag1 = 0;
> +		split_flag1 |= split_flag&  EXT4_EXT_MAY_ZEROOUT ?
> +			       EXT4_EXT_MAY_ZEROOUT : 0;
> +		if (uninitialized)
> +			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
> +		if (split_flag&  EXT4_EXT_MARK_UNINIT2)
> +			split_flag1 |= EXT4_EXT_MARK_UNINIT2;
> +		err = ext4_split_extent_at(handle, inode, path,
> +				map->m_lblk, split_flag1, flags);
> +		if (err)
> +			goto out;
> +	}
> +
> +	ext4_ext_show_leaf(inode, path);
> +out:
> +	return err ? err : map->m_len;
> +}
> +
>   #define EXT4_EXT_ZERO_LEN 7
>   /*
>    * This function is called by ext4_ext_map_blocks() if someone tries to write


Hi there,

I've been working on trying to get the punch hole patch to work with with these new changes, but it looks like some test cases are not passing at the moment, so I'm trying track down where the issues are.  I had to make some adjustments to this patch to fix one of the test cases.  Here is what I did:

---
:100644 100644 ee2dda3... c7d763d... M  fs/ext4/extents.c
 fs/ext4/extents.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee2dda3..c7d763d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2717,12 +2717,12 @@ static int ext4_split_extent(handle_t *handle,
        ee_len = ext4_ext_get_actual_len(ex);
        uninitialized = ext4_ext_is_uninitialized(ex);

+       flags1 = flags;
+       flags1 |= EXT4_GET_BLOCKS_PRE_IO;
        if (map->m_lblk + map->m_len < ee_block + ee_len) {
                split_flag1 = 0;
                split_flag1 |= split_flag & EXT4_EXT_MAY_ZEROOUT ?
                               EXT4_EXT_MAY_ZEROOUT : 0;
-               flags1 = flags;
-               flags1 |= EXT4_GET_BLOCKS_PRE_IO;
                if (uninitialized)
                        split_flag1 |= EXT4_EXT_MARK_UNINIT1 |
                                       EXT4_EXT_MARK_UNINIT2;
@@ -2744,7 +2744,7 @@ static int ext4_split_extent(handle_t *handle,
                if (split_flag & EXT4_EXT_MARK_UNINIT2)
                        split_flag1 |= EXT4_EXT_MARK_UNINIT2;
                err = ext4_split_extent_at(handle, inode, path,
-                               map->m_lblk, split_flag1, flags);
+                               map->m_lblk, split_flag1, flags1);
                if (err)
                        goto out;
        }
--
1.7.1


Let me know if this change works for you.  It looks like the problem was that the extents were getting merged back together because the second ext4_split_extent_at didnt have the EXT4_GET_BLOCKS_PRE_IO flag, so this should fix it.  There are still some other test cases that are showing some odd behavior, so I will keep you posted if I have to make any other changes.

Allison Henderson
