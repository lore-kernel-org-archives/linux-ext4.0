From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] misc: clean up compiler warnings
Date: Thu,  9 Jun 2011 22:52:38 -0600
Message-ID: <1307681558-31407-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58987 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1FJEwm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 00:52:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix several types of compiler warnings (unused variables/labels),
uninitialized variables, etc that are hit with gcc -Wall.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 debugfs/debugfs.c     |    5 ++---
 debugfs/debugfs.h     |    1 +
 debugfs/dump.c        |    2 ++
 e2fsck/message.c      |    1 -
 e2fsck/pass1.c        |    5 +++--
 e2fsck/pass2.c        |    3 ++-
 e2fsck/pass5.c        |    1 -
 e2fsck/rehash.c       |    3 ++-
 e2fsprogs.spec.in     |    1 +
 lib/blkid/probe.c     |    7 ++++---
 lib/e2p/ls.c          |    4 ++--
 lib/ext2fs/ext2fs.h   |    3 ++-
 lib/ext2fs/fileio.c   |    2 +-
 lib/ext2fs/openfs.c   |    1 -
 lib/ext2fs/progress.c |    2 --
 lib/ext2fs/res_gdt.c  |    2 +-
 lib/ext2fs/unix_io.c  |    2 ++
 misc/badblocks.c      |    2 ++
 misc/e2freefrag.c     |    4 ++--
 misc/e2undo.c         |    9 ++++-----
 misc/tune2fs.c        |    5 ++---
 21 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index e441bc5..55d16af 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -855,7 +855,7 @@ void do_stat(int argc, char *argv[])
 	return;
 }
 
-void do_dump_extents(int argc, char *argv[])
+void do_dump_extents(int argc, char **argv)
 {
 	struct ext2_inode inode;
 	ext2_ino_t	ino;
@@ -876,8 +876,7 @@ void do_dump_extents(int argc, char *argv[])
 		}
 	}
 
