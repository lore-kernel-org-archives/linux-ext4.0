From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: [PATCH] e2fsck: improve performance of region_allocate()
Date: Tue, 22 Aug 2017 11:36:54 +0200
Message-ID: <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
References: <20170819011635.1815929-1-dsp@fb.com>
 <20170822022948.nyn6fessudjaj5xh@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F8F185720D6A83D643E467C8"
Cc: linux-ext4@vger.kernel.org, Omar Sandoval <osandov@fb.com>
To: Theodore Ts'o <tytso@mit.edu>, Doug Porter <dsp@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from othala.uls.co.za ([154.73.34.12]:57307 "EHLO othala.uls.co.za"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932306AbdHVJwq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Aug 2017 05:52:46 -0400
In-Reply-To: <20170822022948.nyn6fessudjaj5xh@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------F8F185720D6A83D643E467C8
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ted, Doug,

Ted, I already emailed you the patch for the latter discussion here, 
including my rudimentary benchmarks.

Unfortunately I'm having trouble with inline formatting of the patch, so 
I have attached it instead of providing inline (sorry - I know that 
makes discussion difficult).  Was originally emailed to you as a series 
of three independent patches, with the below as 0001.  We still need to 
discuss the other optimization.

The attached improves CPU performance from O(e*h) to O(e) and memory 
from O(h) to O(1).  The patch below does similar for CPU but nothing for 
memory (In my case it took fsck down by a significant margin).

Previously my fsck got stuck on 0.5% (we both know it got stuck on a 
single 340GB file with numerous holes in it, of which I have multiple 
such files on my filesystem) and stayed there for a few hours.  With 
this (and the memory map link-count for pass2) I managed to finish a 
fsck on a 40TB filesystem in 508 minutes.

Ted - the provided patch by Doug may still improve performance for the 
other uses of region.c as well, but the impact will probably not be as 
severe since (as far as I know) there are usually not a great many 
number of EAs for each file.

Kind Regards,
Jaco


On 22/08/2017 04:29, Theodore Ts'o wrote:
> On Fri, Aug 18, 2017 at 06:16:35PM -0700, Doug Porter wrote:
>> Use a red-black tree to track allocations instead of a linked list.
>> This provides a substantial performance boost when the number of
>> allocations in a region is large.  This change resulted in a reduction
>> in runtime from 4821s to 6s on one filesystem.
>>
>> Signed-off-by: Doug Porter <dsp@fb.com>
> Hi Doug, as it turns out, Jaco Kroon and I had been debugging the same
> problem as oen you were working on.  We came up with a different way
> of solving this problem (see below).  It works by observing that
> unless the extent tree is terribly corrupted, region_allocate() will
> always be appending to the very end of the list.
>
> However, it has since occurred to me that since we are doing an
> breadth-first traversal of the extent tree, the starting lba for each
> leaf node *must* always be monotonically increasing, and we already
> check to make sure this is true within an extent tree block.  So I
> think it might be possible to dispense with using any kind of data
> structure, whether it's an rbtree or a linked list, and instead just
> simply make sure we enforce the start+len of the last entry in an
> extent tree block is < the starting lba of the first entry in the next
> extent tree block.
>
> We are already checking all of the necessary other conditions in
> scan_extent_node, so with this additional check, I believe that using
> the region tracking code in scan_extent_node (which was originally
> written to make sure that extended attribute block did not have any
> parts of a string shared between more than one EA key or value pair)
> can be made entirely unnecessary for scan_extent_node().
>
> I haven't had a chance to code this alternate fix, but I believe it
> should be superior to either your patch or the one which I had drafted
> below.  Does this make sense to you?
>
> 							- Ted
>
> commit 8a48ce07a5923242fecc5dc04d6e30dd59a8f07d
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Aug 14 19:52:39 2017 -0400
>
>      e2fsck: add optimization for large, fragmented sparse files
>      
>      The code which checks for overlapping logical blocks in an extent tree
>      is O(h*e) in time, where h is the number of holes in the file, and e
>      is the number of extents in the file.  So a file with a large number
>      of holes can take e2fsck a long time process.  Optimize this taking
>      advantage of the fact the vast majority of the time, region_allocate()
>      is called with increasing logical block numbers, so we are almost
>      always append onto the end of the region list.
>      
>      Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> diff --git a/e2fsck/region.c b/e2fsck/region.c
> index e32f89db0..95d23be4f 100644
> --- a/e2fsck/region.c
> +++ b/e2fsck/region.c
> @@ -30,6 +30,7 @@ struct region_struct {
>   	region_addr_t	min;
>   	region_addr_t	max;
>   	struct region_el *allocated;
> +	struct region_el *last;
>   };
>   
>   region_t region_create(region_addr_t min, region_addr_t max)
> @@ -42,6 +43,7 @@ region_t region_create(region_addr_t min, region_addr_t max)
>   	memset(region, 0, sizeof(struct region_struct));
>   	region->min = min;
>   	region->max = max;
> +	region->last = NULL;
>   	return region;
>   }
>   
> @@ -68,6 +70,18 @@ int region_allocate(region_t region, region_addr_t start, int n)
>   	if (n == 0)
>   		return 1;
>   
> +	if (region->last && region->last->end == start &&
> +	    !region->last->next) {
> +		region->last->end = end;
> +		return 0;
> +	}
> +	if (region->last && start > region->last->end &&
> +	    !region->last->next) {
> +		r = NULL;
> +		prev = region->last;
> +		goto append_to_list;
> +	}
> +
>   	/*
>   	 * Search through the linked list.  If we find that it
>   	 * conflicts witih something that's already allocated, return
> @@ -92,6 +106,8 @@ int region_allocate(region_t region, region_addr_t start, int n)
>   					r->end = next->end;
>   					r->next = next->next;
>   					free(next);
> +					if (!r->next)
> +						region->last = r;
>   					return 0;
>   				}
>   			}
> @@ -104,12 +120,15 @@ int region_allocate(region_t region, region_addr_t start, int n)
>   	/*
>   	 * Insert a new region element structure into the linked list
>   	 */
> +append_to_list:
>   	new_region = malloc(sizeof(struct region_el));
>   	if (!new_region)
>   		return -1;
>   	new_region->start = start;
>   	new_region->end = start + n;
>   	new_region->next = r;
> +	if (!new_region->next)
> +		region->last = new_region;
>   	if (prev)
>   		prev->next = new_region;
>   	else


