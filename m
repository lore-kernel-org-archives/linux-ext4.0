From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks
 to Uninit Exts
Date: Tue, 01 Mar 2011 13:48:16 -0700
Message-ID: <4D6D5B90.9090209@linux.vnet.ibm.com>
References: <4D6C6318.2010105@linux.vnet.ibm.com> <AANLkTikrKpKUhJ=uW0JYmi1t4j1qZw5F4AKGPosn57by@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:37579 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1CAUsV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 15:48:21 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p21KjhUw010378
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:45:43 -0700
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p21KmIc7112978
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:48:18 -0700
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p21KmHGG027575
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:48:17 -0700
In-Reply-To: <AANLkTikrKpKUhJ=uW0JYmi1t4j1qZw5F4AKGPosn57by@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/1/2011 2:30 AM, Amir Goldstein wrote:
> On Tue, Mar 1, 2011 at 5:08 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> Hi All!
>>
>> This is the patch series for ext4 punch hole that I have been working on.
>> There is still a little more debugging that I would like to do with it,
>> but I've had some requests to see the patch, so I'm sending it out a bit
>> early.  Any feed back is appreciated.  Thx!
>
> Hi Allison,
>
> Very nice work!
>
> One meta comment is related to locking considerations with direct I/O.
> I am not all that familiar with all direct I/O paths (i.e. dioread_nolock),
> but I smell a possible race with holes initiation via direct I/O.
>
> The thing with direct I/O is that you have no flags to test the state
> of the block (did Eric just add a hash table to cope with another issue?).
> Direct I/O writes outside i_size are synchronous (i.e. i_mutex is held until
> I/O completion), but inside i_size, they may be a-synchronous.
> The case of initiating holes is currently handled with DIO_SKIP_HOLES
> by falling back to buffered I/O, although it could be handled by allocating
> an uninitialized extent.
> The case of writing to falloced space in handled by converting extents to
> initialized at async I/O completion.
>
> I am not sure there a race with hole punching here and I am not even sure
> that the description above is totally accurate (?), but it's a dark corner,
> which should to be reviewed carefully.
>

Alrighty, thx for pointing that out though, I will keep an eye out for 
it.  I'll see if I can set up some test cases that do what you describe 
to see how the code handles them.

