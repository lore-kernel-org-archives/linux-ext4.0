From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Thu, 15 Mar 2012 17:07:30 -0700
Message-ID: <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use a more current logging style.

Add pr_fmt to consistently prefix with "EXT4-fs: "
Convert printks with KERN_<LEVEL> to pr_<level>.
Convert bare printks to pr_info and pr_cont where appropriate.
Remove embedded function names from formats, use "%s: ", __func__.
Coalesce formats.
Neaten macros that contain printks/pr_<level>.
Use ##__VA_ARGS__ in those macros.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/balloc.c         |   13 +++--
 fs/ext4/block_validity.c |   11 +++--
 fs/ext4/dir.c            |    5 +-
 fs/ext4/ext4.h           |   21 ++++----
 fs/ext4/extents.c        |   50 +++++++++-----------
 fs/ext4/ialloc.c         |   40 +++++++--------
 fs/ext4/indirect.c       |    6 ++-
 fs/ext4/inode.c          |   34 +++++++------
 fs/ext4/mballoc.c        |   19 +++----
 fs/ext4/mballoc.h        |   18 ++++----
 fs/ext4/namei.c          |   74 +++++++++++++++--------------
 fs/ext4/page-io.c        |    7 ++-
 fs/ext4/resize.c         |   63 +++++++++++-------------
 fs/ext4/super.c          |  118 +++++++++++++++++++++------------------------
 fs/ext4/xattr.c          |   24 ++++------
 15 files changed, 246 insertions(+), 257 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4bbd07a..a5cd777 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -11,6 +11,8 @@
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/time.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
@@ -585,15 +587,14 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 			continue;
 
 		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