-	if (argc != optind+1) {
-	print_usage:
+	if (argc != optind + 1) {
 		com_err(0, 0, "Usage: dump_extents [-n] [-l] file");
 		return;
 	}
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 4cc8a1f..f7ec8da 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -103,6 +103,7 @@ extern void do_unlink(int argc, char **argv);
 extern void do_find_free_block(int argc, char **argv);
 extern void do_find_free_inode(int argc, char **argv);
 extern void do_stat(int argc, char **argv);
+extern void do_dump_extents(int argc, char **argv);
 
 extern void do_chroot(int argc, char **argv);
 extern void do_clri(int argc, char **argv);
diff --git a/debugfs/dump.c b/debugfs/dump.c
index ab0d68b..4cf0752 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -5,7 +5,9 @@
  * under the terms of the GNU Public License.
  */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE /* for O_LARGEFILE */
+#endif
 
 #include <stdio.h>
 #include <unistd.h>
diff --git a/e2fsck/message.c b/e2fsck/message.c
index a5f8947..d560cf8 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -263,7 +263,6 @@ static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 {
 	struct ext2_inode	*inode;
 	struct ext2_inode_large	*large_inode;
-	time_t			t;
 
 	if (!ctx || !ctx->inode)
 		goto no_inode;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 67dd986..d182d1d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -404,7 +404,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	struct ext2_dir_entry 	*dirent;
 	const char		*old_op;
 	errcode_t		retval;
-	blk64_t			blk, first_dir_blk;
+	blk64_t			blk;
 	unsigned int		i, rec_len, not_device = 0;
 	int			extent_fs;
 
@@ -436,7 +436,8 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	 * with it.
 	 */
 
-	extent_fs = (ctx->fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	extent_fs = (ctx->fs->super->s_feature_incompat &
+		     EXT3_FEATURE_INCOMPAT_EXTENTS);
 	if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
 		/* extent mapped */
 		if  (ext2fs_bmap2(ctx->fs, pctx->ino, inode, 0, 0, 0, 0,
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 8d1cbc6..b97a0b3 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -404,7 +404,8 @@ static int check_dotdot(e2fsck_t ctx,
 			struct ext2_dir_entry *dirent,
 			ext2_ino_t ino, struct problem_context *pctx)
 {
-	int	rec_len, problem = 0;
+	int		problem = 0;
+	unsigned int	rec_len;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT_DOT;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index b423d28..3d9874f 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -77,7 +77,6 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
 				  blk64_t start, blk64_t count)
 {
 	ext2_filsys fs = ctx->fs;
-	int ret = 0;
 
 	/*
 	 * If the filesystem has changed it means that there was an corruption
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 5543134..e8af323 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -430,12 +430,13 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		return retval;
 	dirent = (struct ext2_dir_entry *) block_start;
 	prev_rec_len = 0;
+	rec_len = 0;
 	left = fs->blocksize;
 	slack = fd->compress ? 12 :
 		(fs->blocksize * ctx->htree_slack_percentage)/100;
 	if (slack < 12)
 		slack = 12;
-	for (i=0; i < fd->num_array; i++) {
+	for (i = 0; i < fd->num_array; i++) {
 		ent = fd->harray + i;
 		if (ent->dir->inode == 0)
 			continue;
diff --git a/e2fsprogs.spec.in b/e2fsprogs.spec.in
index 6fc23a7..b188b75 100644
--- a/e2fsprogs.spec.in
+++ b/e2fsprogs.spec.in
@@ -212,6 +212,7 @@ exit 0
 %{_includedir}/blkid
 %{_includedir}/e2p
 %{_includedir}/et
+%{_includedir}/com_err.h
 %{_includedir}/ext2fs
 %{_includedir}/ss
 %{_includedir}/uuid
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6b75732..e6131fb 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -248,7 +248,7 @@ static int linux_version_code()
 {
 #ifdef __linux__
 	struct utsname	ut;
-	static		version_code = -1;
+	static int	version_code = -1;
 	int		major, minor, rev;
 	char		*endptr;
 	const char 	*cp;
@@ -1175,7 +1175,7 @@ static int probe_hfs(struct blkid_probe *probe __BLKID_ATTR((unused)),
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
 	}
-	blkid_set_tag(probe->dev, "LABEL", hfs->label, hfs->label_len);
+	blkid_set_tag(probe->dev, "LABEL", (char *)hfs->label, hfs->label_len);
 	return 0;
 }
 
@@ -1296,7 +1296,8 @@ static int probe_hfsplus(struct blkid_probe *probe,
 		return 0;
 
 	label_len = blkid_be16(key->unicode_len) * 2;
-	unicode_16be_to_utf8(label, sizeof(label), key->unicode, label_len);
+	unicode_16be_to_utf8((unsigned char *)label, sizeof(label),
+			     key->unicode, label_len);
 	blkid_set_tag(probe->dev, "LABEL", label, 0);
 	return 0;
 }
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 5e560ed..0f36f40 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -383,7 +383,7 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		tm = sb->s_first_error_time;
 		fprintf(f, "First error time:         %s", ctime(&tm));
 		memset(buf, 0, sizeof(buf));
-		strncpy(buf, sb->s_first_error_func,
+		strncpy(buf, (char *)sb->s_first_error_func,
 			sizeof(sb->s_first_error_func));
 		fprintf(f, "First error function:     %s\n", buf);
 		fprintf(f, "First error line #:       %u\n",
@@ -397,7 +397,7 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		tm = sb->s_last_error_time;
 		fprintf(f, "Last error time:          %s", ctime(&tm));
 		memset(buf, 0, sizeof(buf));
-		strncpy(buf, sb->s_last_error_func,
+		strncpy(buf, (char *)sb->s_last_error_func,
 			sizeof(sb->s_last_error_func));
 		fprintf(f, "Last error function:      %s\n", buf);
 		fprintf(f, "Last error line #:        %u\n",
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d3eb31d..9acccf2 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1396,7 +1396,8 @@ _INLINE_ errcode_t ext2fs_get_memalign(unsigned long size,
 
 	if (align == 0)
 		align = 8;
-	if (retval = posix_memalign((void **) ptr, align, size)) {
+	retval = posix_memalign((void **) ptr, align, size);
+	if (retval) {
 		if (retval == ENOMEM)
 			return EXT2_ET_NO_MEMORY;
 		return retval;
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 4b62c2d..d62ef35 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -377,7 +377,7 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 	truncate_block = ((size + file->fs->blocksize - 1) >>
 			  EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
 	old_size = file->inode.i_size +
-		((blk64_t) file->inode.i_size_high) << 32;
+		((blk64_t)file->inode.i_size_high << 32);
 	old_truncate = ((old_size + file->fs->blocksize - 1) >>
 		      EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
 
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 90abed1..383aa72 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -353,7 +353,6 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	 */
 	if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		struct ext2_group_desc *gd;
 		dgrp_t group;
 
 		for (group = 0; group < fs->group_desc_count; group++) {
diff --git a/lib/ext2fs/progress.c b/lib/ext2fs/progress.c
index ec4f553..1b9bf9c 100644
--- a/lib/ext2fs/progress.c
+++ b/lib/ext2fs/progress.c
@@ -77,8 +77,6 @@ void ext2fs_numeric_progress_close(ext2_filsys fs,
 				   struct ext2fs_numeric_progress_struct * progress,
 				   const char *message)
 {
-	unsigned int len;
-
 	if (!(fs->flags & EXT2_FLAG_PRINT_PROGRESS))
 		return;
 	fprintf(stdout, "%.*s", (2*progress->log_max)+1, spaces);
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index bf10995..f3b3969 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -75,7 +75,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 
 	retval = ext2fs_get_array(2, fs->blocksize, &dindir_buf);
 	if (retval)
-		goto out_free;
+		return retval;
 	gdt_buf = (__u32 *)((char *)dindir_buf + fs->blocksize);
 
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 82e0fe4..6e480b7 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -17,7 +17,9 @@
 
 #define _LARGEFILE_SOURCE
 #define _LARGEFILE64_SOURCE
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 
 #include <stdio.h>
 #include <string.h>
diff --git a/misc/badblocks.c b/misc/badblocks.c
index 8da66f8..1e7e1c8 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -29,7 +29,9 @@
  * 			 list.  (Work done by David Beattie)
  */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE /* for O_DIRECT */
+#endif
 
 #ifndef O_LARGEFILE
 #define O_LARGEFILE 0
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index b827a49..e6fd67e 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -144,7 +144,7 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	unsigned long total_chunks;
 	char *unitp = "KMGTPEZY";
 	int units = 10;
-	unsigned long start = 0, end, cum;
+	unsigned long start = 0, end;
 	int i, retval = 0;
 
 	scan_block_bitmap(fs, info);
@@ -218,7 +218,7 @@ void close_device(char *device_name, ext2_filsys fs)
 
 void collect_info(ext2_filsys fs, struct chunk_info *chunk_info)
 {
-	unsigned int retval = 0, i, free_blks;
+	unsigned int retval = 0;
 
 	printf("Device: %s\n", fs->device_name);
 	printf("Blocksize: %u bytes\n", fs->blocksize);
diff --git a/misc/e2undo.c b/misc/e2undo.c
index b85f270..04d0b17 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -29,12 +29,11 @@ unsigned char blksize_key[] = "filesystem BLKSIZE";
 
 char *prg_name;
 
-static void usage(char *prg_name)
+static void usage(void)
 {
 	fprintf(stderr,
 		_("Usage: %s <transaction file> <filesystem>\n"), prg_name);
 	exit(1);
-
 }
 
 static int check_filesystem(TDB_CONTEXT *tdb, io_channel channel)
@@ -145,12 +144,12 @@ int main(int argc, char *argv[])
 				force = 1;
 				break;
 			default:
-				usage(prg_name);
+				usage();
 		}
 	}
 
-	if (argc != optind+2)
-		usage(prg_name);
+	if (argc != optind + 2)
+		usage();
 
 	tdb_file = argv[optind];
 	device_name = argv[optind+1];
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index bcada11..89bf6c8 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -348,7 +348,6 @@ static void update_feature_set(ext2_filsys fs, char *features)
 {
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *gd;
-	errcode_t	retval;
 	__u32		old_features[3];
 	int		i, type_err;
 	unsigned int	mask_err;
@@ -992,7 +991,7 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 					"Extended mount options too long\n");
 				continue;
 			}
-			strcpy(fs->super->s_mount_opts, arg);
+			strcpy((char *)fs->super->s_mount_opts, arg);
 			ext2fs_mark_super_dirty(fs);
 		} else
 			r_usage++;
@@ -1097,7 +1096,7 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 {
 
 	char *buf;
-	dgrp_t group;
+	dgrp_t group = 0;
 	errcode_t retval;
 	int meta_data = 0;
 	blk64_t blk, new_blk, goal;
-- 
1.7.3.4

