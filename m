From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: check extent-mapped directories with really large logical blocks
Date: Sun, 28 Jul 2013 21:05:03 -0400
Message-ID: <1375059903-15581-1-git-send-email-tytso@mit.edu>
Cc: temnota.am@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45892 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab3G2D0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Jul 2013 23:26:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

E2fsck was missing a check for directories with logical blocks so
large that i_size > 2GB.  Without this check the test image found in
the new test f_toobig_extent_dir will cause e2fsck to die with a
memory allocation failure:

Error storing directory block information (inode=12, block=0, num=475218819): Memory allocation failed
e2fsck: aborted

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Andrey Melnikov <temnota.am@gmail.com>
---
 e2fsck/pass1.c                     |   5 +++++
 tests/f_toobig_extent_dir/expect.1 |  12 ++++++++++++
 tests/f_toobig_extent_dir/expect.2 |   7 +++++++
 tests/f_toobig_extent_dir/image.gz | Bin 0 -> 822 bytes
 tests/f_toobig_extent_dir/name     |   1 +
 5 files changed, 25 insertions(+)
 create mode 100644 tests/f_toobig_extent_dir/expect.1
 create mode 100644 tests/f_toobig_extent_dir/expect.2
 create mode 100644 tests/f_toobig_extent_dir/image.gz
 create mode 100644 tests/f_toobig_extent_dir/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index af9afe3..8f2f961 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1797,12 +1797,17 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			 (extent.e_pblk + extent.e_len) >
 			 ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_ENDS_BEYOND;
+		else if (is_leaf && is_dir &&
+			 ((extent.e_lblk + extent.e_len) >
+			  (1 << (21 - ctx->fs->super->s_log_block_size))))
+			problem = PR_1_TOOBIG_DIR;
 
 		if (problem) {
 report_problem:
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
+			pctx->blkcount = extent.e_lblk + extent.e_len;
 			if (fix_problem(ctx, problem, pctx)) {
 				e2fsck_read_bitmaps(ctx);
 				pctx->errcode =
diff --git a/tests/f_toobig_extent_dir/expect.1 b/tests/f_toobig_extent_dir/expect.1
new file mode 100644
index 0000000..610ca3f
--- /dev/null
+++ b/tests/f_toobig_extent_dir/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 is too big.  Truncate? yes
+
+Block #4294967281 (90) causes directory to be too big.  CLEARED.
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/56 files (0.0% non-contiguous), 28/400 blocks
+Exit status is 1
diff --git a/tests/f_toobig_extent_dir/expect.2 b/tests/f_toobig_extent_dir/expect.2
new file mode 100644
index 0000000..c025645
--- /dev/null
+++ b/tests/f_toobig_extent_dir/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/56 files (0.0% non-contiguous), 28/400 blocks
+Exit status is 0
diff --git a/tests/f_toobig_extent_dir/image.gz b/tests/f_toobig_extent_dir/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..622f65a0526aa8c6b6b13f5cd27e045b9f7132d9
GIT binary patch
literal 822
zc-oWi=3w}`{%ar;^V>W7v#$imFnstvX|qSPMus3eJL`5iclDP_D<+p|A6>emLn&yD
z?3!jjb&jUyT^|3r#Ldms-CYYxFJ0Bzx+uEF^WB24OBA*i#o5XKc&0l2$-Sq?zjJfm
z;bzQOwNu1DiR1FhSnpixt%bkYj=!GqTGuZAW(>zd4Ke%US-XE`?YwqBU&(d*_q)$G
z3A|hK?cw&L-Tv3l&#(OR_wViG@9*nw%wOEOd!6m4UynBnM~femi@9I1`Ol*(tBYQr
zytnJ^@s0QQubBF%E4p7X;9hs?yZLKA?U()ZYI2nIoVq7Gj0aw5cCGxN{J&Xt7psBN
zrdN^{X>+e!`y6@g<(2avE+^XT-dL5L`|Q@Mx3j}vr#~&PJfo*Q+dxRI?&SZqd(PD_
zaMWjH{K<c!-r*nfC;18g8~(6Au~+yH7J9IMf;H;}kI4uB*DqMvwQ?8ZEO%BG24v9i
z(0Ko*ofrD+Z@yo?d7)H&&W8VCrgEMf?5kh?xV|HK#-<sM8crXRD}BH8WX@{SivLG#
z`Mb+cyp*ldKmE)2_wHYlTNm%XGQa4~l8yT#{_8ER`+f0!efr<iY_IM=6p8Ozr15-u
Wj2FWwpa+n8qb@YfUX#IrjR61xdh@3M

literal 0
Hc-jL100001

diff --git a/tests/f_toobig_extent_dir/name b/tests/f_toobig_extent_dir/name
new file mode 100644
index 0000000..d7453ad
--- /dev/null
+++ b/tests/f_toobig_extent_dir/name
@@ -0,0 +1 @@
+directory with a very large lblk in extent
-- 
1.7.12.rc0.22.gcdd159b

