From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] e2fsprogs: Check journal inode sanity and recreate
	journal
Date: Fri, 25 May 2007 02:52:22 +0530
Message-ID: <1180041743.3770.5.camel@garfield>
References: <1173906827.3076.5.camel@garfield>
	 <20070508054034.GA28110@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-KmYI8nNlkX0gp7RPbt/w"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46426 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXEXVTB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 17:19:01 -0400
In-Reply-To: <20070508054034.GA28110@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-KmYI8nNlkX0gp7RPbt/w
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-05-08 at 01:40 -0400, Theodore Tso wrote:
> On Thu, Mar 15, 2007 at 02:43:47AM +0530, Kalpak Shah wrote:
> > Index: e2fsprogs-1.39/lib/ext2fs/mkjournal.c
> > ===================================================================
> > --- e2fsprogs-1.39.orig/lib/ext2fs/mkjournal.c
> > +++ e2fsprogs-1.39/lib/ext2fs/mkjournal.c
> > +	if (fs->super->s_blocks_count < 2048) {
> > +		fputs(("\nFilesystem too small for a journal\n"), stderr);
> > +		return 0;
> > +	}
> 
> Code in lib/ext2fs isn't allowed to do any output to stdio (except for
> debugging purposes).  It causes internationalization problems, and
> it's just in general a bad idea for ext2fs library code to try to do
> any UI.
> 
> 						- Ted

Hi Ted,

I have reworked the patch to make sure that lib/ext2fs does not do any
output. Added that to my mistakes-not-to-be-made-again list.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Thanks,
Kalpak.

--=-KmYI8nNlkX0gp7RPbt/w
Content-Disposition: attachment; filename=recreate-journal.patch
Content-Type: text/x-patch; name=recreate-journal.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: e2fsprogs-1.40/e2fsck/journal.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/journal.c
+++ e2fsprogs-1.40/e2fsck/journal.c
@@ -206,6 +206,7 @@ static errcode_t e2fsck_get_journal(e2fs
 	int			ext_journal = 0;
 	int			tried_backup_jnl = 0;
 	int			i;
+	blk_t			lblock;
 		
 	clear_problem_context(&pctx);
 	
@@ -283,6 +284,13 @@ static errcode_t e2fsck_get_journal(e2fs
 				goto try_backup_journal;
 			}
 		}
+		if (tried_backup_jnl && !(ctx->options & E2F_OPT_READONLY)) {
+			retval = ext2fs_write_inode(ctx->fs, sb->s_journal_inum,
+						    &j_inode->i_ext2);
+			if (retval)
+				goto errout;
+		}
+
 		journal->j_maxlen = j_inode->i_ext2.i_size / journal->j_blocksize;
 
 #ifdef USE_INODE_IO
@@ -299,6 +307,20 @@ static errcode_t e2fsck_get_journal(e2fs
 		if ((retval = journal_bmap(journal, 0, &start)) != 0)
 			goto errout;
 #endif
+		for (lblock = 0; lblock < j_inode->i_ext2.i_size /
+	    				journal->j_blocksize; lblock++) {
+			blk_t pblock;
+
+			if ((retval = journal_bmap(journal, lblock,
+			     &pblock)) != 0) {
+				goto errout;
+			}
+			if (pblock == 0 || pblock < sb->s_first_data_block ||
+			    pblock >= sb->s_blocks_count) {
+				retval = EXT2_ET_BAD_BLOCK_NUM;
+				goto errout;
+			}
+		}
 	} else {
 		ext_journal = 1;
 		if (!ctx->journal_name) {
@@ -418,7 +440,7 @@ static errcode_t e2fsck_journal_fix_bad_
 				       "filesystem is now ext2 only ***\n\n");
 			sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 			sb->s_journal_inum = 0;
-			ctx->flags |= E2F_FLAG_JOURNAL_INODE; /* FIXME: todo */
+			ctx->flags |= E2F_FLAG_JOURNAL_INODE;
 			e2fsck_clear_recover(ctx, 1);
 			return 0;
 		}
Index: e2fsprogs-1.40/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/unix.c
+++ e2fsprogs-1.40/e2fsck/unix.c
@@ -849,6 +849,7 @@ int main (int argc, char *argv[])
 	e2fsck_t	ctx;
 	struct problem_context pctx;
 	int flags, run_result;
+	int journal_size;
 	
 	clear_problem_context(&pctx);
 #ifdef MTRACE
@@ -1143,8 +1144,47 @@ restart:
 			 " but we'll try to go on...\n"));
 	}
 
+	/*
+	 * Save the journal size in megabytes.
+	 * Try and use the journal size from the backup else let e2fsck
+	 * find the default journal size.
+	 */
+	if (sb->s_jnl_backup_type == EXT3_JNL_BACKUP_BLOCKS)
+		journal_size = sb->s_jnl_blocks[16] >> 20;
+	else
+		journal_size = -1;
+
 	run_result = e2fsck_run(ctx);
 	e2fsck_clear_progbar(ctx);
