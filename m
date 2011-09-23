From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 3/4] ext2fs: add multi-mount protection (INCOMPAT_MMP)
Date: Fri, 23 Sep 2011 17:38:43 -0600
Message-ID: <1316821124-7461-3-git-send-email-adilger@whamcloud.com>
References: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Johann Lombardi <johann@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48272 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1IWXiu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 19:38:50 -0400
In-Reply-To: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Multi-mount protection is feature that allows mke2fs, e2fsck, and
others to detect if the filesystem is mounted on a remote node (on
SAN disks) and avoid corrupting the filesystem.  For e2fsprogs this
means that it checks the MMP block to see if the filesystem is in use,
and marks the filesystem busy while e2fsck is running on the system.

This is useful on SAN disks that are shared between high-availability
servers, or accessible by multiple nodes that aren't in HA pairs.  MMP
isn't intended to serve as a primary HA exclusion mechanism, but as a
failsafe to protect against user, software, or hardware errors.

There is no requirement that e2fsck updates the MMP block at regular
intervals, but e2fsck does this occasionally to provide useful
information to the sysadmin in case of a detected conflict.

For the kernel (since Linux 3.0) MMP adds a "heartbeat" mechanism to
periodically write to disk (every few seconds by default) to notify
other nodes that the filesystem is still in use and unsafe to modify.

Originally-by: Kalpak Shah <kalpak@clusterfs.com>

Signed-off-by: Johann Lombardi <johann@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

#
# total: 0 errors, 0 warnings, 1858 lines checked
#
# Your patch has no obvious style problems and is ready for submission.
---
 debugfs/debug_cmds.ct       |    6 +
 debugfs/debugfs.c           |   44 +++++
 debugfs/set_fields.c        |   85 +++++++++-
 e2fsck/e2fsck.c             |    2 +
 e2fsck/e2fsck.h             |    2 +
 e2fsck/journal.c            |    2 +
 e2fsck/pass1.c              |   10 +
 e2fsck/pass1b.c             |    4 +
 e2fsck/problem.c            |   11 +-
 e2fsck/problem.h            |    6 +
 e2fsck/unix.c               |  101 ++++++++++-
 e2fsck/util.c               |   28 +++
 lib/e2p/feature.c           |    4 +-
 lib/e2p/ls.c                |    6 +
 lib/ext2fs/Makefile.in      |    8 +
 lib/ext2fs/closefs.c        |    5 +
 lib/ext2fs/ext2_err.et.in   |   21 +++
 lib/ext2fs/ext2_fs.h        |   59 +++++--
 lib/ext2fs/ext2fs.h         |   26 +++
 lib/ext2fs/freefs.c         |    5 +
 lib/ext2fs/mmp.c            |  417 +++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/openfs.c         |   16 ++
 lib/ext2fs/swapfs.c         |   10 +
 lib/ext2fs/tst_super_size.c |    2 +-
 misc/mke2fs.8.in            |   10 +
 misc/mke2fs.c               |   30 +++-
 misc/tune2fs.8.in           |   23 +++
 misc/tune2fs.c              |  288 ++++++++++++++++++++++++------
 misc/util.c                 |   14 ++
 misc/util.h                 |    1 +
 30 files changed, 1167 insertions(+), 79 deletions(-)
 create mode 100644 lib/ext2fs/mmp.c

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 4e9e831..ea677da 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -166,5 +166,11 @@ request do_set_current_time, "Set current time to use when setting filesystme fi
 request do_supported_features, "Print features supported by this version of e2fsprogs",
 	supported_features;
 
+request do_dump_mmp, "Dump MMP information",
+	dump_mmp;
+
+request do_set_mmp_value, "Set MMP value",
+	set_mmp_value, smmp;
+
 end;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index cfaaed1..dd1435b 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -79,6 +79,8 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 			"opening read-only because of catastrophic mode");
 		open_flags &= ~EXT2_FLAG_RW;
 	}
+	if (catastrophic)
+		open_flags |= EXT2_FLAG_SKIP_MMP;
 
 	retval = ext2fs_open(device, open_flags, superblock, blocksize,
 			     unix_io_manager, &current_fs);
@@ -2161,6 +2163,48 @@ void do_punch(int argc, char *argv[])
 	}
 }
 
+void do_dump_mmp(int argc, char *argv[])
+{
+	struct ext2_super_block *sb = current_fs->super;
+	struct mmp_struct *mmp_s;
+	time_t t;
+	errcode_t retval = 0;
+
+	if (sb->s_mmp_block <= sb->s_first_data_block ||
+	    sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
+		com_err(argv[0], EXT2_ET_MMP_BAD_BLOCK, "while dumping it.\n");
+		return;
+	}
+
+	if (current_fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(current_fs->blocksize,
+					&current_fs->mmp_buf);
+		if (retval) {
+			com_err(argv[0], retval, "allocating MMP buffer.\n");
+			return;
+		}
+	}
+
+	mmp_s = current_fs->mmp_buf;
+
+	retval = ext2fs_mmp_read(current_fs, current_fs->super->s_mmp_block,
+				 current_fs->mmp_buf);
+	if (retval) {
+		com_err(argv[0], retval, "reading MMP block.\n");
+		return;
+	}
+
+	t = mmp_s->mmp_time;
+	fprintf(stdout, "block_number: %llu\n", current_fs->super->s_mmp_block);
+	fprintf(stdout, "update_interval: %d\n",
+		current_fs->super->s_mmp_update_interval);
+	fprintf(stdout, "check_interval: %d\n", mmp_s->mmp_check_interval);
+	fprintf(stdout, "sequence: %08x\n", mmp_s->mmp_seq);
+	fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
+	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
+	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
+}
+
 static int source_file(const char *cmd_file, int sci_idx)
 {
 	FILE		*f;
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 1d5d630..d461275 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -133,7 +133,7 @@ static struct field_set_info super_fields[] = {
 	{ "flags", &set_sb.s_flags, NULL, 4, parse_uint },
 	{ "raid_stride", &set_sb.s_raid_stride, NULL, 2, parse_uint },
 	{ "min_extra_isize", &set_sb.s_min_extra_isize, NULL, 4, parse_uint },
-	{ "mmp_interval", &set_sb.s_mmp_interval, NULL, 2, parse_uint },
+	{ "mmp_interval", &set_sb.s_mmp_update_interval, NULL, 2, parse_uint },
 	{ "mmp_block", &set_sb.s_mmp_block, NULL, 8, parse_uint },
 	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, NULL, 4, parse_uint },
 	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, NULL, 1, parse_uint },
@@ -726,3 +726,86 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 		ext2fs_mark_super_dirty(current_fs);
 	}
 }
