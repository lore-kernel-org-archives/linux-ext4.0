From: Tao Ma <tm@tao.ma>
Subject: [PATCH 2/2] e2fsck/tests: Add the regression test case for e2fsck.
Date: Thu, 17 May 2012 15:16:07 +0800
Message-ID: <1337238967-4704-3-git-send-email-tm@tao.ma>
References: <1337238967-4704-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60246 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761165Ab2EQHQT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2012 03:16:19 -0400
Received: from [182.92.247.2] (helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SUuwc-0005vf-Kr
	for linux-ext4@vger.kernel.org; Thu, 17 May 2012 01:16:19 -0600
In-Reply-To: <1337238967-4704-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In commit "e2fsck: Let end_blk to be the maximum value of u32."
we fix a bug where a normal fallocate will cause e2fsck complain.
So add it to the regression test suite.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 tests/f_zero_extent_length/expect.1 |    7 +++++++
 tests/f_zero_extent_length/expect.2 |    7 +++++++
 tests/f_zero_extent_length/image.gz |  Bin 0 -> 5102 bytes
 tests/f_zero_extent_length/name     |    1 +
 4 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 tests/f_zero_extent_length/expect.1
 create mode 100644 tests/f_zero_extent_length/expect.2
 create mode 100644 tests/f_zero_extent_length/image.gz
 create mode 100644 tests/f_zero_extent_length/name

diff --git a/tests/f_zero_extent_length/expect.1 b/tests/f_zero_extent_length/expect.1
new file mode 100644
index 0000000..762159c
--- /dev/null
+++ b/tests/f_zero_extent_length/expect.1
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/1024 files (16.7% non-contiguous), 1227/4096 blocks
+Exit status is 0
diff --git a/tests/f_zero_extent_length/expect.2 b/tests/f_zero_extent_length/expect.2
new file mode 100644
index 0000000..762159c
--- /dev/null
+++ b/tests/f_zero_extent_length/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/1024 files (16.7% non-contiguous), 1227/4096 blocks
+Exit status is 0
diff --git a/tests/f_zero_extent_length/image.gz b/tests/f_zero_extent_length/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..0b6915805bc7c3d67b9bf0f944f980b36012268e
GIT binary patch
literal 5102
zcmb2|=HM{n-0IK3oSB=Lp33m{u78e5s070Y^WBScwzp2RH+-<N(S>t{lY_{A6(w~8
zL)9)$^`=g#<SjBsT>RICD+?rfbW|xE5jfl^Fk47()~U$+s*edxoa}rp6SlP%t;{b=
zOY|0Bx$rI5=ijRG?`Pk<Idl8%@4o5V4(D(<WG*#ibNXRwW?khxV@=zHE%tU1E-~*;
z&fEC#d6G(E+OxCLp2a&w3wLeJcwJd&x=`@(Q;FT$iZ#>DN?U*Zbz%DYuYW#-zWv;o
zzyIfhcX>HKGoGB7R&H<m=?(MV8UHMcvvPl)kN>}Q*|pujU(VlG{qKRkzl_bqBYfXQ
z`%~91whPSNC#$>h_1Wohn%DLy9y=vr{;1mIR^e~v;%6$d(@t&sSa<6oV?@&Gq&58;
zbyL3DN3PuxdLX6rSJC!gtPH3i)#!8m7q9L2rxta*|MD^K|B9FE-rO^*Rb0u_`p3?^
zc43gD)T#FmH>+LImY4hY<HWP?eDy}3{OZ=vxxd=;Q(3sX?uLL(R{87ypUjH;@8G#Z
zTz1OzU+tfQ{s+Xpl0W7B*ST_Ky@vi*{-;a-E!=a(9wzDaSbuMU)}4FIOV*lje!rnz
z@<Z;uUwk324NKRr^I1EBT-NTkWtw)%r+)f&{*tq+BAQ<(=X4itC|?zoY5ivYs(q!a
zqkpp|d=x$Ye{J&rN=dobl6St`?!Mf8T{}T@%iRCr&UG3WJhT6A*qgCk^zExfu~WCd
z{CVS=`0n!u4i)_4e|oj<-~PqrMc01*2M5YGZiepMKUaU8za|j&rH6OBQvDL4Yi76q
zoL~60Gvykq;LW`O*L4nj+y7rFe}32PTvt1F&U};Gwr3}AuK8WAx78xPMD2C#Eslpd
zbL2EW6&uD!KM8;I@vi*C{NIKDuHN~$-(+3-*Xhr0&$s=z`Y8LPt=m4<yPM^I4Jw=B
z9;AHxf1dB<osaD~oB4OVlYhSZ?~dp1w*37Q?*IC`f9bU!=d+SGWNZ%p!D|?HY)2q(
z;urfb7ys^GxM$bjpU&?4{wI5$`SGv+(rW)JhyQIeoM`4`G5Os4Jw+Q%tUp$hJTd-t
z{yabP&#w*dM?Nu6-naV1@?V=b-?Ewi?$dqw7kysJxpgx(zJGG>*_W5y?9);oKfADW
zPi}0BUEP<8&9UJ=_ut#kj*+muR#=z(<%n(gggaOD@=xd6zZbk(_Se63-+5rDSEgN_
zf7@I?ZapYXHMBnYC4Xwgo9q9l%za(Yh?>mk%UiHHtH<P6vY}l6Mjba@H~*fho_i9t
zhSQEm2rjli=Fl_s?h76Ix@gq4(GVC7fdLMI4;NN~3(A*U1P{$LX^EORzxSuZ#QEJn
zZz=7+B!4JjVtnt<V@mtQKCgAHvwddW{U_~Ax#-W3Gv7simi%|xuO!Dd)ooVF+kKO(
zXJ1~fFBdVbceeBNPus$D%%Mf5`uE89trL@FpPRe+-zjE28T<Crwm;uK53sjKtsf16
n(GVC7fzc2c4S~@R7!85Z5Eu=CArb-&ANXYirY~S%a9{uc`yfdH

literal 0
HcmV?d00001

diff --git a/tests/f_zero_extent_length/name b/tests/f_zero_extent_length/name
new file mode 100644
index 0000000..9e0c6e0
--- /dev/null
+++ b/tests/f_zero_extent_length/name
@@ -0,0 +1 @@
+fallocated extents after i_size
-- 
1.7.1

