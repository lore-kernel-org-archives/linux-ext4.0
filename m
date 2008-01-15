From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: checkpatch.pl warnings
Date: Tue, 15 Jan 2008 18:22:24 +0530
Message-ID: <20080115125224.GA18227@skywalker>
References: <4787D498.1050202@redhat.com> <20080112163144.GA6546@skywalker> <4788ED9E.3090207@redhat.com> <4788EE87.5040007@redhat.com> <1200343767.4197.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37716 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbYAOMwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2008 07:52:36 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0FCqPTm013274
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 23:52:25 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0FCqWQm2768942
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 23:52:33 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0FCqX0d000568
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2008 23:52:33 +1100
Content-Disposition: inline
In-Reply-To: <1200343767.4197.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2008 at 12:49:27PM -0800, Mingming Cao wrote:
> Hi Guys,
> 
> Could you check the checkpatch.pl warnings and see if it make sense to fix them? Thanks!
> 
> cmm@kernel:~/fs/ext4/stylecheck$ grep "has style problems" *
> linux-2.6.24-rc7-48-bit-i_blocks.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-ext3-4-migrate.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-ext4_export_iov_shorten_from_kernel_for_ext4.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-ext4-journal_chksum-2.6.20.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-ext4_rec_len_overflow_with_64kblk_fix-v2.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-ext4_store_maxbytes_for_bitmaped_files.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-inode-version-ext4.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-jbd-stats-through-procfs.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-large-file-blocktype.patch.out:Your patch has style problems, please review.  If any of these errors
> linux-2.6.24-rc7-mballoc-core.patch.out:Your patch has style problems, please review.  If any of these errors
> 

Fixed the checkpatch.pl warning for all the patches in the patch queue.
The diff is attached below for review.

patch queue at
http://www.radian.org/~kvaneesh/ext4/jan-15-2008/
http://www.radian.org/~kvaneesh/ext4/jan-15-2008/patch-queue.tar

This include the complete patch queue.

Tested with
----------
fsx_linux, fs_inode, fsstress on x86_64 
fsx_linux, fs_inode, fsstress on ppc64


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1e46997..2ea7ef4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1798,8 +1798,9 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		printk(KERN_INFO "strange request: removal %u-%u from %u:%u\n",
 			from, to, le32_to_cpu(ex->ee_block), ee_len);
 	} else {
-		printk(KERN_INFO "strange request: removal(2) %u-%u from %u:%u\n",
-			from, to, le32_to_cpu(ex->ee_block), ee_len);
+		printk(KERN_INFO "strange request: removal(2) "
+				"%u-%u from %u:%u\n",
+				from, to, le32_to_cpu(ex->ee_block), ee_len);
 	}
 	return 0;
 }
@@ -2140,10 +2141,11 @@ void ext4_ext_release(struct super_block *sb)
  *   b> Splits in two extents: Write is happening at either end of the extent
  *   c> Splits in three extents: Somone is writing in middle of the extent
  */
