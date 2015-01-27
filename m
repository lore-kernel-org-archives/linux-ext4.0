From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/54] libext2fs: strengthen i_extra_isize checks when
 reading/writing xattrs
Date: Mon, 26 Jan 2015 23:36:12 -0800
Message-ID: <20150127073612.13308.90407.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33040 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbA0HgR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:17 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Strengthen the i_extra_isize checks to look for obviously too-small
values before trying to operate on inode EAs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c                          |   10 ++++++----
 tests/f_write_ea_toobig_extra_isize/expect.1   |   12 ++++++++++++
 tests/f_write_ea_toobig_extra_isize/expect.2   |    7 +++++++
 tests/f_write_ea_toobig_extra_isize/image.gz   |  Bin
 tests/f_write_ea_toobig_extra_isize/name       |    1 +
 tests/f_write_ea_toosmall_extra_isize/expect.1 |   15 +++++++++++++++
 tests/f_write_ea_toosmall_extra_isize/expect.2 |    7 +++++++
 tests/f_write_ea_toosmall_extra_isize/image.gz |  Bin
 tests/f_write_ea_toosmall_extra_isize/name     |    1 +
 9 files changed, 49 insertions(+), 4 deletions(-)
 create mode 100644 tests/f_write_ea_toobig_extra_isize/expect.1
 create mode 100644 tests/f_write_ea_toobig_extra_isize/expect.2
 create mode 100644 tests/f_write_ea_toobig_extra_isize/image.gz
 create mode 100644 tests/f_write_ea_toobig_extra_isize/name
 create mode 100644 tests/f_write_ea_toosmall_extra_isize/expect.1
 create mode 100644 tests/f_write_ea_toosmall_extra_isize/expect.2
 create mode 100644 tests/f_write_ea_toosmall_extra_isize/image.gz
 create mode 100644 tests/f_write_ea_toosmall_extra_isize/name


diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index e8544dc..df512d8 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -536,8 +536,9 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	x = handle->attrs;
 	qsort(x, handle->length, sizeof(struct ext2_xattr), attr_compare);
 
-	/* Does the inode have size for EA? */
-	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
+	/* Does the inode have space for EA? */
+	if (inode->i_extra_isize < sizeof(inode->i_extra_isize) ||
+	    EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
 						  inode->i_extra_isize +
 						  sizeof(__u32))
 		goto write_ea_block;
@@ -773,8 +774,9 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 
 	xattrs_free_keys(handle);
 
-	/* Does the inode have size for EA? */
-	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
+	/* Does the inode have space for EA? */
+	if (inode->i_extra_isize < sizeof(inode->i_extra_isize) ||
+	    EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
 						  inode->i_extra_isize +
 						  sizeof(__u32))
 		goto read_ea_block;
