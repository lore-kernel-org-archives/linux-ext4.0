From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/25] tests: test how e2fsck recovers from corrupt journal
 superblocks
Date: Mon, 08 Sep 2014 16:13:35 -0700
Message-ID: <20140908231335.25904.49826.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39426 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaIHXNk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:13:40 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test e2fsck' ability to deal with corrupt journal superblock checksum
and a bad magic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_corrupt_sb_csum/expect    |   21 +++++++++++++++
 tests/j_corrupt_sb_csum/image.gz  |  Bin
 tests/j_corrupt_sb_csum/name      |    1 +
 tests/j_corrupt_sb_csum/script    |   51 +++++++++++++++++++++++++++++++++++++
 tests/j_corrupt_sb_magic/expect   |   42 ++++++++++++++++++++++++++++++
 tests/j_corrupt_sb_magic/image.gz |  Bin
 tests/j_corrupt_sb_magic/name     |    1 +
 tests/j_corrupt_sb_magic/script   |   51 +++++++++++++++++++++++++++++++++++++
 8 files changed, 167 insertions(+)
 create mode 100644 tests/j_corrupt_sb_csum/expect
 create mode 100644 tests/j_corrupt_sb_csum/image.gz
 create mode 100644 tests/j_corrupt_sb_csum/name
 create mode 100644 tests/j_corrupt_sb_csum/script
 create mode 100644 tests/j_corrupt_sb_magic/expect
 create mode 100644 tests/j_corrupt_sb_magic/image.gz
 create mode 100644 tests/j_corrupt_sb_magic/name
 create mode 100644 tests/j_corrupt_sb_magic/script


