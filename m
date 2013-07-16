From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: detect invalid extents at the end of an extent-block
Date: Tue, 16 Jul 2013 10:17:27 -0500
Message-ID: <51E56407.5040505@redhat.com>
References: <20130403190841.GA16276@fury.redhat.com> <51AE61FB.8080402@redhat.com> <20130607033934.GB7555@thunk.org> <87k3kqa8gd.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	David Jeffery <djeffery@redhat.com>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3GPPRc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jul 2013 11:17:32 -0400
In-Reply-To: <87k3kqa8gd.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/16/13 9:24 AM, Dmitry Monakhov wrote:
> On Thu, 6 Jun 2013 23:39:34 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
>> Thanks for the review.  I took your changes, and added a bit more code
>> cleanup.
>>
>> Here's the version I ultimately checked into my tree.
> This patch cause regression
> TESTCASE:
> #!/bin/bash
> 
> IMG=./IMG
> MNT=/mnt
> dd if=/dev/zero of=$IMG bs=1M count=16
> mkfs.ext4 -b4096 -F $IMG
> mount $IMG $MNT -oloop || exit 1
> fallocate -n -l $((1024*1024*2)) $MNT/f1
> 
> for ((i=0;i<4;i++))
> do
>     dd if=/dev/zero of=$MNT/f1 bs=4k count=1 seek=$((i*100)) conv=notrunc
> done
> sync
> filefrag -v $MNT/f1
> umount $MNT
> e2fsck -f -n $IMG

Yes,this is the case where extents past EOF aren't updating the parent
node in the extent tree:

e2fsck 1.43-WIP (20-Jun-2013)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, end of extent exceeds allowed value
	(logical block 301, physical block 1464, len 211)
Clear? no

Inode 12, i_blocks is 4112, should be 2424.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(1464--1674)
Fix? no

The file looks like this:

debugfs:  ex f1
Level Entries       Logical      Physical Length Flags
 0/ 1   1/  1     0 -   300  1675            301
                                             ^^^ length 301
                        ^^ last logical block at 300
 1/ 1   1/  8     0 -     0  1163 -  1163      1 
 1/ 1   2/  8     1 -    99  1164 -  1262     99 Uninit
 1/ 1   3/  8   100 -   100  1263 -  1263      1 
 1/ 1   4/  8   101 -   199  1264 -  1362     99 Uninit
 1/ 1   5/  8   200 -   200  1363 -  1363      1 
 1/ 1   6/  8   201 -   299  1364 -  1462     99 Uninit
 1/ 1   7/  8   300 -   300  1463 -  1463      1 
 1/ 1   8/  8   301 -   511  1464 -  1674    211 Uninit
                ^^ extent past EOF extends beyond parent


Ted thought that was OK, I guess, but that seems very strange to me.
Why would we NOT update the length/range of the parent block?

Where EOF/i_size happens to land should be orthogonal to how
the extent tree is described, I would expect.

I asked in:

Subject: fallocated blocks past EOF & past parent node range OK?

but there's been no discussion so far.  I'd like to understand
why it's felt that the tree above is not considered to be corrupt.

Thanks,
-Eric

