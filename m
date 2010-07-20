From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 12/12] e2fsprogs: Migrate old to new on-disk format
Date: Tue, 20 Jul 2010 18:16:13 +0300
Message-ID: <1279638973-14561-13-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54962 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0GTPRs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:48 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so969294wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:47 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Detect old 'has_snapshot' feature on ext2fs_open(), migrate snapshot
fields and flags and set new 'has_snapshot' feature.
Detect old 'exclude_inode' feature on create/check_exclude_inode(),
copy old exclude inode to new exclude inode location and set the new
'exclude_inode' feature.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/super.c       |   18 ++++++++++++++++++
 lib/ext2fs/ext2_fs.h |   16 ++++++++++++++++
 lib/ext2fs/ext2fs.h  |    1 +
 lib/ext2fs/openfs.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/res_gdt.c |   28 ++++++++++++++++++++++++++++
 lib/ext2fs/swapfs.c  |    5 +++++
 misc/tune2fs.c       |   17 +++++++++++++++++
 7 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 1dee84d..948c4bb 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -448,6 +448,24 @@ void check_exclude_inode(e2fsck_t ctx)
 
 	clear_problem_context(&pctx);
 
+	/* Migrate from old to new Next3 on-disk format */
+	if (fs->super->s_feature_compat &
+	      NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD) {
+		/* Move exclude inode from old to new position */
+		retval = ext2fs_read_inode(fs, EXT2_EXCLUDE_INO_OLD, &inode);
+		if (!retval) {
+			e2fsck_write_inode(ctx, EXT2_EXCLUDE_INO, &inode,
+					   "copy_old_exclude_ino");
+			memset(&inode, 0, sizeof(inode));
+			e2fsck_write_inode(ctx, EXT2_EXCLUDE_INO_OLD, &inode,
+					   "clear_old_exclude_ino");
+			/* Clear old exclude inode flag */
+			fs->super->s_feature_compat &=
+				~NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD;
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+
 	/* Read the exclude inode */
 	pctx.ino = EXT2_EXCLUDE_INO;
 	retval = ext2fs_read_inode(fs, EXT2_EXCLUDE_INO, &inode);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3a48486..bcc0f78 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -51,6 +51,7 @@
 #define EXT2_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT2_JOURNAL_INO	 8	/* Journal inode */
 #define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */
+#define EXT2_EXCLUDE_INO_OLD	10	/* Old exclude inode */
 
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11
@@ -150,6 +151,9 @@ struct ext2_group_desc
 	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
 };
 
+#define bg_exclude_bitmap_old bg_reserved[0]	/* Old exclude bitmap cache */
+#define bg_cow_bitmap_old bg_reserved[1]	/* Old COW bitmap cache */
+
 /*
  * Structure of a blocks group descriptor
  */
@@ -632,6 +636,12 @@ struct ext2_super_block {
 
 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
 
+/* old snapshot field positions */
+#define s_snapshot_list_old	s_reserved[151]	/* Old snapshot list head */
+#define s_snapshot_r_blocks_old	s_reserved[152] /* Old reserved for snapshot */
+#define s_snapshot_id_old	s_reserved[153]	/* Old active snapshot ID */
+#define s_snapshot_inum_old	s_reserved[154]	/* Old active snapshot inode */
+
 /*
  * Codes for operating systems
  */
@@ -687,6 +697,8 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_DIR_INDEX		0x0020
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
 #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080
+#define NEXT3_FEATURE_COMPAT_BIG_JOURNAL_OLD	0x1000 /* Old big journal */
+#define NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD	0x2000 /* Old exclude inode */
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -696,6 +708,10 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
+#define NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT_OLD 0x1000 /* Old has snapshots */
+#define NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT_OLD	0x2000 /* Old is snapshot */
+#define NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT_OLD 0x4000 /* Old fix snapshot */
+#define NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE_OLD	0x8000 /* Old fix exclude */
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 53c7a55..0e0b2fb 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -521,6 +521,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT2_FEATURE_COMPAT_IMAGIC_INODES|\
 					 EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
 					 EXT2_FEATURE_COMPAT_EXCLUDE_INODE|\
+					 NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD|\
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
 					 EXT2_FEATURE_COMPAT_EXT_ATTR)
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 50aa207..e84a124 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -205,6 +205,51 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		goto cleanup;
 	}
 