-static int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
-					struct ext4_ext_path *path,
-					ext4_lblk_t iblock,
-					unsigned long max_blocks)
+static int ext4_ext_convert_to_initialized(handle_t *handle,
+						struct inode *inode,
+						struct ext4_ext_path *path,
+						ext4_lblk_t iblock,
+						unsigned long max_blocks)
 {
 	struct ext4_extent *ex, newex;
 	struct ext4_extent *ex1 = NULL;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7dc5f3..6bb788d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -751,7 +751,8 @@ err_out:
 	for (i = 1; i <= num; i++) {
 		BUFFER_TRACE(where[i].bh, "call jbd2_journal_forget");
 		ext4_journal_forget(handle, where[i].bh);
-		ext4_free_blocks(handle,inode,le32_to_cpu(where[i-1].key),1, 0);
+		ext4_free_blocks(handle, inode,
+					le32_to_cpu(where[i-1].key), 1, 0);
 	}
 	ext4_free_blocks(handle, inode, le32_to_cpu(where[num].key), blks, 0);
 
@@ -2829,7 +2830,7 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 				EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		/* we are using combined 48 bit field */
 		i_blocks = ((u64)le16_to_cpu(raw_inode->i_blocks_high)) << 32 |
-						le32_to_cpu(raw_inode->i_blocks_lo);
+					le32_to_cpu(raw_inode->i_blocks_lo);
 		if (ei->i_flags & EXT4_HUGE_FILE_FL) {
 			/* i_blocks represent file system block size */
 			return i_blocks  << (inode->i_blkbits - 9);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 16854fd..d8cd81e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -337,7 +337,7 @@ struct ext4_group_info {
 #define EXT4_GROUP_INFO_LOCKED_BIT	1
 
 #define EXT4_MB_GRP_NEED_INIT(grp)	\
-	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp)->bb_state))
+	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
 
 
 struct ext4_prealloc_space {
@@ -468,30 +468,34 @@ static void ext4_mb_free_committed_blocks(struct super_block *);
 static void ext4_mb_return_to_preallocation(struct inode *inode,
 					struct ext4_buddy *e4b, sector_t block,
 					int count);
-static void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *,
-						struct ext4_prealloc_space *pa);
+static void ext4_mb_put_pa(struct ext4_allocation_context *,
+			struct super_block *, struct ext4_prealloc_space *pa);
 static int ext4_mb_init_per_dev_proc(struct super_block *sb);
 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
 
 
 static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
 {
-	bit_spin_lock(EXT4_GROUP_INFO_LOCKED_BIT,
-		      &EXT4_GROUP_INFO(sb, group)->bb_state);
+	struct ext4_group_info *grinfo = ext4_get_group_info(sb, group);
+
+	bit_spin_lock(EXT4_GROUP_INFO_LOCKED_BIT, &(grinfo->bb_state));
 }
 
 static inline void ext4_unlock_group(struct super_block *sb,
 					ext4_group_t group)
 {
-	bit_spin_unlock(EXT4_GROUP_INFO_LOCKED_BIT,
-			&EXT4_GROUP_INFO(sb, group)->bb_state);
+	struct ext4_group_info *grinfo = ext4_get_group_info(sb, group);
+
+	bit_spin_unlock(EXT4_GROUP_INFO_LOCKED_BIT, &(grinfo->bb_state));
 }
 
 static inline int ext4_is_group_locked(struct super_block *sb,
 					ext4_group_t group)
 {
+	struct ext4_group_info *grinfo = ext4_get_group_info(sb, group);
+
 	return bit_spin_is_locked(EXT4_GROUP_INFO_LOCKED_BIT,
-					&EXT4_GROUP_INFO(sb, group)->bb_state);
+						&(grinfo->bb_state));
 }
 
 static ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
@@ -673,7 +677,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 		return 0;
 
 	{
-		static int mb_check_counter = 0;
+		static int mb_check_counter;
 		if (mb_check_counter++ % 100 != 0)
 			return 0;
 	}
@@ -739,7 +743,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
 	MB_CHECK_ASSERT(e4b->bd_info->bb_fragments == fragments);
 
-	grp = EXT4_GROUP_INFO(sb, e4b->bd_group);
+	grp = ext4_get_group_info(sb, e4b->bd_group);
 	buddy = mb_find_buddy(e4b, 0, &max);
 	list_for_each(cur, &grp->bb_prealloc_list) {
 		ext4_group_t groupnr;
@@ -753,7 +757,8 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	return 0;
 }
 #undef MB_CHECK_ASSERT
-#define mb_check_buddy(e4b) __mb_check_buddy(e4b, __FILE__, __FUNCTION__, __LINE__)
+#define mb_check_buddy(e4b) __mb_check_buddy(e4b,	\
+					__FILE__, __FUNCTION__, __LINE__)
 #else
 #define mb_check_buddy(e4b)
 #endif
@@ -818,7 +823,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 static void ext4_mb_generate_buddy(struct super_block *sb,
 				void *buddy, void *bitmap, ext4_group_t group)
 {
-	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
+	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	unsigned short max = EXT4_BLOCKS_PER_GROUP(sb);
 	unsigned short i = 0;
 	unsigned short first;
@@ -853,7 +858,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 		grp->bb_free = free;
 	}
 
-	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &grp->bb_state);
+	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
 
 	period = get_cycles() - period;
 	spin_lock(&EXT4_SB(sb)->s_bal_lock);
@@ -970,6 +975,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
+		struct ext4_group_info *grinfo;
 
 		group = (first_block + i) >> 1;
 		if (group >= EXT4_SB(sb)->s_groups_count)
