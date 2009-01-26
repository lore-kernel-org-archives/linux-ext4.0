From: Sandeep K Sinha <sandeepksinha@gmail.com>
Subject: Re: can't get e4defrag to work
Date: Mon, 26 Jan 2009 17:39:47 +0530
Message-ID: <37d33d830901260409y2cb01512u19646c477fa0e365@mail.gmail.com>
References: <7a45233b0901210704w5038d8b8g5c657e3a4746f34d@mail.gmail.com>
	 <49797056.7030607@rs.jp.nec.com>
	 <87f94c370901230751m107afe09w6df76e258c57eae3@mail.gmail.com>
	 <497D6843.50905@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Derkjan de Haan <haanjdj@gmail.com>,
	Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:30188 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZAZMJt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 07:09:49 -0500
Received: by wa-out-1112.google.com with SMTP id v33so495762wah.21
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2009 04:09:48 -0800 (PST)
In-Reply-To: <497D6843.50905@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2009 at 1:07 PM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> Hi Greg,
>
> Greg Freemyer wrote:
>>
>> Will the new defrag patchset be based on the ioctl's that Ted
>> suggested last month?
>
> Yes, but the new defrag that I will release corresponds to (3) of
> Ted's suggestion.
> (http://marc.info/?l=linux-ext4&m=122880166227883&w=3)
>
> For (1) and (2), probably it will be necessary to change
> the allocation method and add new ioctls, so I will address them later.
>
> Have you already worked on these features?
>

Well,

for option (2), I did try it on ext2/3 and it works fine for me.
Same on ext4 was a bit problematic as a lot of interfaces are changing
to the mballoc from balloc.
And I have read lot of changes pipelined for block allocation in ext4.
So, just waiting to get some information on that so that I can do the
same for ext4 as well.

This is a sample code that I tried and it works fine. It you wish, I
can produce a formal version for the same.
Here are the changes:


#diff a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c

19a20,35
> #define EXT2_BG_ALLOC 7
>
> struct ext2fs_bg_range {
> 	unsigned int bg_start;
> 	unsigned int bg_end;
> };	
>
> struct ext2fs_bg_ioc {
>
> 	struct ext2fs_bg_range bg_range[10];
> 	unsigned long fs_bg_range_count;
> 	unsigned long blk_req_count;
> };
>
> extern ext2_fsblk_t fs_bg_ext2_new_blocks(struct inode *inode, struct ext2fs_bg_range bg[],
> 		    unsigned long fs_bg_range_count, unsigned long *count, int *errp);
25a42
> 	struct ext2fs_bg_ioc bg_ioc;
27,28c44,45
< 	int ret;
>     int ret ,err;
<
> 	case EXT2_BG_ALLOC:
> 		copy_from_user((struct ext2fs_bg_ioc *)&bg_ioc, (const void __user *)arg, sizeof(struct ext2fs_bg_ioc));
> 		ret = fs_bg_ext2_new_blocks(inode, bg_ioc.bg_range, bg_ioc.fs_bg_range_count,
> 				&bg_ioc.blk_req_count, &err);
> 	
> 		break;	
162a198,200
> 	case EXT2_IOC32_BG_ALLOC_BLOCKS:
> 		cmd = EXT2_IOC_BG_ALLOC_BLOCKS;
> 		break;

diff a/fs/ext2/balloc.c b/fs/ext2/balloc.c

16a17
> #include <linux/module.h>
1543a1545,1732
> struct ext2fs_bg_range {
> 	unsigned int bg_start;
> 	unsigned int bg_end;
> };	
>
> ext2_fsblk_t fs_bg_ext2_new_blocks(struct inode *inode, struct ext2fs_bg_range bg_range[],
> 		    unsigned int fs_bg_range_count, unsigned long *count, int *errp)
> {
> 	struct buffer_head *bitmap_bh = NULL;
> 	struct buffer_head *gdp_bh;
> 	int group_no = 0;
> 	int goal_group = 0;
> 	int fs_bg;
> 	int bg_start = 0, bg_end = 0;
> 	ext2_grpblk_t grp_alloc_blk;	/* blockgroup-relative allocated block*/
> 	ext2_fsblk_t ret_block;		/* filesyetem-wide allocated block */
> 	ext2_fsblk_t goal;		/* goal block for allocation */
> 	int bgi;			/* blockgroup iteration index */
> 	int performed_allocation = 0;
> 	ext2_grpblk_t free_blocks;	/* number of free blocks in a group */
> 	struct super_block *sb;
> 	struct ext2_group_desc *gdp;
> 	struct ext2_super_block *es;
> 	struct ext2_sb_info *sbi;
> 	struct ext2_reserve_window_node *my_rsv = NULL;
> 	unsigned short windowsz = 0;
> 	unsigned long ngroups;
> 	unsigned long num = *count;
>
> 	sb = inode->i_sb;
> 	*errp = -ENOSPC;
> 	if (!sb) {
> 		printk("ext2_new_blocks: nonexistent device");
> 		return 0;
> 	}
>
> 	/*
> 	 * Check quota for allocation of this block.
> 	 */
> 	if (DQUOT_ALLOC_BLOCK(inode, num)) {
> 		*errp = -EDQUOT;
> 		return 0;
> 	}
>
> 	sbi = EXT2_SB(sb);
> 	es = EXT2_SB(sb)->s_es;
> 	ext2_debug("goal=%lu.\n", goal);
>
> 	if (!ext2_has_free_blocks(sbi)) {
> 		*errp = -ENOSPC;
> 		goto out;
> 	}
>
> 	goal = ext2_group_first_block_no(sb,EXT2_I(inode)->i_block_group);
> 	
> 	for(fs_bg = 0; fs_bg < fs_bg_range_count; fs_bg++)
>         {
>                 bg_start = bg_range[fs_bg].bg_start;
>                 bg_end = bg_range[fs_bg].bg_end;
>
> 		group_no = bg_start;
> 		goal_group = bg_start;
>
> retry_alloc:
> 	
> 		ngroups = (bg_end - bg_start) + 1;
> 		smp_rmb();
> 	
> 		/*
> 		 * Now search the rest of the groups.  We assume that
> 		 * group_no and gdp correctly point to the last group visited.
> 		 */
> 		
> 		for (bgi = 0; bgi < ngroups; bgi++, group_no++) {
> 			if (group_no > bg_end)  /* ngroups */
> 				group_no = bg_start; /* previous value 0 */
> 			gdp = ext2_get_group_desc(sb, group_no, &gdp_bh);
> 			if (!gdp)
> 				goto io_error;
> 	
> 			free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> 			/*
> 			 * skip this group if the number of
> 			 * free blocks is less than half of the reservation
> 			 * window size.
> 			 */
> 			if (free_blocks <= (windowsz/2))
> 				continue;
>
> 			brelse(bitmap_bh);
> 			bitmap_bh = read_block_bitmap(sb, group_no);
> 			if (!bitmap_bh)
> 				goto io_error;
> 			/*
> 			 * try to allocate block(s) from this group, without a goal(-1).
> 			 */
> 			grp_alloc_blk = ext2_try_to_allocate_with_rsv(sb, group_no,
> 						bitmap_bh, -1, my_rsv, &num);
> 			if (grp_alloc_blk >= 0)
> 				goto allocated;
> 		}
> 	}
> 	/*
> 	 * We may end up a bogus ealier ENOSPC error due to
> 	 * filesystem is "full" of reservations, but
> 	 * there maybe indeed free blocks avaliable on disk
> 	 * In this case, we just forget about the reservations
> 	 * just do block allocation as without reservations.
> 	 */
> 	if (my_rsv) {
> 		my_rsv = NULL;
> 		windowsz = 0;
> 		group_no = goal_group;
> 		goto retry_alloc;
> 	}
> 	/* No space left on the device */
> 	*errp = -ENOSPC;
> 	goto out;
> 	
> allocated:
> 	
> 	ext2_debug("using block group %d(%d)\n",
> 				group_no, gdp->bg_free_blocks_count);
>
> 	ret_block = grp_alloc_blk + ext2_group_first_block_no(sb, group_no);
> 	
> 	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), ret_block, num) ||
> 	    in_range(le32_to_cpu(gdp->bg_inode_bitmap), ret_block, num) ||
> 	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
> 		      EXT2_SB(sb)->s_itb_per_group) ||
> 	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
> 		      EXT2_SB(sb)->s_itb_per_group)) {
> 		ext2_error(sb, "ext2_new_blocks",
> 			    "Allocating block in system zone - "
> 			    "blocks from "E2FSBLK", length %lu",
> 					    ret_block, num);
> 	/*
> 	 * ext2_try_to_allocate marked the blocks we allocated as in
> 	 * use.  So we may want to selectively mark some of the blocks
> 	 * as free
> 	 */
> 		goto retry_alloc;
> 	}
>
> 	performed_allocation = 1;
> 	
> 	if (ret_block + num - 1 >= le32_to_cpu(es->s_blocks_count)) {
> 		ext2_error(sb, "ext2_new_blocks",
> 		    "block("E2FSBLK") >= blocks count(%d) - "
> 		    "block_group = %d, es == %p ", ret_block,
> 		le32_to_cpu(es->s_blocks_count), group_no, es);
> 		goto out;
> 	}
>
> 	group_adjust_blocks(sb, group_no, gdp, gdp_bh, -num);
> 	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
>
> 	mark_buffer_dirty(bitmap_bh);
> 	if (sb->s_flags & MS_SYNCHRONOUS)
> 		sync_dirty_buffer(bitmap_bh);
>
> 	*errp = 0;
> 	brelse(bitmap_bh);
> 	DQUOT_FREE_BLOCK(inode, *count-num);
> 	*count = num;
> 	return ret_block;
> io_error:
> 	*errp = -EIO;
> out:
> 	/*
> 	 * Undo the block allocation
> 	 */
> 	if (!performed_allocation)
> 		DQUOT_FREE_BLOCK(inode, *count);
> 	brelse(bitmap_bh);
> 	return 0;
> }
> EXPORT_SYMBOL(fs_bg_ext2_new_blocks);


This works fine.

I would surely like to see a similar ABI in the linux kernel soon.

> Regards,
> Akira Fujita
>
> --Separator@a-fujita@rs.jp.nec.com:
> greg.freemyer@gmail.com
> haanjdj@gmail.com
> sandeepksinha@gmail.com
> linux-ext4@vger.kernel.org
>



-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."
