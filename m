From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 punch hole 1/6 v5] Ext4 Punch Hole Support: Add flag to
 ext4_has_free_blocks
Date: Mon, 25 Apr 2011 12:53:16 -0700
Message-ID: <4DB5D12C.6020804@linux.vnet.ibm.com>
References: <4DAD3C98.3050308@linux.vnet.ibm.com> <BANLkTi=1PEcextZ03RXXHixzHtav1m2tfQ@mail.gmail.com> <BANLkTi=kX8Roeq1oDUqqYp76ihNfsrLKSg@mail.gmail.com> <BANLkTinPejmzuWukBLFj__NDdAoq+uwphg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33615 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab1DYTx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 15:53:28 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3PJV4nm021248
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 15:31:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3PJrQCK1192116
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 15:53:26 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3PJrPNY005129
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 15:53:26 -0400
In-Reply-To: <BANLkTinPejmzuWukBLFj__NDdAoq+uwphg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/25/2011 10:44 AM, Amir Goldstein wrote:
> On Mon, Apr 25, 2011 at 12:08 PM, Yongqiang Yang<xiaoqiangnk@gmail.com>  wrote:
>> On Mon, Apr 25, 2011 at 3:51 PM, Amir Goldstein<amir73il@gmail.com>  wrote:
>>> Hi Allison,
>>>
>>> Sorry for the late response.
>>> I find it hard to digest yet another set of flags,
>>> especially, since there is already an impressive set of
>>> flags for allocation hints, which is what USE_ROOTBLKS flag really is.
>>>
>>> So I think it would be much better to pass the flag in ext4_allocation_request
>>> and add the 'ar' argument to functions that don't have it, rather than adding
>>> a 'flags' argument.
>> It depends.  I had a look at Allison's patch and found that functions
>> influenced by the patch can be divided into two groups:
>>   1. one of which is extent related and led by ext4_ext_insert_extent()
>>   2. while other one of which is very low level such as
>> ext4_claim_free_blocks() which is used by ext4_da_reserve_space() in a
>> relatively hight level.
>>
>> So I think maybe it's a good idea for extent related functions, but
>> not for low level functions such as ext4_claim_free_blocks.
>>
>> Actually ext4_ext_insert_extent() seldom allocates blocks, because a
>> block can contain a lot of extents.  Thus adding 'ar' parameter to
>> ext4_ext_insert_extent() induces much unnecessary 'ar''s initializing.
>>
>
> Yeah, it's not clear what's the best way to handle this.
>  From a system designer point of view, I would suggest to add a capability flag
> for allocating from reserved space, but it is probably not going to be
> an easy fix to push.
>
>>
>>>
>>> If you do create a patch to pass 'ar' down to has_free_blocks()
>>> I will also be able to use it to pass the HINT_COWING flag.
>> HINT_COWING is being passed via 'ar'.
>>
>
> indeed, which is why if has_free_blocks gets 'ar' we will have that
> flag, which we do not need anyway, since we have the IS_COWING(handle) flag.
>
>> Yongqiang.
>>>
>>> Now here is another advise:
>>> In ext4_mb_new_blocks() after ext4_claim_free_blocks(), there is a call to
>>> dquot_alloc_block().
>>> You need to call dquot_alloc_block_nofail() when allocating for punch hole,
>>> otherwise punch hole can fail on quota limits.
>>> We already have a patch for doing that with HINT_COWING flag.
>>>
>>> I think maybe it is best if our groups (punch hole and snapshots) have
>>> a mutual 'next'
>>> repository we can work with to prepare for the 2.6.40 merge window.
>>> It would be even better, if Ted also collaborated his big alloc patches.
>>>
>>> What do you think guys?
>>>
>>> Amir.
>>>


Hi all,
Thx for the feed back, I will do some more investigation with the 
dquot_alloc_block_nofail() call and also the ext4_allocation_request 
parameter.  But feel free to throw more ideas out here too.  It sounds 
like we have more patches that are starting to intersect, so another 
repo may help us stay on the same page.