@@ -994,8 +1000,9 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			mb_debug("put buddy for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
 			memset(data, 0xff, blocksize);
-			EXT4_GROUP_INFO(sb, group)->bb_fragments = 0;
-			memset(EXT4_GROUP_INFO(sb, group)->bb_counters, 0,
+			grinfo = ext4_get_group_info(sb, group);
+			grinfo->bb_fragments = 0;
+			memset(grinfo->bb_counters, 0,
 			       sizeof(unsigned short)*(sb->s_blocksize_bits+2));
 			/*
 			 * incore got set to the group block bitmap below
@@ -1050,7 +1057,7 @@ static int ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
 
 	e4b->bd_blkbits = sb->s_blocksize_bits;
-	e4b->bd_info = EXT4_GROUP_INFO(sb, group);
+	e4b->bd_info = ext4_get_group_info(sb, group);
 	e4b->bd_sb = sb;
 	e4b->bd_group = group;
 	e4b->bd_buddy_page = NULL;
@@ -1706,7 +1713,8 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	i = e4b->bd_info->bb_first_free;
 
 	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
-		i = ext4_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
+		i = ext4_find_next_zero_bit(bitmap,
+						EXT4_BLOCKS_PER_GROUP(sb), i);
 		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
 			BUG_ON(free != 0);
 			break;
@@ -1771,7 +1779,7 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	unsigned free, fragments;
 	unsigned i, bits;
 	struct ext4_group_desc *desc;
-	struct ext4_group_info *grp = EXT4_GROUP_INFO(ac->ac_sb, group);
+	struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb, group);
 
 	BUG_ON(cr < 0 || cr >= 4);
 	BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));
@@ -1893,7 +1901,7 @@ repeat:
 				group = 0;
 
 			/* quick check to skip empty groups */
-			grp = EXT4_GROUP_INFO(ac->ac_sb, group);
+			grp = ext4_get_group_info(ac->ac_sb, group);
 			if (grp->bb_free == 0)
 				continue;
 
@@ -1901,7 +1909,7 @@ repeat:
 			 * if the group is already init we check whether it is
 			 * a good group and if not we don't load the buddy
 			 */
-			if (EXT4_MB_GRP_NEED_INIT(EXT4_GROUP_INFO(sb, group))) {
+			if (EXT4_MB_GRP_NEED_INIT(grp)) {
 				/*
 				 * we need full data about the group
 				 * to make a good selection
@@ -1937,7 +1945,8 @@ repeat:
 					cpu_to_le16(EXT4_BG_BLOCK_UNINIT) &&
 					ac->ac_2order != 0)) {
 				ext4_mb_simple_scan_group(ac, &e4b);
-			} else if (cr == 1 && ac->ac_g_ex.fe_len == sbi->s_stripe) {
+			} else if (cr == 1 &&
+					ac->ac_g_ex.fe_len == sbi->s_stripe) {
 				ext4_mb_scan_aligned(ac, &e4b);
 			} else {
 				ext4_mb_complex_scan_group(ac, &e4b);
@@ -2042,7 +2051,7 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq, "%-5s %-8s %-23s %-23s %-23s %-5s "
 				"%-5s %-2s %-5s %-5s %-5s %-6s\n",
-			   "pid", "inode", "original", "goal", "result","found",
+			  "pid", "inode", "original", "goal", "result", "found",
 			   "grps", "cr", "flags", "merge", "tail", "broken");
 		return 0;
 	}
@@ -2223,7 +2232,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 				"[ %-5s %-5s %-5s %-5s %-5s %-5s %-5s "
 				  "%-5s %-5s %-5s %-5s %-5s %-5s %-5s ]\n",
 			   "group", "free", "frags", "first",
-			   "2^0", "2^1", "2^2", "2^3", "2^4", "2^5","2^6",
+			   "2^0", "2^1", "2^2", "2^3", "2^4", "2^5", "2^6",
 			   "2^7", "2^8", "2^9", "2^10", "2^11", "2^12", "2^13");
 
 	i = (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters[0]) +
@@ -2234,7 +2243,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 		return 0;
 	}
 	ext4_lock_group(sb, group);
-	memcpy(&sg, EXT4_GROUP_INFO(sb, group), i);
+	memcpy(&sg, ext4_get_group_info(sb, group), i);
 	ext4_unlock_group(sb, group);
 	ext4_mb_release_desc(&e4b);
 
@@ -2431,7 +2440,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		}
 		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
-			&meta_group_info[j]->bb_state);
+			&(meta_group_info[j]->bb_state));
 
 		/*
 		 * initialize bb_free to be able to skip
@@ -2467,7 +2476,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 
 err_freebuddy:
 	while (i >= 0) {
-		kfree(EXT4_GROUP_INFO(sb, i));
+		kfree(ext4_get_group_info(sb, i));
 		i--;
 	}
 	i = num_meta_group_infos;
@@ -2584,9 +2593,10 @@ static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 
 int ext4_mb_release(struct super_block *sb)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t i;
 	int num_meta_group_infos;
+	struct ext4_group_info *grinfo;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (!test_opt(sb, MBALLOC))
 		return 0;
@@ -2602,12 +2612,12 @@ int ext4_mb_release(struct super_block *sb)
 
 	if (sbi->s_group_info) {
 		for (i = 0; i < sbi->s_groups_count; i++) {
+			grinfo = ext4_get_group_info(sb, i);
 #ifdef DOUBLE_CHECK
-			if (EXT4_GROUP_INFO(sb, i)->bb_bitmap)
-				kfree(EXT4_GROUP_INFO(sb, i)->bb_bitmap);
+			kfree(grinfo->bb_bitmap);
 #endif
-			ext4_mb_cleanup_pa(EXT4_GROUP_INFO(sb, i));
-			kfree(EXT4_GROUP_INFO(sb, i));
+			ext4_mb_cleanup_pa(grinfo);
+			kfree(grinfo);
 		}
 		num_meta_group_infos = (sbi->s_groups_count +
 				EXT4_DESC_PER_BLOCK(sb) - 1) >>
@@ -3024,7 +3034,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	max = EXT4_BLOCKS_PER_GROUP(ac->ac_sb) - 1 - 1 -
 				EXT4_SB(ac->ac_sb)->s_itb_per_group;
 
-#define NRL_CHECK_SIZE(req,size,max,bits)	\
+#define NRL_CHECK_SIZE(req, size, max,bits)	\
 		(req <= (size) || max <= ((size) >> bits))
 
 	/* first, try to predict filesize */
@@ -3052,7 +3062,8 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		start = ac->ac_o_ex.fe_logical << bsbits;
 		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
 		size = 4 * 1024 * 1024;
-	} else if(NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,(8<<20)>>bsbits,max,bsbits)){
+	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
+					(8<<20)>>bsbits, max, bsbits)) {
 		start = ac->ac_o_ex.fe_logical;
 		start = start << bsbits;
 		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
@@ -3323,7 +3334,7 @@ static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
 {
-	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
+	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct ext4_prealloc_space *pa;
 	struct list_head *cur;
 	ext4_group_t groupnr;
@@ -3350,7 +3361,8 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 		if (unlikely(len == 0))
 			continue;
 		BUG_ON(groupnr != group);
-		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group), bitmap, start, len);
+		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
+						bitmap, start, len);
 		preallocated += len;
 		count++;
 	}
