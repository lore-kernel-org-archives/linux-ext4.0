From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: ext4 kernel patches against linux-2.6.18-rc7-mm1
Date: Tue, 26 Sep 2006 18:43:47 +0200
Message-ID: <20060926164347.GA24382@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58590 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751550AbWIZQnz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 12:43:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 7C1AE19D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 18:43:51 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 20788-03 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 18:43:48 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id D3C3019D914
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 18:43:47 +0200 (CEST)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hi,

i've updated the ext4 kernel patches to 2.6.18-mm1. I've just done some
reordering/simplifications and fixed some minor bugs:

 - merge all 64bit "metadata" patches together

 - fix false-positive format warnings in balloc.c and resize.c because of
   arithmetic with 'unsigned long' variables:

   the following snippet:

	unsigned long x;
	unsigned long long long y;
	printf("%llu", x + y);
	
   triggers a warning on 64bit archs because gcc doen't
   seem to promote x + y to unsigned long long since long and long long
   have the same size and signedness. So we avoid the warning by:

	printf("%llu", (unsigned long long)(x + y));

 - fix ext4_blocks_count_set() and ext4_r_blocks_count_set() to use 64bit
   block numbers (ie ext4_fsblk_t) instead of __u32

 - coding style fixes: remove misplaced spaces, wrap some lines to 80 cols

 - fix ext4_check_descriptors() and ext4_group_add() to use 
   ext4_blocks_count() (returns full 64bit value) instead of just reading
   sbi->s_es->s_blocks_count (32bit low bits)

 - include fix for JBD2 not to use the same slab naming than JBD (fix from
   Johann Lomabardi)

 - remove unused EXT4_FREE_BLOCKS_COUNT() macro
   
 - update missing %u -> %llu replacements in resize.c

 - make 64bit ext4_super_block getters and setters inline C functions

Just to "summarize" the changes, here is attached a diff between results of
the old patch set and the updated patch set. The new patch set can be found
here:

http://www.bullopensource.org/ext4/20060926/

there are also patches for e2fsprogs-1.39 in sync with the kernel patch set;
both are tested on x86_64 with an 20TB devices.

cheers,

-- Alexandre


diff -ur verif/linux-2.6.18-mm1/fs/ext4/balloc.c linux-2.6.18-mm1/fs/ext4/balloc.c
--- verif/linux-2.6.18-mm1/fs/ext4/balloc.c	2006-09-26 19:59:00.000000000 +0200
+++ linux-2.6.18-mm1/fs/ext4/balloc.c	2006-09-26 19:49:10.000000000 +0200
@@ -554,8 +554,8 @@
 						bit + i, bitmap_bh->b_data)) {
 			jbd_unlock_bh_state(bitmap_bh);
 			ext4_error(sb, __FUNCTION__,
-				"bit already cleared for block %llu",
-				 block + i);
+				   "bit already cleared for block %llu",
+				   (ext4_fsblk_t)(block + i));
 			jbd_lock_bh_state(bitmap_bh);
 			BUFFER_TRACE(bitmap_bh, "bit already cleared");
 		} else {
diff -ur verif/linux-2.6.18-mm1/fs/ext4/resize.c linux-2.6.18-mm1/fs/ext4/resize.c
--- verif/linux-2.6.18-mm1/fs/ext4/resize.c	2006-09-26 19:59:04.000000000 +0200
+++ linux-2.6.18-mm1/fs/ext4/resize.c	2006-09-26 19:49:10.000000000 +0200
@@ -286,17 +286,6 @@
 	return err;
 }
 
