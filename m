From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/14] libext2fs: require the inline data xattr on all inline
 data files
Date: Thu, 4 Jun 2015 18:38:56 -0700
Message-ID: <20150605013856.GA7063@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42829 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbbFEBjB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2015 21:39:01 -0400
Content-Disposition: inline
In-Reply-To: <20150514002108.10785.85860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Turns out that the kernel requires the inline data xattr to exist for
all inline data files, even if the inline data size is zero.
Therefore, never delete the xattr key, and teach e2fsck always to look
for it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                                 |   19 +++----------------
 e2fsck/problem.c                               |    2 +-
 lib/ext2fs/inline_data.c                       |    3 ---
 tests/f_ea_value_crash/expect.1                |   17 +++++++++++++----
 tests/f_ea_value_crash/expect.2                |    2 +-
 tests/f_inline_no_ea/expect.1                  |   22 ++++++++++++++++++++++
 tests/f_inline_no_ea/expect.2                  |    7 +++++++
 tests/f_inline_no_ea/image.gz                  |  Bin
 tests/f_inline_no_ea/name                      |    1 +
 tests/f_inlinedata_repair/expect.1             |   14 +++++++++++---
 tests/f_write_ea_no_extra_isize/expect.1       |   21 ++++++++++++++++++---
 tests/f_write_ea_no_extra_isize/expect.2       |    2 +-
 tests/f_write_ea_toobig_extra_isize/expect.1   |   21 ++++++++++++++++++---
 tests/f_write_ea_toobig_extra_isize/expect.2   |    2 +-
 tests/f_write_ea_toosmall_extra_isize/expect.1 |   22 +++++++++++++++++-----
 tests/f_write_ea_toosmall_extra_isize/expect.2 |    2 +-
 16 files changed, 115 insertions(+), 42 deletions(-)
 create mode 100644 tests/f_inline_no_ea/expect.1
 create mode 100644 tests/f_inline_no_ea/expect.2
 create mode 100644 tests/f_inline_no_ea/image.gz
 create mode 100644 tests/f_inline_no_ea/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3777e42..ad3246a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1278,7 +1278,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 		/* Test for inline data flag but no attr */
 		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && inlinedata_fs &&
