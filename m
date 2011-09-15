From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Thu, 15 Sep 2011 18:50:51 -0400
Message-ID: <1316127052-1890-2-git-send-email-tytso@mit.edu>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57956 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935258Ab1IOWuz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 18:50:55 -0400
In-Reply-To: <1316127052-1890-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reserve EXT4_FEATURE_RO_COMPAT_METADATA_CSUM and
EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP.  Also reserve fields in the
superblock and the inode for the checksums.  In the block group
descriptor, reserve the exclude bitmap field for the snapshot feature,
and checksums for the inode and block allocation bitmaps.

With this commit, the metadata checksum and exclude bitmap features
should have reserved all of the fields they need in ext4's on-disk
format.

This commit also fixes an a missing byte swap for s_overhead_blocks.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Amir Goldstein <amir73il@gmail.com>
---
 debugfs/set_fields.c        |    3 ++-
 e2fsck/pass1.c              |    4 ++--
 lib/e2p/feature.c           |    4 ++++
 lib/e2p/ls.c                |    4 ++++
 lib/ext2fs/ext2_fs.h        |   31 ++++++++++++++++++++++---------
 lib/ext2fs/swapfs.c         |   16 ++++++++++++++--
 lib/ext2fs/tst_inode_size.c |    3 ++-
 lib/ext2fs/tst_super_size.c |    1 +
 8 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ac6bc25..1a5ec7f 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -144,6 +144,7 @@ static struct field_set_info super_fields[] = {
 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse_uint },
 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse_uint },
 	{ "overhead_blocks", &set_sb.s_overhead_blocks, 4, parse_uint },