+	/* Migrate super from old to new Next3 on-disk format */
+	if ((fs->super->s_feature_ro_compat &
+			NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT_OLD) &&
+		!(fs->super->s_feature_ro_compat &
+			EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		struct ext2_super_block *sb = fs->super;
+
+		/* Copy snapshot fields to new positions */
+		sb->s_snapshot_inum = sb->s_snapshot_inum_old;
+		sb->s_snapshot_id = sb->s_snapshot_id_old;
+		sb->s_snapshot_r_blocks_count = sb->s_snapshot_r_blocks_old;
+		sb->s_snapshot_list = sb->s_snapshot_list_old;
+		/* Clear old snapshot fields */
+		sb->s_snapshot_inum_old = 0;
+		sb->s_snapshot_id_old = 0;
+		sb->s_snapshot_r_blocks_old = 0;
+		sb->s_snapshot_list_old = 0;
+		/* Copy snapshot flags to new positions */
+		fs->super->s_feature_ro_compat |=
+				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT;
+		if (fs->super->s_feature_compat &
+				NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD)
+			fs->super->s_feature_compat |=
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE;
+		if (fs->super->s_feature_ro_compat &
+				NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT_OLD)
+			fs->super->s_flags |= EXT2_FLAGS_FIX_SNAPSHOT;
+		if (fs->super->s_feature_ro_compat &
+				NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE_OLD)
+			fs->super->s_flags |= EXT2_FLAGS_FIX_EXCLUDE;
+		/* Clear old snapshot flags */
+		fs->super->s_feature_ro_compat &=
+				~(NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT_OLD|
+				NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT_OLD|
+				NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT_OLD|
+				NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE_OLD);
+		/* Clear deprecated big journal flag */
+		fs->super->s_feature_compat &=
+				~NEXT3_FEATURE_COMPAT_BIG_JOURNAL_OLD;
+		/* Keep old exclude inode flag b/c inode was not moved yet */
+		if (flags & EXT2_FLAG_RW)
+			/* in read-only mode just convert the in-memory copy */
+			ext2fs_mark_super_dirty(fs);
+	}
+
 	/*
 	 * Check for feature set incompatibility
 	 */
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index bfc51fa..5df27c9 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -252,6 +252,28 @@ errcode_t ext2fs_create_exclude_inode(ext2_filsys fs, int flags)
 	indir_buf = (__u32 *)((char *)dindir_buf + 1*fs->blocksize);
 	data_buf = (__u32 *)((char *)dindir_buf + 2*fs->blocksize);
 
+	/* Migrate from old to new Next3 on-disk format */
+	if (fs->super->s_feature_compat &
+	      NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD) {
+		/* Move exclude inode from old to new position */
+		retval = ext2fs_read_inode(fs, EXT2_EXCLUDE_INO_OLD, &inode);
+		if (!retval) {
+			retval = ext2fs_write_inode(fs, EXT2_EXCLUDE_INO,
+					&inode);
+			if (retval)
+				goto out_free;
+			memset(&inode, 0, sizeof(inode));
+			retval = ext2fs_write_inode(fs, EXT2_EXCLUDE_INO_OLD,
+					&inode);
+			if (retval)
+				goto out_free;
+			/* Clear old exclude inode flag */
+			fs->super->s_feature_compat &=
+				~NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD;
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+
 	retval = ext2fs_read_inode(fs, EXT2_EXCLUDE_INO, &inode);
 	if (retval)
 		goto out_free;
@@ -377,6 +399,12 @@ errcode_t ext2fs_create_exclude_inode(ext2_filsys fs, int flags)
 			}
 		}
 		fs->exclude_blks[grp] = data_blk;
+		/* reset old exclude/cow bitmap cache to zero */
+		if (gd->bg_exclude_bitmap_old || gd->bg_cow_bitmap_old) {
+			gd->bg_exclude_bitmap_old = 0;
+			gd->bg_cow_bitmap_old = 0;
+			gdt_dirty = 1;
+		}
 #ifdef EXCLUDE_INO_PROGRESS
 		printf("\b\b\b\b\b\b\b\b\b\b\b%5d/%5d", grp,
 				fs->group_desc_count);
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 619bd2d..d672c97 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -76,6 +76,11 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_snapshot_r_blocks_count =
 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
+	sb->s_snapshot_inum_old = ext2fs_swab32(sb->s_snapshot_inum_old);
+	sb->s_snapshot_id_old = ext2fs_swab32(sb->s_snapshot_id_old);
+	sb->s_snapshot_r_blocks_old =
+		ext2fs_swab32(sb->s_snapshot_r_blocks_old);
+	sb->s_snapshot_list_old = ext2fs_swab32(sb->s_snapshot_list_old);
 
 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 24b3aaa..3e32b81 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -373,6 +373,23 @@ static void remove_exclude_inode(ext2_filsys fs)
 	struct ext2_inode	inode;
 	ino_t			ino = EXT2_EXCLUDE_INO;
 	errcode_t		retval;
+	struct ext2_group_desc *gd;
+	int i;
+
+	if (fs->super->s_feature_compat &
+	      NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD) {
+		/* Remove old exclude inode */
+		ino = EXT2_EXCLUDE_INO_OLD;
+		/* Clear old exclude inode flag */
+		fs->super->s_feature_compat &=
+			~NEXT3_FEATURE_COMPAT_EXCLUDE_INODE_OLD;
+		/* Reset old exclude/cow bitmap cache to zero */
+		for (i = 0; i < fs->group_desc_count; i++) {
+			gd = ext2fs_group_desc(fs, fs->group_desc, i);
+			gd->bg_exclude_bitmap_old = 0;
+			gd->bg_cow_bitmap_old = 0;
+		}
+	}
 
 	/* clear fix_exclude flag */
 	fs->super->s_flags &= ~EXT2_FLAGS_FIX_EXCLUDE;
-- 
1.6.6