-		printk(KERN_DEBUG "group %u: stored = %d, counted = %u\n",
-			i, ext4_free_group_clusters(sb, gdp), x);
+		pr_debug("group %u: stored = %d, counted = %u\n",
+			 i, ext4_free_group_clusters(sb, gdp), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk(KERN_DEBUG "ext4_count_free_clusters: stored = %llu"
-	       ", computed = %llu, %llu\n",
-	       EXT4_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
-	       desc_count, bitmap_count);
+	pr_debug("%s: stored = %llu, computed = %llu, %llu\n",
+		 __func__, EXT4_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
+		 desc_count, bitmap_count);
 	return bitmap_count;
 #else
 	desc_count = 0;
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 3f11656..52a13cc 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -8,6 +8,8 @@
  * should never be used as data blocks by files or directories.
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
@@ -125,16 +127,17 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 	struct ext4_system_zone *entry;
 	int first = 1;
 
-	printk(KERN_INFO "System zones: ");
+	pr_info("System zones: ");
 	node = rb_first(&sbi->system_blks);
 	while (node) {
 		entry = rb_entry(node, struct ext4_system_zone, node);
-		printk("%s%llu-%llu", first ? "" : ", ",
-		       entry->start_blk, entry->start_blk + entry->count - 1);
+		pr_cont("%s%llu-%llu",
+			first ? "" : ", ",
+			entry->start_blk, entry->start_blk + entry->count - 1);
 		first = 0;
 		node = rb_next(node);
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 
 int ext4_setup_system_zone(struct super_block *sb)
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 14aa27c..3107786 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -21,6 +21,8 @@
  *
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/fs.h>
 #include <linux/jbd2.h>
 #include <linux/buffer_head.h>
@@ -522,8 +524,7 @@ static int call_filldir(struct file *filp, void *dirent,
 	sb = inode->i_sb;
 
 	if (!fname) {
-		printk(KERN_ERR "EXT4-fs: call_filldir: called with "
-		       "null fname?!?\n");
+		pr_err("%s: called with null fname?!?\n", __func__);
 		return 0;
 	}
 	curr_pos = hash2pos(filp, fname->hash, fname->minor_hash);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d0e6632..30d32e2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -46,12 +46,9 @@
  * Debug code
  */
 #ifdef EXT4FS_DEBUG
-#define ext4_debug(f, a...)						\
-	do {								\
-		printk(KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __func__);			\
-		printk(KERN_DEBUG f, ## a);				\
-	} while (0)
+#define ext4_debug(fmt, ...)						\
+	pr_debug("DEBUG (%s, %d): %s:" fmt,				\
+		 __FILE__, __LINE__, __func__, ##__VA_ARGS__)
 #else
 #define ext4_debug(f, a...)	do {} while (0)
 #endif
@@ -440,10 +437,14 @@ enum {
 };
 
 #define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
-#define CHECK_FLAG_VALUE(FLAG) if (!TEST_FLAG_VALUE(FLAG)) { \
-	printk(KERN_EMERG "EXT4 flag fail: " #FLAG ": %d %d\n", \
-		EXT4_##FLAG##_FL, EXT4_INODE_##FLAG); BUG_ON(1); }
-
+#define CHECK_FLAG_VALUE(FLAG)						\
+do {									\
+	if (!TEST_FLAG_VALUE(FLAG)) {					\
+		pr_emerg("flag fail: " #FLAG ": %d %d\n",		\
+			 EXT4_##FLAG##_FL, EXT4_INODE_##FLAG);		\
+		BUG_ON(1);						\
+	}								\
+} while (0)
 /*
  * Since it's pretty easy to mix up bit numbers and hex values, and we
  * can't do a compile-time test for ENUM values, we use a run-time
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4394a757..4ca1c7e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -29,6 +29,8 @@
  *   - smart tree reduction
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
@@ -533,12 +535,11 @@ ext4_ext_binsearch_idx(struct inode *inode,
 		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++) {
 		  if (k != 0 &&
 		      le32_to_cpu(ix->ei_block) <= le32_to_cpu(ix[-1].ei_block)) {
-				printk(KERN_DEBUG "k=%d, ix=0x%p, "
-				       "first=0x%p\n", k,
-				       ix, EXT_FIRST_INDEX(eh));
-				printk(KERN_DEBUG "%u <= %u\n",
-				       le32_to_cpu(ix->ei_block),
-				       le32_to_cpu(ix[-1].ei_block));
+				pr_debug("k=%d, ix=0x%p, first=0x%p\n",
+					 k, ix, EXT_FIRST_INDEX(eh));
+				pr_debug("%u <= %u\n",
+					 le32_to_cpu(ix->ei_block),
+					 le32_to_cpu(ix[-1].ei_block));
 			}
 			BUG_ON(k && le32_to_cpu(ix->ei_block)
 					   <= le32_to_cpu(ix[-1].ei_block));
@@ -2274,9 +2275,8 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, NULL, start, num, flags);
 
 	} else {
-		printk(KERN_INFO "strange request: removal(2) "
-				"%u-%u from %u:%u\n",
-				from, to, le32_to_cpu(ex->ee_block), ee_len);
+		pr_info("strange request: removal(2) %u-%u from %u:%u\n",
+			from, to, le32_to_cpu(ex->ee_block), ee_len);
 	}
 	return 0;
 }
@@ -2653,17 +2653,17 @@ void ext4_ext_init(struct super_block *sb)
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 #if defined(AGGRESSIVE_TEST) || defined(CHECK_BINSEARCH) || defined(EXTENTS_STATS)
-		printk(KERN_INFO "EXT4-fs: file extents enabled");
+		pr_info("file extents enabled");
 #ifdef AGGRESSIVE_TEST
-		printk(", aggressive tests");
+		pr_cont(", aggressive tests");
 #endif
 #ifdef CHECK_BINSEARCH
-		printk(", check binsearch");
+		pr_cont(", check binsearch");
 #endif
 #ifdef EXTENTS_STATS
-		printk(", stats");
+		pr_cont(", stats");
 #endif
-		printk("\n");
+		pr_cont("\n");
 #endif
 #ifdef EXTENTS_STATS
 		spin_lock_init(&EXT4_SB(sb)->s_ext_stats_lock);
@@ -2684,11 +2684,11 @@ void ext4_ext_release(struct super_block *sb)
 #ifdef EXTENTS_STATS
 	if (EXT4_SB(sb)->s_ext_blocks && EXT4_SB(sb)->s_ext_extents) {
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
-		printk(KERN_ERR "EXT4-fs: %lu blocks in %lu extents (%lu ave)\n",
-			sbi->s_ext_blocks, sbi->s_ext_extents,
-			sbi->s_ext_blocks / sbi->s_ext_extents);
-		printk(KERN_ERR "EXT4-fs: extents: %lu min, %lu max, max depth %lu\n",
-			sbi->s_ext_min, sbi->s_ext_max, sbi->s_depth_max);
+		pr_err("%lu blocks in %lu extents (%lu ave)\n",
+		       sbi->s_ext_blocks, sbi->s_ext_extents,
+		       sbi->s_ext_blocks / sbi->s_ext_extents);
+		pr_err("extents: %lu min, %lu max, max depth %lu\n",
+		       sbi->s_ext_min, sbi->s_ext_max, sbi->s_depth_max);
 	}
 #endif
 }
@@ -4362,10 +4362,8 @@ retry:
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
-			printk(KERN_ERR "%s: ext4_ext_map_blocks "
-				    "returned error inode#%lu, block=%u, "
-				    "max_blocks=%u", __func__,
-				    inode->i_ino, map.m_lblk, max_blocks);
+			pr_err("%s: ext4_map_blocks returned error inode#%lu, block=%u, max_blocks=%u\n",
+			       __func__, inode->i_ino, map.m_lblk, max_blocks);
 #endif
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
@@ -4438,10 +4436,8 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT);
 		if (ret <= 0) {
 			WARN_ON(ret <= 0);
-			printk(KERN_ERR "%s: ext4_ext_map_blocks "
-				    "returned error inode#%lu, block=%u, "
-				    "max_blocks=%u", __func__,
-				    inode->i_ino, map.m_lblk, map.m_len);
+			pr_err("%s: ext4_map_blocks returned error inode#%lu, block=%u, max_blocks=%u\n",
+			       __func__, inode->i_ino, map.m_lblk, map.m_len);
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ret2 = ext4_journal_stop(handle);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b268599..024466a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -12,6 +12,8 @@
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
@@ -205,18 +207,16 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	int fatal = 0, err, count, cleared;
 
 	if (atomic_read(&inode->i_count) > 1) {
-		printk(KERN_ERR "ext4_free_inode: inode has count=%d\n",
-		       atomic_read(&inode->i_count));
+		pr_err("%s: inode has count=%d\n",
+		       __func__, atomic_read(&inode->i_count));
 		return;
 	}
 	if (inode->i_nlink) {
-		printk(KERN_ERR "ext4_free_inode: inode has nlink=%d\n",
-		       inode->i_nlink);
+		pr_err("%s: inode has nlink=%d\n", __func__, inode->i_nlink);
 		return;
 	}
 	if (!sb) {
-		printk(KERN_ERR "ext4_free_inode: inode on "
-		       "nonexistent device\n");
+		pr_err("%s: inode on nonexistent device\n", __func__);
 		return;
 	}
 	sbi = EXT4_SB(sb);
@@ -965,17 +965,15 @@ iget_failed:
 	inode = NULL;
 bad_orphan:
 	ext4_warning(sb, "bad orphan inode %lu!  e2fsck was run?", ino);
-	printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
-	       bit, (unsigned long long)bitmap_bh->b_blocknr,
-	       ext4_test_bit(bit, bitmap_bh->b_data));
-	printk(KERN_NOTICE "inode=%p\n", inode);
+	pr_notice("ext4_test_bit(bit=%d, block=%llu) = %d\n",
+		  bit, (unsigned long long)bitmap_bh->b_blocknr,
+		  ext4_test_bit(bit, bitmap_bh->b_data));
+	pr_notice("inode=%p\n", inode);
 	if (inode) {
-		printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
-		       is_bad_inode(inode));
-		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
-		       NEXT_ORPHAN(inode));
-		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
-		printk(KERN_NOTICE "i_nlink=%u\n", inode->i_nlink);
+		pr_notice("is_bad_inode(inode)=%d\n", is_bad_inode(inode));
+		pr_notice("NEXT_ORPHAN(inode)=%u\n", NEXT_ORPHAN(inode));
+		pr_notice("max_ino=%lu\n", max_ino);
+		pr_notice("i_nlink=%u\n", inode->i_nlink);
 		/* Avoid freeing blocks if we got a bad deleted inode */
 		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
@@ -1011,14 +1009,14 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 			continue;
 
 		x = ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
-		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
-			(unsigned long) i, ext4_free_inodes_count(sb, gdp), x);
+		pr_debug("group %lu: stored = %d, counted = %lu\n",
+			 (unsigned long)i, ext4_free_inodes_count(sb, gdp), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk(KERN_DEBUG "ext4_count_free_inodes: "
-	       "stored = %u, computed = %lu, %lu\n",
-	       le32_to_cpu(es->s_free_inodes_count), desc_count, bitmap_count);
+	pr_debug("%s: stored = %u, computed = %lu, %lu\n",
+		 __func__, le32_to_cpu(es->s_free_inodes_count), desc_count,
+		 bitmap_count);
 	return desc_count;
 #else
 	desc_count = 0;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..bd02261 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -20,6 +20,8 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include "ext4_jbd2.h"
 #include "truncate.h"
 
@@ -354,8 +356,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			 * for the first direct block
 			 */
 			new_blocks[index] = current_block;
-			printk(KERN_INFO "%s returned more blocks than "
-						"requested\n", __func__);
+			pr_info("%s: returned more blocks than requested\n",
+				__func__);
 			WARN_ON(1);
 			break;
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5f8081c..c67be80 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -18,6 +18,8 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
@@ -1428,21 +1430,21 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd)
 static void ext4_print_free_blocks(struct inode *inode)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	printk(KERN_CRIT "Total free blocks count %lld\n",
-	       EXT4_C2B(EXT4_SB(inode->i_sb),
-			ext4_count_free_clusters(inode->i_sb)));
-	printk(KERN_CRIT "Free/Dirty block details\n");
-	printk(KERN_CRIT "free_blocks=%lld\n",
-	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
-		percpu_counter_sum(&sbi->s_freeclusters_counter)));
-	printk(KERN_CRIT "dirty_blocks=%lld\n",
-	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
-		percpu_counter_sum(&sbi->s_dirtyclusters_counter)));
-	printk(KERN_CRIT "Block reservation details\n");
-	printk(KERN_CRIT "i_reserved_data_blocks=%u\n",
-	       EXT4_I(inode)->i_reserved_data_blocks);
-	printk(KERN_CRIT "i_reserved_meta_blocks=%u\n",
-	       EXT4_I(inode)->i_reserved_meta_blocks);
+	pr_crit("Total free blocks count %lld\n",
+		EXT4_C2B(EXT4_SB(inode->i_sb),
+			 ext4_count_free_clusters(inode->i_sb)));
+	pr_crit("Free/Dirty block details\n");
+	pr_crit("free_blocks=%lld\n",
+		(long long)EXT4_C2B(EXT4_SB(inode->i_sb),
+				    percpu_counter_sum(&sbi->s_freeclusters_counter)));
+	pr_crit("dirty_blocks=%lld\n",
+		(long long)EXT4_C2B(EXT4_SB(inode->i_sb),
+				    percpu_counter_sum(&sbi->s_dirtyclusters_counter)));
+	pr_crit("Block reservation details\n");
+	pr_crit("i_reserved_data_blocks=%u\n",
+		EXT4_I(inode)->i_reserved_data_blocks);
+	pr_crit("i_reserved_meta_blocks=%u\n",
+		EXT4_I(inode)->i_reserved_meta_blocks);
 	return;
 }
 
@@ -2809,7 +2811,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 		goto out;
 
 	if (!(io_end->inode->i_sb->s_flags & MS_ACTIVE)) {
-		printk("sb umounted, discard end_io request for inode %lu\n",
+		pr_info("sb umounted, discard end_io request for inode %lu\n",
 			io_end->inode->i_ino);
 		ext4_free_io_end(io_end);
 		goto out;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7e6fab9..c26b600 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -21,6 +21,8 @@
  * mballoc.c contains the multiblocks allocation routines
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include "ext4_jbd2.h"
 #include "mballoc.h"
 #include <linux/debugfs.h>
@@ -529,9 +531,8 @@ static inline void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
 #define MB_CHECK_ASSERT(assert)						\
 do {									\
 	if (!(assert)) {						\
-		printk(KERN_EMERG					\
-			"Assertion failure in %s() at %s:%d: \"%s\"\n",	\
-			function, file, line, # assert);		\
+		pr_emerg("Assertion failure in %s() at %s:%d: \"%s\"\n", \
+			 function, file, line, #assert);		\
 		BUG();							\
 	}								\
 } while (0)
@@ -2033,7 +2034,7 @@ repeat:
 			 * Someone more lucky has already allocated it.
 			 * The only thing we can do is just take first
 			 * found block(s)
-			printk(KERN_DEBUG "EXT4-fs: someone won our chunk\n");
+			pr_debug("someone won our chunk\n");
 			 */
 			ac->ac_b_ex.fe_group = 0;
 			ac->ac_b_ex.fe_start = 0;
@@ -2367,8 +2368,7 @@ static int ext4_groupinfo_create_slab(size_t size)
 
 	mutex_unlock(&ext4_grpinfo_slab_create_mutex);
 	if (!cachep) {
-		printk(KERN_EMERG
-		       "EXT4-fs: no memory for groupinfo slab cache\n");
+		pr_emerg("no memory for groupinfo slab cache\n");
 		return -ENOMEM;
 	}
 
@@ -3901,17 +3901,14 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 						     NULL, &start);
 			spin_unlock(&pa->pa_lock);
-			printk(KERN_ERR "PA:%u:%d:%u \n", i,
-			       start, pa->pa_len);
+			pr_err("PA:%u:%d:%u\n", i, start, pa->pa_len);
 		}
 		ext4_unlock_group(sb, i);
 
 		if (grp->bb_free == 0)
 			continue;
-		printk(KERN_ERR "%u: %d/%d \n",
-		       i, grp->bb_free, grp->bb_fragments);
+		pr_err("%u: %d/%d\n", i, grp->bb_free, grp->bb_fragments);
 	}
-	printk(KERN_ERR "\n");
 }
 #else
 static inline void ext4_mb_show_ac(struct ext4_allocation_context *ac)
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index c070618..62bdc95 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -39,16 +39,16 @@
 #ifdef CONFIG_EXT4_DEBUG
 extern u8 mb_enable_debug;
 
-#define mb_debug(n, fmt, a...)	                                        \
-	do {								\
-		if ((n) <= mb_enable_debug) {		        	\
-			printk(KERN_DEBUG "(%s, %d): %s: ",		\
-			       __FILE__, __LINE__, __func__);		\
-			printk(fmt, ## a);				\
-		}							\
-	} while (0)
+#define mb_debug(n, fmt, ...)						\
+do {									\
+	if ((n) <= mb_enable_debug)					\
+		pr_debug("(%s, %d): %s: " fmt,				\
+			 __FILE__, __LINE__, __func__, ##__VA_ARGS__);	\
+} while (0)
 #else
-#define mb_debug(n, fmt, a...)
+#define mb_debug(n, fmt, ...)						\
+	no_printk(fmt, ##__VA_ARGS__)
+
 #endif
 
 #define EXT4_MB_HISTORY_ALLOC		1	/* allocation */
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 349d7b3..b10ee89 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -24,6 +24,8 @@
  *	Theodore Ts'o, 2002
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/jbd2.h>
@@ -255,12 +257,13 @@ static inline unsigned dx_node_limit(struct inode *dir)
 static void dx_show_index(char * label, struct dx_entry *entries)
 {
 	int i, n = dx_get_count (entries);
-	printk(KERN_DEBUG "%s index ", label);
+	pr_debug("%s index", label);
 	for (i = 0; i < n; i++) {
-		printk("%x->%lu ", i ? dx_get_hash(entries + i) :
-				0, (unsigned long)dx_get_block(entries + i));
+		pr_cont(" %x->%lu",
+			i ? dx_get_hash(entries + i) : 0,
+			(unsigned long)dx_get_block(entries + i));
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 
 struct stats
@@ -277,7 +280,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 	char *base = (char *) de;
 	struct dx_hash_info h = *hinfo;
 
-	printk("names: ");
+	pr_info("names: ");
 	while ((char *) de < base + size)
 	{
 		if (de->inode)
@@ -286,9 +289,10 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 			{
 				int len = de->name_len;
 				char *name = de->name;
-				while (len--) printk("%c", *name++);
+				while (len--)
+					pr_cont("%c", *name++);
 				ext4fs_dirhash(de->name, de->name_len, &h);
-				printk(":%x.%u ", h.hash,
+				pr_cont(":%x.%u ", h.hash,
 				       (unsigned) ((char *) de - base));
 			}
 			space += EXT4_DIR_REC_LEN(de->name_len);
@@ -296,7 +300,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 		}
 		de = ext4_next_entry(de, size);
 	}
-	printk("(%i)\n", names);
+	pr_cont("(%i)\n", names);
 	return (struct stats) { names, space, 1 };
 }
 
@@ -308,14 +312,14 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 	unsigned bcount = 0;
 	struct buffer_head *bh;
 	int err;
-	printk("%i indexed blocks...\n", count);
+	pr_info("%i indexed blocks...\n", count);
 	for (i = 0; i < count; i++, entries++)
 	{
 		ext4_lblk_t block = dx_get_block(entries);
 		ext4_lblk_t hash  = i ? dx_get_hash(entries): 0;
 		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
 		struct stats stats;
-		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
+		pr_info("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
 		if (!(bh = ext4_bread (NULL,dir, block, 0,&err))) continue;
 		stats = levels?
 		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
@@ -326,9 +330,9 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 		brelse(bh);
 	}
 	if (bcount)
-		printk(KERN_DEBUG "%snames %u, fullness %u (%u%%)\n",
-		       levels ? "" : "   ", names, space/bcount,
-		       (space/bcount)*100/blocksize);
+		pr_debug("%snames %u, fullness %u (%u%%)\n",
+			 levels ? "" : "   ", names, space/bcount,
+			 (space/bcount)*100/blocksize);
 	return (struct stats) { names, space, bcount};
 }
 #endif /* DX_DEBUG */
@@ -401,7 +405,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		goto fail;
 	}
 
-	dxtrace(printk("Look up %x", hash));
+	dxtrace(pr_debug("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
@@ -418,7 +422,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		while (p <= q)
 		{
 			m = p + (q - p)/2;
-			dxtrace(printk("."));
+			dxtrace(pr_cont("."));
 			if (dx_get_hash(m) > hash)
 				q = m - 1;
 			else
@@ -431,7 +435,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 			at = entries;
 			while (n--)
 			{
-				dxtrace(printk(","));
+				dxtrace(pr_cont(","));
 				if (dx_get_hash(++at) > hash)
 				{
 					at--;
@@ -442,7 +446,9 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		}
 
 		at = p - 1;
-		dxtrace(printk(" %x->%u\n", at == entries? 0: dx_get_hash(at), dx_get_block(at)));
+		dxtrace(pr_cont(" %x->%u\n",
+				at == entries ? 0 : dx_get_hash(at),
+				dx_get_block(at)));
 		frame->bh = bh;
 		frame->entries = entries;
 		frame->at = at;
@@ -572,8 +578,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	struct ext4_dir_entry_2 *de, *top;
 	int err, count = 0;
 
-	dxtrace(printk(KERN_INFO "In htree dirblock_to_tree: block %lu\n",
-							(unsigned long)block));
+	dxtrace(pr_info("In htree dirblock_to_tree: block %lu\n",
+			(unsigned long)block));
 	if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
 		return err;
 
@@ -630,8 +636,8 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	int ret, err;
 	__u32 hashval;
 
-	dxtrace(printk(KERN_DEBUG "In htree_fill_tree, start hash: %x:%x\n",
-		       start_hash, start_minor_hash));
+	dxtrace(pr_debug("In htree_fill_tree, start hash: %x:%x\n",
+			 start_hash, start_minor_hash));
 	dir = dir_file->f_path.dentry->d_inode;
 	if (!(ext4_test_inode_flag(dir, EXT4_INODE_INDEX))) {
 		hinfo.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
@@ -692,8 +698,8 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 			break;
 	}
 	dx_release(frames);
-	dxtrace(printk(KERN_DEBUG "Fill tree: returned %d entries, "
-		       "next hash: %x\n", count, *next_hash));
+	dxtrace(pr_debug("Fill tree: returned %d entries, next hash: %x\n",
+			 count, *next_hash));
 	return count;
 errout:
 	dx_release(frames);
@@ -891,8 +897,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		 */
 		if (bh || (err != ERR_BAD_DX_DIR))
 			return bh;
-		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
-			       "falling back\n"));
+		dxtrace(pr_debug("%s: dx failed, falling back\n", __func__));
 	}
 	nblocks = dir->i_size >> EXT4_BLOCK_SIZE_BITS(sb);
 	start = EXT4_I(dir)->i_dir_start_lookup;
@@ -1014,7 +1019,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 
 	*err = -ENOENT;
 errout:
-	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
+	dxtrace(pr_debug("%s not found\n", d_name->name));
 	dx_release (frames);
 	return NULL;
 }
@@ -1200,9 +1205,9 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	split = count - move;
 	hash2 = map[split].hash;
 	continued = hash2 == map[split - 1].hash;
-	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
+	dxtrace(pr_info("Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
-					hash2, split, count-split));
+			hash2, split, count-split));
 
 	/* Fancy dance to stay within two buffers */
 	de2 = dx_move_dirents(data1, data2, map + split, count - split, blocksize);
@@ -1351,7 +1356,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	struct fake_dirent *fde;
 
 	blocksize =  dir->i_sb->s_blocksize;
-	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
+	dxtrace(pr_debug("Creating index: inode %lu\n", dir->i_ino));
 	retval = ext4_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext4_std_error(dir->i_sb, retval);
@@ -1529,8 +1534,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		goto cleanup;
 
 	/* Block full, should compress but for now just split */
-	dxtrace(printk(KERN_DEBUG "using %u of %u node entries\n",
-		       dx_get_count(entries), dx_get_limit(entries)));
+	dxtrace(pr_debug("Using %u of %u node entries\n",
+			 dx_get_count(entries), dx_get_limit(entries)));
 	/* Need to split index? */
 	if (dx_get_count(entries) == dx_get_limit(entries)) {
 		ext4_lblk_t newblock;
@@ -1561,8 +1566,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		if (levels) {
 			unsigned icount1 = icount/2, icount2 = icount - icount1;
 			unsigned hash2 = dx_get_hash(entries + icount1);
-			dxtrace(printk(KERN_DEBUG "Split index %i/%i\n",
-				       icount1, icount2));
+			dxtrace(pr_debug("Split index %i/%i\n",
+					 icount1, icount2));
 
 			BUFFER_TRACE(frame->bh, "get_write_access"); /* index root */
 			err = ext4_journal_get_write_access(handle,
@@ -1591,8 +1596,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 				goto journal_error;
 			brelse (bh2);
 		} else {
-			dxtrace(printk(KERN_DEBUG
-				       "Creating second level index...\n"));
+			dxtrace(pr_debug("Creating second level index...\n"));
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 74cd1f7..09c9d4b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -6,6 +6,8 @@
  * Written by Theodore Ts'o, 2010.
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
@@ -186,9 +188,8 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 static void buffer_io_error(struct buffer_head *bh)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
-			bdevname(bh->b_bdev, b),
-			(unsigned long long)bh->b_blocknr);
+	pr_err("Buffer I/O error on device %s, logical block %llu\n",
+	       bdevname(bh->b_bdev, b), (unsigned long long)bh->b_blocknr);
 }
 
 static void ext4_end_bio(struct bio *bio, int error)
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3fed79d..83884e8 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -8,6 +8,7 @@
  * This could probably be made into a module, because it is not often in use.
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
 
 #define EXT4FS_DEBUG
 
@@ -69,11 +70,10 @@ static int verify_group_input(struct super_block *sb,
 		input->blocks_count - 2 - overhead - sbi->s_itb_per_group;
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: adding %s group %u: %u blocks "
-		       "(%d free, %u reserved)\n",
-		       ext4_bg_has_super(sb, input->group) ? "normal" :
-		       "no-super", input->group, input->blocks_count,
-		       free_blocks_count, input->reserved_blocks);
+		pr_debug("EXT4-fs: adding %s group %u: %u blocks (%d free, %u reserved)\n",
+			 ext4_bg_has_super(sb, input->group) ? "normal" :
+			 "no-super", input->group, input->blocks_count,
+			 free_blocks_count, input->reserved_blocks);
 
 	ext4_get_group_no_and_offset(sb, start, NULL, &offset);
 	if (group != sbi->s_groups_count)
@@ -285,17 +285,15 @@ next_group:
 		int i;
 		group = group_data[0].group;
 
-		printk(KERN_DEBUG "EXT4-fs: adding a flex group with "
-		       "%d groups, flexbg size is %d:\n", flex_gd->count,
-		       flexbg_size);
+		pr_debug("adding a flex group with %d groups, flexbg size is %d:\n",
+			 flex_gd->count, flexbg_size);
 
 		for (i = 0; i < flex_gd->count; i++) {
-			printk(KERN_DEBUG "adding %s group %u: %u "
-			       "blocks (%d free)\n",
-			       ext4_bg_has_super(sb, group + i) ? "normal" :
-			       "no-super", group + i,
-			       group_data[i].blocks_count,
-			       group_data[i].free_blocks_count);
+			pr_debug("adding %s group %u: %u blocks (%d free)\n",
+				 ext4_bg_has_super(sb, group + i) ? "normal" :
+				 "no-super", group + i,
+				 group_data[i].blocks_count,
+				 group_data[i].free_blocks_count);
 		}
 	}
 }
@@ -694,9 +692,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	int err;
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG
-		       "EXT4-fs: ext4_add_new_gdb: adding group block %lu\n",
-		       gdb_num);
+		pr_debug("%s: adding group block %lu\n", __func__, gdb_num);
 
 	/*
 	 * If we are not using the primary superblock/GDT copy don't resize,
@@ -909,9 +905,9 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	for (i = 0; i < reserved_gdb; i++) {
 		int err2;
 		data = (__le32 *)primary[i]->b_data;
-		/* printk("reserving backup %lu[%u] = %lu\n",
-		       primary[i]->b_blocknr, gdbackups,
-		       blk + primary[i]->b_blocknr); */
+		/* pr_debug("reserving backup %lu[%u] = %lu\n",
+			 primary[i]->b_blocknr, gdbackups,
+			 blk + primary[i]->b_blocknr); */
 		data[gdbackups] = cpu_to_le32(blk + primary[i]->b_blocknr);
 		err2 = ext4_handle_dirty_metadata(handle, NULL, primary[i]);
 		if (!err)
@@ -1212,9 +1208,9 @@ static void ext4_update_super(struct super_block *sb,
 	}
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: added group %u:"
-		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
-		       blocks_count, free_blocks, reserved_blocks);
+		pr_debug("added group %u:%llu blocks(%llu free %llu reserved)\n",
+			 flex_gd->count, blocks_count,
+			 free_blocks, reserved_blocks);
 }
 
 /* Add a flex group to an fs. Ensure we handle all possible error conditions
@@ -1481,8 +1477,8 @@ errout:
 
 	if (!err) {
 		if (test_opt(sb, DEBUG))
-			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
-			       "blocks\n", ext4_blocks_count(es));
+			pr_debug("extended group to %llu blocks\n",
+				 ext4_blocks_count(es));
 		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (char *)es,
 			       sizeof(struct ext4_super_block));
 	}
@@ -1512,16 +1508,15 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	o_blocks_count = ext4_blocks_count(es);
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: extending last group from %llu to %llu blocks\n",
-		       o_blocks_count, n_blocks_count);
+		pr_debug("extending last group from %llu to %llu blocks\n",
+			 o_blocks_count, n_blocks_count);
 
 	if (n_blocks_count == 0 || n_blocks_count == o_blocks_count)
 		return 0;
 
 	if (n_blocks_count > (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
-		printk(KERN_ERR "EXT4-fs: filesystem on %s:"
-			" too large to resize to %llu blocks safely\n",
-			sb->s_id, n_blocks_count);
+		pr_err("filesystem on %s: too large to resize to %llu blocks safely\n",
+		       sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
 			ext4_warning(sb, "CONFIG_LBDAF not enabled");
 		return -EINVAL;
@@ -1591,8 +1586,8 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	o_blocks_count = ext4_blocks_count(es);
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: resizing filesystem from %llu "
-		       "upto %llu blocks\n", o_blocks_count, n_blocks_count);
+		pr_debug("resizing filesystem from %llu upto %llu blocks\n",
+			 o_blocks_count, n_blocks_count);
 
 	if (n_blocks_count < o_blocks_count) {
 		/* On-line shrinking not supported */
