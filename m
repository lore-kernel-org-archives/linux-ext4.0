From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC] e2fsprogs: Rework metadata_csum/gdt_csum flag handling
Date: Tue, 28 Feb 2012 17:27:38 -0800
Message-ID: <20120229012738.GD15164@tux1.beaverton.ibm.com>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com> <20120107082919.21970.99182.stgit@elm3c44.beaverton.ibm.com> <8ED6E1F9-DB56-4D31-BCA8-2A3A8D514BD5@dilger.ca> <20120213222828.GF21641@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120213222828.GF21641@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ok, I've reworked the block group descriptor checksum handling code per this
email thread.  INCOMPAT_BG_USE_META_CSUM is gone.  METADATA_CSUM implies (and
in fact overrides) GDT_CSUM.  When both are set, the group descriptor checksum
uses the same function as all other metadata blocks' checksums (by default
crc32c).  I created a helper function to determine if group descriptor
checksums are enabled, and the actual gdt checksum verify/set functions are
smart enough to use the correct function.

Below are the changes that I intend to make to e2fsprogs.  I'll integrate these
changes into the (huge) e2fsprogs patchset, but wanted to aggregate the changes
here first to avoid overwhelming reviewers.  I'll send a kernel patch shortly.

Question: What will happen to old kernels when METADATA_CSUM and GDT_CSUM are
set?  Should tune2fs/e2fsck change METADATA_CSUM|GDT_CSUM to only METADATA_CSUM
if they encounter it?  I'm a little concerned that a pre-METADATA_CSUM kernel
will see the GDT_CSUM flag and assume it's ok to proceed in ro mode and get
confused.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 debugfs/debugfs.c        |    3 +--
 e2fsck/pass5.c           |   18 ++++++-----------
 e2fsck/super.c           |    3 +--
 e2fsck/unix.c            |    2 +-
 lib/e2p/feature.c        |    2 --
 lib/ext2fs/alloc.c       |    6 ++----
 lib/ext2fs/alloc_stats.c |    3 +--
 lib/ext2fs/csum.c        |   13 ++++--------
 lib/ext2fs/ext2_fs.h     |    6 +++++-
 lib/ext2fs/ext2fs.h      |   12 ++++++++----
 lib/ext2fs/initialize.c  |    3 +--
 lib/ext2fs/inode.c       |    9 +++------
 lib/ext2fs/openfs.c      |    3 +--
 lib/ext2fs/rw_bitmaps.c  |   12 ++++--------
 misc/dumpe2fs.c          |    4 ++--
 misc/mke2fs.c            |   23 +++++-----------------
 misc/tune2fs.c           |   48 +++-------------------------------------------
 resize/resize2fs.c       |   12 ++++--------
 18 files changed, 52 insertions(+), 130 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index c1cbf06..9c8e48e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -357,8 +357,7 @@ void do_show_super_stats(int argc, char *argv[])
 		return;
 	}
 
