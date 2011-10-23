From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 8/8] e2fsprogs: add exclude bitmap support in debugfs
Date: Sun, 23 Oct 2011 15:21:28 +0800
Message-ID: <1319354488-6050-9-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1JWJLK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:11:10 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:11:10 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap is a feature needed by ext4 snapshot.  This patch
adds exclude bitmap support in debugfs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 debugfs/debug_cmds.ct |    9 +++++
 debugfs/debugfs.c     |   81 ++++++++++++++++++++++++++++++++++++++++++++++--
 debugfs/set_fields.c  |    1 +
 lib/ext2fs/bitops.h   |   49 +++++++++++++++++++++++++++++
 4 files changed, 136 insertions(+), 4 deletions(-)

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index ea677da..2098f29 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -88,6 +88,15 @@ request do_setb, "Set a block's in-use flag",
 request do_testb, "Test a block's in-use flag",
 	testb;
 
+request do_freee, "Clear a block's exclude flag",
+	freee;
+
+request do_sete, "Set a block's exclude flag",
+	sete;
+
+request do_teste, "Test a block's exclude flag",
+	teste;
+
 request do_modify_inode, "Modify an inode by structure",
 	modify_inode, mi;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index dd1435b..f839563 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -98,6 +98,11 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 			com_err(device, retval, "while reading inode bitmap");
 			goto errout;
 		}
