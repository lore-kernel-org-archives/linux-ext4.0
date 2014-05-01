From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/37] libext2fs: provide a function to set inode size
Date: Thu, 01 May 2014 16:15:26 -0700
Message-ID: <20140501231526.31890.13684.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28998 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaEAXPb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:15:31 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide an API to set i_size in an inode and take care of all required
feature flag modifications.  Refactor the code to use this new
function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c              |    9 ++++-----
 e2fsck/pass2.c              |   11 +++++++++--
 e2fsck/pass3.c              |    5 +++--
 e2fsck/rehash.c             |    5 ++++-
 lib/ext2fs/bb_inode.c       |    5 ++++-
 lib/ext2fs/ext2fs.h         |    2 ++
 lib/ext2fs/fileio.c         |   41 ++++++++++++++++++++++++++++-------------
 lib/ext2fs/mkjournal.c      |    8 +++-----
 lib/ext2fs/res_gdt.c        |    9 +++------
 lib/ext2fs/symlink.c        |    2 +-
 misc/create_inode.c         |    7 ++++++-
 tests/f_big_sparse/expect.1 |    5 -----
 12 files changed, 67 insertions(+), 42 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 376ee23..0705899 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -265,8 +265,7 @@ static void check_size(e2fsck_t ctx, struct problem_context *pctx)
 	if (!fix_problem(ctx, PR_1_SET_NONZSIZE, pctx))
 		return;
 
-	inode->i_size = 0;
-	inode->i_size_high = 0;
+	ext2fs_inode_set_size(ctx->fs, inode, 0);
 	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
 }
 
@@ -2454,9 +2453,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		pctx->num = (pb.last_block+1) * fs->blocksize;
 		pctx->group = bad_size;
 		if (fix_problem(ctx, PR_1_BAD_I_SIZE, pctx)) {
-			inode->i_size = pctx->num;
-			if (!LINUX_S_ISDIR(inode->i_mode))
-				inode->i_size_high = pctx->num >> 32;
+			if (LINUX_S_ISDIR(inode->i_mode))
+				pctx->num &= 0xFFFFFFFFULL;
+			ext2fs_inode_set_size(fs, inode, pctx->num);
 			dirty_inode++;
 		}
 		pctx->num = 0;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 4b19cb8..7a597de 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1768,8 +1768,15 @@ static int allocate_dir_block(e2fsck_t ctx,
 	 */
 	e2fsck_read_inode(ctx, db->ino, &inode, "allocate_dir_block");
 	ext2fs_iblk_add_blocks(fs, &inode, 1);
-	if (inode.i_size < (db->blockcnt+1) * fs->blocksize)
-		inode.i_size = (db->blockcnt+1) * fs->blocksize;
+	if (EXT2_I_SIZE(&inode) < (db->blockcnt+1) * fs->blocksize) {
+		pctx->errcode = ext2fs_inode_set_size(fs, &inode,
+					(db->blockcnt+1) * fs->blocksize);
+		if (pctx->errcode) {
+			pctx->str = "ext2fs_inode_set_size";
+			fix_problem(ctx, PR_2_ALLOC_DIRBOCK, pctx);
+			return 1;
+		}
+	}
 	e2fsck_write_inode(ctx, db->ino, &inode, "allocate_dir_block");
 
 	/*
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index efc0d49..324e398 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -865,8 +865,9 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 		return retval;
 
 	sz = (es.last_block + 1) * fs->blocksize;
-	inode.i_size = sz;
-	inode.i_size_high = sz >> 32;
+	retval = ext2fs_inode_set_size(fs, &inode, sz);
+	if (retval)
+		return retval;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	quota_data_add(ctx->qctx, &inode, dir, es.newblocks * fs->blocksize);
 
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 89708c2..09c55e5 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -783,7 +783,10 @@ static errcode_t write_directory(e2fsck_t ctx, ext2_filsys fs,
 		inode.i_flags &= ~EXT2_INDEX_FL;
 	else
 		inode.i_flags |= EXT2_INDEX_FL;
-	inode.i_size = outdir->num * fs->blocksize;
+	retval = ext2fs_inode_set_size(fs, &inode,
+				       outdir->num * fs->blocksize);
+	if (retval)
+		return retval;
 	ext2fs_iblk_sub_blocks(fs, &inode, wd.cleared);
 	e2fsck_write_inode(ctx, ino, &inode, "rehash_dir");
 
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 268eecf..3d9132b 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -128,7 +128,10 @@ errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 	if (!inode.i_ctime)
 		inode.i_ctime = fs->now ? fs->now : time(0);
 	ext2fs_iblk_set(fs, &inode, rec.bad_block_count);
-	inode.i_size = rec.bad_block_count * fs->blocksize;
+	retval = ext2fs_inode_set_size(fs, &inode,
+				       rec.bad_block_count * fs->blocksize);
+	if (retval)
+		goto cleanup;
 
 	retval = ext2fs_write_inode(fs, EXT2_BAD_INO, &inode);
 	if (retval)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ca35d24..3d7374e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1245,6 +1245,8 @@ errcode_t ext2fs_file_get_lsize(ext2_file_t file, __u64 *ret_size);
 extern ext2_off_t ext2fs_file_get_size(ext2_file_t file);
 extern errcode_t ext2fs_file_set_size(ext2_file_t file, ext2_off_t size);
 extern errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size);
+errcode_t ext2fs_inode_set_size(ext2_filsys fs, struct ext2_inode *inode,
+				ext2_off64_t size);
 
 /* finddev.c */
 extern char *ext2fs_find_block_device(dev_t device);
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1e386f8..55affb4 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -567,6 +567,31 @@ out:
 	return retval;
 }
 