+
+static errcode_t parse_mmp_clear(struct field_set_info *info, char *field,
+				 char *arg)
+{
+	errcode_t retval;
+
+	retval = ext2fs_mmp_clear(current_fs);
+	if (retval != 0)
+		com_err("set_mmp_value", retval, "while clearing MMP block\n");
+	else
+		memcpy(info->ptr, current_fs->mmp_buf, info->size);
+
+	return 1; /* we don't need the MMP block written again */
+}
+
+struct mmp_struct set_mmp;
+static struct field_set_info mmp_fields[] = {
+	{ "clear", &set_mmp.mmp_magic, NULL, sizeof(set_mmp), parse_mmp_clear },
+	{ "magic", &set_mmp.mmp_magic, NULL, 4, parse_uint },
+	{ "seq", &set_mmp.mmp_seq, NULL, 4, parse_uint },
+	{ "time", &set_mmp.mmp_time, NULL, 8, parse_uint },
+	{ "nodename", &set_mmp.mmp_nodename, NULL, sizeof(set_mmp.mmp_nodename),
+		parse_string },
+	{ "bdevname", &set_mmp.mmp_bdevname, NULL, sizeof(set_mmp.mmp_bdevname),
+		parse_string },
+	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
+};
+
+void do_set_mmp_value(int argc, char *argv[])
+{
+	const char *usage = "<field> <value>\n"
+		"\t\"set_mmp_value -l\" will list the names of "
+		"MMP fields\n\twhich can be set.";
+	static struct field_set_info *smmp;
+	struct mmp_struct *mmp_s;
+	errcode_t retval;
+
+	if (argc == 2 && strcmp(argv[1], "-l") == 0) {
+		print_possible_fields(mmp_fields);
+		return;
+	}
+
+	if (current_fs->super->s_mmp_block == 0) {
+		com_err(argv[0], 0, "no MMP block allocated\n");
+		return;
+	}
+
+	if (common_args_process(argc, argv, 2, 3, "set_mmp_value",
+				usage, CHECK_FS_RW))
+		return;
+
+	mmp_s = current_fs->mmp_buf;
+	if (mmp_s == NULL) {
+		retval = ext2fs_get_mem(current_fs->blocksize, &mmp_s);
+		if (retval) {
+			com_err(argv[0], retval, "allocating MMP buffer\n");
+			return;
+		}
+		retval = ext2fs_mmp_read(current_fs,
+					 current_fs->super->s_mmp_block, mmp_s);
+		if (retval) {
+			com_err(argv[0], retval, "reading MMP block %llu.\n",
+				(long long)current_fs->super->s_mmp_block);
+			ext2fs_free_mem(mmp_s);
+			return;
+		}
+		current_fs->mmp_buf = mmp_s;
+	}
+
+	smmp = find_field(mmp_fields, argv[1]);
+	if (smmp == 0) {
+		com_err(argv[0], 0, "invalid field specifier: %s", argv[1]);
+		return;
+	}
+
+	set_mmp = *mmp_s;
+	if (smmp->func(smmp, argv[1], argv[2]) == 0) {
+		ext2fs_mmp_write(current_fs, current_fs->super->s_mmp_block,
+				 &set_mmp);
+		*mmp_s = set_mmp;
+	}
+}
+
diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 3871840..c6e137b 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -218,6 +218,8 @@ int e2fsck_run(e2fsck_t ctx)
 	for (i=0; (e2fsck_pass = e2fsck_passes[i]); i++) {
 		if (ctx->flags & E2F_FLAG_RUN_RETURN)
 			break;
+		if (e2fsck_mmp_update(ctx->fs))
+			fatal_error(ctx, 0);
 		e2fsck_pass(ctx);
 		if (ctx->progress)
 			(void) (ctx->progress)(ctx, 0, 0, 0);
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 88ab84e..d225d89 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -537,6 +537,8 @@ extern blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
 			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
 extern int write_all(int fd, char *buf, size_t count);
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
+errcode_t e2fsck_mmp_update(ext2_filsys fs);
 
 /* unix.c */
 extern void e2fsck_clear_progbar(e2fsck_t ctx);
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 561ff34..915b8bb 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -882,6 +882,8 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
 		ctx->fs->io->manager->get_stats(ctx->fs->io, &stats);
 	if (stats && stats->bytes_written)
 		kbytes_written = stats->bytes_written >> 10;
+
+	ext2fs_mmp_stop(ctx->fs);
 	ext2fs_free(ctx->fs);
 	retval = ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
 			     ctx->superblock, blocksize, io_ptr,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ddaa802..f45831f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -704,7 +704,17 @@ void e2fsck_pass1(e2fsck_t ctx)
 	    (fs->super->s_mtime < fs->super->s_inodes_count))
 		busted_fs_time = 1;
 
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    !(fs->super->s_mmp_block <= fs->super->s_first_data_block ||
+	      fs->super->s_mmp_block >= fs->super->s_blocks_count))
+		ext2fs_mark_block_bitmap2(ctx->block_found_map,
+					  fs->super->s_mmp_block);
+
 	while (1) {
+		if (ino % (fs->super->s_inodes_per_group * 4) == 1) {
+			if (e2fsck_mmp_update(fs))
+				fatal_error(ctx, 0);
+		}
 		old_op = ehandler_operation(_("getting next inode from scan"));
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
 							  inode, inode_size);
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 4011dea..5ff92c2 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -288,6 +288,10 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 	pb.pctx = &pctx;
 	pctx.str = "pass1b";
 	while (1) {
+		if (ino % (fs->super->s_inodes_per_group * 4) == 1) {
+			if (e2fsck_mmp_update(fs))
+				fatal_error(ctx, 0);
+		}
 		pctx.errcode = ext2fs_get_next_inode(scan, &ino, &inode);
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			continue;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2c49493..cf4a270 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -418,6 +418,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Making @q @is hidden.\n\n"),
 	  PROMPT_NONE, PR_PREEN_OK },
 
+	/* Superblock has invalid MMP block. */
+	{ PR_0_MMP_INVALID_BLK,
+	  N_("@S has invalid MMP block.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Superblock has invalid MMP magic. */
+	{ PR_0_MMP_INVALID_MAGIC,
+	  N_("@S has invalid MMP magic.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
@@ -969,7 +979,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error adjusting refcount for @a @b %b (@i %i): %m\n"),
 	  PROMPT_NONE, 0 },
 
-
 	/* Pass 1C: Scan directories for inodes with multiply-claimed blocks. */
 	{ PR_1C_PASS_HEADER,
 	  N_("Pass 1C: Scanning directories for @is with @m @bs\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 21285dc..17b0c10 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -236,6 +236,12 @@ struct problem_context {
 /* Make quota file hidden */
 #define	PR_0_HIDE_QUOTA				0x000041
 
+/* Superblock has invalid MMP block. */
+#define PR_0_MMP_INVALID_BLK			0x000042
+
+/* Superblock has invalid MMP magic. */
+#define PR_0_MMP_INVALID_MAGIC			0x000043
+
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 511648e..f980962 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1006,6 +1006,88 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 static const char *my_ver_string = E2FSPROGS_VERSION;
 static const char *my_ver_date = E2FSPROGS_DATE;
 
+int e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
+{
+	struct mmp_struct *mmp_s;
+	unsigned int mmp_check_interval;
+	errcode_t retval = 0;
+	struct problem_context pctx;
+	unsigned int wait_time = 0;
+
+	clear_problem_context(&pctx);
+	if (fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (retval)
+			goto check_error;
+	}
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto check_error;
+
+	mmp_s = fs->mmp_buf;
+
+	mmp_check_interval = fs->super->s_mmp_update_interval;
+	if (mmp_check_interval < EXT4_MMP_MIN_CHECK_INTERVAL)
+		mmp_check_interval = EXT4_MMP_MIN_CHECK_INTERVAL;
+
+	/*
+	 * If check_interval in MMP block is larger, use that instead of
+	 * check_interval from the superblock.
+	 */
+	if (mmp_s->mmp_check_interval > mmp_check_interval)
+		mmp_check_interval = mmp_s->mmp_check_interval;
+
+	wait_time = mmp_check_interval * 2 + 1;
+
+	if (mmp_s->mmp_seq == EXT4_MMP_SEQ_CLEAN)
+		retval = 0;
+	else if (mmp_s->mmp_seq == EXT4_MMP_SEQ_FSCK)
+		retval = EXT2_ET_MMP_FSCK_ON;
+	else if (mmp_s->mmp_seq > EXT4_MMP_SEQ_MAX)
+		retval = EXT2_ET_MMP_UNKNOWN_SEQ;
+
+	if (retval)
+		goto check_error;
+
+	/* Print warning if e2fck will wait for more than 20 secs. */
+	if (verbose || wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4) {
+		printf("MMP interval is %u seconds and total wait time is %u "
+		       "seconds. Please wait...\n",
+			mmp_check_interval, wait_time * 2);
+	}
+
+	return 0;
+
+check_error:
+
+	if (retval == EXT2_ET_MMP_BAD_BLOCK) {
+		if (fix_problem(ctx, PR_0_MMP_INVALID_BLK, &pctx)) {
+			fs->super->s_mmp_block = 0;
+			ext2fs_mark_super_dirty(fs);
+			retval = 0;
+		}
+	} else if (retval == EXT2_ET_MMP_FAILED) {
+		com_err(ctx->program_name, retval,
+			_("while checking MMP block"));
+		dump_mmp_msg(fs->mmp_buf, NULL);
+	} else if (retval == EXT2_ET_MMP_FSCK_ON ||
+		   retval == EXT2_ET_MMP_UNKNOWN_SEQ) {
+		com_err(ctx->program_name, retval,
+			_("while checking MMP block"));
+		dump_mmp_msg(fs->mmp_buf,
+			     _("If you are sure the filesystem is not "
+			       "in use on any node, run:\n"
+			       "'tune2fs -f -E clear_mmp {device}'\n"));
+	} else if (retval == EXT2_ET_MMP_MAGIC_INVALID) {
+		if (fix_problem(ctx, PR_0_MMP_INVALID_MAGIC, &pctx)) {
+			ext2fs_mmp_clear(fs);
+			retval = 0;
+		}
+	}
+	return retval;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1076,6 +1158,8 @@ int main (int argc, char *argv[])
 				    _("need terminal for interactive repairs"));
 	}
 	ctx->superblock = ctx->use_superblock;
+
+	flags = EXT2_FLAG_SKIP_MMP;
 restart:
 #ifdef CONFIG_TESTIO_DEBUG
 	if (getenv("TEST_IO_FLAGS") || getenv("TEST_IO_BLOCK")) {
@@ -1084,7 +1168,7 @@ restart:
 	} else
 #endif
 		io_ptr = unix_io_manager;
-	flags = EXT2_FLAG_NOFREE_ON_ERROR;
+	flags |= EXT2_FLAG_NOFREE_ON_ERROR;
 	profile_get_boolean(ctx->profile, "options", "old_bitmaps", 0, 0,
 			    &old_bitmaps);
 	if (!old_bitmaps)
@@ -1257,6 +1341,21 @@ failure:
 
 	ehandler_init(fs->io);
 
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    (flags & EXT2_FLAG_SKIP_MMP)) {
+		if (e2fsck_check_mmp(fs, ctx))
+			fatal_error(ctx, 0);
+	}
+
+	 /*
+	  * Restart in order to reopen fs but this time start mmp.
+	  */
+	if (flags & EXT2_FLAG_SKIP_MMP) {
+		ext2fs_close(fs);
+		flags &= ~EXT2_FLAG_SKIP_MMP;
+		goto restart;
+	}
+
 	if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
 	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER))
 		goto skip_journal;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index a15986d..06daf12 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -41,6 +41,7 @@
 
 extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
 
+#include <time.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 
@@ -49,6 +50,7 @@ void fatal_error(e2fsck_t ctx, const char *msg)
 	if (msg)
 		fprintf (stderr, "e2fsck: %s\n", msg);
 	if (ctx->fs && ctx->fs->io) {
+		ext2fs_mmp_stop(ctx->fs);
 		if (ctx->fs->io->magic == EXT2_ET_MAGIC_IO_CHANNEL)
 			io_channel_flush(ctx->fs->io);
 		else
@@ -710,3 +712,29 @@ int write_all(int fd, char *buf, size_t count)
 	}
 	return c;
 }