@@ -1676,7 +1671,7 @@ out:
 
 	iput(resize_inode);
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: resized filesystem from %llu "
-		       "upto %llu blocks\n", o_blocks_count, n_blocks_count);
+		pr_debug("resized filesystem from %llu upto %llu blocks\n",
+			 o_blocks_count, n_blocks_count);
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f2c232f..4e1d656 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -16,6 +16,8 @@
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
@@ -376,7 +378,7 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
 	if (is_handle_aborted(handle))
 		return;
 
-	printk(KERN_ERR "%s:%d: aborting transaction: %s in %s\n",
+	pr_err("%s:%d: aborting transaction: %s in %s\n",
 	       caller, line, errstr, err_fn);
 
 	jbd2_journal_abort_handle(handle);
@@ -494,8 +496,8 @@ void __ext4_error(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
-	       sb->s_id, function, line, current->comm, &vaf);
+	pr_crit("error (device %s): %s:%d: comm %s: %pV\n",
+		sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
 
 	ext4_handle_error(sb);
@@ -515,11 +517,11 @@ void ext4_error_inode(struct inode *inode, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: inode #%lu: ",
-	       inode->i_sb->s_id, function, line, inode->i_ino);
+	pr_crit("error (device %s): %s:%d: inode #%lu: ",
+		inode->i_sb->s_id, function, line, inode->i_ino);
 	if (block)
-		printk(KERN_CONT "block %llu: ", block);
-	printk(KERN_CONT "comm %s: %pV\n", current->comm, &vaf);
+		pr_cont("block %llu: ", block);
+	pr_cont("comm %s: %pV\n", current->comm, &vaf);
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
@@ -541,15 +543,14 @@ void ext4_error_file(struct file *file, const char *function,
 	path = d_path(&(file->f_path), pathname, sizeof(pathname));
 	if (IS_ERR(path))
 		path = "(unknown)";
-	printk(KERN_CRIT
-	       "EXT4-fs error (device %s): %s:%d: inode #%lu: ",
-	       inode->i_sb->s_id, function, line, inode->i_ino);
+	pr_crit("error (device %s): %s:%d: inode #%lu: ",
+		inode->i_sb->s_id, function, line, inode->i_ino);
 	if (block)
-		printk(KERN_CONT "block %llu: ", block);
+		pr_cont("block %llu: ", block);
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CONT "comm %s: path %s: %pV\n", current->comm, path, &vaf);
+	pr_cont("comm %s: path %s: %pV\n", current->comm, path, &vaf);
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
@@ -606,8 +607,8 @@ void __ext4_std_error(struct super_block *sb, const char *function,
 		return;
 
 	errstr = ext4_decode_error(sb, errno, nbuf);
-	printk(KERN_CRIT "EXT4-fs error (device %s) in %s:%d: %s\n",
-	       sb->s_id, function, line, errstr);
+	pr_crit("error (device %s) in %s:%d: %s\n",
+		sb->s_id, function, line, errstr);
 	save_error_info(sb, function, line);
 
 	ext4_handle_error(sb);
@@ -630,10 +631,9 @@ void __ext4_abort(struct super_block *sb, const char *function,
 
 	save_error_info(sb, function, line);
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
-	       function, line);
+	pr_crit("error (device %s): %s:%d: ", sb->s_id, function, line);
 	vprintk(fmt, args);
-	printk("\n");
+	pr_cont("\n");
 	va_end(args);
 
 	if ((sb->s_flags & MS_RDONLY) == 0) {
@@ -656,7 +656,7 @@ void ext4_msg(struct super_block *sb, const char *prefix, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
+	printk("%s" pr_fmt("(%s): %pV\n"), prefix, sb->s_id, &vaf);
 	va_end(args);
 }
 
@@ -669,8 +669,8 @@ void __ext4_warning(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_WARNING "EXT4-fs warning (device %s): %s:%d: %pV\n",
-	       sb->s_id, function, line, &vaf);
+	pr_warn("warning (device %s): %s:%d: %pV\n",
+		sb->s_id, function, line, &vaf);
 	va_end(args);
 }
 
@@ -693,13 +693,13 @@ __acquires(bitlock)
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u, ",
-	       sb->s_id, function, line, grp);
+	pr_crit("error (device %s): %s:%d: group %u, ",
+		sb->s_id, function, line, grp);
 	if (ino)
-		printk(KERN_CONT "inode %lu: ", ino);
+		pr_cont("inode %lu: ", ino);
 	if (block)
-		printk(KERN_CONT "block %llu:", (unsigned long long) block);
-	printk(KERN_CONT "%pV\n", &vaf);
+		pr_cont("block %llu:", (unsigned long long)block);
+	pr_cont("%pV\n", &vaf);
 	va_end(args);
 
 	if (test_opt(sb, ERRORS_CONT)) {
@@ -801,11 +801,10 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 	ext4_msg(sb, KERN_ERR, "sb orphan head is %d",
 		 le32_to_cpu(sbi->s_es->s_last_orphan));
 
-	printk(KERN_ERR "sb_info orphan list:\n");
+	pr_err("sb_info orphan list:\n");
 	list_for_each(l, &sbi->s_orphan) {
 		struct inode *inode = orphan_list_entry(l);
-		printk(KERN_ERR "  "
-		       "inode %s:%lu at %p: mode %o, nlink %d, next %d\n",
+		pr_err("  inode %s:%lu at %p: mode %o, nlink %d, next %d\n",
 		       inode->i_sb->s_id, inode->i_ino, inode,
 		       inode->i_mode, inode->i_nlink,
 		       NEXT_ORPHAN(inode));
@@ -1269,8 +1268,7 @@ static ext4_fsblk_t get_sb_block(void **data)
 	/* TODO: use simple_strtoll with >32bit ext4 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
-		printk(KERN_ERR "EXT4-fs: Invalid sb specification: %s\n",
-		       (char *) *data);
+		pr_err("Invalid sb specification: %s\n", (char *)*data);
 		return 1;
 	}
 	if (*options == ',')
@@ -1840,8 +1838,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	ext4_commit_super(sb, 1);
 done:
 	if (test_opt(sb, DEBUG))
-		printk(KERN_INFO "[EXT4 FS bs=%lu, gc=%u, "
-				"bpg=%lu, ipg=%lu, mo=%04x, mo2=%04x]\n",
+		pr_info("[bs=%lu, gc=%u, bpg=%lu, ipg=%lu, mo=%04x, mo2=%04x]\n",
 			sb->s_blocksize,
 			sbi->s_groups_count,
 			EXT4_BLOCKS_PER_GROUP(sb),
@@ -2583,32 +2580,32 @@ static void print_daily_error_info(unsigned long arg)
 		ext4_msg(sb, KERN_NOTICE, "error count: %u",
 			 le32_to_cpu(es->s_error_count));
 	if (es->s_first_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): initial error at %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_first_error_time),
-		       (int) sizeof(es->s_first_error_func),
-		       es->s_first_error_func,
-		       le32_to_cpu(es->s_first_error_line));
+		pr_notice("(%s): initial error at %u: %.*s:%d",
+			  sb->s_id, le32_to_cpu(es->s_first_error_time),
+			  (int)sizeof(es->s_first_error_func),
+			  es->s_first_error_func,
+			  le32_to_cpu(es->s_first_error_line));
 		if (es->s_first_error_ino)
-			printk(": inode %u",
-			       le32_to_cpu(es->s_first_error_ino));
+			pr_cont(": inode %u",
+				le32_to_cpu(es->s_first_error_ino));
 		if (es->s_first_error_block)
-			printk(": block %llu", (unsigned long long)
-			       le64_to_cpu(es->s_first_error_block));
-		printk("\n");
+			pr_cont(": block %llu", (unsigned long long)
+				le64_to_cpu(es->s_first_error_block));
+		pr_cont("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_last_error_time),
-		       (int) sizeof(es->s_last_error_func),
-		       es->s_last_error_func,
-		       le32_to_cpu(es->s_last_error_line));
+		pr_notice("(%s): last error at %u: %.*s:%d",
+			  sb->s_id, le32_to_cpu(es->s_last_error_time),
+			  (int)sizeof(es->s_last_error_func),
+			  es->s_last_error_func,
+			  le32_to_cpu(es->s_last_error_line));
 		if (es->s_last_error_ino)
-			printk(": inode %u",
-			       le32_to_cpu(es->s_last_error_ino));
+			pr_cont(": inode %u",
+				le32_to_cpu(es->s_last_error_ino));
 		if (es->s_last_error_block)
-			printk(": block %llu", (unsigned long long)
-			       le64_to_cpu(es->s_last_error_block));
-		printk("\n");
+			pr_cont(": block %llu", (unsigned long long)
+				le64_to_cpu(es->s_last_error_block));
+		pr_cont("\n");
 	}
 	mod_timer(&sbi->s_err_report, jiffies + 24*60*60*HZ);  /* Once a day */
 }
@@ -2798,9 +2795,8 @@ static int ext4_run_lazyinit_thread(void)
 		ext4_clear_request_list();
 		kfree(ext4_li_info);
 		ext4_li_info = NULL;
-		printk(KERN_CRIT "EXT4: error %d creating inode table "
-				 "initialization thread\n",
-				 err);
+		pr_crit("error %d creating inode table initialization thread\n",
+			err);
 		return err;
 	}
 	ext4_li_info->li_state |= EXT4_LAZYINIT_RUNNING;
@@ -3101,9 +3097,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
-			    "with data=journal disables delayed "
-			    "allocation and O_DIRECT support!\n");
+		pr_warn_once("Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!\n");
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "both data=journal and delalloc");
@@ -3571,7 +3565,7 @@ no_journal:
 	EXT4_SB(sb)->dio_unwritten_wq =
 		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
 	if (!EXT4_SB(sb)->dio_unwritten_wq) {
-		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
+		pr_err("failed to create DIO workqueue\n");
 		goto failed_mount_wq;
 	}
 
@@ -4793,8 +4787,7 @@ static inline void register_as_ext2(void)
 {
 	int err = register_filesystem(&ext2_fs_type);
 	if (err)
-		printk(KERN_WARNING
-		       "EXT4-fs: Unable to register as ext2 (%d)\n", err);
+		pr_warn("Unable to register as ext2 (%d)\n", err);
 }
 
 static inline void unregister_as_ext2(void)
@@ -4824,8 +4817,7 @@ static inline void register_as_ext3(void)
 {
 	int err = register_filesystem(&ext3_fs_type);
 	if (err)
-		printk(KERN_WARNING
-		       "EXT4-fs: Unable to register as ext3 (%d)\n", err);
+		pr_warn("Unable to register as ext3 (%d)\n", err);
 }
 
 static inline void unregister_as_ext3(void)
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 3369157..a8674d2 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -67,20 +67,16 @@
 #define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
 
 #ifdef EXT4_XATTR_DEBUG
-# define ea_idebug(inode, f...) do { \
-		printk(KERN_DEBUG "inode %s:%lu: ", \
-			inode->i_sb->s_id, inode->i_ino); \
-		printk(f); \
-		printk("\n"); \
-	} while (0)
-# define ea_bdebug(bh, f...) do { \
-		char b[BDEVNAME_SIZE]; \
-		printk(KERN_DEBUG "block %s:%lu: ", \
-			bdevname(bh->b_bdev, b), \
-			(unsigned long) bh->b_blocknr); \
-		printk(f); \
-		printk("\n"); \
-	} while (0)
+# define ea_idebug(inode, fmt, ...)					\
+	pr_debug("inode %s:%lu: " fmt "\n",				\
+		 inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
+# define ea_bdebug(bh, fmt, ...)
+do {									\
+	char b[BDEVNAME_SIZE];						\
+	pr_debug("block %s:%lu: " fmt "\n",				\
+		 bdevname(bh->b_bdev, b),				\
+		 (unsigned long)bh->b_blocknr, ##__VA_ARGS__);		\
+} while (0)
 #else
 # define ea_idebug(f...)
 # define ea_bdebug(f...)
-- 
1.7.8.111.gad25c.dirty
