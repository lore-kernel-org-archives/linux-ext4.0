From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/37] e2fsck: write dir blocks after new inode when
 reconstructing root/lost+found
Date: Thu, 01 May 2014 16:13:47 -0700
Message-ID: <20140501231347.31890.92245.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaEAXNw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:13:52 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we trash the root directory block, e2fsck will find inode 11 (the
old lost+found) and try to attach it to l+f.  The lost+found checker
also fails to find l+f and tries to add one to the root dir.  The root
dir is not found but is recreated with incorrect checksums, so linking
in the l+f dir fails and the l+f '..' entry isn't set.  Since both
dirs now fail checksum verification, they're both referred to rehash
to have that fixed, but because l+f doesn't have a '..' entry, rehash
crashes because l+f has < 2 entries.

On a checksumming filesystem, the routines in e2fsck that recreate
/lost+found and / must write the new directory block *after* the inode
has been written to disk because the checksum depends on i_generation.
Add a regression test while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c                        |   85 +++++----
 tests/f_rebuild_csum_rootdir/expect.1 |  311 +++++++++++++++++++++++++++++++++
 tests/f_rebuild_csum_rootdir/expect.2 |    7 +
 tests/f_rebuild_csum_rootdir/image.gz |  Bin
 tests/f_rebuild_csum_rootdir/name     |    1 
 5 files changed, 364 insertions(+), 40 deletions(-)
 create mode 100644 tests/f_rebuild_csum_rootdir/expect.1
 create mode 100644 tests/f_rebuild_csum_rootdir/expect.2
 create mode 100644 tests/f_rebuild_csum_rootdir/image.gz
 create mode 100644 tests/f_rebuild_csum_rootdir/name


diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 6f7f855..efc0d49 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -188,28 +188,6 @@ static void check_root(e2fsck_t ctx)
 	ext2fs_mark_bb_dirty(fs);
 
 	/*
-	 * Now let's create the actual data block for the inode
-	 */
-	pctx.errcode = ext2fs_new_dir_block(fs, EXT2_ROOT_INO, EXT2_ROOT_INO,
-					    &block);
-	if (pctx.errcode) {
-		pctx.str = "ext2fs_new_dir_block";
-		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-
-	pctx.errcode = ext2fs_write_dir_block4(fs, blk, block, 0,
-					       EXT2_ROOT_INO);
-	if (pctx.errcode) {
-		pctx.str = "ext2fs_write_dir_block4";
-		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-	ext2fs_free_mem(&block);
-
-	/*
 	 * Set up the inode structure
 	 */
 	memset(&inode, 0, sizeof(inode));
@@ -232,6 +210,30 @@ static void check_root(e2fsck_t ctx)
 	}
 
 	/*
+	 * Now let's create the actual data block for the inode.
+	 * Due to metadata_csum, we must write the dir blocks AFTER
+	 * the inode has been written to disk!
+	 */
+	pctx.errcode = ext2fs_new_dir_block(fs, EXT2_ROOT_INO, EXT2_ROOT_INO,
+					    &block);
+	if (pctx.errcode) {
+		pctx.str = "ext2fs_new_dir_block";
+		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+
+	pctx.errcode = ext2fs_write_dir_block4(fs, blk, block, 0,
+					       EXT2_ROOT_INO);
+	ext2fs_free_mem(&block);
+	if (pctx.errcode) {
+		pctx.str = "ext2fs_write_dir_block4";
+		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+
+	/*
 	 * Miscellaneous bookkeeping...
 	 */
 	e2fsck_add_dir_info(ctx, EXT2_ROOT_INO, EXT2_ROOT_INO);
@@ -449,24 +451,6 @@ unlink:
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
 
 	/*
-	 * Now let's create the actual data block for the inode
-	 */
-	retval = ext2fs_new_dir_block(fs, ino, EXT2_ROOT_INO, &block);
-	if (retval) {
-		pctx.errcode = retval;
-		fix_problem(ctx, PR_3_ERR_LPF_NEW_DIR_BLOCK, &pctx);
-		return 0;
-	}
-
-	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
-	ext2fs_free_mem(&block);
-	if (retval) {
-		pctx.errcode = retval;
-		fix_problem(ctx, PR_3_ERR_LPF_WRITE_BLOCK, &pctx);
-		return 0;
-	}
-
-	/*
 	 * Set up the inode structure
 	 */
 	memset(&inode, 0, sizeof(inode));
@@ -486,6 +470,27 @@ unlink:
 		fix_problem(ctx, PR_3_CREATE_LPF_ERROR, &pctx);
 		return 0;
 	}
+
+	/*
+	 * Now let's create the actual data block for the inode.
+	 * Due to metadata_csum, the directory block MUST be written
+	 * after the inode is written to disk!
+	 */
+	retval = ext2fs_new_dir_block(fs, ino, EXT2_ROOT_INO, &block);
+	if (retval) {
+		pctx.errcode = retval;
+		fix_problem(ctx, PR_3_ERR_LPF_NEW_DIR_BLOCK, &pctx);
+		return 0;
+	}
+
+	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
+	ext2fs_free_mem(&block);
+	if (retval) {
+		pctx.errcode = retval;
+		fix_problem(ctx, PR_3_ERR_LPF_WRITE_BLOCK, &pctx);
+		return 0;
+	}
+
 	/*
 	 * Finally, create the directory link
 	 */
diff --git a/tests/f_rebuild_csum_rootdir/expect.1 b/tests/f_rebuild_csum_rootdir/expect.1
new file mode 100644
index 0000000..6b5c47b
--- /dev/null
+++ b/tests/f_rebuild_csum_rootdir/expect.1
@@ -0,0 +1,311 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Directory inode 2, block #0, offset 0: directory has no checksum
+Fix? yes
+
+Directory inode 2, block #0, offset 0: directory corrupted
+Salvage? yes
+
+Missing '.' in directory inode 2.
+Fix? yes
+
+Setting filetype for entry '.' in ??? (2) to 2.
+Missing '..' in directory inode 2.
+Fix? yes
+
+Setting filetype for entry '..' in ??? (2) to 2.
+Pass 3: Checking directory connectivity
+'..' in / (2) is <The NULL inode> (0), should be / (2).
+Fix? yes
+
+Unconnected directory inode 11 (/???)
+Connect to /lost+found? yes
+
+/lost+found not found.  Create? yes
+
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Inode 11 ref count is 3, should be 2.  Fix? yes
+
+Unattached inode 12
+Connect to /lost+found? yes
+
+Inode 12 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 13
+Connect to /lost+found? yes
+
+Inode 13 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 14
+Connect to /lost+found? yes
+
+Inode 14 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 15
+Connect to /lost+found? yes
+
+Inode 15 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 16
+Connect to /lost+found? yes
+
+Inode 16 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 17
+Connect to /lost+found? yes
+
+Inode 17 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 18
+Connect to /lost+found? yes
+
+Inode 18 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 19
+Connect to /lost+found? yes
+
+Inode 19 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 20
+Connect to /lost+found? yes
+
+Inode 20 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 21
+Connect to /lost+found? yes
+
+Inode 21 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 22
+Connect to /lost+found? yes
+
+Inode 22 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 23
+Connect to /lost+found? yes
+
+Inode 23 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 24
+Connect to /lost+found? yes
+
+Inode 24 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 25
+Connect to /lost+found? yes
+
+Inode 25 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 26
+Connect to /lost+found? yes
+
+Inode 26 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 27
+Connect to /lost+found? yes
+
+Inode 27 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 28
+Connect to /lost+found? yes
+
+Inode 28 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 29
+Connect to /lost+found? yes
+
+Inode 29 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 30
+Connect to /lost+found? yes
+
+Inode 30 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 31
+Connect to /lost+found? yes
+
+Inode 31 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 32
+Connect to /lost+found? yes
+
+Inode 32 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 33
+Connect to /lost+found? yes
+
+Inode 33 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 34
+Connect to /lost+found? yes
+
+Inode 34 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 35
+Connect to /lost+found? yes
+
+Inode 35 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 36
+Connect to /lost+found? yes
+
+Inode 36 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 37
+Connect to /lost+found? yes
+
+Inode 37 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 38
+Connect to /lost+found? yes
+
+Inode 38 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 39
+Connect to /lost+found? yes
+
+Inode 39 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 40
+Connect to /lost+found? yes
+
+Inode 40 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 41
+Connect to /lost+found? yes
+
+Inode 41 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 42
+Connect to /lost+found? yes
+
+Inode 42 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 43
+Connect to /lost+found? yes
+
+Inode 43 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 44
+Connect to /lost+found? yes
+
+Inode 44 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 45
+Connect to /lost+found? yes
+
+Inode 45 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 46
+Connect to /lost+found? yes
+
+Inode 46 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 47
+Connect to /lost+found? yes
+
+Inode 47 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 48
+Connect to /lost+found? yes
+
+Inode 48 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 49
+Connect to /lost+found? yes
+
+Inode 49 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 50
+Connect to /lost+found? yes
+
+Inode 50 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 51
+Connect to /lost+found? yes
+
+Inode 51 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 52
+Connect to /lost+found? yes
+
+Inode 52 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 53
+Connect to /lost+found? yes
+
+Inode 53 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 54
+Connect to /lost+found? yes
+
+Inode 54 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 55
+Connect to /lost+found? yes
+
+Inode 55 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 56
+Connect to /lost+found? yes
+
+Inode 56 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 57
+Connect to /lost+found? yes
+
+Inode 57 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 58
+Connect to /lost+found? yes
+
+Inode 58 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 59
+Connect to /lost+found? yes
+
+Inode 59 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 60
+Connect to /lost+found? yes
+
+Inode 60 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 61
+Connect to /lost+found? yes
+
+Inode 61 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 62
+Connect to /lost+found? yes
+
+Inode 62 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 63
+Connect to /lost+found? yes
+
+Inode 63 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 64
+Connect to /lost+found? yes
+
+Inode 64 ref count is 2, should be 1.  Fix? yes
+
+Unattached zero-length inode 65.  Clear? yes
+
+Unattached inode 66
+Connect to /lost+found? yes
+
+Inode 66 ref count is 2, should be 1.  Fix? yes
+
+Unattached inode 67
+Connect to /lost+found? yes
+
+Inode 67 ref count is 2, should be 1.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 67/512 files (1.5% non-contiguous), 1127/2048 blocks
+Exit status is 1
diff --git a/tests/f_rebuild_csum_rootdir/expect.2 b/tests/f_rebuild_csum_rootdir/expect.2
new file mode 100644
index 0000000..033f1bf
--- /dev/null
+++ b/tests/f_rebuild_csum_rootdir/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 67/512 files (1.5% non-contiguous), 1127/2048 blocks
+Exit status is 0
diff --git a/tests/f_rebuild_csum_rootdir/image.gz b/tests/f_rebuild_csum_rootdir/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..a32fd4431a44560b20033d43836000ef22ce977f
GIT binary patch
literal 12476
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
W)Gq69OyI|Sozg9bf2Chr*ZB{=uW}{;

literal 0
HcmV?d00001

diff --git a/tests/f_rebuild_csum_rootdir/name b/tests/f_rebuild_csum_rootdir/name
new file mode 100644
index 0000000..b246f48
--- /dev/null
+++ b/tests/f_rebuild_csum_rootdir/name
@@ -0,0 +1 @@
+force fsck to rebuild a corrupted rootdir w/ metadata_csum

