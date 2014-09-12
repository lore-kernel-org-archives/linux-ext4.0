From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] e2fsck: handle preallocation for large PAGE_SIZE
Date: Fri, 12 Sep 2014 14:50:05 -0600
Message-ID: <1410555005-2372-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9821 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILU7l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2014 16:59:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix handling of block preallocation support in cases where the kernel
PAGE_SIZE is larger than the filesystem blocksize (e.g. Lustre+PPC).

There was an existing test to try and verify this behaviour using 1KB
blocksize, but it had a off-by-one error using pb.last_init_lblock
(which is 3 for a 4KB file) and was over-zealous in "fixing" the size
of inodes with 4KB of data blocks allocated.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 e2fsck/pass1.c             |   10 +++++++---
 tests/f_eofblocks/expect.1 |    6 ++----
 tests/f_eofblocks/expect.2 |    2 +-
 tests/f_eofblocks/image.gz |  Bin 1364 -> 1372 bytes
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 50a8b99..898b7d0 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2323,10 +2323,14 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 
 		size = EXT2_I_SIZE(inode);
 		if ((pb.last_init_lblock >= 0) &&
-		    /* allow allocated blocks to end of PAGE_SIZE */
+		    /* if size is smaller than expected by the block count,
+		     * allow allocated blocks to end of PAGE_SIZE.
+		     * last_init_lblock is the last in-use block, so it is
+		     * the minimum expected file size. */
 		    (size < (__u64)pb.last_init_lblock * fs->blocksize) &&
-		    (pb.last_init_lblock / blkpg * blkpg != pb.last_init_lblock ||
-		     size < (__u64)(pb.last_init_lblock & ~(blkpg-1)) *
+		    ((pb.last_init_lblock + 1) / blkpg * blkpg !=
+		     (pb.last_init_lblock + 1) ||
+		     size < (__u64)(pb.last_init_lblock & ~(blkpg - 1)) *
 		     fs->blocksize))
 			bad_size = 3;
 		else if (!(extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
diff --git a/tests/f_eofblocks/expect.1 b/tests/f_eofblocks/expect.1
index 2e9133e..3422248 100644
--- a/tests/f_eofblocks/expect.1
+++ b/tests/f_eofblocks/expect.1
@@ -1,7 +1,5 @@
 Pass 1: Checking inodes, blocks, and sizes
-Inode 30, i_size is 2048, should be 4096.  Fix? yes
-
-Inode 31, i_size is 2048, should be 4096.  Fix? yes
+Inode 31, i_size is 2048, should be 6144.  Fix? yes
 
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -9,5 +7,5 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 31/56 files (29.0% non-contiguous), 83/400 blocks
+test_filesys: 31/56 files (29.0% non-contiguous), 85/400 blocks
 Exit status is 1
diff --git a/tests/f_eofblocks/expect.2 b/tests/f_eofblocks/expect.2
index 2a2bca5..0cce314 100644
--- a/tests/f_eofblocks/expect.2
+++ b/tests/f_eofblocks/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 31/56 files (29.0% non-contiguous), 83/400 blocks
+test_filesys: 31/56 files (29.0% non-contiguous), 85/400 blocks
 Exit status is 0
diff --git a/tests/f_eofblocks/image.gz b/tests/f_eofblocks/image.gz
index 2586a6a7670ad609ba7e66911a8f7a8f4df96321..e1177b3a7d6f33ce135fe91c7b6d11bbb1ee09a3 100644
GIT binary patch
literal 1372
zcmeH^Z!p^j7{_gHWq)pV>s%4!*j5`dL&d)l)1f=FR9$4$E~jY_5rXTqM1E?z%@ET~
zC?TU&hAs^g6(yT0>Cr@5;w~-emPlNYREYQ`zdy5=z1!Qp+xNwD_x*nEp6BlQV(Xlp
zkH0oee9@84%+94bY^|hxN20koJu5YR=A+da`a+}fKmJVwRX@nN%&LE@I!B3j+<Du6
z^6S78&drIw@8v7SC;FSS>-N&$c^OyzN_PS#JfUvk)De&33i*U#!OI}OQnoO~*SK^>
zx|k-kz-p+W($M*W>8$&QY0UcaaUQL**psV`^JHuhZ%vTEoz?LWyrjpvn-{}4<{eFD
z#F`qDsaMz1<`nH-=dSIKCOysAEAiBz1<$%7bFtvwLn7xqGD|L>yk*<?Vz>zXgCR({
zVOCNE`}*w`d_A9Iu~Lkj{f?0$ox+IoX7JHm@8z^!VPAB9Z*n6hj)T)PP`TcQl|8-R
z#JjkueM$a?!(+C`pNg4FiP|h2e7LGTe&T{l)_{;p9S|;)g@r43th5-5;q}`r)>5Zq
zkWsTFA#-OL(W)(ZVSwF|f$v=xWVO&r=VE6JuCUxqK-mkP{CU0X?*7yeMI&*!XI}}P
z?AxTWi<PF@?RRNdEu4TZN>nCXTV;I^&NdM|Ie0*Ct_!%^YX>yod*q56#T^FAcQ@dI
zC;D)EzXcEtj35`?ca!6Ow>b?0|2CcgU32d{RJr#k^E~B{kki_<S>^DYSXw$Ci@|M3
z=V4~4ij9f{A2c)|>@m`fBuN|47%`VaJH9P4#4{g1`e~`VaGR<1@QU=ns=g{C-bNV9
zkof$o{8h}V0Yrwy4-vA$RtNiS+(dU1SIWK2gpbr})F_F-M|n15XDPsNTg8`(OST%g
zD7ARd>)udBKuEb%T~^Q!HOW>y!a{t2N7q1@30g@y#iufj_t<#1m`Fu1YIAtHPLU$h
zV8#@QTOBiyliF+&$^_vgPS%-keXXp;F8Vw`KaHGBK%g3k+GNjM6dfcPrxDgtZ0iqz
ze~Gj{Dy#u?5w8UaWt4;DXo-{?71{t27I@NbUulpJdP>Jzx`1e{0%$~eeL5y5H6B@$
z;RbdfKRuzfRT_~E!>(hr9yvfegIunG5_P=hD3nwS!f9)YxuMa&ET-{PP&6+f6~hLw
zy^b35tF*%3?DVF&G0EtZI_sw^YCnc@#n4?>F!`{V_(@?#hk<}VWl4J8^o}&p2R(bR
zF$87b4+>NP<lQ3GQ3aOoPhcPU=O}8)R6{L(IsiLHJJ*R$Lt(WBAYlqA#T)IPXVFOy
zpsU_EIY1w>io9%jv)6wy@7U!(k~2wqYx+C^*cuHhM(((R&sG1w`ENb|MI(n&#=kK+
I#2s?@8x*BH;s5{u

delta 1029
zcmV+g1p52j3e*aJABzYGwEKil0t0DnVP|Ck?cGg?Rb?0l@N@4>A*1;@>Wq$B5N#~K
zpfpXwDN;z7McWL_kL*JYvLGWIX(WQ87VV-)s+C|wdn<~B7C{BkqK%uPMP#W9jkrDc
zo^$AqbLY%^(ZZbH51u&>?>*yx-s5@SnKR%u%Yf->L)068wJht8<K{RH#<A9Z!p(U#
z&wJ<6*vLmw^{ml&=(k$yygx3Cjg+UBpEomVwD_}!>sj`E9N+z9=>FMf9{lFx55Ir<
zhZp-kyZq}|z5l?WE1ylR^3`7+`TF7K)(?O2((gat{=l1SUTvN|t9Y$(_MdrNO`X1?
z-l$z}J+1+N&3m!A_HS*i|G})@8p#c2+uw490O0!52!A%tH5xB;@d?0nq2781uGLq?
zG4Jd3Rjcx6`2MV~{?x%|4z1jK@Yw^q^JnFFy|#1hp6sTwUzcUGi~iBISvIHaV|;GW
z?~3txWgp}7i+*>EFDUzU`Ey9K-xK2t%Ra^z75(0S7++lWF+NcAkFCvrZ_(;wd`Z#o
zi}9spALBzs|9FfqEBhE<Ui44I_=@Py)}vqNdjr?MnU}5q^F8_c2d2?40RihDu>Jw-
zAF%!b>mRWG0qY;I{sHSBu>OJng&vmx0H&2jqj4njuliwHvI7DD000000000000000
zz_q7;advE^tp76i*DYD={l|X1FgEhj#k}%YdRqS<ahA=<Hpa)kbG31AQ&x+*!CxC!
zX!K}&Skv1(@&2z}@!R6fcX_XQpEmcOHJ$dqdNxq(KUs(UXI9jWS0VrXqxt@K+xfAP
zO;OF``1@~0Yp?4&SD&!|Ei8_;(JZ^OB4gHnm-~-Rl|LN0Tcd_2<Zqiaf1oY@u8REG
z3HduBcX!l|F6O_!Eq_Br{+xvTeUbZQ)V?m}KiHOkcSZi(sq*6%I~=)3q7HX4|0Qkt
z8!PhXCFCEA+?S({bus^?ZTXw3_Q8bwQ<3|5)Tu7!Kh&1LtRjCwLjLK<{VM8o7xTY=
zr!9YZMSg!m{)NabtMmNF??26-jW#FlF$)v&FGg-zo##I>|K7y>MG5QgugEPcb^a?7
z^A{)NHzK#J)cLPW%paI4e{Pn&9zXxS9o0OR`7<i+|7QM{;#iOS?~aQ6!G!$dk^5fM
z@d^3cCe6R4Eq_r({*r|J6Omh1=lPFozy7_Ed0*o7Uz(7AGIGmGnSXQ5FDTZ3PxP<V
zCeI(5DnEQ1xn-r!|CL(W{Ff!<e;2uBb)Nsk{MCuqe|f_Gb0(hqPF%_>Y5q~$i|b#S
z?0sxEez0@%RQb*4&Xbq&N}7Mv*2MX5s>lbk@dIB0k^}_|;NS5#ODu1?06+!+NxVE=

-- 
1.7.3.4

