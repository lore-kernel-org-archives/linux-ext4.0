From: Amir Goldstein <amir73il@users.sf.net>
Subject: [PATCH 5/8] e2fsprogs: Add has_snapshot feature for Next3.
Date: Wed, 05 May 2010 21:28:53 +0300
Message-ID: <1273084136-6286-6-git-send-email-amir73il@users.sf.net>
References: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout3.netvision.net.il ([194.90.6.2]:28329 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0EESwL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:52:11 -0400
Received: from localhost.localdomain ([109.186.177.237])
 by mxout3.netvision.net.il
 (Sun Java(tm) System Messaging Server 6.3-9.01 (built Oct 22 2009; 32bit))
 with ESMTP id <0L1Y005YHLXZVNB0@mxout3.netvision.net.il> for
 linux-ext4@vger.kernel.org; Wed, 05 May 2010 21:29:05 +0300 (IDT)
In-reply-to: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 sets the read-only compatible feature 'has_snapshot',
so the file system could be mounted with Ext3 only in read-only mode
to protect the snapshots.
Fsck displays a warning about possible corruption of the snapshots
in interactive mode and avoids freeing blocks in preen mode.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/e2fsck.h  |    1 +
 e2fsck/pass1.c   |   11 +++++++++++
 e2fsck/pass5.c   |    5 +++++
 e2fsck/problem.c |    7 +++++++
 e2fsck/problem.h |    3 +++
 e2fsck/rehash.c  |    7 +++++++
 e2fsck/super.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c    |    1 +
 misc/mke2fs.c    |    1 +
 misc/tune2fs.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 resize/main.c    |   11 +++++++++++
 11 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 8f31107..58a862c 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -474,6 +474,7 @@ void check_super_block(e2fsck_t ctx);
 int check_backup_super_block(e2fsck_t ctx);
 void check_resize_inode(e2fsck_t ctx);
 void check_exclude_inode(e2fsck_t ctx);
+void check_snapshots(e2fsck_t ctx);
 
 /* util.c */
 extern void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e32fa8e..af35e83 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1664,6 +1664,17 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 			struct ext2_inode *inode, int restart_flag,
 			const char *source)
 {
+	/* don't clear inode with blocks when preening volume with active snapshot */
+	if ((ctx->fs->super->s_feature_ro_compat &
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
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
index b22a838..2b4673f 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -334,6 +334,11 @@ redo_counts:
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
 
+	if (fs->super->s_feature_ro_compat &
+			NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT)
+		/* ignore free block counts in next3 snapshot image */
+		goto errout;
+
 	for (i = 0; i < fs->group_desc_count; i++) {
 		if (free_array[i] != ext2fs_bg_free_blocks_count(fs, i)) {
 			pctx.group = i;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2c635f0..77ae11b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -342,6 +342,13 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Exclude @i not valid.  "),
 	  PROMPT_RECREATE, 0 },
 
+	/* Corrupted snapshot */
+	{ PR_0_FIX_SNAPSHOT,
+	  N_("@f has corrupted snapshots.\n"
+	     "This version of e2fsck does not support fixing snapshots.\n"
+	     "You may wish to discard snapshots and run e2fsck again.\n"),
+	  PROMPT_ABORT, 0 },
+
 	/* Last mount time is in the future */
 	{ PR_0_FUTURE_SB_LAST_MOUNT,
 	  N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 044b715..19341ad 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -233,6 +233,9 @@ struct problem_context {
 /* Exclude inode invalid */
 #define PR_0_EXCLUDE_INODE_INVALID		0x000101
 
+/* Corrupted snapshot */
+#define PR_0_FIX_SNAPSHOT			0x000103
+
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index c0944a9..f9357e6 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -829,6 +829,13 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 	int			cur, max, all_dirs, dir_index, first = 1;
 
 	init_resource_track(&rtrack, ctx->fs->io);
+
+ 	/* never rehash directories when scanning volume with active snapshot */
+ 	if ((ctx->fs->super->s_feature_ro_compat &
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
+ 		 ctx->fs->super->s_snapshot_inum)
+ 		return;
+
 	all_dirs = ctx->options & E2F_OPT_COMPRESS_DIRS;
 
 	if (!ctx->dirs_to_hash && !all_dirs)
diff --git a/e2fsck/super.c b/e2fsck/super.c
index f475b99..f66ce9d 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -231,6 +231,12 @@ static int release_orphan_inodes(e2fsck_t ctx)
 	struct problem_context pctx;
 	char *block_buf;
 
+	/* never release orphans when scanning volume with active snapshot */
+	if ((fs->super->s_feature_ro_compat &
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
+		 fs->super->s_snapshot_inum)
+		return 0;
+
 	if ((ino = fs->super->s_last_orphan) == 0)
 		return 0;
 
@@ -508,6 +514,50 @@ void check_exclude_inode(e2fsck_t ctx)
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
+	if (!(sb->s_feature_ro_compat & 
+			NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT) ||
+		!sb->s_snapshot_inum)
+		/* no active snapshot */
+		return;
+
+	if (sb->s_feature_ro_compat & 
+			NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT) {
+		/* corrupted snapshot need to be fixed */
+		clear_problem_context(&pctx);
+		if (fix_problem(ctx, PR_0_FIX_SNAPSHOT, &pctx)) {
+			/* TODO: fix snapshot problems */
+			ctx->flags |= E2F_FLAG_ABORT;
+			return;
+		}
+	}
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
index 225b411..568a3fc 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1310,6 +1310,7 @@ print_unsupp_features:
 		fatal_error(ctx, 0);
 	check_if_skip(ctx);
 	check_resize_inode(ctx);
+	check_snapshots(ctx);
 	check_exclude_inode(ctx);
 	if (bad_blocks_file)
 		read_bad_blocks_file(ctx, bad_blocks_file, replace_bad_blocks);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 41b555d..f1dbc71 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -798,6 +798,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
+		NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ed06b87..70852bd 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -128,6 +128,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
+		NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
@@ -147,6 +148,7 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
+		NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
@@ -447,6 +449,23 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	old_features[E2P_FEATURE_INCOMPAT] = sb->s_feature_incompat;
 	old_features[E2P_FEATURE_RO_INCOMPAT] = sb->s_feature_ro_compat;
 
+	/* disallow changing features when filesystem has snapshots */
+	if (sb->s_feature_ro_compat & 
+		NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT) {
+		fputs(_("The filesystem has snapshots.  "
+				"Please clear the has_snapshot flag\n"
+				"before clearing/setting other filesystem flags.\n"), 
+				stderr);
+		ok_features[E2P_FEATURE_COMPAT] = 0;
+		ok_features[E2P_FEATURE_INCOMPAT] = 0;
+		ok_features[E2P_FEATURE_RO_INCOMPAT] =
+			NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT;
+		clear_ok_features[E2P_FEATURE_COMPAT] = 0;
+		clear_ok_features[E2P_FEATURE_INCOMPAT] = 0;
+		clear_ok_features[E2P_FEATURE_RO_INCOMPAT] =
+			NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT;
+	}
+
 	if (e2p_edit_feature2(features, &sb->s_feature_compat,
 			      ok_features, clear_ok_features,
 			      &type_err, &mask_err)) {
@@ -532,6 +551,37 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		}
 	}
 
+	if (FEATURE_ON_SAFE(E2P_FEATURE_RO_INCOMPAT,
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		if ((sb->s_feature_compat &
+		    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+			/* update 'big_journal' flag */
+			ext2fs_check_journal_size(fs);
+		}
+		else if (!journal_size) {
+			/* create 'big_journal' */
+			journal_size = -1;
+			sb->s_feature_compat |= NEXT3_FEATURE_COMPAT_BIG_JOURNAL;
+		}
+	
+		/* allocate/reset exclude bitmap blocks */
+		retval = ext2fs_create_exclude_inode(fs, 1);
+		if (!retval)
+			sb->s_feature_compat |=
+				NEXT3_FEATURE_COMPAT_EXCLUDE_INODE;
+
+		type_err = E2P_FEATURE_COMPAT;
+		if (!(sb->s_feature_compat &
+			(mask_err = NEXT3_FEATURE_COMPAT_BIG_JOURNAL)) ||
+			!(sb->s_feature_compat &
+			(mask_err = NEXT3_FEATURE_COMPAT_EXCLUDE_INODE)))
+			fprintf(stderr,_("Warning: the '%s' flag is not set.\n"
+				"For best operation, set the '%s' flag\n"
+				"before setting the 'has_snapshot' flag.\n"),
+				e2p_feature2string(type_err, mask_err),
+				e2p_feature2string(type_err, mask_err));
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_DIR_INDEX)) {
 		if (!sb->s_def_hash_version)
 			sb->s_def_hash_version = EXT2_HASH_HALF_MD4;
diff --git a/resize/main.c b/resize/main.c
index fd85d90..2155c7a 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -437,6 +437,17 @@ int main (int argc, char ** argv)
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
+		/* do not offline resize a volume with active snapshot */
+		if (!force && (fs->super->s_feature_ro_compat &
+					NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT) &&
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

