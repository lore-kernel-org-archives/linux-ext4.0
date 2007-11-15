From: "Abhishek Rai" <abhishekrai@google.com>
Subject: Re: ext3 metaclustering performance numbers and updated patch
Date: Thu, 15 Nov 2007 11:55:36 -0800
Message-ID: <d9885f0f0711151155jd27e6b7oa6696d7eb63e19f0@mail.gmail.com>
References: <d9885f0f0711091733i374d33efq8704d01fbb67036@mail.gmail.com>
	 <20071110075254.GL3966@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Abhishek Rai" <abhishekrai@google.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:20065 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbXKOTzn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 14:55:43 -0500
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id lAFJtcEs009357
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 19:55:39 GMT
Received: from wr-out-0506.google.com (wrac8.prod.google.com [10.54.54.8])
	by zps38.corp.google.com with ESMTP id lAFJsc7q015850
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 11:55:37 -0800
Received: by wr-out-0506.google.com with SMTP id c8so570010wra
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 11:55:37 -0800 (PST)
In-Reply-To: <20071110075254.GL3966@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas,

Thanks for the great review. I've hopefully addressed all your concerns.
Please find my responses inline followed by an updated patch.

On Nov 9, 2007 11:52 PM, Andreas Dilger <adilger@sun.com> wrote:
> On Nov 09, 2007  17:33 -0800, Abhishek Rai wrote:
> > Benchmark 5: fsck
> > Description: Prepare a newly formated 400GB disk as follows: create
> > 200 files of 0.5GB each, 100 files of 1GB each, 40 files of 2.5GB ech,
> > and 10 files of 10GB each. fsck command line: fsck -f -n
> > 1. vanilla:
> >    Total: 12m18.1s
> >    User: 15.9s
> >    System: 18.3s
> > 2. mc:
> >    Total: 4m47.0s
> >    User: 16.0s
> >    System: 17.1s
>
> The fsck improvement is quite impressive.
>
> Do you have any benchmarks with small files 64kB-1MB in size
> (e.g. kernbench or mongo)?  I'm wondering if there are any drawbacks
> from the metaclustering block reservation of blocks if the files are
> relatively small because of the extra seeking involved.

Here are the results for kernbench from a 8 cpu machine with 32GB RAM.

Benchmark: kernbench
Description: 6 runs, very low standard deviation
1. vanilla:
   Elapsed: 35.60
   User: 228.79
   System: 21.10
2. mc:
   Elapsed: 35.12
   User: 228.47
   System: 21.08

>
> Also, it took me a while to determine whether the metacluster is
> done on a per-group basis instead of per-file or per-filesystem.
> It is counter-intuitive because the ext3_get_metacluster_range()
> function only takes the superblock as a parameter and not e.g. the
> group or inode number.

Good point, renamed the function to ext3_get_grp_metacluster(). But
refrained from adding a group parameter as that might suggest we vary
metaclusters from group to group.

>
> > In comparison, approaches that optimize inode table reads or bitmap
> > block reads deliver little performance gains on such disks with lots
> > of data as they target only a small fraction of the total e2fsck
> > latency. However, such approaches (e.g., uninit_groups), deliver
> > substantial improvement for disks with little data, but e2fsck on such
> > disks doesn't take "too long" anyway and hence may not be considered a
> > serious issue in the first place.
>
> Did you do a comparison of the metacluster code with extents?  That
> should also improve the e2fsck time in a similar manner by virtue of
> not needing as many (or any) indirect blocks.  In ideal allocation
> cases a single extent can represent a whole block group of blocks,
> and files up to 480MB might not even need any index blocks.
>
> I understand you aren't very keen on changing the on-disk format, but
> it would be interesting to compare the relative benefits of the two
> on identical hardware.

That's a valid point. I'm definitely going to do a performance
comparison of metaclusters with extents and report my findings.

>
> I also suspect that using ext3_new_indirect_block() for extent
> index blocks on large files would have a similar positive impact for
> ext4 extents in the case where they are needed).

I think this would be worth investigating though I don't expect to see
long e2fsck times with extents in the first place. One difference with
extents would be that
prefetching might not be as relevant for extent index blocks as it is
for indirect blocks given the much larger data coverage achieved by
the former. However, prefetching is just an optimization, its
not the main point of this change. I'll investigate this in conjunction
with metaclustering vs extent comparison.

> While your patch is fairly complex, I personally don't have a big objection
> to it going into the kernel, but there was a lot of vocal opposition to
> ext3 changes in the past so you may have an uphill battle with other
> kernel developers.
>
> > @@ -1713,6 +1783,161 @@ ext3_fsblk_t ext3_new_block(handle_t *ha
> > +int ext3_new_indirect_blocks(handle_t *handle, struct inode *inode,
> > +                     unsigned long group_no, unsigned long *count,
> > +                     ext3_fsblk_t new_blocks[])
> > +{
> > +     if (err && err != -ENOSPC)
> > +             printk("ext3_new_indirect_blocks: error %d", err);
>
> Should this be an ext3_error() instead of a printk() or do all of the
> functions that generate errors already call ext3_error()?  If there is
> a good reason NOT to make it an ext3_error() you are missing a KERN_*
> error level.

Done

>
> > +typedef struct {
> > +     __le32  *p;
> > +     __le32  key;
> > +     struct buffer_head *bh;
> > +} Indirect;
>
> Typedefs are frowned upon in Linux kernel code.
>
> > @@ -233,12 +255,6 @@ no_delete:
> > -typedef struct {
> > -     __le32  *p;
> > -     __le32  key;
> > -     struct buffer_head *bh;
> > -} Indirect;
>
> Though, hmm, it seems you didn't invent this yourself...
>
> > -static ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)
> > +static inline ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)
>
> Function is much too large to inline, even if it has just a single callsite.

In the worst case it will not be inlined, so that shouldn't be a
problem. Still, I removed the inline just in case someone adds an
additional callsite in the future and forgets to remove it then.

