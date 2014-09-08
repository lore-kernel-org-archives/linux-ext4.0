From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/25] tests: test e2fsck recovery with broken commit blocks
Date: Mon, 08 Sep 2014 16:13:48 -0700
Message-ID: <20140908231348.25904.68480.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39500 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaIHXNy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:13:54 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test e2fsck' recovery of commit blocks with (a) only a corrupt
checksum and (b) an obviously incorrect tid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_corrupt_commit_csum/expect   |   18 ++++++++++++
 tests/j_corrupt_commit_csum/image.gz |  Bin
 tests/j_corrupt_commit_csum/name     |    1 +
 tests/j_corrupt_commit_csum/script   |   51 ++++++++++++++++++++++++++++++++++
 tests/j_corrupt_commit_tid/expect    |   17 +++++++++++
 tests/j_corrupt_commit_tid/image.gz  |  Bin
 tests/j_corrupt_commit_tid/name      |    1 +
 tests/j_corrupt_commit_tid/script    |   51 ++++++++++++++++++++++++++++++++++
 8 files changed, 139 insertions(+)
 create mode 100644 tests/j_corrupt_commit_csum/expect
 create mode 100644 tests/j_corrupt_commit_csum/image.gz
 create mode 100644 tests/j_corrupt_commit_csum/name
 create mode 100644 tests/j_corrupt_commit_csum/script
 create mode 100644 tests/j_corrupt_commit_tid/expect
 create mode 100644 tests/j_corrupt_commit_tid/image.gz
 create mode 100644 tests/j_corrupt_commit_tid/name
 create mode 100644 tests/j_corrupt_commit_tid/script


