From: Johann Lombardi <johann@whamcloud.com>
Subject: [PATCH] Add multi-mount protection support to libext2fs (INCOMPAT_MMP feature).
Date: Sun,  3 Apr 2011 22:13:39 -0700
Message-ID: <1301894019-17281-1-git-send-email-johann@whamcloud.com>
Cc: Johann Lombardi <johann@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33751 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1DDFOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 01:14:42 -0400
Received: by pwi15 with SMTP id 15so1230445pwi.19
        for <linux-ext4@vger.kernel.org>; Sun, 03 Apr 2011 22:14:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This allows mke2fs, e2fsck, and others to detect if the filesystem is
mounted on a remote node (on SAN disks) and avoid corrupting the
filesystem. For e2fsprogs this only means that it check the MMP block
to see if the filesystem is in use, and mark the filesystem busy while
e2fsck is running on the system.

There is no requirement that e2fsck updates the MMP block in any regular
interval, but e2fsck does this occasionally to provide additional
information to the sysadmin in case of conflict.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Johann Lombardi <johann@whamcloud.com>
---
 debugfs/debug_cmds.ct       |    3 +
 debugfs/debugfs.c           |   35 ++++++
 debugfs/set_fields.c        |    2 +-
 e2fsck/e2fsck.c             |    4 +
 e2fsck/e2fsck.h             |    2 +
 e2fsck/journal.c            |    2 +
 e2fsck/pass1.c              |   13 ++
 e2fsck/pass1b.c             |    7 +
 e2fsck/problem.c            |   10 ++
 e2fsck/problem.h            |    5 +
 e2fsck/unix.c               |   83 ++++++++++++++-
 e2fsck/util.c               |   22 ++++
 lib/e2p/feature.c           |    4 +-
 lib/e2p/ls.c                |    6 +
 lib/ext2fs/Makefile.in      |    4 +
 lib/ext2fs/closefs.c        |    5 +
 lib/ext2fs/ext2_err.et.in   |   21 ++++
 lib/ext2fs/ext2_fs.h        |   39 ++++---
 lib/ext2fs/ext2fs.h         |   36 ++++++
 lib/ext2fs/freefs.c         |    5 +
 lib/ext2fs/openfs.c         |   16 +++
 lib/ext2fs/swapfs.c         |   10 ++
 lib/ext2fs/tst_super_size.c |    2 +-
 misc/mke2fs.c               |   15 +++-
 misc/tune2fs.8.in           |   13 ++
 misc/tune2fs.c              |  259 +++++++++++++++++++++++++++++++++++--------
 misc/util.c                 |    8 ++
 27 files changed, 562 insertions(+), 69 deletions(-)

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index 9b6c985..af4b504 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -163,5 +163,8 @@ request do_set_current_time, "Set current time to use when setting filesystme fi
 request do_supported_features, "Print features supported by this version of e2fsprogs",
 	supported_features;
 
+request do_dump_mmp, "Dump MMP information",
+	dump_mmp;
+
 end;
 
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index e441bc5..c6160fc 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -78,6 +78,8 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
 			"opening read-only because of catastrophic mode");
 		open_flags &= ~EXT2_FLAG_RW;
 	}
+	if (catastrophic)
+		open_flags |= EXT2_FLAG_SKIP_MMP;
 
 	retval = ext2fs_open(device, open_flags, superblock, blocksize,
 			     unix_io_manager, &current_fs);
@@ -2133,6 +2135,39 @@ void do_punch(int argc, char *argv[])
 	}
 }
 
