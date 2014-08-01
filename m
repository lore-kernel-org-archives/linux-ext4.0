From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/19] tests: add regression tests for group descriptors
 with bad checksums
Date: Fri, 01 Aug 2014 11:13:42 -0700
Message-ID: <20140801181342.12496.94782.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36932 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHASNr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:47 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add tests to examine how e2fsck deals with (a) the block bitmap being
corrupt; (b) the inode bitmap being corrupt; (c) the bitmap checksums
being incorrect (but the bitmaps are fine); and (d) the group
descriptor checksum itself is incorrect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_bad_bbitmap/expect.1   |   15 +++++++++++++++
 tests/f_bad_bbitmap/expect.2   |    7 +++++++
 tests/f_bad_bbitmap/image.gz   |  Bin
 tests/f_bad_bbitmap/name       |    1 +
 tests/f_bad_bmap_csum/expect.1 |   16 ++++++++++++++++
 tests/f_bad_bmap_csum/expect.2 |    7 +++++++
 tests/f_bad_bmap_csum/image.gz |  Bin
 tests/f_bad_bmap_csum/name     |    1 +
 tests/f_bad_gdt_csum/expect.1  |   10 ++++++++++
 tests/f_bad_gdt_csum/expect.2  |    7 +++++++
 tests/f_bad_gdt_csum/image.gz  |  Bin
 tests/f_bad_gdt_csum/name      |    1 +
 tests/f_bad_ibitmap/expect.1   |   15 +++++++++++++++
 tests/f_bad_ibitmap/expect.2   |    7 +++++++
 tests/f_bad_ibitmap/image.gz   |  Bin
 tests/f_bad_ibitmap/name       |    1 +
 16 files changed, 88 insertions(+)
 create mode 100644 tests/f_bad_bbitmap/expect.1
 create mode 100644 tests/f_bad_bbitmap/expect.2
 create mode 100644 tests/f_bad_bbitmap/image.gz
 create mode 100644 tests/f_bad_bbitmap/name
 create mode 100644 tests/f_bad_bmap_csum/expect.1
 create mode 100644 tests/f_bad_bmap_csum/expect.2
 create mode 100644 tests/f_bad_bmap_csum/image.gz
 create mode 100644 tests/f_bad_bmap_csum/name
 create mode 100644 tests/f_bad_gdt_csum/expect.1
 create mode 100644 tests/f_bad_gdt_csum/expect.2
 create mode 100644 tests/f_bad_gdt_csum/image.gz
 create mode 100644 tests/f_bad_gdt_csum/name
 create mode 100644 tests/f_bad_ibitmap/expect.1
 create mode 100644 tests/f_bad_ibitmap/expect.2
 create mode 100644 tests/f_bad_ibitmap/image.gz
 create mode 100644 tests/f_bad_ibitmap/name