+
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+{
+
+	if (msg)
+		printf("MMP check failed: %s\n", msg);
+	if (mmp) {
+		time_t t = mmp->mmp_time;
+
+		printf("MMP error info: last update: %s node: %s device: %s\n",
+		       ctime(&t), mmp->mmp_nodename, mmp->mmp_bdevname);
+	}
+}
+
+errcode_t e2fsck_mmp_update(ext2_filsys fs)
+{
+	errcode_t retval;
+
+	retval = ext2fs_mmp_update(fs);
+	if (retval == EXT2_ET_MMP_CHANGE_ABORT)
+		dump_mmp_msg(fs->mmp_cmp,
+			     _("UNEXPECTED INCONSISTENCY: the filesystem is "
+			       "being modified while fsck is running.\n"));
+
+	return retval;
+}
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 916d0fe..63486f3 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -81,8 +81,10 @@ static struct feature feature_list[] = {
 			"meta_bg" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
+			"mmp" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
-                        "flex_bg"},
+			"flex_bg"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 259eea1..f05e16d 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -408,6 +408,12 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "Last error block #:       %llu\n",
 			sb->s_last_error_block);
 	}
+	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+		fprintf(f, "MMP block number:         %llu\n",
+			(long long)sb->s_mmp_block);
+		fprintf(f, "MMP update interval:      %u\n",
+			sb->s_mmp_update_interval);
+	}
 	if (sb->s_usr_quota_inum)
 		fprintf(f, "User quota inode:         %u\n",
 			sb->s_usr_quota_inum);
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 77e18d8..0d05ffc 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -65,6 +65,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
+	mmp.o \
 	namei.o \
 	native.o \
 	newdir.o \
@@ -136,6 +137,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/lookup.c \
 	$(srcdir)/mkdir.c \
 	$(srcdir)/mkjournal.c \
+	$(srcdir)/mmp.c	\
 	$(srcdir)/namei.c \
 	$(srcdir)/native.c \
 	$(srcdir)/newdir.c \
@@ -732,6 +734,12 @@ mkjournal.o: $(srcdir)/mkjournal.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/bitops.h $(srcdir)/jfs_user.h $(srcdir)/kernel-jbd.h \
  $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
+mmp.o: $(srcdir)/mmp.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
+ $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
+ $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h
 namei.o: $(srcdir)/namei.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 9141944..7652bf0 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -451,6 +451,11 @@ errcode_t ext2fs_close(ext2_filsys fs)
 		if (retval)
 			return retval;
 	}
+
+	retval = ext2fs_mmp_stop(fs);
+	if (retval)
+		return retval;
+
 	ext2fs_free(fs);
 	return 0;
 }
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 995ddc3..e759b6f 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -422,4 +422,25 @@ ec	EXT2_NO_MTAB_FILE,
 ec	EXT2_ET_CANT_USE_LEGACY_BITMAPS,
 	"Filesystem too large to use legacy bitmaps"
 
+ec	EXT2_ET_MMP_MAGIC_INVALID,
+	"MMP: invalid magic number"
+
+ec	EXT2_ET_MMP_FAILED,
+	"MMP: device currently active"
+
+ec	EXT2_ET_MMP_FSCK_ON,
+	"MMP: fsck being run"
+
+ec	EXT2_ET_MMP_BAD_BLOCK,
+	"MMP: block number beyond filesystem range"
+
+ec	EXT2_ET_MMP_UNKNOWN_SEQ,
+	"MMP: undergoing an unknown operation"
+
+ec	EXT2_ET_MMP_CHANGE_ABORT,
+	"MMP: filesystem still in use"
+
+ec	EXT2_ET_MMP_OPEN_DIRECT,
+	"MMP: open with O_DIRECT failed"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0e73ed2..0f8cde8 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -614,7 +614,7 @@ struct ext2_super_block {
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
 	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
+	__u16   s_mmp_update_interval;  /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
@@ -721,7 +721,8 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
+				       EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -802,28 +803,52 @@ struct ext2_dir_entry_2 {
 					 ~EXT2_DIR_ROUND)
 
 /*
- * This structure will be used for multiple mount protection. It will be
- * written into the block number saved in the s_mmp_block field in the
- * superblock.
+ * This structure is used for multiple mount protection. It is written
+ * into the block number saved in the s_mmp_block field in the superblock.
+ * Programs that check MMP should assume that if SEQ_FSCK (or any unknown
+ * code above SEQ_MAX) is present then it is NOT safe to use the filesystem,
+ * regardless of how old the timestamp is.
+ *
+ * The timestamp in the MMP structure will be updated by e2fsck at some
+ * arbitary intervals (start of passes, after every few groups of inodes
+ * in pass1 and pass1b).  There is no guarantee that e2fsck is updating
+ * the MMP block in a timely manner, and the updates it does are purely
+ * for the convenience of the sysadmin and not for automatic validation.
+ *
+ * Note: Only the mmp_seq value is used to determine whether the MMP block
+ *	is being updated.  The mmp_time, mmp_nodename, and mmp_bdevname
+ *	fields are only for informational purposes for the administrator,
+ *	due to clock skew between nodes and hostname HA service takeover.
  */
-#define	EXT2_MMP_MAGIC    0x004D4D50 /* ASCII for MMP */
-#define	EXT2_MMP_CLEAN    0xFF4D4D50 /* Value of mmp_seq for clean unmount */
-#define	EXT2_MMP_FSCK_ON  0xE24D4D50 /* Value of mmp_seq when being fscked */
+#define EXT4_MMP_MAGIC     0x004D4D50U /* ASCII for MMP */
+#define EXT4_MMP_SEQ_CLEAN 0xFF4D4D50U /* mmp_seq value for clean unmount */
+#define EXT4_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */
+#define EXT4_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */
 
 struct mmp_struct {
-	__u32	mmp_magic;
-	__u32	mmp_seq;
-	__u64	mmp_time;
-	char	mmp_nodename[64];
-	char	mmp_bdevname[32];
-	__u16	mmp_interval;
+	__u32	mmp_magic;		/* Magic number for MMP */
+	__u32	mmp_seq;		/* Sequence no. updated periodically */
+	__u64	mmp_time;		/* Time last updated */
+	char	mmp_nodename[64];	/* Node which last updated MMP block */
+	char	mmp_bdevname[32];	/* Bdev which last updated MMP block */
+	__u16	mmp_check_interval;	/* Changed mmp_check_interval */
 	__u16	mmp_pad1;
-	__u32	mmp_pad2;
+	__u32	mmp_pad2[227];
 };
 
 /*
- * Interval in number of seconds to update the MMP sequence number.
+ * Default interval for MMP update in seconds.
+ */
+#define EXT4_MMP_UPDATE_INTERVAL	5
+
+/*
+ * Maximum interval for MMP update in seconds.
+ */
+#define EXT4_MMP_MAX_UPDATE_INTERVAL	300
+
+/*
+ * Minimum interval for MMP checking in seconds.
  */
-#define EXT2_MMP_DEF_INTERVAL	5
+#define EXT4_MMP_MIN_CHECK_INTERVAL     5
 
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ab47621..e516c73 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -195,6 +195,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_64BITS		0x20000
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
+#define EXT2_FLAG_SKIP_MMP		0x100000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -257,6 +258,18 @@ struct struct_ext2_filsys {
 	io_channel			image_io;
 
 	/*
+	 * Buffers for Multiple mount protection(MMP) block.
+	 */
+	void *mmp_buf;
+	void *mmp_cmp;
+	int mmp_fd;
+
+	/*
+	 * Time at which e2fsck last updated the MMP block.
+	 */
+	long mmp_last_written;
+
+	/*
 	 * More callback functions
 	 */
 	errcode_t (*get_alloc_block)(ext2_filsys fs, blk64_t goal,
@@ -549,6 +562,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
@@ -557,6 +571,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
@@ -1321,6 +1336,16 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 			ext2_ino_t ino, int flags);
 
+/* mmp.c */
+errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
+errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
+errcode_t ext2fs_mmp_clear(ext2_filsys fs);
+errcode_t ext2fs_mmp_init(ext2_filsys fs);
+errcode_t ext2fs_mmp_start(ext2_filsys fs);
+errcode_t ext2fs_mmp_update(ext2_filsys fs);
+errcode_t ext2fs_mmp_stop(ext2_filsys fs);
+unsigned ext2fs_mmp_new_seq();
+
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
 				      ext2_badblocks_list *bb_list);
