From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 Secure Delete 3/7v4] ext4: Secure Delete: Add secure	delete
 functions
Date: Fri, 07 Oct 2011 16:08:14 -0700
Message-ID: <4E8F865E.9070909@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-4-git-send-email-achender@linux.vnet.ibm.com> <20111007180711.GH12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49644 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab1JGXJH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2011 19:09:07 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 7 Oct 2011 17:09:06 -0600
In-Reply-To: <20111007180711.GH12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/07/2011 11:07 AM, Darrick J. Wong wrote:
> On Fri, Oct 07, 2011 at 12:11:01AM -0700, Allison Henderson wrote:
>> This patch adds two new routines: ext4_secure_delete_pblks
>> and ext4_secure_delete_lblks.
>>
>> ext4_secure_delete_pblks() will write zeros to the specified
>> physical blocks or random data if the EXT4_SECRM_RANDOM_FL flag is
>> set.  If the device supports secure discard, the secure
>> discard will be used instead. ext4_secure_delete_lblks handels walking
>
> handles
>
>> the logical blocks of a file and calling ext4_secure_delete_pblks()
>> as needed.
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>> ---
>> v1->v2
>> Removed check for discard mount option and replaced with
>> check for secure discard and discard_zeroes_data
>>
>> Added BLKDEV_DISCARD_SECURE to the sb_issue_discard call
>>
>> v2->v3
>> Removed code for discard.  A seperate patch will
>
> separate
>
>> be done to add that code in the block layer
>>
>> v3->v4
>> Discard code will be kept in the vfs layer.  Code
>> for secure delete is now in its own function,
>> ext4_secure_delete_pblks and is called
>> by a new function ext4_secure_delete_lblks
>> before any blocks are released
>>
>> :100644 100644 5c9f88c... 34f82a1... M	fs/ext4/ext4.h
>> :100644 100644 095c36f... 10180e3... M	fs/ext4/ext4_extents.h
>> :100644 100644 57cf568... 40d4e50... M	fs/ext4/extents.c
>> :100644 100644 9dc8c14... 0a526c4... M	fs/ext4/inode.c
>>   fs/ext4/ext4.h         |    5 +
>>   fs/ext4/ext4_extents.h |    2 +
>>   fs/ext4/extents.c      |    2 +-
>>   fs/ext4/inode.c        |  196 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 204 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 5c9f88c..34f82a1 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -2220,6 +2220,11 @@ extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   			   struct ext4_map_blocks *map, int flags);
>>   extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>   			__u64 start, __u64 len);
>> +extern int ext4_secure_delete_lblks(struct inode *inode,
>> +			ext4_lblk_t first_block, unsigned long count);
>> +extern int ext4_secure_delete_pblks(struct inode *inode,
>> +			ext4_fsblk_t block, unsigned long count);
>> +
>>   /* move_extent.c */
>>   extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>   			     __u64 start_orig, __u64 start_donor,
>> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
>> index 095c36f..10180e3 100644
>> --- a/fs/ext4/ext4_extents.h
>> +++ b/fs/ext4/ext4_extents.h
>> @@ -290,5 +290,7 @@ extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
>>   							struct ext4_ext_path *);
>>   extern void ext4_ext_drop_refs(struct ext4_ext_path *);
>>   extern int ext4_ext_check_inode(struct inode *inode);
>> +extern int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
>> +		struct ext4_ext_cache *ex);
>>   #endif /* _EXT4_EXTENTS */
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 57cf568..40d4e50 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2034,7 +2034,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>>    *
>>    * Return 0 if cache is invalid; 1 if the cache is valid
>>    */
>> -static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
>> +int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
>>   	struct ext4_ext_cache *ex){
>>   	struct ext4_ext_cache *cex;
>>   	struct ext4_sb_info *sbi;
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9dc8c14..0a526c4 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -38,6 +38,7 @@
>>   #include<linux/printk.h>
>>   #include<linux/slab.h>
>>   #include<linux/ratelimit.h>
>> +#include<linux/random.h>
>>
>>   #include "ext4_jbd2.h"
>>   #include "xattr.h"
>> @@ -713,6 +714,201 @@ static int ext4_ind_hole_lookup(struct inode *inode, ext4_lblk_t block)
>>   	return 0;
>>   }
>>
>> +
>> +/*
>> + * ext4_secure_delete_pblks
>> + *
>> + * Securely delete physical blocks.
>> + * If the devices supports secure discard,
>> + * blocks will be discarded.  Otherwise
>> + * the blocks will be either zeroed or
>> + * randomized if the random secure delete
>> + * flag is on
>
> The fact that random secure delete produces zeroed blocks on discard devices is
> documented somewhere user-visible, right?  Just in case someone actually
> depends on the randomizing.

At the moment no, the code is just the result of reviews and 
brainstorming, but I can add in some documentation somewhere so that it 
is more clear.  Will catch the misspellings too, thx!  :)

>
>> + * inode: The files inode
>> + * block: The physical block at which to start deleteing
>
> deleting
>
>> + * count: The number of blocks to delete
>> + *
>> + * Returns 0 on sucess or negative on error
>> + */
>> +int ext4_secure_delete_pblks(struct inode *inode, ext4_fsblk_t block,
>> +		unsigned long count){
>> +
>> +	struct fstrim_range range;
>> +	ext4_fsblk_t iblock, last_block;
>> +	struct buffer_head *bh;
>> +	struct super_block *sb = inode->i_sb;
>> +	struct request_queue *q = bdev_get_queue(sb->s_bdev);
>> +	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
>> +	int err = 0;
>> +
>> +	last_block = block + count;
>> +	/*
>> +	 * Check to see if the device supports secure discard,
>> +	 * And also that read after discard returns zeros
>> +	 */
>> +	if (blk_queue_secdiscard(q)&&  q->limits.discard_zeroes_data) {
>> +		err = sb_issue_discard(sb, block, count,
>> +			GFP_NOFS, BLKDEV_DISCARD_SECURE);
>> +		if (err)
>> +			goto zero_out;
>> +
>> +		range.start = block;
>> +		range.len = count;
>> +		range.minlen = 1;
>> +		err = ext4_trim_fs(sb,&range);
>> +
>> +		if (err)
>> +			goto zero_out;
>> +
>> +		return 0;
>> +	}
>> +
>> +	if (EXT4_I(inode)->i_flags&  EXT4_SECRM_RANDOM_FL) {
>> +		for (iblock = block; iblock<  last_block; iblock++) {
>> +			bh = sb_getblk(sb, iblock);
>> +			get_random_bytes(bh->b_data, bh->b_size);
>> +			set_buffer_dirty(bh);
>> +
>> +			sync_dirty_buffer(bh);
>> +			if (buffer_req(bh)&&  !buffer_uptodate(bh)) {
>> +				es->s_last_error_block =
>> +					cpu_to_le64(bh->b_blocknr);
>> +				ext4_error_inode(inode, __func__,
>> +					__LINE__, bh->b_blocknr,
>> +					"IO error syncing itable block");
>
> itable block?
>
>> +				err = -EIO;
>> +				brelse(bh);
>> +				goto zero_out;
>> +			}
>> +			brelse(bh);
>> +		}
>> +		return 0;
>> +	}
>> +
>> +zero_out:
>> +	return sb_issue_zeroout(sb, block, count, GFP_NOFS);
>> +
>> +}
>> +
>> +/*
>> + * ext4_secure_delete_lblks
>> + *
>> + * Secure deletes the data blocks of a file
>> + * starting at the given logical block
>> + *
>> + * @inode: The files inode
>> + * @first_block: Starting logical block
>> + * @count: The number of blocks to secure delete
>> + *
>> + * Returns 0 on sucess or negative on error
>> + */
>> +int ext4_secure_delete_lblks(struct inode *inode, ext4_lblk_t first_block,
>> +				unsigned long count){
>> +	handle_t *handle;
>> +	struct ext4_map_blocks map;
>> +	struct ext4_ext_cache cache_ex;
>> +	ext4_lblk_t num_blocks, max_blocks = 0;
>> +	ext4_lblk_t last_block = first_block + count;
>> +	ext4_lblk_t iblock = first_block;
>> +	int ret, credits, hole_len, err = 0;
>> +
>> +	credits = ext4_writepage_trans_blocks(inode);
>> +	handle = ext4_journal_start(inode, credits);
>> +	if (IS_ERR(handle))
>> +		return PTR_ERR(handle);
>> +
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +	ext4_ext_invalidate_cache(inode);
>> +	ext4_discard_preallocations(inode);
>> +
>> +	/* Do not allow last_block to wrap when caller passes EXT_MAX_BLOCK */
>> +	if (last_block<  first_block)
>> +		last_block = EXT_MAX_BLOCKS;
>> +
>> +	while (iblock<  last_block) {
>> +		max_blocks = last_block - iblock;
>> +		num_blocks = 1;
>> +		memset(&map, 0, sizeof(map));
>> +		map.m_lblk = iblock;
>> +		map.m_len = max_blocks;
>> +
>> +		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>> +			ret = ext4_ext_map_blocks(handle, inode,&map, 0);
>> +		else
>> +			ret = ext4_ind_map_blocks(handle, inode,&map, 0);
>> +
>> +		if (ret>  0) {
>> +			err = ext4_secure_delete_pblks(inode,
>> +				map.m_pblk, map.m_len);
>> +			if (err)
>> +				break;
>> +			num_blocks = ret;
>> +		} else if (ret == 0) {
>> +			if (ext4_test_inode_flag(inode,
>> +				EXT4_INODE_EXTENTS)) {
>> +				/*
>> +				 * If map blocks could not find the block,
>> +				 * then it is in a hole.  If the hole was
>> +				 * not already cached, then map blocks should
>> +				 * put it in the cache.  So we can get the hole
>> +				 * out of the cache
>> +				 */
>> +				memset(&cache_ex, 0, sizeof(cache_ex));
>> +				if ((ext4_ext_check_cache(inode, iblock,
>> +					&cache_ex))&&  !cache_ex.ec_start) {
>> +
>> +					/* The hole is cached */
>> +					num_blocks = cache_ex.ec_block +
>> +						cache_ex.ec_len - iblock;
>> +
>> +				} else {
>> +					/* reached EOF of extent file */
>> +					break;
>> +				}
>> +			} else {
>> +				hole_len = ext4_ind_hole_lookup(inode, iblock);
>> +
>> +				if (hole_len>  0) {
>> +					/* Skip over the hole */
>> +					num_blocks = hole_len;
>> +				} else if (hole_len == 0) {
>> +					/* No hole, EOF reached */
>> +					break;
>> +				} else {
>> +					/* Hole look up err */
>> +					err = hole_len;
>> +					break;
>> +				}
>> +			}
>> +		} else {
>> +			/* Map blocks error */
>> +			err = ret;
>> +			break;
>> +		}
>> +
>> +		if (num_blocks == 0) {
>> +			/* This condition should never happen */
>> +			ext_debug("Block lookup failed");
>> +			err = -EIO;
>> +			break;
>> +		}
>> +
>> +		iblock += num_blocks;
>> +	}
>> +
>> +	if (IS_SYNC(inode))
>> +		ext4_handle_sync(handle);
>> +
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>> +
>> +	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>> +	ext4_mark_inode_dirty(handle, inode);
>> +	ext4_journal_stop(handle);
>> +
>> +	return err;
>> +}
>> +
>>   struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
>>   			       ext4_lblk_t block, int create, int *err)
>>   {
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