@@ -3486,7 +3498,7 @@ static int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
 
 	ei = EXT4_I(ac->ac_inode);
-	grp = EXT4_GROUP_INFO(sb, ac->ac_b_ex.fe_group);
+	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
 
 	pa->pa_obj_lock = &ei->i_prealloc_lock;
 	pa->pa_inode = ac->ac_inode;
@@ -3541,7 +3553,7 @@ static int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	ext4_mb_use_group_pa(ac, pa);
 	atomic_add(pa->pa_free, &EXT4_SB(sb)->s_mb_preallocated);
 
-	grp = EXT4_GROUP_INFO(sb, ac->ac_b_ex.fe_group);
+	grp = ext4_get_group_info(sb, ac->ac_b_ex.fe_group);
 	lg = ac->ac_lg;
 	BUG_ON(lg == NULL);
 
@@ -3677,7 +3689,7 @@ static int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 					ext4_group_t group, int needed)
 {
-	struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, group);
+	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
 	struct list_head list;
@@ -3704,7 +3716,7 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	if (needed == 0)
 		needed = EXT4_BLOCKS_PER_GROUP(sb) + 1;
 
-	grp = EXT4_GROUP_INFO(sb, group);
+	grp = ext4_get_group_info(sb, group);
 	INIT_LIST_HEAD(&list);
 
 repeat:
@@ -3907,7 +3919,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			ac->ac_status, ac->ac_flags);
 	printk(KERN_ERR "EXT4-fs: orig %lu/%lu/%lu@%lu, goal %lu/%lu/%lu@%lu, "
 			"best %lu/%lu/%lu@%lu cr %d\n",
-			(unsigned long )ac->ac_o_ex.fe_group,
+			(unsigned long)ac->ac_o_ex.fe_group,
 			(unsigned long)ac->ac_o_ex.fe_start,
 			(unsigned long)ac->ac_o_ex.fe_len,
 			(unsigned long)ac->ac_o_ex.fe_logical,
@@ -3924,7 +3936,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 		ac->ac_found);
 	printk(KERN_ERR "EXT4-fs: groups: \n");
 	for (i = 0; i < EXT4_SB(sb)->s_groups_count; i++) {
-		struct ext4_group_info *grp = EXT4_GROUP_INFO(sb, i);
+		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
 		struct ext4_prealloc_space *pa;
 		ext4_grpblk_t start;
 		struct list_head *cur;
@@ -3935,7 +3947,8 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 						     NULL, &start);
 			spin_unlock(&pa->pa_lock);
-			printk(KERN_ERR "PA:%lu:%d:%u \n", i, start, pa->pa_len);
+			printk(KERN_ERR "PA:%lu:%d:%u \n", i,
+							start, pa->pa_len);
 		}
 
 		if (grp->bb_free == 0)
@@ -4117,13 +4130,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	sbi = EXT4_SB(sb);
 
 	if (!test_opt(sb, MBALLOC)) {
-#if 0
-		static int ext4_mballoc_warning = 0;
-		if (ext4_mballoc_warning++ == 0)
-			printk(KERN_ERR "EXT4-fs: multiblock request with "
-					"mballoc disabled!\n");
-		ar->len = 1;
-#endif
 		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
 					    &(ar->len), errp);
 		return block;
@@ -4190,7 +4196,8 @@ out:
 }
 EXPORT_SYMBOL(ext4_mb_new_blocks);
 