diff --git a/tests/j_corrupt_commit_csum/expect b/tests/j_corrupt_commit_csum/expect
new file mode 100644
index 0000000..5fc82b8
--- /dev/null
+++ b/tests/j_corrupt_commit_csum/expect
@@ -0,0 +1,18 @@
+test_filesys: recovering journal
+Journal transaction 3 was corrupt, replay was aborted.
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
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
diff --git a/tests/j_corrupt_commit_csum/image.gz b/tests/j_corrupt_commit_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..334fcd000d57f589e45987e6dc447c5f3e39c4bb
GIT binary patch
literal 2949
zcmb2|=3tok=T$Hh^V_?=88V?V3?H`38x{)BzVhwC!i){<fr@Qa7m~QPIkC1jEemkb
zy3!wYbXiwm=7dYX0@q{+ez_3*F=1neM#e%d(Q1K@A!`%##WqgY(iF<A+91^V{;i+N
z?3^rxTe(L2<A0ogQ}gEBzLS5_@0~k$j+^ns>bWZ~iyeA)!#ap7(cl~R<n$NoTxaEH
z<m|9_RqW~i-Y>H1^U{Z%k?QlV&*S}a^j`Q;0XgmV4Ry!A{a$amvF!WnYQMZ+wF!s6
zt$hD@*;?l2VtwD|TMTn2%l$7%I@$hSc31Y3%eJ-b^8XW#zI1x{?Ly!hU+<?YdZsy5
zUix!%&5xsRrcOT|A(O1KZu!5q)9+VFM~VIC;(exdd?It|ZMn0h`#%5Jrk(u%mW1}I
zpY{^lzus!w`R)1D^*n7~<IjD$^M3#C_1C3X7*IgN|6@N?7j3mXdf$@Ia@xDx%Ys}-
z=LPIO@9VB1R$Z0#{X?Xb)=~9swzd_IpXHwCv6-{1^+V~(fEy{>IX_38c`EP!cgwqi
z-&6klUm9|{J|XdW{m%nu{g)np?sbj*iSGaQdscrp{bB#ff1=*uAM+>q3I7}Zus^X^
z_|N#0|IGeB_Eon})fO6L_wKU!XkZ#0%k|Z_QQvbe+uMrkriHfiXKk%}*DcL=Q|QEI
zo&TF_^w-an*#Ggf@$cp5WA`bSX&L+HuVeeImcX|EZct_6p3QZ0;$58UY&aO6_<j4i
zf5zPRtFQgn|1xu7eMOGO*Xmz<_g@K%=yZIp*S)#&_v%fbYqHl!M%?(f>-o>Wll%T(
zUH|T0OzEp9Z~Fc}zrT$w@nFsW>yu=^-@f!?o4x#w;(b$(ey=yEzQ1SN_g(D`cV>nB
z_kYfC=v29P{+U((_P=`9{A~d=SPL>GrKI1@@95roCcNBy|DFBo_^xWtUp{?*$X*Sl
zSiYHheQSEeUcJkma!hyT<4xu{oQaVYUrrX3UHpCZ#6SMZo6pwOnccT6e^;^Z^#7YP
zYo^zqZhW@CeeUk0<=bQC?fb9Y^3HPKx4r+3YF|&>^8faa<5wPEaMiDW!PR?eek^Ca
z?5dt=ufF|%dE>&|ua|X8rh!t+5|KkW+#f#f3i;PxX0rLu*^+O!Yo6DCS1n-Qx_ITk
z%ePnj3qDiFW3}<`_3QOkNjh^MZ?ezyz5V}d_3WL0_itVucEs&x{62@j`cMDPioExx
zDCO$D=~BJ*4<oexE6@FZ<$qGh^!Zm=8BtOdDyQL@_E8VtncI%+&~eLNvGrF~Wsg_S
zw}9;TU%Mo_o!0Jsybj2gK-DwK8x4Wc5EzCbu;8W{Bg4+cY-sh+F!brDmqtTic!j`$
Q|1a~U-z3gpU{GKH0EFfkcmMzZ

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_commit_csum/name b/tests/j_corrupt_commit_csum/name
new file mode 100644
index 0000000..05a99ea
--- /dev/null
+++ b/tests/j_corrupt_commit_csum/name
@@ -0,0 +1 @@
+corrupt commit csum (csum v3)
diff --git a/tests/j_corrupt_commit_csum/script b/tests/j_corrupt_commit_csum/script
new file mode 100644
index 0000000..102feba
--- /dev/null
+++ b/tests/j_corrupt_commit_csum/script
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
diff --git a/tests/j_corrupt_commit_tid/expect b/tests/j_corrupt_commit_tid/expect
new file mode 100644
index 0000000..dfbb3f5
--- /dev/null
+++ b/tests/j_corrupt_commit_tid/expect
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
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
diff --git a/tests/j_corrupt_commit_tid/image.gz b/tests/j_corrupt_commit_tid/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..988e5c6763b541de0d5c70f336619ae94cb891f4
GIT binary patch
literal 2953
zcmb2|=3sd7=T$Hh^V_?z9U-AI3?Gc;XW!njbC%tg4Ob@d2OivZ!`Vyk2^$-$(^>^V
zwr>l?c8cY;dUt$NlvH)J{h?y3;_2eZ87A>l;Ns-e3HqK-x?6>!*YQhA-?lU^PdYw#
zYpd?@yT5<y{;z&scjk^|`TPI(jLYBM5oVeYZXLATwxxGt`3{jo0dK_B&RvM@Ho5=d
z#>+;LRs%abgP;}XrnkM`d~LqDy>x_Rb-bu^#TuDIx8B~C+wtzltJwAL?KVFAez5em
zUXA?r97&m3m6=xRy_xer{AhpNZC~^L!CmF~@8T*SeB_@tS4-p_hwRZ?TSEFyWoS-O
zKNEkZEB;JeWoD17q1&S>sf=BJT6vvgKd!%!vaU$RGGg1?i&4+5`*ZhNeOuqZam}p%
z&V|wIb7!oskNbKmAmaDakn?~4?fzZ8){y}f{K)T#S9`W~*$?YuipMYQ&9!n`ctber
z`_7jfN0a>h-^$r}J1zZj<l6G~yn8#o&OGRTX^X%<Jy9;{H)e@p-8=t0J~{uI%&dCH
zfB%D4J+(L3{(1kN|JRmZdR(mfn)%bT|A+JERz?16{=@#nUg1CEPyQ424*!@x$xry-
z@P|Du{-6BL+N1X@W^8qfU1#reHf*|6a`1!h;N_my_jr9{&M!+_JOB5iWzE}IKIxqP
zuXF$O->)BE+uLu>|8(c6b@FnfuV1cZZOUg__ThH!RPp21(#L<gnmjq~%;4}YW&Z!}
zm3k9i{g0i^bz1-1%)|#@ZWO%wzQ$(D9d(Tv!q5NT+7$f#ddl;kzt&35xczU}_n)<2
zAJ_j~z1#e^-@F<3KK}o6`<lX;neTz>9@kY%-T(Kzx%}+5O+WteFMB`x`nNkD3?@Vi
zzxw}D#v$Tk-pk(1tN(w$vrORUf(GsM=?^zvX8yV(<aAAG`0LYuU#|+-`>C?%r}x!v
zrAtpIynJ-xRK~)G_uMk?Jd)I_zWYpI*P&(Vhi|gJ4_E$e|0H$x?r%41p5NJ-{8R6L
zditl>e`kM3|CcL!(=+#8QRSz9>jieD|G4%2@98hP?U(=M|CJY)YuBs%dHB$UHGghS
z{cv^Rsf?A0|L6Dd-i@@s>y!>oFkXs2+Zp87dp`Z2QLTOYzE}GGv*rKF<JrmstS7y)
z-+T6z{n0na7kquYf8)Q)g2^X&rvE*;XUpIFJC;wq{omR;+cjs}|EJwo{s-Or?*BP$
zx^iuGe3se2*2OFT^q2h${@)!KTNftIf|{^Uc~R>{luc7_i9PO;`0TXy>UHhpkfbyG
zTffDv@7kzv<(74vMAlnbW>h_+ywMOC4S``80$XmeF({N@X&8oH8}-s?2n_2G_+kH-
NSAdZ%h=D<Y0RS767W@DJ

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_commit_tid/name b/tests/j_corrupt_commit_tid/name
new file mode 100644
index 0000000..9b4054c
--- /dev/null
+++ b/tests/j_corrupt_commit_tid/name
@@ -0,0 +1 @@
+corrupt commit tid (csum v3)
diff --git a/tests/j_corrupt_commit_tid/script b/tests/j_corrupt_commit_tid/script
new file mode 100644
index 0000000..102feba
--- /dev/null
+++ b/tests/j_corrupt_commit_tid/script
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