>>
>> This first patch adds a function to convert a range of blocks
>> to an uninitialized extent.  This function will
>> be used to first convert the blocks to extents before
>> punching them out.
>>
>> This function also adds a routine to split an extent at
>> a given block.  This routine is used when a range of
>> blocks to be converted is only partially contained in
>> an extent.
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>> ---
>> :100644 100644 7516fb9... ab2e42e... M  fs/ext4/extents.c
>>   fs/ext4/extents.c |  185 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 185 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 7516fb9..ab2e42e 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2169,6 +2169,105 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
>>         return 0;
>>   }
>>
>> +/*
>> + * ext4_split_extents() Splits a given extent at the block "split"
>> + * @handle: The journal handle
>> + * @inode: The file inode
>> + * @split: The block where the extent will be split
>> + * @path: The path to the extent
>> + * @flags: flags used to insert the new extent
>> + */
>> +static int ext4_split_extents(handle_t *handle,
>> +                                       struct inode *inode,
>> +                                       ext4_lblk_t split,
>> +                                       struct ext4_ext_path *path,
>> +                                       int flags)
>> +{
>> +       struct ext4_extent *ex, newex, orig_ex, *i_ex;
>> +       struct ext4_extent *ex1 = NULL;
>> +       struct ext4_extent *ex2 = NULL;
>> +       struct ext4_extent_header *eh;
>> +       ext4_lblk_t ee_block;
>> +       unsigned int ee_len, depth;
>> +       ext4_fsblk_t newblock, origblock;
>> +       int err = 0;
>> +
>> +       ext_debug("ext4_split_extent: inode %lu, split %u\n", inode->i_ino, split);
>> +       ext4_ext_show_leaf(inode, path);
>> +
>> +       depth = ext_depth(inode);
>> +       eh = path[depth].p_hdr;
>> +       ex = path[depth].p_ext;
>> +       ee_block = le32_to_cpu(ex->ee_block);
>> +       ee_len = ext4_ext_get_actual_len(ex);
>> +
>> +       /* if the block is not actually in the extent, go to out */
>> +       if(split>  ee_block+ee_len || split<  ee_block)
>> +               goto out;
>> +
>> +       origblock = ee_block + ext4_ext_pblock(ex);
>> +       newblock = split - ee_block + ext4_ext_pblock(ex);
>> +       ext_debug("The new block is %llu, the orig block is: %llu\n", newblock, origblock);
>> +
>> +       /* save original block in case split fails */
>> +       orig_ex.ee_block = ex->ee_block;
>> +       orig_ex.ee_len   = cpu_to_le16(ee_len);
>> +       ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
>> +
>> +       err = ext4_ext_get_access(handle, inode, path + depth);
>> +       if (err)
>> +               goto out;
>> +
>> +       ex1 = ex;
>> +       ex1->ee_len = cpu_to_le16(split-ee_block);
>> +
>> +       ex2 =&newex;
>> +       ex2->ee_len = cpu_to_le16(ee_len-(split-ee_block));
>> +       ex2->ee_block = split;
>> +       ext4_ext_store_pblock(ex2, newblock);
>> +
>> +       if (ex1->ee_block != ex2->ee_block)
>> +               goto insert;
>> +
>> +       /* Mark modified extent as dirty */
>> +       err = ext4_ext_dirty(handle, inode, path + depth);
>> +       ext_debug("out here\n");
>> +       goto out;
>> +insert:
>> +
>> +       /*
>> +        * If this leaf cannot fit in any more extents
>> +        * insert it into another leaf
>> +        */
>> +       if(EXT_LAST_EXTENT(eh)>=  EXT_MAX_EXTENT(eh)){
>> +               err = ext4_ext_insert_extent(handle, inode, path,&newex, flags);
>> +               if (err)
>> +                       goto fix_extent_len;
>> +       }
>> +
>> +       /* otherwise just scoot all ther other extents down  */
>> +       else{
>> +               for(i_ex = EXT_LAST_EXTENT(eh); i_ex>  ex1; i_ex-- ){
>> +                       memcpy(i_ex+1, i_ex, sizeof(struct ext4_extent));
>> +               }
>> +               memcpy(ex1+1, ex2, sizeof(struct ext4_extent));
>> +               eh->eh_entries++;
>> +       }
>> +
>> +out:
>> +       ext4_ext_show_leaf(inode, path);
>> +       return err;
>> +
>> +fix_extent_len:
>> +       ex->ee_block = orig_ex.ee_block;
>> +       ex->ee_len   = orig_ex.ee_len;
>> +       ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
>> +       ext4_ext_mark_uninitialized(ex);
>> +       ext4_ext_dirty(handle, inode, path + depth);
>> +
>> +       return err;
>> +}
>> +
>>   static int
>>   ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>                 struct ext4_ext_path *path, ext4_lblk_t start)
>> @@ -3598,6 +3697,92 @@ out_stop:
>>         ext4_journal_stop(handle);
>>   }
>>
>> +/*
>> + * ext4_ext_convert_blocks_uninit()
>> + * Converts a range of blocks to uninitialized
>> + *
>> + * @inode:  The files inode
>> + * @handle: The journal handle
>
>
> (style) in all other functions, @handle comes before @inode
> I'm sorry, but this hurts my eyes :-)
>
>> + * @lblock: The logical block where the conversion will start
>> + * @len:    The max number of blocks to convert
>> + *
>> + * Returns the number of blocks successfully converted
>> + */
>> +static int ext4_ext_convert_blocks_uninit(struct inode *inode, handle_t *handle, ext4_lblk_t lblock, ext4_lblk_t len){
>> +
>> +       ext4_lblk_t ee_block, iblock;
>> +       struct ext4_ext_path *path;
>> +       struct ext4_extent *ex;
>> +       unsigned int ee_len;
>> +       int ret, err = 0;
>> +
>> +       iblock = lblock;
>> +       while(iblock<  lblock+len){
>> +
>> +               path = ext4_ext_find_extent(inode, lblock, NULL);
>> +
>> +               if(path == NULL)
>> +                       goto next;
>> +
>> +               err = ext4_ext_get_access(handle, inode, path);
>> +               if(err<  0)
>> +                       goto next;
>> +
>> +               ex = path->p_ext;
>> +               if(ex == NULL)
>> +                       goto next;
>> +
>> +               ee_block = le32_to_cpu(ex->ee_block);
>> +               ee_len = ext4_ext_get_actual_len(ex);
>> +
>> +               /*
>> +                * If the block is in the middle of the extent,
>> +                * split the extent to remove the head.
>> +                * Then find the new extent that contains the block
>> +                */
>> +               if(ee_block<  iblock){
>> +                       err = ext4_split_extents(handle, inode, iblock, path, 0);
>> +                       if(err)
>> +                               goto next;
>> +
>> +                       path = ext4_ext_find_extent(inode, iblock, NULL);
>> +
>> +                       if(path == NULL)
>> +                               goto next;
>> +
>> +                       ex = path->p_ext;
>> +                       if(ex == NULL)
>> +                               goto next;
>> +
>> +                       ee_block = le32_to_cpu(ex->ee_block);
>> +                       ee_len = ext4_ext_get_actual_len(ex);
>> +
>> +               }
>> +
>> +               /* If the extent exceeds len, split the extent to remove the tail */
>> +               if(ee_len>  len){
>> +                       err = ext4_split_extents(handle, inode, lblock+len, path, 0);
>> +                       if(err)
>> +                               goto next;
>> +
>> +                       ee_len = ext4_ext_get_actual_len(ex);
>> +               }
>> +
>> +               /* Mark the extent uninitialized */
>> +               ext4_ext_mark_uninitialized(ex);
>> +
>> +               iblock+=ex->ee_len;
>> +               ret+=ex->ee_len;
>> +               continue;
>> +next:
>> +               /* If the extent for this block cannot be found, skip it */
>> +               iblock++;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +
>>   static void ext4_falloc_update_inode(struct inode *inode,
>>                                 int mode, loff_t new_size, int update_ctime)
>>   {
>> --
>> 1.7.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thx for the feed back, I will get the style comments integrated too.

Allison Henderson

