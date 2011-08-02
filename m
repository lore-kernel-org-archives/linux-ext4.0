From: Joe Perches <joe@perches.com>
Subject: [PATCH V2] ext4: Use current logging styles with "EXT4-fs: " prefix
Date: Tue,  2 Aug 2011 00:04:25 -0700
Message-ID: <bf4d8bd075e22d1dff35ad53c27a9794a6acb9ba.1312268536.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4449 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1HBHEf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2011 03:04:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Always use "EXT4-fs: " logging message prefix so dmesg can be more
easily grepped for EXT4 specific messages.

Add #define pr_fmt(fmt) "EXT4-fs: " fmt
Add ccflags-$(CONFIG-EXT4_FS) to always enable -DDEBUG for pr_debug.
Convert printks to pr_<level>.  Convert some bare printks to pr_cont.
Consolidate split printks used in internal ext4_<warning|error>.
Coalesce some long formats.
Convert embedded function names to "%s: ", __func__.
Neaten macro definitions that use fmt, arg...
Correct macro definition of ext4_grp_locked_error to add ino and block.
Add do {} while (0) to some macros, delete it from single lines.
Add terminating newlines to a couple of messages.
Remove terminating newline from ext4_warning use.
Correct grammar in a few messages.
Add casts to (unsigned long long) in 3 messages in xattr.c
Miscellaneous whitespace neatening.

Signed-off-by: Joe Perches <joe@perches.com>

---

Updated against Linus' commit c027a474a680
with a couple more cleanups for new changes.

 fs/ext4/Makefile         |    2 +
 fs/ext4/balloc.c         |   12 ++-
 fs/ext4/block_validity.c |   11 ++-
 fs/ext4/dir.c            |    5 +-
 fs/ext4/ext4.h           |  102 ++++++++++++-----------
 fs/ext4/extents.c        |   55 ++++++-------
 fs/ext4/ialloc.c         |   41 ++++-----
 fs/ext4/indirect.c       |    6 +-
 fs/ext4/inode.c          |   28 ++++---
 fs/ext4/mballoc.c        |   45 +++++------
 fs/ext4/mballoc.h        |   19 ++--
 fs/ext4/move_extent.c    |   24 +++---
 fs/ext4/namei.c          |   72 ++++++++--------
 fs/ext4/page-io.c        |    6 +-
 fs/ext4/resize.c         |   30 +++----
 fs/ext4/super.c          |  208 ++++++++++++++++++++++++++--------------------
 fs/ext4/xattr.c          |   47 ++++++----
 17 files changed, 380 insertions(+), 333 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 56fd8f86..617a5d8 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the linux ext4-filesystem routines.
 #
 
+ccflags-$(CONFIG_EXT4_FS) := -DDEBUG
+
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
 ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f8224ad..d683e66 100644
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
@@ -515,14 +517,14 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
 			continue;
 
 		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
