From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] tests: add two more tests of orphaned inode handling
Date: Tue, 12 Jun 2012 01:45:07 -0400
Message-ID: <1339479907-19088-2-git-send-email-tytso@mit.edu>
References: <1339467762-5725-1-git-send-email-tytso@mit.edu>
 <1339479907-19088-1-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49239 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2FLFpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2012 01:45:12 -0400
In-Reply-To: <1339479907-19088-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add two tests, f_orphan_indirect_inode, and f_orphan_extents_inode,
which tests the bug fixes in the two previous commits:

e2fsck: update global free blocks/inodes count when truncating orphan inodes
libext2fs: fix block iterator for extents when truncating inodes

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_orphan_extents_inode/expect.1  |  10 ++++++++++
 tests/f_orphan_extents_inode/expect.2  |   7 +++++++
 tests/f_orphan_extents_inode/image.gz  | Bin 0 -> 564 bytes
 tests/f_orphan_extents_inode/name      |   1 +
 tests/f_orphan_indirect_inode/expect.1 |   2 ++
 tests/f_orphan_indirect_inode/expect.2 |   7 +++++++
 tests/f_orphan_indirect_inode/image.gz | Bin 0 -> 592 bytes
 tests/f_orphan_indirect_inode/name     |   1 +
 tests/f_orphan_indirect_inode/script   |   2 ++
 9 files changed, 30 insertions(+)
 create mode 100644 tests/f_orphan_extents_inode/expect.1
 create mode 100644 tests/f_orphan_extents_inode/expect.2
 create mode 100644 tests/f_orphan_extents_inode/image.gz
 create mode 100644 tests/f_orphan_extents_inode/name
 create mode 100644 tests/f_orphan_indirect_inode/expect.1
 create mode 100644 tests/f_orphan_indirect_inode/expect.2
 create mode 100644 tests/f_orphan_indirect_inode/image.gz
 create mode 100644 tests/f_orphan_indirect_inode/name
 create mode 100644 tests/f_orphan_indirect_inode/script