-static void ext4_mb_poll_new_transaction(struct super_block *sb, handle_t *handle)
+static void ext4_mb_poll_new_transaction(struct super_block *sb,
+						handle_t *handle)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
@@ -4419,7 +4426,8 @@ do_more:
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext4_journal_dirty_metadata(handle, gd_bh);
-	if (!err) err = ret;
+	if (!err)
+		err = ret;
 
 	if (overflow && !err) {
 		block += count;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 0e4bffe..1d4d6e0 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -40,7 +40,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
 
 	/* Add the extent to temp inode*/
 	newext.ee_block = cpu_to_le32(lb->first_block);
-	newext.ee_len   = cpu_to_le16(lb->last_block - lb->first_block +1);
+	newext.ee_len   = cpu_to_le16(lb->last_block - lb->first_block + 1);
 	ext4_ext_store_pblock(&newext, lb->first_pblock);
 	path = ext4_ext_find_extent(inode, lb->first_block, NULL);
 
@@ -69,13 +69,16 @@ static int finish_range(handle_t *handle, struct inode *inode,
 
 	}
 
-	if (needed && (retval = ext4_journal_extend(handle, needed)) != 0) {
-		/*
-		 * IF not able to extend the journal restart the journal
-		 */
-		retval = ext4_journal_restart(handle, needed);
-		if (retval)
-			goto err_out;
+	if (needed) {
+		retval = ext4_journal_extend(handle, needed);
+		if (retval != 0) {
+			/*
+			 * IF not able to extend the journal restart the journal
+			 */
+			retval = ext4_journal_restart(handle, needed);
+			if (retval)
+				goto err_out;
+		}
 	}
 
 	retval = ext4_ext_insert_extent(handle, inode, path, &newext);
@@ -336,8 +339,8 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * One credit accounted for writing the
 	 * i_data field of the original inode
 	 */
-	if ((retval = ext4_journal_extend(handle, 1)) != 0) {
-
+	retval = ext4_journal_extend(handle, 1);
+	if (retval != 0) {
 		retval = ext4_journal_restart(handle, 1);
 		if (retval)
 			goto err_out;
@@ -439,7 +442,7 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 	return retval;
 
 }
-int ext4_ext_migrate(struct inode * inode, struct file * filp,
+int ext4_ext_migrate(struct inode *inode, struct file *filp,
 				unsigned int cmd, unsigned long arg)
 {
 	handle_t *handle;
@@ -503,7 +506,7 @@ int ext4_ext_migrate(struct inode * inode, struct file * filp,
 	ext4_journal_stop(handle);
 
 	ei = EXT4_I(inode);
-        i_data = ei->i_data;
+	i_data = ei->i_data;
 	memset(&lb, 0, sizeof(lb));
 
 	/* 32 bit block address 4 bytes */
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c8adca7..67b6d8a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -144,8 +144,8 @@ struct dx_map_entry
 	u16 size;
 };
 
-static inline ext4_lblk_t dx_get_block (struct dx_entry *entry);
-static void dx_set_block (struct dx_entry *entry, ext4_lblk_t value);
+static inline ext4_lblk_t dx_get_block(struct dx_entry *entry);
+static void dx_set_block(struct dx_entry *entry, ext4_lblk_t value);
 static inline unsigned dx_get_hash (struct dx_entry *entry);
 static void dx_set_hash (struct dx_entry *entry, unsigned value);
 static unsigned dx_get_count (struct dx_entry *entries);
@@ -166,7 +166,7 @@ static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext4_dir_entry_2 *dx_move_dirents (char *from, char *to,
 		struct dx_map_entry *offsets, int count);
 static struct ext4_dir_entry_2* dx_pack_dirents (char *base, int size);
-static void dx_insert_block (struct dx_frame *frame,
+static void dx_insert_block(struct dx_frame *frame,
 					u32 hash, ext4_lblk_t block);
 static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
@@ -182,12 +182,12 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
  * Mask them off for now.
  */
 
-static inline ext4_lblk_t dx_get_block (struct dx_entry *entry)
+static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
 {
 	return le32_to_cpu(entry->block) & 0x00ffffff;
 }
 
-static inline void dx_set_block (struct dx_entry *entry, ext4_lblk_t value)
+static inline void dx_set_block(struct dx_entry *entry, ext4_lblk_t value)
 {
 	entry->block = cpu_to_le32(value);
 }
@@ -298,8 +298,8 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 	printk("%i indexed blocks...\n", count);
 	for (i = 0; i < count; i++, entries++)
 	{
-		ext4_lblk_t block = dx_get_block(entries),
-						hash = i? dx_get_hash(entries): 0;
+		ext4_lblk_t block = dx_get_block(entries);
+		ext4_lblk_t hash  = i ? dx_get_hash(entries): 0;
 		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
 		struct stats stats;
 		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
@@ -553,7 +553,7 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
  */
 static inline struct ext4_dir_entry_2 *ext4_next_entry(struct ext4_dir_entry_2 *p)
 {
-	return (struct ext4_dir_entry_2 *)((char*)p +
+	return (struct ext4_dir_entry_2 *)((char *)p +
 		ext4_rec_len_from_disk(p->rec_len));
 }
 
@@ -571,7 +571,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	struct ext4_dir_entry_2 *de, *top;
 	int err, count = 0;
 
-	dxtrace(printk("In htree dirblock_to_tree: block %lu\n",
+	dxtrace(printk(KERN_INFO "In htree dirblock_to_tree: block %lu\n",
 							(unsigned long)block));
 	if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
 		return err;
@@ -915,7 +915,8 @@ restart:
 		if (!buffer_uptodate(bh)) {
 			/* read error, skip block & hope for the best */
 			ext4_error(sb, __FUNCTION__, "reading directory #%lu "
-				   "offset %lu", dir->i_ino, (unsigned long)block);
+				   "offset %lu", dir->i_ino,
+				   (unsigned long)block);
 			brelse(bh);
 			goto next;
 		}
@@ -1221,7 +1222,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	split = count - move;
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
-	dxtrace(printk("Split block %lu at %x, %i/%i\n",
+	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
 					hash2, split, count-split));
 
@@ -1830,7 +1831,8 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	de = ext4_next_entry(de);
 	de->inode = cpu_to_le32(dir->i_ino);
-	de->rec_len = ext4_rec_len_to_disk(inode->i_sb->s_blocksize-EXT4_DIR_REC_LEN(1));
+	de->rec_len = ext4_rec_len_to_disk(inode->i_sb->s_blocksize -
+						EXT4_DIR_REC_LEN(1));
 	de->name_len = 2;
 	strcpy (de->name, "..");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0314355..3d7256e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -888,7 +888,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota, Opt_extents, Opt_noextents,Opt_i_version,
+	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
 	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 };
 
@@ -1120,11 +1120,11 @@ static int parse_options (char *options, struct super_block *sb,
 			*journal_devnum = option;
 			break;
 		case Opt_journal_checksum:
-			set_opt (sbi->s_mount_opt, JOURNAL_CHECKSUM);
+			set_opt(sbi->s_mount_opt, JOURNAL_CHECKSUM);
 			break;
 		case Opt_journal_async_commit:
-			set_opt (sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
-			set_opt (sbi->s_mount_opt, JOURNAL_CHECKSUM);
+			set_opt(sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
+			set_opt(sbi->s_mount_opt, JOURNAL_CHECKSUM);
 			break;
 		case Opt_noload:
 			set_opt (sbi->s_mount_opt, NOLOAD);
@@ -1295,7 +1295,7 @@ clear_qf_name:
 			clear_opt (sbi->s_mount_opt, EXTENTS);
 			break;
 		case Opt_i_version:
-			set_opt (sbi->s_mount_opt, I_VERSION);
+			set_opt(sbi->s_mount_opt, I_VERSION);
 			sb->s_flags |= MS_I_VERSION;
 			break;
 		case Opt_nodelalloc:
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 1eff534..2a9fde6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -66,7 +66,6 @@ EXPORT_SYMBOL(jbd2_journal_update_format);
 EXPORT_SYMBOL(jbd2_journal_check_used_features);
 EXPORT_SYMBOL(jbd2_journal_check_available_features);
 EXPORT_SYMBOL(jbd2_journal_set_features);
-EXPORT_SYMBOL(jbd2_journal_clear_features);
 EXPORT_SYMBOL(jbd2_journal_create);
 EXPORT_SYMBOL(jbd2_journal_load);
 EXPORT_SYMBOL(jbd2_journal_destroy);
@@ -1606,6 +1605,7 @@ int jbd2_journal_clear_features(journal_t *journal, unsigned long compat,
 
 	return 1;
 }
+EXPORT_SYMBOL(jbd2_journal_clear_features);
 
 /**
  * int jbd2_journal_update_format () - Update on-disk journal structure.
diff --git a/fs/read_write.c b/fs/read_write.c
index 3fc2cad..dfaee3f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -450,7 +450,6 @@ unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to)
 	}
 	return seg;
 }
-
 EXPORT_SYMBOL(iov_shorten);
 
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 7c7c6b5..adc16a9 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -55,27 +55,46 @@
 
 #define EXT4_MULTIBLOCK_ALLOCATOR	1
 
-#define EXT4_MB_HINT_MERGE		1	/* prefer goal again. length */
-#define EXT4_MB_HINT_RESERVED		2	/* blocks already reserved */
-#define EXT4_MB_HINT_METADATA		4	/* metadata is being allocated */
-#define EXT4_MB_HINT_FIRST		8	/* first blocks in the file */
-#define EXT4_MB_HINT_BEST		16	/* search for the best chunk */
-#define EXT4_MB_HINT_DATA		32	/* data is being allocated */
-#define EXT4_MB_HINT_NOPREALLOC		64	/* don't preallocate (for tails) */
-#define EXT4_MB_HINT_GROUP_ALLOC	128	/* allocate for locality group */
-#define EXT4_MB_HINT_GOAL_ONLY		256	/* allocate goal blocks or none */
-#define EXT4_MB_HINT_TRY_GOAL		512	/* goal is meaningful */
+/* prefer goal again. length */
+#define EXT4_MB_HINT_MERGE		1
+/* blocks already reserved */
+#define EXT4_MB_HINT_RESERVED		2
+/* metadata is being allocated */
+#define EXT4_MB_HINT_METADATA		4
+/* first blocks in the file */
+#define EXT4_MB_HINT_FIRST		8
+/* search for the best chunk */
+#define EXT4_MB_HINT_BEST		16
+/* data is being allocated */
+#define EXT4_MB_HINT_DATA		32
+/* don't preallocate (for tails) */
+#define EXT4_MB_HINT_NOPREALLOC		64
+/* allocate for locality group */
+#define EXT4_MB_HINT_GROUP_ALLOC	128
+/* allocate goal blocks or none */
+#define EXT4_MB_HINT_GOAL_ONLY		256
+/* goal is meaningful */
+#define EXT4_MB_HINT_TRY_GOAL		512
 
 struct ext4_allocation_request {
-	struct inode *inode;	/* target inode for block we're allocating */
-	ext4_lblk_t logical;	/* logical block in target inode */
-	ext4_fsblk_t goal;	/* phys. target (a hint) */
-	ext4_lblk_t lleft;	/* the closest logical allocated block to the left */
-	ext4_fsblk_t pleft;	/* phys. block for ^^^ */
-	ext4_lblk_t lright;	/* the closest logical allocated block to the right */
-	ext4_fsblk_t pright;	/* phys. block for ^^^ */
-	unsigned long len;	/* how many blocks we want to allocate */
-	unsigned long flags;	/* flags. see above EXT4_MB_HINT_* */
+	/* target inode for block we're allocating */
+	struct inode *inode;
+	/* logical block in target inode */
+	ext4_lblk_t logical;
+	/* phys. target (a hint) */
+	ext4_fsblk_t goal;
+	/* the closest logical allocated block to the left */
+	ext4_lblk_t lleft;
+	/* phys. block for ^^^ */
+	ext4_fsblk_t pleft;
+	/* the closest logical allocated block to the right */
+	ext4_lblk_t lright;
+	/* phys. block for ^^^ */
+	ext4_fsblk_t pright;
+	/* how many blocks we want to allocate */
+	unsigned long len;
+	/* flags. see above EXT4_MB_HINT_* */
+	unsigned long flags;
 };
 
 /*
@@ -984,7 +1003,8 @@ extern long ext4_mb_stats;
 extern long ext4_mb_max_to_scan;
 extern int ext4_mb_init(struct super_block *, int);
 extern int ext4_mb_release(struct super_block *);
-extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *, struct ext4_allocation_request *, int *);
+extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
+				struct ext4_allocation_request *, int *);
 extern int ext4_mb_reserve_blocks(struct super_block *, int);
 extern void ext4_mb_discard_inode_preallocations(struct inode *);
 extern int __init init_ext4_mballoc(void);
@@ -996,13 +1016,14 @@ extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext4_fsblk_t blocknr);
-struct buffer_head * ext4_getblk(handle_t *, struct inode *,
+struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
-struct buffer_head * ext4_bread(handle_t *, struct inode *,
+struct buffer_head *ext4_bread(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
-	ext4_lblk_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
-	int create, int extend_disksize);
+				ext4_lblk_t iblock, unsigned long maxblocks,
+				struct buffer_head *bh_result,
+				int create, int extend_disksize);
 
 extern void ext4_read_inode (struct inode *);
 extern int  ext4_write_inode (struct inode *, int);
@@ -1027,7 +1048,7 @@ extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* migrate.c */
-extern int ext4_ext_migrate (struct inode *, struct file *, unsigned int,
+extern int ext4_ext_migrate(struct inode *, struct file *, unsigned int,
 		       unsigned long);
 /* namei.c */
 extern int ext4_orphan_add(handle_t *, struct inode *);
@@ -1121,6 +1142,19 @@ static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
 	raw_inode->i_size_high = cpu_to_le32(i_size >> 32);
 }
 
+static inline
+struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
+							ext4_group_t group)
+{
+	 struct ext4_group_info ***grp_info;
+	 long indexv, indexh;
+	 grp_info = EXT4_SB(sb)->s_group_info;
+	 indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
+	 indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
+	 return grp_info[indexv][indexh];
+}
+
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 36b9bb0..56d0ec6 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -219,7 +219,7 @@ extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_extent *);
 extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
-extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, ext4_lblk_t,
+extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
 							struct ext4_ext_path *);
 extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
 						ext4_lblk_t *, ext4_fsblk_t *);
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 3bc6583..abaae2c 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -144,9 +144,5 @@ struct ext4_sb_info {
 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
 };
-#define EXT4_GROUP_INFO(sb, group)					   \
-	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \
-				 [(group) & (EXT4_DESC_PER_BLOCK(sb) - 1)]
-
 
 #endif	/* _LINUX_EXT4_FS_SB */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 6eed2b4..a2645c2 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -162,8 +162,7 @@ typedef struct journal_header_s
 /*
  * Commit block header for storing transactional checksums:
  */
-struct commit_header
-{
+struct commit_header {
 	__be32		h_magic;
 	__be32          h_blocktype;
 	__be32          h_sequence;