diff --git a/tests/j_corrupt_sb_csum/expect b/tests/j_corrupt_sb_csum/expect
new file mode 100644
index 0000000..0493500
--- /dev/null
+++ b/tests/j_corrupt_sb_csum/expect
@@ -0,0 +1,21 @@
+Journal superblock is corrupt.
+Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 1
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 0
+debugfs: cat /a
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
diff --git a/tests/j_corrupt_sb_csum/image.gz b/tests/j_corrupt_sb_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..ee92f6b10a68ac7bb761e645969f612af7598b8b
GIT binary patch
literal 3030
zcmeH_|5MU;9LFiT(94}(Ds;<L+PCZGj+~^a6{Y92)ODE?Ly>Dt^N=s87y>FZ?8`OH
zYJQs{)e_14ww7UNLSGiv@>_1|P!W}(ATtmT5RuP&KWzQbzu@`$<#o@y*DsI9^R@j4
z7ns00cX~a1UPZW?@Qn}5lygoYNDn6D-rd#|)VzNK_Ez}27iE4f`R85PF}smPDR5kP
zbke5pO`=P8T<UK8(rt=7wyQYW&$sB>{apv56Rr{%w>MY!DLDu$X@%FT$Sss>xyEr$
z|35v_9AG2O^awn77Y<Zy9P(J6*5!p1T|C&QK<VD>EFU|>mIg;6=PVObl%|wwniqAv
z^<GsHDr#?xFQv7}WKnkQ#7VlA7H3C>RdQYFobXLQ$$lNWs2@pxUluZy)m|yU<}5v%
zi>tIUONE_5ZRY5TX7^fA{+S0+^W=~OMLF7g2<;76S;ee?%Nq6^b$N;4S&vl6n~pb}
zsA%=f5G{(W`2pDLs8@N}{s1v85z?#rFBDo#M|EI|Z7Wz28;9|H*vDg1-&gylx7RQ8
zb2CW#c4}xuA|7d0OZ9G|!C%wt^d-g>yxvmVxv|1JKdu6JJn}`m)_;uL?iz^i(W>1E
zKb?MGRR&ORSrDAbgy@Gl3^fc+8>QfArxpYnx8e7JV-VcD{RZHzApXYg0PF1TuenDd
zcpw^_Y$7b468N+4wP0xVw8pn*zr{^%8oYBHJK@>!M0i|<7aOt4%^Bw+A(TB;IZy>=
z^;Gw-zaS{LARZgg^yWQ|J(Hn{PW;vf{k81a4WloEV0Y%dMu2GADcf(JQFhZ9y#pK;
zBj;0e!SY>P%CYB!1xVdA-RwYIv)O}^0?#uYj>#)1#b==VNCyWRvM1B#mw*D9>5(pZ
zj=6t%02M`4e9lvy9Yic2X4PfaM4@f<ufw}0!UQGdF@Kc&T;j;}@-$5Az8il;X&qmA
zB-Ms3BkGAY($g~u-Kx}VsAme^7)%&dA7;NF9r%6c8Oaewg*mNZ+v7&9>pbd2q$TDR
zH`RxfT0Hec$gVk3I8xMbX#t%X|KOI^umP{{(nN@zP;gso)+`Vu$5k^vG5t1)F#g3~
z|6hyGYDMoP^n8wNjG9+xu|Njt{$VqV?0g%^zdDz+RW>?A2_Jigp+CoLcia^I`ISlJ
zL}3en#;auHE<qv{7iJm-VU9%32v>K>+5!}0!|j)ovV%#d8e&x-jYPdI&W)A6F>{CO
zoa%@CA4?+u#~FdkNCZz8@*uxBIdv)FusGgHENm;c&_zV6gb6X5$j+RDH~YAWm@u%<
zo4Aom0iONbP!i+h;=@W=tppgk6s;8~Wlyj5n&sL2MR}QRD{UdnC#tlUI7or^&c-{@
z#h5-2U)N0+Z2F({<FEaYnsL`}c6?dutr2c{6ft2ibOn$DLc=H2hJt{ZqNj3A%MBaT
u?ZfffUNf*}VAUEJASbWmNi=RQtCnyLY|X&xG{76v69;z-J7KULuzvwe)<rY`

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_sb_csum/name b/tests/j_corrupt_sb_csum/name
new file mode 100644
index 0000000..921a0fd
--- /dev/null
+++ b/tests/j_corrupt_sb_csum/name
@@ -0,0 +1 @@
+corrupt sb csum (csum v3)
diff --git a/tests/j_corrupt_sb_csum/script b/tests/j_corrupt_sb_csum/script
new file mode 100644
index 0000000..102feba
--- /dev/null
+++ b/tests/j_corrupt_sb_csum/script
@@ -0,0 +1,51 @@
+if test -x $DEBUGFS_EXE; then
+
+IMAGE=$test_dir/image.gz
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+gzip -d < $IMAGE > $TMPFILE
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "cat /a" > $TMPFILE.cmd
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+rm -f $TMPFILE.cmd
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/j_corrupt_sb_magic/expect b/tests/j_corrupt_sb_magic/expect
new file mode 100644
index 0000000..a233033
--- /dev/null
+++ b/tests/j_corrupt_sb_magic/expect
@@ -0,0 +1,42 @@
+Superblock has an invalid journal (inode 8).
+Clear? yes
+
+*** ext3 journal has been deleted - filesystem is now ext2 only ***
+
+Superblock has_journal flag is clear, but a journal is present.
+Clear? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Journal inode is not in use, but contains data.  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(32--33) -(35--49) -(83--1089)
+Fix? yes
+
+Free blocks count wrong for group #0 (956, counted=1980).
+Fix? yes
+
+Free blocks count wrong (956, counted=1980).
+Fix? yes
+
+Recreate journal? yes
+
+Creating journal (1024 blocks):  Done.
+
+*** journal has been re-created - filesystem is now ext3 again ***
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 1092/2048 blocks
+Exit status is 1
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 0
+debugfs: cat /a
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
diff --git a/tests/j_corrupt_sb_magic/image.gz b/tests/j_corrupt_sb_magic/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..5d895e78beaf49dd8e53370b85d7a7e5ce1afe82
GIT binary patch
literal 3036
zcmeIw>o?m67zgka-5hl6Y=_n@%E75p%_zDwby+ROn7S7^T8_DtR!TxDL|j|6?lme%
z)hV4aT1-Zw3@vpZQ9(9o5Rrr*@w1TMZ*TU-zu<V@eP28;zMtno<|!lcch<cX6h(`;
z2R^>Kh|Tzj!3Cl%jzHIMvUzn;$-dZWvai%onLKB_W>Kb*8La5<<PxBozDd_iH!O7O
z)9=?hS#;6xVWx)JvtqxDYgu#7;5oXWs>{myH9EETXWq9gF2G6@_eAWDb;ZMpV%lXZ
zQ>9wmsTYn|WzO<i5-O8!H@2?2!!H_^{uHe3Qj~R%bkqFTQn%^$XYKn0U(?xv$@fmm
z9JjONON_(=V0M)v+gN8LYsr^dBLH3iGb}Dr)?R@Q_rNZSj915Wul{y_dO+UuRYc3<
zrYpta!tWB#hCErHB-NjGCGb^e*0o;3Bz!&zHMmUFj$}a9*^OCSmbblLmhw4Dfr5ob
zOwD)!&l#oP@(K1_U~lVf3&fU4U6l-Oh>%$T?TG?|G!Tae(&2Od+?e&D{H_*jF7I$p
ze5W$v1fgvg>7D@{=J2VSrHLC!gw<wxJ%=dPCmUO+{_`~SNi2RY^Nhs`a5v||_&K8c
zFswRo1*W3Wu&w^0l)%7Te}k!A1mMO_^;e~^0es?L^>-8pND)95!f6Mef3i1#sTJk0
z0PTQpo7W*U60Hb9IJHMOs-;VYi9E?R0gowRw5NihU;~CqB!-GA)!|WaDtrFG-s5f$
zC0Z~wXt&nA3(Q8}i&1F4HDgIL;&(mTCL3wb5BVW#MLsRC>I}Hww<oMC2$odd`g`gc
zMcXn3pq2+azSY};xJ~OpAn40o<=h<UrHNWHkX0?o@)mLexG}PA%Uuw{x1Yv3{_-(<
zy4EN&7Qf@%tuUu&l2Xep$C|P2@lgiOn!|i*Ym?UncXsZqnC(jo(88MXio%lxgEgZT
zT$G))eEtLNn-_KB-QxI&FOUH}f@Nsw;cI`apZ@zcDgBQ^OE>9Sw^vLg%d^3c<tZP}
z3;U3V((Igen3jUpKU(BdZj^Y{n{!PjTqU~5%Oa3PPnn^?T6b)srY`k{^-EZMWtIOg
z*;yXQVaj&No%3@^LZN)siarI9qUCurpM9xUW<#d=w`F%wqn6U6n)m6<zrNqhl51Th
zN$S3CU!~)AyG&DKB~>~pbv;6RAUK&#3BwAJ{hLg?fa_-N7%04~V|@C)d)Hfl#eUA?
zwq}%s<UpV-r+T6ZBJs8keyB|4Y&Oa~>Se6Gxbs4;tGy&vav%wukqyNe(%_~@BIMnW
zdge_BY+DT{46V^t80E~0U09MD$%kM8vpaVbU?tGDS*4)P9RRJ1Ef@`%ih+hAyyfEs
z>@nEuxs*M2^2FhvJ(SXB&kwrbD#mj0{`nuzN~BWpX&Q>*w8Rx+P%D|;EM9dXn5cGW
r<v1J*919#pfr;oKL|O+=P5CI6JMMHWaD)ZYf&@ryg3DtB!T|9f_U=kB

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_sb_magic/name b/tests/j_corrupt_sb_magic/name
new file mode 100644
index 0000000..dc781aa
--- /dev/null
+++ b/tests/j_corrupt_sb_magic/name
@@ -0,0 +1 @@
+corrupt sb magic (csum v3)
diff --git a/tests/j_corrupt_sb_magic/script b/tests/j_corrupt_sb_magic/script
new file mode 100644
index 0000000..102feba
--- /dev/null
+++ b/tests/j_corrupt_sb_magic/script
@@ -0,0 +1,51 @@
+if test -x $DEBUGFS_EXE; then
+
+IMAGE=$test_dir/image.gz
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+gzip -d < $IMAGE > $TMPFILE
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "cat /a" > $TMPFILE.cmd
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+rm -f $TMPFILE.cmd
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