+void do_dump_mmp(int argc, char *argv[])
+{
+	struct mmp_struct *mmp_s;
+	errcode_t retval = 0;
+
+	if (current_fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(current_fs->blocksize,
+					&current_fs->mmp_buf);
+		if (retval) {
+			com_err(argv[0], 0, "Could not allocate memory.\n");
+			return;
+	 	}
+	}
+
+	mmp_s = current_fs->mmp_buf;
+
+	retval = ext2fs_mmp_read(current_fs, current_fs->super->s_mmp_block,
+				 current_fs->mmp_buf);
+	if (retval) {
+		com_err(argv[0], retval, "Error reading MMP block.\n");
+		return;
+	}
+
+	fprintf(stdout, "MMP Block: %llu\n", current_fs->super->s_mmp_block);
+	fprintf(stdout, "MMP Update Interval: %d\n",
+		current_fs->super->s_mmp_update_interval);
+	fprintf(stdout, "MMP Check Interval: %d\n", mmp_s->mmp_check_interval);
+	fprintf(stdout, "MMP Sequence: %u\n", mmp_s->mmp_seq);
+	fprintf(stdout, "Last Update Time: %llu\n", mmp_s->mmp_time);
+	fprintf(stdout, "Node: %s\n", mmp_s->mmp_nodename);
+	fprintf(stdout, "Device: %s\n", mmp_s->mmp_bdevname);
+}
+
 static int source_file(const char *cmd_file, int sci_idx)
 {
 	FILE		*f;
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ac6bc25..efb8d1b 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -130,7 +130,7 @@ static struct field_set_info super_fields[] = {
 	{ "flags", &set_sb.s_flags, 4, parse_uint },
 	{ "raid_stride", &set_sb.s_raid_stride, 2, parse_uint },
 	{ "min_extra_isize", &set_sb.s_min_extra_isize, 4, parse_uint },
-	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
+	{ "mmp_update_interval", &set_sb.s_mmp_update_interval, 2, parse_uint },
 	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
 	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
 	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, 1, parse_uint },
diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index f1da97a..3fcc444 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -205,6 +205,7 @@ int e2fsck_run(e2fsck_t ctx)
 {
 	int	i;
 	pass_t	e2fsck_pass;
+	int error;
 
 #ifdef HAVE_SETJMP_H
 	if (setjmp(ctx->abort_loc)) {
@@ -217,6 +218,9 @@ int e2fsck_run(e2fsck_t ctx)
 	for (i=0; (e2fsck_pass = e2fsck_passes[i]); i++) {
 		if (ctx->flags & E2F_FLAG_RUN_RETURN)
 			break;
+		error = e2fsck_mmp_update(ctx->fs);
+		if (error)
+			fatal_error(ctx, 0);
 		e2fsck_pass(ctx);
 		if (ctx->progress)
 			(void) (ctx->progress)(ctx, 0, 0, 0);
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 486a71b..34dcf73 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -521,6 +521,8 @@ extern blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
 			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
 extern int write_all(int fd, char *buf, size_t count);
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
+errcode_t e2fsck_mmp_update(ext2_filsys fs);
 
 /* unix.c */
 extern void e2fsck_clear_progbar(e2fsck_t ctx);
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 93f685c..c43d57d 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -879,6 +879,8 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
 		ctx->fs->io->manager->get_stats(ctx->fs->io, &stats);
 	if (stats && stats->bytes_written)
 		kbytes_written = stats->bytes_written >> 10;
+
+	ext2fs_mmp_stop(ctx->fs);
 	ext2fs_free(ctx->fs);
 	retval = ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
 			     ctx->superblock, blocksize, io_ptr,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 67dd986..7e2f692 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -694,7 +694,20 @@ void e2fsck_pass1(e2fsck_t ctx)
 	    (fs->super->s_mtime < fs->super->s_inodes_count))
 		busted_fs_time = 1;
 
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    !(fs->super->s_mmp_block <= fs->super->s_first_data_block ||
+	      fs->super->s_mmp_block >= fs->super->s_blocks_count))
+		ext2fs_mark_block_bitmap2(ctx->block_found_map,
+					 fs->super->s_mmp_block);
+
 	while (1) {
+		if (ino % EXT2_MMP_INODE_INTERVAL == 0) {
+			errcode_t error;
+
+			error = e2fsck_mmp_update(fs);
+			if (error)
+				fatal_error(ctx, 0);
+		}
 		old_op = ehandler_operation(_("getting next inode from scan"));
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
 							  inode, inode_size);
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 155fcba..577087f 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -286,6 +286,13 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 	pb.pctx = &pctx;
 	pctx.str = "pass1b";
 	while (1) {
+		if (ino % EXT2_MMP_INODE_INTERVAL == 0) {
+			errcode_t error;
+
+			error = e2fsck_mmp_update(fs);
+			if (error)
+				fatal_error(ctx, 0);
+		}
 		pctx.errcode = ext2fs_get_next_inode(scan, &ino, &inode);
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			continue;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 8f0b211..170d61a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -933,6 +933,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error adjusting refcount for @a @b %b (@i %i): %m\n"),
 	  PROMPT_NONE, 0 },
 
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
 
 	/* Pass 1C: Scan directories for inodes with multiply-claimed blocks. */
 	{ PR_1C_PASS_HEADER,
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 7c4c156..08ae76c 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -227,6 +227,11 @@ struct problem_context {
 /* Block group checksum (latch question) */
 #define PR_0_GDT_CSUM_LATCH			0x00003E
 
+/* Superblock has invalid MMP block. */
+#define PR_0_MMP_INVALID_BLK			0x000043
+
+/* Superblock has invalid MMP magic. */
+#define PR_0_MMP_INVALID_MAGIC			0x000044
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 73cc2cf..4fd108f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -973,6 +973,70 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
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
+	if (mmp_check_interval < EXT2_MMP_MIN_CHECK_INTERVAL)
+		mmp_check_interval = EXT2_MMP_MIN_CHECK_INTERVAL;
+
+	/*
+ 	 * If check_interval in MMP block is larger, use that instead of
+	 * check_interval from the superblock.
+	 */
+	if (mmp_s->mmp_check_interval > mmp_check_interval)
+		mmp_check_interval = mmp_s->mmp_check_interval;
+
+	wait_time = mmp_check_interval * 2 + 1;
+
+	/* Print warning if e2fck will wait for more than 20 secs. */
+	if (wait_time > EXT2_MMP_MIN_CHECK_INTERVAL * 4) {
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
+		}
+	} else if (retval == EXT2_ET_MMP_FAILED) {
+		dump_mmp_msg(fs->mmp_buf, NULL);
+	} else if (retval == EXT2_ET_MMP_FSCK_ON) {
+		dump_mmp_msg(fs->mmp_buf,
+			     _("If you are sure that e2fsck "
+			       "is not running on any node then use "
+			       "'tune2fs -f -E clear_mmp {device}'\n"));
+	} else if (retval == EXT2_ET_MMP_MAGIC_INVALID) {
+		if (fix_problem(ctx, PR_0_MMP_INVALID_MAGIC, &pctx))
+			ext2fs_mmp_clear(fs);
+	}
+	return 1;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1042,6 +1106,8 @@ int main (int argc, char *argv[])
 				    _("need terminal for interactive repairs"));
 	}
 	ctx->superblock = ctx->use_superblock;
+
+	flags = EXT2_FLAG_SKIP_MMP;
 restart:
 #ifdef CONFIG_TESTIO_DEBUG
 	if (getenv("TEST_IO_FLAGS") || getenv("TEST_IO_BLOCK")) {
@@ -1050,7 +1116,7 @@ restart:
 	} else
 #endif
 		io_ptr = unix_io_manager;
-	flags = EXT2_FLAG_NOFREE_ON_ERROR;
+	flags |= EXT2_FLAG_NOFREE_ON_ERROR;
 	profile_get_boolean(ctx->profile, "options", "old_bitmaps", 0, 0,
 			    &old_bitmaps);
 	if (!old_bitmaps)
@@ -1223,6 +1289,21 @@ failure:
 
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
+		flags &=~EXT2_FLAG_SKIP_MMP;
+		goto restart;
+	}
+
 	if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
 	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER))
 		goto skip_journal;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index fa156a1..86f4fc0 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -48,6 +48,7 @@ void fatal_error(e2fsck_t ctx, const char *msg)
 	if (msg)
 		fprintf (stderr, "e2fsck: %s\n", msg);
 	if (ctx->fs && ctx->fs->io) {
+		ext2fs_mmp_stop(ctx->fs);
 		if (ctx->fs->io->magic == EXT2_ET_MAGIC_IO_CHANNEL)
 			io_channel_flush(ctx->fs->io);
 		else
@@ -709,3 +710,24 @@ int write_all(int fd, char *buf, size_t count)
 	}
 	return c;
 }