diff --git a/tests/f_bad_bbitmap/expect.1 b/tests/f_bad_bbitmap/expect.1
new file mode 100644
index 0000000..71ad1bb
--- /dev/null
+++ b/tests/f_bad_bbitmap/expect.1
@@ -0,0 +1,15 @@
+One or more block group descriptor checksums are invalid.  Fix? yes
+
+Group descriptor 0 checksum is 0x49ff, should be 0x4972.  FIXED.
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(8--10) -(12--17) -(19--31)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_bad_bbitmap/expect.2 b/tests/f_bad_bbitmap/expect.2
new file mode 100644
index 0000000..411e656
--- /dev/null
+++ b/tests/f_bad_bbitmap/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bad_bbitmap/image.gz b/tests/f_bad_bbitmap/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c488ecd365b99c51a304597c0944444e0552c57d
GIT binary patch
literal 2546
zcmb2|=3tPuydKQN{Pvb@MzEs{!-wijhs@@wyEMdfSk)E#woVp}J#uhiFnj4n-m6LN
zCJUln-|8s!@wvWG>gZ_Vi<)y}mqv!`QAfeuKh{1_|M=8-q5x}dX3o9$;_vjz_e|gO
z|McF+@1C|Ys9dek^lsgtrWfa?D6;D9$}FvXgSfkTW|xg`%R6nn@n4JU;`u7q5Z&9W
zrur5Z+WwpH_oYCT-Tj%fX5aW#_UUI==y|?%wsvMS<Zm0B*ci>QpAx?&qTj}L>h3+2
zw|B0re*JxJ<%dKCu3E*(zf9M)UX|Rx$m;FO9fiBsxi{P9+%3Hq$<Xjb)3@IG(UsVF
z|HU6w?YeVs_TInC1iJRmU3Sl=x@!4mb_NCpZ)d}ATT|<PGXvTGw_p1If2P3FO$$Hi
zIH)ZNx|#D-@}B$KwJRrH{Bxsi;l)FZd*4k3syh%gne*XCm+-vu=(E4-*X`Z(4`kA;
z<iGd#zB@AY((mtY&w&I?UjO<Z_I|SE>v|w(156D+kV6dcjxCJzl?AHIuzJ@(j0PNP
zKA5LfrTwm7a`e}^KH1*>-$$oeL`UlXo3>$3OxUMu<$)gmH^qnCOR8)0Z@VC=mY!YT
zzU0f!#;YgyJ=2TvF8g!8Pu2QguW_$^+sDI&W_QEW|8%cXzP~?v^-6csufNT`9>>26
z4m!SH-+l7k|N3#hWq)>F2daH}>Cf`@_x`Ah?)qo&-!uGjP0g99>;CVaKB?+2D4<8d
iXb6mkz-S1JhQMeDjD`R$LSVy(eath088aCe6c_+dh#I*7

literal 0
HcmV?d00001

diff --git a/tests/f_bad_bbitmap/name b/tests/f_bad_bbitmap/name
new file mode 100644
index 0000000..923ddcb
--- /dev/null
+++ b/tests/f_bad_bbitmap/name
@@ -0,0 +1 @@
+corrupt block bitmap (metadata_csum)
diff --git a/tests/f_bad_bmap_csum/expect.1 b/tests/f_bad_bmap_csum/expect.1
new file mode 100644
index 0000000..ca8f77f
--- /dev/null
+++ b/tests/f_bad_bmap_csum/expect.1
@@ -0,0 +1,16 @@
+One or more block group descriptor checksums are invalid.  Fix? yes
+
+Group descriptor 0 checksum is 0x4972, should be 0x7074.  FIXED.
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Inode bitmap differences: Group 0 inode bitmap does not match checksum.
+FIXED.
+Block bitmap differences: Group 0 block bitmap does not match checksum.
+FIXED.
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_bad_bmap_csum/expect.2 b/tests/f_bad_bmap_csum/expect.2
new file mode 100644
index 0000000..411e656
--- /dev/null
+++ b/tests/f_bad_bmap_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bad_bmap_csum/image.gz b/tests/f_bad_bmap_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..70a0d1812b9c030959651bd068f1331e36330578
GIT binary patch
literal 2546
zcmb2|=3pqYxE{>J{Pvc0hKQpC!-Jb=8x<{WI(w522y75al3d%9p)4l0GH6BbNkLvV
zAEsNbSFR`}WeT>KG<9fXEIjDdGj)NWD7UN6V`ljWlZ)RkY<VnVqL`ky|NV@avlGAP
z{oi{tF)iPj;ZoL~8Alb@_;y_n<Vc?SZO0@p>7MXy-e*eAe`^cS__D9l>C5UkvCvc3
zyi$vU?s(ZfNl<H9rvH7}Gqr8|XV>g3`r57h+OPLpf6qH<37J>&mR6fWHp<o4nbqgM
z?&}WbH<PjW{~|eFq{_)`p8WMkS^jZ>z2AH;?FhcU_?+DKH#?u`FgW}YS-wBl^Oero
z|Hmg)ExQuu@#N6M`+mXiV=T7czRAqM(C~EOg*lw}XNhgFXJBCXa9{i1|M|RucSKK}
zXG(FFDKDKm|6%Q<?9TQ!cQ<oBo_^U|@8dXu3U$nH3e58>dGdW**xLWki=KW3>AoQG
z`v1AF%h!wFuRmca4-#1M`v30ed1oX4gKUDSsRzms10vpWX|H+(ROxWIke!7X9oW@0
z>^Hn@d;7Ps?$z>bZ&%gdS-(y7=BlWV=B>|yBF{zNb5}IZ-@jtZ(L+4*I2YRboD2KU
zm-(`|Hv3ZT+1PzE-~HG>->3Y~?6g<)Jdcl0%GtI2*bnhgw|({3qeA;vz2eUoKfeFZ
z^DTY#@%~G8|Bv4}@!gNl`LFAFE+75r@4xn^zl_yCga0Q(E;-el5?}xSclhP1zre5<
k1*0J_8UmvsFd71*Aut*OGzozXKk671F0Px-z@WeY0F<&6$N&HU

literal 0
HcmV?d00001

diff --git a/tests/f_bad_bmap_csum/name b/tests/f_bad_bmap_csum/name
new file mode 100644
index 0000000..df19fe3
--- /dev/null
+++ b/tests/f_bad_bmap_csum/name
@@ -0,0 +1 @@
+bad block/inode bitmap csum (metadata_csum)
diff --git a/tests/f_bad_gdt_csum/expect.1 b/tests/f_bad_gdt_csum/expect.1
new file mode 100644
index 0000000..e14c897
--- /dev/null
+++ b/tests/f_bad_gdt_csum/expect.1
@@ -0,0 +1,10 @@
+One or more block group descriptor checksums are invalid.  Fix? yes
+
+Group descriptor 0 checksum is 0xffff, should be 0x4972.  FIXED.
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bad_gdt_csum/expect.2 b/tests/f_bad_gdt_csum/expect.2
new file mode 100644
index 0000000..411e656
--- /dev/null
+++ b/tests/f_bad_gdt_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bad_gdt_csum/image.gz b/tests/f_bad_gdt_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c3fdafe6627561f7de16ea09a6f02d52f6265b00
GIT binary patch
literal 2548
zcmb2|=3uC|xE{>J{Pvb@MzEs{!-wk31DC|KO9OQxxcr=CvemVBbu>FK=X;eTz3M1m
zro;BGTahj@vRxNk1q4}Tw^($R243juYE~-y7=6(H(dqUeCy^~nH&*VC-?977$GA`b
z^uPD*o-WQbA>{E<9nnL#c2tPAPFTNXxz@@p2P;x{-|#t~Q_s=r^#8Sn%l=oXflG7N
zhL{~c+WW(qZ;5lpucGp-yrkQ^Pl{`Y+uLt>cjQJwUe5aqA5J8^E67`!Wc%w)$+uI}
z-acRcF8@aTw};0YHNLcNyYgp;Sa|xMuB<J~A0Lz5C0F`wMe29fbVi0r%Ps!C?FcT<
z{5QY<^~<2@{AcHG*Vvr@f46S?xw$u=zF}lwIPfVT!>>Kxm-~i10|Ud4_oDy*=W_>Y
z37<O8w52sfYqF;O;om#<s+t<jlD=(WGRuC)`Mp9wg%NqToGOeiPQ80MYU{uG+4}4M
z1I=nU7V*D)y?y1@AOD<pe+CLL^zQn%|L*USbH6}_uYsvy26Bi12a3WY0z=t>Dy90Y
z6^PJ)OUa+!ne%S`o1eLI-{$1>zmMy7nw|^0+O=QPWcsP1d!OvMURM5gU8*aV_9KL2
zZer24U*#TN^Q9vuzsY|0=xfUH|9>ksJ-%-e{6AU3UMT%?t?9A-D~vw<-F<CURY+)k
z!DfqpsrKrne|}f#-2D6h($<vY^J{@>XXu@)|CM#NK4{@<{?GGERCSLm&-wUkf4Sw#
o>-M<ZIVwIH0;3@?8UmvsFd71*AwX#ebiZdekeYCofkA-*0GSvb(f|Me

literal 0
HcmV?d00001

diff --git a/tests/f_bad_gdt_csum/name b/tests/f_bad_gdt_csum/name
new file mode 100644
index 0000000..fe2c601
--- /dev/null
+++ b/tests/f_bad_gdt_csum/name
@@ -0,0 +1 @@
+bad group descriptor csum (metadata_csum)
diff --git a/tests/f_bad_ibitmap/expect.1 b/tests/f_bad_ibitmap/expect.1
new file mode 100644
index 0000000..ea17523
--- /dev/null
+++ b/tests/f_bad_ibitmap/expect.1
@@ -0,0 +1,15 @@
+One or more block group descriptor checksums are invalid.  Fix? yes
+
+Group descriptor 0 checksum is 0xffff, should be 0x4972.  FIXED.
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Inode bitmap differences:  -(12--32)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_bad_ibitmap/expect.2 b/tests/f_bad_ibitmap/expect.2
new file mode 100644
index 0000000..411e656
--- /dev/null
+++ b/tests/f_bad_ibitmap/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_bad_ibitmap/image.gz b/tests/f_bad_ibitmap/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..3a5239802dc3927db009d83b951f487033e528d6
GIT binary patch
literal 2548
zcmb2|=3rp7ydKQN{Pvb@MzEs{!-wk3wo7c<rGYvTTz*b6+3MQ6I+~rA^Sw%vUUif&
z(_wqptw<Lc*{%z&0)nivTP!+D121%SH7k{Uj6Uf9=ybc1BG;`;H}>4uzZ3heLcj9=
z^y=exPjfSRtm+J!#+B$Bv!};NBjk4Q)sTA$i+084Y%9-GXh|x35Gt~0{@1P*QQN|`
zXFqyW^+)mdWyLKu`;2YvcYb|)<+JGOd9pFpH8mRc`_d~?N;K*<_J?egtE|#0ul&5N
z`11E_@2x*SIGiBz%USJfc1-tb?K;=eTbBzTm&Nw8Ro~e5de3GChLgdw{*@hDx!mTz
z{*kXGJNN2W|Mpd!_xyj}{@LmN?@PWhFfb%kYHV9}`1&-~H~c`}pYLA(|ED`mIn{P*
zGsDaYUa6a>rdP<9ZdvMf{L^FUw&Psv-*$yF0TrJ1Rckpu`R>lUZ%tqS|Jirympo7~
zqwj0|`CY={UhnUhTYv;Eta<%Ey4L^M+W(9U3<qFp?13`G0G;xq5xKHJl^J^P8i>(=
zL(K>CwCd+<bxW51I(JUCxBvIiX%^9u`v0a~h|<%pyuDjvN&QWIt^AD!%IeN9xPptf
z?spFQb?3pWl=x!tb*k3?@{doF{eSG{G5Nzs9$L(Px!(An>(z<x?{B?+W$~<Ef2Egx
z)c>xz^6~xYi%-7$FTP&Q`rn<`K(#)Z|1QVp|C`Kpw|>U|C95+P?VfpE|9{upbMHT3
mSd4<v5Eu=C(GVC7fzc2c4FQ^jKt#=b#-EO-moqRZFaQ7#Mj2iJ

literal 0
HcmV?d00001

diff --git a/tests/f_bad_ibitmap/name b/tests/f_bad_ibitmap/name
new file mode 100644
index 0000000..76ec12d
--- /dev/null
+++ b/tests/f_bad_ibitmap/name
@@ -0,0 +1 @@
+corrupt inode bitmap (metadata_csum)