@@ -1356,6 +1381,7 @@ extern void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 				   int bufsize);
 extern void ext2fs_swap_inode(ext2_filsys fs,struct ext2_inode *t,
 			      struct ext2_inode *f, int hostorder);
+extern void ext2fs_swap_mmp(struct mmp_struct *mmp);
 
 /* valid_blk.c */
 extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 52ff570..28c4132 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -54,6 +54,11 @@ void ext2fs_free(ext2_filsys fs)
 	if (fs->icache)
 		ext2fs_free_inode_cache(fs->icache);
 
+	if (fs->mmp_buf)
+		ext2fs_free_mem(&fs->mmp_buf);
+	if (fs->mmp_cmp)
+		ext2fs_free_mem(&fs->mmp_cmp);
+
 	fs->magic = 0;
 
 	ext2fs_free_mem(&fs);
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
new file mode 100644
index 0000000..5d0d39d
--- /dev/null
+++ b/lib/ext2fs/mmp.c
@@ -0,0 +1,417 @@
+/*
+ * Helper functions for multiple mount protection (MMP).
+ *
+ * Copyright (C) 2011 Whamcloud, Inc.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <sys/time.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+static int mmp_pagesize(void)
+{
+#ifdef _SC_PAGESIZE
+	int sysval = sysconf(_SC_PAGESIZE);
+	if (sysval > 0)
+		return sysval;
+#endif /* _SC_PAGESIZE */
+#ifdef HAVE_GETPAGESIZE
+	return getpagesize();
+#else
+	return 4096;
+#endif
+}
+
+#ifndef O_DIRECT
+#define O_DIRECT 0
+#endif
+
+errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
+{
+	struct mmp_struct *mmp_cmp;
+	errcode_t retval = 0;
+
+	if ((mmp_blk <= fs->super->s_first_data_block) ||
+	    (mmp_blk >= fs->super->s_blocks_count))
+		return EXT2_ET_MMP_BAD_BLOCK;
+
+	if (fs->mmp_cmp == NULL) {
+		/* O_DIRECT in linux 2.4: page aligned
+		 * O_DIRECT in linux 2.6: sector aligned
+		 * A filesystem cannot be created with blocksize < sector size,
+		 * or with blocksize > page_size. */
+		int bufsize = fs->blocksize;
+
+		if (bufsize < mmp_pagesize())
+			bufsize = mmp_pagesize();
+		retval = ext2fs_get_memalign(bufsize, bufsize, &fs->mmp_cmp);
+		if (retval)
+			return retval;
+	}
+
+	/* ext2fs_open() reserves fd0,1,2 to avoid stdio collision, so checking
+	 * mmp_fd <= 0 is OK to validate that the fd is valid.  This opens its
+	 * own fd to read the MMP block to ensure that it is using O_DIRECT,
+	 * regardless of how the io_manager is doing reads, to avoid caching of
+	 * the MMP block by the io_manager or the VM.  It needs to be fresh. */
+	if (fs->mmp_fd <= 0) {
+		fs->mmp_fd = open(fs->device_name, O_RDWR | O_DIRECT);
+		if (fs->mmp_fd < 0) {
+			retval = EXT2_ET_MMP_OPEN_DIRECT;
+			goto out;
+		}
+	}
+
+	if (ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize, SEEK_SET) !=
+	    mmp_blk * fs->blocksize) {
+		retval = EXT2_ET_LLSEEK_FAILED;
+		goto out;
+	}
+
+	if (read(fs->mmp_fd, fs->mmp_cmp, fs->blocksize) != fs->blocksize) {
+		retval = EXT2_ET_SHORT_READ;
+		goto out;
+	}
+
+	mmp_cmp = fs->mmp_cmp;
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		ext2fs_swap_mmp(mmp_cmp);
+#endif
+
+	if (buf != NULL && buf != fs->mmp_cmp)
+		memcpy(buf, fs->mmp_cmp, fs->blocksize);
+
+	if (mmp_cmp->mmp_magic != EXT4_MMP_MAGIC) {
+		retval = EXT2_ET_MMP_MAGIC_INVALID;
+		goto out;
+	}
+
+out:
+	return retval;
+}
+
+errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
+{
+	struct mmp_struct *mmp_s = buf;
+	struct timeval tv;
+	errcode_t retval = 0;
+
+	gettimeofday(&tv, 0);
+	mmp_s->mmp_time = tv.tv_sec;
+	fs->mmp_last_written = tv.tv_sec;
+
+	if (fs->super->s_mmp_block < fs->super->s_first_data_block ||
+	    fs->super->s_mmp_block > ext2fs_blocks_count(fs->super))
+		return EXT2_ET_MMP_BAD_BLOCK;
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+		ext2fs_swap_mmp(mmp_s);
+#endif
+
+	/* I was tempted to make this use O_DIRECT and the mmp_fd, but
+	 * this caused no end of grief, while leaving it as-is works. */
+	retval = io_channel_write_blk64(fs->io, mmp_blk, -fs->blocksize, buf);
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+		ext2fs_swap_mmp(mmp_s);
+#endif
+
+	/* Make sure the block gets to disk quickly */
+	io_channel_flush(fs->io);
+	return retval;
+}
+
+#ifdef HAVE_SRANDOM
+#define srand(x) 	srandom(x)
+#define rand() 		random()
+#endif
+
+unsigned ext2fs_mmp_new_seq()
+{
+	unsigned new_seq;
+	struct timeval tv;
+
+	gettimeofday(&tv, 0);
+	srand((getpid() << 16) ^ getuid() ^ tv.tv_sec ^ tv.tv_usec);
+
+	gettimeofday(&tv, 0);
+	/* Crank the random number generator a few times */
+	for (new_seq = (tv.tv_sec ^ tv.tv_usec) & 0x1F; new_seq > 0; new_seq--)
+		rand();
+
+	do {
+		new_seq = rand();
+	} while (new_seq > EXT4_MMP_SEQ_MAX);
+
+	return new_seq;
+}
+
+static errcode_t ext2fs_mmp_reset(ext2_filsys fs)
+{
+	struct mmp_struct *mmp_s = NULL;
+	errcode_t retval = 0;
+
+	if (fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (retval)
+			goto out;
+	}
+
+	memset(fs->mmp_buf, 0, fs->blocksize);
+	mmp_s = fs->mmp_buf;
+
+	mmp_s->mmp_magic = EXT4_MMP_MAGIC;
+	mmp_s->mmp_seq = EXT4_MMP_SEQ_CLEAN;
+	mmp_s->mmp_time = 0;
+#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
+#else
+	mmp_s->mmp_nodename[0] = '\0';
+#endif
+	strncpy(mmp_s->mmp_bdevname, fs->device_name,
+		sizeof(mmp_s->mmp_bdevname));
+
+	mmp_s->mmp_check_interval = fs->super->s_mmp_update_interval;
+	if (mmp_s->mmp_check_interval < EXT4_MMP_MIN_CHECK_INTERVAL)
+		mmp_s->mmp_check_interval = EXT4_MMP_MIN_CHECK_INTERVAL;
+
+	retval = ext2fs_mmp_write(fs, fs->super->s_mmp_block, fs->mmp_buf);
+out:
+	return retval;
+}
+
+errcode_t ext2fs_mmp_clear(ext2_filsys fs)
+{
+	errcode_t retval = 0;
+
+	if (!(fs->flags & EXT2_FLAG_RW))
+		return EXT2_ET_RO_FILSYS;
+
+	retval = ext2fs_mmp_reset(fs);
+
+	return retval;
+}
+
+errcode_t ext2fs_mmp_init(ext2_filsys fs)
+{
+	struct ext2_super_block *sb = fs->super;
+	blk64_t mmp_block;
+	errcode_t retval;
+
+	if (sb->s_mmp_update_interval == 0)
+		sb->s_mmp_update_interval = EXT4_MMP_UPDATE_INTERVAL;
+	/* This is probably excessively large, but who knows? */
+	else if (sb->s_mmp_update_interval > EXT4_MMP_MAX_UPDATE_INTERVAL)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (retval)
+			goto out;
+	}
+
+	retval = ext2fs_alloc_block2(fs, 0, fs->mmp_buf, &mmp_block);
+	if (retval)
+		goto out;
+
+	sb->s_mmp_block = mmp_block;
+
+	retval = ext2fs_mmp_reset(fs);
+	if (retval)
+		goto out;
+
+out:
+	return retval;
+}
+
+/*
+ * Make sure that the fs is not mounted or being fsck'ed while opening the fs.
+ */
+errcode_t ext2fs_mmp_start(ext2_filsys fs)
+{
+	struct mmp_struct *mmp_s;
+	unsigned seq;
+	unsigned int mmp_check_interval;
+	errcode_t retval = 0;
+
+	if (fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (retval)
+			goto mmp_error;
+	}
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	mmp_s = fs->mmp_buf;
+
+	mmp_check_interval = fs->super->s_mmp_update_interval;
+	if (mmp_check_interval < EXT4_MMP_MIN_CHECK_INTERVAL)
+		mmp_check_interval = EXT4_MMP_MIN_CHECK_INTERVAL;
+
+	seq = mmp_s->mmp_seq;
+	if (seq == EXT4_MMP_SEQ_CLEAN)
+		goto clean_seq;
+	if (seq == EXT4_MMP_SEQ_FSCK) {
+		retval = EXT2_ET_MMP_FSCK_ON;
+		goto mmp_error;
+	}
+
+	if (seq > EXT4_MMP_SEQ_FSCK) {
+		retval = EXT2_ET_MMP_UNKNOWN_SEQ;
+		goto mmp_error;
+	}
+
+	/*
+	 * If check_interval in MMP block is larger, use that instead of
+	 * check_interval from the superblock.
+	 */
+	if (mmp_s->mmp_check_interval > mmp_check_interval)
+		mmp_check_interval = mmp_s->mmp_check_interval;
+
+	sleep(2 * mmp_check_interval + 1);
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+clean_seq:
+	if (!(fs->flags & EXT2_FLAG_RW))
+		goto mmp_error;
+
+	mmp_s->mmp_seq = seq = ext2fs_mmp_new_seq();
+#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
+#else
+	strcpy(mmp_s->mmp_nodename, "unknown host");
+#endif
+	strncpy(mmp_s->mmp_bdevname, fs->device_name,
+		sizeof(mmp_s->mmp_bdevname));
+
+	retval = ext2fs_mmp_write(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	sleep(2 * mmp_check_interval + 1);
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+	mmp_s->mmp_seq = EXT4_MMP_SEQ_FSCK;
+	retval = ext2fs_mmp_write(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	return 0;
+
+mmp_error:
+	return retval;
+}
+
+/*
+ * Clear the MMP usage in the filesystem.  If this function returns an
+ * error EXT2_ET_MMP_CHANGE_ABORT it means the filesystem was modified
+ * by some other process while in use, and changes should be dropped, or
+ * risk filesystem corruption.
+ */
+errcode_t ext2fs_mmp_stop(ext2_filsys fs)
+{
+	struct mmp_struct *mmp, *mmp_cmp;
+	errcode_t retval = 0;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
+		goto mmp_error;
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	/* Check if the MMP block is not changed. */
+	mmp = fs->mmp_buf;
+	mmp_cmp = fs->mmp_cmp;
+	if (memcmp(mmp, mmp_cmp, sizeof(*mmp_cmp))) {
+		retval = EXT2_ET_MMP_CHANGE_ABORT;
+		goto mmp_error;
+	}
+
+	mmp_cmp->mmp_seq = EXT4_MMP_SEQ_CLEAN;
+	retval = ext2fs_mmp_write(fs, fs->super->s_mmp_block, fs->mmp_cmp);
+
+mmp_error:
+	if (fs->mmp_fd > 0) {
+		close(fs->mmp_fd);
+		fs->mmp_fd = -1;
+	}
+
+	return retval;
+}
+
+#define EXT2_MIN_MMP_UPDATE_INTERVAL 60
+
+/*
+ * Update the on-disk mmp buffer, after checking that it hasn't been changed.
+ */
+errcode_t ext2fs_mmp_update(ext2_filsys fs)
+{
+	struct mmp_struct *mmp, *mmp_cmp;
+	struct timeval tv;
+	errcode_t retval = 0;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
+		return 0;
+
+	gettimeofday(&tv, 0);
+	if (tv.tv_sec - fs->mmp_last_written < EXT2_MIN_MMP_UPDATE_INTERVAL)
+		return 0;
+
+	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, NULL);
+	if (retval)
+		goto mmp_error;
+
+	mmp = fs->mmp_buf;
+	mmp_cmp = fs->mmp_cmp;
+
+	if (memcmp(mmp, mmp_cmp, sizeof(*mmp_cmp)))
+		return EXT2_ET_MMP_CHANGE_ABORT;
+
+	mmp->mmp_time = tv.tv_sec;
+	mmp->mmp_seq = EXT4_MMP_SEQ_FSCK;
+	retval = ext2fs_mmp_write(fs, fs->super->s_mmp_block, fs->mmp_buf);
+
+mmp_error:
+	return retval;
+}
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index a986beb..0cefe3f 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -23,6 +23,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
 
 #include "ext2_fs.h"
 
@@ -83,6 +86,7 @@ errcode_t ext2fs_open(const char *name, int flags, int superblock,
  * 	EXT2_FLAG_FORCE - Open the filesystem even if some of the
  *				features aren't supported.
  *	EXT2_FLAG_JOURNAL_DEV_OK - Open an ext3 journal device
+ *	EXT2_FLAG_SKIP_MMP - Open without multi-mount protection check.
  */
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
@@ -380,6 +384,18 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs = fs;
+
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    !(flags & EXT2_FLAG_SKIP_MMP) &&
+	    (flags & (EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE))) {
+		retval = ext2fs_mmp_start(fs);
+		if (retval) {
+			fs->flags |= EXT2_FLAG_SKIP_MMP; /* just do cleanup */
+			ext2fs_mmp_stop(fs);
+			goto cleanup;
+		}
+	}
+
 	return 0;
 cleanup:
 	if (flags & EXT2_FLAG_NOFREE_ON_ERROR)
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index bc6d569..7962472 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -71,6 +71,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_min_extra_isize = ext2fs_swab16(sb->s_min_extra_isize);
 	sb->s_want_extra_isize = ext2fs_swab16(sb->s_want_extra_isize);
 	sb->s_flags = ext2fs_swab32(sb->s_flags);
+	sb->s_mmp_update_interval = ext2fs_swab16(sb->s_mmp_update_interval);
+	sb->s_mmp_block = ext2fs_swab64(sb->s_mmp_block);
 	sb->s_kbytes_written = ext2fs_swab64(sb->s_kbytes_written);
 	sb->s_snapshot_inum = ext2fs_swab32(sb->s_snapshot_inum);
 	sb->s_snapshot_id = ext2fs_swab32(sb->s_snapshot_id);
@@ -342,4 +344,12 @@ void ext2fs_swap_inode(ext2_filsys fs, struct ext2_inode *t,
 				sizeof(struct ext2_inode));
 }
 
