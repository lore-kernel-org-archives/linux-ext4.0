From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 02/10] e2fsck: use errcode_t to suppress some -Wconversion warnings
Date: Tue,  3 Dec 2013 00:10:10 -0500
Message-ID: <1386047418-32431-3-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35874 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3LCFKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:31 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to store some error codes using an int to keep recovery.c as
close as possible to the recovery.c source file in the kernel.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/e2fsck.h  |  4 ++--
 e2fsck/journal.c | 20 ++++++++++----------
 e2fsck/pass1b.c  |  8 ++++----
 e2fsck/rehash.c  |  2 +-
 e2fsck/unix.c    |  2 +-
 e2fsck/util.c    |  8 ++++----
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e3ad78d..3c4f832 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -452,8 +452,8 @@ extern const char *ehandler_operation(const char *op);
 extern void ehandler_init(io_channel channel);
 
 /* journal.c */
-extern int e2fsck_check_ext3_journal(e2fsck_t ctx);
-extern int e2fsck_run_ext3_journal(e2fsck_t ctx);
+extern errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx);
+extern errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx);
 extern void e2fsck_move_ext3_journal(e2fsck_t ctx);
 extern int e2fsck_fix_ext3_journal_hint(e2fsck_t ctx);
 
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 0cbdb7b..ff11f22 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -62,7 +62,7 @@ int journal_bmap(journal_t *journal, blk64_t block, unsigned long long *phys)
 	retval= ext2fs_bmap2(inode->i_ctx->fs, inode->i_ino,
 			     &inode->i_ext2, NULL, 0, block, 0, &pblk);
 	*phys = pblk;
-	return (retval);
+	return (int) retval;
 #endif
 }
 
@@ -108,7 +108,7 @@ void sync_blockdev(kdev_t kdev)
 
 void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
 {
-	int retval;
+	errcode_t retval;
 	struct buffer_head *bh;
 
 	for (; nr > 0; --nr) {
@@ -123,7 +123,7 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
 				com_err(bh->b_ctx->device_name, retval,
 					"while reading block %llu\n",
 					bh->b_blocknr);
-				bh->b_err = retval;
+				bh->b_err = (int) retval;
 				continue;
 			}
 			bh->b_uptodate = 1;
@@ -138,7 +138,7 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
 				com_err(bh->b_ctx->device_name, retval,
 					"while writing block %llu\n",
 					bh->b_blocknr);
-				bh->b_err = retval;
+				bh->b_err = (int) retval;
 				continue;
 			}
 			bh->b_dirty = 0;
@@ -340,7 +340,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 #else
 		journal->j_inode = j_inode;
 		ctx->journal_io = ctx->fs->io;
-		if ((retval = journal_bmap(journal, 0, &start)) != 0)
+		if ((retval = (errcode_t) journal_bmap(journal, 0, &start)) != 0)
 			goto errout;
 #endif
 	} else {
@@ -705,7 +705,7 @@ static void e2fsck_journal_release(e2fsck_t ctx, journal_t *journal,
  * This function makes sure that the superblock fields regarding the
  * journal are consistent.
  */
-int e2fsck_check_ext3_journal(e2fsck_t ctx)
+errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
 	journal_t *journal;
@@ -714,7 +714,7 @@ int e2fsck_check_ext3_journal(e2fsck_t ctx)
 	struct problem_context pctx;
 	problem_t problem;
 	int reset = 0, force_fsck = 0;
-	int retval;
+	errcode_t retval;
 
 	/* If we don't have any journal features, don't do anything more */
 	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
@@ -838,7 +838,7 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)
 {
 	struct problem_context	pctx;
 	journal_t *journal;
-	int retval;
+	errcode_t retval;
 
 	clear_problem_context(&pctx);
 
@@ -873,7 +873,7 @@ errout:
 	return retval;
 }
 
-int e2fsck_run_ext3_journal(e2fsck_t ctx)
+errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx)
 {
 	io_manager io_ptr = ctx->fs->io->manager;
 	int blocksize = ctx->fs->blocksize;
@@ -920,7 +920,7 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
 	ctx->fs->super->s_kbytes_written += kbytes_written;
 
 	/* Set the superblock flags */
-	e2fsck_clear_recover(ctx, recover_retval);
+	e2fsck_clear_recover(ctx, recover_retval != 0);
 
 	/*
 	 * Do one last sanity check, and propagate journal->s_errno to
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index cd6c883..a3b880c 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -88,8 +88,8 @@ static int process_pass1b_block(ext2_filsys fs, blk64_t	*blocknr,
 				int ref_offset, void *priv_data);
 static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 			struct dup_inode *dp, char *block_buf);
-static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
-		      struct dup_inode *dp, char* block_buf);
+static errcode_t clone_file(e2fsck_t ctx, ext2_ino_t ino,
+			    struct dup_inode *dp, char* block_buf);
 static int check_if_fs_block(e2fsck_t ctx, blk64_t test_block);
 static int check_if_fs_cluster(e2fsck_t ctx, blk64_t cluster);
 
@@ -779,8 +779,8 @@ static int clone_file_block(ext2_filsys fs,
 	return 0;
 }
 
-static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
-		      struct dup_inode *dp, char* block_buf)
+static errcode_t clone_file(e2fsck_t ctx, ext2_ino_t ino,
+			    struct dup_inode *dp, char* block_buf)
 {
 	ext2_filsys fs = ctx->fs;
 	errcode_t	retval;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 9dbdb3b..ac0ff31 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -55,7 +55,7 @@
 struct fill_dir_struct {
 	char *buf;
 	struct ext2_inode *inode;
-	int err;
+	errcode_t err;
 	e2fsck_t ctx;
 	struct hash_entry *harray;
 	int max_array, num_array;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 1ed8fc5..bacb86a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1071,7 +1071,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 static const char *my_ver_string = E2FSPROGS_VERSION;
 static const char *my_ver_date = E2FSPROGS_DATE;
 
-static int e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
+static errcode_t e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
 {
 	struct mmp_struct *mmp_s;
 	unsigned int mmp_check_interval;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index d361a51..c9e2ca1 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -439,7 +439,7 @@ void print_resource_track(e2fsck_t ctx, const char *desc,
 void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
 			      struct ext2_inode * inode, const char *proc)
 {
-	int retval;
+	errcode_t retval;
 
 	retval = ext2fs_read_inode(ctx->fs, ino, inode);
 	if (retval) {
@@ -453,7 +453,7 @@ void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
 			    struct ext2_inode *inode, int bufsize,
 			    const char *proc)
 {
-	int retval;
+	errcode_t retval;
 
 	retval = ext2fs_read_inode_full(ctx->fs, ino, inode, bufsize);
 	if (retval) {
@@ -467,7 +467,7 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 			       struct ext2_inode * inode, int bufsize,
 			       const char *proc)
 {
-	int retval;
+	errcode_t retval;
 
 	retval = ext2fs_write_inode_full(ctx->fs, ino, inode, bufsize);
 	if (retval) {
@@ -480,7 +480,7 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 extern void e2fsck_write_inode(e2fsck_t ctx, unsigned long ino,
 			       struct ext2_inode * inode, const char *proc)
 {
-	int retval;
+	errcode_t retval;
 
 	retval = ext2fs_write_inode(ctx->fs, ino, inode);
 	if (retval) {
-- 
1.8.5.rc3.362.gdf10213

