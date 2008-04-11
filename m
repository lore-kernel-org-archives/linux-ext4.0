From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 2/5] ext4: online defrag-- Allocate new contiguous	blocks
 with mballoc
Date: Fri, 11 Apr 2008 16:32:26 +0900
Message-ID: <47FF140A.2070702@rs.jp.nec.com>
References: <200803060001.AA00322@TNESG9526.rs.jp.nec.com>	 <1204934917.14884.70.camel@localhost.localdomain> <1204939249.14884.120.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1204939249.14884.120.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello.
Thank you for review comments.

Mingming Cao wrote:
>> +	while (--ppos >= 0) {
>> +		if (EXT_LAST_INDEX(path[ppos].p_hdr) >
>> +		    path[ppos].p_idx) {
>> +			int cur_ppos = ppos;
>> +
>> +			/* index block */
>> +			path[ppos].p_idx++;
>> +			path[ppos].p_block =
>> +				idx_pblock(path[ppos].p_idx);
>> +			if (path[ppos+1].p_bh)
>> +				brelse(path[ppos+1].p_bh);
>> +			path[ppos+1].p_bh =
>> +				sb_bread(inode->i_sb, path[ppos].p_block);
>> +			if (!path[ppos+1].p_bh)
>> +				return  -EIO;
>> +			path[ppos+1].p_hdr =
>> +				ext_block_hdr(path[ppos+1].p_bh);
>> +
>> +			/* Halfway index block */
>> +			while (++cur_ppos < leaf_ppos) {
>> +				path[cur_ppos].p_idx =
>> +					EXT_FIRST_INDEX(path[cur_ppos].p_hdr);
>> +				path[cur_ppos].p_block =
>> +					idx_pblock(path[cur_ppos].p_idx);
>> +				if (path[cur_ppos+1].p_bh)
>> +					brelse(path[cur_ppos+1].p_bh);
>> +				path[cur_ppos+1].p_bh = sb_bread(inode->i_sb,
>> +					path[cur_ppos].p_block);
>> +				if (!path[cur_ppos+1].p_bh)
>> +					return  -EIO;
> 
> bh are not proper released at error case

In error case, bh is released by ext4_ext_drop_refs()
in ext4_defrag() which calls this function.
Since the resource should be released in the function where we got it,
I will fix this.

>> +	if (cmd == EXT4_IOC_FIBMAP) {
>> +		ext4_fsblk_t __user *p = (ext4_fsblk_t __user *)arg;
>> +		ext4_fsblk_t block = 0;
>> +		struct address_space *mapping = filp->f_mapping;
>> +
> 
>> +		if (copy_from_user(&block, (ext4_fsblk_t __user *)arg,
>> +					sizeof(block)))
>> +			return -EFAULT;
>> +
>> +		lock_kernel();
>> +		block = ext4_bmap(mapping, block);
>> +		unlock_kernel();
>> +
> 
> I am little surprised to find that bmap needs to be called with the big kernel lock....

As you said, the big kernel lock is unnecessary.
It has already been removed in the latest defrag patches.

But why does current FIBMAP take the big kernel lock as follows?

static int ioctl_fibmap(struct file *filp, int __user *p)
{
        struct address_space *mapping = filp->f_mapping;
        int res, block;
..
        lock_kernel();
        res = mapping->a_ops->bmap(mapping, block);
        unlock_kernel();
        return put_user(res, p);
}


>> +		return put_user(block, p);
>> +	} else if (cmd == EXT4_IOC_DEFRAG) {
>> +		struct ext4_ext_defrag_data defrag;
>> +
>>
> 
> Perhaps need to check if inode in read-only mode?
> 

Yes. We should check the file permission.


> I assume this defrag only handles extents based file? We need to check the file type somewhere, so for indirect-based
> files it could handles failure case smoothly.
> 

Yes, ext4 online defrag supports only extents based file.
Before ext4_defrag() processing, ext4_defrag_ioctl() checks the file type.


>> +	/* Calculate group nubmer of org_inode block */
>> +	if (phase == DEFRAG_FORCE_VICTIM) {
>> +		org_path = ext4_ext_find_extent(org_inode, iblock, org_path);
>> +		if (IS_ERR(org_path)) {
>> +			err = PTR_ERR(org_path);
>> +			org_path = NULL;
>> +			goto out2;
>> +		}
>> +		ext4_get_group_no_and_offset(org_inode->i_sb,
>> +				ext_pblock(org_path[org_depth].p_ext),
>> +				&org_grp_no, &org_blk_off);
>> +		ar.excepted_group = org_grp_no;
> 
> In the DEFRAG_FORCE_VICTIM mode, I assume you wants victim files to move out of the block group to free some space
> for defraging. Should the target block group to allocate from is set as the same as the block group that the file-to-defrag
> located?
>

Exactly.
I add it to my TODO list.


>> +	while (alloc_total != total_blocks) {
>> +		credits = ext4_ext_calc_credits_for_insert(dest_inode,
>> +							dest_path);
>> +		handle = ext4_ext_journal_restart(handle,
>> +				credits + EXT4_TRANS_META_BLOCKS);
>> +
>> +		if (IS_ERR(handle))
>> +			return PTR_ERR(handle);
>> +
>> +		newblock = ext4_mb_new_blocks(handle, &ar, &err);
>> +
>>
> 
> I am not sure, could we reuse the generic ext4_ext_get_blocks_wrap() function to do the allocation?
> Would be nice to avoid code duplication here. Also I don't see the defrag takes advantage of the
> in-core preallocation and group locality feature combined in mballoc here.
> 

We need to set the goal offset which is passed from user-space to
goal entry of allocation_request structure when defrag -r and -f mode.
So we can't reuse the generic ext4_ext_get_blocks_wrap() function.


>> +		} else {
>> +			/*
>> +			 * Dirty buffer_head causes the overwriting
>> +			 * if ext4_mb_new_blocks() allocates the block
>> +			 * which used to be the metadata block.
>> +			 * We should call unmap_underlying_metadata()
>> +			 * to clear the dirty flag.
>> +			 */
>> +			for (len_cnt = 0; len_cnt < ar.len; len_cnt++) {
>> +				bh = sb_find_get_block(org_sb,
>> +							newblock + len_cnt);
>> +				unmap_underlying_metadata(org_sb->s_bdev,
>> +							newblock + len_cnt);
>> +			}
>> +
> 
> Not sure why we are doing this, ext4_mb_new_blocks() does well to handle the reuse of a block that used to be a metablock,
> or I missed something here....
> 

Um.. I think it is necessary to prevent data corruption
because defrag calls ext4_mb_new_blocks() directly.


>> +			case DEFRAG_FORCE_VICTIM:
>> +				/*
>> +				 * We can't allocate new blocks in the same
>> +				 * block group.
>> +				 */
>> +				if (dest_grp_no == org_grp_no) {
>> +					printk(KERN_ERR "ext4 defrag: "
>> +						"Failed to allocate victim file"
>> +						" to other block group\n");
>> +					ext4_free_blocks(handle, org_inode,
>> +						newblock, ar.len, metadata);
>> +					err = -ENOSPC;
>> +					goto out;
>> +				}
>> +				break;
> Previously the goal allocation group for the dest_inode is set to the same 
> as org_grp_no before the allocation in the VICTIM mode. so the warning could happen
> often?
> 

org_grp_no == dest_grp_no is a rare case, because org_grp_no is set
to excepted_group entry of ext4_allocation_request structure,
and we try to skip this block group number in ext4_mb_new_block().
But it will rarely happen(it means there is no space to allocate blocks
in other block group except in org_grop_no).


>> +			case DEFRAG_FORCE_GATHER:
>>
> I missed what this phase for?

DEFRAG_FORCE_GATHER means to make sufficient space in -f mode.
I added more comments for these phases in the latest defrag patches.

>> +				/*
>> +				 * Maybe reserved blocks are already used by
>> +				 * other process.
>> +				 */
>> +				if (dest_grp_no != goal_grp_no
>> +					|| alloc_total != total_blocks) {
>> +					printk(KERN_ERR "ext4 defrag: "
>> +						"Reserved blocks are already "
>> +						"used by other process\n");
>> +					ext4_free_blocks(handle, org_inode,
>> +						newblock, ar.len, metadata);
>> +					err = -EIO;
>> +					goto out;
>> +				}
>> +				break;
>> +			}
>> +
> 
> The phase mode plug into the allocation function is not very nice...might be cleaner to do it outside the allocation.
> 

I will separate the phase mode plug from the allocation function.

>> +
>> +/**
>> + * ext4_defrag_new_extent_tree -  Allocate contiguous blocks
>> + *
> 
> I think a better description of this function would be helpful.
> 

OK. I will add appropriate description of ext4_defrag_new_extent_tree().


>> +/**
>> + * ext4_defrag - Defrag the specified range of a file
>> + *
>> + * @filp:		pointer to file
>> + * @from:		starting offset to defrag in blocks
> 
> This should be @block_start

All right, Thanks.



>> + * @defrag_size:	size of defrag in blocks
>> + * @goal:		block offset for allocation
>> + * @flag:		phase of the force defrag mode
>> + * @ext:		extent to be moved (only -f)
>> + *
>> + * This function returns the number of blocks if succeeded, otherwise
>> + * returns error value.
>> + */
> 
> This is a bit long function, Could you try to split it to small functions to make it easy to review?
> 

I will do that.

>> +	/* ext4 defrag needs mballoc mount option. */
>> +	if (!test_opt(inode->i_sb, MBALLOC)) {
>> +		printk(KERN_ERR "ext4 defrag: multiblock allocation "
>> +				"is disabled\n");
>> +		return -EINVAL;
>> +	}
>> +
> 
> It would be prefered to always use mballoc for defrag, but is it necessary to fail defrag
> if ext4 is not tuned or mounted with mballoc?
> 

Defrag does not support single block allocation
and ext4_mb_new_blocks() uses single block allocation
if mballoc option is not set.
So we need to check mballoc option here to prevent data corruption
with unexpected block allocation.

>> +	/* Check goal offset if goal offset was given from userspace */
> Perhaps this userspace check should be moved the ioctl.c?
> 

I think you are right.
I will move this check to ioctl function.


>> +	if (((0 < goal) && (ext4_blocks_count(es) < goal)) && (goal != -1)) {
>> +		printk(KERN_ERR "ext4 defrag: Invalid goal offset %llu, "
>> +				"you can set goal offset up to %llu\n", goal,
>> +						ext4_blocks_count(es));
>> +		return -EINVAL;
>> +	}
>> +
> 
> And I think the above "if" is true if we have a good "goal" from user, missed a "!" somewhere?
> 

"if" is not "true" when correct goal is passed from user-space.
But I fix this condition as follows because it is hard to read a bit.

	if (!(goal < ext4_blocks_count(es)) && (goal != -1)) {
		printk(KERN_ERR "ext4 defrag: Invalid goal offset %llu, "
				"you can set goal offset up to %llu\n", goal,
						ext4_blocks_count(es));
		return -EINVAL;
	}


>> +	path = ext4_ext_find_extent(inode, block_start, NULL);
>> +	if (IS_ERR(path)) {
>> +		ret = PTR_ERR(path);
>> +		path = NULL;
>> +		goto out;
>> +	}
>> +
>> +	/* Get path structure to check the hole */
>> +	holecheck_path = ext4_ext_find_extent(inode, block_start, NULL);
>> +	if (IS_ERR(holecheck_path)) {
>> +		ret = PTR_ERR(holecheck_path);
>> +		holecheck_path = NULL;
>> +		goto out;
>> +	}
>> +
> 
> Can't we point holecheck_path to path? it appears all point to the same path...
> 

holecheck_path and path are used for the different purpose.
holecheck_path is used to calculate contiguous space of temporary inode
and path is to check whether fragmentation is improved or not.
We should initialize them separately.


> I am lost in this function :-) A bit high level description of how ext4_defrag() is implemented would be helpful.
>  

OK. I will add the description about ext4_defrag().


>>  		return err;
>>  	}
>> +	case EXT4_IOC_FIBMAP:
>> +	case EXT4_IOC_DEFRAG:
>> +	case EXT4_IOC_GROUP_INFO:
>> +	case EXT4_IOC_FREE_BLOCKS_INFO:
>> +	case EXT4_IOC_EXTENTS_INFO:
>> +	case EXT4_IOC_RESERVE_BLOCK:
>> +	case EXT4_IOC_MOVE_VICTIM:
>> +	case EXT4_IOC_BLOCK_RELEASE: {
>> +		return ext4_defrag_ioctl(inode, filp, cmd, arg);
>> +	}
> 
> Better to move these to the last patch where the ioctl commands get implemented.

All right.


>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index ad6bf37..b07f34f 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -528,6 +528,7 @@ struct ext4_allocation_context {
>>  	struct page *ac_buddy_page;
>>  	struct ext4_prealloc_space *ac_pa;
>>  	struct ext4_locality_group *ac_lg;
>> +	long long ac_excepted_group;
>>
> 
> There is a type for block groups, ext4_group_t. 

ac_excepted_group has not only except block group number but also -1
(it means any block group are accepted).
So we should keep long long, otherwise overflow may happen in large ext4.

Regards,
Akira