>>
>> 						- Ted
>>
>> commit d3f32c2db8f11c87aa7939d78e7eb4c373f7034f
>> Author: David Jeffery <djeffery@redhat.com>
>> Date:   Thu Jun 6 20:04:33 2013 -0400
>>
>>     e2fsck: detect invalid extents at the end of an extent-block
>>     
>>     e2fsck does not detect extents which are outside their location in the
>>     extent tree.  This can result in a bad extent at the end of an extent-block
>>     not being detected.
>>     
>>     From a part of a dump_extents output:
>>     
>>      1/ 2  37/ 68 143960 - 146679 123826181               2720
>>      2/ 2   1/  2 143960 - 146679 123785816 - 123788535   2720
>>      2/ 2   2/  2 146680 - 147583 123788536 - 123789439    904 Uninit <-bad extent
>>      1/ 2  38/ 68 146680 - 149391 123826182               2712
>>      2/ 2   1/  2 146680 - 147583     18486 -     19389    904
>>      2/ 2   2/  2 147584 - 149391 123789440 - 123791247   1808
>>     
>>     e2fsck does not detect this bad extent which both overlaps another, valid
>>     extent, and is invalid by being beyond the end of the extent above it in
>>     the tree.
>>     
>>     This patch modifies e2fsck to detect this invalid extent and remove it.
>>     
>>     Signed-off-by: David Jeffery <djeffery@redhat.com>
>>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>>     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
>> index de00638..af9afe3 100644
>> --- a/e2fsck/pass1.c
>> +++ b/e2fsck/pass1.c
>> @@ -1760,11 +1760,11 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
>>  
>>  static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>>  			     struct process_block_struct *pb,
>> -			     blk64_t start_block,
>> +			     blk64_t start_block, blk64_t end_block,
>>  			     ext2_extent_handle_t ehandle)
>>  {
>>  	struct ext2fs_extent	extent;
>> -	blk64_t			blk;
>> +	blk64_t			blk, last_lblk;
>>  	e2_blkcnt_t		blockcnt;
>>  	unsigned int		i;
>>  	int			is_dir, is_leaf;
>> @@ -1780,6 +1780,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>>  	while (!pctx->errcode && info.num_entries-- > 0) {
>>  		is_leaf = extent.e_flags & EXT2_EXTENT_FLAGS_LEAF;
>>  		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
>> +		last_lblk = extent.e_lblk + extent.e_len - 1;
>>  
>>  		problem = 0;
>>  		if (extent.e_pblk == 0 ||
>> @@ -1788,6 +1789,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>>  			problem = PR_1_EXTENT_BAD_START_BLK;
>>  		else if (extent.e_lblk < start_block)
>>  			problem = PR_1_OUT_OF_ORDER_EXTENTS;
>> +		else if (end_block && last_lblk > end_block)
>> +			problem = PR_1_EXTENT_END_OUT_OF_BOUNDS;
>>  		else if (is_leaf && extent.e_len == 0)
>>  			problem = PR_1_EXTENT_LENGTH_ZERO;
>>  		else if (is_leaf &&
>> @@ -1822,10 +1825,9 @@ report_problem:
>>  		}
>>  
>>  		if (!is_leaf) {
>> -			blk64_t lblk;
>> +			blk64_t lblk = extent.e_lblk;
>>  
>>  			blk = extent.e_pblk;
>> -			lblk = extent.e_lblk;
>>  			pctx->errcode = ext2fs_extent_get(ehandle,
>>  						  EXT2_EXTENT_DOWN, &extent);
>>  			if (pctx->errcode) {
>> @@ -1847,7 +1849,8 @@ report_problem:
>>  				if (fix_problem(ctx, problem, pctx))
>>  					ext2fs_extent_fix_parents(ehandle);
>>  			}
>> -			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
>> +			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
>> +					 last_lblk, ehandle);
>>  			if (pctx->errcode)
>>  				return;
>>  			pctx->errcode = ext2fs_extent_get(ehandle,
>> @@ -1928,10 +1931,10 @@ report_problem:
>>  		if (is_dir && extent.e_len > 0)
>>  			pb->last_db_block = blockcnt - 1;
>>  		pb->previous_block = extent.e_pblk + extent.e_len - 1;
>> -		start_block = pb->last_block = extent.e_lblk + extent.e_len - 1;
>> +		start_block = pb->last_block = last_lblk;
>>  		if (is_leaf && !is_dir &&
>>  		    !(extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT))
>> -			pb->last_init_lblock = extent.e_lblk + extent.e_len - 1;
>> +			pb->last_init_lblock = last_lblk;
>>  	next:
>>  		pctx->errcode = ext2fs_extent_get(ehandle,
>>  						  EXT2_EXTENT_NEXT_SIB,
>> @@ -1967,7 +1970,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
>>  		ctx->extent_depth_count[info.max_depth]++;
>>  	}
>>  
>> -	scan_extent_node(ctx, pctx, pb, 0, ehandle);
>> +	scan_extent_node(ctx, pctx, pb, 0, 0, ehandle);
>>  	if (pctx->errcode &&
>>  	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
>>  		pb->num_blocks = 0;
>> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
>> index 05ef626..6d03765 100644
>> --- a/e2fsck/problem.c
>> +++ b/e2fsck/problem.c
>> @@ -954,6 +954,12 @@ static struct e2fsck_problem problem_table[] = {
>>  	     "Logical start %b does not match logical start %c at next level.  "),
>>  	  PROMPT_FIX, 0 },
>>  
>> +	/* Extent end is out of bounds for the tree */
>> +	{ PR_1_EXTENT_END_OUT_OF_BOUNDS,
>> +	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
>> +	  PROMPT_CLEAR, 0 },
>> +
>> +
>>  	/* Pass 1b errors */
>>  
>>  	/* Pass 1B: Rescan for duplicate/bad blocks */
>> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
>> index aed524d..b578678 100644
>> --- a/e2fsck/problem.h
>> +++ b/e2fsck/problem.h
>> @@ -561,6 +561,7 @@ struct problem_context {
>>  /* Index start doesn't match start of next extent down */
>>  #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
>>  
>> +#define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
>>  /*
>>   * Pass 1b errors
>>   */
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

