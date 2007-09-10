From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mballoc review
Date: Mon, 10 Sep 2007 15:33:23 +0530
Message-ID: <46E5166B.4040904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:49158 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXIJKEA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2007 06:04:00 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8AA3a0i031928
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 20:03:36 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8AA3bER4874320
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 20:03:37 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8AB3aTt002531
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 21:03:36 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Alex,

Attaching below is some of the questions and comments i had while looking at
mballoc code. Can you take a look at this. I will try to push a new patch which 
contain

a) comments from the below review
b) uninitialzed group changes assuming the uninitialized group patches will go before
   mballoc
c) checkpatch.pl error fixes.
d) mkdir oops fix

NOTE: I am not sure whether we need the little endian  ext2_find_next_le_bit. I have marked
it in the below diff


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a28ba0c..bdc83a8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -846,20 +846,27 @@ ext4_mb_generate_buddy(struct super_block *sb, void *buddy, void *bitmap,
 	unsigned free = 0, fragments = 0;
 	unsigned long long period = get_cycles();
 
 	/* initialize buddy from bitmap which is aggregation
 	 * of on-disk bitmap and preallocations */
 	i = mb_find_next_zero_bit(bitmap, max, 0);
 	grp->bb_first_free = i;
 	while (i < max) {
 		fragments++;
 		first = i;
+		/*
+		 * We need to explain what is the endianess dependency
+		 * here
+		 * Right now it looks at the bitmap read from the
+		 * disk and AFAIU the bitmap are stored in an endian
+		 * neutral way. I guess we can switch this to find_next_bit
+		 */
 		i = ext2_find_next_le_bit(bitmap, max, i);
 		len = i - first;
 		free += len;
 		if (len > 1)
 			ext4_mb_mark_free_simple(sb, buddy, first, len, grp);
 		else
 			grp->bb_counters[0]++;
 		if (i < max)
 			i = mb_find_next_zero_bit(bitmap, max, i);
 	}
@@ -873,20 +880,40 @@ ext4_mb_generate_buddy(struct super_block *sb, void *buddy, void *bitmap,
 
 	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &grp->bb_state);
 
 	period = get_cycles() - period;
 	spin_lock(&EXT4_SB(sb)->s_bal_lock);
 	EXT4_SB(sb)->s_mb_buddies_generated++;
 	EXT4_SB(sb)->s_mb_generation_time += period;
 	spin_unlock(&EXT4_SB(sb)->s_bal_lock);
 }
 
