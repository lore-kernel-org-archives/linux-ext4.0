From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/25] e2fsck: ignore badblocks if it says badblocks inode is
 bad
Date: Thu, 11 Sep 2014 12:44:49 -0700
Message-ID: <20140911194449.GT10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19900 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaIKToz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 15:44:55 -0400
Content-Disposition: inline
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the badblocks list says that the badblocks inode is bad, it's quite
likely that badblocks is broken.  Worse yet, if the root inode is in
the same block as the badblocks inode (likely since they're adjacent),
the filesystem becomes unfixable because pass3 notices the bad root
inode and exits.

So... if we encounter this case, just kill the badblocks inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c            |   31 +++++++++++++++++++++++++++++++
 e2fsck/problem.c          |    5 +++++
 e2fsck/problem.h          |    3 +++
 tests/f_bb_in_bb/expect.1 |   17 +++++++++++++++++
 tests/f_bb_in_bb/expect.2 |    7 +++++++
 tests/f_bb_in_bb/image.gz |  Bin
 tests/f_bb_in_bb/name     |    1 +
 7 files changed, 64 insertions(+)
 create mode 100644 tests/f_bb_in_bb/expect.1
 create mode 100644 tests/f_bb_in_bb/expect.2
 create mode 100644 tests/f_bb_in_bb/image.gz
 create mode 100644 tests/f_bb_in_bb/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index f09cddb..7dfb1bd 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1141,6 +1141,37 @@ void e2fsck_pass1(e2fsck_t ctx)
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE) {
+			/*
+			 * If badblocks says badblocks is bad, offer to clear
+			 * the list, update the in-core bb list, and restart
+			 * the inode scan.
+			 */
+			if (ino == EXT2_BAD_INO &&
+			    fix_problem(ctx, PR_1_BADBLOCKS_IN_BADBLOCKS,
+					&pctx)) {
+				errcode_t err;
+
+				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
+				ext2fs_badblocks_list_free(ctx->fs->badblocks);
+				ctx->fs->badblocks = NULL;
+				err = ext2fs_read_bb_inode(ctx->fs,
+							&ctx->fs->badblocks);
+				if (err) {
+					fix_problem(ctx, PR_1_ISCAN_ERROR,
+						    &pctx);
+					ctx->flags |= E2F_FLAG_ABORT;
+					goto endit;
+				}
+				err = ext2fs_inode_scan_goto_blockgroup(scan,
+									0);
+				if (err) {
+					fix_problem(ctx, PR_1_ISCAN_ERROR,
+						    &pctx);
+					ctx->flags |= E2F_FLAG_ABORT;
+					goto endit;
+				}
+				continue;
+			}
 			if (!ctx->inode_bb_map)
 				alloc_bb_map(ctx);
 			ext2fs_mark_inode_bitmap2(ctx->inode_bb_map, ino);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 4b41a21..79bba1a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1086,6 +1086,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has inline data and @x flags set but i_block contains junk.\n"),
 	  PROMPT_CLEAR_INODE, 0 },
 
+	/* Bad block list says the bad block list inode is bad */
+	{ PR_1_BADBLOCKS_IN_BADBLOCKS,
+	  N_("Bad block list says the bad block list @i is bad.  "),
+	  PROMPT_CLEAR_INODE, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f86c531..5b32aeb 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -632,6 +632,9 @@ struct problem_context {
 /* inlinedata/extent set, clear inode */
 #define PR_1_CLEAR_EXTENT_INLINE_DATA_INODE	0x01007A
 
+/* badblocks is in badblocks */
+#define PR_1_BADBLOCKS_IN_BADBLOCKS		0x01007B
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_bb_in_bb/expect.1 b/tests/f_bb_in_bb/expect.1
new file mode 100644
index 0000000..1d719e5
--- /dev/null
+++ b/tests/f_bb_in_bb/expect.1
@@ -0,0 +1,17 @@
+Pass 1: Checking inodes, blocks, and sizes
+Bad block list says the bad block list inode is bad.  Clear inode? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (493, counted=494).
+Fix? yes
+
+Free blocks count wrong (493, counted=494).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_bb_in_bb/expect.2 b/tests/f_bb_in_bb/expect.2
new file mode 100644
index 0000000..411e656
--- /dev/null
+++ b/tests/f_bb_in_bb/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bb_in_bb/image.gz b/tests/f_bb_in_bb/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e2c46c09ed2f92070579537d0b03faf9796970dd
GIT binary patch
literal 2414
zcmb2|=3ubDE)c@R{Pxzy>|jR;h7a%K<RfM|G(S)Xo8s3r;pWOCM?DKNVp+@!g}O7A
z=@ni)dGY_DgN_F`mJ}Afd+<mjqwqpghk$<Ndet_KBwgRf@5SHsy}!5jfb7E`@1D9c
z{9k=<ftHfr^E7qWlGpzh=^bX=TNSfy)7_}<7vIC}mwNmzRK1$Jm{0F%ns)t3w>)|K
zoxd_3-<`^T-v4gR*3z=_?;6jl9v_<Be}7(__2);gPe0pv_4@aql0}g{=U(5BIyK*9
z;r=sEcg>e$U~o^E@NeFk)XEwE%Zp>)#lJpwJ3Wkpfq|iK|Gyf^`_K6b?13DEuWbMS
zn=6aHU2%^!!!2;j?W@*%-iwQOS-<`+AG2rgy}i|^HwyvPS*(*ve*Ry-`|3}5Aa91D
zt~ZckIQJh&G<*gbL@bb5_pfuK1W@%1%XtmNYQm!K!|^CV?b~a&?%j0V*4`+k(rx*^
z;-BH4=dXSqf0cWF@D%0mOCNSLM@x0PUzdMi@Kx?v)@I|x|K9d*|JN@z6jT2#?=$tR
z<G;%@r~DTw{Ad2tKT`ZBKNf37g+@bQGz3ONU^E0qLtr!ns1gE~pRg}xmOQ|~puhkC
D<cZO-

literal 0
HcmV?d00001

diff --git a/tests/f_bb_in_bb/name b/tests/f_bb_in_bb/name
new file mode 100644
index 0000000..88727e1
--- /dev/null
+++ b/tests/f_bb_in_bb/name
@@ -0,0 +1 @@
+bad block inode table block in bad block list
