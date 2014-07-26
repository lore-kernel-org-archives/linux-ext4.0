From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/18] libext2/fsck: correctly preserve fs flags when
 modifying ignore-csum-error flag
Date: Fri, 25 Jul 2014 17:34:47 -0700
Message-ID: <20140726003447.28334.51963.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaGZAev (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:34:51 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we need to modify the "ignore checksum error" behavior flag to
get us past a library call, it's possible that the library call can
result in other flag bits being changed.  Therefore, it is not correct
to restore unconditionally the previous flags value, since this will
have unintended side effects on the other fs->flags; nor is it correct
to assume that we can unconditionally set (or clear) the "ignore csum
error" flag bit.  Therefore, we must merge the previous value of the
"ignore csum error" flag with the value of flags after the call.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c     |   14 ++++++++++----
 e2fsck/pass3.c     |   11 ++++++++---
 e2fsck/rehash.c    |    4 +++-
 e2fsck/util.c      |    5 ++++-
 lib/ext2fs/inode.c |    3 ++-
 5 files changed, 27 insertions(+), 10 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 5e31343..9394a29 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1306,6 +1306,7 @@ skip_checksum:
 		}
 	}
 	if (dir_modified) {
+		int	flags, will_rehash;
 		/* leaf block with no tail?  Rehash dirs later. */
 		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
@@ -1318,8 +1319,11 @@ skip_checksum:
 		}
 
 write_and_fix:
-		if (e2fsck_dir_will_be_rehashed(ctx, ino))
+		will_rehash = e2fsck_dir_will_be_rehashed(ctx, ino);
+		if (will_rehash) {
+			flags = ctx->fs->flags;
 			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		}
 		if (inline_data_size) {
 			cd->pctx.errcode =
 				ext2fs_inline_data_set(fs, ino, 0, buf,
@@ -1327,8 +1331,11 @@ write_and_fix:
 		} else
 			cd->pctx.errcode = ext2fs_write_dir_block4(fs, block_nr,
 								   buf, 0, ino);
-		if (e2fsck_dir_will_be_rehashed(ctx, ino))
-			ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		if (will_rehash)
+			ctx->fs->flags = (flags &
+					  EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+					 (ctx->fs->flags &
+					  ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
@@ -1604,7 +1611,6 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	return 0;
 }
 
-
 /*
  * allocate_dir_block --- this function allocates a new directory
  * 	block for a particular inode; this is done if a directory has
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 1ec4015..9eb859e 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -687,6 +687,7 @@ static void fix_dotdot(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 	errcode_t	retval;
 	struct fix_dotdot_struct fp;
 	struct problem_context pctx;
+	int		flags, will_rehash;
 
 	fp.fs = fs;
 	fp.parent = parent;
@@ -699,12 +700,16 @@ static void fix_dotdot(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
-	if (e2fsck_dir_will_be_rehashed(ctx, ino))
+	will_rehash = e2fsck_dir_will_be_rehashed(ctx, ino);
+	if (will_rehash) {
+		flags = ctx->fs->flags;
 		ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	}
 	retval = ext2fs_dir_iterate(fs, ino, DIRENT_FLAG_INCLUDE_EMPTY,
 				    0, fix_dotdot_proc, &fp);
-	if (e2fsck_dir_will_be_rehashed(ctx, ino))
-		ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	if (will_rehash)
+		ctx->fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+			(ctx->fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 	if (retval || !fp.done) {
 		pctx.errcode = retval;
 		fix_problem(ctx, retval ? PR_3_FIX_PARENT_ERR :
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 5913ae7..6d18348 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -126,10 +126,12 @@ static int fill_dir_block(ext2_filsys fs,
 		dirent = (struct ext2_dir_entry *) dir;
 		(void) ext2fs_set_rec_len(fs, fs->blocksize, dirent);
 	} else {
+		int flags = fs->flags;
 		fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		fd->err = ext2fs_read_dir_block4(fs, *block_nr, dir, 0,
 						 fd->dir);
-		fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+			    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 		if (fd->err)
 			return BLOCK_ABORT;
 	}
diff --git a/e2fsck/util.c b/e2fsck/util.c
index e36e902..8237328 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -267,6 +267,7 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	errcode_t	retval;
 	const char	*old_op;
 	unsigned int	save_type;
+	int		flags;
 
 	if (ctx->invalid_bitmaps) {
 		com_err(ctx->program_name, 0,
@@ -278,9 +279,11 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	old_op = ehandler_operation(_("reading inode and block bitmaps"));
 	e2fsck_set_bitmap_type(fs, EXT2FS_BMAP64_RBTREE, "fs_bitmaps",
 			       &save_type);
+	flags = ctx->fs->flags;
 	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_read_bitmaps(fs);
-	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	ctx->fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+			 (ctx->fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 	fs->default_bitmap_type = save_type;
 	ehandler_operation(old_op);
 	if (retval) {
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 0cea9f0..ca97ab8 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -717,7 +717,8 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		retval = ext2fs_read_inode_full(fs, ino,
 						(struct ext2_inode *)w_inode,
 						length);
-		fs->flags = old_flags;
+		fs->flags = (old_flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+			    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 		if (retval)
 			goto errout;
 	}