+void ext2fs_swap_mmp(struct mmp_struct *mmp)
+{
+	mmp->mmp_magic = ext2fs_swab32(mmp->mmp_magic);
+	mmp->mmp_seq = ext2fs_swab32(mmp->mmp_seq);
+	mmp->mmp_time = ext2fs_swab64(mmp->mmp_time);
+	mmp->mmp_check_interval = ext2fs_swab16(mmp->mmp_check_interval);
+}
+
 #endif
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index bbc2508..6593652 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -101,7 +101,7 @@ void check_superblock_fields()
 	check_field(s_want_extra_isize);
 	check_field(s_flags);
 	check_field(s_raid_stride);
-	check_field(s_mmp_interval);
+	check_field(s_mmp_update_interval);
 	check_field(s_mmp_block);
 	check_field(s_raid_stripe_width);
 	check_field(s_log_groups_per_flex);
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 0dc03e1..e249c6b 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -198,6 +198,16 @@ option is still accepted for backwards compatibility.   The
 following extended options are supported:
 .RS 1.2i
 .TP
+.BI mmp_update_interval= interval
+Adjust the initial MMP update interval to
+.I interval
+seconds.  Specifying an
+.I interval
+of 0 means to use the default interval.  The specified interval must
+be less than 300 seconds.  Requires that the
+.B mmp
+feature be enabled.
+.TP
 .BI stride= stride-size
 Configure the filesystem for a RAID array with
 .I stride-size
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 1280b3b..3dcb3b7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -675,7 +675,21 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			*arg = 0;
 			arg++;
 		}
