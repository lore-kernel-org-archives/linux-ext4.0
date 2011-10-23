From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 6/8] e2fsprogs: add exclude bitmap support in tune2fs
Date: Sun, 23 Oct 2011 15:21:26 +0800
Message-ID: <1319354488-6050-7-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1JWJLG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:11:06 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:11:05 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap is a feature needed by ext4 snapshot.  This patch
adds exclude bitmap support in tune2fs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 misc/tune2fs.c |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index e2fdb4a..02edcd6 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -129,7 +129,9 @@ static void usage(void)
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
-		EXT2_FEATURE_COMPAT_DIR_INDEX,
+		EXT2_FEATURE_COMPAT_DIR_INDEX |
+		EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
+
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
@@ -149,7 +151,8 @@ static __u32 clear_ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
-		EXT2_FEATURE_COMPAT_DIR_INDEX,
+		EXT2_FEATURE_COMPAT_DIR_INDEX |
+		EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
@@ -288,6 +291,81 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 }
 
 /*
+ * Add exclude bitmaps to the filesystem
+ */
+static void add_exclude_bitmaps(ext2_filsys fs)
+{
+	char *buf = 0;
+	int retval, i;
+
+	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
+	if (retval) {
+		fputs(_("Allocating memory failed.\n"), stderr);
+		exit(1);
+	}
+	strcpy(buf, "exclude bitmap for ");
+	strcat(buf, fs->device_name);
+
+	retval = ext2fs_allocate_exclude_bitmap(fs, buf,
+						&fs->exclude_map);
+	ext2fs_free_mem(&buf);
+	if (retval) {
+		fputs(_("Allocating exclude bitmap failed.\n"), stderr);
+		exit(1);
+	}
+
+	retval = ext2fs_read_block_bitmap(fs);
+	if (retval) {
+		ext2fs_free_exclude_bitmap(fs->exclude_map);
+		fputs(_("Reading block bitmap failed.\n"), stderr);
+		exit(1);
+	}
+
+	retval = ext2fs_allocate_tables(fs);
+	if (retval) {
+		ext2fs_free_exclude_bitmap(fs->exclude_map);
+		fputs(_("Allocating filesystem exclude bitmaps "
+			"failed.\n"), stderr);
+		exit(1);
+	}
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_bb_dirty(fs);
+	ext2fs_mark_eb_dirty(fs);
+	ext2fs_mark_super_dirty(fs);
+}
+
+/*
+ * Remove the exclude bitmaps from the filesystem
+ */
+static void remove_exclude_bitmaps(ext2_filsys fs)
+{
+	struct ext2_group_desc *gd;
+	int retval, i;
+
+	retval = ext2fs_read_block_bitmap(fs);
+	if (retval) {
+		fputs(_("Reading block bitmap failed.\n"), stderr);
+		exit(1);
+	}
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		blk64_t exclude_bitmap;
+		gd = ext2fs_group_desc(fs, fs->group_desc, i);
+		exclude_bitmap = ext2fs_exclude_bitmap_loc(fs, i);
+		release_blocks_proc(fs, &exclude_bitmap, 0, 0, 0, NULL);
+		ext2fs_exclude_bitmap_loc_set(fs, i, 0);
+		ext2fs_bg_flags_clear(fs, i, EXT2_BG_EXCLUDE_UNINIT);
+		if(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			ext2fs_group_desc_csum_set(fs, i);
+	}
+
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_bb_dirty(fs);
+	ext2fs_mark_super_dirty(fs);
+}
+
+/*
  * Remove the journal inode from the filesystem
  */
 static errcode_t remove_journal_inode(ext2_filsys fs)
@@ -363,6 +441,32 @@ static void request_fsck_afterwards(ext2_filsys fs)
 		printf(_("(and reboot afterwards!)\n"));
 }
 
