From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/21] tests: add regression tests for inlinedata fixes
Date: Mon, 04 Aug 2014 18:07:16 -0700
Message-ID: <20140805010716.2611.99727.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44579 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaHEBHU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:07:20 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a regression test to ensure that previous patches' fixes to e2fsck
do not revert.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_inlinedata_repair/expect.1 |   78 ++++++++++++++++++++++++++++++++++++
 tests/f_inlinedata_repair/expect.2 |   33 +++++++++++++++
 tests/f_inlinedata_repair/image.gz |  Bin
 tests/f_inlinedata_repair/name     |    1 
 4 files changed, 112 insertions(+)
 create mode 100644 tests/f_inlinedata_repair/expect.1
 create mode 100644 tests/f_inlinedata_repair/expect.2
 create mode 100644 tests/f_inlinedata_repair/image.gz
 create mode 100644 tests/f_inlinedata_repair/name


diff --git a/tests/f_inlinedata_repair/expect.1 b/tests/f_inlinedata_repair/expect.1
new file mode 100644
index 0000000..a91ce76
--- /dev/null
+++ b/tests/f_inlinedata_repair/expect.1
@@ -0,0 +1,78 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Truncate? yes
+
+Inode 16, i_size is 56, should be 60.  Fix? yes
+
+Inode 24, i_size is 59, should be 60.  Fix? yes
+
+Inode 28 is a unknown file type with mode 00 but it looks like it is really a directory.
+Fix? yes
+
+Inode 36 is a unknown file type with mode 00 but it looks like it is really a directory.
+Fix? yes
+
+Inode 36, i_size is 5, should be 60.  Fix? yes
+
+Pass 2: Checking directory structure
+Directory inode 20, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Directory inode 28, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Directory inode 32, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Directory inode 32, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Entry '..' in ??? (36) has invalid inode #: 1633774699.
+Clear? yes
+
+Directory inode 36, block #0, offset 4: directory corrupted
+Salvage? yes
+
+Symlink /1 (inode #12) is invalid.
+Clear? yes
+
+Symlink /3 (inode #14) is invalid.
+Clear? yes
+
+Inode 38 (/B) has invalid mode (00).
+Clear? yes
+
+Entry 'A' in / (2) has an incorrect filetype (was 1, should be 2).
+Fix? yes
+
+Pass 3: Checking directory connectivity
+'..' in /A (36) is ??? (1633774699), should be / (2).
+Fix? yes
+
+Error while adjusting inode count on inode 0
+Pass 4: Checking reference counts
+Unattached zero-length inode 22.  Clear? yes
+
+Unattached zero-length inode 23.  Clear? yes
+
+Unattached zero-length inode 29.  Clear? yes
+
+Unattached zero-length inode 30.  Clear? yes
+
+Unattached zero-length inode 31.  Clear? yes
+
+Unattached zero-length inode 33.  Clear? yes
+
+Unattached zero-length inode 34.  Clear? yes
+
+Unattached zero-length inode 35.  Clear? yes
+
+Inode 36 ref count is 1, should be 2.  Fix? yes
+
+Pass 5: Checking group summary information
+Directories count wrong for group #0 (7, counted=8).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 27/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_inlinedata_repair/expect.2 b/tests/f_inlinedata_repair/expect.2
new file mode 100644
index 0000000..941241d
--- /dev/null
+++ b/tests/f_inlinedata_repair/expect.2
@@ -0,0 +1,33 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 20, i_size is 60, should be 0.  Fix? yes
+
+Inode 28, i_size is 60, should be 0.  Fix? yes
+
+Inode 32, i_size is 60, should be 0.  Fix? yes
+
+Inode 36, i_size is 60, should be 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Directory inode 20 has an unallocated block #0.  Allocate? yes
+
+Directory inode 28 has an unallocated block #0.  Allocate? yes
+
+Directory inode 32 has an unallocated block #0.  Allocate? yes
+
+Directory inode 36 has an unallocated block #0.  Allocate? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Unattached zero-length inode 21.  Clear? yes
+
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (494, counted=490).
+Fix? yes
+
+Free blocks count wrong (494, counted=490).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 26/128 files (0.0% non-contiguous), 22/512 blocks
+Exit status is 1
diff --git a/tests/f_inlinedata_repair/image.gz b/tests/f_inlinedata_repair/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c33d81dc60f828c89c9b743e64e0b9cf4224da1f
GIT binary patch
literal 3201
zcmeH}TToMX5XOV3SS*O*jEG_=Sfruc3K|e0RjE{iqQyW6AO%r`D1m}NDR8{uSS&JA
z>J5PmD#aMWCEN|+R4qmWns#Cg;6Nymq(IU@0*Qy5oPXm>-<)y!oPF8-cD|jR`OQ8o
z{_+akvzp=PCD!Uu^2x&#C!5&-v0KO5vNL66=O&KsT;dt#>b%s^eUBqOqiFnch84cO
zoYt{?ooAIpqQfrg>J+~<u|DO_cigyHM-#g5hxcE-7@pYTx~H=6MNLSuXX*M8ns87f
zEz;FYMJn}>rut?`7cqUsmv=^f_9^=$Va;o1slzLU%vW)BG?~oex1_b?xW+^~IZvZ(
zhl$b0t3sBC3{+5_8rxB!cF4YW{UgQD^^N@RP5F2Zrd1PTRan;Z3XL5Iy*59u2eP<Z
zV<hO$vq#zXr@S-!Kp$TR`(B{bai|YCUkD0ru7hpei{Ri_HMNB}T=lYaLw-ynn`;6c
z$r+vbH10OlSel&`4)<FR<6eC*`a19;(*}pbdGO~Ap!1-ok9~cP)yS^a?t<*8jbp)e
z9o;NVJ@(ax#UuZy4|E+f)D#x0#JV}VR?$<zKng=7AU+8TfK<1*0zx_CN^xdb-=}wT
zQpxh%rrC2vy>5CsS^mg{yt{ilzWIu&it3_{wjK2~%=ap0?aW(WrjC3T2DZRm@g%c4
zNIXtkX3pcfcPcB>YtvqEhal054qyz*{?e_(q@{0jX;b>zzA*O3K@ZIyzbWL+5_A55
z_%hU~EEAvSVz%D%y>jLQCf;Ys@+cYdABt<*BQy!73;Y8vkn`>G`nU~;>*Hw?u`JQ0
z>zs&{bv+YG+t#Wl$%rn+C9M5qe2m(}FYm<8wxtbhm`efoS04c@kr~<F`#0qAv&y9K
zUz**Wwvj)X(m~qP*G8z{k0=8lxvRk4Vx}T{1OzXjzMBwOw@PhS=dMr6v(IZ9qz|zr
zgMrRY=WSN`7>(^lsLcj?o}o)5{yN!^jp!9D!|~z+C43$mrnkpMERGU%vf5a0M3h>(
z<FGeiD~qcsgUoBpCzEQ@YDDuw*DR#>c7ewdEzD!2#rQ+C66dH?Osh|-k+v9szY^N4
zU=}_=VGbI=zCrRPm2V+Hi)h!5F@1DGW{<ELnpDfGlX$K%@h1qmp$oY;u2%4*j1_J2
zf}I<iWi8piPd0HnP0%oQEQYDU+`LH(awMu3P_-3r&J*{U-k_68h`cQ$bo-*z7(suI
z_Zq+(!}(x;I3{r30pyiIP!;Hs1OeYj<4OdD@1<Z#3CA$fA#ZTn+Sry+IK%!NQY{1m
zX5&_<@m)EOCP~K;o<}wo2pF7fEa{s$3`*}u;YJ|}-KSxFr){_o(!|m@Y-lDOBPG%?
z>br6Zk&TWc(x?e^FGmBe3#w{Gz>A;&C_xA9?m$EEZ#~$RTB!h)QU99&k>{0A-WnyT
z(geKPIu2EVSjr$Mr6@p-L<?~h-}Z3PR;d_;N?sx}as*~Q)EOct&}Y9;1ry(aA5W{+
z3LvKJr9`q_D9~`O!F<>-d)vCXVc$Sh@ogpO=PeHr2m7&@1!%tNHS|M-fZh;_@j51z
zkK;l2HVUm|+OfwZo&(w*l0XF3!*U?Q_}YGPCMea7J)8c6dnz4a;boZ1@QKBsQ@{~i
kvVPxvTly9P76KLm76KLm76Sj9z-C~@tUY1=!Ci6x0)&jPy8r+H

literal 0
HcmV?d00001

diff --git a/tests/f_inlinedata_repair/name b/tests/f_inlinedata_repair/name
new file mode 100644
index 0000000..7e7e898
--- /dev/null
+++ b/tests/f_inlinedata_repair/name
@@ -0,0 +1 @@
+repair corrupt inline data files