>
> > +/*
> > + * ext3_read_indblocks_async --
> > + *      Synchronously read at most count indirect blocks listed in
> > + *      ind_blocks[]. This function calls ext3_read_indblocks_async() to do all
> > + *      the hard work. It waits for read to complete on first_bh before
> > + *      returning.
> > +static int ext3_read_indblocks_sync(struct super_block *sb,
>
> Comment function name does not match actual function name.

Fixed

>
> > + * ext3_get_metacluster_range:
> > + *
> > + *   Determines metacluster block range for all block groups of the file
> > + *   system. Number of metacluster blocks:
> > + *   = 2 * (blocks_per_group / block_pointers_per_metablock)
> > + *   = 2 * (blocks_per_group / (block_size / 4))
> > + *   = (8 * blocks_per_group) / block_size
>
> This works out to 64 blocks for a default-formatted 4kB filesystem.
> Do you have any stats from your previous testing on what the average
> number of indirect blocks/group is?  For large files (> 8MB or so)
> I suspect the above will be sufficient, but for small files (< 2MB)
> this wouldn't be enough as the indirect blocks will not be filled.
> I guess it isn't harmful in the case where these reserved blocks run
> out...

This is a very good point. Current, metacluster size is 0.2%. There are
two factors to consider before increasing metacluster size though:

1. When ext3 runs out of data blocks, it starts using metacluster blocks
for data block allocation. If metaclusters are too big, this will happen
too soon resulting in no or little clustering of indirect blocks.

2. Also, in the above case ext3_new_blocks() will make two passes over
all groups, first pass without allocating from metaclusters and second
pass doing allocation from metaclusters. This of course will hurt
performance since first pass is totally unnecessary in this case.
Unlike gdp->bg_free_blocks_count, there is no field that tells it to
skip a group if all data blocks are taken even though there are
metacluster blocks available. If the metacluster is too big, this
will happen too early. I'd love to have suggestions on how this problem
can be fixed or whether we can live with it by keeping metaclusters
reasonably small.

Considering these factors I'd be wary of increasing metacluster size to
anything more than 0.8% (256 blocks per block group in default
configuration) which means we'll see all the above special effects only
when we cross 99.2% space utilization in the file system. In the patch
below I've changed it so, but please let me know what you think.

> > +ext3_get_metacluster_range(struct super_block *sb,
> > +                             ext3_grpblk_t *mc_start,
> > +                             ext3_grpblk_t *mc_end)  /* exclusive */
> > +{
> > +     *mc_start = EXT3_BLOCKS_PER_GROUP(sb) / 2;
>
> Have you tested with mc_start right after the inode table?  For e2fsck
> that might be slightly better positioning as it could potentially be
> read into cache without a seek, and it avoids breaking up the group in
> the middle if you are creating large files.

That's a very good point. I evaluated three different configurations:
metacluster in the beginning, middle, and end of the block group.
Putting metacluster in the beginning does give partially better
performance on sequential IO. Turns out that for sequential reads, the
beginning configuration was 0.5% better than the middle, and the end
configuration was 2% worse. But for random reads, middle was the best,
being 1% better than beginning and end. Most importantly, middle
configuration was the closest to vanilla always, so I stuck with it.

>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Software Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>

Below is an updated version of the patch with the above comments
applied.

Thanks,
Abhishek

Signed-off-by: Abhishek Rai <abhishekrai@google.com>


diff -uprdN linux-2.6.23mm1-clean/fs/ext3/balloc.c
linux-2.6.23mm1-ext3mc/fs/ext3/balloc.c
--- linux-2.6.23mm1-clean/fs/ext3/balloc.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/balloc.c	2007-11-15 11:23:51.000000000 -0800
@@ -711,6 +711,7 @@ bitmap_search_next_usable_block(ext3_grp
 	ext3_grpblk_t next;
 	struct journal_head *jh = bh2jh(bh);

+	BUG_ON(start > maxblocks);
 	while (start < maxblocks) {
 		next = ext3_find_next_zero_bit(bh->b_data, maxblocks, start);
 		if (next >= maxblocks)
@@ -841,10 +842,12 @@ claim_block(spinlock_t *lock, ext3_grpbl
 static ext3_grpblk_t
 ext3_try_to_allocate(struct super_block *sb, handle_t *handle, int group,
 			struct buffer_head *bitmap_bh, ext3_grpblk_t grp_goal,
-			unsigned long *count, struct ext3_reserve_window *my_rsv)
+			int use_metacluster, unsigned long *count,
+			struct ext3_reserve_window *my_rsv)
 {
 	ext3_fsblk_t group_first_block;
 	ext3_grpblk_t start, end;
+	ext3_grpblk_t mc_start, mc_end, start2 = -1, end2 = -1;
 	unsigned long num = 0;

 	/* we do allocation within the reservation window if we have a window */
@@ -872,12 +875,48 @@ ext3_try_to_allocate(struct super_block
 	}

 	BUG_ON(start > EXT3_BLOCKS_PER_GROUP(sb));
+	/* start must have been set to grp_goal if one still exists. */
+	BUG_ON(grp_goal >= 0 && start != grp_goal);
+
+	if (test_opt(sb, METACLUSTER) && !use_metacluster) {
+		ext3_get_grp_metacluster(sb, &mc_start, &mc_end);
+
+		/*
+	 	 * If there is an overlap with metacluster range, adjust our
+		 * range to remove overlap, splitting our range into two if
+		 * needed.
+	 	 */
+		if (mc_end > mc_start) {
+			if (mc_start <= start)
+				start = max_t(ext3_grpblk_t, start, mc_end);
+			else if (mc_end >= end)
+				end = min_t(ext3_grpblk_t, end, mc_start);
+			else {
+				start2 = mc_end;
+				end2 = end;
+				end = mc_start;
+			}
+		}
+	}
+
+	if (start >= end)
+		goto fail_access;
+
+	if (grp_goal > 0)
+		grp_goal = start;

 repeat:
 	if (grp_goal < 0 || !ext3_test_allocatable(grp_goal, bitmap_bh)) {
 		grp_goal = find_next_usable_block(start, bitmap_bh, end);
-		if (grp_goal < 0)
+		if (grp_goal < 0) {
+			if (start2 >= 0) {
+				start = start2;
+				end = end2;
+				start2 = -1;
+				goto repeat;
+			}
 			goto fail_access;
+		}
 		if (!my_rsv) {
 			int i;

@@ -898,8 +937,15 @@ repeat:
 		 */
 		start++;
 		grp_goal++;
-		if (start >= end)
-			goto fail_access;
+		if (start >= end) {
+			if (start2 < 0)
+				goto fail_access;
+
+			start = start2;
+			end = end2;
+			start2 = -1;
+			grp_goal = -1;
+		}
 		goto repeat;
 	}
 	num++;
@@ -1084,6 +1130,7 @@ static int alloc_new_reservation(struct
 	unsigned long size;
 	int ret;
 	spinlock_t *rsv_lock = &EXT3_SB(sb)->s_rsv_window_lock;
+	ext3_grpblk_t mc_start, mc_end;

 	group_first_block = ext3_group_first_block_no(sb, group);
 	group_end_block = group_first_block + (EXT3_BLOCKS_PER_GROUP(sb) - 1);
@@ -1143,6 +1190,7 @@ static int alloc_new_reservation(struct
 	 * To make sure the reservation window has a free bit inside it, we
 	 * need to check the bitmap after we found a reservable window.
 	 */
+	ext3_get_grp_metacluster(sb, &mc_start, &mc_end);
 retry:
 	ret = find_next_reservable_window(search_head, my_rsv, sb,
 						start_block, group_end_block);
@@ -1170,6 +1218,11 @@ retry:
 			my_rsv->rsv_start - group_first_block,
 			bitmap_bh, group_end_block - group_first_block + 1);

+	if (first_free_block >= mc_start && first_free_block < mc_end) {
+		start_block = mc_end;
+		goto next;
+	}
+
 	if (first_free_block < 0) {
 		/*
 		 * no free block left on the bitmap, no point
@@ -1195,6 +1248,7 @@ retry:
 	 * start from where the free block is,
 	 * we also shift the list head to where we stopped last time
 	 */
+next:
 	search_head = my_rsv;
 	spin_lock(rsv_lock);
 	goto retry;
@@ -1223,12 +1277,18 @@ static void try_to_extend_reservation(st
 	struct ext3_reserve_window_node *next_rsv;
 	struct rb_node *next;
 	spinlock_t *rsv_lock = &EXT3_SB(sb)->s_rsv_window_lock;
+	ext3_grpblk_t mc_start, mc_end;

 	if (!spin_trylock(rsv_lock))
 		return;

 	next = rb_next(&my_rsv->rsv_node);

+	ext3_get_grp_metacluster(sb, &mc_start, &mc_end);
+
+	if (my_rsv->rsv_end >= mc_start && my_rsv->rsv_end < mc_end)
+		size += mc_end - 1 - my_rsv->rsv_end;
+
 	if (!next)
 		my_rsv->rsv_end += size;
 	else {
@@ -1274,7 +1334,7 @@ static void try_to_extend_reservation(st
 static ext3_grpblk_t
 ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 			unsigned int group, struct buffer_head *bitmap_bh,
-			ext3_grpblk_t grp_goal,
+			ext3_grpblk_t grp_goal, int use_metacluster,
 			struct ext3_reserve_window_node * my_rsv,
 			unsigned long *count, int *errp)
 {
@@ -1305,7 +1365,8 @@ ext3_try_to_allocate_with_rsv(struct sup
 	 */
 	if (my_rsv == NULL ) {
 		ret = ext3_try_to_allocate(sb, handle, group, bitmap_bh,
-						grp_goal, count, NULL);
+						grp_goal, use_metacluster,
+						count, NULL);
 		goto out;
 	}
 	/*
@@ -1361,7 +1422,8 @@ ext3_try_to_allocate_with_rsv(struct sup
 			BUG();
 		}
 		ret = ext3_try_to_allocate(sb, handle, group, bitmap_bh,
-					   grp_goal, &num, &my_rsv->rsv_window);
+						grp_goal, use_metacluster,
+						&num, &my_rsv->rsv_window);
 		if (ret >= 0) {
 			my_rsv->rsv_alloc_hit += num;
 			*count = num;
@@ -1455,6 +1517,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	int bgi;			/* blockgroup iteration index */
 	int fatal = 0, err;
 	int performed_allocation = 0;
+	int use_metacluster = 0;
 	ext3_grpblk_t free_blocks;	/* number of free blocks in a group */
 	struct super_block *sb;
 	struct ext3_group_desc *gdp;
@@ -1473,6 +1536,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	sb = inode->i_sb;
 	if (!sb) {
 		printk("ext3_new_block: nonexistent device");
+		*errp = -ENODEV;
 		return 0;
 	}

@@ -1487,6 +1551,11 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	sbi = EXT3_SB(sb);
 	es = EXT3_SB(sb)->s_es;
 	ext3_debug("goal=%lu.\n", goal);
+
+	/* Caller should ensure this. */
+	BUG_ON(goal < le32_to_cpu(es->s_first_data_block) ||
+	       goal >= le32_to_cpu(es->s_blocks_count));
+
 	/*
 	 * Allocate a block from reservation only when
 	 * filesystem is mounted with reservation(default,-o reservation), and
@@ -1507,9 +1576,6 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	/*
 	 * First, test whether the goal block is free.
 	 */
-	if (goal < le32_to_cpu(es->s_first_data_block) ||
-	    goal >= le32_to_cpu(es->s_blocks_count))
-		goal = le32_to_cpu(es->s_first_data_block);
 	group_no = (goal - le32_to_cpu(es->s_first_data_block)) /
 			EXT3_BLOCKS_PER_GROUP(sb);
 	goal_group = group_no;
@@ -1535,7 +1601,7 @@ retry_alloc:
 			goto io_error;
 		grp_alloc_blk = ext3_try_to_allocate_with_rsv(sb, handle,
 					group_no, bitmap_bh, grp_target_blk,
-					my_rsv,	&num, &fatal);
+					use_metacluster, my_rsv, &num, &fatal);
 		if (fatal)
 			goto out;
 		if (grp_alloc_blk >= 0)
@@ -1573,8 +1639,8 @@ retry_alloc:
 		 * try to allocate block(s) from this group, without a goal(-1).
 		 */
 		grp_alloc_blk = ext3_try_to_allocate_with_rsv(sb, handle,
-					group_no, bitmap_bh, -1, my_rsv,
-					&num, &fatal);
+					group_no, bitmap_bh, -1,
+					use_metacluster, my_rsv, &num, &fatal);
 		if (fatal)
 			goto out;
 		if (grp_alloc_blk >= 0)
@@ -1593,6 +1659,10 @@ retry_alloc:
 		group_no = goal_group;
 		goto retry_alloc;
 	}
+	if (test_opt(sb, METACLUSTER) && use_metacluster == 0) {
+		use_metacluster = 1;
+		goto retry_alloc;
+	}
 	/* No space left on the device */
 	*errp = -ENOSPC;
 	goto out;
@@ -1713,6 +1783,161 @@ ext3_fsblk_t ext3_new_block(handle_t *ha
 	return ext3_new_blocks(handle, inode, goal, &count, errp);
 }

+/*
+ * ext3_new_indirect_blocks() -- allocate indirect blocks for inode.
+ * @inode:		file inode
+ * @count:		target number of indirect blocks to allocate
+ * @new_blocks[]:       used for returning block numbers allocated
+ *
+ * return: 0 on success, appropriate error code otherwise. Upon return, *count
+ * contains the number of blocks successfully allocated which is non-zero only
+ * in the success case.
+ *
+ * Allocate maximum of *count indirect blocks from the indirect block metadata
+ * area of inode's group and store the block numbers in new_blocksp[]. Since
+ * the allocation is in a predetermined region of the block group, caller just
+ * needs to pass a group number here which is where the goal and/or the
+ * reservation window may fall.
+ */
+int ext3_new_indirect_blocks(handle_t *handle, struct inode *inode,
+			unsigned long group_no, unsigned long *count,
+			ext3_fsblk_t new_blocks[])
+{
+	struct super_block *sb;
+	struct ext3_sb_info *sbi;
+	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *gdp_bh;
+	struct ext3_group_desc *gdp;
+	ext3_grpblk_t group_first_block;      /* first block in the group */
+	ext3_grpblk_t free_blocks;	/* number of free blocks in the group */
+	ext3_grpblk_t mc_start, mc_end;
+	int blk, done = 0;
+	int err = 0;
+
+	BUG_ON(*count > 3);
+
+	sb = inode->i_sb;
+	if (!sb) {
+		printk(KERN_INFO "ext3_new_indirect_blocks: "
+			"nonexistent device");
+		return -ENODEV;
+	}
+	BUG_ON(!test_opt(sb, METACLUSTER));
+	sbi = EXT3_SB(sb);
+
+	if (DQUOT_ALLOC_BLOCK(inode, *count))
+		return -EDQUOT;
+
+	if (!ext3_has_free_blocks(sbi)) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
+	if (!gdp) {
+		err = -EIO;
+		goto out;
+	}
+
+	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+	if (free_blocks == 0) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	bitmap_bh = read_block_bitmap(sb, group_no);
+	if (!bitmap_bh) {
+		err = -EIO;
+		goto out;
+	}
+
+	/*
+	 * Make sure we use undo access for the bitmap, because it is critical
+	 * that we do the frozen_data COW on bitmap buffers in all cases even
+	 * if the buffer is in BJ_Forget state in the committing transaction.
+	 */
+	BUFFER_TRACE(bitmap_bh, "get undo access for new indirect block");
+	err = ext3_journal_get_undo_access(handle, bitmap_bh);
+	if (err)
+		goto out;
+
+	err = -ENOSPC;
+	group_first_block = ext3_group_first_block_no(sb, group_no);
+	ext3_get_grp_metacluster(sb, &mc_start, &mc_end);
+	blk = mc_start;
+
+	while (done < *count && blk < mc_end) {
+		if (!ext3_test_allocatable(blk, bitmap_bh)) {
+			/*
+			 * Don't use find_next_usable_block() here as it may
+			 * skip free blocks that are not close to the goal.
+			 * Since our goal is always fixed (mc_start), we may
+			 * be trying to allocate slightly far from it and that
+			 * will be a problem.
+			 */
+			blk = bitmap_search_next_usable_block(blk, bitmap_bh,
+								mc_end);
+			continue;
+		}
+		if (claim_block(sb_bgl_lock(sbi, group_no), blk,
+				bitmap_bh)) {
+			new_blocks[done++] = group_first_block + blk;
+		} else {
+			/*
+		 	 * The block was allocated by another thread, or it
+			 * was allocated and then freed by another thread
+		 	 */
+			cpu_relax();
+		}
+		blk++;
+	}
+
+	if (!done) {
+		BUFFER_TRACE(bitmap_bh, "journal_release_buffer");
+		ext3_journal_release_buffer(handle, bitmap_bh);
+		goto out;
+	}
+
+	BUFFER_TRACE(bitmap_bh, "journal_dirty_metadata for bitmap block");
+	err = ext3_journal_dirty_metadata(handle, bitmap_bh);
+	if (err)
+		goto out;
+
+	BUFFER_TRACE(gdp_bh, "get_write_access");
+	err = ext3_journal_get_write_access(handle, gdp_bh);
+	if (err)
+		goto out;
+
+	/*
+	 * Caller is responsible for adding the new indirect block buffers
+	 * to the journal list.
+	 */
+
+	spin_lock(sb_bgl_lock(sbi, group_no));
+	gdp->bg_free_blocks_count =
+		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) - done);
+	spin_unlock(sb_bgl_lock(sbi, group_no));
+	percpu_counter_sub(&sbi->s_freeblocks_counter, done);
+
+	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
+	err = ext3_journal_dirty_metadata(handle, gdp_bh);
+	sb->s_dirt = 1;
+	if (err)
+		goto out;
+
+out:
+	if (bitmap_bh)
+		brelse(bitmap_bh);
+
+	DQUOT_FREE_BLOCK(inode, *count - done);
+	*count = done;
+
+	if (err && err != -ENOSPC)
+		ext3_error(sb, "ext3_new_indirect_blocks", "error %d", err);
+
+	return err;
+}
+
 /**
  * ext3_count_free_blocks() -- count filesystem free blocks
  * @sb:		superblock
diff -uprdN linux-2.6.23mm1-clean/fs/ext3/inode.c
linux-2.6.23mm1-ext3mc/fs/ext3/inode.c
--- linux-2.6.23mm1-clean/fs/ext3/inode.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/inode.c	2007-11-15 11:21:07.000000000 -0800
@@ -39,7 +39,29 @@
 #include "xattr.h"
 #include "acl.h"

+typedef struct {
+	__le32	*p;
+	__le32	key;
+	struct buffer_head *bh;
+} Indirect;
+
+struct ext3_ind_read_info {
+	int                     count;
+	int                     seq_prefetch;
+	long                    size;
+	struct buffer_head      *bh[0];
+};
+
+# define EXT3_IND_READ_INFO_SIZE(_c)        \
+	(sizeof(struct ext3_ind_read_info) + \
+	 sizeof(struct buffer_head *) * (_c))
+
+# define EXT3_IND_READ_MAX     	(32)
+
 static int ext3_writepage_trans_blocks(struct inode *inode);
+static Indirect *ext3_read_indblocks(struct inode *inode, int iblock,
+					int depth, int offsets[4],
+					Indirect chain[4], int *err);

 /*
  * Test whether an inode is a fast symlink.
@@ -233,12 +255,6 @@ no_delete:
 	clear_inode(inode);	/* We must guarantee clearing of inode... */
 }

-typedef struct {
-	__le32	*p;
-	__le32	key;
-	struct buffer_head *bh;
-} Indirect;
-
 static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 {
 	p->key = *(p->p = v);
@@ -352,18 +368,21 @@ static int ext3_block_to_path(struct ino
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
  */
 static Indirect *ext3_get_branch(struct inode *inode, int depth, int *offsets,
-				 Indirect chain[4], int *err)
+				 Indirect chain[4], int ind_readahead, int *err)
 {
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	int index;

 	*err = 0;
 	/* i_data is not going away, no lock needed */
 	add_chain (chain, NULL, EXT3_I(inode)->i_data + *offsets);
 	if (!p->key)
 		goto no_block;
-	while (--depth) {
+	for (index = 0; index < depth - 1; index++) {
+		if (ind_readahead && depth > 2 && index == depth - 2)
+			break;
 		bh = sb_bread(sb, le32_to_cpu(p->key));
 		if (!bh)
 			goto failure;
@@ -396,7 +415,15 @@ no_block:
  *	It is used when heuristic for sequential allocation fails.
  *	Rules are:
  *	  + if there is a block to the left of our position - allocate near it.
- *	  + if pointer will live in indirect block - allocate near that block.
+ *	  + If METACLUSTER options is not specified, allocate the data
+ *	  block close to the metadata block. Otherwise, if pointer will live in
+ *	  indirect block, we cannot allocate near the indirect block since
+ *	  indirect blocks are allocated in a reserved area. Even if we allocate
+ *	  this block right after the preceding logical file block, we'll still
+ *	  have to incur extra seek due to the indirect block (unless we
+ *	  prefetch the indirect block separately). So for now (until
+ *	  prefetching is turned on), it's OK not to return a sequential goal -
+ *	  just put in the same cylinder group as the inode.
  *	  + if pointer will live in inode - allocate in the same
  *	    cylinder group.
  *
@@ -421,9 +448,11 @@ static ext3_fsblk_t ext3_find_near(struc
 			return le32_to_cpu(*p);
 	}

-	/* No such thing, so let's try location of indirect block */
-	if (ind->bh)
-		return ind->bh->b_blocknr;
+	if (!test_opt(inode->i_sb, METACLUSTER)) {
+		/* No such thing, so let's try location of indirect block */
+		if (ind->bh)
+			return ind->bh->b_blocknr;
+	}

 	/*
 	 * It is going to be referred to from the inode itself? OK, just put it
@@ -475,8 +504,7 @@ static ext3_fsblk_t ext3_find_goal(struc
  *	@blks: number of data blocks to be mapped.
  *	@blocks_to_boundary:  the offset in the indirect block
  *
- *	return the total number of blocks to be allocate, including the
- *	direct and indirect blocks.
+ *	return the total number of direct blocks to be allocated.
  */
 static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
 		int blocks_to_boundary)
@@ -508,22 +536,39 @@ static int ext3_blks_to_allocate(Indirec
  *	ext3_alloc_blocks: multiple allocate blocks needed for a branch
  *	@indirect_blks: the number of blocks need to allocate for indirect
  *			blocks
- *
+ *	@blks: the number of direct blocks to be allocated
  *	@new_blocks: on return it will store the new block numbers for
  *	the indirect blocks(if needed) and the first direct block,
- *	@blks:	on return it will store the total number of allocated
- *		direct blocks
+ *
+ *	returns the number of direct blocks allocated, error via *err, and
+ *	new block numbers via new_blocks[]
  */
 static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int indirect_blks, int blks,
 			ext3_fsblk_t new_blocks[4], int *err)
 {
+	struct super_block *sb;
+	struct ext3_super_block *es;
 	int target, i;
-	unsigned long count = 0;
+	unsigned long count = 0, goal_group;
 	int index = 0;
 	ext3_fsblk_t current_block = 0;
 	int ret = 0;

+	BUG_ON(blks <= 0);
+
+	sb = inode->i_sb;
+	if (!sb) {
+		printk(KERN_INFO "ext3_alloc_blocks: nonexistent device");
+		*err = -ENODEV;
+		return 0;
+	}
+	es = EXT3_SB(sb)->s_es;
+
+	if (goal < le32_to_cpu(es->s_first_data_block) ||
+	    goal >= le32_to_cpu(es->s_blocks_count))
+		goal = le32_to_cpu(es->s_first_data_block);
+
 	/*
 	 * Here we try to allocate the requested multiple blocks at once,
 	 * on a best-effort basis.
@@ -534,6 +579,41 @@ static int ext3_alloc_blocks(handle_t *h
 	 */
 	target = blks + indirect_blks;

+	/*
+	 * Try to allocate indirect blocks in the metacluster region of block
+	 * group in which goal falls. This should not only give us clustered
+	 * metablock allocation, but also allocate new metablocks close to the
+	 * corresponding data blocks (by putting them in the same block group).
+	 * Note that allocation of indirect blocks is only guided by goal and
+	 * not by reservation window since the goal mostly falls within the
+	 * reservation window for sequential allocation.
+	 * If the indirect blocks could not be allocated in this block group,
+	 * we fall back to sequential allocation of indirect block alongside
+	 * the data block instead of trying other block groups as that can
+	 * separate indirect and data blocks too far out.
+	 */
+	if (test_opt(sb, METACLUSTER) && indirect_blks) {
+		count = indirect_blks;
+		goal_group = (goal - le32_to_cpu(es->s_first_data_block)) /
+				EXT3_BLOCKS_PER_GROUP(sb);
+		*err = ext3_new_indirect_blocks(handle, inode, goal_group,
+						&count, new_blocks + index);
+		if (*err && *err != -ENOSPC) {
+			printk(KERN_ERR "ext3_alloc_blocks failed to allocate "
+				"indirect blocks: %d", *err);
+			goto failed_out;
+		} else if (*err == 0) {
+			BUG_ON(count == 0);
+		}
+		*err = 0;
+
+		if (count > 0) {
+			index += count;
+			target -= count;
+			BUG_ON(index > indirect_blks);
+		}
+	}
+
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
@@ -542,7 +622,7 @@ static int ext3_alloc_blocks(handle_t *h
 			goto failed_out;

 		target -= count;
-		/* allocate blocks for indirect blocks */
+		/* store indirect block numbers we just allocated */
 		while (index < indirect_blks && count) {
 			new_blocks[index++] = current_block++;
 			count--;
@@ -570,10 +650,14 @@ failed_out:
  *	@inode: owner
  *	@indirect_blks: number of allocated indirect blocks
  *	@blks: number of allocated direct blocks
+ *	@goal: goal for allocation
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
  *
- *	This function allocates blocks, zeroes out all but the last one,
+ *	returns error and number of direct blocks allocated via *blks
+ *
+ *	This function allocates indirect_blks + *blks, zeroes out all
+ *	indirect blocks,
  *	links them into chain and (if we are synchronous) writes them to disk.
  *	In other words, it prepares a branch that can be spliced onto the
  *	inode. It stores the information about that chain in the branch[], in
@@ -799,17 +883,24 @@ int ext3_get_blocks_handle(handle_t *han
 	int blocks_to_boundary = 0;
 	int depth;
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	int count = 0;
+	int count = 0, ind_readahead;
 	ext3_fsblk_t first_block = 0;

-
+	BUG_ON(!create &&
+		iblock >= (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+					inode->i_sb->s_blocksize_bits);
 	J_ASSERT(handle != NULL || create == 0);
 	depth = ext3_block_to_path(inode,iblock,offsets,&blocks_to_boundary);

 	if (depth == 0)
 		goto out;

-	partial = ext3_get_branch(inode, depth, offsets, chain, &err);
+	ind_readahead = !create && depth > 2;
+	partial = ext3_get_branch(inode, depth, offsets, chain,
+				  ind_readahead, &err);
+	if (!partial && ind_readahead)
+		partial = ext3_read_indblocks(inode, iblock, depth,
+					      offsets, chain, &err);

 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
@@ -844,7 +935,7 @@ int ext3_get_blocks_handle(handle_t *han
 	}

 	/* Next simple case - plain lookup or failed read of indirect block */
-	if (!create || err == -EIO)
+	if (!create || (err && err != -EAGAIN))
 		goto cleanup;

 	mutex_lock(&ei->truncate_mutex);
@@ -866,7 +957,8 @@ int ext3_get_blocks_handle(handle_t *han
 			brelse(partial->bh);
 			partial--;
 		}
-		partial = ext3_get_branch(inode, depth, offsets, chain, &err);
+		partial = ext3_get_branch(inode, depth, offsets, chain, 0,
+					&err);
 		if (!partial) {
 			count++;
 			mutex_unlock(&ei->truncate_mutex);
@@ -1974,7 +2066,7 @@ static Indirect *ext3_find_shared(struct
 	/* Make k index the deepest non-null offest + 1 */
 	for (k = depth; k > 1 && !offsets[k-1]; k--)
 		;
-	partial = ext3_get_branch(inode, k, offsets, chain, &err);
+	partial = ext3_get_branch(inode, k, offsets, chain, 0, &err);
 	/* Writer: pointers */
 	if (!partial)
 		partial = chain + k-1;
@@ -3297,3 +3389,508 @@ int ext3_change_inode_journal_flag(struc

 	return err;
 }
+
+/*
+ * ext3_ind_read_end_bio --
+ *
+ * 	bio callback for read IO issued from ext3_read_indblocks.
+ * 	Will be called only once, when all I/O has completed.
+ * 	Frees read_info and bio.
+ */
+static void ext3_ind_read_end_bio(struct bio *bio, int err)
+{
+	struct ext3_ind_read_info *read_info = bio->bi_private;
+	struct buffer_head *bh;
+	int uptodate = !err && test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int i;
+
+	BUG_ON(read_info->count <= 0);
+
+	if (err == -EOPNOTSUPP)
+		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+
+	for (i = 0; i < read_info->count; i++) {
+		bh = read_info->bh[i];
+		BUG_ON(bh == NULL);
+
+		if (err == -EOPNOTSUPP)
+			set_bit(BH_Eopnotsupp, &bh->b_state);
+
+		if (uptodate) {
+			BUG_ON(buffer_uptodate(bh));
+			BUG_ON(ext3_buffer_prefetch(bh));
+			set_buffer_uptodate(bh);
+			if (read_info->seq_prefetch)
+				ext3_set_buffer_prefetch(bh);
+		}
+
+		unlock_buffer(bh);
+		brelse(bh);
+	}
+
+	kfree(read_info);
+	bio_put(bio);
+}
+
+/*
+ * ext3_get_max_read --
+ * 	@inode: inode of file.
+ * 	@block: block number in file (starting from zero).
+ * 	@offset_in_dind_block: offset of the indirect block inside it's
+ * 	parent doubly-indirect block.
+ *
+ *      Compute the maximum no. of indirect blocks that can be read
+ *      satisfying following constraints:
+ *              - Don't read indirect blocks beyond the end of current
+ *              doubly-indirect block.
+ *              - Don't read beyond eof.
+ */
+static inline unsigned long ext3_get_max_read(const struct inode *inode,
+						  int block,
+						  int offset_in_dind_block)
+{
+	const struct super_block *sb = inode->i_sb;
+	unsigned long max_read;
+	unsigned long ptrs = EXT3_ADDR_PER_BLOCK(inode->i_sb);
+	unsigned long ptrs_bits = EXT3_ADDR_PER_BLOCK_BITS(inode->i_sb);
+	unsigned long blocks_in_file =
+		(inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	unsigned long remaining_ind_blks_in_dind =
+		(ptrs >= offset_in_dind_block) ? (ptrs - offset_in_dind_block)
+					       : 0;
+	unsigned long remaining_ind_blks_before_eof =
+		((blocks_in_file - EXT3_NDIR_BLOCKS + ptrs - 1) >> ptrs_bits) -
+		((block - EXT3_NDIR_BLOCKS) >> ptrs_bits);
+
+	BUG_ON(block >= blocks_in_file);
+
+	max_read = min_t(unsigned long, remaining_ind_blks_in_dind,
+			 remaining_ind_blks_before_eof);
+
+	BUG_ON(max_read < 1);
+
+	return max_read;
+}
+
+static void ext3_read_indblocks_submit(struct bio **pbio,
+					struct ext3_ind_read_info **pread_info,
+					int *read_cnt, int seq_prefetch)
+{
+	struct bio *bio = *pbio;
+	struct ext3_ind_read_info *read_info = *pread_info;
+
+	BUG_ON(*read_cnt < 1);
+
+	read_info->seq_prefetch = seq_prefetch;
+	read_info->count = *read_cnt;
+	read_info->size = bio->bi_size;
+	bio->bi_private = read_info;
+	bio->bi_end_io = ext3_ind_read_end_bio;
+	submit_bio(READ, bio);
+
+	*pbio = NULL;
+	*pread_info = NULL;
+	*read_cnt = 0;
+}
+
+/*
+ * ext3_read_indblocks_async --
+ *      @sb:            super block
+ *      @ind_blocks[]:  array of indirect block numbers on disk
+ *      @count:         maximum number of indirect blocks to read
+ *      @first_bh:      buffer_head for indirect block ind_blocks[0], may be
+ *                      NULL
+ *      @seq_prefetch:  if this is part of a sequential prefetch and buffers'
+ *                      prefetch bit must be set.
+ *      @blocks_done:   number of blocks considered for prefetching.
+ *
+ *      Issue a single bio request to read upto count buffers identified in
+ *      ind_blocks[]. Fewer than count buffers may be read in some cases:
+ *      - If a buffer is found to be uptodate and it's prefetch bit is set, we
+ *      don't look at any more buffers as they will most likely be in
the cache.
+ *      - We skip buffers we cannot lock without blocking (except for first_bh
+ *			read_info->seq_prefetch = seq_prefetch;
+			read_info->count = read_cnt;
+			read_info->size = bio->bi_size;
+			bio->bi_private = read_info;
+			bio->bi_end_io = ext3_ind_read_end_bio;
+			submit_bio(READ, bio);
+      if specified).
+ *      - We skip buffers beyond a certain range on disk.
+ *
+ *      This function must issue read on first_bh if specified unless of course
+ *      it's already uptodate.
+ */
+static int ext3_read_indblocks_async(struct super_block *sb,
+				     __le32 ind_blocks[], int count,
+				     struct buffer_head *first_bh,
+				     int seq_prefetch,
+				     unsigned long *blocks_done)
+{
+	struct buffer_head *bh;
+	struct bio *bio = NULL;
+	struct ext3_ind_read_info *read_info = NULL;
+	int read_cnt = 0, blk;
+	ext3_fsblk_t prev_blk = 0, io_start_blk = 0, curr;
+	int err = 0;
+
+	BUG_ON(count < 1);
+	/* Don't move this to ext3_get_max_read() since callers often need to
+	 * trim the count returned by that function. So this bound must only
+	 * be imposed at the last moment. */
+	count = min_t(unsigned long, count, EXT3_IND_READ_MAX);
+	*blocks_done = 0UL;
+
+	if (count == 1 && first_bh) {
+		lock_buffer(first_bh);
+		get_bh(first_bh);
+		first_bh->b_end_io = end_buffer_read_sync;
+		submit_bh(READ, first_bh);
+		*blocks_done = 1UL;
+		return 0;
+	}
+
+	for (blk = 0; blk < count; blk++) {
+		curr = le32_to_cpu(ind_blocks[blk]);
+
+		if (!curr)
+			continue;
+
+		if (io_start_blk > 0) {
+			if (max(io_start_blk, curr) - min(io_start_blk, curr) >=
+					EXT3_IND_READ_MAX)
+				continue;
+		}
+
+		if (prev_blk > 0 && curr != prev_blk + 1) {
+			ext3_read_indblocks_submit(&bio, &read_info,
+						&read_cnt, seq_prefetch);
+			prev_blk = 0;
+			break;
+		}
+
+		if (blk == 0 && first_bh) {
+			bh = first_bh;
+			get_bh(first_bh);
+		} else {
+			bh = sb_getblk(sb, curr);
+			if (unlikely(!bh)) {
+				err = -ENOMEM;
+				goto failure;
+			}
+		}
+
+		if (buffer_uptodate(bh)) {
+			if (ext3_buffer_prefetch(bh)) {
+				brelse(bh);
+				break;
+			}
+			brelse(bh);
+			continue;
+		}
+
+		/* Lock the buffer without blocking, skipping any buffers
+		 * which would require us to block. first_bh when specified is
+		 * an exception as caller typically wants it to be read for
+		 * sure (e.g., ext3_read_indblocks_sync).
+		 */
+		if (bh == first_bh) {
+			lock_buffer(bh);
+		} else if (test_set_buffer_locked(bh)) {
+			brelse(bh);
+			continue;
+		}
+
+		/* Check again with the buffer locked. */
+		if (buffer_uptodate(bh)) {
+			if (ext3_buffer_prefetch(bh)) {
+				unlock_buffer(bh);
+				brelse(bh);
+				break;
+			}
+			unlock_buffer(bh);
+			brelse(bh);
+			continue;
+		}
+
+		if (read_cnt == 0) {
+			/* read_info freed in ext3_ind_read_end_bio(). */
+			read_info = kmalloc(EXT3_IND_READ_INFO_SIZE(count),
+					    GFP_KERNEL);
+			if (unlikely(!read_info)) {
+				err = -ENOMEM;
+				goto failure;
+			}
+
+			bio = bio_alloc(GFP_KERNEL, count);
+			if (unlikely(!bio)) {
+				err = -ENOMEM;
+				goto failure;
+			}
+			bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+			bio->bi_bdev = bh->b_bdev;
+		}
+
+		if (bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh))
+				< bh->b_size) {
+			brelse(bh);
+			if (read_cnt == 0)
+				goto failure;
+
+			break;
+		}
+
+		read_info->bh[read_cnt++] = bh;
+
+		prev_blk = curr;
+		if (io_start_blk == 0)
+			io_start_blk = curr;
+	}
+
+	if (read_cnt == 0)
+		goto done;
+
+	ext3_read_indblocks_submit(&bio, &read_info, &read_cnt, seq_prefetch);
+
+	*blocks_done = blk;
+	return 0;
+
+failure:
+	while (--read_cnt >= 0) {
+		unlock_buffer(read_info->bh[read_cnt]);
+		brelse(read_info->bh[read_cnt]);
+	}
+
+done:
+	if (read_info)
+		kfree(read_info);
+
+	if (bio)
+		bio_put(bio);
+
+	return err;
+}
+
+/*
+ * ext3_read_indblocks_sync --
+ *      @sb:            super block
+ *      @ind_blocks[]:  array of indirect block numbers on disk
+ *      @count:         maximum number of indirect blocks to read
+ *      @first_bh:      buffer_head for indirect block ind_blocks[0], must be
+ *                      non-NULL.
+ *      @seq_prefetch:  set prefetch bit of buffers, used when this is part of
+ *                      a sequential prefetch.
+ *      @blocks_done:   number of blocks considered for prefetching.
+ *
+ *      Synchronously read at most count indirect blocks listed in
+ *      ind_blocks[]. This function calls ext3_read_indblocks_async() to do all
+ *      the hard work. It waits for read to complete on first_bh before
+ *      returning.
+ */
+
+static int ext3_read_indblocks_sync(struct super_block *sb,
+				    __le32 ind_blocks[], int count,
+				    struct buffer_head *first_bh,
+				    int seq_prefetch,
+				    unsigned long *blocks_done)
+{
+	int err;
+
+	BUG_ON(count < 1);
+	BUG_ON(!first_bh);
+
+	err = ext3_read_indblocks_async(sb, ind_blocks, count, first_bh,
+					seq_prefetch, blocks_done);
+	if (err)
+		return err;
+
+	wait_on_buffer(first_bh);
+	if (!buffer_uptodate(first_bh))
+		err = -EIO;
+
+	/* if seq_prefetch != 0, ext3_read_indblocks_async() sets prefetch bit
+	 * for all buffers, but the first buffer for sync IO is never a prefetch
+	 * buffer since it's needed presently so mark it so.
+	 */
+	if (seq_prefetch)
+		ext3_clear_buffer_prefetch(first_bh);
+
+	BUG_ON(ext3_buffer_prefetch(first_bh));
+
+	return err;
+}
+
+/*
+ * ext3_read_indblocks --
+ *
+ * 	@inode: inode of file
+ * 	@iblock: block number inside file (starting from 0).
+ * 	@depth: depth of path from inode to data block.
+ * 	@offsets: array of offsets within blocks identified in 'chain'.
+ * 	@chain: array of Indirect with info about all levels of blocks until
+ * 	the data block.
+ * 	@err: error pointer.
+ *
+ * 	This function is called after reading all metablocks leading to 'iblock'
+ * 	except the (singly) indirect block. It reads the indirect block if not
+ * 	already in the cache and may also prefetch next few indirect blocks.
+ * 	It uses a combination of synchronous and asynchronous requests to
+ * 	accomplish this. We do prefetching even for random reads by reading
+ * 	ahead one indirect block since reads of size >=512KB have at least 12%
+ * 	chance of spanning two indirect blocks.
+ */
+
+static Indirect *ext3_read_indblocks(struct inode *inode, int iblock,
+				     int depth, int offsets[4],
+				     Indirect chain[4], int *err)
+{
+	struct super_block *sb = inode->i_sb;
+	struct buffer_head *first_bh, *prev_bh;
+	unsigned long max_read, blocks_done = 0;
+	__le32 *ind_blocks;
+
+	/* Must have doubly indirect block for prefetching indirect blocks. */
+	BUG_ON(depth <= 2);
+	BUG_ON(!chain[depth-2].key);
+
+	*err = 0;
+
+	/* Handle first block */
+	ind_blocks = chain[depth-2].p;
+	first_bh = sb_getblk(sb, le32_to_cpu(ind_blocks[0]));
+	if (unlikely(!first_bh)) {
+		printk(KERN_ERR "Failed to get block %u for sb %p\n",
+		       le32_to_cpu(ind_blocks[0]), sb);
+		goto failure;
+	}
+
+	BUG_ON(first_bh->b_size != sb->s_blocksize);
+
+	if (buffer_uptodate(first_bh)) {
+		/* Found the buffer in cache, either it was accessed recently or
+		 * it was prefetched while reading previous indirect block(s).
+		 * We need to figure out if we need to prefetch the following
+		 * indirect blocks.
+		 */
+		if (!ext3_buffer_prefetch(first_bh)) {
+			/* Either we've seen this indirect block before while
+			 * accessing another data block, or this is a random
+			 * read. In the former case, we must have done the
+			 * needful the first time we had a cache hit on this
+			 * indirect block, in the latter case we obviously
+			 * don't need to do any prefetching.
+			 */
+			goto done;
+		}
+
+		max_read = ext3_get_max_read(inode, iblock,
+					     offsets[depth-2]);
+
+		/* This indirect block is in the cache due to prefetching and
+		 * this is its first cache hit, clear the prefetch bit and
+		 * make sure the following blocks are also prefetched.
+		 */
+		ext3_clear_buffer_prefetch(first_bh);
+
+		if (max_read >= 2) {
+			/* ext3_read_indblocks_async() stops at the first
+			 * indirect block which has the prefetch bit set which
+			 * will most likely be the very next indirect block.
+			 */
+			ext3_read_indblocks_async(sb, &ind_blocks[1],
+						  max_read - 1,
+						  NULL, 1, &blocks_done);
+		}
+
+	} else {
+		/* Buffer is not in memory, we need to read it. If we are
+		 * reading sequentially from the previous indirect block, we
+		 * have just detected a sequential read and we must prefetch
+		 * some indirect blocks for future.
+		 */
+
+		max_read = ext3_get_max_read(inode, iblock,
+					     offsets[depth-2]);
+
+		if ((ind_blocks - (__le32 *)chain[depth-2].bh->b_data) >= 1) {
+			prev_bh = sb_getblk(sb, le32_to_cpu(ind_blocks[-1]));
+			if (buffer_uptodate(prev_bh) &&
+			    !ext3_buffer_prefetch(prev_bh)) {
+				/* Detected sequential read. */
+				brelse(prev_bh);
+
+				/* Sync read indirect block, also read the next
+				 * few indirect blocks.
+				 */
+				*err = ext3_read_indblocks_sync(sb, ind_blocks,
+							 max_read, first_bh, 1,
+							 &blocks_done);
+
+				if (*err)
+					goto out;
+
+				/* In case the very next indirect block is
+				 * discontiguous by a non-trivial amount,
+				 * ext3_read_indblocks_sync() above won't
+				 * prefetch it (indicated by blocks_done < 2).
+				 * So to help sequential read, schedule an
+				 * async request for reading the next
+				 * contiguous indirect block range (which
+				 * in metaclustering case would be the next
+				 * metacluster, without metaclustering it
+				 * would be the next indirect block). This is
+				 * expected to benefit the non-metaclustering
+				 * case.
+				 */
+				if (max_read >= 2 && blocks_done < 2)
+					ext3_read_indblocks_async(sb,
+							&ind_blocks[1],
+							max_read - 1,
+							NULL, 1, &blocks_done);
+
+				goto done;
+			}
+			brelse(prev_bh);
+		}
+
+		/* Either random read, or sequential detection failed above.
+		 * We always prefetch the next indirect block in this case
+		 * whenever possible.
+		 * This is because for random reads of size ~512KB, there is
+		 * >12% chance that a read will span two indirect blocks.
+		 */
+		*err = ext3_read_indblocks_sync(sb, ind_blocks,
+						(max_read >= 2) ? 2 : 1,
+						first_bh, 0, &blocks_done);
+		if (*err)
+			goto out;
+	}
+
+done:
+	/* Reader: pointers */
+	if (!verify_chain(chain, &chain[depth - 2])) {
+		brelse(first_bh);
+		goto changed;
+	}
+	add_chain(&chain[depth - 1], first_bh,
+		  (__le32*)first_bh->b_data + offsets[depth - 1]);
+	/* Reader: end */
+	if (!chain[depth - 1].key)
+		goto out;
+
+	BUG_ON(!buffer_uptodate(first_bh));
+	return NULL;
+
+changed:
+	*err = -EAGAIN;
+	goto out;
+failure:
+	*err = -EIO;
+out:
+	if (*err) {
+		ext3_debug("Error %d reading indirect blocks\n", *err);
+		return &chain[depth - 2];
+	} else
+		return &chain[depth - 1];
+}
+
diff -uprdN linux-2.6.23mm1-clean/fs/ext3/super.c
linux-2.6.23mm1-ext3mc/fs/ext3/super.c
--- linux-2.6.23mm1-clean/fs/ext3/super.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/super.c	2007-11-09 16:46:29.000000000 -0800
@@ -625,6 +625,9 @@ static int ext3_show_options(struct seq_
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");

+	if (test_opt(sb, METACLUSTER))
+		seq_puts(seq, ",metacluster");
+
 	ext3_show_quota_options(seq, sb);

 	return 0;
@@ -758,7 +761,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_metacluster
 };

 static match_table_t tokens = {
@@ -808,6 +811,7 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
+	{Opt_metacluster, "metacluster"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1140,6 +1144,9 @@ clear_qf_name:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_metacluster:
+			set_opt(sbi->s_mount_opt, METACLUSTER);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
diff -uprdN linux-2.6.23mm1-clean/include/linux/ext3_fs.h
linux-2.6.23mm1-ext3mc/include/linux/ext3_fs.h
--- linux-2.6.23mm1-clean/include/linux/ext3_fs.h	2007-10-17
18:31:43.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/include/linux/ext3_fs.h	2007-11-15
11:53:17.000000000 -0800
@@ -380,6 +380,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_METACLUSTER		0x400000 /* Indirect block clustering */

 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
@@ -493,6 +494,7 @@ struct ext3_super_block {
 #ifdef __KERNEL__
 #include <linux/ext3_fs_i.h>
 #include <linux/ext3_fs_sb.h>
+#include <linux/buffer_head.h>
 static inline struct ext3_sb_info * EXT3_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
@@ -722,6 +724,11 @@ struct dir_private_info {
 	__u32		next_hash;
 };

+/* Special bh flag used by the metacluster readahead logic. */
+enum ext3_bh_state_bits {
+	EXT3_BH_PREFETCH = BH_JBD_Sentinel,
+};
+
 /* calculate the first block number of the group */
 static inline ext3_fsblk_t
 ext3_group_first_block_no(struct super_block *sb, unsigned long group_no)
@@ -730,6 +737,24 @@ ext3_group_first_block_no(struct super_b
 		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block);
 }

+static inline void
+ext3_set_buffer_prefetch(struct buffer_head *bh)
+{
+	set_bit(EXT3_BH_PREFETCH, &bh->b_state);
+}
+
+static inline void
+ext3_clear_buffer_prefetch(struct buffer_head *bh)
+{
+	clear_bit(EXT3_BH_PREFETCH, &bh->b_state);
+}
+
+static inline int
+ext3_buffer_prefetch(struct buffer_head *bh)
+{
+	return test_bit(EXT3_BH_PREFETCH, &bh->b_state);
+}
+
 /*
  * Special error return code only used by dx_probe() and its callers.
  */
@@ -752,6 +777,9 @@ extern int ext3_bg_has_super(struct supe
 extern unsigned long ext3_bg_num_gdb(struct super_block *sb, int group);
 extern ext3_fsblk_t ext3_new_block (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int *errp);
+extern int ext3_new_indirect_blocks(handle_t *handle, struct inode *,
+				unsigned long group_no, unsigned long *,
+				ext3_fsblk_t new_blocks[]);
 extern ext3_fsblk_t ext3_new_blocks (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext3_free_blocks (handle_t *handle, struct inode *inode,
@@ -870,6 +898,31 @@ extern const struct inode_operations ext
 extern const struct inode_operations ext3_symlink_inode_operations;
 extern const struct inode_operations ext3_fast_symlink_inode_operations;

+/*
+ * ext3_get_grp_metacluster:
+ *
+ * 	Determines metacluster block range for all block groups of the file
+ * 	system.
+ *
+ * 	Number of metacluster blocks = blocks_per_group/128. This allows us
+ * 	to fit all indirect blocks in a block group with average file size of
+ * 	256KB into the group's metacluster. We want to avoid having large
+ * 	metaclusters because then we'll run of data blocks sooner and when
+ * 	out of data blocks metaclustering goes for a toss.
+ * 	
+ */
+static inline void
+ext3_get_grp_metacluster(struct super_block *sb,
+				ext3_grpblk_t *mc_start,
+				ext3_grpblk_t *mc_end)	/* exclusive */
+{
+	*mc_start = EXT3_BLOCKS_PER_GROUP(sb) / 2;
+	if (test_opt(sb, METACLUSTER)) {
+		*mc_end = *mc_start + EXT3_BLOCKS_PER_GROUP(sb) >> 7;
+	} else {
+		*mc_end = *mc_start;
+	}
+}

 #endif	/* __KERNEL__ */

diff -uprdN linux-2.6.23mm1-clean/include/linux/jbd.h
linux-2.6.23mm1-ext3mc/include/linux/jbd.h
--- linux-2.6.23mm1-clean/include/linux/jbd.h	2007-10-17
18:31:43.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/include/linux/jbd.h	2007-11-09
16:46:29.000000000 -0800
@@ -294,6 +294,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_JBD_Sentinel,	/* Start bit for clients of jbd */
 };

 BUFFER_FNS(JBD, jbd)
