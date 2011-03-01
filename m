From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 punch hole 4/5] Ext4 Punch Hole Support: Enable Punch Hole
Date: Tue, 01 Mar 2011 13:51:37 -0700
Message-ID: <4D6D5C59.2030105@linux.vnet.ibm.com>
References: <4D6C634C.8050308@linux.vnet.ibm.com> <AANLkTi=Y1m=oH6zms-vsZE9iHwYd2q7Seuo+KcHCFQv-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:44707 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab1CAUvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 15:51:41 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p21Kf9KN026755
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:41:09 -0700
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p21Kpcdi121178
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:51:38 -0700
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p21Kpc1T007799
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:51:38 -0700
In-Reply-To: <AANLkTi=Y1m=oH6zms-vsZE9iHwYd2q7Seuo+KcHCFQv-@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/1/2011 1:20 AM, Amir Goldstein wrote:
> On Tue, Mar 1, 2011 at 5:09 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> This patch adds the  new "ext4_punch_hole" "ext4_ext_punch_hole" routines.
>>
>> fallocate has been modified to call ext4_punch_hole when the punch hole
>> flag is passed.  At the moment, we only support punching holes in
>> extents, so this routine is pretty much a wrapper for the ext4_ext_punch_hole
>> routine.
>>
>> The ext4_ext_punch_hole routine zeros out the pages that are
>> covered by the hole.  The blocks to be punched out
>> are then identified as mapped, delayed, or already punched out.
>> The blocks that mapped are the converted to into uninitialized
>> extents.  The blocks are then punched out using the
>> "ext4_ext_release_blocks" routine.
>>
>> Some minor utility functions have also been added.
>> A new ext4_ext_lookup_hole routine is used by
>> ext4_ext_punch_hole to check if a range of blocks
>> have already been punched out.
>>
>> A new ext4_ext_test_block_flag has also been
>> added to identify the state of a block (ie mapped,
>> delayed, ect)
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>> ---
>> :100644 100644 43a5772... aeb86d6... M  fs/ext4/ext4.h
>> :100644 100644 efbc3ef... 5713258... M  fs/ext4/extents.c
>> :100644 100644 28c9137... 493c908... M  fs/ext4/inode.c
>>   fs/ext4/ext4.h    |    2 +
>>   fs/ext4/extents.c |  321 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ext4/inode.c   |   26 +++++
>>   3 files changed, 345 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 43a5772..aeb86d6 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1729,6 +1729,7 @@ extern int ext4_change_inode_journal_flag(struct inode *, int);
>>   extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
>>   extern int ext4_can_truncate(struct inode *inode);
>>   extern void ext4_truncate(struct inode *);
>> +extern long  ext4_punch_hole(struct inode *inode,loff_t offset, loff_t length);
>>   extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
>>   extern void ext4_set_inode_flags(struct inode *);
>>   extern void ext4_get_inode_flags(struct ext4_inode_info *);
>> @@ -2066,6 +2067,7 @@ extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
>>   extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>                                struct ext4_map_blocks *map, int flags);
>>   extern void ext4_ext_truncate(struct inode *);
>> +extern void ext4_ext_punch_hole(struct inode *inode, loff_t offset, loff_t length);
>>   extern void ext4_ext_init(struct super_block *);
>>   extern void ext4_ext_release(struct super_block *);
>>   extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index efbc3ef..5713258 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2776,6 +2776,154 @@ out:
>>   }
>>
>>   /*
>> + * lookup_hole()
>> + * Returns the numbers of consecutive blocks starting at "start"
>> + * that are not contained within an extent
>> + */
>> +static int ext4_ext_lookup_hole(struct inode *inode, ext4_lblk_t start){
>> +    struct super_block *sb = inode->i_sb;
>> +       int depth = ext_depth(inode);
>> +       struct ext4_ext_path *path;
>> +       struct ext4_extent_header *eh;
>> +       struct ext4_extent *ex;
>> +       struct buffer_head *bh;
>> +       ext4_lblk_t last_block;
>> +       handle_t *handle;
>> +       int i, err;
>> +
>> +       ext_debug("lookup hole since %u\n", start);
>> +
>> +       /* Make sure start is valid */
>> +       last_block = inode->i_size>>  EXT4_BLOCK_SIZE_BITS(sb);
>> +       if(start>= last_block)
>> +               return -EIO;
>> +
>> +       handle = ext4_journal_start(inode, depth + 1);
>> +       if (IS_ERR(handle))
>> +                       return PTR_ERR(handle);
> 
> This is strange. The name of the functions implies it is a readonly operation,
> so why is a transaction needed?
> You should probably document the reason for that and specify the changes
> which this function may apply.

Oh, I must have been doing something that required at handle at one point, and forgot to take this out.  Thx for catching it, I will pull out the code for the handle.

> 
>> +
>> +       /*
>> +        * We start scanning from right side, looking for
>> +        * the left most block contained in the leaf, and
>> +        * stopping when "start" is crossed.
>> +        */
>> +       depth = ext_depth(inode);
>> +       path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
>> +       if (path == NULL) {
>> +                       ext4_journal_stop(handle);
>> +                       return -ENOMEM;
>> +       }
>> +       path[0].p_depth = depth;
>> +       path[0].p_hdr = ext_inode_hdr(inode);
>> +       if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
>> +               err = -EIO;
>> +               goto out;
>> +       }
>> +       i = err = 0;
>> +
>> +       while (i>= 0&&  err == 0) {
>> +               if (i == depth) {
>> +                       /* this is leaf block */
>> +
>> +                       eh = path[i].p_hdr;
>> +                       if (eh != NULL){
>> +                               if (eh->eh_entries == 0){
>> +                                       err = -EIO;
>> +                                       goto out;
>> +                               }
>> +
>> +                               ex = EXT_LAST_EXTENT(eh);
>> +                               while (ex != NULL&&  ex>= EXT_FIRST_EXTENT(eh)){
>> +
>> +                                       /*
>> +                                        * If the entire extent apears before start
>> +                                        * then we have passed the hole.
>> +                                        */
>> +                                       if(ex->ee_block + ex->ee_len<= start)
>> +                                               goto out;
>> +
>> +                                       /*
>> +                                        * If the start of the extent appears after
>> +                                        * or on start, then mark this as the edge
>> +                                        * of the hole
>> +                                        */
>> +                                       if(ex->ee_block>= start)
>> +                                               last_block = ex->ee_block;
>> +
>> +                                       /*
>> +                                        * If the extent contains start, then there
>> +                                        * is no hole.
>> +                                        */
>> +                                       else if(ex->ee_block + ex->ee_len>  start){
>> +                                               last_block = start;
>> +                                               goto out;
>> +                                       }
>> +
>> +                                       ex--;
>> +                               }
>> +                       }
>> +
>> +                       /* root level has p_bh == NULL, brelse() eats this */
>> +                       brelse(path[i].p_bh);
>> +                       path[i].p_bh = NULL;
>> +                       i--;
>> +                       continue;
>> +               }
>> +
>> +               /* this is index block */
>> +               if (!path[i].p_hdr)
>> +                       path[i].p_hdr = ext_block_hdr(path[i].p_bh);
>> +
>> +               if (!path[i].p_idx) {
>> +                       /* this level hasn't been touched yet */
>> +                       path[i].p_idx = EXT_LAST_INDEX(path[i].p_hdr);
>> +                       path[i].p_block = le16_to_cpu(path[i].p_hdr->eh_entries)+1;
>> +                       ext_debug("init index ptr: hdr 0x%p, num %d\n",
>> +                       path[i].p_hdr,
>> +                       le16_to_cpu(path[i].p_hdr->eh_entries));
>> +               }
>> +               else {
>> +                       /* we were already here, see at next index */
>> +                       path[i].p_idx--;
>> +               }
>> +
>> +               ext_debug("level %d - index, first 0x%p, cur 0x%p\n",
>> +               i, EXT_FIRST_INDEX(path[i].p_hdr),
>> +               path[i].p_idx);
>> +
>> +               /* go to the next level */
>> +               ext_debug("move to level %d (block %llu)\n",
>> +                               i + 1, ext4_idx_pblock(path[i].p_idx));
>> +               memset(path + i + 1, 0, sizeof(*path));
>> +               bh = sb_bread(sb, ext4_idx_pblock(path[i].p_idx));
>> +               if (!bh) {
>> +                       err = -EIO;
>> +                       break;
>> +               }
>> +               if (WARN_ON(i + 1>  depth)) {
>> +                       err = -EIO;
>> +                       break;
>> +               }
>> +               if (ext4_ext_check(inode, ext_block_hdr(bh), depth - i - 1)) {
>> +                       err = -EIO;
>> +                       break;
>> +               }
>> +
>> +               path[i + 1].p_bh = bh;
>> +
>> +               i++;
>> +
>> +       }
>> +out:
>> +       ext4_ext_drop_refs(path);
>> +       kfree(path);
>> +       ext4_journal_stop(handle);
>> +
>> +       return err ? err : last_block - start;
>> +
>> +}
>> +
>> +/*
>>   * called at mount time
>>   */
>>   void ext4_ext_init(struct super_block *sb)
>> @@ -4029,6 +4177,172 @@ next:
>>         return ret;
>>   }
>>
>> +/*
>> + * ext4_ext_test_block_flag
>> + * Tests the buffer head associated with the given block
>> + * to see if the state contains flag
>> + *
>> + * @inode:  The inode of the given file
>> + * @block:  The block to test
>> + * @flag:   The flag to check for
>> + *
>> + * Returns 0 on sucess or negative on err
>> + */
>> +static int ext4_ext_test_block_flag(struct inode *inode, ext4_lblk_t block, enum bh_state_bits flag){
> 
> (style) open { in new line.
> 
>> +       struct buffer_head *bh;
>> +       struct page *page;
>> +       struct address_space *mapping = inode->i_mapping;
>> +       loff_t block_offset;
>> +       int i, ret;
>> +       unsigned long flag_mask = 1<<  flag;
>> +
>> +       block_offset = block<<  EXT4_BLOCK_SIZE_BITS(inode->i_sb);
>> +       page = find_or_create_page(mapping, block_offset>>  PAGE_CACHE_SHIFT,
>> +       mapping_gfp_mask(mapping)&  ~__GFP_FS);
>> +
>> +       if (!page)
>> +               return -EIO;
>> +
>> +       if (!page_has_buffers(page))
>> +               create_empty_buffers(page, EXT4_BLOCK_SIZE(inode->i_sb), 0);
>> +
>> +       /* advance to the buffer that has the block offset  */
>> +       bh = page_buffers(page);
>> +       for (i = 0; i<  block_offset; i+=EXT4_BLOCK_SIZE(inode->i_sb)) {
>> +               bh = bh->b_this_page;
>> +       }
>> +
>> +       if(bh->b_state&  flag_mask)
>> +               ret = 0;
>> +       else
>> +               ret = -1;
>> +
>> +       unlock_page(page);
>> +       page_cache_release(page);
>> +
>> +       return ret;
>> +
>> +}
>> +
>> +/*
>> + * ext4_ext_punch_hole
>> + *
>> + * Punches a hole of "length" bytes in a file starting
>> + * at byte "offset"
>> + *
>> + * @inode:  The inode of the file to punch a hole in
>> + * @offset: The starting byte offset of the hole
>> + * @length: The length of the hole
>> + *
>> + */
>> +void ext4_ext_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>> +{
>> +       struct super_block *sb = inode->i_sb;
>> +       ext4_lblk_t first_block, last_block, num_blocks, iblock = 0;
>> +       struct address_space *mapping = inode->i_mapping;
>> +       struct ext4_map_blocks map;
>> +       handle_t *handle;
>> +       loff_t first_block_offset, last_block_offset, block_len;
>> +       int get_blocks_flags, err, ret = 0;
>> +
>> +       first_block = (offset + sb->s_blocksize - 1)
>> +>>  EXT4_BLOCK_SIZE_BITS(sb);
>> +       last_block = (offset+length)>>  EXT4_BLOCK_SIZE_BITS(sb);
>> +
>> +       first_block_offset = first_block<<  EXT4_BLOCK_SIZE_BITS(sb);
>> +       last_block_offset = last_block<<  EXT4_BLOCK_SIZE_BITS(sb);
>> +
>> +       err = ext4_writepage_trans_blocks(inode);
> 
> 1. (style) err is not an appropriate name (even though is it
> convenient to reuse it)
> 2. did you check if ext4_writepage_trans_blocks(inode) covers the credits
>      needed for splitting 1 extent into 3? I suppose it does if it also
> being used
>      when converting a middle part of an uninitialized extent, but I
> didn't check.
> 
>> +       handle = ext4_journal_start(inode, err);
>> +       if (IS_ERR(handle))
>> +               return;
>> +
>> +       /*
>> +        * Now we need to zero out the un block aligned data.
>> +        * If the file is smaller than a block, just
>> +        * zero out the middle and return
>> +        */
>> +       if(first_block>  last_block)
>> +               ext4_block_zero_page_range(handle, mapping, offset, length);
>> +       else{
>> +               /* zero out the head of the hole before the first block */
>> +               block_len  = first_block_offset - offset;
>> +               if(block_len>  0)
>> +                       ext4_block_zero_page_range(handle, mapping, offset, block_len);
>> +
>> +               /* zero out the tail of the hole after the last block */
>> +               block_len = offset + length - last_block_offset;
>> +               if(block_len>  0)
>> +                       ext4_block_zero_page_range(handle, mapping,
>> +                                       last_block_offset, block_len);
>> +       }
>> +
>> +       /* If there are no blocks to remove, return now */
>> +       if(first_block>= last_block){
>> +               ext4_journal_stop(handle);
>> +               return;
>> +       }
>> +
>> +       /* Clear pages associated with the hole */
>> +       if (mapping->nrpages)
>> +               invalidate_inode_pages2_range(mapping, offset>>  PAGE_CACHE_SHIFT,
>> +                                               (offset+length)>>  PAGE_CACHE_SHIFT );
>> +
>> +
>> +       /* Loop over all the blocks and identify blocks that need to be punched out */
>> +       iblock = first_block;
>> +       while(iblock<  last_block){
>> +               map.m_lblk = iblock;
>> +               map.m_len = last_block - iblock;
>> +               ret = ext4_map_blocks(handle, inode,&map, 0);
>> +
>> +               /* If the blocks are mapped, release them */
>> +               if(ret>  0){
>> +                       num_blocks = ret;
>> +                       ext4_ext_convert_blocks_uninit(inode, handle, iblock, num_blocks);
>> +                       ext4_ext_release_blocks(inode, iblock, iblock+num_blocks);
>> +                       goto next;
>> +               }
>> +
>> +               /*
>> +                * If they are not mapped
>> +                * check to see if they are punched out
>> +                */
>> +               ret = ext4_ext_lookup_hole(inode, iblock);
>> +               if(ret>  0){
>> +                       num_blocks = ret;
>> +                       goto next;
>> +               }
>> +
>> +               /*
>> +                * If the block could not be mapped, and
>> +                * its not already punched out,
>> +                * check to see if the block is delayed
>> +                */
>> +               if(ext4_ext_test_block_flag(inode, iblock, BH_Delay) == 0){
>> +                       get_blocks_flags = EXT4_GET_BLOCKS_CREATE | EXT4_GET_BLOCKS_DELALLOC_RESERVE;
>> +                       ret = ext4_map_blocks(handle, inode,&map, get_blocks_flags);
>> +                       /* If the blocks are found, release them */
>> +
>> +                       if(ret>  0){
>> +                               num_blocks = ret;
>> +                               ext4_ext_release_blocks(inode, iblock, iblock+num_blocks);
>> +                               goto next;
>> +                       }
>> +               }
>> +
>> +               /* If the block cannot be identified, just skip it */
>> +               num_blocks = 1;
>> +
>> +next:
>> +               iblock+=num_blocks;
>> +       }
>> +       ext4_mark_inode_dirty(handle, inode);
>> +
>> +       ext4_journal_stop(handle);
>> +
>> +}
>> +
>>
>>   static void ext4_falloc_update_inode(struct inode *inode,
>>                                 int mode, loff_t new_size, int update_ctime)
>> @@ -4079,10 +4393,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>         struct ext4_map_blocks map;
>>         unsigned int credits, blkbits = inode->i_blkbits;
>>
>> -       /* We only support the FALLOC_FL_KEEP_SIZE mode */
>> -       if (mode&  ~FALLOC_FL_KEEP_SIZE)
>> -               return -EOPNOTSUPP;
>> -
>>         /*
>>          * currently supporting (pre)allocate mode for extent-based
>>          * files _only_
>> @@ -4090,6 +4400,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>>         if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>>                 return -EOPNOTSUPP;
>>
>> +       if (mode&  FALLOC_FL_PUNCH_HOLE)
>> +               return ext4_punch_hole(inode, offset, len);
>> +
>>         map.m_lblk = offset>>  blkbits;
>>         /*
>>          * We can't just convert len to max_blocks because
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 28c9137..493c908 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4487,6 +4487,32 @@ int ext4_can_truncate(struct inode *inode)
>>   }
>>
>>   /*
>> + * ext4_punch_hole: punches a hole in a file by releaseing the blocks
>> + * associated with the given offset and length
>> + *
>> + * @inode:  File inode
>> + * @offset: The offset where the hole will begin
>> + * @len:    The length of the hole
>> + *
>> + * Returns: 0 on sucess or negative on failure
>> + */
>> +
>> +long  ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>> +{
>> +
>> +       if (!S_ISREG(inode->i_mode)==1)
>> +                return -ENOTSUPP;
> 
> (style) please drop the == 1. I am not even sure that !(0) is
> guarantied to return 1...
> 
>> +
>> +       if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
>> +               //TODO: Add support for non extent hole punching
>> +               return -ENOTSUPP;
>> +       }
>> +
>> +       ext4_ext_punch_hole(inode, offset, length);
>> +       return 0;
>> +}
>> +
>> +/*
>>   * ext4_truncate()
>>   *
>>   * We block out ext4_get_block() block instantiations across the entire
>> --
>> 1.7.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


Thx for the feedback!  I will check into the ext4_writepage_trans_blocks routine to make sure it has enough credits, and I will update the rest of the patch with the style fixes.

Allison Henderson