-		printk(KERN_DEBUG "group %u: stored = %d, counted = %u\n",
-			i, ext4_free_blks_count(sb, gdp), x);
+		pr_debug("group %u: stored = %d, counted = %u\n",
+			 i, ext4_free_blks_count(sb, gdp), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk(KERN_DEBUG "ext4_count_free_blocks: stored = %llu"
-		", computed = %llu, %llu\n", ext4_free_blocks_count(es),
-	       desc_count, bitmap_count);
+	pr_debug("%s: stored = %llu, computed = %llu, %llu\n",
+		 __func__,
+		 ext4_free_blocks_count(es), desc_count, bitmap_count);
 	return bitmap_count;
 #else
 	desc_count = 0;
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 8efb2f0..2c5895d 100644
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
@@ -126,16 +128,17 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
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
index 164c560..90d1d20 100644
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
@@ -425,8 +427,7 @@ static int call_filldir(struct file *filp, void *dirent,
 	sb = inode->i_sb;
 
 	if (!fname) {
-		printk(KERN_ERR "EXT4-fs: call_filldir: called with "
-		       "null fname?!?\n");
+		pr_err("%s: called with null fname?!?\n", __func__);
 		return 0;
 	}
 	curr_pos = hash2pos(fname->hash, fname->minor_hash);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..ed65da8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -46,24 +46,22 @@
  * Debug code
  */
 #ifdef EXT4FS_DEBUG
-#define ext4_debug(f, a...)						\
-	do {								\
-		printk(KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __func__);			\
-		printk(KERN_DEBUG f, ## a);				\
-	} while (0)
+#define ext4_debug(fmt, args...)				\
+	pr_debug("DEBUG (%s, %d): %s: " fmt,			\
+		 __FILE__, __LINE__, __func__, ##args)
 #else
-#define ext4_debug(f, a...)	do {} while (0)
+#define ext4_debug(fmt, args...)				\
+	no_printk(fmt, ##args)
 #endif
 
-#define EXT4_ERROR_INODE(inode, fmt, a...) \
-	ext4_error_inode((inode), __func__, __LINE__, 0, (fmt), ## a)
+#define EXT4_ERROR_INODE(inode, fmt, args...)				\
+	ext4_error_inode((inode), __func__, __LINE__, 0, fmt, ##args)
 
-#define EXT4_ERROR_INODE_BLOCK(inode, block, fmt, a...)			\
-	ext4_error_inode((inode), __func__, __LINE__, (block), (fmt), ## a)
+#define EXT4_ERROR_INODE_BLOCK(inode, block, fmt, args...)		\
+	ext4_error_inode((inode), __func__, __LINE__, (block), fmt, ##args)
 
-#define EXT4_ERROR_FILE(file, block, fmt, a...)				\
-	ext4_error_file((file), __func__, __LINE__, (block), (fmt), ## a)
+#define EXT4_ERROR_FILE(file, block, fmt, args...)			\
+	ext4_error_file((file), __func__, __LINE__, (block), fmt, ##args)
 
 /* data type for block offset of block group */
 typedef int ext4_grpblk_t;
@@ -411,9 +409,14 @@ enum {
 };
 
 #define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
-#define CHECK_FLAG_VALUE(FLAG) if (!TEST_FLAG_VALUE(FLAG)) { \
-	printk(KERN_EMERG "EXT4 flag fail: " #FLAG ": %d %d\n", \
-		EXT4_##FLAG##_FL, EXT4_INODE_##FLAG); BUG_ON(1); }
+#define CHECK_FLAG_VALUE(FLAG)						\
+do {									\
+	if (!TEST_FLAG_VALUE(FLAG)) {					\
+		pr_emerg("EXT4 flag fail: " #FLAG ": %d %d\n",		\
+			 EXT4_##FLAG##_FL, EXT4_INODE_##FLAG);		\
+		BUG_ON(1);						\
+	}								\
+} while (0)
 
 /*
  * Since it's pretty easy to mix up bit numbers and hex values, and we
@@ -1877,42 +1880,45 @@ extern int ext4_group_extend(struct super_block *sb,
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
-extern void __ext4_error(struct super_block *, const char *, unsigned int,
-			 const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
-#define ext4_error(sb, message...)	__ext4_error(sb, __func__,	\
-						     __LINE__, ## message)
-extern void ext4_error_inode(struct inode *, const char *, unsigned int,
-			     ext4_fsblk_t, const char *, ...)
-	__attribute__ ((format (printf, 5, 6)));
-extern void ext4_error_file(struct file *, const char *, unsigned int,
-			    ext4_fsblk_t, const char *, ...)
-	__attribute__ ((format (printf, 5, 6)));
+
+extern __attribute__ ((format (printf, 4, 5)))
+void __ext4_error(struct super_block *, const char *func, unsigned int line,
+		  const char *fmt, ...);
+#define ext4_error(sb, fmt, args...)				\
+	__ext4_error(sb, __func__, __LINE__, fmt, ##args)
+
+extern __attribute__ ((format (printf, 5, 6)))
+void ext4_error_inode(struct inode *, const char *, unsigned int,
+		      ext4_fsblk_t, const char *fmt, ...);
+extern __attribute__ ((format (printf, 5, 6)))
+void ext4_error_file(struct file *, const char *, unsigned int,
+		     ext4_fsblk_t, const char *fmt, ...);
 extern void __ext4_std_error(struct super_block *, const char *,
 			     unsigned int, int);
-extern void __ext4_abort(struct super_block *, const char *, unsigned int,
-		       const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
-#define ext4_abort(sb, message...)	__ext4_abort(sb, __func__, \
-						       __LINE__, ## message)
-extern void __ext4_warning(struct super_block *, const char *, unsigned int,
-			  const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
-#define ext4_warning(sb, message...)	__ext4_warning(sb, __func__, \
-						       __LINE__, ## message)
-extern void ext4_msg(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __attribute__ ((format (printf, 4, 5)))
+void __ext4_abort(struct super_block *, const char *func, unsigned int line,
+		  const char *fmt, ...);
+#define ext4_abort(sb, fmt, args...)			\
+	__ext4_abort(sb, __func__, __LINE__, fmt, ##args)
+extern __attribute__ ((format (printf, 4, 5)))
+void __ext4_warning(struct super_block *, const char *func, unsigned int line,
+		    const char *fmt, ...);
+#define ext4_warning(sb, fmt, args...)				\
+	__ext4_warning(sb, __func__, __LINE__, fmt, ##args)
+extern __attribute__ ((format (printf, 3, 4)))
+void ext4_msg(struct super_block *, const char *level, const char *fmt, ...);
 extern void __dump_mmp_msg(struct super_block *, struct mmp_struct *mmp,
 			   const char *, unsigned int, const char *);
-#define dump_mmp_msg(sb, mmp, msg)	__dump_mmp_msg(sb, mmp, __func__, \
-						       __LINE__, msg)
-extern void __ext4_grp_locked_error(const char *, unsigned int, \
-				    struct super_block *, ext4_group_t, \
-				    unsigned long, ext4_fsblk_t, \
-				    const char *, ...)
-	__attribute__ ((format (printf, 7, 8)));
-#define ext4_grp_locked_error(sb, grp, message...) \
-	__ext4_grp_locked_error(__func__, __LINE__, (sb), (grp), ## message)
+#define dump_mmp_msg(sb, mmp, msg)				\
+	__dump_mmp_msg(sb, mmp, __func__, __LINE__, msg)
+extern __attribute__ ((format (printf, 7, 8)))
+void __ext4_grp_locked_error(const char *func, unsigned int line,
+			     struct super_block *, ext4_group_t grp,
+			     unsigned long ino, ext4_fsblk_t block,
+			     const char *fmt, ...);
+#define ext4_grp_locked_error(sb, grp, ino, block, fmt, args...)	\
+	__ext4_grp_locked_error(__func__, __LINE__, sb, grp, ino, block, \
+				fmt, ##args)
 extern void ext4_update_dynamic_rev(struct super_block *sb);
 extern int ext4_update_compat_feature(handle_t *handle, struct super_block *sb,
 					__u32 compat);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..5c6601a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -29,6 +29,8 @@
  *   - smart tree reduction
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
@@ -537,14 +539,14 @@ ext4_ext_binsearch_idx(struct inode *inode,
 
 		chix = ix = EXT_FIRST_INDEX(eh);
 		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++) {
-		  if (k != 0 &&
-		      le32_to_cpu(ix->ei_block) <= le32_to_cpu(ix[-1].ei_block)) {
-				printk(KERN_DEBUG "k=%d, ix=0x%p, "
-				       "first=0x%p\n", k,
-				       ix, EXT_FIRST_INDEX(eh));
-				printk(KERN_DEBUG "%u <= %u\n",
-				       le32_to_cpu(ix->ei_block),
-				       le32_to_cpu(ix[-1].ei_block));
+			if (k != 0 &&
+			    le32_to_cpu(ix->ei_block) <=
+			    le32_to_cpu(ix[-1].ei_block)) {
+				pr_debug("k=%d, ix=0x%p, first=0x%p\n",
+					 k, ix, EXT_FIRST_INDEX(eh));
+				pr_debug("%u <= %u\n",
+					 le32_to_cpu(ix->ei_block),
+					 le32_to_cpu(ix[-1].ei_block));
 			}
 			BUG_ON(k && le32_to_cpu(ix->ei_block)
 					   <= le32_to_cpu(ix[-1].ei_block));
@@ -2241,9 +2243,8 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, 0, start, num, flags);
 
 	} else {
-		printk(KERN_INFO "strange request: removal(2) "
-				"%u-%u from %u:%u\n",
-				from, to, le32_to_cpu(ex->ee_block), ee_len);
+		pr_info("strange request: removal(2) %u-%u from %u:%u\n",
+			from, to, le32_to_cpu(ex->ee_block), ee_len);
 	}
 	return 0;
 }
@@ -2653,17 +2654,17 @@ void ext4_ext_init(struct super_block *sb)
 
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
@@ -2684,11 +2685,11 @@ void ext4_ext_release(struct super_block *sb)
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
@@ -3811,10 +3812,8 @@ retry:
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
-			printk(KERN_ERR "%s: ext4_ext_map_blocks "
-				    "returned error inode#%lu, block=%u, "
-				    "max_blocks=%u", __func__,
-				    inode->i_ino, map.m_lblk, max_blocks);
+			pr_err("%s: ext4_ext_map_blocks returned error inode#%lu, block=%u, max_blocks=%u\n",
+			       __func__, inode->i_ino, map.m_lblk, max_blocks);
 #endif
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
@@ -3887,10 +3886,8 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT);
 		if (ret <= 0) {
 			WARN_ON(ret <= 0);
-			printk(KERN_ERR "%s: ext4_ext_map_blocks "
-				    "returned error inode#%lu, block=%u, "
-				    "max_blocks=%u", __func__,
-				    inode->i_ino, map.m_lblk, map.m_len);
+			pr_err("%s: ext4_ext_map_blocks returned error inode#%lu, block=%u, max_blocks=%u\n",
+			       __func__, inode->i_ino, map.m_lblk, map.m_len);
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ret2 = ext4_journal_stop(handle);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..c99d755 100644
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
@@ -195,18 +197,16 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
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
@@ -849,9 +849,8 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
 			ret2 = find_group_other(sb, dir, &group, mode);
 			if (ret2 == 0 && once) {
 				once = 0;
-				printk(KERN_NOTICE "ext4: find_group_flex "
-				       "failed, fallback succeeded dir %lu\n",
-				       dir->i_ino);
+				pr_notice("find_group_flex failed, fallback succeeded dir %lu\n",
+					  dir->i_ino);
 			}
 		}
 		goto got_group;
@@ -1144,17 +1143,15 @@ iget_failed:
 	inode = NULL;
 bad_orphan:
 	ext4_warning(sb, "bad orphan inode %lu!  e2fsck was run?", ino);
-	printk(KERN_NOTICE "ext4_test_bit(bit=%d, block=%llu) = %d\n",
+	pr_notice("ext4_test_bit(bit=%d, block=%llu) = %d\n",
 	       bit, (unsigned long long)bitmap_bh->b_blocknr,
 	       ext4_test_bit(bit, bitmap_bh->b_data));
-	printk(KERN_NOTICE "inode=%p\n", inode);
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
@@ -1190,14 +1187,14 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
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
+		 __func__, le32_to_cpu(es->s_free_inodes_count),
+		 desc_count, bitmap_count);
 	return desc_count;
 #else
 	desc_count = 0;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b8602cd..3502914 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -20,6 +20,8 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/module.h>
 #include "ext4_jbd2.h"
 #include "truncate.h"
@@ -355,8 +357,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
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
index d47264c..207cd36 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -18,6 +18,8 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
@@ -1335,18 +1337,18 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd)
 static void ext4_print_free_blocks(struct inode *inode)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	printk(KERN_CRIT "Total free blocks count %lld\n",
-	       ext4_count_free_blocks(inode->i_sb));
-	printk(KERN_CRIT "Free/Dirty block details\n");
-	printk(KERN_CRIT "free_blocks=%lld\n",
-	       (long long) percpu_counter_sum(&sbi->s_freeblocks_counter));
-	printk(KERN_CRIT "dirty_blocks=%lld\n",
-	       (long long) percpu_counter_sum(&sbi->s_dirtyblocks_counter));
-	printk(KERN_CRIT "Block reservation details\n");
-	printk(KERN_CRIT "i_reserved_data_blocks=%u\n",
-	       EXT4_I(inode)->i_reserved_data_blocks);
-	printk(KERN_CRIT "i_reserved_meta_blocks=%u\n",
-	       EXT4_I(inode)->i_reserved_meta_blocks);
+	pr_crit("Total free blocks count %lld\n",
+		ext4_count_free_blocks(inode->i_sb));
+	pr_crit("Free/Dirty block details\n");
+	pr_crit("free_blocks=%lld\n",
+		(long long) percpu_counter_sum(&sbi->s_freeblocks_counter));
+	pr_crit("dirty_blocks=%lld\n",
+		(long long) percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+	pr_crit("Block reservation details\n");
+	pr_crit("i_reserved_data_blocks=%u\n",
+		EXT4_I(inode)->i_reserved_data_blocks);
+	pr_crit("i_reserved_meta_blocks=%u\n",
+		EXT4_I(inode)->i_reserved_meta_blocks);
 	return;
 }
 
@@ -2662,7 +2664,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 		goto out;
 
 	if (!(io_end->inode->i_sb->s_flags & MS_ACTIVE)) {
-		printk("sb umounted, discard end_io request for inode %lu\n",
+		pr_info("sb umounted, discard end_io request for inode %lu\n",
 			io_end->inode->i_ino);
 		ext4_free_io_end(io_end);
 		goto out;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..522c009 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -21,6 +21,8 @@
  * mballoc.c contains the multiblocks allocation routines
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include "mballoc.h"
 #include <linux/debugfs.h>
 #include <linux/slab.h>
@@ -526,9 +528,8 @@ static inline void mb_cmp_bitmaps(struct ext4_buddy *e4b, void *bitmap)
 #define MB_CHECK_ASSERT(assert)						\
 do {									\
 	if (!(assert)) {						\
-		printk(KERN_EMERG					\
-			"Assertion failure in %s() at %s:%d: \"%s\"\n",	\
-			function, file, line, # assert);		\
+		pr_emerg("Assertion failure in %s() at %s:%d: \"%s\"\n", \
+			 function, file, line, # assert);		\
 		BUG();							\
 	}								\
 } while (0)
@@ -631,8 +632,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	return 0;
 }
 #undef MB_CHECK_ASSERT
-#define mb_check_buddy(e4b) __mb_check_buddy(e4b,	\
-					__FILE__, __func__, __LINE__)
+#define mb_check_buddy(e4b) __mb_check_buddy(e4b, __FILE__, __func__, __LINE__)
 #else
 #define mb_check_buddy(e4b)
 #endif
@@ -643,9 +643,9 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
  * Clear the bits in bitmap which the blocks of the chunk(s) covered,
  * then increase bb_counters[] for corresponded chunk size.
  */
-static void ext4_mb_mark_free_simple(struct super_block *sb,
-				void *buddy, ext4_grpblk_t first, ext4_grpblk_t len,
-					struct ext4_group_info *grp)
+static void ext4_mb_mark_free_simple(struct super_block *sb, void *buddy,
+				     ext4_grpblk_t first, ext4_grpblk_t len,
+				     struct ext4_group_info *grp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_grpblk_t min;
@@ -2081,7 +2081,7 @@ repeat:
 			 * Someone more lucky has already allocated it.
 			 * The only thing we can do is just take first
 			 * found block(s)
-			printk(KERN_DEBUG "EXT4-fs: someone won our chunk\n");
+			pr_debug("someone won our chunk\n");
 			 */
 			ac->ac_b_ex.fe_group = 0;
 			ac->ac_b_ex.fe_start = 0;
@@ -2225,8 +2225,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			EXT4_DESC_PER_BLOCK_BITS(sb);
 		meta_group_info = kmalloc(metalen, GFP_KERNEL);
 		if (meta_group_info == NULL) {
-			ext4_msg(sb, KERN_ERR, "EXT4-fs: can't allocate mem "
-				 "for a buddy group");
+			ext4_msg(sb, KERN_ERR, "can't allocate mem for a buddy group");
 			goto exit_meta_group_info;
 		}
 		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] =
@@ -2239,7 +2238,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 	meta_group_info[i] = kmem_cache_alloc(cachep, GFP_KERNEL);
 	if (meta_group_info[i] == NULL) {
-		ext4_msg(sb, KERN_ERR, "EXT4-fs: can't allocate buddy mem");
+		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
 		goto exit_group_info;
 	}
 	memset(meta_group_info[i], 0, kmem_cache_size(cachep));
@@ -2415,8 +2414,7 @@ static int ext4_groupinfo_create_slab(size_t size)
 
 	mutex_unlock(&ext4_grpinfo_slab_create_mutex);
 	if (!cachep) {
-		printk(KERN_EMERG
-		       "EXT4-fs: no memory for groupinfo slab cache\n");
+		pr_emerg("no memory for groupinfo slab cache\n");
 		return -ENOMEM;
 	}
 
@@ -3883,11 +3881,11 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	    (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED))
 		return;
 
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: Can't allocate:"
+	ext4_msg(ac->ac_sb, KERN_ERR, "Can't allocate:"
 			" Allocation context details:");
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: status %d flags %d",
+	ext4_msg(ac->ac_sb, KERN_ERR, "status %d flags %d",
 			ac->ac_status, ac->ac_flags);
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: orig %lu/%lu/%lu@%lu, "
+	ext4_msg(ac->ac_sb, KERN_ERR, "orig %lu/%lu/%lu@%lu, "
 		 	"goal %lu/%lu/%lu@%lu, "
 			"best %lu/%lu/%lu@%lu cr %d",
 			(unsigned long)ac->ac_o_ex.fe_group,
@@ -3903,9 +3901,9 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			(unsigned long)ac->ac_b_ex.fe_len,
 			(unsigned long)ac->ac_b_ex.fe_logical,
 			(int)ac->ac_criteria);
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: %lu scanned, %d found",
+	ext4_msg(ac->ac_sb, KERN_ERR, "%lu scanned, %d found",
 		 ac->ac_ex_scanned, ac->ac_found);
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: groups: ");
+	ext4_msg(ac->ac_sb, KERN_ERR, "groups: ");
 	ngroups = ext4_get_groups_count(sb);
 	for (i = 0; i < ngroups; i++) {
 		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
@@ -3920,17 +3918,14 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
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
@@ -4710,7 +4705,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	 * boundary.
 	 */
 	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
-		ext4_warning(sb, "too much blocks added to group %u\n",
+		ext4_warning(sb, "too many blocks added to group %u\n",
 			     block_group);
 		err = -EINVAL;
 		goto error_return;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 9d4a636..a065bfb 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -39,16 +39,17 @@
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
+#define mb_debug(n, fmt, args...)					\
+do {									\
+	if ((n) <= mb_enable_debug) {					\
+		pr_debug("(%s, %d): %s: " fmt,				\
+			 __FILE__, __LINE__, __func__, ##args);		\
+	}								\
+} while (0)
 #else
-#define mb_debug(n, fmt, a...)
+#define mb_debug(n, fmt, args...)					\
+	no_printk(fmt, ##args)
+
 #endif
 
 #define EXT4_MB_HISTORY_ALLOC		1	/* allocation */
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index f57455a..8c74ad4 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1027,12 +1027,12 @@ mext_check_arguments(struct inode *orig_inode,
 		/* TODO: eliminate this artificial restriction */
 		if (orig_start + *len > donor_blocks) {
 			ext4_debug("ext4 move extent: End offset [%llu] should "
-				"be less than donor file blocks [%u]."
-				"So adjust length from %llu to %llu "
-				"[ino:orig %lu, donor %lu]\n",
-				orig_start + *len, donor_blocks,
-				*len, donor_blocks - orig_start,
-				orig_inode->i_ino, donor_inode->i_ino);
+				   "be less than donor file blocks [%u]. "
+				   "So length adjusted from %llu to %llu "
+				   "[ino:orig %lu, donor %lu]\n",
+				   orig_start + *len, donor_blocks,
+				   *len, donor_blocks - orig_start,
+				   orig_inode->i_ino, donor_inode->i_ino);
 			*len = donor_blocks - orig_start;
 		}
 	} else {
@@ -1047,12 +1047,12 @@ mext_check_arguments(struct inode *orig_inode,
 		}
 
 		if (orig_start + *len > orig_blocks) {
-			ext4_debug("ext4 move extent: Adjust length "
-				"from %llu to %llu. Because it should be "
-				"less than original file blocks "
-				"[ino:orig %lu, donor %lu]\n",
-				*len, orig_blocks - orig_start,
-				orig_inode->i_ino, donor_inode->i_ino);
+			ext4_debug("ext4 move extent: Adjusted length "
+				   "from %llu to %llu because it should be "
+				   "less than original file blocks "
+				   "[ino:orig %lu, donor %lu]\n",
+				   *len, orig_blocks - orig_start,
+				   orig_inode->i_ino, donor_inode->i_ino);
 			*len = orig_blocks - orig_start;
 		}
 	}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 565a154..89db67b 100644
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
@@ -255,12 +257,12 @@ static inline unsigned dx_node_limit(struct inode *dir)
 static void dx_show_index(char * label, struct dx_entry *entries)
 {
 	int i, n = dx_get_count (entries);
-	printk(KERN_DEBUG "%s index ", label);
+	pr_debug("%s index", label);
 	for (i = 0; i < n; i++) {
-		printk("%x->%lu ", i ? dx_get_hash(entries + i) :
-				0, (unsigned long)dx_get_block(entries + i));
+		pr_cont(" %x->%lu", i ? dx_get_hash(entries + i) :
+			0, (unsigned long)dx_get_block(entries + i));
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 
 struct stats
@@ -277,7 +279,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 	char *base = (char *) de;
 	struct dx_hash_info h = *hinfo;
 
-	printk("names: ");
+	pr_info("names: ");
 	while ((char *) de < base + size)
 	{
 		if (de->inode)
@@ -286,9 +288,9 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 			{
 				int len = de->name_len;
 				char *name = de->name;
-				while (len--) printk("%c", *name++);
+				while (len--) pr_cont("%c", *name++);
 				ext4fs_dirhash(de->name, de->name_len, &h);
-				printk(":%x.%u ", h.hash,
+				pr_cont(":%x.%u ", h.hash,
 				       (unsigned) ((char *) de - base));
 			}
 			space += EXT4_DIR_REC_LEN(de->name_len);
@@ -296,7 +298,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 		}
 		de = ext4_next_entry(de, size);
 	}
-	printk("(%i)\n", names);
+	pr_cont("(%i)\n", names);
 	return (struct stats) { names, space, 1 };
 }
 
@@ -308,14 +310,14 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
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
@@ -326,9 +328,9 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
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
@@ -401,7 +403,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		goto fail;
 	}
 
-	dxtrace(printk("Look up %x", hash));
+	dxtrace(pr_debug("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
@@ -418,7 +420,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		while (p <= q)
 		{
 			m = p + (q - p)/2;
-			dxtrace(printk("."));
+			dxtrace(pr_cont("."));
 			if (dx_get_hash(m) > hash)
 				q = m - 1;
 			else
@@ -431,7 +433,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 			at = entries;
 			while (n--)
 			{
-				dxtrace(printk(","));
+				dxtrace(pr_cont(","));
 				if (dx_get_hash(++at) > hash)
 				{
 					at--;
@@ -442,7 +444,9 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		}
 
 		at = p - 1;
-		dxtrace(printk(" %x->%u\n", at == entries? 0: dx_get_hash(at), dx_get_block(at)));
+		dxtrace(pr_cont(" %x->%u\n",
+				at == entries ? 0 : dx_get_hash(at),
+				dx_get_block(at)));
 		frame->bh = bh;
 		frame->entries = entries;
 		frame->at = at;
@@ -572,8 +576,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	struct ext4_dir_entry_2 *de, *top;
 	int err, count = 0;
 
-	dxtrace(printk(KERN_INFO "In htree dirblock_to_tree: block %lu\n",
-							(unsigned long)block));
+	dxtrace(pr_info("In htree dirblock_to_tree: block %lu\n",
+			(unsigned long)block));
 	if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
 		return err;
 
@@ -630,8 +634,8 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	int ret, err;
 	__u32 hashval;
 
-	dxtrace(printk(KERN_DEBUG "In htree_fill_tree, start hash: %x:%x\n",
-		       start_hash, start_minor_hash));
+	dxtrace(pr_debug("In htree_fill_tree, start hash: %x:%x\n",
+			 start_hash, start_minor_hash));
 	dir = dir_file->f_path.dentry->d_inode;
 	if (!(ext4_test_inode_flag(dir, EXT4_INODE_INDEX))) {
 		hinfo.hash_version = EXT4_SB(dir->i_sb)->s_def_hash_version;
@@ -692,8 +696,8 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
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
@@ -891,8 +895,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		 */
 		if (bh || (err != ERR_BAD_DX_DIR))
 			return bh;
-		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
-			       "falling back\n"));
+		dxtrace(pr_debug("%s: dx failed, falling back\n", __func__));
 	}
 	nblocks = dir->i_size >> EXT4_BLOCK_SIZE_BITS(sb);
 	start = EXT4_I(dir)->i_dir_start_lookup;
@@ -1013,7 +1016,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 
 	*err = -ENOENT;
 errout:
-	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
+	dxtrace(pr_debug("%s not found\n", d_name->name));
 	dx_release (frames);
 	return NULL;
 }
@@ -1199,9 +1202,9 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
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
@@ -1350,7 +1353,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	struct fake_dirent *fde;
 
 	blocksize =  dir->i_sb->s_blocksize;
-	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
+	dxtrace(pr_debug("Creating index: inode %lu\n", dir->i_ino));
 	retval = ext4_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext4_std_error(dir->i_sb, retval);
@@ -1528,8 +1531,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		goto cleanup;
 
 	/* Block full, should compress but for now just split */
-	dxtrace(printk(KERN_DEBUG "using %u of %u node entries\n",
-		       dx_get_count(entries), dx_get_limit(entries)));
+	dxtrace(pr_debug("Using %u of %u node entries\n",
+			 dx_get_count(entries), dx_get_limit(entries)));
 	/* Need to split index? */
 	if (dx_get_count(entries) == dx_get_limit(entries)) {
 		ext4_lblk_t newblock;
@@ -1560,8 +1563,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		if (levels) {
 			unsigned icount1 = icount/2, icount2 = icount - icount1;
 			unsigned hash2 = dx_get_hash(entries + icount1);
-			dxtrace(printk(KERN_DEBUG "Split index %i/%i\n",
-				       icount1, icount2));
+			dxtrace(pr_debug("Split index %i/%i\n",
+					 icount1, icount2));
 
 			BUFFER_TRACE(frame->bh, "get_write_access"); /* index root */
 			err = ext4_journal_get_write_access(handle,
@@ -1590,8 +1593,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
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
index 430c401..a2dc191 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -6,6 +6,8 @@
  * Written by Theodore Ts'o, 2010.
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
@@ -108,7 +110,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 
 	ret = ext4_convert_unwritten_extents(inode, offset, size);
 	if (ret < 0) {
-		printk(KERN_EMERG "%s: failed to convert unwritten "
+		pr_emerg("%s: failed to convert unwritten "
 			"extents to written extents, error is %d "
 			"io is still on inode %lu aio dio list\n",
 		       __func__, ret, inode->i_ino);
@@ -179,7 +181,7 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 static void buffer_io_error(struct buffer_head *bh)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
+	pr_err("Buffer I/O error on device %s, logical block %llu\n",
 			bdevname(bh->b_bdev, b),
 			(unsigned long long)bh->b_blocknr);
 }
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 707d3f1..d0be841 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -8,6 +8,7 @@
  * This could probably be made into a module, because it is not often in use.
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
 
 #define EXT4FS_DEBUG
 
@@ -29,7 +30,7 @@ int ext4_resize_begin(struct super_block *sb)
 	 */
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		ext4_warning(sb, "There are errors in the filesystem, "
-			     "so online resizing is not allowed\n");
+			     "so online resizing is not allowed");
 		return -EPERM;
 	}
 
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
@@ -409,9 +409,8 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	int err;
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG
-		       "EXT4-fs: ext4_add_new_gdb: adding group block %lu\n",
-		       gdb_num);
+		pr_debug("ext4_add_new_gdb: adding group block %lu\n",
+			 gdb_num);
 
 	/*
 	 * If we are not using the primary superblock/GDT copy don't resize,
@@ -992,16 +991,15 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
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
@@ -1074,8 +1072,8 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 		goto exit_put;
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: extended group to %llu blocks\n",
-		       ext4_blocks_count(es));
+		pr_debug("extended group to %llu blocks\n",
+			 ext4_blocks_count(es));
 	update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (char *)es,
 		       sizeof(struct ext4_super_block));
 exit_put:
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e2d88ba..591c643 100644
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
@@ -374,7 +376,7 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
 	if (is_handle_aborted(handle))
 		return;
 
-	printk(KERN_ERR "%s:%d: aborting transaction: %s in %s\n",
+	pr_err("%s:%d: aborting transaction: %s in %s\n",
 	       caller, line, errstr, err_fn);
 
 	jbd2_journal_abort_handle(handle);
@@ -460,8 +462,8 @@ void __ext4_error(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
-	       sb->s_id, function, line, current->comm, &vaf);
+	pr_crit("error (device %s): %s:%d: comm %s: %pV\n",
+		sb->s_id, function, line, current->comm, &vaf);
 	va_end(args);
 
 	ext4_handle_error(sb);
@@ -474,18 +476,27 @@ void ext4_error_inode(struct inode *inode, const char *function,
 	va_list args;
 	struct va_format vaf;
 	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	char cblock[sizeof("block:  ") + sizeof(unsigned long long) * 3];
 
 	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
 	es->s_last_error_block = cpu_to_le64(block);
 	save_error_info(inode->i_sb, function, line);
+
+	if (block)
+		snprintf(cblock, sizeof(cblock), "block %llu: ",
+			 (unsigned long long)block);
+	else
+		cblock[0] = 0;
+
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: inode #%lu: ",
-	       inode->i_sb->s_id, function, line, inode->i_ino);
-	if (block)
-		printk(KERN_CONT "block %llu: ", block);
-	printk(KERN_CONT "comm %s: %pV\n", current->comm, &vaf);
+
+	pr_crit("error (device %s): %s:%d: inode #%lu: %scomm %s: %pV\n",
+		inode->i_sb->s_id, function, line, inode->i_ino, cblock,
+		current->comm, &vaf);
+
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
@@ -500,6 +511,7 @@ void ext4_error_file(struct file *file, const char *function,
 	struct ext4_super_block *es;
 	struct inode *inode = file->f_dentry->d_inode;
 	char pathname[80], *path;
+	char cblock[sizeof("block:  ") + sizeof(unsigned long long) * 3];
 
 	es = EXT4_SB(inode->i_sb)->s_es;
 	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
@@ -507,15 +519,22 @@ void ext4_error_file(struct file *file, const char *function,
 	path = d_path(&(file->f_path), pathname, sizeof(pathname));
 	if (IS_ERR(path))
 		path = "(unknown)";
-	printk(KERN_CRIT
-	       "EXT4-fs error (device %s): %s:%d: inode #%lu: ",
-	       inode->i_sb->s_id, function, line, inode->i_ino);
+
 	if (block)
-		printk(KERN_CONT "block %llu: ", block);
+		snprintf(cblock, sizeof(cblock), "block %llu: ",
+			 (unsigned long long)block);
+	else
+		cblock[0] = 0;
+
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CONT "comm %s: path %s: %pV\n", current->comm, path, &vaf);
+
+	pr_crit("error (device %s): %s:%d: inode #%lu: %scomm %s: path %s: %pV\n",
+		inode->i_sb->s_id, function, line, inode->i_ino,
+		cblock, current->comm, path, &vaf);
+
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
@@ -572,8 +591,8 @@ void __ext4_std_error(struct super_block *sb, const char *function,
 		return;
 
 	errstr = ext4_decode_error(sb, errno, nbuf);
-	printk(KERN_CRIT "EXT4-fs error (device %s) in %s:%d: %s\n",
-	       sb->s_id, function, line, errstr);
+	pr_crit("error (device %s) in %s:%d: %s\n",
+		sb->s_id, function, line, errstr);
 	save_error_info(sb, function, line);
 
 	ext4_handle_error(sb);
@@ -593,13 +612,18 @@ void __ext4_abort(struct super_block *sb, const char *function,
 		unsigned int line, const char *fmt, ...)
 {
 	va_list args;
+	struct va_format vaf;
 
 	save_error_info(sb, function, line);
+
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
-	       function, line);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_crit("error (device %s): %s:%d: %pV\n",
+		sb->s_id, function, line, &vaf);
+
 	va_end(args);
 
 	if ((sb->s_flags & MS_RDONLY) == 0) {
@@ -620,9 +644,12 @@ void ext4_msg(struct super_block *sb, const char *prefix, const char *fmt, ...)
 	va_list args;
 
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
+
+	printk("%s" pr_fmt("(%s): %pV\n"), prefix, sb->s_id, &vaf);
+
 	va_end(args);
 }
 
@@ -633,10 +660,13 @@ void __ext4_warning(struct super_block *sb, const char *function,
 	va_list args;
 
 	va_start(args, fmt);
+
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_WARNING "EXT4-fs warning (device %s): %s:%d: %pV\n",
-	       sb->s_id, function, line, &vaf);
+
+	pr_warn("warning (device %s): %s:%d: %pV\n",
+		sb->s_id, function, line, &vaf);
+
 	va_end(args);
 }
 
@@ -650,22 +680,32 @@ __acquires(bitlock)
 	struct va_format vaf;
 	va_list args;
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	char cblock[sizeof("block:  ") + sizeof(unsigned long long) * 3];
+	char cinode[sizeof("inode:  ") + sizeof(unsigned long) * 3];
 
 	es->s_last_error_ino = cpu_to_le32(ino);
 	es->s_last_error_block = cpu_to_le64(block);
 	__save_error_info(sb, function, line);
 
+	if (ino)
+		snprintf(cinode, sizeof(cinode), " inode %lu:", ino);
+	else
+		cinode[0] = 0;
+
+	if (block)
+		snprintf(cblock, sizeof(cblock), " block %llu:",
+			 (unsigned long long)block);
+	else
+		cblock[0] = 0;
+
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u, ",
-	       sb->s_id, function, line, grp);
-	if (ino)
-		printk(KERN_CONT "inode %lu: ", ino);
-	if (block)
-		printk(KERN_CONT "block %llu:", (unsigned long long) block);
-	printk(KERN_CONT "%pV\n", &vaf);
+
+	pr_crit("error (device %s): %s:%d: group %u,%s%s %pV\n",
+		sb->s_id, function, line, grp, cinode, cblock, &vaf);
+
 	va_end(args);
 
 	if (test_opt(sb, ERRORS_CONT)) {
@@ -767,11 +807,10 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
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
@@ -1411,8 +1450,7 @@ static ext4_fsblk_t get_sb_block(void **data)
 	/* TODO: use simple_strtoll with >32bit ext4 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
-		printk(KERN_ERR "EXT4-fs: Invalid sb specification: %s\n",
-		       (char *) *data);
+		pr_err("Invalid sb specification: %s\n", (char *) *data);
 		return 1;
 	}
 	if (*options == ',')
@@ -1435,27 +1473,25 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 	if (sb_any_quota_loaded(sb) &&
 		!sbi->s_qf_names[qtype]) {
 		ext4_msg(sb, KERN_ERR,
-			"Cannot change journaled "
-			"quota options when quota turned on");
+			 "Cannot change journaled quota options when quota turned on");
 		return 0;
 	}
 	qname = match_strdup(args);
 	if (!qname) {
 		ext4_msg(sb, KERN_ERR,
-			"Not enough memory for storing quotafile name");
+			 "Not enough memory for storing quotafile name");
 		return 0;
 	}
 	if (sbi->s_qf_names[qtype] &&
 		strcmp(sbi->s_qf_names[qtype], qname)) {
 		ext4_msg(sb, KERN_ERR,
-			"%s quota file already specified", QTYPE2NAME(qtype));
+			 "%s quota file already specified", QTYPE2NAME(qtype));
 		kfree(qname);
 		return 0;
 	}
 	sbi->s_qf_names[qtype] = qname;
 	if (strchr(sbi->s_qf_names[qtype], '/')) {
-		ext4_msg(sb, KERN_ERR,
-			"quotafile must be on filesystem root");
+		ext4_msg(sb, KERN_ERR, "quotafile must be on filesystem root");
 		kfree(sbi->s_qf_names[qtype]);
 		sbi->s_qf_names[qtype] = NULL;
 		return 0;
@@ -1471,8 +1507,8 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 
 	if (sb_any_quota_loaded(sb) &&
 		sbi->s_qf_names[qtype]) {
-		ext4_msg(sb, KERN_ERR, "Cannot change journaled quota options"
-			" when quota turned on");
+		ext4_msg(sb, KERN_ERR,
+			 "Cannot change journaled quota options when quota turned on");
 		return 0;
 	}
 	/*
@@ -1615,7 +1651,7 @@ static int parse_options(char *options, struct super_block *sb,
 		case Opt_journal_dev:
 			if (is_remount) {
 				ext4_msg(sb, KERN_ERR,
-					"Cannot specify journal on remount");
+					 "Cannot specify journal on remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option))
@@ -1669,7 +1705,7 @@ static int parse_options(char *options, struct super_block *sb,
 			if (is_remount) {
 				if (test_opt(sb, DATA_FLAGS) != data_opt) {
 					ext4_msg(sb, KERN_ERR,
-						"Cannot change data mode on remount");
+						 "Cannot change data mode on remount");
 					return 0;
 				}
 			} else {
@@ -1712,9 +1748,8 @@ static int parse_options(char *options, struct super_block *sb,
 set_qf_format:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
-				ext4_msg(sb, KERN_ERR, "Cannot change "
-					"journaled quota options when "
-					"quota turned on");
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot change journaled quota options when quota turned on");
 				return 0;
 			}
 			sbi->s_jquota_fmt = qfmt;
@@ -1730,8 +1765,8 @@ set_qf_format:
 			break;
 		case Opt_noquota:
 			if (sb_any_quota_loaded(sb)) {
-				ext4_msg(sb, KERN_ERR, "Cannot change quota "
-					"options when quota turned on");
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot change quota options when quota turned on");
 				return 0;
 			}
 			clear_opt(sb, QUOTA);
@@ -1742,8 +1777,7 @@ set_qf_format:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
-			ext4_msg(sb, KERN_ERR,
-				"quota options not supported");
+			ext4_msg(sb, KERN_ERR, "quota options not supported");
 			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
@@ -1753,7 +1787,7 @@ set_qf_format:
 		case Opt_jqfmt_vfsv0:
 		case Opt_jqfmt_vfsv1:
 			ext4_msg(sb, KERN_ERR,
-				"journaled quota options not supported");
+				 "journaled quota options not supported");
 			break;
 		case Opt_noquota:
 			break;
@@ -1780,8 +1814,7 @@ set_qf_format:
 		case Opt_resize:
 			if (!is_remount) {
 				ext4_msg(sb, KERN_ERR,
-					"resize option only available "
-					"for remount");
+					 "resize option only available for remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option) != 0)
@@ -1832,8 +1865,7 @@ set_qf_format:
 				return 0;
 			if (option && !is_power_of_2(option)) {
 				ext4_msg(sb, KERN_ERR,
-					 "EXT4-fs: inode_readahead_blks"
-					 " must be a power of 2");
+					 "inode_readahead_blks must be a power of 2");
 				return 0;
 			}
 			sbi->s_inode_readahead_blks = option;
@@ -1968,8 +2000,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 
 	ext4_commit_super(sb, 1);
 	if (test_opt(sb, DEBUG))
-		printk(KERN_INFO "[EXT4 FS bs=%lu, gc=%u, "
-				"bpg=%lu, ipg=%lu, mo=%04x, mo2=%04x]\n",
+		pr_info("bs=%lu, gc=%u, bpg=%lu, ipg=%lu, mo=%04x, mo2=%04x\n",
 			sb->s_blocksize,
 			sbi->s_groups_count,
 			EXT4_BLOCKS_PER_GROUP(sb),
@@ -2224,16 +2255,16 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		dquot_initialize(inode);
 		if (inode->i_nlink) {
 			ext4_msg(sb, KERN_DEBUG,
-				"%s: truncating inode %lu to %lld bytes",
-				__func__, inode->i_ino, inode->i_size);
+				 "%s: truncating inode %lu to %lld bytes",
+				 __func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext4_truncate(inode);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
-				"%s: deleting unreferenced inode %lu",
-				__func__, inode->i_ino);
+				 "%s: deleting unreferenced inode %lu",
+				 __func__, inode->i_ino);
 			jbd_debug(2, "deleting unreferenced inode %lu\n",
 				  inode->i_ino);
 			nr_orphans++;
@@ -2703,32 +2734,32 @@ static void print_daily_error_info(unsigned long arg)
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
+			  (int) sizeof(es->s_first_error_func),
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
+			  (int) sizeof(es->s_last_error_func),
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
@@ -2919,9 +2950,8 @@ static int ext4_run_lazyinit_thread(void)
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
@@ -3626,7 +3656,7 @@ no_journal:
 	EXT4_SB(sb)->dio_unwritten_wq =
 		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
 	if (!EXT4_SB(sb)->dio_unwritten_wq) {
-		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
+		pr_err("failed to create DIO workqueue\n");
 		goto failed_mount_wq;
 	}
 
@@ -4863,8 +4893,7 @@ static inline void register_as_ext2(void)
 {
 	int err = register_filesystem(&ext2_fs_type);
 	if (err)
-		printk(KERN_WARNING
-		       "EXT4-fs: Unable to register as ext2 (%d)\n", err);
+		pr_warn("Unable to register as ext2 (%d)\n", err);
 }
 
 static inline void unregister_as_ext2(void)
@@ -4894,8 +4923,7 @@ static inline void register_as_ext3(void)
 {
 	int err = register_filesystem(&ext3_fs_type);
 	if (err)
-		printk(KERN_WARNING
-		       "EXT4-fs: Unable to register as ext3 (%d)\n", err);
+		pr_warn("Unable to register as ext3 (%d)\n", err);
 }
 
 static inline void unregister_as_ext3(void)
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..3264345 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -50,6 +50,8 @@
  * by the buffer lock.
  */
 
+#define pr_fmt(fmt) "EXT4-fs: " fmt
+
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -67,23 +69,27 @@
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
+# define ea_idebug(inode, fmt, args...)				\
+do {								\
+	pr_debug("inode %s:%lu: " fmt "\n",			\
+		 inode->i_sb->s_id, inode->i_ino, ##args);	\
+} while (0)
+# define ea_bdebug(bh, fmt, args...)				\
+do {								\
+	char b[BDEVNAME_SIZE];					\
+	pr_debug("block %s:%lu: " fmt "\n",			\
+		 bdevname(bh->b_bdev, b),			\
+		 (unsigned long)bh->b_blocknr, ##args);		\
+} while (0)
 #else
-# define ea_idebug(f...)
-# define ea_bdebug(f...)
+static inline __attribute__((format (printf, 2, 3)))
+void ea_idebug(const struct inode *inode, const char *fmt, ...)
+{
+}
+static inline __attribute__((format (printf, 2, 3)))
+void ea_bdebug(const struct buffer_head *bh, const char *fmt, ...)
+{
+}
 #endif
 
 static void ext4_xattr_cache_insert(struct buffer_head *);
@@ -220,7 +226,8 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	error = -ENODATA;
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
-	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
+	ea_idebug(inode, "reading block %llu",
+		  (unsigned long long)EXT4_I(inode)->i_file_acl);
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
 	if (!bh)
 		goto cleanup;
@@ -363,7 +370,8 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	error = 0;
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
-	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
+	ea_idebug(inode, "reading block %llu",
+		  (unsigned long long)EXT4_I(inode)->i_file_acl);
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
 	error = -EIO;
 	if (!bh)
@@ -828,7 +836,8 @@ inserted:
 			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
 
-			ea_idebug(inode, "creating block %d", block);
+			ea_idebug(inode, "creating block %llu",
+				  (unsigned long long)block);
 
 			new_bh = sb_getblk(sb, block);
 			if (!new_bh) {
-- 
1.7.6.131.g99019