+
+	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
+		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
+			retval = ext2fs_figure_journal_size(&journal_size, fs);
+
+			if (journal_size && retval) {
+				fs->super->s_feature_compat &=
+					~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+				com_err("Error ", retval, _("\n\twhile "
+					"trying to create journal file"));
+				goto no_journal;
+			}
+			printf(_("Creating journal (%d blocks): "),
+			       journal_size);
+			fflush(stdout);
+			retval = ext2fs_add_journal_inode(fs,
+							  journal_size, 0);
+			if (retval) {
+				com_err("Error ", retval,
+					_("\n\twhile trying to create journal"));
+				goto no_journal;
+			}
+			printf(_(" Done.\n"));
+			printf(_("\n*** journal has been re-created - "
+				       "filesystem is now ext3 again ***\n"));
+		}
+	}
+no_journal:
+
 	if (run_result == E2F_FLAG_RESTART) {
 		printf(_("Restarting e2fsck from the beginning...\n"));
 		retval = e2fsck_reset_context(ctx);
Index: e2fsprogs-1.40/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2fs.h
@@ -879,6 +879,8 @@ extern errcode_t ext2fs_add_journal_devi
 					   ext2_filsys journal_dev);
 extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size,
 					  int flags);
+extern int ext2fs_figure_journal_size(int *size, ext2_filsys fs);
+
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
Index: e2fsprogs-1.40/lib/ext2fs/mkjournal.c
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/mkjournal.c
+++ e2fsprogs-1.40/lib/ext2fs/mkjournal.c
@@ -308,6 +308,51 @@ errcode_t ext2fs_add_journal_device(ext2
 }
 
 /*
+ * Determine the number of journal blocks to use, either via
+ * user-specified # of megabytes, or via some intelligently selected
+ * defaults.
+ *
+ * Find a reasonable journal file size (in blocks) given the number of blocks
+ * in the filesystem.  For very small filesystems, it is not reasonable to
+ * have a journal that fills more than half of the filesystem.
+ */
+int ext2fs_figure_journal_size(int *size, ext2_filsys fs)
+{
+	blk_t j_blocks;
+
+	if (fs->super->s_blocks_count < 2048)
+		return EXT2_ET_JOURNAL_FS_TOO_SMALL;
+
+	if (*size > 0) {
+		j_blocks = (*size) * 1024 / (fs->blocksize / 1024);
+		if (j_blocks < 1024 || j_blocks > 102400)
+			return EXT2_ET_JOURNAL_INVALID_SIZE;
+
+		if (j_blocks > fs->super->s_free_blocks_count ||
+		    j_blocks > fs->super->s_blocks_count / 2)
+			return EXT2_ET_JOURNAL_TOO_BIG;
+
+		*size = j_blocks;
+		return 0;
+	}
+
+	if (fs->super->s_blocks_count < 32768)
+		j_blocks = 1024;
+	else if (fs->super->s_blocks_count < 256*1024)
+		j_blocks = 4096;
+	else if (fs->super->s_blocks_count < 512*1024)
+		j_blocks = 8192;
+	else if (fs->super->s_blocks_count < 1024*1024)
+		j_blocks = 16384;
+	else
+		j_blocks = 32768;
+
+	*size = j_blocks;
+
+	return 0;
+}
+
+/*
  * This function adds a journal inode to a filesystem, using either
  * POSIX routines if the filesystem is mounted, or using direct I/O
  * functions if it is not.
Index: e2fsprogs-1.40/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.40.orig/misc/mke2fs.c
+++ e2fsprogs-1.40/misc/mke2fs.c
@@ -1691,19 +1691,24 @@ int main (int argc, char *argv[])
 	} else if ((journal_size) ||
 		   (fs_param.s_feature_compat & 
 		    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
-		journal_blocks = figure_journal_size(journal_size, fs);
+		retval = ext2fs_figure_journal_size(&journal_size, fs);
 
-		if (!journal_blocks) {
+		if (journal_size && retval) {
+			com_err(program_name, retval,
+				_("\n\twhile trying to create journal file"));
+			exit(1);
+		}
+		if (!journal_size) {
 			fs->super->s_feature_compat &=
 				~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 			goto no_journal;
 		}
 		if (!quiet) {
 			printf(_("Creating journal (%d blocks): "),
-			       journal_blocks);
+			       journal_size);
 			fflush(stdout);
 		}
-		retval = ext2fs_add_journal_inode(fs, journal_blocks,
+		retval = ext2fs_add_journal_inode(fs, journal_size,
 						  journal_flags);
 		if (retval) {
 			com_err (program_name, retval,
Index: e2fsprogs-1.40/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.40.orig/misc/tune2fs.c
+++ e2fsprogs-1.40/misc/tune2fs.c
@@ -373,7 +373,6 @@ static void update_feature_set(ext2_fils
  */
 static void add_journal(ext2_filsys fs)
 {
-	unsigned long journal_blocks;
 	errcode_t	retval;
 	ext2_filsys	jfs;
 	io_manager	io_ptr;
@@ -417,9 +416,14 @@ static void add_journal(ext2_filsys fs)
 	} else if (journal_size) {
 		fputs(_("Creating journal inode: "), stdout);
 		fflush(stdout);
-		journal_blocks = figure_journal_size(journal_size, fs);
+		retval = ext2fs_figure_journal_size(&journal_size, fs);
 
-		retval = ext2fs_add_journal_inode(fs, journal_blocks,
+		if (journal_size && retval) {
+			com_err(program_name, retval,
+				_("\n\twhile trying to create journal file"));
+			exit(1);
+		}
+		retval = ext2fs_add_journal_inode(fs, journal_size,
 						  journal_flags);
 		if (retval) {
 			fprintf(stderr, "\n");
Index: e2fsprogs-1.40/misc/util.c
===================================================================
--- e2fsprogs-1.40.orig/misc/util.c
+++ e2fsprogs-1.40/misc/util.c
@@ -238,57 +238,6 @@ void parse_journal_opts(const char *opts
 	}
 }	
 
-/*
- * Determine the number of journal blocks to use, either via
- * user-specified # of megabytes, or via some intelligently selected
- * defaults.
- * 
- * Find a reasonable journal file size (in blocks) given the number of blocks
- * in the filesystem.  For very small filesystems, it is not reasonable to
- * have a journal that fills more than half of the filesystem.
- */
-int figure_journal_size(int size, ext2_filsys fs)
-{
-	blk_t j_blocks;
-
-	if (fs->super->s_blocks_count < 2048) {
-		fputs(_("\nFilesystem too small for a journal\n"), stderr);
-		return 0;
-	}
-	
-	if (size > 0) {
-		j_blocks = size * 1024 / (fs->blocksize	/ 1024);
-		if (j_blocks < 1024 || j_blocks > 102400) {
-			fprintf(stderr, _("\nThe requested journal "
-				"size is %d blocks; it must be\n"
-				"between 1024 and 102400 blocks.  "
-				"Aborting.\n"),
-				j_blocks);
-			exit(1);
-		}
-		if (j_blocks > fs->super->s_free_blocks_count) {
-			fputs(_("\nJournal size too big for filesystem.\n"),
-			      stderr);
-			exit(1);
-		}
-		return j_blocks;
-	}
-
-	if (fs->super->s_blocks_count < 32768)
-		j_blocks = 1400;
-	else if (fs->super->s_blocks_count < 256*1024)
-		j_blocks = 4096;
-	else if (fs->super->s_blocks_count < 512*1024)
-		j_blocks = 8192;
-	else if (fs->super->s_blocks_count < 1024*1024)
-		j_blocks = 16384;
-	else
-		j_blocks = 32768;
-
-
-	return j_blocks;
-}
-
 void print_check_message(ext2_filsys fs)
 {
 	printf(_("This filesystem will be automatically "
Index: e2fsprogs-1.40/misc/util.h
===================================================================
--- e2fsprogs-1.40.orig/misc/util.h
+++ e2fsprogs-1.40/misc/util.h
@@ -22,5 +22,4 @@ extern void proceed_question(void);
 extern void check_plausibility(const char *device);
 extern void parse_journal_opts(const char *opts);
 extern void check_mount(const char *device, int force, const char *type);
-extern int figure_journal_size(int size, ext2_filsys fs);
 extern void print_check_message(ext2_filsys fs);
Index: e2fsprogs-1.40/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/problem.c
+++ e2fsprogs-1.40/e2fsck/problem.c
@@ -1489,6 +1489,11 @@ static struct e2fsck_problem problem_tab
 	  " +(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
+	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
+	{ PR_6_RECREATE_JOURNAL,
+	  N_("Recreate journal to make the filesystem ext3 again?\n"),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
+
 	{ 0 }
 };
 
Index: e2fsprogs-1.40/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/problem.h
+++ e2fsprogs-1.40/e2fsck/problem.h
@@ -898,6 +898,13 @@ struct problem_context {
 #define PR_5_INODE_RANGE_USED		0x050017
 
 /*
+ * Post-Pass 5 errors
+ */
+
+/* Recreate the journal if E2F_FLAG_JOURNAL_INODE flag is set */
+#define PR_6_RECREATE_JOURNAL		0x060000
+
+/*
  * Function declarations
  */
 int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx);
Index: e2fsprogs-1.40/lib/ext2fs/ext2_err.et.in
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2_err.et.in
+++ e2fsprogs-1.40/lib/ext2fs/ext2_err.et.in
@@ -275,6 +275,15 @@ ec	EXT2_ET_LOAD_EXT_JOURNAL,
 ec	EXT2_ET_NO_JOURNAL,
 	"Journal not found"
 
+ec	EXT2_ET_JOURNAL_FS_TOO_SMALL,
+	"Filesystem too small for a journal"
+
+ec	EXT2_ET_JOURNAL_TOO_BIG,
+	"Journal size too big for filesystem"
+
+ec	EXT2_ET_JOURNAL_INVALID_SIZE,
+	"The journal size must be between 1024 and 102400 blocks."
+
 ec	EXT2_ET_DIRHASH_UNSUPP,
 	"Directory hash unsupported"
 

--=-KmYI8nNlkX0gp7RPbt/w--
