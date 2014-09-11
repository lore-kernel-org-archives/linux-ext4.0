From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 29/25] e2fsck: expand root dir if linking l+f fails
Date: Thu, 11 Sep 2014 12:48:04 -0700
Message-ID: <20140911194804.GU10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21453 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaIKTsK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 15:48:10 -0400
Content-Disposition: inline
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there isn't space in the root directory to add the lost+found
entry, try expanding the root directory before failing the fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c                         |    8 ++++++++
 tests/f_expandroot_create_lnf/expect.1 |   12 ++++++++++++
 tests/f_expandroot_create_lnf/expect.2 |    7 +++++++
 tests/f_expandroot_create_lnf/image.gz |  Bin
 tests/f_expandroot_create_lnf/name     |    1 +
 5 files changed, 28 insertions(+)
 create mode 100644 tests/f_expandroot_create_lnf/expect.1
 create mode 100644 tests/f_expandroot_create_lnf/expect.2
 create mode 100644 tests/f_expandroot_create_lnf/image.gz
 create mode 100644 tests/f_expandroot_create_lnf/name

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 9860cdf..f03c7ae 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -530,7 +530,15 @@ skip_new_block:
 	 * Finally, create the directory link
 	 */
 	pctx.errcode = ext2fs_link(fs, EXT2_ROOT_INO, name, ino, EXT2_FT_DIR);
+	if (pctx.errcode == EXT2_ET_DIR_NO_SPACE) {
+		pctx.errcode = ext2fs_expand_dir(fs, EXT2_ROOT_INO);
+		if (pctx.errcode)
+			goto link_error;
+		pctx.errcode = ext2fs_link(fs, EXT2_ROOT_INO, name, ino,
+					   EXT2_FT_DIR);
+	}
 	if (pctx.errcode) {
+link_error:
 		pctx.str = "ext2fs_link";
 		fix_problem(ctx, PR_3_CREATE_LPF_ERROR, &pctx);
 		return 0;
diff --git a/tests/f_expandroot_create_lnf/expect.1 b/tests/f_expandroot_create_lnf/expect.1
new file mode 100644
index 0000000..9593dbf
--- /dev/null
+++ b/tests/f_expandroot_create_lnf/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+/lost+found not found.  Create? yes
+
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 16/64 files (0.0% non-contiguous), 33/1024 blocks
+Exit status is 1
diff --git a/tests/f_expandroot_create_lnf/expect.2 b/tests/f_expandroot_create_lnf/expect.2
new file mode 100644
index 0000000..5eec1f0
--- /dev/null
+++ b/tests/f_expandroot_create_lnf/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 16/64 files (6.3% non-contiguous), 33/1024 blocks
+Exit status is 0
diff --git a/tests/f_expandroot_create_lnf/image.gz b/tests/f_expandroot_create_lnf/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..ccdbfa7a03aafbc206638d704d8bb22b21a293ed
GIT binary patch
literal 1622
zcmb2|=3r2MEf~VY{Pynoe4juOh6lfwHLnVq9ARRT*uBKWY?_CPl9<ruWak#%tpT3e
zg0JK^2-piLiG_tJDaA%8OzfE28qwLSWOB*%=%pRy_x3Ev4Jo;_^2~SBbido*Z{04o
ze*V?ZI6scVVfU?xd8ZU}x?h&Mb1)mG?|-*Jv46|`o#&@!RW1rT>$J8k!D#h+^N%Zo
zbjx)2<+(m?ersr}+iD>6`55nY_iuOa{(X4w*Szjv{rJ4u|B7=gEiFv`XHENC`1-}|
z^^dpnzr9uc_DA=|f9BzRDH~V43)=Vgy49?u`ukEh*Vy@$TfA6zT<L;na&C|B*MIUH
zOMmS(HW$dVHF0KufDJ#cW<8(Y_I~Rc*TeBE7<DJl`*%%tQ&9bxpTCy|)z|-%*=M?N
zb;+X-FBhIY?l)J`X4baW3p1~7diYH&%<Ng>lD(~=y_FWX?>YI;X?K6<SoXtyOH$PT
z`nM;3%V!9u1~dGUzwp1|ANv>k1^*fU^1rBe_|FUyVqiFs6k>h<gu`vmz4tHv5I-<U
z!rQq{bnZEc)3S1mP^Uqt1*&Rxp{rcC1mBG>Yx{Nbe7;@ys`XM6^Ixur=eL~8Irm)e
zyIH5|s%LJ|d2-!j{`!3qhue3}TQ0$EUUfV7U*ol%22%OkrkytK{~sA)d;b02cl!PH
zm;dwqTzlY9#hh#Q(dp6ur#j^){}oP){9j_eNb>dkuy6n8UbKntdc9AnZrz7ZzcyF>
z{r}Hs=i};k@_&N=UOkx}-tF;t`JM}3<NF?qU3~NF{`tWFXY=15>w=1Qf<^7m1pfag
zdw-tD#AE)I3t!ipKK|(c`PF|5_rFIU&lk!3GeveLsy|UYJ<1skfzc2cG9i$#O#ZIS
K!%zkW0R{l3<x~Iw

literal 0
HcmV?d00001

diff --git a/tests/f_expandroot_create_lnf/name b/tests/f_expandroot_create_lnf/name
new file mode 100644
index 0000000..f22542b
--- /dev/null
+++ b/tests/f_expandroot_create_lnf/name
@@ -0,0 +1 @@
+no space in root to create lost+found entry