diff --git a/tests/f_orphan_extents_inode/expect.1 b/tests/f_orphan_extents_inode/expect.1
new file mode 100644
index 0000000..2eaab78
--- /dev/null
+++ b/tests/f_orphan_extents_inode/expect.1
@@ -0,0 +1,10 @@
+Truncating orphaned inode 12 (uid=0, gid=0, mode=0100644, size=0)
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/16 files (0.0% non-contiguous), 21/100 blocks
+Exit status is 1
diff --git a/tests/f_orphan_extents_inode/expect.2 b/tests/f_orphan_extents_inode/expect.2
new file mode 100644
index 0000000..4ee5d96
--- /dev/null
+++ b/tests/f_orphan_extents_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 21/100 blocks
+Exit status is 0
diff --git a/tests/f_orphan_extents_inode/image.gz b/tests/f_orphan_extents_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..6c57fef553f44be6dd97bb2449827dd0ce5a0007
GIT binary patch
literal 564
zc-oWi=HT#Lc+H=QIlrhNBQZ}mwW1_7ucTNvGcP|SRWCC)o#E|W`)uJv8TJp)cX~VC
zc34$bARuyNAxGx&S1TN?cBFg|73rFs%dUOHPxpt}624NwazPoZj?K+3uc8G?FF3|L
zn!KBPhKWMP)C)CsAI{27SHCmgX21OQCqhgHE7O9*f|mt}1!ZY|yv{iN)R$wn_g`<(
zw|TiG`9<0Ln$Dv;{%%=ozvchVnN#LYd9Artr)BMynypuJYin**efjZq_S>53pNBsb
z>a1Ct|L^qYHOp;we|u!Gzc%~j(@zio-2T=7ed8^;wsVgyjtbtcx?XYeN;1zA&F4XS
z;$P#rBMq&8fBy1$mNtue`1T7L*Y=k;dQKAke!wt$S?bPtsb|wF`R&D*ZLXI7ZodBB
z-HHwSqV8$$Kb;(N(d?ni49Qjh^D86&A81*zlV!m_#;^P<>K*<vzmgC5-|&n5ial6}
zfuUz{-r@WOi9s(L7*K#g-M8;nZ|nX&ud~0)bM*7^s^7LNg7!@o|L-nyXr;jA*I%w%
ze3-FG!e(2~{_UG*$BAWcUHsWT?DPBca|<hv-*a65U#IU?eWXSF*ZBsE{$B}R*0=cm
zyRhShOa31%NM7*&Df937zB_|-r8SE+#aHjED9eyv{ybdn*D^*1N<hQ?pPcCj7~e8X
HU}OLQ$zlQb

literal 0
Hc-jL100001

diff --git a/tests/f_orphan_extents_inode/name b/tests/f_orphan_extents_inode/name
new file mode 100644
index 0000000..fc48ec2
--- /dev/null
+++ b/tests/f_orphan_extents_inode/name
@@ -0,0 +1 @@
+truncating an orphaned extent-mapped inode
diff --git a/tests/f_orphan_indirect_inode/expect.1 b/tests/f_orphan_indirect_inode/expect.1
new file mode 100644
index 0000000..33cdd65
--- /dev/null
+++ b/tests/f_orphan_indirect_inode/expect.1
@@ -0,0 +1,2 @@
+test_filesys: clean, 12/16 files, 21/100 blocks
+Exit status is 0
diff --git a/tests/f_orphan_indirect_inode/expect.2 b/tests/f_orphan_indirect_inode/expect.2
new file mode 100644
index 0000000..4ee5d96
--- /dev/null
+++ b/tests/f_orphan_indirect_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 21/100 blocks
+Exit status is 0
diff --git a/tests/f_orphan_indirect_inode/image.gz b/tests/f_orphan_indirect_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..54b39094350bfb528a4202b9cb3d3be38ddab209
GIT binary patch
literal 592
zc-oWi=HQsW@R~mpbAC}lMq-|BW?o8WQEGAtkddE~s+XCY&hYlGZMJZs%z=;pW0kU2
zZ_8TCzx7)CuZZ5SoFY~$niqL5T&L$$D3E#Z)jhx1Ilq`h9FI5(91(x;Oj<y_uslGV
zeftmZcS;N2DqRga^PKs<8K?NAKh^t{%e{k`tU~imB-eIl1)83^Wqu?6O7y+jUvC~)
zOndb;`u^r;W&DrovM*ozyle5z7fDm5_v`PeFUs8T|Jmc~@yFEH-Jg9j{C90$*S&o^
zYv0~J@bqE0eq5jL-G~`yP949z==(?W)H1_s8@wz(AN>;^oaeb9`O56JS=;NcHTGRf
z=3EfGbld0qVXJ@seEfRqBbFr}cYRJ>YdrZ|@x-rot3L9dId`=GVpi$PfAiP=h}m)e
z)4Iy{Qpe|CeA-uEdF$%7yKNcCS3=|N=fs%bk;(0>I`w)*^y1u$-|Q>?J}*A{{-^5k
z{W`I^xAWYu$iMB8s=xj&!{0>UZ7<v6+KT~|C%-w|F1D{dcl^)tNWXh`rf=T!?RVL{
z>sd$b?oHqI>Gx%0e)o5N_OoW`eEZ2iRcCkd%?JB0?9KRBAJX-c-OA;vP{U95GxiDp
z7(esRs6X(B`I)@If3Oe(GT0!*zS#L<L5YQxkZf<C>+!|H7d=Xhtforc7o2zL<&{6D
g)|9AONzd&*=Ps_J&Oj+RFzY*a!K>vl3=<d`05fVA1poj5

literal 0
Hc-jL100001

diff --git a/tests/f_orphan_indirect_inode/name b/tests/f_orphan_indirect_inode/name
new file mode 100644
index 0000000..04ccb31
--- /dev/null
+++ b/tests/f_orphan_indirect_inode/name
@@ -0,0 +1 @@
+truncating an orphaned inode in preen mode
diff --git a/tests/f_orphan_indirect_inode/script b/tests/f_orphan_indirect_inode/script
new file mode 100644
index 0000000..ea3b93a
--- /dev/null
+++ b/tests/f_orphan_indirect_inode/script
@@ -0,0 +1,2 @@
+FSCK_OPT=-p
+. $cmd_dir/run_e2fsck
-- 
1.7.10.2.552.gaa3bb87