+
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+{
+	if (msg)
+		printf("MMP check failed: %s\n", msg);
+	printf("MMP failure info: last update time: %llu node: %s device: %s\n",
+	       (long long)mmp->mmp_time, mmp->mmp_nodename, mmp->mmp_bdevname);
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
index 16fba53..6482c80 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -77,7 +77,9 @@ static struct feature feature_list[] = {
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
-                        "flex_bg"},
+			"flex_bg"},
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
+			"mmp" },
 	{	0, 0, 0 },
 };
 
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 5e560ed..9e8472b 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -413,6 +413,12 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_grp_quota_inum)
 		fprintf(f, "Group quota inode:        %u\n",
 			sb->s_grp_quota_inum);
+	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+		fprintf(f, "MMP block number:         %llu\n",
+			(long long)sb->s_mmp_block);
+		fprintf(f, "MMP update interval:      %u\n",
+			sb->s_mmp_update_interval);
+	}
 }
 
 void list_super (struct ext2_super_block * s)
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 9c1c273..63845a6 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -64,6 +64,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
+	mmp.o \
 	namei.o \
 	native.o \
 	newdir.o \
@@ -132,6 +133,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/lookup.c \
 	$(srcdir)/mkdir.c \
 	$(srcdir)/mkjournal.c \
