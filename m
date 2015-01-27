From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/54] e2fsck: handle multiple *ind block collisions with
 critical metadata
Date: Mon, 26 Jan 2015 23:37:10 -0800
Message-ID: <20150127073710.13308.92552.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45866 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbbA0HhQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:16 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An earlier patch tried to detect indirect blocks that conflicted with
critical FS metadata for the purpose of preventing corrections being
made to those indirect blocks.  Unfortunately, that patch cannot
handle more than one conflicting *ind block per file; therefore, use
the ref_block parameter to test the metadata block map to decide if
we need to avoid fixing the *ind block when we're iterating the
block's entries.  (We have to iterate the block to capture any blocks
that the block points to, as they could be in use.)

As a side note, in 1B we'll reallocate all those conflicting *ind
blocks and restart fsck, so the contents will be checked eventually.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                       |   17 +++-
 tests/f_ind_inode_collision/expect.1 |  147 ++++++++++++++++++++++++++++++++++
 tests/f_ind_inode_collision/expect.2 |    7 ++
 tests/f_ind_inode_collision/image.gz |  Bin
 tests/f_ind_inode_collision/name     |    1 
 5 files changed, 167 insertions(+), 5 deletions(-)
 create mode 100644 tests/f_ind_inode_collision/expect.1
 create mode 100644 tests/f_ind_inode_collision/expect.2
 create mode 100644 tests/f_ind_inode_collision/image.gz
 create mode 100644 tests/f_ind_inode_collision/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index faafa7c..2089943 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -93,7 +93,6 @@ struct process_block_struct {
 	struct problem_context *pctx;
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
-	blk64_t		bad_ref;
 	region_t	region;
 };
 
@@ -2791,7 +2790,6 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.pctx = pctx;
 	pb.ctx = ctx;
 	pb.inode_modified = 0;