+errcode_t ext2fs_inode_set_size(ext2_filsys fs, struct ext2_inode *inode,
+				ext2_off64_t size)
+{
+	/* Only regular files get to be larger than 4GB */
+	if (!LINUX_S_ISREG(inode->i_mode) && (size >> 32))
+		return EXT2_ET_FILE_TOO_BIG;
+
+	/* If we're writing a large file, set the large_file flag */
+	if (LINUX_S_ISREG(inode->i_mode) &&
+	    ext2fs_needs_large_file_feature(size) &&
+	    (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE) ||
+	     fs->super->s_rev_level == EXT2_GOOD_OLD_REV)) {
+		fs->super->s_feature_ro_compat |=
+					EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
+		ext2fs_update_dynamic_rev(fs);
+		ext2fs_mark_super_dirty(fs);
+	}
+
+	inode->i_size = size & 0xffffffff;
+	inode->i_size_high = (size >> 32);
+
+	return 0;
+}
+
 /*
  * This function sets the size of the file, truncating it if necessary
  *
@@ -588,20 +613,10 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 	old_truncate = ((old_size + file->fs->blocksize - 1) >>
 		      EXT2_BLOCK_SIZE_BITS(file->fs->super));
 
-	/* If we're writing a large file, set the large_file flag */
-	if (LINUX_S_ISREG(file->inode.i_mode) &&
-	    ext2fs_needs_large_file_feature(EXT2_I_SIZE(&file->inode)) &&
-	    (!EXT2_HAS_RO_COMPAT_FEATURE(file->fs->super,
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE) ||
-	     file->fs->super->s_rev_level == EXT2_GOOD_OLD_REV)) {
-		file->fs->super->s_feature_ro_compat |=
-				EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
-		ext2fs_update_dynamic_rev(file->fs);
-		ext2fs_mark_super_dirty(file->fs);
-	}
+	retval = ext2fs_inode_set_size(file->fs, &file->inode, size);
+	if (retval)
+		return retval;
 
-	file->inode.i_size = size & 0xffffffff;
-	file->inode.i_size_high = (size >> 32);
 	if (file->ino) {
 		retval = ext2fs_write_inode(file->fs, file->ino, &file->inode);
 		if (retval)
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index ecc3912..11f33ab 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -400,15 +400,13 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 		goto errout;
 
 	inode_size = (unsigned long long)fs->blocksize * num_blocks;
-	inode.i_size = inode_size & 0xFFFFFFFF;
-	inode.i_size_high = (inode_size >> 32) & 0xFFFFFFFF;
-	if (ext2fs_needs_large_file_feature(inode_size))
-		fs->super->s_feature_ro_compat |=
-			EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	inode.i_mtime = inode.i_ctime = fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
 	inode.i_mode = LINUX_S_IFREG | 0600;
+	retval = ext2fs_inode_set_size(fs, &inode, inode_size);
+	if (retval)
+		goto errout;
 
 	if ((retval = ext2fs_write_new_inode(fs, journal_ino, &inode)))
 		goto errout;
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index e61c330..1343ce6 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -133,12 +133,9 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 		dindir_dirty = inode_dirty = 1;
 		inode_size = apb*apb + apb + EXT2_NDIR_BLOCKS;
 		inode_size *= fs->blocksize;
-		inode.i_size = inode_size & 0xFFFFFFFF;
-		inode.i_size_high = (inode_size >> 32) & 0xFFFFFFFF;
-		if(inode.i_size_high) {
-			sb->s_feature_ro_compat |=
-				EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
-		}
+		retval = ext2fs_inode_set_size(fs, &inode, inode_size);
+		if (retval)
+			goto out_free;
 		inode.i_ctime = fs->now ? fs->now : time(0);
 	}
 
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index cb3a2e7..4147181 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -80,7 +80,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	inode.i_uid = inode.i_gid = 0;
 	ext2fs_iblk_set(fs, &inode, fastlink ? 0 : 1);
 	inode.i_links_count = 1;
-	inode.i_size = target_len;
+	ext2fs_inode_set_size(fs, &inode, target_len);
 	/* The time fields are set by ext2fs_write_new_inode() */
 
 	if (fastlink) {
diff --git a/misc/create_inode.c b/misc/create_inode.c
index e7faab1..ec98afe 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -405,7 +405,12 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 	inode.i_atime = inode.i_ctime = inode.i_mtime =
 		fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
-	inode.i_size = statbuf.st_size;
+	retval = ext2fs_inode_set_size(fs, &inode, statbuf.st_size);
+	if (retval) {
+		com_err(dest, retval, 0);
+		close(fd);
+		return retval;
+	}
 	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
 		inode.i_flags |= EXT4_INLINE_DATA_FL;
diff --git a/tests/f_big_sparse/expect.1 b/tests/f_big_sparse/expect.1
index 437ade7..eac82ed 100644
--- a/tests/f_big_sparse/expect.1
+++ b/tests/f_big_sparse/expect.1
@@ -2,11 +2,6 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 12, i_size is 61440, should be 4398050758656.  Fix? yes
 
 Pass 2: Checking directory structure
-Filesystem contains large files, but lacks LARGE_FILE flag in superblock.
-Fix? yes
-
-Filesystem has feature flag(s) set, but is a revision 0 filesystem.  Fix? yes