-	gdt_csum = EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
-					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	gdt_csum = ext2fs_has_group_desc_csum(current_fs);
 	for (i = 0; i < current_fs->group_desc_count; i++) {
 		fprintf(out, " Group %2d: block bitmap at %llu, "
 		        "inode bitmap at %llu, "
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f1ce6d7..c5dba0b 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -88,7 +88,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	int		nbytes;
 	ext2_ino_t	ino_itr;
 	errcode_t	retval;
-	int		csum_flag = 0;
+	int		csum_flag;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
 	if (ext2fs_test_ib_dirty(ctx->fs))
@@ -103,9 +103,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(ctx->fs);
 
 	clear_problem_context(&pctx);
 	for (i = 0; i < ctx->fs->group_desc_count; i++) {
@@ -149,7 +147,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 	int		nbytes;
 	blk64_t		blk_itr;
 	errcode_t	retval;
-	int		csum_flag = 0;
+	int		csum_flag;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
 	if (ext2fs_test_bb_dirty(ctx->fs))
@@ -164,9 +162,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(ctx->fs);
 
 	clear_problem_context(&pctx);
 	for (i = 0; i < ctx->fs->group_desc_count; i++) {
@@ -322,8 +318,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
@@ -599,8 +594,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index dbd337c..5f6fb08 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -583,8 +583,7 @@ void check_super_block(e2fsck_t ctx)
 	first_block = sb->s_first_data_block;
 	last_block = ext2fs_blocks_count(sb)-1;
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		pctx.group = i;
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 9319e40..d3fb8f8 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1658,7 +1658,7 @@ no_journal:
 	}
 
 	if ((run_result & E2F_FLAG_CANCEL) == 0 &&
-	    sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
+	    ext2fs_has_group_desc_csum(ctx->fs) &&
 	    !(ctx->options & E2F_OPT_READONLY)) {
 		retval = ext2fs_set_gdt_csum(ctx->fs);
 		if (retval) {
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 9f9c6dd..486f846 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -87,8 +87,6 @@ static struct feature feature_list[] = {
 			"mmp" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
 			"flex_bg"},
-	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
-			"bg_use_meta_csum"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 948a0ec..e62ed68 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -36,8 +36,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 	blk64_t		blk, super_blk, old_desc_blk, new_desc_blk;
 	int		old_desc_blocks;
 
-	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) ||
+	if (!ext2fs_has_group_desc_csum(fs) ||
 	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
 		return;
 
@@ -83,8 +82,7 @@ static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 {
 	ext2_ino_t	i, ino;
 
-	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) ||
+	if (!ext2fs_has_group_desc_csum(fs) ||
 	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT)))
 		return;
 
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index adec363..4229084 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -38,8 +38,7 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 	/* We don't strictly need to be clearing the uninit flag if inuse < 0
 	 * (i.e. freeing inodes) but it also means something is bad. */
 	ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (ext2fs_has_group_desc_csum(fs)) {
 		ext2_ino_t first_unused_inode =	fs->super->s_inodes_per_group -
 			ext2fs_bg_itable_unused(fs, group) +
 			group * fs->super->s_inodes_per_group + 1;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 99ca652..425f736 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -743,9 +743,7 @@ STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 #endif
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
-	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		/* new metadata csum code */
 		__u16 old_crc;
 		__u32 crc32;
@@ -781,8 +779,7 @@ out:
 
 int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group)
 {
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	if (ext2fs_has_group_desc_csum(fs) &&
 	    (ext2fs_bg_checksum(fs, group) !=
 	     ext2fs_group_desc_csum(fs, group)))
 		return 0;
@@ -792,8 +789,7 @@ int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group)
 
 void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group)
 {
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (!ext2fs_has_group_desc_csum(fs))
 		return;
 
 	/* ext2fs_bg_checksum_set() sets the actual checksum field but
@@ -827,8 +823,7 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 	if (!fs->inode_map)
 		return EXT2_ET_NO_INODE_BITMAP;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (!ext2fs_has_group_desc_csum(fs))
 		return 0;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index c2e7fbe..89df977 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -729,6 +729,11 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+/*
+ * METADATA_CSUM implies GDT_CSUM.  When METADATA_CSUM is set, group
+ * descriptor checksums use the same algorithm as all other data
+ * structures' checksums.
+ */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 
@@ -743,7 +748,6 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
-#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x8000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff2799a..28cb626 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -579,8 +579,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT|\
-					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -589,8 +588,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT|\
-					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
@@ -646,6 +644,12 @@ typedef struct stat ext2fs_struct_stat;
 /*
  * function prototypes
  */
+static inline int ext2fs_has_group_desc_csum(ext2_filsys fs)
+{
+	return EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+}
 
 /* alloc.c */
 extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index a63ea18..a22cab4 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -435,8 +435,7 @@ ipg_retry:
 	 * bitmaps will be accounted for when allocated).
 	 */
 	free_blocks = 0;
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		/*
 		 * Don't set the BLOCK_UNINIT group for the last group
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 74703c5..3e6d853 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -157,8 +157,7 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 						     scan->current_group);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (ext2fs_has_group_desc_csum(fs)) {
 		scan->inodes_left -=
 			ext2fs_bg_itable_unused(fs, scan->current_group);
 		scan->blocks_left =
@@ -183,8 +182,7 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	}
 	if (scan->fs->badblocks && scan->fs->badblocks->num)
 		scan->scan_flags |= EXT2_SF_CHK_BADBLOCKS;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (ext2fs_has_group_desc_csum(fs))
 		scan->scan_flags |= EXT2_SF_DO_LAZY;
 	*ret_scan = scan;
 	return 0;
@@ -250,8 +248,7 @@ static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 	scan->bytes_left = 0;
 	scan->inodes_left = EXT2_INODES_PER_GROUP(fs->super);
 	scan->blocks_left = fs->inode_blocks_per_group;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (ext2fs_has_group_desc_csum(fs)) {
 		scan->inodes_left -=
 			ext2fs_bg_itable_unused(fs, scan->current_group);
 		scan->blocks_left =
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index d2b64f4..2dc9b94 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -382,8 +382,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	 * If recovery is from backup superblock, Clear _UNININT flags &
 	 * reset bg_itable_unused to zero
 	 */
-	if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
 		dgrp_t group;
 
 		for (group = 0; group < fs->group_desc_count; group++) {
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index a5097c1..18e18aa 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -36,7 +36,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	unsigned int	nbits;
 	errcode_t	retval;
 	char		*block_buf = NULL, *inode_buf = NULL;
-	int		csum_flag = 0;
+	int		csum_flag;
 	blk64_t		blk;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
 	ext2_ino_t	ino_itr = 1;
@@ -46,9 +46,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 
 	inode_nbytes = block_nbytes = 0;
 	if (do_block) {
@@ -168,7 +166,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	errcode_t retval;
 	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
 	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
-	int csum_flag = 0;
+	int csum_flag;
 	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
 	unsigned int	cnt;
 	blk64_t	blk;
@@ -181,9 +179,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 
 	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
 	if (retval)
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index b8f386e..3ceb0f8 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -114,7 +114,7 @@ static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 {
 	int first = 1, bg_flags = 0;
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+	if (ext2fs_has_group_desc_csum(fs))
 		bg_flags = ext2fs_bg_flags(fs, i);
 
 	print_bg_opt(bg_flags, EXT2_BG_INODE_UNINIT, "INODE_UNINIT",
@@ -190,7 +190,7 @@ static void list_desc (ext2_filsys fs)
 		print_range(first_block, last_block);
 		fputs(")", stdout);
 		print_bg_opts(fs, i);
-		if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+		if (ext2fs_has_group_desc_csum(fs))
 			printf(_("  Checksum 0x%04x, unused inodes %u\n"),
 			       ext2fs_bg_checksum(fs, i),
 			       ext2fs_bg_itable_unused(fs, i));
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 8852735..f5d3d3b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -885,8 +885,7 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT |
-		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2049,7 +2048,8 @@ static int should_do_undo(const char *name)
 	int csum_flag, force_undo;
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
 	force_undo = get_int_from_profile(fs_types, "force_undo", 0);
 	if (!force_undo && (!csum_flag || !lazy_itable_init))
 		return 0;
@@ -2306,19 +2306,6 @@ int main (int argc, char *argv[])
 	if (!quiet &&
 	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
-		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-			printf(_("Group descriptor checksums "
-				 "are not enabled.  This reduces the "
-				 "coverage of metadata checksumming.  "
-				 "Pass -O uninit_bg to rectify.\n"));
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
-		    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM))
-			printf(_("Group descriptor checksums will not use "
-				 "the faster metadata_checksum algorithm.  "
-				 "Pass -O bg_use_meta_csum to rectify.\n"));
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				EXT3_FEATURE_INCOMPAT_EXTENTS))
 			printf(_("Extents are not enabled.  The file extent "
@@ -2358,6 +2345,7 @@ int main (int argc, char *argv[])
 	    (fs_param.s_feature_ro_compat &
 	     (EXT4_FEATURE_RO_COMPAT_HUGE_FILE|EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 	      EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
+	      EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
 	      EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)))
 		fs->super->s_kbytes_written = 1;
 
@@ -2505,8 +2493,7 @@ int main (int argc, char *argv[])
 		 * inodes as unused; we want e2fsck to consider all
 		 * inodes as potentially containing recoverable data.
 		 */
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		if (ext2fs_has_group_desc_csum(fs)) {
 			for (i = 1; i < fs->group_desc_count; i++)
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 		}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index cba4d4c..5a55412 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -92,7 +92,6 @@ static unsigned long new_inode_size;
 static char *ext_mount_opts;
 static int usrquota, grpquota;
 static int rewrite_checksums;
-static int rewrite_bgs_for_checksum;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -138,8 +137,7 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -159,8 +157,7 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -718,29 +715,6 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 }
 
 /*
- * Rewrite just the block group checksums.  Only call this function if
- * you're _not_ calling rewrite_metadata_checksums; this function exists
- * to handle the case that you're changing bg_use_meta_csum and NOT changing
- * either gdt_csum or metadata_csum.
- */
-static void rewrite_bg_checksums(ext2_filsys fs)
-{
-	int i;
-
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
-	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		return;
-
-	ext2fs_init_csum_seed(fs);
-	for (i = 0; i < fs->group_desc_count; i++)
-		ext2fs_group_desc_csum_set(fs, i);
-	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-	ext2fs_mark_super_dirty(fs);
-}
-
-/*
  * Update the feature set as provided by the user.
  */
 static int update_feature_set(ext2_filsys fs, char *features)
@@ -912,20 +886,6 @@ mmp_error:
 		}
 	}
 
-	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
-		       EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
-		if (check_fsck_needed(fs))
-			exit(1);
-		rewrite_bgs_for_checksum = 1;
-	}
-
-	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
-			EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
-		if (check_fsck_needed(fs))
-			exit(1);
-		rewrite_bgs_for_checksum = 1;
-	}
-
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (check_fsck_needed(fs))
@@ -965,7 +925,7 @@ mmp_error:
 			}
 			gd->bg_itable_unused = 0;
 			gd->bg_flags = 0;