-	pb.bad_ref = 0;
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
@@ -3175,7 +3173,6 @@ static int process_block(ext2_filsys fs,
 	if (blockcnt < 0 &&
 	    p->ino != EXT2_RESIZE_INO &&
 	    ext2fs_test_block_bitmap2(ctx->block_metadata_map, blk)) {
-		p->bad_ref = blk;
 		pctx->blk = blk;
 		fix_problem(ctx, PR_1_CRITICAL_METADATA_COLLISION, pctx);
 		ctx->flags |= E2F_FLAG_RESTART_LATER;
@@ -3185,13 +3182,23 @@ static int process_block(ext2_filsys fs,
 		p->num_illegal_blocks++;
 		/*
 		 * A bit of subterfuge here -- we're trying to fix a block
-		 * mapping, but know that the IND/DIND/TIND block has collided
+		 * mapping, but the IND/DIND/TIND block could have collided
 		 * with some critical metadata.  So, fix the in-core mapping so
 		 * iterate won't go insane, but return 0 instead of
 		 * BLOCK_CHANGED so that it won't write the remapping out to
 		 * our multiply linked block.
+		 *
+		 * Even if we previously determined that an *IND block
+		 * conflicts with critical metadata, we must still try to
+		 * iterate the *IND block as if it is an *IND block to find and
+		 * mark the blocks it points to.  Better to be overly cautious
+		 * with the used_blocks map so that we don't move the *IND
+		 * block to a block that's really in use!
 		 */
-		if (p->bad_ref && ref_block == p->bad_ref) {
+		if (p->ino != EXT2_RESIZE_INO &&
+		    ref_block != 0 &&
+		    ext2fs_test_block_bitmap2(ctx->block_metadata_map,
+					      ref_block)) {
 			*block_nr = 0;
 			return 0;
 		}
diff --git a/tests/f_ind_inode_collision/expect.1 b/tests/f_ind_inode_collision/expect.1
new file mode 100644
index 0000000..012cd9f
--- /dev/null
+++ b/tests/f_ind_inode_collision/expect.1
@@ -0,0 +1,147 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 block 41 conflicts with critical metadata, skipping block checks.
+Inode 12 block 40 conflicts with critical metadata, skipping block checks.
+Inode 12 block 34 conflicts with critical metadata, skipping block checks.
+Illegal block number passed to ext2fs_test_block_bitmap #16777215 for metadata block map
+Inode 12 block 1 conflicts with critical metadata, skipping block checks.
+Inode 12, i_size is 33, should be 25227264.  Fix? yes
+
+Inode 12, i_blocks is 999, should be 184.  Fix? yes
+
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 2: 3
+Multiply-claimed block(s) in inode 7: 11
+Multiply-claimed block(s) in inode 11: 4--7
+Multiply-claimed block(s) in inode 12: 41 40Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16877 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #4096 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #196608 for multiply claimed block map
+ 34 8 3Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #33152 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #4243456 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #65536 for multiply claimed block map
+ 28 8 11 1Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16832 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16384 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #131072 for multiply claimed block map
+ 28 4--7Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #33206 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #25227264 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #65536 for multiply claimed block map
+ 28 41Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16777215 for multiply claimed block map
+ 28
+Error while iterating over blocks in inode 12 (pass1b): Illegal indirect block found
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 3 inodes containing multiply-claimed blocks.)
+
+File / (inode #2, mod time Sat Jan 17 21:16:16 2015) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/a (inode #12, mod time Sat Jan 17 21:16:37 2015)
+Clone multiply-claimed blocks? yes
+
+File /lost+found (inode #11, mod time Sat Jan 17 21:16:16 2015) 
+  has 4 multiply-claimed block(s), shared with 1 file(s):
+	/a (inode #12, mod time Sat Jan 17 21:16:37 2015)
+Clone multiply-claimed blocks? yes
+
+File /a (inode #12, mod time Sat Jan 17 21:16:37 2015) 
+  has 17 multiply-claimed block(s), shared with 4 file(s):
+	<filesystem metadata>
+	/lost+found (inode #11, mod time Sat Jan 17 21:16:16 2015)
+	<The group descriptor inode> (inode #7, mod time Sat Jan 17 21:16:16 2015)
+	/ (inode #2, mod time Sat Jan 17 21:16:16 2015)
+Clone multiply-claimed blocks? yes
+
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16877 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #4096 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #196608 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #33152 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #4243456 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #65536 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16832 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16384 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #131072 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529376 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #33206 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #25227264 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #65536 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #1421529397 for multiply claimed block map
+Illegal block number passed to ext2fs_test_block_bitmap #16777215 for multiply claimed block map
+Pass 2: Checking directory structure
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has illegal block(s).  Clear? yes
+
+Illegal block #1038 (1421529376) in inode 12.  CLEARED.
+Illegal block #1039 (1421529376) in inode 12.  CLEARED.
+Illegal block #1040 (1421529376) in inode 12.  CLEARED.
+Illegal block #1100 (16877) in inode 12.  CLEARED.
+Illegal block #1101 (4096) in inode 12.  CLEARED.
+Illegal block #1102 (1421529376) in inode 12.  CLEARED.
+Illegal block #1103 (1421529376) in inode 12.  CLEARED.
+Illegal block #1104 (1421529376) in inode 12.  CLEARED.
+Illegal block #1106 (196608) in inode 12.  CLEARED.
+Illegal block #1136 (1421529376) in inode 12.  CLEARED.
+Illegal block #1420 (33152) in inode 12.  CLEARED.
+Too many illegal blocks in inode 12.
+Clear inode? yes
+
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Entry 'a' in / (2) has deleted/unused inode 12.  Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(3--7) -(15--17) -(19--24)
+Fix? yes
+
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
+test_filesys: 11/128 files (9.1% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_ind_inode_collision/expect.2 b/tests/f_ind_inode_collision/expect.2
new file mode 100644
index 0000000..d0a6dac
--- /dev/null
+++ b/tests/f_ind_inode_collision/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (9.1% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_ind_inode_collision/image.gz b/tests/f_ind_inode_collision/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..924d220f6887030e2584b344847814b02fe055e1
GIT binary patch
literal 2456
zcmb2|=3o%Myeou>`R%R!*}{P`3?Is;N37;t;vv4!`Amx7CQ+Hk&+^P11&%l#<y$t{
zJ0>Qir0lDGzz6r07kp*7^ZqgVY5kLE{Ty4QX?Q0o+jnxE-NWkRzbEeAQ-1vM-qWoN
zGNFHKCbtz>z1ydv_@(R5mJY|(x<LJ^J)3XxDxTJ>^>tb!H>>$eK+v0P*GDyVJrxsn
z|5Oyacc<e2uFqfIzWVf3e*G%`<rl9#|DIo$Z@cqG?Z%G}ZZ2M{{r=PaX#e)q$8Udx
zhdol)Jh}du#lvgN3<+GHUcO%`vG(Af{o<Fe-rW@U<69s<BLl;MH>br`KMYTmzt7IV
zz`(cn&;S2b9+%1__HhUBXWq)=zyC0nPyKTA>+-7S>(=Mr**9%^>xYFCRl;q}fSMa-
z2F;H6|38Q4`hTG219KuTu>$FYzx+Tl;y*KxBoZ7rcuGn*6R0@hT?G>pk(#h5J8(ba
zT~3*M;gnl{e>&aKnYwkqkl688p?oj?Xscd7c$ec3|KIAu&382=|4*_%wtw#m-zCD2
z<z=*P|NOH&*zCWjbMcxu(_<SYxDETxU;OhtRp$S>BY&f8-fOrmzPh~D?^oFO3;#?X
z%VV(^EOe%4vtg9sCY{@7y-T=pDH;_Y4S~@R7!85Z5Eu=C(GVam1P)yJ%Vzdsc>n{0
G0s{axvFe2Y

literal 0
HcmV?d00001

diff --git a/tests/f_ind_inode_collision/name b/tests/f_ind_inode_collision/name
new file mode 100644
index 0000000..11feee3
--- /dev/null
+++ b/tests/f_ind_inode_collision/name
@@ -0,0 +1 @@
+multiple *ind collisions with critical metadata