+		retval = ext2fs_read_exclude_bitmap(current_fs);
+		if (retval) {
+			com_err(device, retval, "while reading exclude bitmap");
+			goto errout;
+		}
 		retval = ext2fs_read_block_bitmap(current_fs);
 		if (retval) {
 			com_err(device, retval, "while reading block bitmap");
@@ -352,12 +357,14 @@ void do_show_super_stats(int argc, char *argv[])
 					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	for (i = 0; i < current_fs->group_desc_count; i++) {
 		fprintf(out, " Group %2d: block bitmap at %llu, "
+			"exlcude bitmap at %llu, "
 		        "inode bitmap at %llu, "
 		        "inode table at %llu\n"
 		        "           %u free %s%s, "
 		        "%u free %s, "
 		        "%u used %s%s",
 		        i, ext2fs_block_bitmap_loc(current_fs, i),
+			ext2fs_exclude_bitmap_loc(current_fs, i),
 		        ext2fs_inode_bitmap_loc(current_fs, i),
 			ext2fs_inode_table_loc(current_fs, i),
 		        ext2fs_bg_free_blocks_count(current_fs, i), units,
@@ -375,10 +382,12 @@ void do_show_super_stats(int argc, char *argv[])
 				ext2fs_bg_itable_unused(current_fs, i) != 1 ?
 				"inodes" : "inode");
 		first = 1;
-		print_bg_opts(current_fs, i, EXT2_BG_INODE_UNINIT, "Inode not init",
-			      &first, out);
-		print_bg_opts(current_fs, i, EXT2_BG_BLOCK_UNINIT, "Block not init",
-			      &first, out);
+		print_bg_opts(current_fs, i, EXT2_BG_INODE_UNINIT,
+			      "Inode not init", &first, out);
+		print_bg_opts(current_fs, i, EXT2_BG_EXCLUDE_UNINIT,
+			      "Exclude not init", &first, out);
+		print_bg_opts(current_fs, i, EXT2_BG_BLOCK_UNINIT,
+			      "Block not init", &first, out);
 		if (gdt_csum) {
 			fprintf(out, "%sChecksum 0x%04x",
 				first ? "           [":", ", ext2fs_bg_checksum(current_fs, i));
@@ -1074,6 +1083,70 @@ void do_testb(int argc, char *argv[])
 	}
 }
 
+void do_freee(int argc, char *argv[])
+{
+	blk64_t block;
+	blk64_t count = 1;
+
+	if (!EXT2_HAS_COMPAT_FEATURE(current_fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		return;
+	if (common_block_args_process(argc, argv, &block, &count))
+		return;
+	if (check_fs_read_write(argv[0]))
+		return;
+	while (count-- > 0) {
+		if (!ext2fs_test_exclude_bitmap2(current_fs->exclude_map,
+						 block))
+			com_err(argv[0], 0, "Warning: block %llu already "
+				"not excluded", block);
+		ext2fs_unmark_exclude_bitmap2(current_fs->exclude_map, block);
+		block++;
+	}
+	ext2fs_mark_eb_dirty(current_fs);
+}
+
+void do_sete(int argc, char *argv[])
+{
+	blk64_t block;
+	blk64_t count = 1;
+
+	if (!EXT2_HAS_COMPAT_FEATURE(current_fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		return;
+	if (common_block_args_process(argc, argv, &block, &count))
+		return;
+	if (check_fs_read_write(argv[0]))
+		return;
+	while (count-- > 0) {
+		if (ext2fs_test_exclude_bitmap2(current_fs->exclude_map, block))
+			com_err(argv[0], 0, "Warning: block %llu already "
+				"excluded", block);
+		ext2fs_mark_exclude_bitmap2(current_fs->exclude_map, block);
+		block++;
+	}
+	ext2fs_mark_eb_dirty(current_fs);
+}
+
+void do_teste(int argc, char *argv[])
+{
+	blk64_t block;
+	blk64_t count = 1;
+
+	if (!EXT2_HAS_COMPAT_FEATURE(current_fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		return;
+	if (common_block_args_process(argc, argv, &block, &count))
+		return;
+	while (count-- > 0) {
+		if (ext2fs_test_exclude_bitmap2(current_fs->exclude_map, block))
+			printf("Block %llu marked excluded\n", block);
+		else
+			printf("Block %llu not excluded\n", block);
+		block++;
+	}
+}
+
 static void modify_u8(char *com, const char *prompt,
 		      const char *format, __u8 *val)
 {
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index d461275..7ecf7d8 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -205,6 +205,7 @@ static struct field_set_info inode_fields[] = {
 
 static struct field_set_info ext2_bg_fields[] = {
 	{ "block_bitmap", &set_gd.bg_block_bitmap, NULL, 4, parse_uint },
+	{ "exclude_bitmap", &set_gd.bg_exclude_bitmap_lo, NULL, 4, parse_uint },
 	{ "inode_bitmap", &set_gd.bg_inode_bitmap, NULL, 4, parse_uint },
 	{ "inode_table", &set_gd.bg_inode_table, NULL, 4, parse_uint },
 	{ "free_blocks_count", &set_gd.bg_free_blocks_count, NULL, 2, parse_uint },
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 83a01e4..64d14f9 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -72,6 +72,13 @@ extern int ext2fs_unmark_block_bitmap(ext2fs_block_bitmap bitmap,
 				       blk_t block);
 extern int ext2fs_test_block_bitmap(ext2fs_block_bitmap bitmap, blk_t block);
 
+extern int ext2fs_mark_exclude_bitmap(ext2fs_exclude_bitmap bitmap,
+				      blk_t block);
+extern int ext2fs_unmark_exclude_bitmap(ext2fs_exclude_bitmap bitmap,
+					blk_t block);
+extern int ext2fs_test_exclude_bitmap(ext2fs_exclude_bitmap bitmap,
+				      blk_t block);
+
 extern int ext2fs_mark_inode_bitmap(ext2fs_inode_bitmap bitmap, ext2_ino_t inode);
 extern int ext2fs_unmark_inode_bitmap(ext2fs_inode_bitmap bitmap,
 				       ext2_ino_t inode);
@@ -415,6 +422,27 @@ _INLINE_ int ext2fs_test_block_bitmap(ext2fs_block_bitmap bitmap,
 					  block);
 }
 
+_INLINE_ int ext2fs_mark_exclude_bitmap(ext2fs_exclude_bitmap bitmap,
+				       blk_t block)
+{
+	return ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+					  block);
+}
+
+_INLINE_ int ext2fs_unmark_exclude_bitmap(ext2fs_exclude_bitmap bitmap,
+					 blk_t block)
+{
+	return ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+					    block);
+}
+
+_INLINE_ int ext2fs_test_exclude_bitmap(ext2fs_exclude_bitmap bitmap,
+				       blk_t block)
+{
+	return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+					  block);
+}
+
 _INLINE_ int ext2fs_mark_inode_bitmap(ext2fs_inode_bitmap bitmap,
 				       ext2_ino_t inode)
 {
@@ -534,6 +562,27 @@ _INLINE_ int ext2fs_test_block_bitmap2(ext2fs_block_bitmap bitmap,
 					block);
 }
 
+_INLINE_ int ext2fs_mark_exclude_bitmap2(ext2fs_exclude_bitmap bitmap,
+				       blk64_t block)
+{
+	return ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+					  block);
+}
+
+_INLINE_ int ext2fs_unmark_exclude_bitmap2(ext2fs_exclude_bitmap bitmap,
+					 blk64_t block)
+{
+	return ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+					    block);
+}
+
+_INLINE_ int ext2fs_test_exclude_bitmap2(ext2fs_exclude_bitmap bitmap,
+				       blk64_t block)
+{
+	return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+					  block);
+}
+
 _INLINE_ int ext2fs_mark_inode_bitmap2(ext2fs_inode_bitmap bitmap,
 				       ext2_ino_t inode)
 {
-- 
1.7.5.1

