From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/19] tests: add regression tests for EA blocks with bad
 checksums
Date: Fri, 01 Aug 2014 11:13:07 -0700
Message-ID: <20140801181307.12496.76118.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33518 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaHASNN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:13 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add regression tests for e2fsck dealing with (a) EA block with a bad
checksum; (b) EA block with a bad magic number; and (c) EA block with
damage that isn't otherwise noticeable.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_ea_bad_csum/expect.1 |   29 +++++++++++++++++++++++++++++
 tests/f_ea_bad_csum/expect.2 |    7 +++++++
 tests/f_ea_bad_csum/image.gz |  Bin
 tests/f_ea_bad_csum/name     |    1 +
 4 files changed, 37 insertions(+)
 create mode 100644 tests/f_ea_bad_csum/expect.1
 create mode 100644 tests/f_ea_bad_csum/expect.2
 create mode 100644 tests/f_ea_bad_csum/image.gz
 create mode 100644 tests/f_ea_bad_csum/name

diff --git a/tests/f_ea_bad_csum/expect.1 b/tests/f_ea_bad_csum/expect.1
new file mode 100644
index 0000000..4fc365f
--- /dev/null
+++ b/tests/f_ea_bad_csum/expect.1
@@ -0,0 +1,29 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has a bad extended attribute block 1074.  Clear? yes
+
+Inode 12, i_blocks is 2, should be 0.  Fix? yes
+
+Extended attribute in inode 13 has a hash (1631637196) which is invalid
+Clear? yes
+
+Inode 13, i_blocks is 2, should be 0.  Fix? yes
+
+Inode 14 extended attribute block 1076 passes checks, but checksum does not match block.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(1074--1075)
+Fix? yes
+
+Free blocks count wrong for group #0 (971, counted=973).
+Fix? yes
+
+Free blocks count wrong (971, counted=973).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 14/128 files (7.1% non-contiguous), 1075/2048 blocks
+Exit status is 1
diff --git a/tests/f_ea_bad_csum/expect.2 b/tests/f_ea_bad_csum/expect.2
new file mode 100644
index 0000000..d83fdfb
--- /dev/null
+++ b/tests/f_ea_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 14/128 files (7.1% non-contiguous), 1075/2048 blocks
+Exit status is 0
diff --git a/tests/f_ea_bad_csum/image.gz b/tests/f_ea_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e7a25c512feec33336f18ef0954737e91003269c
GIT binary patch
literal 3176
zcmeIy`&ZHj6aa8qEzO-1Zh53>rA*T$X)MiYK1k1*uSB#`o0_HtElpXH(nKSB=?SL`
z^HFMym71Aa<fAmC5_S1DQFMS53>XSBGDRNW?{}X4*1yp4{&3H|Ki<!|_uA3SVc8D+
z!=J5Ji^Q}e(c57El1>H1#}20-_D}}IGKx%(Q2~yvHtdkES~nnVe8#T7S+HnCeU7vZ
zg981&&EN2)jpGe?_fNI#hh5)9`Il{=vkqAp?023~j0nfil06$;>qS8B+aW)9ozR=4
z5o(@c<g@NbnET`b!<gl(Vy~@31!IVU(5!sC>}I*`>1We7>Ku!TvlDP(vSzNL?2j^~
zoS^AK*0p3JRW4V?GVdGTSCJA|lmIa)L%6u4YbgP?rRC)4A}(ZD7g1`NE}S_P*fdy@
z;hmkUtXW?Z+}XS{lu}uNDmkdQt0nkbJs421W^e^1eXV=z>MAq1vepIyfR!eOrrvbn
zBFNScDLlS_!)878-W;Ej>e@?9O5hKo<jcLHdc&)SrCYF+l*P%Oa(mdvVe$!r5Z1i3
zWwW5<jR%eGw-9vUT;zg+koc!8ro~P7?g`pM-bvQX7<t7afK9w74a1jao%O;D)&tk>
z<w<kPadgk&UE!O)E2o}G_%M}5>gPg}x!z#Day!%{b~SkqiwEL&peH0y?O>88jcN&9
zTruNf?7?+fcp>$GX}!eG5_-X-K@+2X#(>=0fNd6&j)mHD&NN0E>Qy$7wC3n-^gg_n
zaZ)RK@B9O)%+o%#aiAkcX4f*{9IcmA^nua(z)7RkRDVH`*xc9m?r6y`n}@a{1>-oK
z;Z(1OPhD_IYT@aK_5e4rLqfL#!{%euO?P+I^?NXm8{y%h!!rTYoJjvl4b4m{JDe{-
zkQsAdJc)?lWmHe+E<KvsvQob}FHUS=fXFKowkHVb=CN^Z*+&k^&MD|`9x*>mpLcIC
zg&d;qfV)<o1O$=*Ua+Qo(c$rI*n?{SVf>PFt)VAx3EHk`2XdHgeOxR9Q*9_n0n+z5
zB`)^%G*G>!INg2RJ#&h=X6-yg)%1*5UYI%Rum2e@)G;_lK#|5xq65?DuSu9@&0f3b
z$HWHmv1TH`@Qo51DpVH9_UY6qYYQnKa@<|@x3T5?ixqO>@Ejb=i~(d=9Nt*UAp*D)
zCw}w{AAQ|4H1b+h_>!gEbD>)o5o0j%Am<^+G7w|Nav}tGGOPr}AX<Lu4qoOF*;Z11
zWqiDNKC~fW2@J${wyHx0iG|9l>H8`d-t&xqz`U1tX4$2TMlDeI{SjGgjfj(_A9w99
z-oqySz8J!9b36@S%+xJYoy2{fzfx+adZVtcNJcJY{bq>ciA_Zyl<Wk74BJqan)i&k
zEV(tZz%+J5cO2xe8y)G>SyMV&tI=(0RJM-Xgi_09Y0$f6Nz>(ujm||-vKBt!1jetf
zn|?WEz7*vaz7<mRV#2Fdh+Py2x5V~?^UglTp9D36=A+kFw;tX06x6*V0mQs{@@lH!
z7^y-?3fg^q5Nq9<z?#4(FK|(b_Xv}qv5ISd(N68}DtOS3pbPZpynJlM@hT;YcRW=P
zt6I>+Rmd|P$WrQ4_WAj@wJ$fVR#uSDZokTnTJe4-aI^z40pxFzLeJIzKb|MsK6$vc
W0oMdRZ2`h{3@q4p;W7+n5Bm?Qd!Nbx

literal 0
HcmV?d00001

diff --git a/tests/f_ea_bad_csum/name b/tests/f_ea_bad_csum/name
new file mode 100644
index 0000000..958b244
--- /dev/null
+++ b/tests/f_ea_bad_csum/name
@@ -0,0 +1 @@
+EA block with bad checksum (metadata_csum)

