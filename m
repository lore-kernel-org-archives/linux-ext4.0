From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/19] e2fsck: use root dir for lost+found when really
 desperate
Date: Fri, 01 Aug 2014 11:11:59 -0700
Message-ID: <20140801181159.12496.97356.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32949 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaHASMG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:06 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If we're totally unable to allocate a lost+found directory, ask the
user if he would like to dump orphaned files in the root directory.
Hopefully this enables the user to delete enough files so that a
subsequent run of e2fsck will make more progress.  Better to cram lost
files in the rootdir than the current behavior, which is to fail at
linking them in, thereby leaving them as lost files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c                    |   12 ++++++++++++
 e2fsck/problem.c                  |    5 +++++
 e2fsck/problem.h                  |    3 +++
 tests/f_nospc_create_lnf/expect.1 |   28 ++++++++++++++++++++++++++++
 tests/f_nospc_create_lnf/expect.2 |   25 +++++++++++++++++++++++++
 tests/f_nospc_create_lnf/image.gz |  Bin
 tests/f_nospc_create_lnf/name     |    1 +
 7 files changed, 74 insertions(+)
 create mode 100644 tests/f_nospc_create_lnf/expect.1
 create mode 100644 tests/f_nospc_create_lnf/expect.2
 create mode 100644 tests/f_nospc_create_lnf/image.gz
 create mode 100644 tests/f_nospc_create_lnf/name

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 31131ab..e6142ad 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -450,6 +450,12 @@ unlink:
 		goto skip_new_block;
 	}
 	retval = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
+	if (retval == EXT2_ET_BLOCK_ALLOC_FAIL &&
+	    fix_problem(ctx, PR_3_LPF_NO_SPACE, &pctx)) {
+		printf("Delete some files and re-run e2fsck.\n\n");
+		ctx->lost_and_found = EXT2_ROOT_INO;
+		return 0;
+	}
 	if (retval) {
 		pctx.errcode = retval;
 		fix_problem(ctx, PR_3_ERR_LPF_NEW_BLOCK, &pctx);
@@ -464,6 +470,12 @@ skip_new_block:
 	 */
 	retval = ext2fs_new_inode(fs, EXT2_ROOT_INO, 040700,
 				  ctx->inode_used_map, &ino);
+	if (retval == EXT2_ET_INODE_ALLOC_FAIL &&
+	    fix_problem(ctx, PR_3_LPF_NO_SPACE, &pctx)) {
+		printf("Delete some files and re-run e2fsck.\n\n");
+		ctx->lost_and_found = EXT2_ROOT_INO;
+		return 0;
+	}
 	if (retval) {
 		pctx.errcode = retval;
 		fix_problem(ctx, PR_3_ERR_LPF_NEW_INODE, &pctx);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2c9386f..e68433b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1630,6 +1630,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("/@l has inline data\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Cannot allocate /lost+found. */
+	{ PR_3_LPF_NO_SPACE,
+	  N_("Cannot allocate space for /@l.\nPlace lost files in root directory instead"),
+	  PROMPT_NULL, 0 },
+
 	/* Pass 3A Directory Optimization	*/
 
 	/* Pass 3A: Optimizing directories */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 80ef4a2..496e873 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -973,6 +973,9 @@ struct problem_context {
 /* Lost+found has inline data */
 #define PR_3_LPF_INLINE_DATA		0x030018
 
+/* Cannot allocate lost+found */
+#define PR_3_LPF_NO_SPACE		0x030019
+
 /*
  * Pass 3a --- rehashing diretories
  */
diff --git a/tests/f_nospc_create_lnf/expect.1 b/tests/f_nospc_create_lnf/expect.1
new file mode 100644
index 0000000..fc20628
--- /dev/null
+++ b/tests/f_nospc_create_lnf/expect.1
@@ -0,0 +1,28 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+/lost+found not found.  Create? yes
+
+Cannot allocate space for /lost+found.
+Place lost files in root directory instead? yes
+
+Delete some files and re-run e2fsck.
+
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Unattached inode 125
+Connect to /lost+found? yes
+
+Inode 125 ref count is 2, should be 1.  Fix? yes
+
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (496, counted=495).
+Fix? yes
+
+Free blocks count wrong (496, counted=495).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 128/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_nospc_create_lnf/expect.2 b/tests/f_nospc_create_lnf/expect.2
new file mode 100644
index 0000000..5a44649
--- /dev/null
+++ b/tests/f_nospc_create_lnf/expect.2
@@ -0,0 +1,25 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+/lost+found not found.  Create? yes
+
+Cannot allocate space for /lost+found.
+Place lost files in root directory instead? yes
+
+Delete some files and re-run e2fsck.
+
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -9
+Fix? yes
+
+Free blocks count wrong for group #0 (494, counted=495).
+Fix? yes
+
+Free blocks count wrong (494, counted=495).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 128/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_nospc_create_lnf/image.gz b/tests/f_nospc_create_lnf/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..dc71b61a0028603aac348c61b015fd3c0b25273a
GIT binary patch
literal 4201
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
bI<V-#q63Q#yqW_*K`wuwV)xT%Yia)j*ECk;

literal 0
HcmV?d00001

diff --git a/tests/f_nospc_create_lnf/name b/tests/f_nospc_create_lnf/name
new file mode 100644
index 0000000..df6c932
--- /dev/null
+++ b/tests/f_nospc_create_lnf/name
@@ -0,0 +1 @@
+no space to create lost+found

