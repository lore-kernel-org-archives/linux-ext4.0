From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 punch hole 3/5 v6] Ext4 Punch Hole Support: Punch out extents
Date: Thu, 05 May 2011 18:11:29 -0700
Message-ID: <4DC34AC1.8090505@linux.vnet.ibm.com>
References: <4DC031BE.8070807@linux.vnet.ibm.com> <BANLkTi=yXiv0emuC7h9eUGs1AiJNv1aWNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:37911 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1EFBLj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 21:11:39 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4618iG9007605
	for <linux-ext4@vger.kernel.org>; Thu, 5 May 2011 19:08:44 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p461BWPV362340
	for <linux-ext4@vger.kernel.org>; Thu, 5 May 2011 19:11:32 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p461BW59032115
	for <linux-ext4@vger.kernel.org>; Thu, 5 May 2011 19:11:32 -0600
In-Reply-To: <BANLkTi=yXiv0emuC7h9eUGs1AiJNv1aWNw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/5/2011 12:41 AM, Yongqiang Yang wrote:
> On Wed, May 4, 2011 at 12:47 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> This patch modifies the truncate routines to support hole punching
>> Below is a brief summary of the patches changes:
>>
>> - Added end param to ext_ext4_rm_leaf
>>         This function has been modified to accept an end parameter
>>         which enables it to punch holes in leafs instead of just
>>         truncating them.
>>
>> - Implemented the "remove head" case in the ext_remove_blocks routine
>>         This routine is used by ext_ext4_rm_leaf to remove the tail
>>         of an extent during a truncate.  The new ext_ext4_rm_leaf
>>         routine will now also use it to remove the head of an extent in the
>>         case that the hole covers a region of blocks at the beginning
>>         of an extent.
>>
>> - Added "end" param to ext4_ext_remove_space routine
>>         This function has been modified to accept a stop parameter, which
>>         is passed through to ext4_ext_rm_leaf.
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>> ---
>> :100644 100644 7398a59... 0afb746... M  fs/ext4/extents.c
>>   fs/ext4/extents.c |  160 ++++++++++++++++++++++++++++++++++++++++++++++------
>>   1 files changed, 141 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 7398a59..0afb746 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -46,6 +46,13 @@
>>
>>   #include<trace/events/ext4.h>
>>
>> +static int ext4_split_extent(handle_t *handle,
>> +                               struct inode *inode,
>> +                               struct ext4_ext_path *path,
>> +                               struct ext4_map_blocks *map,
>> +                               int split_flag,
>> +                               int flags);
>> +
>>   static int ext4_ext_truncate_extend_restart(handle_t *handle,
>>                                             struct inode *inode,
>>                                             int needed)
>> @@ -2198,8 +2205,16 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
>>                 ext4_free_blocks(handle, inode, NULL, start, num, flags);
>>         } else if (from == le32_to_cpu(ex->ee_block)
>>                    &&  to<= le32_to_cpu(ex->ee_block) + ee_len - 1) {
>> -               printk(KERN_INFO "strange request: removal %u-%u from %u:%u\n",
>> -                       from, to, le32_to_cpu(ex->ee_block), ee_len);
>> +               /* head removal */
>> +               ext4_lblk_t num;
>> +               ext4_fsblk_t start;
>> +
>> +               num = to - from;
>> +               start = ext4_ext_pblock(ex);
>> +
>> +               ext_debug("free first %u blocks starting %llu\n", num, start);
>> +               ext4_free_blocks(handle, inode, 0, start, num, flags);
>> +
>>         } else {
>>                 printk(KERN_INFO "strange request: removal(2) "
>>                                 "%u-%u from %u:%u\n",
>> @@ -2208,9 +2223,22 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
>>         return 0;
>>   }
>>
>> +
>> +/*
>> + * ext4_ext_rm_leaf() Removes the extents associated with the
>> + * blocks appearing between "start" and "end", and splits the extents
>> + * if "start" and "end" appear in the same extent
>> + *
>> + * @handle: The journal handle
>> + * @inode:  The files inode
>> + * @path:   The path to the leaf
>> + * @start:  The first block to remove
>> + * @end:   The last block to remove
>> + */
>>   static int
>>   ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>> -               struct ext4_ext_path *path, ext4_lblk_t start)
>> +               struct ext4_ext_path *path, ext4_lblk_t start,
>> +               ext4_lblk_t end)
>>   {
>>         int err = 0, correct_index = 0;
>>         int depth = ext_depth(inode), credits;
>> @@ -2221,6 +2249,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>         unsigned short ex_ee_len;
>>         unsigned uninitialized = 0;
>>         struct ext4_extent *ex;
>> +       struct ext4_map_blocks map;
>>
>>         /* the header must be checked already in ext4_ext_remove_space() */
>>         ext_debug("truncate since %u in leaf\n", start);
>> @@ -2250,31 +2279,95 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>                 path[depth].p_ext = ex;
>>
>>                 a = ex_ee_block>  start ? ex_ee_block : start;
>> -               b = ex_ee_block + ex_ee_len - 1<  EXT_MAX_BLOCK ?
>> -                       ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCK;
>> +               b = ex_ee_block+ex_ee_len - 1<  end ?
>> +                       ex_ee_block+ex_ee_len - 1 : end;
>>
>>                 ext_debug("  border %u:%u\n", a, b);
>>
>> -               if (a != ex_ee_block&&  b != ex_ee_block + ex_ee_len - 1) {
>> -                       block = 0;
>> -                       num = 0;
>> -                       BUG();
>> +               /* If this extent is beyond the end of the hole, skip it */
>> +               if (end<= ex_ee_block) {
>> +                       ex--;
>> +                       ex_ee_block = le32_to_cpu(ex->ee_block);
>> +                       ex_ee_len = ext4_ext_get_actual_len(ex);
>> +                       continue;
>> +               } else if (a != ex_ee_block&&
>> +                       b != ex_ee_block + ex_ee_len - 1) {
>> +                       /*
>> +                        * If this is a truncate, then this condition should
>> +                        * never happen because at least one of the end points
>> +                        * needs to be on the edge of the extent.
>> +                        */
>> +                       if (end == EXT_MAX_BLOCK) {
>> +                               ext_debug("  bad truncate %u:%u\n",
>> +                                               start, end);
>> +                               block = 0;
>> +                               num = 0;
>> +                               err = -EIO;
>> +                               goto out;
>> +                       }
>> +                       /*
>> +                        * else this is a hole punch, so the extent needs to
>> +                        * be split since neither edge of the hole is on the
>> +                        * extent edge
>> +                        */
>> +                       else{
>> +                               map.m_pblk = ext4_ext_pblock(ex);
>> +                               map.m_lblk = ex_ee_block;
>> +                               map.m_len = b - ex_ee_block;
>> +
>> +                               err = ext4_split_extent(handle,
>> +                                       inode, path,&map, 0,
>> +                                       EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
>> +                                       EXT4_GET_BLOCKS_PRE_IO);
>> +
>> +                               if (err<  0)
>> +                                       goto out;
>> +
>> +                               ex_ee_len = ext4_ext_get_actual_len(ex);
>> +
>> +                               b = ex_ee_block+ex_ee_len - 1<  end ?
>> +                                       ex_ee_block+ex_ee_len - 1 : end;
>> +
>> +                               /* Then remove tail of this extent */
>> +                               block = ex_ee_block;
>> +                               num = a - block;
>> +                       }
>>                 } else if (a != ex_ee_block) {
>>                         /* remove tail of the extent */
>>                         block = ex_ee_block;
>>                         num = a - block;
>>                 } else if (b != ex_ee_block + ex_ee_len - 1) {
>>                         /* remove head of the extent */
>> -                       block = a;
>> -                       num = b - a;
>> -                       /* there is no "make a hole" API yet */
>> -                       BUG();
>> +                       block = b;
>> +                       num =  ex_ee_block + ex_ee_len - b;
>> +
>> +                       /*
>> +                        * If this is a truncate, this condition
>> +                        * should never happen
>> +                        */
>> +                       if (end == EXT_MAX_BLOCK) {
>> +                               ext_debug("  bad truncate %u:%u\n",
>> +                                       start, end);
>> +                               err = -EIO;
>> +                               goto out;
>> +                       }
>>                 } else {
>>                         /* remove whole extent: excellent! */
>>                         block = ex_ee_block;
>>                         num = 0;
>> -                       BUG_ON(a != ex_ee_block);
>> -                       BUG_ON(b != ex_ee_block + ex_ee_len - 1);
>> +                       if (a != ex_ee_block) {
>> +                               ext_debug("  bad truncate %u:%u\n",
>> +                                       start, end);
>> +                               err = -EIO;
>> +                               goto out;
>> +                       }
>> +
>> +                       if (b != ex_ee_block + ex_ee_len - 1) {
>> +                               ext_debug("  bad truncate %u:%u\n",
>> +                                       start, end);
>> +                               err = -EIO;
>> +                               goto out;
>> +                       }
>>                 }
>>
>>                 /*
>> @@ -2305,7 +2398,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>                 if (num == 0) {
>>                         /* this extent is removed; mark slot entirely unused */
>>                         ext4_ext_store_pblock(ex, 0);
>> -                       le16_add_cpu(&eh->eh_entries, -1);
>> +               } else if (block != ex_ee_block) {
>> +                       /*
>> +                        * If this was a head removal, then we need to update
>> +                        * the physical block since it is now at a different
>> +                        * location
>> +                        */
>> +                       ext4_ext_store_pblock(ex, ext4_ext_pblock(ex) + (b-a));
>>                 }
>>
>>                 ex->ee_block = cpu_to_le32(block);
>> @@ -2321,6 +2420,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>                 if (err)
>>                         goto out;
>>
>> +               /*
>> +                * If the extent was completely released,
>> +                * we need to remove it from the leaf
>> +                */
>> +               if (num == 0) {
>> +                       if (end != EXT_MAX_BLOCK) {
>> +                               /*
>> +                                * For hole punching, we need to scoot all the
>> +                                * extents up when an extent is removed so that
>> +                                * we dont have blank extents in the middle
>> +                                */
>> +                               memmove(ex, ex+1, (EXT_LAST_EXTENT(eh) - ex) *
>> +                                       sizeof(struct ext4_extent));
>> +
>> +                               /* Now get rid of the one at the end */
>> +                               memset(EXT_LAST_EXTENT(eh), 0,
>> +                                       sizeof(struct ext4_extent));
>> +                       }
>> +                       le16_add_cpu(&eh->eh_entries, -1);
>> +               }
>> +
>>                 ext_debug("new extent: %u:%u:%llu\n", block, num,
>>                                 ext4_ext_pblock(ex));
>>                 ex--;
>> @@ -2361,7 +2481,8 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
>>         return 1;
>>   }
>>
>> -static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
>> +static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
>> +                               ext4_lblk_t end)
>>   {
>>         struct super_block *sb = inode->i_sb;
>>         int depth = ext_depth(inode);
>> @@ -2400,7 +2521,8 @@ again:
>>         while (i>= 0&&  err == 0) {
>>                 if (i == depth) {
>>                         /* this is leaf block */
>> -                       err = ext4_ext_rm_leaf(handle, inode, path, start);
>> +                       err = ext4_ext_rm_leaf(handle, inode, path,
>> +                                       start, end);
> Hi there,
>
> Sorry for so late voice.
>
> ext4_ext_remove_space() are supposed to be used by truncate, so it
> remove blocks from EOF to start as indicated by while-loop.   Now it
> has an end, so I think we'd better limit the while loop from the end
> to the start, but not from EOF to the start.
>
> we can achieve this by assigning path right before while-loop.

Hi there,

Well, I tried setting the path using find_extent, but it doesnt look 
like it quite worked out. Could you expand a little more on this?  It is 
not immediately clear to me how we can do this by setting path.  It 
looks like path is an array of paths that keep track of where we are in 
the tree.  The current sequence of paths represent the current location, 
but I dont know how we could set up a particular sequence of paths with 
out walking into the tree to know what it is.  I think the while loop 
just detects when the search has come back around to top of the tree. 
If I understand the code correctly, we would need a sequence of the 
paths starting at the  deepest path that can still descend to all the 
extents in the hole, and the sequence would need to end at the path that 
points to the extent that contains the end of the hole. Thus limiting 
the search to only that subtree that spans the hole.  At least that is 
my interpretation of the code.  It that correct, or maybe there is 
something I missed?

If that is how it works, maybe what we could do instead check 
(path[i].p_idx->ei_block < end) when deciding weather or not to descend? 
  I think that would get rid of needlessly walking space that is beyond 
the end of the hole.  And then when we return from the ext4_ext_rm_leaf, 
we can check to see if the leaf contains extents appearing before the 
hole, and then quit out if it does.  Does that sound correct?  Thx!

Allison Henderson

>
>>                         /* root level has p_bh == NULL, brelse() eats this */
>>                         brelse(path[i].p_bh);
>>                         path[i].p_bh = NULL;
>> @@ -3443,7 +3565,7 @@ void ext4_ext_truncate(struct inode *inode)
>>
>>         last_block = (inode->i_size + sb->s_blocksize - 1)
>>                         >>  EXT4_BLOCK_SIZE_BITS(sb);
>> -       err = ext4_ext_remove_space(inode, last_block);
>> +       err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCK);
>>
>>         /* In a multi-transaction truncate, we only make the final
>>          * transaction synchronous.
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>