--------------F8F185720D6A83D643E467C8
Content-Type: text/x-patch;
 name="0003-e2fsk-Optimize-out-the-use-of-region.c-for-logical-b.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-e2fsk-Optimize-out-the-use-of-region.c-for-logical-b.pa";
 filename*1="tch"

>From 1cb50ef22658798f3934b15f7f4be06a7ef4d5ff Mon Sep 17 00:00:00 2001
From: Jaco Kroon <jaco@uls.co.za>
Date: Fri, 18 Aug 2017 15:37:51 +0200
Subject: [PATCH 3/3] e2fsk:  Optimize out the use of region.c for logical
 block overlap detection.

Since extents have a guarantee of being monotonically increasing we
merely need to check that block n+1 starts after block n.  This is a
simple enough check and we can perform this by calculating the next
expected block
---
 e2fsck/pass1.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 97dd79c4..b78c4416 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -103,7 +103,7 @@ struct process_block_struct {
 	struct problem_context *pctx;
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
-	region_t	region;
+	blk64_t		next_logical_block;
 	struct extent_tree_info	eti;
 };
 
@@ -2819,9 +2819,16 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			  (1U << (21 - ctx->fs->super->s_log_block_size))))
 			problem = PR_1_TOOBIG_DIR;
 
-		if (is_leaf && problem == 0 && extent.e_len > 0 &&
-		    region_allocate(pb->region, extent.e_lblk, extent.e_len))
-			problem = PR_1_EXTENT_COLLISION;
+		if (is_leaf && problem == 0 && extent.e_len > 0) {
+#if 0
+			printf("extent_region(ino=%u, expect=%llu, lblk=%llu, len=%u)\n",
+					pb->ino, pb->next_logical_block, extent.e_lblk, extent.e_len);
+#endif
+			if (extent.e_lblk < pb->next_logical_block)
+				problem = PR_1_EXTENT_COLLISION;
+			else if (extent.e_lblk + extent.e_len > pb->next_logical_block)
+				pb->next_logical_block = extent.e_lblk + extent.e_len;
+		}
 
 		/*
 		 * Uninitialized blocks in a directory?  Clear the flag and
@@ -3170,13 +3177,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	memset(pb->eti.ext_info, 0, sizeof(pb->eti.ext_info));
 	pb->eti.ino = pb->ino;
 
-	pb->region = region_create(0, info.max_lblk);
-	if (!pb->region) {
-		ext2fs_extent_free(ehandle);
-		fix_problem(ctx, PR_1_EXTENT_ALLOC_REGION_ABORT, pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
+	pb->next_logical_block = 0;
 
 	eof_lblk = ((EXT2_I_SIZE(inode) + fs->blocksize - 1) >>
 		EXT2_BLOCK_SIZE_BITS(fs->super)) - 1;
@@ -3189,8 +3190,6 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 				   "check_blocks_extents");
 		pctx->errcode = 0;
 	}
-	region_free(pb->region);
-	pb->region = NULL;
 	ext2fs_extent_free(ehandle);
 
 	/* Rebuild unless it's a dir and we're rehashing it */
-- 
2.13.3


--------------F8F185720D6A83D643E467C8--