+	$(srcdir)/mmp.c	\
 	$(srcdir)/namei.c \
 	$(srcdir)/native.c \
 	$(srcdir)/newdir.c \
@@ -646,6 +648,8 @@ mkjournal.o: $(srcdir)/mkjournal.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/bitops.h $(srcdir)/jfs_user.h $(srcdir)/kernel-jbd.h \
  $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
+mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h
 namei.o: $(srcdir)/namei.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 7a23e46..0da41e9 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -455,6 +455,11 @@ errcode_t ext2fs_close(ext2_filsys fs)
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
index a89e33b..8cc638f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -588,7 +588,7 @@ struct ext2_super_block {
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
 	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
+	__u16   s_mmp_update_interval;  /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
@@ -691,7 +691,8 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
+				       EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -774,26 +775,34 @@ struct ext2_dir_entry_2 {
 /*
  * This structure will be used for multiple mount protection. It will be
  * written into the block number saved in the s_mmp_block field in the
- * superblock.
+ * superblock. Programs that check MMP should assume that if SEQ_FSCK
+ * (or any unknown code above SEQ_MAX) is present then it is NOT safe
+ * to use the filesystem, regardless of how old the timestamp is.
  */
-#define	EXT2_MMP_MAGIC    0x004D4D50 /* ASCII for MMP */
-#define	EXT2_MMP_CLEAN    0xFF4D4D50 /* Value of mmp_seq for clean unmount */
-#define	EXT2_MMP_FSCK_ON  0xE24D4D50 /* Value of mmp_seq when being fscked */
+#define EXT2_MMP_MAGIC     0x004D4D50U /* ASCII for MMP */
+#define EXT2_MMP_SEQ_CLEAN 0xFF4D4D50U /* mmp_seq value for clean unmount */
+#define EXT2_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */
+#define EXT2_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */
 
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
+ * Default interval in seconds to update the MMP sequence number.
  */
-#define EXT2_MMP_DEF_INTERVAL	5
+#define EXT2_MMP_UPDATE_INTERVAL	1
+
+/*
+ * Minimum interval for MMP checking in seconds.
+ */
+#define EXT2_MMP_MIN_CHECK_INTERVAL     5
 
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d3eb31d..ccb04d6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -184,6 +184,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_64BITS		0x20000
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
+#define EXT2_FLAG_SKIP_MMP		0x100000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -200,6 +201,15 @@ typedef struct ext2_file *ext2_file_t;
 
 struct opaque_ext2_group_desc;
 
+/*
+ * The timestamp in the MMP structure will be updated by e2fsck at some
+ * arbitary intervals (start of passes, after every EXT2_MMP_INODE_INTERVAL
+ * inodes in pass1 and pass1b).  There is no guarantee that e2fsck is updating
+ * the MMP block in a timely manner, and the updates it does are purely for
+ * the convenience of the sysadmin and not for automatic validation.
+ */
+#define EXT2_MMP_INODE_INTERVAL 20000
+
 struct struct_ext2_filsys {
 	errcode_t			magic;
 	io_channel			io;
@@ -246,6 +256,19 @@ struct struct_ext2_filsys {
 	io_channel			image_io;
 
 	/*
+	 * Buffers for Multiple mount protection(MMP) block.
+	 */
+	void *mmp_buf;
+	void *mmp_unaligned_buf;
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
@@ -538,6 +561,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
@@ -546,6 +570,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
@@ -1280,6 +1305,16 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 			ext2_ino_t ino, int flags);
 
+/* mmp.c */
+errcode_t ext2fs_mmp_read(ext2_filsys fs, blk_t mmp_blk, void *buf);
+errcode_t ext2fs_mmp_write(ext2_filsys fs, blk_t mmp_blk, void *buf);
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
@@ -1315,6 +1350,7 @@ extern void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 				   int bufsize);
 extern void ext2fs_swap_inode(ext2_filsys fs,struct ext2_inode *t,
 			      struct ext2_inode *f, int hostorder);
+extern void ext2fs_swap_mmp(struct mmp_struct *mmp);
 
 /* valid_blk.c */
 extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 5c35bb6..5a151d1 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -53,6 +53,11 @@ void ext2fs_free(ext2_filsys fs)
 	if (fs->icache)
 		ext2fs_free_inode_cache(fs->icache);
 
+	if (fs->mmp_buf)
+		ext2fs_free_mem(&fs->mmp_buf);
+	if (fs->mmp_unaligned_buf)
+		ext2fs_free_mem(&fs->mmp_unaligned_buf);
+
 	fs->magic = 0;
 
 	ext2fs_free_mem(&fs);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 90abed1..aa1c8bd 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -22,6 +22,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
 
 #include "ext2_fs.h"
 
@@ -82,6 +85,7 @@ errcode_t ext2fs_open(const char *name, int flags, int superblock,
  * 	EXT2_FLAG_FORCE - Open the filesystem even if some of the
  *				features aren't supported.
  *	EXT2_FLAG_JOURNAL_DEV_OK - Open an ext3 journal device
+ *	EXT2_FLAG_SKIP_MMP - Open without multi-mount protection check.
  */
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
@@ -366,6 +370,18 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs = fs;
+
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    !(flags & EXT2_FLAG_SKIP_MMP)
+	    && (flags & (EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE))) {
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
index 3a43c6c..90c1e8b 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -70,6 +70,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_min_extra_isize = ext2fs_swab16(sb->s_min_extra_isize);
 	sb->s_want_extra_isize = ext2fs_swab16(sb->s_want_extra_isize);
 	sb->s_flags = ext2fs_swab32(sb->s_flags);
+	sb->s_mmp_update_interval = ext2fs_swab16(sb->s_mmp_update_interval);
+	sb->s_mmp_block = ext2fs_swab64(sb->s_mmp_block);
 	sb->s_kbytes_written = ext2fs_swab64(sb->s_kbytes_written);
 	sb->s_snapshot_inum = ext2fs_swab32(sb->s_snapshot_inum);
 	sb->s_snapshot_id = ext2fs_swab32(sb->s_snapshot_id);
@@ -312,4 +314,12 @@ void ext2fs_swap_inode(ext2_filsys fs, struct ext2_inode *t,
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
index 1e5a524..7a16995 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -100,7 +100,7 @@ void check_superblock_fields()
 	check_field(s_want_extra_isize);
 	check_field(s_flags);
 	check_field(s_raid_stride);
-	check_field(s_mmp_interval);
+	check_field(s_mmp_update_interval);
 	check_field(s_mmp_block);
 	check_field(s_raid_stripe_width);
 	check_field(s_log_groups_per_flex);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9798b88..832e7ec 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -808,6 +808,7 @@ static __u32 ok_features[3] = {
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
+		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
@@ -2366,7 +2367,19 @@ int main (int argc, char *argv[])
 			printf(_("done\n"));
 	}
 no_journal:
-
+	if (!super_only) {
+		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+			retval = ext2fs_mmp_init(fs);
+			if (retval) {
+				fprintf(stderr, _("\nError while enabling "
+					"multiple mount protection feature."));
+				exit(1);
+			}
+			printf(_("Multiple mount protection has been enabled "
+				 "with update interval %d seconds.\n"),
+				 fs->super->s_mmp_update_interval);
+		}
+	}
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 2f9db81..0f5c48c 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -167,6 +167,11 @@ separated, and may take an argument using the equals ('=') sign.
 The following extended options are supported:
 .RS 1.2i
 .TP
+.B clear-mmp
+Reset the MMP block (if any) back to the clean state.  Use only if
+absolutely certain the device is not currently mounted or being
+fscked, or major filesystem corruption can result.  Needs '-f'.
+.TP
 .BI stride= stride-size
 Configure the filesystem for a RAID array with
 .I stride-size
@@ -519,6 +524,11 @@ future.
 .B Tune2fs 
 only supports clearing this filesystem feature.
 .TP
+.B mmp
+Enable or disable multiple mount protection(MMP) feature. MMP helps to protect
+the filesystem from being multiply mounted and is useful in shared storage
+environment.
+.TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
 .TP
@@ -555,6 +565,9 @@ and
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
index bcada11..eea4e31 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -64,8 +64,9 @@ char *device_name;
 char *new_label, *new_last_mounted, *new_UUID;
 char *io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
-static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
+static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag, p_flag;
 static int I_flag;
+static int clear_mmp;
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
@@ -75,6 +76,7 @@ static double reserved_ratio;
 static unsigned long resgid, resuid;
 static unsigned short errors;
 static int open_flag;
+static unsigned int mmp_update_interval;
 static char *features_cmd;
 static char *mntopts_cmd;
 static int stride, stripe_width;
@@ -107,7 +109,7 @@ static void usage(void)
 		  "[-g group]\n"
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options] [-l]\n"
 		  "\t[-m reserved_blocks_percent] "
-		  "[-o [^]mount_options[,...]] \n"
+		  "[-o [^]mount_options[,...]] [-p mmp_update_interval]\n"
 		  "\t[-r reserved_blocks_count] [-u user] [-C mount_count] "
 		  "[-L volume_label]\n"
 		  "\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
@@ -123,7 +125,8 @@ static __u32 ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -140,7 +143,8 @@ static __u32 clear_ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -152,7 +156,7 @@ static __u32 clear_ok_features[3] = {
 /*
  * Remove an external journal from the filesystem
  */
-static void remove_journal_device(ext2_filsys fs)
+static int remove_journal_device(ext2_filsys fs)
 {
 	char		*journal_path;
 	ext2_filsys	jfs;
@@ -241,13 +245,15 @@ static void remove_journal_device(ext2_filsys fs)
 no_valid_journal:
 	if (commit_remove_journal == 0) {
 		fputs(_("Journal NOT removed\n"), stderr);
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
@@ -272,7 +278,7 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 /*
  * Remove the journal inode from the filesystem
  */
-static void remove_journal_inode(ext2_filsys fs)
+static errcode_t remove_journal_inode(ext2_filsys fs)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
@@ -282,14 +288,14 @@ static void remove_journal_inode(ext2_filsys fs)
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
@@ -297,7 +303,7 @@ static void remove_journal_inode(ext2_filsys fs)
 		if (retval) {
 			com_err(program_name, retval,
 				_("while clearing journal inode"));
-			exit(1);
+			return retval;
 		}
 		memset(&inode, 0, sizeof(inode));
 		ext2fs_mark_bb_dirty(fs);
@@ -308,25 +314,29 @@ static void remove_journal_inode(ext2_filsys fs)
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
@@ -344,7 +354,7 @@ static void request_fsck_afterwards(ext2_filsys fs)
 /*
  * Update the feature set as provided by the user.
  */
-static void update_feature_set(ext2_filsys fs, char *features)
+static int update_feature_set(ext2_filsys fs, char *features)
 {
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *gd;
@@ -381,7 +391,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			fprintf(stderr, _("Setting filesystem feature '%s' "
 					  "not supported.\n"),
 				e2p_feature2string(type_err, mask_err));
-		exit(1);
+		return 1;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
@@ -391,22 +401,89 @@ static void update_feature_set(ext2_filsys fs, char *features)
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
+					 EXT2_MMP_MAGIC, mmp_cmp->mmp_magic);
+			else
+				com_err (program_name, error,
+					 _("while reading MMP block."));
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
@@ -498,12 +575,14 @@ static void update_feature_set(ext2_filsys fs, char *features)
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
@@ -558,7 +637,7 @@ static void add_journal(ext2_filsys fs)
 			fprintf(stderr, "\n");
 			com_err(program_name, retval,
 				_("\n\twhile trying to create journal file"));
-			exit(1);
+			return retval;
 		} else
 			fputs(_("done\n"), stdout);
 		/*
@@ -569,11 +648,11 @@ static void add_journal(ext2_filsys fs)
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	}
 	print_check_message(fs);
-	return;
+	return 0;
 
 err:
 	free(journal_device);
-	exit(1);
+	return 1;
 }
 
 
@@ -641,7 +720,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	open_flag = 0;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:p:r:s:u:C:E:I:J:L:M:O:T:U:")) != EOF)
 		switch (c) {
 		case 'c':
 			max_mount_count = strtol(optarg, &tmp, 0);
@@ -796,6 +875,25 @@ static void parse_tune2fs_options(int argc, char **argv)
 			features_cmd = optarg;
 			open_flag = EXT2_FLAG_RW;
 			break;
+		case 'p':
+			mmp_update_interval = strtol(optarg, &tmp, 0);
+			if (*tmp && mmp_update_interval < 0) {
+				com_err(program_name, 0,
+					_("invalid mmp update interval"));
+				usage();
+			}
+			if (mmp_update_interval == 0)
+				mmp_update_interval = EXT2_MMP_UPDATE_INTERVAL;
+			if (mmp_update_interval > EXT2_MMP_UPDATE_INTERVAL) {
+				com_err(program_name, 0,
+					_("MMP update interval of %s seconds "
+					  "may be dangerous under high load.  "
+					  "Consider decreasing it."),
+					optarg);
+			}
+			p_flag = 1;
+			open_flag = EXT2_FLAG_RW;
+			break;
 		case 'r':
 			reserved_blocks = strtoul(optarg, &tmp, 0);
 			if (*tmp) {
@@ -900,7 +998,7 @@ void do_findfs(int argc, char **argv)
 }
 #endif
 
-static void parse_extended_opts(ext2_filsys fs, const char *opts)
+static int parse_extended_opts(ext2_filsys fs, const char *opts)
 {
 	char	*buf, *token, *next, *p, *arg;
 	int	len, hash_alg;
@@ -911,7 +1009,7 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 	if (!buf) {
 		fprintf(stderr,
 			_("Couldn't allocate memory to parse options!\n"));
-		exit(1);
+		return 1;
 	}
 	strcpy(buf, opts);
 	for (token = buf; token && *token; token = next) {
@@ -934,6 +1032,9 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 			fs->super->s_flags &= ~EXT2_FLAGS_TEST_FILESYS;
 			printf("Clearing test filesystem flag\n");
 			ext2fs_mark_super_dirty(fs);
+		} else if (strcmp(token, "clear-mmp") == 0 ||
+		           strcmp(token, "clear_mmp") == 0) {
+			clear_mmp = 1;
 		} else if (strcmp(token, "stride") == 0) {
 			if (!arg) {
 				r_usage++;
@@ -1003,15 +1104,18 @@ static void parse_extended_opts(ext2_filsys fs, const char *opts)
 			"and may take an argument which\n"
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
+			"\tclear-mmp\n"
 			"\tstride=<RAID per-disk chunk size in blocks>\n"
 			"\tstripe_width=<RAID stride*data disks in blocks>\n"
 			"\thash_alg=<hash algorithm>\n"
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
@@ -1591,6 +1695,7 @@ int main(int argc, char **argv)
 	ext2_filsys fs;
 	struct ext2_super_block *sb;
 	io_manager io_ptr, io_ptr_orig = NULL;
+	int rc = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1620,14 +1725,26 @@ int main(int argc, char **argv)
 		io_ptr = unix_io_manager;
 
 retry_open:
+	if ((open_flag & EXT2_FLAG_RW) == 0 || f_flag)
+		 open_flag |= EXT2_FLAG_SKIP_MMP;
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
+		if (retval == EXT2_ET_MMP_FSCK_ON)
+			fprintf(stderr,
+				_("If you are sure e2fsck is not running then "
+				  "use 'tune2fs -f -E clear_mmp {device}'\n"));
+		else if (retval == EXT2_ET_MMP_MAGIC_INVALID)
+			fprintf(stderr,
+				_("Magic for mmp is wrong. Try to fix it by "
+				  "using 'fsck {device}'\n"));
+		else if (retval != EXT2_ET_MMP_FAILED)
+			fprintf(stderr,
+			     _("Couldn't find valid filesystem superblock.\n"));
 		exit(1);
 	}
 
@@ -1640,12 +1757,14 @@ retry_open:
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
@@ -1654,8 +1773,10 @@ retry_open:
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
@@ -1670,7 +1791,7 @@ retry_open:
 		printf("%.*s\n", (int) sizeof(sb->s_volume_name),
 		       sb->s_volume_name);
 		remove_error_table(&et_ext2_error_table);
-		exit(0);
+		goto closefs;
 	}
 
 	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
@@ -1678,7 +1799,8 @@ retry_open:
 		com_err("ext2fs_check_if_mount", retval,
 			_("while determining whether %s is mounted."),
 			device_name);
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 	/* Normally we only need to write out the superblock */
 	fs->flags |= EXT2_FLAG_SUPER_ONLY;
@@ -1717,12 +1839,19 @@ retry_open:
 		printf (_("Setting reserved blocks percentage to %g%% (%llu blocks)\n"),
 			reserved_ratio, ext2fs_r_blocks_count(sb));
 	}
+	if (p_flag) {
+		sb->s_mmp_update_interval = mmp_update_interval;
+		ext2fs_mark_super_dirty(fs);
+		printf(_("Setting multiple mount protection update interval to "
+			  "%u seconds\n"), mmp_update_interval);
+	}
 	if (r_flag) {
 		if (reserved_blocks >= ext2fs_blocks_count(sb)/2) {
 			com_err(program_name, 0,
 				_("reserved blocks count is too big (%llu)"),
 				reserved_blocks);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		ext2fs_r_blocks_count_set(sb, reserved_blocks);
 		ext2fs_mark_super_dirty(fs);
@@ -1746,7 +1875,8 @@ retry_open:
 	if (s_flag == 0) {
 		fputs(_("\nClearing the sparse superflag not supported.\n"),
 		      stderr);
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 	if (T_flag) {
 		sb->s_lastcheck = last_check_time;
@@ -1774,14 +1904,36 @@ retry_open:
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
+			        "It must be used with -f\n"),
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
+		if (rc);
+			goto closefs;
+	}
 
 	if (U_flag) {
 		int set_csum = 0;
@@ -1809,7 +1961,8 @@ retry_open:
 			uuid_generate(sb->s_uuid);
 		} else if (uuid_parse(new_UUID, sb->s_uuid)) {
 			com_err(program_name, 0, _("Invalid UUID format\n"));
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		if (set_csum) {
 			for (i = 0; i < fs->group_desc_count; i++)
@@ -1823,7 +1976,8 @@ retry_open:
 			fputs(_("The inode size may only be "
 				"changed when the filesystem is "
 				"unmounted.\n"), stderr);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		if (fs->super->s_feature_incompat &
 		    EXT4_FEATURE_INCOMPAT_FLEX_BG) {
@@ -1858,5 +2012,12 @@ retry_open:
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
index 51bdb60..a22ba91 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -291,3 +291,11 @@ void print_check_message(ext2_filsys fs)
 	       fs->super->s_max_mnt_count,
 	       (double)fs->super->s_checkinterval / (3600 * 24));
 }
+
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+{
+	if (msg)
+		printf("MMP check failed: %s\n", msg);
+	printf("MMP failure info: last update time: %llu node: %s device: %s\n",
+	       (long long)mmp->mmp_time, mmp->mmp_nodename, mmp->mmp_bdevname);
+}
-- 
1.7.1