-static void ext4_blocks_count_set(struct ext4_super_block *es, __u32 v)
-{
-	es->s_blocks_count = cpu_to_le32(v);
-	es->s_blocks_count_hi = cpu_to_le32(((__u64) v) >> 32);
-}
-
-static void ext4_r_blocks_count_set(struct ext4_super_block *es, __u32 v)
-{
-	es->s_r_blocks_count = cpu_to_le32(v);
-	es->s_r_blocks_count_hi = cpu_to_le32(((__u64) v) >> 32);
-}
 
 /*
  * Iterate through the groups which hold BACKUP superblock/GDT copies in an
@@ -352,12 +341,15 @@
 	int gdbackups = 0;
 
 	while ((grp = ext4_list_backups(sb, &three, &five, &seven)) < end) {
-		if (le32_to_cpu(*p++) != grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
+		if (le32_to_cpu(*p++) != 
+		    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
 			ext4_warning(sb, __FUNCTION__,
 				     "reserved GDT %llu"
 				     " missing grp %d (%llu)",
 				     blk, grp,
-				     grp * EXT4_BLOCKS_PER_GROUP(sb) + blk);
+				     grp * 
+				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) + 
+				     blk);
 			return -EINVAL;
 		}
 		if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
@@ -743,8 +735,8 @@
 		return -EPERM;
 	}
 
-	if (le32_to_cpu(es->s_blocks_count) + input->blocks_count <
-	    le32_to_cpu(es->s_blocks_count)) {
+	if (ext4_blocks_count(es) + input->blocks_count < 
+	    ext4_blocks_count(es)) {
 		ext4_warning(sb, __FUNCTION__, "blocks_count overflow\n");
 		return -EINVAL;
 	}
diff -ur verif/linux-2.6.18-mm1/fs/ext4/super.c linux-2.6.18-mm1/fs/ext4/super.c
--- verif/linux-2.6.18-mm1/fs/ext4/super.c	2006-09-26 19:59:04.000000000 +0200
+++ linux-2.6.18-mm1/fs/ext4/super.c	2006-09-26 19:49:10.000000000 +0200
@@ -62,17 +62,6 @@
 static void ext4_write_super (struct super_block * sb);
 static void ext4_write_super_lockfs(struct super_block *sb);
 
-ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
-{
-	return (ext4_fsblk_t) ((__u64)le32_to_cpu(es->s_blocks_count_hi) << 32 |
-				(__u64)le32_to_cpu(es->s_blocks_count));
-}
-
-ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es)
-{
-	return (ext4_fsblk_t) ((__u64)le32_to_cpu(es->s_r_blocks_count_hi) << 32 |
-				(__u64)le32_to_cpu(es->s_r_blocks_count));
-}
 
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
@@ -101,7 +90,7 @@
 void ext4_block_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_block_bitmap    = cpu_to_le32((u32)blk);
+	bg->bg_block_bitmap = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
 		bg->bg_block_bitmap_hi = cpu_to_le32(blk >> 32);
 }
@@ -109,7 +98,7 @@
 void ext4_inode_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_inode_bitmap    = cpu_to_le32((u32)blk);
+	bg->bg_inode_bitmap  = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
 		bg->bg_inode_bitmap_hi = cpu_to_le32(blk >> 32);
 }
@@ -117,18 +106,11 @@
 void ext4_inode_table_set(struct super_block *sb,
 			  struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_inode_table    = cpu_to_le32((u32)blk);
+	bg->bg_inode_table = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
 		bg->bg_inode_table_hi = cpu_to_le32(blk >> 32);
 }
 
-
-static void ext4_free_blocks_count_set(struct ext4_super_block *es, __u32 v)
-{
-	es->s_free_blocks_count = cpu_to_le32(v);
-	es->s_free_blocks_count_hi = cpu_to_le32(((__u64) v) >> 32);
-}
-
 /*
  * Wrappers for jbd2_journal_start/end.
  *
@@ -1261,7 +1243,7 @@
 	for (i = 0; i < sbi->s_groups_count; i++)
 	{
 		if (i == sbi->s_groups_count - 1)
-			last_block = le32_to_cpu(sbi->s_es->s_blocks_count) - 1;
+			last_block = ext4_blocks_count(sbi->s_es) - 1;
 		else
 			last_block = first_block +
 				(EXT4_BLOCKS_PER_GROUP(sb) - 1);
diff -ur verif/linux-2.6.18-mm1/fs/jbd2/journal.c linux-2.6.18-mm1/fs/jbd2/journal.c
--- verif/linux-2.6.18-mm1/fs/jbd2/journal.c	2006-09-26 19:58:58.000000000 +0200
+++ linux-2.6.18-mm1/fs/jbd2/journal.c	2006-09-26 19:49:09.000000000 +0200
@@ -1643,7 +1643,7 @@
 
 static kmem_cache_t *jbd_slab[JBD_MAX_SLABS];
 static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd_1k", "jbd_2k", "jbd_4k", NULL, "jbd_8k"
+	"jbd2_1k", "jbd2_2k", "jbd2_4k", NULL, "jbd2_8k"
 };
 
 static void jbd2_journal_destroy_jbd_slabs(void)
@@ -1714,7 +1714,7 @@
 	int retval;
 
 	J_ASSERT(jbd2_journal_head_cache == 0);
-	jbd2_journal_head_cache = kmem_cache_create("journal_head",
+	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				0,		/* flags */
@@ -2019,7 +2019,7 @@
 
 static int __init journal_init_handle_cache(void)
 {
-	jbd2_handle_cache = kmem_cache_create("journal_handle",
+	jbd2_handle_cache = kmem_cache_create("jbd2_journal_handle",
 				sizeof(handle_t),
 				0,		/* offset */
 				0,		/* flags */
diff -ur verif/linux-2.6.18-mm1/fs/jbd2/revoke.c linux-2.6.18-mm1/fs/jbd2/revoke.c
--- verif/linux-2.6.18-mm1/fs/jbd2/revoke.c	2006-09-26 19:58:58.000000000 +0200
+++ linux-2.6.18-mm1/fs/jbd2/revoke.c	2006-09-26 19:49:09.000000000 +0200
@@ -169,13 +169,13 @@
 
 int __init jbd2_journal_init_revoke_caches(void)
 {
-	jbd2_revoke_record_cache = kmem_cache_create("revoke_record",
+	jbd2_revoke_record_cache = kmem_cache_create("jbd2_revoke_record",
 					   sizeof(struct jbd2_revoke_record_s),
 					   0, SLAB_HWCACHE_ALIGN, NULL, NULL);
 	if (jbd2_revoke_record_cache == 0)
 		return -ENOMEM;
 
-	jbd2_revoke_table_cache = kmem_cache_create("revoke_table",
+	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, 0, NULL, NULL);
 	if (jbd2_revoke_table_cache == 0) {
diff -ur verif/linux-2.6.18-mm1/include/linux/ext4_fs.h linux-2.6.18-mm1/include/linux/ext4_fs.h
--- verif/linux-2.6.18-mm1/include/linux/ext4_fs.h	2006-09-26 19:59:04.000000000 +0200
+++ linux-2.6.18-mm1/include/linux/ext4_fs.h	2006-09-26 19:49:10.000000000 +0200
@@ -516,10 +516,6 @@
 	__u32	s_reserved[169];	/* Padding to the end of the block */
 };
 
-#define EXT4_FREE_BLOCKS_COUNT(s)					\
-	(ext4_fsblk_t)(((__u64)le32_to_cpu((s)->s_free_blocks_count_hi) << 32) | \
-		 (__u64)le32_to_cpu((s)->s_free_blocks_count))
-
 #ifdef __KERNEL__
 static inline struct ext4_sb_info * EXT4_SB(struct super_block *sb)
 {
@@ -909,8 +905,6 @@
 extern void ext4_warning (struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern void ext4_update_dynamic_rev (struct super_block *sb);
-extern ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es);
-extern ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es);
 extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
@@ -924,6 +918,47 @@
 extern void ext4_inode_table_set(struct super_block *sb,
 				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
 
+static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
+{
+	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |
+		le32_to_cpu(es->s_blocks_count);
+}
+
+static inline ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es)
+{
+	return ((ext4_fsblk_t)le32_to_cpu(es->s_r_blocks_count_hi) << 32) |
+		le32_to_cpu(es->s_r_blocks_count);
+}
+
+static inline ext4_fsblk_t ext4_free_blocks_count(struct ext4_super_block *es)
+{
+	return ((ext4_fsblk_t)le32_to_cpu(es->s_free_blocks_count_hi) << 32) |
+		le32_to_cpu(es->s_free_blocks_count);
+}
+
+static inline void ext4_blocks_count_set(struct ext4_super_block *es,
+					 ext4_fsblk_t blk)
+{
+	es->s_blocks_count = cpu_to_le32((u32)blk);
+	es->s_blocks_count_hi = cpu_to_le32(blk >> 32);
+}
+
+static inline void ext4_free_blocks_count_set(struct ext4_super_block *es,
+					      ext4_fsblk_t blk)
+{
+	es->s_free_blocks_count = cpu_to_le32((u32)blk);
+	es->s_free_blocks_count_hi = cpu_to_le32(blk >> 32);
+}
+
+static inline void ext4_r_blocks_count_set(struct ext4_super_block *es,
+					   ext4_fsblk_t blk)
+{
+	es->s_r_blocks_count = cpu_to_le32((u32)blk);
+	es->s_r_blocks_count_hi = cpu_to_le32(blk >> 32);
+}
+
+
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