-			gd->bg_checksum = 0;
+			ext2fs_group_desc_csum_set(fs, i);
 		}
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	}
@@ -2588,8 +2548,6 @@ retry_open:
 	}
 	if (rewrite_checksums)
 		rewrite_metadata_checksums(fs);
-	else if (rewrite_bgs_for_checksum)
-		rewrite_bg_checksums(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dc2805d..8a02ff4 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -191,8 +191,7 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 	int		old_desc_blocks;
 	dgrp_t		g;
 
-	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+	if (!ext2fs_has_group_desc_csum(fs))
 		return;
 
 	for (g=0; g < fs->group_desc_count; g++) {
@@ -482,8 +481,7 @@ retry:
 	group_block = fs->super->s_first_data_block +
 		old_fs->group_desc_count * fs->super->s_blocks_per_group;
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	adj = old_fs->group_desc_count;
 	max_group = fs->group_desc_count - adj;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
@@ -743,8 +741,7 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 	} else if (IS_INODE_TB(fs, group, blk)) {
 		ext2fs_inode_table_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
-	} else if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	} else if (ext2fs_has_group_desc_csum(fs) &&
 		   (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT))) {
 		/*
 		 * If the block bitmap is uninitialized, which means
@@ -804,8 +801,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	for (blk = ext2fs_blocks_count(fs->super);
 	     blk < ext2fs_blocks_count(old_fs->super); blk++) {
 		g = ext2fs_group_of_blk2(fs, blk);
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+		if (ext2fs_has_group_desc_csum(fs) &&
 		    ext2fs_bg_flags_test(old_fs, g, EXT2_BG_BLOCK_UNINIT)) {
 			/*
 			 * The block bitmap is uninitialized, so skip