+	{ "checksum", &set_sb.s_checksum, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
@@ -179,6 +180,7 @@ static struct field_set_info inode_fields[] = {
 	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uint },
 	{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, parse_uint },
 	{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, parse_uint },
+	{ "checksum", &set_inode.osd2.linux2.l_i_checksum_lo, 2, parse_uint },
 	{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_uint },
 	{ "bmap", NULL, 4, parse_bmap, FLAG_ARRAY },
 	{ 0, 0, 0, 0 }
@@ -192,7 +194,6 @@ static struct field_set_info ext2_bg_fields[] = {
 	{ "free_inodes_count", &set_gd.bg_free_inodes_count, 2, parse_uint },
 	{ "used_dirs_count", &set_gd.bg_used_dirs_count, 2, parse_uint },
 	{ "flags", &set_gd.bg_flags, 2, parse_uint },
-	{ "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARRAY, 2 },
 	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
 	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
 	{ 0, 0, 0, 0 }
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index dd18ade..16ddcda 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -364,8 +364,8 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
 	printf("inode #%u, i_extra_size %d\n", pctx->ino,
 			inode->i_extra_isize);
 #endif
-	/* i_extra_isize must cover i_extra_isize + i_pad1 at least */
-	min = sizeof(inode->i_extra_isize) + sizeof(inode->i_pad1);
+	/* i_extra_isize must cover i_extra_isize + i_checksum_hi at least */
+	min = sizeof(inode->i_extra_isize) + sizeof(inode->i_checksum_hi);
 	max = EXT2_INODE_SIZE(sb) - EXT2_GOOD_OLD_INODE_SIZE;
 	/*
 	 * For now we will allow i_extra_isize to be 0, but really
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 16fba53..965fc16 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -40,6 +40,8 @@ static struct feature feature_list[] = {
 			"resize_inode" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LAZY_BG,
 			"lazy_bg" },
+	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
+			"snapshot" },
 
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
 			"sparse_super" },
@@ -59,6 +61,8 @@ static struct feature feature_list[] = {
 			"quota" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_BIGALLOC,
 			"bigalloc"},
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM,
+			"metadata_csum"},
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 0f36f40..aaacdaa 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -413,6 +413,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_grp_quota_inum)
 		fprintf(f, "Group quota inode:        %u\n",
 			sb->s_grp_quota_inum);
+
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+		fprintf(f, "Checksum:                 0x%08x\n",
+			sb->s_checksum);
 }
 
 void list_super (struct ext2_super_block * s)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 4fec5db..1c86cb2 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -142,7 +142,9 @@ struct ext2_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;
-	__u32	bg_reserved[2];
+	__u32	bg_exclude_bitmap_lo;	/* Exclude bitmap for snapshots */
+	__u16	bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
+	__u16	bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
 	__u16	bg_itable_unused;	/* Unused inodes count */
 	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
 };
@@ -159,7 +161,9 @@ struct ext4_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
-	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__u32	bg_exclude_bitmap_lo;	/* Exclude bitmap for snapshots */
+	__u16	bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
+	__u16	bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
 	__u16	bg_itable_unused;	/* Unused inodes count */
 	__u16	bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__u32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
@@ -169,7 +173,10 @@ struct ext4_group_desc
 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
 	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
-	__u32	bg_reserved2[3];
+	__u32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
+	__u16	bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
+	__u16	bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
+	__u32	bg_reserved;
 };
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
@@ -363,7 +370,8 @@ struct ext2_inode {
 			__u16	l_i_file_acl_high;
 			__u16	l_i_uid_high;	/* these 2 fields    */
 			__u16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__u16	l_i_checksum_lo;	/* crc32c(uuid+inum+inode) */
+			__u16	l_i_reserved;	/* crc32c(uuid+inum+inode) */
 		} linux2;
 		struct {
 			__u8	h_i_frag;	/* Fragment number */
@@ -410,7 +418,8 @@ struct ext2_inode_large {
 			__u16	l_i_file_acl_high;
 			__u16	l_i_uid_high;	/* these 2 fields    */
 			__u16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__u16	l_i_checksum_lo; /* crc32c(uuid+inum+inode) */
+			__u16	l_i_reserved;
 		} linux2;
 		struct {
 			__u8	h_i_frag;	/* Fragment number */
@@ -422,7 +431,7 @@ struct ext2_inode_large {
 		} hurd2;
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
-	__u16	i_pad1;
+	__u16	i_checksum_hi;	/* crc32c(uuid+inum+inode) */
 	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */
 	__u32	i_mtime_extra;	/* extra Modification time (nsec << 2 | epoch) */
 	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
@@ -441,7 +450,7 @@ struct ext2_inode_large {
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_checksum	osd2.linux2.l_i_checksum
 #else
 #if defined(__GNU__)
 
@@ -623,7 +632,8 @@ struct ext2_super_block {
 	__u32	s_usr_quota_inum;	/* inode number of user quota file */
 	__u32	s_grp_quota_inum;	/* inode number of group quota file */
 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
-	__u32   s_reserved[109];        /* Padding to the end of the block */
+	__u32	s_checksum;		/* crc32c(superblock) */
+	__u32   s_reserved[108];        /* Padding to the end of the block */
 };
 
 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
@@ -671,7 +681,9 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT2_FEATURE_COMPAT_DIR_INDEX		0x0020
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
-#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080
+/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080 not used, legacy */
+#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100
+
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -683,6 +695,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 87b1a2e..d1c4a56 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -78,6 +78,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
 	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
 	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);
+	sb->s_overhead_blocks = ext2fs_swab32(sb->s_overhead_blocks);
+	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
 
 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
@@ -106,6 +108,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 	gdp->bg_free_inodes_count = ext2fs_swab16(gdp->bg_free_inodes_count);
 	gdp->bg_used_dirs_count = ext2fs_swab16(gdp->bg_used_dirs_count);
 	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
+	gdp->bg_exclude_bitmap_lo = ext2fs_swab32(gdp->bg_exclude_bitmap_lo);
+	gdp->bg_block_bitmap_csum_lo =
+		ext2fs_swab16(gdp->bg_block_bitmap_csum_lo);
+	gdp->bg_inode_bitmap_csum_lo =
+		ext2fs_swab16(gdp->bg_inode_bitmap_csum_lo);
 	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
 	/* If we're 32-bit, we're done */
@@ -125,6 +132,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 	gdp4->bg_used_dirs_count_hi =
 		ext2fs_swab16(gdp4->bg_used_dirs_count_hi);
 	gdp4->bg_itable_unused_hi = ext2fs_swab16(gdp4->bg_itable_unused_hi);
+	gdp->bg_exclude_bitmap_hi = ext2fs_swab16(gdp->bg_exclude_bitmap_hi);
+	gdp->bg_block_bitmap_csum_hi =
+		ext2fs_swab16(gdp->bg_block_bitmap_csum_hi);
+	gdp->bg_inode_bitmap_csum_hi =
+		ext2fs_swab16(gdp->bg_inode_bitmap_csum_hi);
 }
 
 void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
@@ -244,8 +256,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		  ext2fs_swab16 (f->osd2.linux2.l_i_uid_high);
 		t->osd2.linux2.l_i_gid_high =
 		  ext2fs_swab16 (f->osd2.linux2.l_i_gid_high);
-		t->osd2.linux2.l_i_reserved2 =
-			ext2fs_swab32(f->osd2.linux2.l_i_reserved2);
+		t->osd2.linux2.l_i_checksum =
+			ext2fs_swab32(f->osd2.linux2.checksum);
 		break;
 	case EXT2_OS_HURD:
 		t->osd1.hurd1.h_i_translator =
diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
index 962f1cd..a4f6247 100644
--- a/lib/ext2fs/tst_inode_size.c
+++ b/lib/ext2fs/tst_inode_size.c
@@ -61,7 +61,8 @@ void check_structure_fields()
 	check_field(osd2.linux2.l_i_file_acl_high);
 	check_field(osd2.linux2.l_i_uid_high);
 	check_field(osd2.linux2.l_i_gid_high);
-	check_field(osd2.linux2.l_i_reserved2);
+	check_field(osd2.linux2.l_i_checksum_lo);
+	check_field(osd2.linux2.l_i_reserved);
 	printf("Ending offset is %d\n\n", cur_offset);
 #endif
 }
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index 1e5a524..75659ae 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -126,6 +126,7 @@ void check_superblock_fields()
 	check_field(s_usr_quota_inum);
 	check_field(s_grp_quota_inum);
 	check_field(s_overhead_blocks);
+	check_field(s_checksum);
 	check_field(s_reserved);
 	printf("Ending offset is %d\n\n", cur_offset);
 #endif
-- 
1.7.4.1.22.gec8e1.dirty