Allison Henderson



>>> On Tue, Apr 19, 2011 at 10:41 AM, Allison Henderson
>>> <achender@linux.vnet.ibm.com>  wrote:
>>>> This patch adds a flag to ext4_has_free_blocks which
>>>> enables the use of reserved blocks.  This will allow
>>>> a punch hole to proceed even if the disk is full.
>>>> Punching a hole may require additional blocks to first
>>>> split the extents.  The blocks will be reclaimed after
>>>> the punch hole completes.
>>>>
>>>> Because ext4_has_free_blocks is a low level function,
>>>> the flag needs to be passed down through several
>>>> functions listed below:
>>>>
>>>> ext4_ext_insert_extent
>>>> ext4_ext_create_new_leaf
>>>> ext4_ext_grow_indepth
>>>> ext4_ext_split
>>>> ext4_ext_new_meta_block
>>>> ext4_mb_new_blocks
>>>> ext4_claim_free_blocks
>>>> ext4_has_free_blocks
>>>>
>>>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>>>> ---
>>>> :100644 100644 97b970e... 794c4d2... M  fs/ext4/balloc.c
>>>> :100644 100644 4daaf2b... 6c1f415... M  fs/ext4/ext4.h
>>>> :100644 100644 dd2cb50... 0b186d9... M  fs/ext4/extents.c
>>>> :100644 100644 1a86282... ec890fd... M  fs/ext4/inode.c
>>>> :100644 100644 a5837a8... db8b120... M  fs/ext4/mballoc.c
>>>> :100644 100644 b545ca1... 2d9b12c... M  fs/ext4/xattr.c
>>>>   fs/ext4/balloc.c  |   17 ++++++++++-------
>>>>   fs/ext4/ext4.h    |   16 +++++++++++++---
>>>>   fs/ext4/extents.c |   27 ++++++++++++++++-----------
>>>>   fs/ext4/inode.c   |    6 +++---
>>>>   fs/ext4/mballoc.c |    5 +++--
>>>>   fs/ext4/xattr.c   |    2 +-
>>>>   6 files changed, 46 insertions(+), 27 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>>>> index 97b970e..794c4d2 100644
>>>> --- a/fs/ext4/balloc.c
>>>> +++ b/fs/ext4/balloc.c
>>>> @@ -493,7 +493,8 @@ error_return:
>>>>   * Check if filesystem has nblocks free&  available for allocation.
>>>>   * On success return 1, return 0 on failure.
>>>>   */
>>>> -static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
>>>> +static int ext4_has_free_blocks(struct ext4_sb_info *sbi,
>>>> +                               s64 nblocks, int flags)
>>>>   {
>>>>         s64 free_blocks, dirty_blocks, root_blocks;
>>>>         struct percpu_counter *fbc =&sbi->s_freeblocks_counter;
>>>> @@ -522,7 +523,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
>>>>         /* Hm, nope.  Are (enough) root reserved blocks available? */
>>>>         if (sbi->s_resuid == current_fsuid() ||
>>>>             ((sbi->s_resgid != 0)&&  in_group_p(sbi->s_resgid)) ||
>>>> -           capable(CAP_SYS_RESOURCE)) {
>>>> +           capable(CAP_SYS_RESOURCE) ||
>>>> +               (flags&  EXT4_HAS_FREE_BLKS_USE_ROOTBLKS)) {
>>>> +
>>>>                 if (free_blocks>= (nblocks + dirty_blocks))
>>>>                         return 1;
>>>>         }
>>>> @@ -531,9 +534,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
>>>>   }
>>>>
>>>>   int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>>>> -                                               s64 nblocks)
>>>> +                                               s64 nblocks, int flags)
>>>>   {
>>>> -       if (ext4_has_free_blocks(sbi, nblocks)) {
>>>> +       if (ext4_has_free_blocks(sbi, nblocks, flags)) {
>>>>                 percpu_counter_add(&sbi->s_dirtyblocks_counter, nblocks);
>>>>                 return 0;
>>>>         } else
>>>> @@ -554,7 +557,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>>>>   */
>>>>   int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>>>>   {
>>>> -       if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
>>>> +       if (!ext4_has_free_blocks(EXT4_SB(sb), 1, 0) ||
>>>>             (*retries)++>  3 ||
>>>>             !EXT4_SB(sb)->s_journal)
>>>>                 return 0;
>>>> @@ -577,7 +580,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>>>>   * error stores in errp pointer
>>>>   */
>>>>   ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>>>> -               ext4_fsblk_t goal, unsigned long *count, int *errp)
>>>> +               ext4_fsblk_t goal, unsigned long *count, int *errp, int flags)
>>>>   {
>>>>         struct ext4_allocation_request ar;
>>>>         ext4_fsblk_t ret;
>>>> @@ -588,7 +591,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>>>>         ar.goal = goal;
>>>>         ar.len = count ? *count : 1;
>>>>
>>>> -       ret = ext4_mb_new_blocks(handle,&ar, errp);
>>>> +       ret = ext4_mb_new_blocks(handle,&ar, errp, flags);
>>>>         if (count)
>>>>                 *count = ar.len;
>>>>         /*
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 4daaf2b..6c1f415 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -512,6 +512,8 @@ struct ext4_new_group_data {
>>>>         /* Convert extent to initialized after IO complete */
>>>>   #define EXT4_GET_BLOCKS_IO_CONVERT_EXT         (EXT4_GET_BLOCKS_CONVERT|\
>>>>                                          EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
>>>> +       /* Punch out blocks of an extent */
>>>> +#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT          0x0020
>>>>
>>>>   /*
>>>>   * Flags used by ext4_free_blocks
>>>> @@ -521,6 +523,11 @@ struct ext4_new_group_data {
>>>>   #define EXT4_FREE_BLOCKS_VALIDATED     0x0004
>>>>
>>>>   /*
>>>> + * Flags used by ext4_has_free_blocks
>>>> + */
>>>> +#define EXT4_HAS_FREE_BLKS_USE_ROOTBLKS 0x0001
>>>> +
>>>> +/*
>>>>   * ioctl commands
>>>>   */
>>>>   #define        EXT4_IOC_GETFLAGS               FS_IOC_GETFLAGS
>>>> @@ -1638,8 +1645,10 @@ extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
>>>>   extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
>>>>                         ext4_group_t group);
>>>>   extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>>>> -                       ext4_fsblk_t goal, unsigned long *count, int *errp);
>>>> -extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
>>>> +                       ext4_fsblk_t goal, unsigned long *count,
>>>> +                       int *errp, int flags);
>>>> +extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>>>> +                                       s64 nblocks, int flags);
>>>>   extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
>>>>                                 ext4_fsblk_t block, unsigned long count);
>>>>   extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
>>>> @@ -1696,7 +1705,8 @@ extern long ext4_mb_max_to_scan;
>>>>   extern int ext4_mb_init(struct super_block *, int);
>>>>   extern int ext4_mb_release(struct super_block *);
>>>>   extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
>>>> -                               struct ext4_allocation_request *, int *);
>>>> +                               struct ext4_allocation_request *,
>>>> +                               int *, int flags);
>>>>   extern int ext4_mb_reserve_blocks(struct super_block *, int);
>>>>   extern void ext4_discard_preallocations(struct inode *);
>>>>   extern int __init ext4_init_mballoc(void);
>>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>>> index dd2cb50..0b186d9 100644
>>>> --- a/fs/ext4/extents.c
>>>> +++ b/fs/ext4/extents.c
>>>> @@ -192,12 +192,12 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
>>>>   static ext4_fsblk_t
>>>>   ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
>>>>                         struct ext4_ext_path *path,
>>>> -                       struct ext4_extent *ex, int *err)
>>>> +                       struct ext4_extent *ex, int *err, int flags)
>>>>   {
>>>>         ext4_fsblk_t goal, newblock;
>>>>
>>>>         goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
>>>> -       newblock = ext4_new_meta_blocks(handle, inode, goal, NULL, err);
>>>> +       newblock = ext4_new_meta_blocks(handle, inode, goal, NULL, err, flags);
>>>>         return newblock;
>>>>   }
>>>>
>>>> @@ -793,7 +793,7 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
>>>>   */
>>>>   static int ext4_ext_split(handle_t *handle, struct inode *inode,
>>>>                                 struct ext4_ext_path *path,
>>>> -                               struct ext4_extent *newext, int at)
>>>> +                               struct ext4_extent *newext, int at, int flags)
>>>>   {
>>>>         struct buffer_head *bh = NULL;
>>>>         int depth = ext_depth(inode);
>>>> @@ -847,7 +847,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
>>>>         ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
>>>>         for (a = 0; a<  depth - at; a++) {
>>>>                 newblock = ext4_ext_new_meta_block(handle, inode, path,
>>>> -                                                  newext,&err);
>>>> +                                                  newext,&err, flags);
>>>>                 if (newblock == 0)
>>>>                         goto cleanup;
>>>>                 ablocks[a] = newblock;
>>>> @@ -1057,7 +1057,7 @@ cleanup:
>>>>   */
>>>>   static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>>>>                                         struct ext4_ext_path *path,
>>>> -                                       struct ext4_extent *newext)
>>>> +                                       struct ext4_extent *newext, int flags)
>>>>   {
>>>>         struct ext4_ext_path *curp = path;
>>>>         struct ext4_extent_header *neh;
>>>> @@ -1065,7 +1065,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>>>>         ext4_fsblk_t newblock;
>>>>         int err = 0;
>>>>
>>>> -       newblock = ext4_ext_new_meta_block(handle, inode, path, newext,&err);
>>>> +       newblock = ext4_ext_new_meta_block(handle, inode, path,
>>>> +               newext,&err, flags);
>>>>         if (newblock == 0)
>>>>                 return err;
>>>>
>>>> @@ -1141,7 +1142,7 @@ out:
>>>>   */
>>>>   static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
>>>>                                         struct ext4_ext_path *path,
>>>> -                                       struct ext4_extent *newext)
>>>> +                                       struct ext4_extent *newext, int flags)
>>>>   {
>>>>         struct ext4_ext_path *curp;
>>>>         int depth, i, err = 0;
>>>> @@ -1161,7 +1162,7 @@ repeat:
>>>>         if (EXT_HAS_FREE_INDEX(curp)) {
>>>>                 /* if we found index with free entry, then use that
>>>>                  * entry: create all needed subtree and add new leaf */
>>>> -               err = ext4_ext_split(handle, inode, path, newext, i);
>>>> +               err = ext4_ext_split(handle, inode, path, newext, i, flags);
>>>>                 if (err)
>>>>                         goto out;
>>>>
>>>> @@ -1174,7 +1175,7 @@ repeat:
>>>>                         err = PTR_ERR(path);
>>>>         } else {
>>>>                 /* tree is full, time to grow in depth */
>>>> -               err = ext4_ext_grow_indepth(handle, inode, path, newext);
>>>> +               err = ext4_ext_grow_indepth(handle, inode, path, newext, flags);
>>>>                 if (err)
>>>>                         goto out;
>>>>
>>>> @@ -1668,6 +1669,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
>>>>         int depth, len, err;
>>>>         ext4_lblk_t next;
>>>>         unsigned uninitialized = 0;
>>>> +       int free_blks_flags = 0;
>>>>
>>>>         if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
>>>>                 EXT4_ERROR_INODE(inode, "ext4_ext_get_actual_len(newext) == 0");
>>>> @@ -1742,7 +1744,10 @@ repeat:
>>>>          * There is no free space in the found leaf.
>>>>          * We're gonna add a new leaf in the tree.
>>>>          */
>>>> -       err = ext4_ext_create_new_leaf(handle, inode, path, newext);
>>>> +       if (flag&  EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
>>>> +               free_blks_flags = EXT4_HAS_FREE_BLKS_USE_ROOTBLKS;
>>>> +       err = ext4_ext_create_new_leaf(handle, inode, path,
>>>> +               newext, free_blks_flags);
>>>>         if (err)
>>>>                 goto cleanup;
>>>>         depth = ext_depth(inode);
>>>> @@ -3446,7 +3451,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>>>         else
>>>>                 /* disable in-core preallocation for non-regular files */
>>>>                 ar.flags = 0;
>>>> -       newblock = ext4_mb_new_blocks(handle,&ar,&err);
>>>> +       newblock = ext4_mb_new_blocks(handle,&ar,&err, 0);
>>>>         if (!newblock)
>>>>                 goto out2;
>>>>         ext_debug("allocate new block: goal %llu, found %llu/%u\n",
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 1a86282..ec890fd 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -640,7 +640,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>>>>                 count = target;
>>>>                 /* allocating blocks for indirect blocks and direct blocks */
>>>>                 current_block = ext4_new_meta_blocks(handle, inode,
>>>> -                                                       goal,&count, err);
>>>> +                                                       goal,&count, err, 0);
>>>>                 if (*err)
>>>>                         goto failed_out;
>>>>
>>>> @@ -686,7 +686,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
>>>>                 /* enable in-core preallocation only for regular files */
>>>>                 ar.flags = EXT4_MB_HINT_DATA;
>>>>
>>>> -       current_block = ext4_mb_new_blocks(handle,&ar, err);
>>>> +       current_block = ext4_mb_new_blocks(handle,&ar, err, 0);
>>>>         if (unlikely(current_block + ar.len>  EXT4_MAX_BLOCK_FILE_PHYS)) {
>>>>                 EXT4_ERROR_INODE(inode,
>>>>                                  "current_block %llu + ar.len %d>  %d!",
>>>> @@ -1930,7 +1930,7 @@ repeat:
>>>>          * We do still charge estimated metadata to the sb though;
>>>>          * we cannot afford to run out of free blocks.
>>>>          */
>>>> -       if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
>>>> +       if (ext4_claim_free_blocks(sbi, md_needed + 1, 0)) {
>>>>                 dquot_release_reservation_block(inode, 1);
>>>>                 if (ext4_should_retry_alloc(inode->i_sb,&retries)) {
>>>>                         yield();
>>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>>> index a5837a8..db8b120 100644
>>>> --- a/fs/ext4/mballoc.c
>>>> +++ b/fs/ext4/mballoc.c
>>>> @@ -4276,7 +4276,8 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
>>>>   * to usual allocation
>>>>   */
>>>>   ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>>> -                               struct ext4_allocation_request *ar, int *errp)
>>>> +                               struct ext4_allocation_request *ar, int *errp,
>>>> +                               int flags)
>>>>   {
>>>>         int freed;
>>>>         struct ext4_allocation_context *ac = NULL;
>>>> @@ -4303,7 +4304,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>>>                  * there is enough free blocks to do block allocation
>>>>                  * and verify allocation doesn't exceed the quota limits.
>>>>                  */
>>>> -               while (ar->len&&  ext4_claim_free_blocks(sbi, ar->len)) {
>>>> +               while (ar->len&&  ext4_claim_free_blocks(sbi, ar->len, flags)) {
>>>>                         /* let others to free the space */
>>>>                         yield();
>>>>                         ar->len = ar->len>>  1;
>>>> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
>>>> index b545ca1..2d9b12c 100644
>>>> --- a/fs/ext4/xattr.c
>>>> +++ b/fs/ext4/xattr.c
>>>> @@ -821,7 +821,7 @@ inserted:
>>>>                                 goal = goal&  EXT4_MAX_BLOCK_FILE_PHYS;
>>>>
>>>>                         block = ext4_new_meta_blocks(handle, inode,
>>>> -                                                 goal, NULL,&error);
>>>> +                                                 goal, NULL,&error, 0);
>>>>                         if (error)
>>>>                                 goto cleanup;
>>>>
>>>> --
>>>> 1.7.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