diff --git a/tests/f_write_ea_toobig_extra_isize/expect.1 b/tests/f_write_ea_toobig_extra_isize/expect.1
new file mode 100644
index 0000000..b7e7438
--- /dev/null
+++ b/tests/f_write_ea_toobig_extra_isize/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Directory inode 12, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_write_ea_toobig_extra_isize/expect.2 b/tests/f_write_ea_toobig_extra_isize/expect.2
new file mode 100644
index 0000000..3b6073e
--- /dev/null
+++ b/tests/f_write_ea_toobig_extra_isize/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 0
diff --git a/tests/f_write_ea_toobig_extra_isize/image.gz b/tests/f_write_ea_toobig_extra_isize/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..291924bf62477e5f9f18c198c9d478972590f345
GIT binary patch
literal 2518
zcmb2|=3tmxGd+Zf`Ry&+Y!OEZh6m-}^`s^_@O3Vjpj4;eVQ?ceQSj)oL#Gnz1=cLm
zv~lD(l2O;tJLA~BLvcFItzwzFYgn{h1(d})6D-o-GbiuS<}oxp`B`T3;hH<T#=FhG
zzq{wg@cU}a#*@l@%ieg41!iA;zV^xsgX?F)+{Dzpj*F>nT5)~-(sL`Tb(Zh?mY%wH
z&;C%0`J1NmE2Rbfdz1F{@0;D;&gbvXtEw%1_3M;h&({2Zzh5p7m+K9)m#HxPS@6|I
z?6Khl^V`?@lUMUB55Ko?-<+WSV19-M*?=R<+k>p`b^Ol`%yL=oyVaunCJ!S6!-03@
z>$l6;d(Ez|mt|mJ`0-x!|9^g$Y5lIBBO4k|eBQY6neiUyi_`sm@2~5<H)CIM_NI*P
z3ga11%kP>2bvMK=-GBOP{lmu#eu8+mi<7v3h8*~64<tzef1<x0<V^+YNH|}}&O(Y#
zRJ9HJKbEE>E}Hx8@(%lWpV?kVvZTI8X`4o$x_J9UwX*l^efg2AelA_1oqO<KdvH`t
zly&5ir|Rp|zTN)AY@PnDZX-i)dBp$C*M4oU{40Gba{AZ&$L}XBX1blcv7`Q6S=awh
z7MHr}7dih4&T{dH7XDxI|KIcZ+m!$9p73d_{iFSR?k=6QR{N^?#{PN7y{G2oZa!)_
z!@g$G+^)akmDPWqHt+vFf6cX3=b})ZJjxplfzc2c4S~@R7!85Z5TIHJG`y>0x~TET
Joq<7t0RSPO2<HF*

literal 0
HcmV?d00001

diff --git a/tests/f_write_ea_toobig_extra_isize/name b/tests/f_write_ea_toobig_extra_isize/name
new file mode 100644
index 0000000..a5ed718
--- /dev/null
+++ b/tests/f_write_ea_toobig_extra_isize/name
@@ -0,0 +1 @@
+write EA when i_extra_size is too big for EA
diff --git a/tests/f_write_ea_toosmall_extra_isize/expect.1 b/tests/f_write_ea_toosmall_extra_isize/expect.1
new file mode 100644
index 0000000..eecfc9d
--- /dev/null
+++ b/tests/f_write_ea_toosmall_extra_isize/expect.1
@@ -0,0 +1,15 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has a extra size (1) which is invalid
+Fix? yes
+
+Pass 2: Checking directory structure
+Directory inode 12, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_write_ea_toosmall_extra_isize/expect.2 b/tests/f_write_ea_toosmall_extra_isize/expect.2
new file mode 100644
index 0000000..3b6073e
--- /dev/null
+++ b/tests/f_write_ea_toosmall_extra_isize/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 0
diff --git a/tests/f_write_ea_toosmall_extra_isize/image.gz b/tests/f_write_ea_toosmall_extra_isize/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..78a01497ec729dabc9406afb5914e76ce018cbb3
GIT binary patch
literal 2517
zcmb2|=3uBxpAo{u{Pvb@wuqwy!-MkgdQy`d_&OI%P^we#Fu0MKD0uYPp;HO<0&5m&
z+BkA#nAjh1n{@2np*Wr9R<TUoH7we$0?J~Y2^Q(^nUnWu^B5YQ{4BHiaLpY(<L&0(
z-`#U#_<c2J<4NVdWpBL20<*6^Uwh?+!R<3)ZenU)$Hmk(t+>8^>A98FI?H!`+qWs~
z-hHh({x?sz3mR+Imu>#_@7`{2=kxdHRn?Zh`gO{$XKVhu-!GSk%k_uZ%TyTt%=qdf
z_SkTO`R!}{$*Xymhu>ScZ%$BuFh4_sY`~G_?Lk)eI{s$|X1Of)-D**OlZTOk;lR7{
z{o7^iy=K?f%Q7%9{CF?=|3AOWw0_smkqwO}K5yLk%y^IU#p(XO_t*8_o3XDrds9Yt
zh4GB1<#)}1x*KAb?mzvt{^8>VKS4a(#YtR1Lk@hk2a=?KKha+g@}>fHB%Ci~XCXx=
zs@jJAA4^jb7tQ^4d53+x&up(FSyJDlv`wQ=UA%pwTG{*dzWm5lKbNl1&OP|CJvb^R
z$~tn%Q}y*}-){e5wod=%xRIf^JmUZ6YrnQv{*^uzIsI$?<M$K%S+^Ze68t~st;qkU
zg-b;LyR`pUex+l=Hno2*|NT90pX>goT=8jk{gL|0-QKFv;j8i=N!Wh&o|>0?bf5Th
zzWEu;AN_E>Cs+UT!TZ1JtGBM&EQadjQQl|>jE2By2#kinXb6mk0M$ZZ!S4Ay_uDlX
H7!())`D6t8

literal 0
HcmV?d00001

diff --git a/tests/f_write_ea_toosmall_extra_isize/name b/tests/f_write_ea_toosmall_extra_isize/name
new file mode 100644
index 0000000..718c12c
--- /dev/null
+++ b/tests/f_write_ea_toosmall_extra_isize/name
@@ -0,0 +1 @@
+write EA when i_extra_size is too small to make sense