+/* Need description of how the buddy cache inode maps to
+ * different groups and block
+ */
+/* The buddy information is attached the buddy cache inode
+ * for convenience. The information regarding each group
+ * is loaded via ext4_mb_load_buddy. The information involve
+ * block bitmap and buddy information. The information are
+ * stored in the inode as
+ *
+ * {                        page                        }
+ * [ group 0 buddy][ group 0 bitmap] [group 1][ group 1]...
+ *
+ *
+ * one block each for bitmap and buddy information.
+ * So for each group we take up 2 blocks. A page can
+ * contain blocks_per_page (PAGE_CACHE_SIZE / blocksize)  blocks.
+ * So it can have information regarding groups_per_page which
+ * is blocks_per_page/2
+ */
+
 static int ext4_mb_init_cache(struct page *page, char *incore)
 {
 	int blocksize, blocks_per_page, groups_per_page;
 	int err = 0, i, first_group, first_block;
 	struct super_block *sb;
 	struct buffer_head *bhs;
 	struct buffer_head **bh;
 	struct inode *inode;
 	char *data, *bitmap;
 
@@ -920,20 +947,21 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 		if (first_group + i >= EXT4_SB(sb)->s_groups_count)
 			break;
 
 		err = -EIO;
 		desc = ext4_get_group_desc(sb, first_group + i, NULL);
 		if (desc == NULL)
 			goto out;
 
 		err = -ENOMEM;
+		/* ext4_block_bitmap */
 		bh[i] = sb_getblk(sb, le32_to_cpu(desc->bg_block_bitmap));
 		if (bh[i] == NULL)
 			goto out;
 
 		if (buffer_uptodate(bh[i]))
 			continue;
 
 		lock_buffer(bh[i]);
 		if (buffer_uptodate(bh[i])) {
 			unlock_buffer(bh[i]);
@@ -956,48 +984,64 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			goto out;
 
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
 
 		group = (first_block + i) >> 1;
 		if (group >= EXT4_SB(sb)->s_groups_count)
 			break;
 
+		/*
+		 * data carry information regarding this
+		 * particular group in the format specified
+		 * above
+		 *
+		 */
 		data = page_address(page) + (i * blocksize);
 		bitmap = bh[group - first_group]->b_data;
 
+		/*
+		 * We place the buddy block and bitmap block
+		 * close together
+		 */
 		if ((first_block + i) & 1) {
 			/* this is block of buddy */
 			BUG_ON(incore == NULL);
 			mb_debug("put buddy for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
 			memset(data, 0xff, blocksize);
 			EXT4_GROUP_INFO(sb, group)->bb_fragments = 0;
 			memset(EXT4_GROUP_INFO(sb, group)->bb_counters, 0,
 			       sizeof(unsigned short)*(sb->s_blocksize_bits+2));
+			/*
+			 * incore got set to the group block bitmap below
+			 */
 			ext4_mb_generate_buddy(sb, data, incore, group);
 			incore = NULL;
 		} else {
 			/* this is block of bitmap */
 			BUG_ON(incore != NULL);
 			mb_debug("put bitmap for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
 
 			/* see comments in ext4_mb_put_pa() */
 			ext4_lock_group(sb, group);
 			memcpy(data, bitmap, blocksize);
 
 			/* mark all preallocated blocks used in in-core bitmap */
 			ext4_mb_generate_from_pa(sb, data, group);
 			ext4_unlock_group(sb, group);
 
+			/* set incore so that the buddy information can be
+			 * generated using this
+			 */
 			incore = data;
 		}
 	}
 	SetPageUptodate(page);
 
 out:
 	if (bh) {
 		for (i = 0; i < groups_per_page && bh[i]; i++)
 			brelse(bh[i]);
 		if (bh != &bhs)
@@ -1018,20 +1062,25 @@ static int ext4_mb_load_buddy(struct super_block *sb, int group,
 
 	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
 
 	e3b->bd_blkbits = sb->s_blocksize_bits;
 	e3b->bd_info = EXT4_GROUP_INFO(sb, group);
 	e3b->bd_sb = sb;
 	e3b->bd_group = group;
 	e3b->bd_buddy_page = NULL;
 	e3b->bd_bitmap_page = NULL;
 
+	/*
+	 * the buddy cache inode stores the block bitmap
+	 * and buddy information in consecutive blocks.
+	 * So for each group we need two blocks.
+	 */
 	block = group * 2;
 	pnum = block / blocks_per_page;
 	poff = block % blocks_per_page;
 
 	/* we could use find_or_create_page(), but it locks page
 	 * what we'd like to avoid in fast path ... */
 	page = find_get_page(inode->i_mapping, pnum);
 	if (page == NULL || !PageUptodate(page)) {
 		if (page)
 			page_cache_release(page);
@@ -1758,42 +1807,49 @@ int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	/* first, try the goal */
 	err = ext4_mb_find_by_goal(ac, &e3b);
 	if (err || ac->ac_status == AC_STATUS_FOUND)
 		goto out;
 
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		goto out;
 
 	i = ffs(ac->ac_g_ex.fe_len);
 	ac->ac_2order = 0;
+	/* What happens if it  i is still greater than s_mb_order2_reqs */
 	if (i >= sbi->s_mb_order2_reqs) {
 		i--;
 		if ((ac->ac_g_ex.fe_len & (~(1 << i))) == 0)
 			ac->ac_2order = i;
 	}
 
 	/* if stream allocation is enabled, use global goal */
+	/* Need more explanation on what it is and how stream
+	 * allocation is represented by the below conditional */
 	if ((ac->ac_g_ex.fe_len < sbi->s_mb_large_req) &&
 			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
 		/* TBD: may be hot point */
 		spin_lock(&sbi->s_md_lock);
 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
 		spin_unlock(&sbi->s_md_lock);
 	}
 
 	group = ac->ac_g_ex.fe_group;
 
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
 repeat:
 	for (; cr < 4 && ac->ac_status == AC_STATUS_CONTINUE; cr++) {
+		/* We need to explain what criteria is and also
+		 * need to define the number 0 to 4 for criteria
+		 * What they actually means.
+		 */
 		ac->ac_criteria = cr;
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
 
 			if (group == EXT4_SB(sb)->s_groups_count)
 				group = 0;
 
 			/* quick check to skip empty groups */
 			grp = EXT4_GROUP_INFO(ac->ac_sb, group);
 			if (grp->bb_free == 0)
@@ -1805,20 +1861,22 @@ repeat:
 				err = ext4_mb_load_buddy(sb, group, &e3b);
 				if (err)
 					goto out;
 				ext4_mb_release_desc(&e3b);
 			}
 
 			/* check is group good for our criteries */
 			if (!ext4_mb_good_group(ac, group, cr))
 				continue;
 
+			/* here also we are loading the buddy. so what difference
+			 * does EXT4_MB_GRP_NEED_INIT actually make */
 			err = ext4_mb_load_buddy(sb, group, &e3b);
 			if (err)
 				goto out;
 
 			ext4_lock_group(sb, group);
 			if (!ext4_mb_good_group(ac, group, cr)) {
 				/* someone did allocation from this group */
 				ext4_unlock_group(sb, group);
 				ext4_mb_release_desc(&e3b);
 				continue;
@@ -2848,20 +2906,21 @@ int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac, handle_t *ha
 		goto out_err;
 
 	err = ext4_journal_get_write_access(handle, gdp_bh);
 	if (err)
 		goto out_err;
 
 	block = ac->ac_b_ex.fe_group * EXT4_BLOCKS_PER_GROUP(sb)
 		+ ac->ac_b_ex.fe_start
 		+ le32_to_cpu(es->s_first_data_block);
 
+		/* ext4_block_bitmap  ext4_inode_bitmap ext4_inode_table*/
 	if (block == le32_to_cpu(gdp->bg_block_bitmap) ||
 			block == le32_to_cpu(gdp->bg_inode_bitmap) ||
 			in_range(block, le32_to_cpu(gdp->bg_inode_table),
 				EXT4_SB(sb)->s_itb_per_group))
 		ext4_error(sb, __FUNCTION__,
 			   "Allocating block in system zone - block = %lu",
 			   (unsigned long) block);
 #ifdef AGGRESSIVE_CHECK
 	{
 		int i;
@@ -3813,32 +3872,36 @@ void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 
 		if (grp->bb_free == 0)
 			continue;
 		printk("%d: %d/%d ", i, grp->bb_free, grp->bb_fragments);
 	}
 	printk("\n");
 	//dump_stack();
 #endif
 }
 
+/* Need comment explaining when we look at locality group
+ * based allocation */
+
 void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
 
 	/* request is so large that we don't care about
 	 * streaming - it overweights any possible seek */
 	if (ac->ac_o_ex.fe_len >= sbi->s_mb_large_req)
 		return;
 
+	/*is this  >=  considering the above ?*/
 	if (ac->ac_o_ex.fe_len >= sbi->s_mb_small_req)
 		return;
 
 	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
 		return;
 
 	BUG_ON(ac->ac_lg != NULL);
 	ac->ac_lg = &sbi->s_locality_groups[smp_processor_id()];
 
 	/* we're going to use group allocation */
@@ -3852,20 +3915,21 @@ int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	struct super_block *sb = ar->inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	unsigned long group, len, goal;
 	ext4_grpblk_t block;
 
 	/* we can't allocate > group size */
 	len = ar->len;
+	/* What is  10 here ? */
 	if (len >= EXT4_BLOCKS_PER_GROUP(sb) - 10)
 		len = EXT4_BLOCKS_PER_GROUP(sb) - 10;
 
 	/* start searching from the goal */
 	goal = ar->goal;
 	if (goal < le32_to_cpu(es->s_first_data_block) ||
 			goal >= le32_to_cpu(es->s_blocks_count))
 		goal = le32_to_cpu(es->s_first_data_block);
 	ext4_get_group_no_and_offset(sb, goal, &group, &block);
 
@@ -4187,20 +4251,21 @@ do_more:
 		count -= overflow;
 	}
 	brelse(bitmap_bh);
 	bitmap_bh = read_block_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
 	gdp = ext4_get_group_desc (sb, block_group, &gd_bh);
 	if (!gdp)
 		goto error_return;
 
+		/* ext4_block_bitmap  ext4_inode_bitmap ext4_inode_table*/
 	if (in_range (le32_to_cpu(gdp->bg_block_bitmap), block, count) ||
 	    in_range (le32_to_cpu(gdp->bg_inode_bitmap), block, count) ||
 	    in_range (block, le32_to_cpu(gdp->bg_inode_table),
 		      EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range (block + count - 1, le32_to_cpu(gdp->bg_inode_table),
 		      EXT4_SB(sb)->s_itb_per_group))
 		ext4_error(sb, __FUNCTION__,
 			   "Freeing blocks in system zone - "
 			   "Block = %lu, count = %lu", block, count);
 
