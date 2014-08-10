From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: flush out the superblock and bitmaps before printing final messages
Date: Sun, 10 Aug 2014 17:33:44 -0400
Message-ID: <1407706424-22108-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Dan Jacobson <jidanni@jidanni.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53369 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaHJVdw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 17:33:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A user who sees the message

***** REBOOT LINUX *****

or

***** FILE SYSTEM WAS MODIFIED *****

might think that e2fsck was complete even though we haven't finished
writing out the superblock or bitmap blocks, and then either forcibly
reboot or power cycle the box, or yank the USB key out while the
storage device is still being written (before e2fsck exits).

So rearrange the exit path of e2fsck so that we flush out the dirty
superblock/bg descriptors/bitmaps before we print the final message.
Also clean up this code so that the flow of control is easier to
understand, and add error checking to catch any errors (normally
caused by I/O errors writing to the disk) for these final writebacks.

Addresses-Debian-Bugs: #757543, #757544
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Dan Jacobson <jidanni@jidanni.org>
---
 e2fsck/problem.c | 15 ++++++++++++
 e2fsck/problem.h |  9 +++++++
 e2fsck/unix.c    | 73 ++++++++++++++++++++++++++------------------------------
 3 files changed, 58 insertions(+), 39 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 57c2e39..be4bd0c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1737,6 +1737,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Update quota info for quota type %N"),
 	  PROMPT_NULL, PR_PREEN_OK },
 
+	/* Error setting block group checksum info */
+	{ PR_6_SET_BG_CHECKSUM,
+	  N_("Error setting @b @g checksum info: %m\n"),
+	  PROMPT_NULL, PR_FATAL },
+
+	/* Error writing file system info */
+	{ PR_6_FLUSH_FILESYSTEM,
+	  N_("Error writing file system info: %m\n"),
+	  PROMPT_NULL, PR_FATAL },
+
+	/* Error flushing writes to storage device */
+	{ PR_6_IO_FLUSH,
+	  N_("Error flushing writes to strage device: %m\n"),
+	  PROMPT_NULL, PR_FATAL },
+
 	{ 0 }
 };
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 3426a22..212ed35 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1059,6 +1059,15 @@ struct problem_context {
 /* Update quota information if it is inconsistent */
 #define PR_6_UPDATE_QUOTAS		0x060002
 
+/* Error setting block group checksum info */
+#define PR_6_SET_BG_CHECKSUM		0x060003
+
+/* Error writing file system info */
+#define PR_6_FLUSH_FILESYSTEM		0x060004
+
+/* Error flushing writes to storage device */
+#define PR_6_IO_FLUSH			0x060005
+
 /*
  * Function declarations
  */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index fc05bde..628faeb 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1177,7 +1177,7 @@ int main (int argc, char *argv[])
 	e2fsck_t	ctx;
 	blk64_t		orig_superblock;
 	struct problem_context pctx;
-	int flags, run_result;
+	int flags, run_result, was_changed;
 	int journal_size;
 	int sysval, sys_page_size = 4096;
 	int old_bitmaps;
@@ -1695,22 +1695,45 @@ no_journal:
 		ext2fs_close_free(&fs);
 		goto restart;
 	}
+	if (run_result & E2F_FLAG_ABORT)
+		fatal_error(ctx, _("aborted"));
+
+#ifdef MTRACE
+	mtrace_print("Cleanup");
+#endif
+	was_changed = ext2fs_test_changed(fs);
 	if (run_result & E2F_FLAG_CANCEL) {
 		log_out(ctx, _("%s: e2fsck canceled.\n"), ctx->device_name ?
 			ctx->device_name : ctx->filesystem_name);
 		exit_value |= FSCK_CANCELED;
-	}
-	if (run_result & E2F_FLAG_ABORT)
-		fatal_error(ctx, _("aborted"));
-	if (check_backup_super_block(ctx)) {
-		fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
+	} else if (!(ctx->options & E2F_OPT_READONLY)) {
+		if (ext2fs_test_valid(fs)) {
+			if (!(sb->s_state & EXT2_VALID_FS))
+				exit_value |= FSCK_NONDESTRUCT;
+			sb->s_state = EXT2_VALID_FS;
+			if (check_backup_super_block(ctx))
+				fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
+		} else
+			sb->s_state &= ~EXT2_VALID_FS;
+		if (!(ctx->flags & E2F_FLAG_TIME_INSANE))
+			sb->s_lastcheck = ctx->now;
+		sb->s_mnt_count = 0;
+		memset(((char *) sb) + EXT4_S_ERR_START, 0, EXT4_S_ERR_LEN);
+		pctx.errcode = ext2fs_set_gdt_csum(ctx->fs);
+		if (pctx.errcode)
+			fix_problem(ctx, PR_6_SET_BG_CHECKSUM, &pctx);
 		ext2fs_mark_super_dirty(fs);
 	}
 
-#ifdef MTRACE
-	mtrace_print("Cleanup");
-#endif
-	if (ext2fs_test_changed(fs)) {
+	e2fsck_write_bitmaps(ctx);
+	pctx.errcode = ext2fs_flush(ctx->fs);
+	if (pctx.errcode)
+		fix_problem(ctx, PR_6_FLUSH_FILESYSTEM, &pctx);
+	pctx.errcode = io_channel_flush(ctx->fs->io);
+	if (pctx.errcode)
+		fix_problem(ctx, PR_6_IO_FLUSH, &pctx);
+
+	if (was_changed) {
 		exit_value |= FSCK_NONDESTRUCT;
 		if (!(ctx->options & E2F_OPT_PREEN))
 			log_out(ctx, _("\n%s: ***** FILE SYSTEM WAS "
@@ -1741,37 +1764,9 @@ no_journal:
 		    (sb->s_state & EXT2_VALID_FS) &&
 		    !(sb->s_state & EXT2_ERROR_FS))
 			exit_value = 0;
-	} else {
+	} else
 		show_stats(ctx);
-		if (!(ctx->options & E2F_OPT_READONLY)) {
-			if (ext2fs_test_valid(fs)) {
-				if (!(sb->s_state & EXT2_VALID_FS))
-					exit_value |= FSCK_NONDESTRUCT;
-				sb->s_state = EXT2_VALID_FS;
-			} else
-				sb->s_state &= ~EXT2_VALID_FS;
-			sb->s_mnt_count = 0;
-			if (!(ctx->flags & E2F_FLAG_TIME_INSANE))
-				sb->s_lastcheck = ctx->now;
-			memset(((char *) sb) + EXT4_S_ERR_START, 0,
-			       EXT4_S_ERR_LEN);
-			ext2fs_mark_super_dirty(fs);
-		}
-	}
 
-	if ((run_result & E2F_FLAG_CANCEL) == 0 &&
-	    sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
-	    !(ctx->options & E2F_OPT_READONLY)) {
-		retval = ext2fs_set_gdt_csum(ctx->fs);
-		if (retval) {
-			com_err(ctx->program_name, retval, "%s",
-				_("while setting block group checksum info"));
-			fatal_error(ctx, 0);
-		}
-	}
