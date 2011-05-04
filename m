From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 punch hole 4/5 v6] Ext4 Punch Hole Support: Map blocks
 punch hole flag
Date: Tue, 03 May 2011 20:15:29 -0700
Message-ID: <4DC0C4D1.4070200@linux.vnet.ibm.com>
References: <4DC031C1.4050703@linux.vnet.ibm.com> <1304467948.3069.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60583 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab1EDDPd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 23:15:33 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p442s2QK004936
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 22:54:02 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p443FWCD225570
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 23:15:32 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p443FV4B007140
	for <linux-ext4@vger.kernel.org>; Wed, 4 May 2011 00:15:31 -0300
In-Reply-To: <1304467948.3069.6.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/3/2011 5:12 PM, Mingming Cao wrote:
> On Tue, 2011-05-03 at 09:48 -0700, Allison Henderson wrote:
>> This patch adds a new flag to map blocks that specifies
>> the given range of blocks should be punched out.  Extents
>> are first converted to uninitialized extents before they are
>> punched out. Because punching a hole may require that the
>> extent be split, it is possible that the splitting may need
>> more blocks than are available.  To deal with this, reserved
>> blocks are temporarily borrowed to allow the split to proceed.
>> The borrowed blocks are then returned after the hole punch has
>> released more blocks.
>>
> Just want to make sure that in the case of ENOSPC, the reserved root
> blocks are used/consumed to allow extent being splitted and then punch
> hole being proceeded. The reserved blocks, if I understand right, is
> being used, not returned back. No?
>
> Mingming

Hi there,

That's correct, the last line of the description should have probably 
been removed to avoid confusion.  To clarify for others, in an earlier 
version of the set before we had this flag, we had code to convert root 
blocks to user blocks when there was not enough blocks to split the 
extents, and then the blocks would be converted back after the punch 
hole had free'd up more user blocks. But there was concern that this 
would cause a race condition with other processes also trying to 
allocate user blocks, so we took that code out and added this flag 
instead.  The flag only allows consumption of the root blocks, there is 
no logic for converting the blocks back anymore.  The blocks are just 
returned to the pool normally when the remove space routines release them.

Allison Henderson

>
>
>> The routine then returns the number of blocks successfully
>> punched out.
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>> ---
>> :100644 100644 0afb746... 7f0fcc1... M	fs/ext4/extents.c
>>   fs/ext4/extents.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++------
>>   1 files changed, 87 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 0afb746..7f0fcc1 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3290,15 +3290,19 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>   	ext4_fsblk_t newblock = 0;
>>   	int err = 0, depth, ret;
>>   	unsigned int allocated = 0;
>> +	unsigned int punched_out = 0;
>> +	unsigned int result = 0;
>>   	struct ext4_allocation_request ar;
>>   	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
>> +	struct ext4_map_blocks punch_map;
>>
>>   	ext_debug("blocks %u/%u requested for inode %lu\n",
>>   		  map->m_lblk, map->m_len, inode->i_ino);
>>   	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
>>
>>   	/* check in cache */
>> -	if (ext4_ext_in_cache(inode, map->m_lblk,&newex)) {
>> +	if (ext4_ext_in_cache(inode, map->m_lblk,&newex)&&
>> +		((flags&  EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0)) {
>>   		if (!newex.ee_start_lo&&  !newex.ee_start_hi) {
>>   			if ((flags&  EXT4_GET_BLOCKS_CREATE) == 0) {
>>   				/*
>> @@ -3363,16 +3367,84 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>   			ext_debug("%u fit into %u:%d ->  %llu\n", map->m_lblk,
>>   				  ee_block, ee_len, newblock);
>>
>> -			/* Do not put uninitialized extent in the cache */
>> -			if (!ext4_ext_is_uninitialized(ex)) {
>> -				ext4_ext_put_in_cache(inode, ee_block,
>> -							ee_len, ee_start);
>> -				goto out;
>> +			if ((flags&  EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0) {
>> +				/*
>> +				 * Do not put uninitialized extent
>> +				 * in the cache
>> +				 */
>> +				if (!ext4_ext_is_uninitialized(ex)) {
>> +					ext4_ext_put_in_cache(inode, ee_block,
>> +						ee_len, ee_start);
>> +					goto out;
>> +				}
>> +				ret = ext4_ext_handle_uninitialized_extents(
>> +					handle, inode, map, path, flags,
>> +					allocated, newblock);
>> +				return ret;
>>   			}
>> -			ret = ext4_ext_handle_uninitialized_extents(handle,
>> -					inode, map, path, flags, allocated,
>> -					newblock);
>> -			return ret;
>> +
>> +			/*
>> +			 * Punch out the map length, but only to the
>> +			 * end of the extent
>> +			 */
>> +			punched_out = allocated<  map->m_len ?
>> +				allocated : map->m_len;
>> +
>> +			/*
>> +			 * Sense extents need to be converted to
>> +			 * uninitialized, they must fit in an
>> +			 * uninitialized extent
>> +			 */
>> +			if (punched_out>  EXT_UNINIT_MAX_LEN)
>> +				punched_out = EXT_UNINIT_MAX_LEN;
>> +
>> +			punch_map.m_lblk = map->m_lblk;
>> +			punch_map.m_pblk = newblock;
>> +			punch_map.m_len = punched_out;
>> +			punch_map.m_flags = 0;
>> +
>> +			/* Check to see if the extent needs to be split */
>> +			if (punch_map.m_len != ee_len ||
>> +				punch_map.m_lblk != ee_block) {
>> +
>> +				ret = ext4_split_extent(handle, inode,
>> +				path,&punch_map, 0,
>> +				EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
>> +				EXT4_GET_BLOCKS_PRE_IO);
>> +
>> +				if (ret<  0) {
>> +					err = ret;
>> +					goto out2;
>> +				}
>> +				/*
>> +				 * find extent for the block at
>> +				 * the start of the hole
>> +				 */
>> +				ext4_ext_drop_refs(path);
>> +				kfree(path);
>> +
>> +				path = ext4_ext_find_extent(inode,
>> +				map->m_lblk, NULL);
>> +				if (IS_ERR(path)) {
>> +					err = PTR_ERR(path);
>> +					path = NULL;
>> +					goto out2;
>> +				}
>> +
>> +				depth = ext_depth(inode);
>> +				ex = path[depth].p_ext;
>> +				ee_len = ext4_ext_get_actual_len(ex);
>> +				ee_block = le32_to_cpu(ex->ee_block);
>> +				ee_start = ext4_ext_pblock(ex);
>> +
>> +			}
>> +
>> +			ext4_ext_mark_uninitialized(ex);
>> +
>> +			err = ext4_ext_remove_space(inode, map->m_lblk,
>> +				map->m_lblk + punched_out);
>> +
>> +			goto out2;
>>   		}
>>   	}
>>
>> @@ -3517,7 +3589,11 @@ out2:
>>   	}
>>   	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
>>   		newblock, map->m_len, err ? err : allocated);
>> -	return err ? err : allocated;
>> +
>> +	result = (flags&  EXT4_GET_BLOCKS_PUNCH_OUT_EXT) ?
>> +			punched_out : allocated;
>> +
>> +	return err ? err : result;
>>   }
>>
>>   void ext4_ext_truncate(struct inode *inode)
>
>