+static int verify_clean_fs(ext2_filsys fs, int compat, unsigned int mask,
+		int on)
+{
+	struct ext2_super_block *sb= fs->super;
+
+	if ((mount_flags & EXT2_MF_MOUNTED) &&
+		!(mount_flags & EXT2_MF_READONLY)) {
+		fprintf(stderr, _("The '%s' feature may only be "
+					"%s when the filesystem is\n"
+					"unmounted or mounted read-only.\n"),
+				e2p_feature2string(compat, mask),
+				on ? "set" : "cleared");
+		exit(1);
+	}
+	if (sb->s_feature_incompat &
+		EXT3_FEATURE_INCOMPAT_RECOVER) {
+		fprintf(stderr, _("The needs_recovery flag is set.  "
+					"Please run e2fsck before %s\n"
+					"the '%s' flag.\n"),
+				on ? "setting" : "clearing",
+				e2p_feature2string(compat, mask));
+		exit(1);
+	}
+	return 1;
+}
+
 /*
  * Update the feature set as provided by the user.
  */
@@ -380,6 +484,10 @@ static int update_feature_set(ext2_filsys fs, char *features)
 				 !((&sb->s_feature_compat)[(type)] & (mask)))
 #define FEATURE_CHANGED(type, mask) ((mask) & \
 		     (old_features[(type)] ^ (&sb->s_feature_compat)[(type)]))
+#define FEATURE_ON_SAFE(compat, mask) \
+	(FEATURE_ON(compat, mask) && verify_clean_fs(fs, compat, mask, 1))
+#define FEATURE_OFF_SAFE(compat, mask) \
+	(FEATURE_OFF(compat, mask) && verify_clean_fs(fs, compat, mask, 0))
 
 	old_features[E2P_FEATURE_COMPAT] = sb->s_feature_compat;
 	old_features[E2P_FEATURE_INCOMPAT] = sb->s_feature_incompat;
@@ -507,6 +615,16 @@ mmp_error:
 		sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	}
 
+	if (FEATURE_OFF_SAFE(E2P_FEATURE_COMPAT,
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+		remove_exclude_bitmaps(fs);
+	}
+
+	if (FEATURE_ON_SAFE(E2P_FEATURE_COMPAT,
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+		add_exclude_bitmaps(fs);
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_DIR_INDEX)) {
 		if (!sb->s_def_hash_version)
 			sb->s_def_hash_version = EXT2_HASH_HALF_MD4;
@@ -551,7 +669,7 @@ mmp_error:
 		for (i = 0; i < fs->group_desc_count; i++) {
 			gd = ext2fs_group_desc(fs, fs->group_desc, i);
 			if ((gd->bg_flags & EXT2_BG_INODE_ZEROED) == 0) {
-				/* 
+				/*
 				 * XXX what we really should do is zap
 				 * uninitialized inode tables instead.
 				 */
@@ -1318,6 +1436,10 @@ static int ext2fs_is_meta_block(ext2_filsys fs, blk_t blk)
 	group = ext2fs_group_of_blk(fs, blk);
 	if (ext2fs_block_bitmap_loc(fs, group) == blk)
 		return 1;
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+	    ext2fs_exclude_bitmap_loc(fs, group) == blk)
+		return 1;
 	if (ext2fs_inode_bitmap_loc(fs, group) == blk)
 		return 1;
 	return 0;
@@ -1536,6 +1658,17 @@ static int group_desc_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 			ext2fs_block_bitmap_loc_set(fs, i, new_blk);
 		}
 
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+			blk = ext2fs_exclude_bitmap_loc(fs, i);
+			if (ext2fs_test_block_bitmap(bmap, blk)) {
+				new_blk = translate_block(blk);
+				if (!new_blk)
+					continue;
+				ext2fs_exclude_bitmap_loc_set(fs, i, new_blk);
+			}
+		}
+
 		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (ext2fs_test_block_bitmap2(bmap, blk)) {
 			new_blk = translate_block(blk);
-- 
1.7.5.1

