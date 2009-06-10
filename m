From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] allow goal inode to be specified
Date: Wed, 10 Jun 2009 14:27:02 -0600
Message-ID: <20090610202702.GI9002@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47575 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbZFJU11 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 16:27:27 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5AKRN5k028295
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 13:27:25 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KL100400HZOPZ00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 10 Jun 2009 13:27:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow a goal inode to be specified when allocating new inodes.
If the goal is within the range of valid inodes use this in
preference to one of the other target inode heuristics (Orlov or
parent directory).

The goal inode can be specified via /sys/fs/{dev}/inode_goal for
testing inode allocation beyond 2^32 blocks on very large filesystems,
and in the future will be used for large xattr inode allocation.

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: linux-stage/fs/ext4/ialloc.c
===================================================================
--- linux-stage.orig/fs/ext4/ialloc.c
+++ linux-stage/fs/ext4/ialloc.c
@@ -675,7 +675,8 @@ err_ret:
  * For other inodes, search forward from the parent directory's block
  * group to find a free inode.
  */
-struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
+struct inode *ext4_new_inode_goal(handle_t *handle, struct inode *dir,
+				  int mode, unsigned goal)
 {
 	struct super_block *sb;
 	struct buffer_head *inode_bitmap_bh = NULL;
@@ -706,6 +707,14 @@ struct inode *ext4_new_inode(handle_t *h
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
 
+	if (goal && goal < le32_to_cpu(es->s_inodes_count)) {
+		group = (goal - 1) / EXT4_INODES_PER_GROUP(sb);
+		ino = (goal - 1) % EXT4_INODES_PER_GROUP(sb);
+
+		ret2 = 0;
+		goto got_group;
+	}
+
 	if (sbi->s_log_groups_per_flex && test_opt(sb, OLDALLOC)) {
 		ret2 = find_group_flex(sb, dir, &group);
 		if (ret2 == -1) {
@@ -724,7 +733,7 @@ got_group:
 	if (ret2 == -1)
 		goto out;
 
-	for (i = 0; i < sbi->s_groups_count; i++) {
+	for (i = 0; i < sbi->s_groups_count; i++, ino = 0) {
 		err = -EIO;
 
 		gdp = ext4_get_group_desc(sb, group, &group_desc_bh);
@@ -736,8 +745,6 @@ got_group:
 		if (!inode_bitmap_bh)
 			goto fail;
 
-		ino = 0;
-
 repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 					      inode_bitmap_bh->b_data,
Index: linux-stage/fs/ext4/ext4.h
===================================================================
--- linux-stage.orig/fs/ext4/ext4.h
+++ linux-stage/fs/ext4/ext4.h
@@ -1032,7 +1032,14 @@ extern int ext4fs_dirhash(const char *na
 			  dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern struct inode * ext4_new_inode(handle_t *, struct inode *, int);
+extern struct inode *ext4_new_inode_goal(handle_t *handle, struct inode *dir,
+				    int mode, unsigned goal);
+static inline struct inode *ext4_new_inode(handle_t *handle, struct inode *dir,
+					   int mode)
+{
+	return ext4_new_inode_goal(handle, dir, mode,
+				   EXT4_SB(dir->i_sb)->s_inode_goal);
+}
 extern void ext4_free_inode(handle_t *, struct inode *);
 extern struct inode * ext4_orphan_get(struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes(struct super_block *);
Index: linux-stage/fs/ext4/super.c
===================================================================
--- linux-stage.orig/fs/ext4/super.c
+++ linux-stage/fs/ext4/super.c
@@ -2145,6 +2145,7 @@
 EXT4_RO_ATTR(lifetime_write_kbytes);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
+EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
 EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
 EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
@@ -2157,6 +2158,7 @@
 	ATTR_LIST(session_write_kbytes),
 	ATTR_LIST(lifetime_write_kbytes),
 	ATTR_LIST(inode_readahead_blks),
+	ATTR_LIST(inode_goal),
 	ATTR_LIST(mb_stats),
 	ATTR_LIST(mb_max_to_scan),
 	ATTR_LIST(mb_min_to_scan),
Index: linux-stage/fs/ext4/ext4_sb.h
===================================================================
--- linux-stage.orig/fs/ext4/ext4_sb.h
+++ linux-stage/fs/ext4/ext4_sb.h
@@ -53,6 +53,7 @@ struct ext4_sb_info {
 	int s_inode_size;
 	int s_first_ino;
 	unsigned int s_inode_readahead_blks;
+	unsigned int s_inode_goal;
 	spinlock_t s_next_gen_lock;
 	u32 s_next_generation;
 	u32 s_hash_seed[4];

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

