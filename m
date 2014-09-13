From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/34] e2fsck: fix sliding the directory block down on
 bigalloc
Date: Sat, 13 Sep 2014 15:11:25 -0700
Message-ID: <20140913221125.13646.11024.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32117 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaIMWLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:11:31 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we find a hole in a directory on a bigalloc filesystem, we need to
obey the cluster alignment rules when collapsing the gap to avoid
later complaints.

Specifically, the calculation of the new logical cluster number was
incorrect, and we need to ensure that the logical cluster alignment
respects the physical cluster alignment, since we've concluded that
the extent's logical block number is wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c            |    6 ++--
 tests/f_holedir4/expect.1 |   68 +++++++++++++++++++++++++++++++++++++++++++++
 tests/f_holedir4/expect.2 |   11 +++++++
 tests/f_holedir4/image.gz |  Bin
 tests/f_holedir4/name     |    1 +
 5 files changed, 83 insertions(+), 3 deletions(-)
 create mode 100644 tests/f_holedir4/expect.1
 create mode 100644 tests/f_holedir4/expect.2
 create mode 100644 tests/f_holedir4/image.gz
 create mode 100644 tests/f_holedir4/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index aaeb70a..db5273e 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2568,9 +2568,9 @@ report_problem:
 			new_lblk = pb->last_block + 1;
 			if (EXT2FS_CLUSTER_RATIO(ctx->fs) > 1)
 				new_lblk = ((new_lblk +
-					     EXT2FS_CLUSTER_RATIO(ctx->fs)) &
-					    EXT2FS_CLUSTER_MASK(ctx->fs)) |
-					   (extent.e_lblk &
+					     EXT2FS_CLUSTER_RATIO(ctx->fs) - 1) &
+					    ~EXT2FS_CLUSTER_MASK(ctx->fs)) |
+					   (extent.e_pblk &
 					    EXT2FS_CLUSTER_MASK(ctx->fs));
 			pctx->blk = extent.e_lblk;
 			pctx->blk2 = new_lblk;
diff --git a/tests/f_holedir4/expect.1 b/tests/f_holedir4/expect.1
new file mode 100644
index 0000000..1e66fb6
--- /dev/null
+++ b/tests/f_holedir4/expect.1
@@ -0,0 +1,68 @@
+Pass 1: Checking inodes, blocks, and sizes
+Directory inode 12 block 211 should be at block 25.  Fix? yes
+
+Inode 12, i_size is 4096, should be 110592.  Fix? yes
+
+Inode 12, i_blocks is 128, should be 256.  Fix? yes
+
+Pass 2: Checking directory structure
+Directory inode 12 has an unallocated block #2.  Allocate? yes
+
+Directory inode 12 has an unallocated block #3.  Allocate? yes
+
+Directory inode 12 has an unallocated block #4.  Allocate? yes
+
+Directory inode 12 has an unallocated block #5.  Allocate? yes
+
+Directory inode 12 has an unallocated block #6.  Allocate? yes
+
+Directory inode 12 has an unallocated block #7.  Allocate? yes
+
+Directory inode 12 has an unallocated block #8.  Allocate? yes
+
+Directory inode 12 has an unallocated block #9.  Allocate? yes
+
+Directory inode 12 has an unallocated block #10.  Allocate? yes
+
+Directory inode 12 has an unallocated block #11.  Allocate? yes
+
+Directory inode 12 has an unallocated block #12.  Allocate? yes
+
+Directory inode 12 has an unallocated block #13.  Allocate? yes
+
+Directory inode 12 has an unallocated block #14.  Allocate? yes
+
+Directory inode 12 has an unallocated block #15.  Allocate? yes
+
+Directory inode 12 has an unallocated block #16.  Allocate? yes
+
+Directory inode 12 has an unallocated block #17.  Allocate? yes
+
+Directory inode 12 has an unallocated block #18.  Allocate? yes
+
+Directory inode 12 has an unallocated block #19.  Allocate? yes
+
+Directory inode 12 has an unallocated block #20.  Allocate? yes
+
+Directory inode 12 has an unallocated block #21.  Allocate? yes
+
+Directory inode 12 has an unallocated block #22.  Allocate? yes
+
+Directory inode 12 has an unallocated block #23.  Allocate? yes
+
+Directory inode 12 has an unallocated block #24.  Allocate? yes
+
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (26, counted=25).
+Fix? yes
+
+Free blocks count wrong (416, counted=400).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/32 files (7.7% non-contiguous), 112/512 blocks
+Exit status is 1
diff --git a/tests/f_holedir4/expect.2 b/tests/f_holedir4/expect.2
new file mode 100644
index 0000000..1f0e351
--- /dev/null
+++ b/tests/f_holedir4/expect.2
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12, i_blocks is 3072, should be 128.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/32 files (0.0% non-contiguous), 112/512 blocks
+Exit status is 1
diff --git a/tests/f_holedir4/image.gz b/tests/f_holedir4/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..8ab12454dc873c181981df34621d9b6c39551ee1
GIT binary patch
literal 2535
zcmb2|=3vmV6AocwetXk5Ti8*C{lUzQ9+|;GJqliqAGO%@n*z85_ij-?SjV7yDR`q(
z=o-14{B7#LRbP27QHW#FoLBW-!}bTG%aJ>;Rc_u8Z_01kx8%HVowfCB-)a9<bc{VY
z4iuIy+~}z|=j_?j5>87k=JB^qKD+myfLPb(O)EE^O5uo(-oF3n1b_b3i+k(5b#5J8
zRIF<*|5@7hbfxv)%Dl?jKVMHxH|C$Vzy6*@N0fQI&fPhc_JO}Yq`iA}>S^asiL8ZF
zqRzivvpCxAlX98Gz3Im9R<ko4V9fBT_kSA0(`)LWIw#|tU$oZ4kJ`#C3=9nJ_dnnG
zVa^X^y-2NNWCYS=f(Q9IbI*hHSIvrdAkz$xwjbiF7f(G|))#y?e*N>a1<QZ^KIF9d
zZGIkm-I1D<=rcPnwZ85z`5{vy-S~IIh8gCsxAJ}8A93gZzx!)#|GxOg-hQeo`CssB
zlmDLk=l=h)HLmQ*bNjbH??>&+v!46ffA=eY%km;S(cj*&tLk&-zpmeYBP+irRPFZ7
ze=X(L<jbz!*R6hif1e#W?%%8Mbc&PD)%f3<p~dM2@8|O|XQq|Cd${!FP51BbP3L9L
ztv288Y$^RzVmXf@Ip!nuIQUDP(QKWuYNxN|*CMa0s|ta^-Z0NNhXbhOz%O|qx#1r>
zLOH!yKQ;#$8-^CoE_(HJ%Bs-EOh9}0rmWcduiw9`Zf}kcy_`XwJr?`gio6t$EqC1?
vXQl=;;==0J|0`eDlV{kduF((}4S~@R7!83z6ao#-FVz?F-&)SVpuhkC?Cc78

literal 0
HcmV?d00001

diff --git a/tests/f_holedir4/name b/tests/f_holedir4/name
new file mode 100644
index 0000000..5eb55c1
--- /dev/null
+++ b/tests/f_holedir4/name
@@ -0,0 +1 @@
+bigalloc directory with hole and misaligned extent after hole

