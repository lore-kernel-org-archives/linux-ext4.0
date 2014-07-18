From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/24] e2fsck: always submit logical block 0 of a directory
 for pass 2
Date: Fri, 18 Jul 2014 15:54:38 -0700
Message-ID: <20140718225438.31374.51461.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33531 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbaGRWyq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:54:46 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Always iterate logical block 0 in a directory, even if no physical
block has been allocated.  Pass 2 will notice the lack of mapping and
offer to allocate a new directory block; this enables us to link the
directory into lost+found.

Previously, if there were no logical blocks mapped, we would fail to
pick up even block 0 of the directory for processing in pass 2.  This
meant that e2fsck never allocated a block 0 and therefore wouldn't fix
the missing . and .. entries for the directory; subsequent e2fsck runs
would complain about (yet never fix) the problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c            |   15 +++++++++++++++
 tests/f_emptydir/expect.1 |   19 +++++++++++++++++++
 tests/f_emptydir/expect.2 |    7 +++++++
 tests/f_emptydir/image.gz |  Bin
 tests/f_emptydir/name     |    2 ++
 5 files changed, 43 insertions(+)
 create mode 100644 tests/f_emptydir/expect.1
 create mode 100644 tests/f_emptydir/expect.2
 create mode 100644 tests/f_emptydir/image.gz
 create mode 100644 tests/f_emptydir/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 756e3bb..7a16780 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2652,6 +2652,21 @@ static int process_block(ext2_filsys fs,
 		return 0;
 	}
 
+	/*
+	 * For a directory, add logical block zero for processing even if it's
+	 * not mapped or we'll be perennially stuck with broken "." and ".."
+	 * entries.
+	 */
+	if (p->is_dir && blockcnt == 0 && blk == 0) {
+		pctx->errcode = ext2fs_add_dir_block2(fs->dblist, p->ino, 0, 0);
+		if (pctx->errcode) {
+			pctx->blk = blk;
+			pctx->num = blockcnt;
+			goto failed_add_dir_block;
+		}
+		p->last_db_block++;
+	}
+
 	if (blk == 0)
 		return 0;
 
diff --git a/tests/f_emptydir/expect.1 b/tests/f_emptydir/expect.1
new file mode 100644
index 0000000..c612621
--- /dev/null
+++ b/tests/f_emptydir/expect.1
@@ -0,0 +1,19 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12, i_size is 1024, should be 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Directory inode 12 has an unallocated block #0.  Allocate? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (957, counted=956).
+Fix? yes
+
+Free blocks count wrong (957, counted=956).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/256 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 1
diff --git a/tests/f_emptydir/expect.2 b/tests/f_emptydir/expect.2
new file mode 100644
index 0000000..75c0515
--- /dev/null
+++ b/tests/f_emptydir/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/256 files (16.7% non-contiguous), 1092/2048 blocks
+Exit status is 0
diff --git a/tests/f_emptydir/image.gz b/tests/f_emptydir/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..1b6f8f8350312013782acd2d2136db9f77c896dd
GIT binary patch
literal 2710
zcmb2|=3q#<KR=j>`R(2P*;fK&7(PtDv+`@y*0o$s-fO#+L;_h{*-MK89Q_M7b7*zh
zYyFeBqqSrAuCMk51x12Ku7<u)Vht2zUHORDZ=U{i>*{Uop|AS0KmR=NeUi76+{vfX
zaYZMq6&YHm9(lp}utvs4uQeds?^oUm$-+mgS9ZSoE#bN1`s&M`$vaQ}*jpPq^Pa?G
z!*53`X0;Vq^S#ftEO~kQ+TqvoHL|wbUS2smy*@qp+L@V`E}QN9{bjN6{5W~ZeY^iX
zS?B%UZl3p~zYF!xK2N<J_%nv<>9(hrpDkN{)-=D*P$1dr-SVvCpMG1vyLWSwk=_*9
zsz3G3hHc4jGM?1yZb^60-6OlTodFd*c)z;5^V0vDe?D4?L|ohE8}D&x;)LzRm&GrY
zq^RT{PLEx&Wcu;EJ9o<J-dwx7`Q{#hdDEvY4?h=UUHx%avARy#-p!x(hn@N?ufdUf
zvGEW46MKdKj6eBL)I0oR{v<!)e*;KpgNDt`-OvA>kz8;`>g=wy^Zt6pEnfbH?{9_r
zHzl1{fBa|twEZ*L_3|}Kg<Chx>@1Aq>~5IVy5IhBOG30-dY5<YS)0#|OTGU&C-RzU
z|BX!jTewn8|5th*+qFZt15H&DPTu=(Az;6)-N4c`FxT~U+3~hx8<u~J{5j{(2XoJB
zVwZN=2mEVi{;7N2eB+(4EvNivKUJ4Kb$*%bpQHbC<9znoyqdmj_UrGr{x{dJ*U$LR
z-IbU3_xt^ftM%&7uhgIZe69ZaubUAWtRMW!{)X$FxBWNSV9SA0`TtixIoH1ksjGW=
zbJstezXgBNcN$)iN!$Lx{J2Dip{(|${gV&e`rpcQ|Np7^|1;~irN>?ET=`vE-=;d_
zJtHIv9Lhibk#`OG^8A0-y5INzM@KMc-?VPJ_n#RxhR}FFY?oem(PX95z0u}a*M#p?
zdyU*w-SSWT-W?~JTzcZS^n3ow`p0N`M!BOQFd71*Aut*OqaiRF0s|fb8>ZAS-!GLj
JV_;BV0054XfYJZ}

literal 0
HcmV?d00001

diff --git a/tests/f_emptydir/name b/tests/f_emptydir/name
new file mode 100644
index 0000000..d5bc660
--- /dev/null
+++ b/tests/f_emptydir/name
@@ -0,0 +1,2 @@
+always iterate dir block 0 or e2fsck goes into infinite loop
+