-		if (strcmp(token, "stride") == 0) {
+		if (strcmp(token, "mmp_update_interval") == 0) {
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			param->s_mmp_update_interval = strtoul(arg, &p, 0);
+			if (*p) {
+				fprintf(stderr,
+					_("Invalid mmp_update_interval: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
+		} else if (strcmp(token, "stride") == 0) {
 			if (!arg) {
 				r_usage++;
 				badopt = token;
@@ -823,6 +837,7 @@ static __u32 ok_features[3] = {
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
+		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
@@ -2500,6 +2515,19 @@ int main (int argc, char *argv[])
 			printf(_("done\n"));
 	}
 no_journal:
+	if (!super_only &&
+	    fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+		retval = ext2fs_mmp_init(fs);
+		if (retval) {
+			fprintf(stderr, _("\nError while enabling multiple "
+					  "mount protection feature."));
+			exit(1);
+		}
+		if (!quiet)
+			printf(_("Multiple mount protection is enabled "
+				 "with update interval %d seconds.\n"),
+			       fs->super->s_mmp_update_interval);
+	}
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
 				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 89bc1d9..a317ce9 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -172,6 +172,21 @@ separated, and may take an argument using the equals ('=') sign.
 The following extended options are supported:
 .RS 1.2i
 .TP
+.B clear_mmp
+Reset the MMP block (if any) back to the clean state.  Use only if
+absolutely certain the device is not currently mounted or being
+fscked, or major filesystem corruption can result.  Needs '-f'.
+.TP
+.BI mmp_update_interval= interval
+Adjust the initial MMP update interval to
+.I interval
+seconds.  Specifying an
+.I interval
+of 0 means to use the default interval.  The specified interval must
+be less than 300 seconds.  Requires that the
+.B mmp
+feature be enabled.
+.TP
 .BI stride= stride-size
 Configure the filesystem for a RAID array with
 .I stride-size
@@ -527,6 +542,11 @@ future.
 .B Tune2fs 
 only supports clearing this filesystem feature.
 .TP
+.B mmp
+Enable or disable multiple mount protection(MMP) feature. MMP helps to protect
+the filesystem from being multiply mounted and is useful in shared storage
+environments.
+.TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
 .TP
@@ -563,6 +583,9 @@ and
 .BR flex_bg
 features are only supported by the ext4 filesystem.
 .TP
+.BI \-p " mmp_check_interval"
+Set the desired MMP check interval in seconds. It is 5 seconds by default.
+.TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
 .TP
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index fa9728b..17c90ad 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -73,6 +73,7 @@ char *io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
 static int m_flag, M_flag, Q_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
 static int I_flag;
+static int clear_mmp;
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
@@ -116,7 +117,7 @@ static void usage(void)
 		  "[-g group]\n"
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options] [-l]\n"
 		  "\t[-m reserved_blocks_percent] "
-		  "[-o [^]mount_options[,...]] \n"
+		  "[-o [^]mount_options[,...]] [-p mmp_update_interval]\n"
 		  "\t[-r reserved_blocks_count] [-u user] [-C mount_count] "
 		  "[-L volume_label]\n"
 		  "\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
@@ -132,7 +133,8 @@ static __u32 ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -150,7 +152,8 @@ static __u32 clear_ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -163,7 +166,7 @@ static __u32 clear_ok_features[3] = {
 /*
  * Remove an external journal from the filesystem
  */
-static void remove_journal_device(ext2_filsys fs)
+static int remove_journal_device(ext2_filsys fs)
 {
 	char		*journal_path;
 	ext2_filsys	jfs;
@@ -254,13 +257,15 @@ no_valid_journal:
 		fputs(_("Cannot locate journal device. It was NOT removed\n"
 			"Use -f option to remove missing journal device.\n"),
 		      stderr);
-		exit(1);
+		return 1;
 	}
 	fs->super->s_journal_dev = 0;
 	uuid_clear(fs->super->s_journal_uuid);
 	ext2fs_mark_super_dirty(fs);
 	fputs(_("Journal removed\n"), stdout);
 	free(journal_path);
+
+	return 0;
 }
 
 /* Helper function for remove_journal_inode */
@@ -285,7 +290,7 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 /*
  * Remove the journal inode from the filesystem
  */
-static void remove_journal_inode(ext2_filsys fs)
+static errcode_t remove_journal_inode(ext2_filsys fs)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
@@ -295,14 +300,14 @@ static void remove_journal_inode(ext2_filsys fs)
 	if (retval) {
 		com_err(program_name, retval,
 			_("while reading journal inode"));
-		exit(1);
+		return retval;
 	}
 	if (ino == EXT2_JOURNAL_INO) {
 		retval = ext2fs_read_bitmaps(fs);
 		if (retval) {
 			com_err(program_name, retval,
 				_("while reading bitmaps"));
-			exit(1);
+			return retval;
 		}
 		retval = ext2fs_block_iterate3(fs, ino,
 					       BLOCK_FLAG_READ_ONLY, NULL,
@@ -310,7 +315,7 @@ static void remove_journal_inode(ext2_filsys fs)
 		if (retval) {
 			com_err(program_name, retval,
 				_("while clearing journal inode"));
-			exit(1);
+			return retval;
 		}
 		memset(&inode, 0, sizeof(inode));
 		ext2fs_mark_bb_dirty(fs);
@@ -321,25 +326,29 @@ static void remove_journal_inode(ext2_filsys fs)
 	if (retval) {
 		com_err(program_name, retval,
 			_("while writing journal inode"));
-		exit(1);
+		return retval;
 	}
 	fs->super->s_journal_inum = 0;
 	ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 /*
  * Update the default mount options
  */
-static void update_mntopts(ext2_filsys fs, char *mntopts)
+static int update_mntopts(ext2_filsys fs, char *mntopts)
 {
 	struct ext2_super_block *sb = fs->super;
 
 	if (e2p_edit_mntopts(mntopts, &sb->s_default_mount_opts, ~0)) {
 		fprintf(stderr, _("Invalid mount option set: %s\n"),
 			mntopts);
-		exit(1);
+		return 1;
 	}
 	ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 static void request_fsck_afterwards(ext2_filsys fs)
@@ -357,7 +366,7 @@ static void request_fsck_afterwards(ext2_filsys fs)
 /*
  * Update the feature set as provided by the user.
  */
-static void update_feature_set(ext2_filsys fs, char *features)
+static int update_feature_set(ext2_filsys fs, char *features)
 {
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *gd;
@@ -393,7 +402,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			fprintf(stderr, _("Setting filesystem feature '%s' "
 					  "not supported.\n"),
 				e2p_feature2string(type_err, mask_err));
-		exit(1);
+		return 1;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
@@ -403,22 +412,89 @@ static void update_feature_set(ext2_filsys fs, char *features)
 				"cleared when the filesystem is\n"
 				"unmounted or mounted "
 				"read-only.\n"), stderr);
-			exit(1);
+			return 1;
 		}
 		if (sb->s_feature_incompat &
 		    EXT3_FEATURE_INCOMPAT_RECOVER) {
 			fputs(_("The needs_recovery flag is set.  "
 				"Please run e2fsck before clearing\n"
 				"the has_journal flag.\n"), stderr);
-			exit(1);
+			return 1;
 		}
 		if (sb->s_journal_inum) {
-			remove_journal_inode(fs);
+			if (remove_journal_inode(fs))
+				return 1;
 		}
 		if (sb->s_journal_dev) {
-			remove_journal_device(fs);
+			if (remove_journal_device(fs))
+				return 1;
 		}
 	}
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP)) {
+		int error;
+
+		if ((mount_flags & EXT2_MF_MOUNTED) ||
+		    (mount_flags & EXT2_MF_READONLY)) {
+			fputs(_("The multiple mount protection feature can't \n"
+				"be set if the filesystem is mounted or \n"
+				"read-only.\n"), stderr);
+			return 1;
+		}
+
+		error = ext2fs_mmp_init(fs);
+		if (error) {
+			fputs(_("\nError while enabling multiple mount "
+				"protection feature."), stderr);
+			return 1;
+		}
+
+		/*
+		 * We want to update group desc with the new free blocks count
+		 */
+		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+
+		printf(_("Multiple mount protection has been enabled "
+			 "with update interval %ds.\n"),
+		       sb->s_mmp_update_interval);
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP)) {
+		int error;
+
+		if (mount_flags & EXT2_MF_READONLY) {
+			fputs(_("The multiple mount protection feature cannot\n"
+				"be disabled if the filesystem is readonly.\n"),
+				stderr);
+			return 1;
+		}
+
+		error = ext2fs_read_bitmaps(fs);
+		if (error) {
+			fputs(_("Error while reading bitmaps\n"), stderr);
+			return 1;
+		}
+
+		error = ext2fs_mmp_read(fs, sb->s_mmp_block, NULL);
+		if (error) {
+			struct mmp_struct *mmp_cmp = fs->mmp_cmp;
+
+			if (error == EXT2_ET_MMP_MAGIC_INVALID)
+				printf(_("Magic number in MMP block does not "
+					 "match. expected: %x, actual: %x\n"),
+					 EXT4_MMP_MAGIC, mmp_cmp->mmp_magic);
+			else
+				com_err(program_name, error,
+					_("while reading MMP block."));
+			goto mmp_error;
+		}
+
+		/* We need to force out the group descriptors as well */
+		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+		ext2fs_block_alloc_stats(fs, sb->s_mmp_block, -1);
+mmp_error:
+		sb->s_mmp_block = 0;
+		sb->s_mmp_update_interval = 0;
+	}
 
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		/*
@@ -443,7 +519,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			fputs(_("Clearing the flex_bg flag would "
 				"cause the the filesystem to be\n"
 				"inconsistent.\n"), stderr);
-			exit(1);
+			return 1;
 		}
 	}
 
@@ -455,7 +531,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 				"cleared when the filesystem is\n"
 				"unmounted or mounted "
 				"read-only.\n"), stderr);
-			exit(1);
+			return 1;
 		}
 	}
 
@@ -540,12 +616,14 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	    (old_features[E2P_FEATURE_INCOMPAT] != sb->s_feature_incompat) ||
 	    (old_features[E2P_FEATURE_RO_INCOMPAT] != sb->s_feature_ro_compat))
 		ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 /*
  * Add a journal to the filesystem.
  */
-static void add_journal(ext2_filsys fs)
+static int add_journal(ext2_filsys fs)
 {
 	unsigned long journal_blocks;
 	errcode_t	retval;
@@ -600,7 +678,7 @@ static void add_journal(ext2_filsys fs)
 			fprintf(stderr, "\n");
 			com_err(program_name, retval,
 				_("\n\twhile trying to create journal file"));
-			exit(1);
+			return retval;
 		} else
 			fputs(_("done\n"), stdout);
 		/*
@@ -612,11 +690,11 @@ static void add_journal(ext2_filsys fs)
 	}
 	print_check_message(fs->super->s_max_mnt_count,
 			    fs->super->s_checkinterval);
-	return;
+	return 0;
 
 err:
 	free(journal_device);
-	exit(1);
+	return 1;
 }
 
 void handle_quota_options(ext2_filsys fs)
@@ -916,7 +994,6 @@ static void parse_tune2fs_options(int argc, char **argv)
 			mntopts_cmd = optarg;
 			open_flag = EXT2_FLAG_RW;
 			break;
-			
 		case 'O':
 			if (features_cmd) {
 				com_err(program_name, 0,
@@ -1035,7 +1112,7 @@ void do_findfs(int argc, char **argv)
 }
 #endif
 
-static void parse_extended_opts(ext2_filsys fs, const char *opts)
+static int parse_extended_opts(ext2_filsys fs, const char *opts)
 {
 	char	*buf, *token, *next, *p, *arg;
 	int	len, hash_alg;
@@ -1046,7 +1123,7 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 	if (!buf) {
 		fprintf(stderr,
 			_("Couldn't allocate memory to parse options!\n"));
-		exit(1);
+		return 1;
 	}
 	strcpy(buf, opts);
 	for (token = buf; token && *token; token = next) {
@@ -1061,7 +1138,37 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 			*arg = 0;
 			arg++;
 		}
-		if (!strcmp(token, "test_fs")) {
+		if (strcmp(token, "clear-mmp") == 0 ||
+		    strcmp(token, "clear_mmp") == 0) {
+			clear_mmp = 1;
+		} else if (strcmp(token, "mmp_update_interval") == 0) {
+			unsigned long interval;
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			interval = strtoul(arg, &p, 0);
+			if (*p) {
+				fprintf(stderr,
+					_("Invalid mmp_update_interval: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
+			if (interval == 0) {
+				interval = EXT4_MMP_UPDATE_INTERVAL;
+			} else if (interval > EXT4_MMP_MAX_UPDATE_INTERVAL) {
+				fprintf(stderr,
+					_("mmp_update_interval too big: %lu\n"),
+					interval);
+				r_usage++;
+				continue;
+			}
+			printf(_("Setting multiple mount protection update "
+				 "interval to %lu seconds\n"), interval);
+			fs->super->s_mmp_update_interval = interval;
+			ext2fs_mark_super_dirty(fs);
+		} else if (!strcmp(token, "test_fs")) {
 			fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
 			printf("Setting test filesystem flag\n");
 			ext2fs_mark_super_dirty(fs);
@@ -1077,7 +1184,7 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 			stride = strtoul(arg, &p, 0);
 			if (*p) {
 				fprintf(stderr,
-				       _("Invalid RAID stride: %s\n"),
+					_("Invalid RAID stride: %s\n"),
 					arg);
 				r_usage++;
 				continue;
@@ -1137,6 +1244,7 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 			"and may take an argument which\n"
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
+			"\tclear_mmp\n"
 			"\thash_alg=<hash algorithm>\n"
 			"\tmount_opts=<extended default mount options>\n"
 			"\tstride=<RAID per-disk chunk size in blocks>\n"
@@ -1144,9 +1252,11 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 			"\ttest_fs\n"
 			"\t^test_fs\n"));
 		free(buf);
-		exit(1);
+		return 1;
 	}
 	free(buf);
+
+	return 0;
 }
 
 /*
@@ -1735,6 +1845,7 @@ int main(int argc, char **argv)
 	ext2_filsys fs;
 	struct ext2_super_block *sb;
 	io_manager io_ptr, io_ptr_orig = NULL;
+	int rc = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1764,14 +1875,37 @@ int main(int argc, char **argv)
 		io_ptr = unix_io_manager;
 
 retry_open:
+	if ((open_flag & EXT2_FLAG_RW) == 0 || f_flag)
+		open_flag |= EXT2_FLAG_SKIP_MMP;
+
+	open_flag |= EXT2_FLAG_64BITS;
+
+	/* keep the filesystem struct around to dump MMP data */
+	open_flag |= EXT2_FLAG_NOFREE_ON_ERROR;
+
 	retval = ext2fs_open2(device_name, io_options, open_flag,
 			      0, 0, io_ptr, &fs);
 	if (retval) {
-			com_err(program_name, retval,
-				_("while trying to open %s"),
+		com_err(program_name, retval,
+			_("while trying to open %s"),
 			device_name);
-		fprintf(stderr,
-			_("Couldn't find valid filesystem superblock.\n"));
+		if (retval == EXT2_ET_MMP_FSCK_ON ||
+		    retval == EXT2_ET_MMP_UNKNOWN_SEQ)
+			dump_mmp_msg(fs->mmp_buf,
+				     _("If you are sure the filesystem "
+				       "is not in use on any node, run:\n"
+				       "'tune2fs -f -E clear_mmp {device}'\n"));
+		else if (retval == EXT2_ET_MMP_FAILED)
+			dump_mmp_msg(fs->mmp_buf, NULL);
+		else if (retval == EXT2_ET_MMP_MAGIC_INVALID)
+			fprintf(stderr,
+				_("MMP block magic is bad. Try to fix it by "
+				  "running:\n'e2fsck -f %s'\n"), device_name);
+		else if (retval != EXT2_ET_MMP_FAILED)
+			fprintf(stderr,
+			     _("Couldn't find valid filesystem superblock.\n"));
+
+		ext2fs_free(fs);
 		exit(1);
 	}
 
@@ -1784,12 +1918,14 @@ retry_open:
 		if (new_inode_size == EXT2_INODE_SIZE(fs->super)) {
 			fprintf(stderr, _("The inode size is already %lu\n"),
 				new_inode_size);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		if (new_inode_size < EXT2_INODE_SIZE(fs->super)) {
 			fprintf(stderr, _("Shrinking the inode size is "
 					  "not supported\n"));
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 
 		/*
@@ -1798,8 +1934,10 @@ retry_open:
 		 */
 		io_ptr_orig = io_ptr;
 		retval = tune2fs_setup_tdb(device_name, &io_ptr);
-		if (retval)
-			exit(1);
+		if (retval) {
+			rc = 1;
+			goto closefs;
+		}
 		if (io_ptr != io_ptr_orig) {
 			ext2fs_close(fs);
 			goto retry_open;
@@ -1814,7 +1952,7 @@ retry_open:
 		printf("%.*s\n", (int) sizeof(sb->s_volume_name),
 		       sb->s_volume_name);
 		remove_error_table(&et_ext2_error_table);
-		exit(0);
+		goto closefs;
 	}
 
 	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
@@ -1822,7 +1960,8 @@ retry_open:
 		com_err("ext2fs_check_if_mount", retval,
 			_("while determining whether %s is mounted."),
 			device_name);
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 	/* Normally we only need to write out the superblock */
 	fs->flags |= EXT2_FLAG_SUPER_ONLY;
@@ -1853,7 +1992,8 @@ retry_open:
 			com_err(program_name, 0,
 				_("interval between checks is too big (%lu)"),
 				interval);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		sb->s_checkinterval = interval;
 		ext2fs_mark_super_dirty(fs);
@@ -1872,7 +2012,8 @@ retry_open:
 			com_err(program_name, 0,
 				_("reserved blocks count is too big (%llu)"),
 				reserved_blocks);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		ext2fs_r_blocks_count_set(sb, reserved_blocks);
 		ext2fs_mark_super_dirty(fs);
@@ -1896,7 +2037,8 @@ retry_open:
 	if (s_flag == 0) {
 		fputs(_("\nClearing the sparse superflag not supported.\n"),
 		      stderr);
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 	if (T_flag) {
 		sb->s_lastcheck = last_check_time;
@@ -1924,20 +2066,43 @@ retry_open:
 			sizeof(sb->s_last_mounted));
 		ext2fs_mark_super_dirty(fs);
 	}
-	if (mntopts_cmd)
-		update_mntopts(fs, mntopts_cmd);
-	if (features_cmd)
-		update_feature_set(fs, features_cmd);
-	if (extended_cmd)
-		parse_extended_opts(fs, extended_cmd);
-	if (journal_size || journal_device)
-		add_journal(fs);
+	if (mntopts_cmd) {
+		rc = update_mntopts(fs, mntopts_cmd);
+		if (rc)
+			goto closefs;
+	}
+	if (features_cmd) {
+		rc = update_feature_set(fs, features_cmd);
+		if (rc)
+			goto closefs;
+	}
+	if (extended_cmd) {
+		rc = parse_extended_opts(fs, extended_cmd);
+		if (rc)
+			goto closefs;
+		if (clear_mmp && !f_flag) {
+			fputs(_("Error in using clear_mmp. "
+				"It must be used with -f\n"),
+			      stderr);
+			goto closefs;
+		}
+	}
+	if (clear_mmp) {
+		rc = ext2fs_mmp_clear(fs);
+		goto closefs;
+	}
+	if (journal_size || journal_device) {
+		rc = add_journal(fs);
+		if (rc)
+			goto closefs;
+	}
 
 	if (Q_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The quota feature may only be changed when "
 				"the filesystem is unmounted.\n"), stderr);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		handle_quota_options(fs);
 	}
@@ -1968,7 +2133,8 @@ retry_open:
 			uuid_generate(sb->s_uuid);
 		} else if (uuid_parse(new_UUID, sb->s_uuid)) {
 			com_err(program_name, 0, _("Invalid UUID format\n"));
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		if (set_csum) {
 			for (i = 0; i < fs->group_desc_count; i++)
@@ -1982,7 +2148,8 @@ retry_open:
 			fputs(_("The inode size may only be "
 				"changed when the filesystem is "
 				"unmounted.\n"), stderr);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		if (fs->super->s_feature_incompat &
 		    EXT4_FEATURE_INCOMPAT_FLEX_BG) {
@@ -1990,7 +2157,8 @@ retry_open:
 				"filesystems with the flex_bg\n"
 				"feature enabled.\n"),
 			      stderr);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		/*
 		 * We want to update group descriptor also
@@ -2002,7 +2170,8 @@ retry_open:
 							new_inode_size);
 		} else {
 			printf(_("Failed to change inode size\n"));
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 	}
 
@@ -2029,5 +2198,12 @@ retry_open:
 	}
 	free(device_name);
 	remove_error_table(&et_ext2_error_table);
+
+closefs:
+	if (rc) {
+		ext2fs_mmp_stop(fs);
+		exit(1);
+	}
+
 	return (ext2fs_close(fs) ? 1 : 0);
 }
diff --git a/misc/util.c b/misc/util.c
index 4564b4e..05334a6 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -24,6 +24,7 @@
 #ifdef HAVE_SYS_STAT_H
 #include <sys/stat.h>
 #endif
+#include <time.h>
 
 #include "et/com_err.h"
 #include "e2p/e2p.h"
@@ -285,3 +286,16 @@ void print_check_message(unsigned int mnt, unsigned int check)
 		 "Use tune2fs -c or -i to override.\n"),
 	       mnt, ((double) check) / (3600 * 24));
 }
+
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+{
+
+	if (msg)
+		printf("MMP check failed: %s\n", msg);
+	if (mmp) {
+		time_t t = mmp->mmp_time;
+
+		printf("MMP error info: last update: %s node: %s device: %s\n",
+		       ctime(&t), mmp->mmp_nodename, mmp->mmp_bdevname);
+	}
+}
diff --git a/misc/util.h b/misc/util.h
index d05f17e..56a7765 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -24,3 +24,4 @@ extern void parse_journal_opts(const char *opts);
 extern void check_mount(const char *device, int force, const char *type);
 extern unsigned int figure_journal_size(int size, ext2_filsys fs);
 extern void print_check_message(unsigned int, unsigned int);
+extern void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
-- 
1.7.3.4

