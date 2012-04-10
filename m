From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] tests: add test for symlink extent
Date: Tue, 10 Apr 2012 15:34:17 -0600
Message-ID: <1334093657-32559-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:43217 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab2DJVeU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Apr 2012 17:34:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Long symlinks with the EXT4_EXTENTS_FL set may have been created at
one time due to the EXTENTS_FL being inherited from the parent dir.
While the original cause of such symlinks has been fixed in the
upstream kernel commit 2dc6b0d48ca0599837df21b14bb8393d0804af57,
such symlinks may still exist in the wild.

Add a test image that includes an extent symlink for sanity checks.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 tests/f_extents_symlink/expect.1 |    7 +++++++
 tests/f_extents_symlink/expect.2 |    7 +++++++
 tests/f_extents_symlink/image.gz |  Bin 0 -> 617 bytes
 tests/f_extents_symlink/name     |    1 +
 4 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 tests/f_extents_symlink/expect.1
 create mode 100644 tests/f_extents_symlink/expect.2
 create mode 100644 tests/f_extents_symlink/image.gz
 create mode 100644 tests/f_extents_symlink/name

diff --git a/tests/f_extents_symlink/expect.1 b/tests/f_extents_symlink/expect.1
new file mode 100644
index 0000000..4c5476c
--- /dev/null
+++ b/tests/f_extents_symlink/expect.1
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 22/100 blocks
+Exit status is 0
diff --git a/tests/f_extents_symlink/expect.2 b/tests/f_extents_symlink/expect.2
new file mode 100644
index 0000000..4c5476c
--- /dev/null
+++ b/tests/f_extents_symlink/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/16 files (0.0% non-contiguous), 22/100 blocks
+Exit status is 0
diff --git a/tests/f_extents_symlink/image.gz b/tests/f_extents_symlink/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..797a9fa4f245e274cd49e67d207090ea3028923a
GIT binary patch
literal 617
zcmb2|=HLj|KkUoIoSB=Lp33m{#@=k<L>cxEr@OaoyZVdE@7CJpNmjc=GN<cp>u&BY
zIHH!@Y^tv2ba&O{M|zL0T|5}OaEg<-_<sg=aq;*C78)-WTv4CCg!k4$rK{6w?4C&L
zmHTsifAZ7z&Sw|F3v2sYra1An__RK8Hk!-ZHY;<>@34s3dyF=j&FpSle0si7=5AyE
zd%iBguQM-y`~J&W%vrCcXZtz%{~rnyzrJ2Nxj%m2PK%OXFBktWT>rj(zV9BdW7Fkq
z>i5=s{r6^X&hf2Z?8+RE2_*BM-kP;9^8Zhb)!qxTb8>j{<m&G;>^ikUuOaX1&VRYj
z<L&C#^sntP6H~C~%AUMe`K-yg^*ztbt}FGLmh`)umK}U__d}W8{QtFo(*ITI);N8C
zSGhX5_kaEFpZd~sUu9gEE;3lMe(Qcqfg+731t$`+<-cZ}*mx{%dEVWhzlt@xq=f6L
z-{qhGAN}?E>~sHX=NrGY3w^%t)fc|{#}8k1Z?CGVzFDG^zNz)><D6{)8GRp%1LMo=
zR$e`SPG$S*rO#%_cNEzgdrs>6d+g)ZM{BpRO)LI6@8=S$)$WP^U;JPCZ~v27U-?Tq
z_vkTv<zG?n@R#|Oe8B&PU+h=x7yM%c2{BL?{0pgF7u0=twZwV#t2cL)JwH~nw90m!
zYGLiVh<@#_JN6jF>P^pjSZp~@^V+NE+&r=6rwf<Pidz{nIViIH(7sQ?#zL3%7$z_>
F004Uf9en@*

literal 0
HcmV?d00001

diff --git a/tests/f_extents_symlink/name b/tests/f_extents_symlink/name
new file mode 100644
index 0000000..4aac4ac
--- /dev/null
+++ b/tests/f_extents_symlink/name
@@ -0,0 +1 @@
+long symlink with extents flag set
-- 
1.7.3.4

