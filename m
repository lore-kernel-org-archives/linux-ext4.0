From: Amir Goldstein <amir73il@users.sf.net>
Subject: [PATCH 1/8] e2fsprogs: Next3 on-disk format changes.
Date: Wed, 05 May 2010 21:28:49 +0300
Message-ID: <1273084136-6286-2-git-send-email-amir73il@users.sf.net>
References: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout3.netvision.net.il ([194.90.6.2]:28329 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0EESwA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:52:00 -0400
Received: from localhost.localdomain ([109.186.177.237])
 by mxout3.netvision.net.il
 (Sun Java(tm) System Messaging Server 6.3-9.01 (built Oct 22 2009; 32bit))
 with ESMTP id <0L1Y005YHLXZVNB0@mxout3.netvision.net.il> for
 linux-ext4@vger.kernel.org; Wed, 05 May 2010 21:28:06 +0300 (IDT)
In-reply-to: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 uses a few reserved fields in the Ext2 super block, group
descriptor and inode structs.
Next3 defines the following compatible features:
'big_journal' (>2GB journal), 'exclude_inode' (special exclude inode).
Next3 defines the following read-only compatible features:
'has_snapshot' (contains snaphsots), 'is_snapshot' (a snapshot image),
'fix_snapshot' and 'fix_exclude' (corrupted snapshot/exclude bitmap).

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 debugfs/set_fields.c |    8 +++++++-
 lib/e2p/feature.c    |   12 ++++++++++++
 lib/e2p/ls.c         |   11 +++++++++++
 lib/ext2fs/ext2_fs.h |   26 ++++++++++++++++++++++----
 lib/ext2fs/ext2fs.h  |    6 ++++++
 lib/ext2fs/swapfs.c  |    6 ++++++
 6 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 88cf411..036f22c 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -113,6 +113,11 @@ static struct field_set_info super_fields[] = {
 	{ "journal_inum", &set_sb.s_journal_inum, 4, parse_uint },
 	{ "journal_dev", &set_sb.s_journal_dev, 4, parse_uint },
 	{ "last_orphan", &set_sb.s_last_orphan, 4, parse_uint },
+	{ "snapshot_inum", &set_sb.s_snapshot_inum, 4, parse_uint },
+	{ "snapshot_id", &set_sb.s_snapshot_id, 4, parse_uint },
+	{ "snapshot_r_blocks_count", &set_sb.s_snapshot_r_blocks_count,
+		4, parse_uint },
+	{ "snapshot_list", &set_sb.s_snapshot_list, 4, parse_uint },
 	{ "hash_seed", &set_sb.s_hash_seed, 16, parse_uuid },
 	{ "def_hash_version", &set_sb.s_def_hash_version, 1, parse_hashalg },
 	{ "jnl_backup_type", &set_sb.s_jnl_backup_type, 1, parse_uint },
@@ -183,7 +188,8 @@ static struct field_set_info ext2_bg_fields[] = {
 	{ "free_inodes_count", &set_gd.bg_free_inodes_count, 2, parse_uint },
 	{ "used_dirs_count", &set_gd.bg_used_dirs_count, 2, parse_uint },
 	{ "flags", &set_gd.bg_flags, 2, parse_uint },
-	{ "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARRAY, 2 },
+	{ "exclude_bitmap", &set_gd.bg_exclude_bitmap, 4, parse_uint },
+	{ "cow_bitmap", &set_gd.bg_cow_bitmap, 4, parse_uint },
 	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
 	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
 	{ 0, 0, 0, 0 }
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 1da3c7d..15c0546 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -29,6 +29,8 @@ static struct feature feature_list[] = {
 			"dir_prealloc" },
 	{	E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL,
 			"has_journal" },
+	{	E2P_FEATURE_COMPAT, NEXT3_FEATURE_COMPAT_BIG_JOURNAL,
+			"big_journal" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_IMAGIC_INODES,
 			"imagic_inodes" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXT_ATTR,
@@ -37,6 +39,8 @@ static struct feature feature_list[] = {
 			"dir_index" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_RESIZE_INODE,
 			"resize_inode" },
+	{	E2P_FEATURE_COMPAT, NEXT3_FEATURE_COMPAT_EXCLUDE_INODE,
+			"exclude_inode" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LAZY_BG,
 			"lazy_bg" },
 
@@ -44,6 +48,14 @@ static struct feature feature_list[] = {
 			"sparse_super" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_LARGE_FILE,
 			"large_file" },
+	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT,
+			"has_snapshot" },
+	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT,
+			"is_snapshot" },
+	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT,
+			"fix_snapshot" },
+	{	E2P_FEATURE_RO_INCOMPAT, NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE,
+			"fix_exclude" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HUGE_FILE,
 			"huge_file" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index f385fd7..eea8dc5 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -331,6 +331,17 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_last_orphan)
 		fprintf(f, "First orphan inode:       %u\n",
 			sb->s_last_orphan);
+	if (sb->s_snapshot_inum) {
+		fprintf(f, "Snapshot inode:       %u\n",
+			sb->s_snapshot_inum);
+		fprintf(f, "Snapshot ID:       %u\n",
+			sb->s_snapshot_id);
+		fprintf(f, "Snapshot reserved blocks:       %u\n",
+			sb->s_snapshot_r_blocks_count);
+	}
+	if (sb->s_snapshot_list)
+		fprintf(f, "Snapshot list first inode:       %u\n",
+			sb->s_snapshot_list);
 	if ((sb->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) ||
 	    sb->s_def_hash_version)
 		fprintf(f, "Default directory hash:   %s\n",
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 6e31c0d..35b9ac3 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -144,7 +144,8 @@ struct ext2_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;
-	__u32	bg_reserved[2];
+	__u32	bg_exclude_bitmap;	/* Exclude bitmap block */
+	__u32	bg_cow_bitmap;		/* COW bitmap block of last snapshot */
 	__u16	bg_itable_unused;	/* Unused inodes count */
 	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
 };
@@ -426,14 +427,14 @@ struct ext2_inode_large {
 #define i_dir_acl	i_size_high
 
 #if defined(__KERNEL__) || defined(__linux__)
-#define i_reserved1	osd1.linux1.l_i_reserved1
+#define i_next_snapshot	osd1.linux1.l_i_version
 #define i_frag		osd2.linux2.l_i_frag
 #define i_fsize		osd2.linux2.l_i_fsize
 #define i_uid_low	i_uid
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_snapshot_blocks	osd2.linux2.l_i_reserved2
 #else
 #if defined(__GNU__)
 
@@ -584,7 +585,14 @@ struct ext2_super_block {
 	__u8    s_reserved_char_pad;
 	__u16	s_reserved_pad;		/* Padding to next 32bits */
 	__u64	s_kbytes_written;	/* nr of lifetime kilobytes written */
-	__u32   s_reserved[160];        /* Padding to the end of the block */
+	__u32   s_reserved[156];        /* Padding to the end of the block */
+ 	/*
+ 	 * Snapshots support valid if NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT is set.
+ 	 */
+	__u32	s_snapshot_list;	/* Start of list of snapshot inodes */
+	__u32	s_snapshot_r_blocks_count; /* Reserved for active snapshot */
+	__u32	s_snapshot_id;		/* Sequential ID of active snapshot */
+	__u32	s_snapshot_inum;	/* Inode number of active snapshot */
 };
 
 /*
@@ -630,6 +638,8 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT2_FEATURE_COMPAT_DIR_INDEX		0x0020
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
+#define NEXT3_FEATURE_COMPAT_BIG_JOURNAL	0x1000 /* Has big journal */
+#define NEXT3_FEATURE_COMPAT_EXCLUDE_INODE	0x2000 /* Has exclude inode */
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -638,6 +648,10 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+#define NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x1000 /* Next3 has snapshots */
+#define NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT	0x2000 /* Is a snapshot image */
+#define NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT	0x4000 /* Corrupted snapshot */
+#define NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE	0x8000 /* Bad exclude bitmap */
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -654,6 +668,10 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
+					 NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT|\
+					 NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT|\
+					 NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE|\
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 213a819..c2d9fb9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -507,6 +507,8 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_FEATURE_COMPAT_SUPP	(EXT2_FEATURE_COMPAT_DIR_PREALLOC|\
 					 EXT2_FEATURE_COMPAT_IMAGIC_INODES|\
 					 EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
+					 NEXT3_FEATURE_COMPAT_BIG_JOURNAL|\
+					 NEXT3_FEATURE_COMPAT_EXCLUDE_INODE|\
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
 					 EXT2_FEATURE_COMPAT_EXT_ATTR)
@@ -537,6 +539,10 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
+					 NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT|\
+					 NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT|\
+					 NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE|\
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index acdb7e9..f9e224f 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -60,6 +60,10 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_journal_inum = ext2fs_swab32(sb->s_journal_inum);
 	sb->s_journal_dev = ext2fs_swab32(sb->s_journal_dev);
 	sb->s_last_orphan = ext2fs_swab32(sb->s_last_orphan);
+	sb->s_snapshot_inum = ext2fs_swab32(sb->s_snapshot_inum);
+	sb->s_snapshot_id = ext2fs_swab32(sb->s_snapshot_id);
+	sb->s_snapshot_r_blocks_count = ext2fs_swab32(sb->s_snapshot_r_blocks_count);
+	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
 	sb->s_desc_size = ext2fs_swab16(sb->s_desc_size);
 	sb->s_default_mount_opts = ext2fs_swab32(sb->s_default_mount_opts);
 	sb->s_first_meta_bg = ext2fs_swab32(sb->s_first_meta_bg);
@@ -98,6 +102,8 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 	gdp->bg_free_inodes_count = ext2fs_swab16(gdp->bg_free_inodes_count);
 	gdp->bg_used_dirs_count = ext2fs_swab16(gdp->bg_used_dirs_count);
 	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
+	gdp->bg_exclude_bitmap = ext2fs_swab32(gdp->bg_exclude_bitmap);
+	gdp->bg_cow_bitmap = ext2fs_swab32(gdp->bg_cow_bitmap);
 	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
 	/* If we're 32-bit, we're done */
-- 
1.6.6