-		    EXT2_I_SIZE(inode) > EXT4_MIN_INLINE_DATA_SIZE &&
 		    (ino >= EXT2_FIRST_INODE(fs->super))) {
 			size_t size = 0;
 			errcode_t err;
@@ -1309,22 +1308,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 			case EXT2_ET_NO_INLINE_DATA:
 			case EXT2_ET_EXT_ATTR_CSUM_INVALID:
 			case EXT2_ET_EA_BAD_VALUE_OFFSET:
-				/* broken EA or no system.data EA; truncate */
+				/* broken EA or no system.data EA; remove */
 				if (fix_problem(ctx, PR_1_INLINE_DATA_NO_ATTR,
-						&pctx)) {
-					err = ext2fs_inode_size_set(fs, inode,
-							sizeof(inode->i_block));
-					if (err) {
-						pctx.errcode = err;
-						ctx->flags |= E2F_FLAG_ABORT;
-						goto endit;
-					}
-					if (LINUX_S_ISLNK(inode->i_mode))
-						inode->i_flags &= ~EXT4_INLINE_DATA_FL;
-					e2fsck_write_inode(ctx, ino, inode,
-							   "pass1");
-					failed_csum = 0;
-				}
+						&pctx))
+					goto clear_inode;
 				break;
 			default:
 				/* Some other kind of non-xattr error? */
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 4f4309e..80c6492 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1053,7 +1053,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Inode has INLINE_DATA_FL flag but extended attribute not found */
 	{ PR_1_INLINE_DATA_NO_ATTR,
 	  N_("@i %i has INLINE_DATA_FL flag but @a not found.  "),
-	  PROMPT_TRUNCATE, 0 },
+	  PROMPT_CLEAR, 0 },
 
 	/* Extents/inlinedata flag set on a device or socket inode */
 	{ PR_1_SPECIAL_EXTENTS_IDATA,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 6260c5f..187465c 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -558,9 +558,6 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	if (size <= EXT4_MIN_INLINE_DATA_SIZE) {
-		retval = ext2fs_inline_data_ea_remove(fs, ino);
-		if (retval)
-			return retval;
 		memcpy((void *)inode->i_block, buf, size);
 		return ext2fs_write_inode(fs, ino, inode);
 	}
diff --git a/tests/f_ea_value_crash/expect.1 b/tests/f_ea_value_crash/expect.1
index 8315358..3a884d1 100644
--- a/tests/f_ea_value_crash/expect.1
+++ b/tests/f_ea_value_crash/expect.1
@@ -1,15 +1,24 @@
 Pass 1: Checking inodes, blocks, and sizes
-Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Truncate? yes
-
-Inode 12 extended attribute is corrupt (allocation collision).  Clear? yes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Clear? yes
 
 Inode 13 extended attribute is corrupt (allocation collision).  Clear? yes
 
 Pass 2: Checking directory structure
+Entry 'a' in / (2) has deleted/unused inode 12.  Clear? yes
+
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (115, counted=116).
+Fix? yes
+
+Free inodes count wrong (115, counted=116).
+Fix? yes
+
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 13/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 1
diff --git a/tests/f_ea_value_crash/expect.2 b/tests/f_ea_value_crash/expect.2
index 06886a4..3b6073e 100644
--- a/tests/f_ea_value_crash/expect.2
+++ b/tests/f_ea_value_crash/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 13/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 0
diff --git a/tests/f_inline_no_ea/expect.1 b/tests/f_inline_no_ea/expect.1
new file mode 100644
index 0000000..9d3700e
--- /dev/null
+++ b/tests/f_inline_no_ea/expect.1
@@ -0,0 +1,22 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Clear? yes
+
+Pass 2: Checking directory structure
+Entry 'a' in / (2) has deleted/unused inode 12.  Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (116, counted=117).
+Fix? yes
+
+Free inodes count wrong (116, counted=117).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_inline_no_ea/expect.2 b/tests/f_inline_no_ea/expect.2
new file mode 100644
index 0000000..8025ccb
--- /dev/null
+++ b/tests/f_inline_no_ea/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 0
diff --git a/tests/f_inline_no_ea/image.gz b/tests/f_inline_no_ea/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..63c08578eb4296d6fcc78c72f857a8722169cfbf
GIT binary patch
literal 2511
zcmb2|=3rp?RS?R={Px!VY~er|h7aG@F?vU31hTj8+R+)|Dj;*)@y^ty?ga{5Nwb>@
zgSLpua{0ZTpCCT>NUX*?t|0fLQGzal?BdK$HPd6fJ2^An^53qrdswai{$1>(@00e_
zyf0E@u)gZD?}XEh`Ca*jEm<4wv=?1WSQNQuWp96thoJM`Ix|zhvxjR|>Dz|soSL_&
z$Vl}3`?dn(ss8uvfBg7x?Zfo+<?G&6R{lTX^!l}hl~q{m`+f6P&$Ta3y#C=!h)wO&
zi)XrT8}hW?TeCAa)&ANkhh0a_UVCfu{dmF1uz~Z_m-6zi=H5U1XT4hbH23O;52rX7
z85j;+D__1_q^@jj-G3_v28Iv!Pyhe_p4U*C=WI4(mGd-SKC|@??@FJ#x%Jf7R}W85
zl}?`iDOYjNyY7#RE~^36Z&>=J#Nyxi+E>PQAYSelX(k|D@P{8rk^)|@zIQ!{9jIfQ
zY`Oy}8qw7Lkp8^&<HV&mJpcZ)nj`jCagXocIGsg1mui=opL!>7dD9=;wo6@qlNKM{
zFYWO$`P+{WIe)q1<<_}>8qXRV&J-(l&VBYj;!OSO>z9N2WuNW8c3<&5S5D7PoBx*A
z^!}edv`^_jXYQx@Hs3YZ2L8MJ^Y{GPxcC3g`<eaT_#^t?cAMz0&%e8APyLiN|M8K%
zGo9-v{eL>qzCJE5<UcT^N5N<ajE2By2#kinXb6mk08K(*+wAzPxn_G97!())1v3Vl

literal 0
HcmV?d00001

diff --git a/tests/f_inline_no_ea/name b/tests/f_inline_no_ea/name
new file mode 100644
index 0000000..770273e
--- /dev/null
+++ b/tests/f_inline_no_ea/name
@@ -0,0 +1 @@
+remove inline data files which lack the xattr
diff --git a/tests/f_inlinedata_repair/expect.1 b/tests/f_inlinedata_repair/expect.1
index 9c84b14..89f0f7b 100644
--- a/tests/f_inlinedata_repair/expect.1
+++ b/tests/f_inlinedata_repair/expect.1
@@ -1,5 +1,5 @@
 Pass 1: Checking inodes, blocks, and sizes
-Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Truncate? yes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Clear? yes
 
 Inode 16, i_size is 56, should be 60.  Fix? yes
 
@@ -21,8 +21,7 @@ Salvage? yes
 Directory inode 32, block #0, offset 4: directory corrupted
 Salvage? yes
 
-Symlink /1 (inode #12) is invalid.
-Clear? yes
+Entry '1' in / (2) has deleted/unused inode 12.  Clear? yes
 
 Symlink /3 (inode #14) is invalid.
 Clear? yes
@@ -52,6 +51,15 @@ Unattached zero-length inode 34.  Clear? yes
 Unattached zero-length inode 35.  Clear? yes
 
 Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (101, counted=102).
+Fix? yes
+
+Free inodes count wrong (101, counted=102).
+Fix? yes
+
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 26/128 files (0.0% non-contiguous), 18/512 blocks
diff --git a/tests/f_write_ea_no_extra_isize/expect.1 b/tests/f_write_ea_no_extra_isize/expect.1
index b7e7438..50c81a9 100644
--- a/tests/f_write_ea_no_extra_isize/expect.1
+++ b/tests/f_write_ea_no_extra_isize/expect.1
@@ -1,12 +1,27 @@
 Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Clear? yes
+
 Pass 2: Checking directory structure
-Directory inode 12, block #0, offset 4: directory corrupted
-Salvage? yes
+Entry 'x' in / (2) has deleted/unused inode 12.  Clear? yes
 
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
+Inode 2 ref count is 4, should be 3.  Fix? yes
+
 Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (116, counted=117).
+Fix? yes
+
+Directories count wrong for group #0 (3, counted=2).
+Fix? yes
+
+Free inodes count wrong (116, counted=117).
+Fix? yes
+
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 1
diff --git a/tests/f_write_ea_no_extra_isize/expect.2 b/tests/f_write_ea_no_extra_isize/expect.2
index 3b6073e..8025ccb 100644
--- a/tests/f_write_ea_no_extra_isize/expect.2
+++ b/tests/f_write_ea_no_extra_isize/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 0
diff --git a/tests/f_write_ea_toobig_extra_isize/expect.1 b/tests/f_write_ea_toobig_extra_isize/expect.1
index b7e7438..50c81a9 100644
--- a/tests/f_write_ea_toobig_extra_isize/expect.1
+++ b/tests/f_write_ea_toobig_extra_isize/expect.1
@@ -1,12 +1,27 @@
 Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Clear? yes
+
 Pass 2: Checking directory structure
-Directory inode 12, block #0, offset 4: directory corrupted
-Salvage? yes
+Entry 'x' in / (2) has deleted/unused inode 12.  Clear? yes
 
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
+Inode 2 ref count is 4, should be 3.  Fix? yes
+
 Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (116, counted=117).
+Fix? yes
+
+Directories count wrong for group #0 (3, counted=2).
+Fix? yes
+
+Free inodes count wrong (116, counted=117).
+Fix? yes
+
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 1
diff --git a/tests/f_write_ea_toobig_extra_isize/expect.2 b/tests/f_write_ea_toobig_extra_isize/expect.2
index 3b6073e..8025ccb 100644
--- a/tests/f_write_ea_toobig_extra_isize/expect.2
+++ b/tests/f_write_ea_toobig_extra_isize/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 0
diff --git a/tests/f_write_ea_toosmall_extra_isize/expect.1 b/tests/f_write_ea_toosmall_extra_isize/expect.1
index eecfc9d..50c81a9 100644
--- a/tests/f_write_ea_toosmall_extra_isize/expect.1
+++ b/tests/f_write_ea_toosmall_extra_isize/expect.1
@@ -1,15 +1,27 @@
 Pass 1: Checking inodes, blocks, and sizes
-Inode 12 has a extra size (1) which is invalid
-Fix? yes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Clear? yes
 
 Pass 2: Checking directory structure
-Directory inode 12, block #0, offset 4: directory corrupted
-Salvage? yes
+Entry 'x' in / (2) has deleted/unused inode 12.  Clear? yes
 
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
+Inode 2 ref count is 4, should be 3.  Fix? yes
+
 Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (116, counted=117).
+Fix? yes
+
+Directories count wrong for group #0 (3, counted=2).
+Fix? yes
+
+Free inodes count wrong (116, counted=117).
+Fix? yes
+
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 1
diff --git a/tests/f_write_ea_toosmall_extra_isize/expect.2 b/tests/f_write_ea_toosmall_extra_isize/expect.2
index 3b6073e..8025ccb 100644
--- a/tests/f_write_ea_toosmall_extra_isize/expect.2
+++ b/tests/f_write_ea_toosmall_extra_isize/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+test_filesys: 11/128 files (0.0% non-contiguous), 17/512 blocks
 Exit status is 0
