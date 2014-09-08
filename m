From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/25] tests: test e2fsck recovery of corrupt revoke blocks
Date: Mon, 08 Sep 2014 16:13:41 -0700
Message-ID: <20140908231341.25904.75703.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39461 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaIHXNs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:13:48 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test e2fsck' ability to deal with (a) revoke blocks with a bad
checksum and (b) revoke blocks with an obviously bad block number.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_corrupt_revoke_block/expect   |   17 +++++++++++
 tests/j_corrupt_revoke_block/image.gz |  Bin
 tests/j_corrupt_revoke_block/name     |    1 +
 tests/j_corrupt_revoke_block/script   |   51 +++++++++++++++++++++++++++++++++
 tests/j_corrupt_revoke_csum/expect    |   17 +++++++++++
 tests/j_corrupt_revoke_csum/image.gz  |  Bin
 tests/j_corrupt_revoke_csum/name      |    1 +
 tests/j_corrupt_revoke_csum/script    |   51 +++++++++++++++++++++++++++++++++
 8 files changed, 138 insertions(+)
 create mode 100644 tests/j_corrupt_revoke_block/expect
 create mode 100644 tests/j_corrupt_revoke_block/image.gz
 create mode 100644 tests/j_corrupt_revoke_block/name
 create mode 100644 tests/j_corrupt_revoke_block/script
 create mode 100644 tests/j_corrupt_revoke_csum/expect
 create mode 100644 tests/j_corrupt_revoke_csum/image.gz
 create mode 100644 tests/j_corrupt_revoke_csum/name
 create mode 100644 tests/j_corrupt_revoke_csum/script


