From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 05/12] e2fsprogs: Avoid offline modifications to a file system with snapshots
Date: Tue, 20 Jul 2010 18:16:06 +0300
Message-ID: <1279638973-14561-6-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab0GTPRc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:32 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:32 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 sets the read-only compatible feature 'has_snapshot',
so the file system could be mounted with Ext3 only in read-only mode
to protect the snapshots.
Fsck displays a warning about possible corruption of the snapshots
in interactive mode and avoids freeing blocks in preen mode.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/e2fsck.h |    1 +
 e2fsck/pass1.c  |   11 +++++++++++
 e2fsck/pass5.c  |    4 ++++
 e2fsck/rehash.c |    7 +++++++
 e2fsck/super.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c   |    1 +
 misc/mke2fs.c   |    1 +
 misc/tune2fs.c  |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 resize/main.c   |   11 +++++++++++
 9 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 0f23751..13d4161 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -477,6 +477,7 @@ void check_super_block(e2fsck_t ctx);
 int check_backup_super_block(e2fsck_t ctx);
 void check_resize_inode(e2fsck_t ctx);
 void check_exclude_inode(e2fsck_t ctx);
+void check_snapshots(e2fsck_t ctx);
 
 /* util.c */
 extern void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5793467..43ca2e6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1668,6 +1668,17 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 			struct ext2_inode *inode, int restart_flag,
 			const char *source)
 {
+	/* don't clear inode with blocks when preening volume with active snapshot */
+	if ((ctx->fs->super->s_feature_ro_compat &
+				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
+		 ctx->fs->super->s_snapshot_inum) {
+		int i;
+		for (i = 0; i < EXT2_N_BLOCKS; i++)
+			if (inode->i_block[i])
+				/* if we don't halt, inode blocks will be freed */
+				preenhalt(ctx);
+	}
+
 	inode->i_flags = 0;
 	inode->i_links_count = 0;
 	ext2fs_icount_store(ctx->inode_link_info, ino, 0);
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index cbc12f3..fa14b19 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -334,6 +334,10 @@ redo_counts:
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
 
+	if (fs->super->s_flags & EXT2_FLAGS_IS_SNAPSHOT)
+		/* ignore free block counts in next3 snapshot image */
+		goto errout;
+
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (free_array[i] != ext2fs_bg_free_blocks_count(fs, i)) {
 			pctx.group = i;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 5543134..e045fd1 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -829,6 +829,13 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 	int			cur, max, all_dirs, dir_index, first = 1;
 
 	init_resource_track(&rtrack, ctx->fs->io);
+
+ 	/* never rehash directories when scanning volume with active snapshot */
+ 	if ((ctx->fs->super->s_feature_ro_compat &
+				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
+ 		 ctx->fs->super->s_snapshot_inum)
+ 		return;
+
 	all_dirs = ctx->options & E2F_OPT_COMPRESS_DIRS;
 
 	if (!ctx->dirs_to_hash && !all_dirs)
diff --git a/e2fsck/super.c b/e2fsck/super.c
index c155949..a9cf0d9 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -231,6 +231,12 @@ static int release_orphan_inodes(e2fsck_t ctx)
 	struct problem_context pctx;
 	char *block_buf;
 
+	/* never release orphans when scanning volume with active snapshot */
+	if ((fs->super->s_feature_ro_compat &
+				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
+		 fs->super->s_snapshot_inum)
+		return 0;
+
 	if ((ino = fs->super->s_last_orphan) == 0)
 		return 0;
 
@@ -510,6 +516,41 @@ void check_exclude_inode(e2fsck_t ctx)
 }
 
 /*
+ * This function checks if the file system has snapshots
+ */
+void check_snapshots(e2fsck_t ctx)
+{
+	struct ext2_super_block *sb = ctx->fs->super;
+	struct problem_context	pctx;
+	int cont;
+
+	if (!(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT))
+		/* no snapshots */
+		return;
+
+	if (!sb->s_snapshot_inum)
+		/* no active snapshot */
+		return;
+
+	if ((ctx->options & E2F_OPT_PREEN) ||
+		(ctx->options & E2F_OPT_NO))
+		/* preen and readonly modes are snapshot friendly */
+		return;
+
+	printf(_("%s has snapshots.  "), ctx->filesystem_name);
+	if (!ctx->interactive)
+		fatal_error(ctx, _("Cannot continue, aborting.\n\n"));
+	printf(_("\n\n\007\007\007\007WARNING!!!  "
+	       "Running e2fsck on filesystem with snapshots may\n"
+	       "damage the snapshots.\007\007\007\n\n"));
+	cont = ask_yn(_("Do you really want to continue"), -1);
+	if (!cont) {
+		printf (_("check aborted.\n"));
+		exit (0);
+	}
+}
+
+/*
  * This function checks the dirhash signed/unsigned hint if necessary.
  */
 static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 71e563d..43b0197 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1319,6 +1319,7 @@ print_unsupp_features:
 		fatal_error(ctx, 0);
 	check_if_skip(ctx);
 	check_resize_inode(ctx);
+	check_snapshots(ctx);
 	check_exclude_inode(ctx);
 	if (bad_blocks_file)
 		read_bad_blocks_file(ctx, bad_blocks_file, replace_bad_blocks);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6894945..f383f82 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -801,6 +801,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
+		EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 596b384..47d2754 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -127,6 +127,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
+		EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
@@ -145,6 +146,7 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
+		EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
@@ -448,6 +450,23 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	old_features[E2P_FEATURE_INCOMPAT] = sb->s_feature_incompat;
 	old_features[E2P_FEATURE_RO_INCOMPAT] = sb->s_feature_ro_compat;
 
+	/* disallow changing features when filesystem has snapshots */
+	if (sb->s_feature_ro_compat & 
+		EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT) {
+		fputs(_("The filesystem has snapshots.  "
+				"Please clear the has_snapshot flag\n"
+				"before clearing/setting other filesystem flags.\n"), 
+				stderr);
+		ok_features[E2P_FEATURE_COMPAT] = 0;
+		ok_features[E2P_FEATURE_INCOMPAT] = 0;
+		ok_features[E2P_FEATURE_RO_INCOMPAT] =
+			EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT;
+		clear_ok_features[E2P_FEATURE_COMPAT] = 0;
+		clear_ok_features[E2P_FEATURE_INCOMPAT] = 0;
+		clear_ok_features[E2P_FEATURE_RO_INCOMPAT] =
+			EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT;
+	}
+
 	if (e2p_edit_feature2(features, &sb->s_feature_compat,
 			      ok_features, clear_ok_features,
 			      &type_err, &mask_err)) {
@@ -516,6 +535,41 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		}
 	}
 
+	if (FEATURE_ON_SAFE(E2P_FEATURE_RO_INCOMPAT,
+				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		int big_journal = 0;
+
+		if ((sb->s_feature_compat &
+		    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+			/* update 'big_journal' flag */
+			big_journal = (ext2fs_check_journal_size(fs) >=
+					NEXT3_MIN_JOURNAL_BLOCKS);
+		} else if (!journal_size || journal_size == -1) {
+			/* Create a big journal for Next3 */
+			journal_size = -NEXT3_MAX_COW_CREDITS;
+			big_journal = 1;
+		}
+	
+		if (!big_journal)
+			fprintf(stderr,
+				_("Warning: journal size is not big enough.\n"
+				"For best operation of Next3, try re-creating "
+				"the journal with '-J big' before setting the "
+				"'has_snapshot' flag.\n"));
+
+		/* allocate/reset exclude bitmap blocks */
+		retval = ext2fs_create_exclude_inode(fs, EXCLUDE_CREATE);
+		if (!retval)
+			sb->s_feature_compat |=
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE;
+		else
+			fprintf(stderr,
+				_("Warning: failed to create exclude inode.\n"
+				"For best operation of Next3, try re-creating "
+				"the exclude inode before setting the "
+				"'has_snapshot' flag.\n"));
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_DIR_INDEX)) {
 		if (!sb->s_def_hash_version)
 			sb->s_def_hash_version = EXT2_HASH_HALF_MD4;
diff --git a/resize/main.c b/resize/main.c
index 7d8b287..ab5515f 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -444,6 +444,17 @@ int main (int argc, char ** argv)
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
+		/* do not offline resize a volume with active snapshot */
+		if (!force && (fs->super->s_feature_ro_compat &
+					EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
+				fs->super->s_snapshot_inum) {
+			fprintf(stderr,
+				_("offline resize will damage next3 snapshots "
+					"on %s - Please mount the filesystem "
+					"for online resize.\n\n"),
+				device_name);
+			exit(1);
+		}
 		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
 			       (fs->super->s_state & EXT2_ERROR_FS) ||
 			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
-- 
1.6.6