diff --git a/tests/j_corrupt_revoke_block/expect b/tests/j_corrupt_revoke_block/expect
new file mode 100644
index 0000000..52cda2c
--- /dev/null
+++ b/tests/j_corrupt_revoke_block/expect
@@ -0,0 +1,17 @@
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 0
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 0
+debugfs: cat /a
+bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbb
\ No newline at end of file
diff --git a/tests/j_corrupt_revoke_block/image.gz b/tests/j_corrupt_revoke_block/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..b165d00b46676b6c35d974053ee557c1a757bc09
GIT binary patch
literal 3038
zcmeIw*;7*o6bA4JGbS}!El`RI5(f)q!c<Ze5NeTH#Ssw{WfO=f9Rz{Ypp6*GWeJN=
z#1>OFB_It#(O^(w7Lu??U_iE_!2l*hiGT<piQX*SaBm;_#J|9B-oA(P@cqtlEW)5D
z#`#bS%f+`qfz4Tal*UVVIh9&feIo>jh>42Bz{fTn!G;#%G+Rq*kkg;}_j+jd(CJTc
z7^ESmrr@tTPyD(7o1Z!h_E`PcP;kO$i`AF^elC(&2^2y(YeER3qq)_P$zEA;zv8(U
zG&AGt>j9+_F^7cn!8v5ix#_tG0$uDqDE(?~(1|hOO>T5KVtX`zn%BZ1CkkSp!ELw4
zUsQVgoWjJNbEP+<4V#Gyoq32!j7eL{R`v^B#J5=!RH#0-N?tm1x94E&RrSl-6}(sU
z<k)_)e!gAT70LBHgEh6BDd}Te_@)?7Y&a_kfd;S_U*00vJP!>X1u32<21@)QOHZ@h
zl+MG)XHTl(3#s;d3$(@v*wCGEP)T62Y2bO{+{#qcP{yZ+OJNh)sMVuU+KGZ*CI^8~
zKy5K=iQAa>=*b?HGA(pVZs#9gn<&PsxyPqoJNQDjq_><V1LK(+om3RbmB(4vx0d%y
z9NNBbdPCTa?6vu5MynUhL?C|F>%I2ah(7bze&nIz2VOLsV@9j|aL5MJ)?VNcY^ig+
zgJhb~^+ec_D4Or`j{Hz8I0KXm9)FuBWw+0={7Y$VI|aPzlW(IWRF2Q3;F|ldb&@}q
zSl2)kaBrN9sQzJrS3>xDoh*r*Y{8D}e&5$Vw;)Z2opy}(*rI9{U$GHvE0hsu1UmxQ
zl!4*2#Q2Ll_R@4&Wzqf}4p$J;Q31b<jZQL{Wb*HRNq|1Iqi6kK!wRraCrlt#3*XNu
z5aL8Uw)2yWx$)gLu5_eKyXky*xh9K7+0{5H{XOuYYm2+jxX0aMM&Ky;0Gz${%31be
z<kt0gd6+<(kQVsdpbrvxK6M#zEupr}O;#L+!c%#?=F6&u*IDoKpC+d?*y?_6+{M6m
z=jpMzQ6RQe+2$_2XLtCDFSsuTNa%WHHkR&pJ=>>Cv3UGxkdqZEMs|*m@gN|#DyZ`6
z7EJ^Kkq%^A{C~^#MV5j~x=9tEOS!}YLHJ{ZyG)l(UMXtb_{BSp=S>Da^6*6aK9a&_
zY$b$}<Yep=W0_*ZslsJtZH%7pLQ7e?xASJ5=!2gonmPt#@WJL<fMoB6XE-||EgbGp
z=#5~0hfWgCnpTcjS}XHm!*c%M@FO^VT5B%Z2Xd!MuQ5-6fOaZOCSlOzqY9If^8jp~
zy6%HS$`;HIx2dty21NRine-dml}*)FB_asi6Q)L(ivvw>+>pSr14v-HMD2{^Pxp@S
ziz){YRr246X=>R-EPMtp^Kq-6c6A!Q(QVg=AKgw+7ZN;FBC*1u&Z^EywIWhjUkvMo
yeAS!Nfu7YX>uFtJU0^K=JmzjkUGg2wT#Mb-JFN?>WdR-o-hkUp??Rz)sQ&=iqgHMJ

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_revoke_block/name b/tests/j_corrupt_revoke_block/name
new file mode 100644
index 0000000..c7a0088
--- /dev/null
+++ b/tests/j_corrupt_revoke_block/name
@@ -0,0 +1 @@
+corrupt revoke block (csum v3)
diff --git a/tests/j_corrupt_revoke_block/script b/tests/j_corrupt_revoke_block/script
new file mode 100644
index 0000000..102feba
--- /dev/null
+++ b/tests/j_corrupt_revoke_block/script
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
diff --git a/tests/j_corrupt_revoke_csum/expect b/tests/j_corrupt_revoke_csum/expect
new file mode 100644
index 0000000..52cda2c
--- /dev/null
+++ b/tests/j_corrupt_revoke_csum/expect
@@ -0,0 +1,17 @@
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 0
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
+Exit status is 0
+debugfs: cat /a
+bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbb
\ No newline at end of file
diff --git a/tests/j_corrupt_revoke_csum/image.gz b/tests/j_corrupt_revoke_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..f505592079452ad78b22f5c096f951158d47981d
GIT binary patch
literal 3034
zcmeH_>o?m67{_DICZ~k0T2s|VXS2Fg=CoT}aw*!PV|K!EkGLIkO<YDSwMIwP$z0m4
znPM0gw^o=-G?GZ`oJu<fahqChCUXx#BqF!pUaW6=&i;bV^X~bc^St<cz7O<!Fi3Q;
z5%QMtmIzmNBF`4IBazXWqD<0;H!=bn6%RH99J^{7Lb2O<YQJ`Y`fdrrIM~PE-SoSi
zCUa7mKLvcl40qznNZE(SecH<~o{(cFm&`fvrp*IZ4NbsOTEs9Kw1>8mn)(`vc$<(v
z+;_2$E5d;<vuyl})4&4hT7gH2!F|HPYVCzRRe&IMz^_`3j*{;5?dGHo#rEIiP9!8?
zZR=fb_p}@znfKLRb0yp`tWI{*S;Q&%9OuVI-d_E;`kC%=p<`~RB_8HMR_#2Ut8+cO
zb{0v@%UZtY5)DnG6-IXY@u)fNf#-2foj50hV#!*OV8&C<3ifwdHmz2p+(!W&*MI7^
zOra^-R5#twmG3_*C`15SDWie#Ab5V5)PvsFXLV^&ni*nxmpAD3Q4`8V4#|V98skL%
z=rlnv>k}4bwI^YA+{UCX^y=V+L%x3Nb6A$P8ZQ}WlT-U$N(f_-j5)kza{q%d?wKJ(
zo6y4%fZbQ<Otxh@Nx|0#@O4$nf~F{c3}_Rh`Z0!Loyp&5JHY7B;yL-U!FUgP7bw!1
zB*z*WBUmfN?veY~upN>>QCPKaV)&xz^e+KuF$5bk`76Fl!ihND`w@SFqJ!;mdYe!{
z)r?@fF>0vS&D@jDVGq>G>Wb1Ml<B<1m%`C+hTns1C7uTH^C=1dlg)vZvr+rcl@q5(
zunPPaQd%%-=ZA~uAKTM`aVJ-iBs^wS5I6p${z5%K-j{0uwI6YE7(pHz=Kx&BGn<l{
zOgl*Dxs0k7nDo?>hELXw^$iFNbG)UR6q1xZIpy_pMfK-1%4VfD&&qOhX)Q_ECu<j~
z`<TmKT1^|Sjv2BN`mr!J#~}Nw_#qsN;3G-f8;if&M>0^e*AII`t16wBOI4<{W({o#
z4Xbp6jb_CJbAq7Uhw*9gy0O~(ok@qDx57xP>cvzp0NF|(QF5op9fCYf3NjY;gEDWU
ze|ub1VF&{FZ%9ekXNYMH2~Y-F6AlprhUI4OD|u`Pjz@jelo?k$7*|`R|1vnuUOjTl
zw2^%fPtk1hT?InRum1E}EfuH8H5RCOu~HI|sn4~32{mzcqIPJx8SE`Zzc>WnqmzG{
z3J_&8FXX<!4ZUx8N*KW2Eiil##LZNPBHJ)}T;XG?l0d_$28aeCJx!nMey@@ocFD`&
zcoO$c7Xhf?p$Du*Gleo5p>+$;LZg{_G6UV6(5LH;SyjW9^`&(>bKX><qWV%Du*(bu
z(0&^{vg5RLzUu8)q_6+&tF7n{XP!T{W`dF(UcPWnu2gPYpK<f_6-zdeZYw2hu9SZF
wfN1ugr$^zDfg=NNk^z2Nv{4a53I@MPP)96B2L1;IilWz{_JJk~AdnsCAAu!D7XSbN

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_revoke_csum/name b/tests/j_corrupt_revoke_csum/name
new file mode 100644
index 0000000..b63ea23
--- /dev/null
+++ b/tests/j_corrupt_revoke_csum/name
@@ -0,0 +1 @@
+corrupt revoke csum (csum v3)
diff --git a/tests/j_corrupt_revoke_csum/script b/tests/j_corrupt_revoke_csum/script
new file mode 100644
index 0000000..102feba
--- /dev/null
+++ b/tests/j_corrupt_revoke_csum/script
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

