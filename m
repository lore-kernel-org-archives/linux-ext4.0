From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 34/47] tests: verify proper rebuilding of sparse extent
 trees and block map file conversion
Date: Fri, 07 Nov 2014 13:54:26 -0800
Message-ID: <20141107215426.883.65261.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46385 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaKGVyc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:54:32 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_collapse_extent_tree/expect.1       |   16 ++++
 tests/f_collapse_extent_tree/expect.2       |   10 ++
 tests/f_collapse_extent_tree/image.gz       |  Bin
 tests/f_collapse_extent_tree/name           |    1 
 tests/f_collapse_extent_tree/script         |  118 +++++++++++++++++++++++++++
 tests/f_compress_extent_tree_level/expect.1 |   23 +++++
 tests/f_compress_extent_tree_level/expect.2 |   17 ++++
 tests/f_compress_extent_tree_level/image.gz |  Bin
 tests/f_compress_extent_tree_level/name     |    1 
 tests/f_compress_extent_tree_level/script   |  118 +++++++++++++++++++++++++++
 tests/f_convert_bmap/expect.1               |   26 ++++++
 tests/f_convert_bmap/expect.2               |   10 ++
 tests/f_convert_bmap/image.gz               |  Bin
 tests/f_convert_bmap/name                   |    1 
 tests/f_convert_bmap/script                 |  119 +++++++++++++++++++++++++++
 tests/f_extent_too_deep/expect.1            |   23 +++++
 tests/f_extent_too_deep/expect.2            |   10 ++
 tests/f_extent_too_deep/image.gz            |  Bin
 tests/f_extent_too_deep/name                |    1 
 tests/f_extent_too_deep/script              |  118 +++++++++++++++++++++++++++
 tests/f_opt_extent/expect                   |   55 ++++++++++++
 tests/f_opt_extent/name                     |    1 
 tests/f_opt_extent/script                   |   64 +++++++++++++++
 tests/f_opt_extent_ext3/expect              |   45 ++++++++++
 tests/f_opt_extent_ext3/name                |    1 
 tests/f_opt_extent_ext3/script              |   65 +++++++++++++++
 26 files changed, 843 insertions(+)
 create mode 100644 tests/f_collapse_extent_tree/expect.1
 create mode 100644 tests/f_collapse_extent_tree/expect.2
 create mode 100644 tests/f_collapse_extent_tree/image.gz
 create mode 100644 tests/f_collapse_extent_tree/name
 create mode 100644 tests/f_collapse_extent_tree/script
 create mode 100644 tests/f_compress_extent_tree_level/expect.1
 create mode 100644 tests/f_compress_extent_tree_level/expect.2
 create mode 100644 tests/f_compress_extent_tree_level/image.gz
 create mode 100644 tests/f_compress_extent_tree_level/name
 create mode 100644 tests/f_compress_extent_tree_level/script
 create mode 100644 tests/f_convert_bmap/expect.1
 create mode 100644 tests/f_convert_bmap/expect.2
 create mode 100644 tests/f_convert_bmap/image.gz
 create mode 100644 tests/f_convert_bmap/name
 create mode 100644 tests/f_convert_bmap/script
 create mode 100644 tests/f_extent_too_deep/expect.1
 create mode 100644 tests/f_extent_too_deep/expect.2
 create mode 100644 tests/f_extent_too_deep/image.gz
 create mode 100644 tests/f_extent_too_deep/name
 create mode 100644 tests/f_extent_too_deep/script
 create mode 100644 tests/f_opt_extent/expect
 create mode 100644 tests/f_opt_extent/name
 create mode 100644 tests/f_opt_extent/script
 create mode 100644 tests/f_opt_extent_ext3/expect
 create mode 100644 tests/f_opt_extent_ext3/name
 create mode 100644 tests/f_opt_extent_ext3/script


diff --git a/tests/f_collapse_extent_tree/expect.1 b/tests/f_collapse_extent_tree/expect.1
new file mode 100644
index 0000000..0d4b465
--- /dev/null
+++ b/tests/f_collapse_extent_tree/expect.1
@@ -0,0 +1,16 @@
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -     0     9              1
+ 1/ 1   1/  1     0 -     0    10 -    10      1 
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extent tree could be more compact.  Fix? yes
+
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 1
diff --git a/tests/f_collapse_extent_tree/expect.2 b/tests/f_collapse_extent_tree/expect.2
new file mode 100644
index 0000000..a1d28b1
--- /dev/null
+++ b/tests/f_collapse_extent_tree/expect.2
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 0
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  1     0 -     0    10 -    10      1 
diff --git a/tests/f_collapse_extent_tree/image.gz b/tests/f_collapse_extent_tree/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..97036cc597c5d2bcf6da6ffa68039b743b46aa20
GIT binary patch
literal 2537
zcmb2|=3r2~7aqdI{Pxc7?BGBdh6lxY##=IfImEQ^-3nbX`9VZ0->#??lNCe@FW4FQ
z#YVL}TII*Z*HrHjAfO&wvUze}my@ja$2)hVrIT2)v*+IzulqiySl;uUviknXEiDW(
zp{IYUa6fd>vO6yD>gk^~J=eHSyKdZJX8c#hmFMiUr|S)uTs`cRwf(*Jw5JI-Ev9#g
zzx10H^z+x-+1&PezM<j%wN-x#UY^?f?s?&}Z!v%C-)BF5eDl?n_HOO-adCV1e|+^f
zi)Zq}X`-jCz9%p5SsMMuaQ~#F154Q%4#=Ijd_P(9SoF_&+pXIBr(Hc<aafRvfuW&!
zy=4ribnWdMatsU%H@<&*|36zXO?crCT?gHin@3zeO5c0DaMs;f`-AOklmETD^R*_D
z<Gowbo@dFzK=l>@Y`c&Bzwh4l(H_VvIMHLp0;CiE@B>MS|I9!V1gcl=k~>^-C+GRq
zERBES2J6qaJ*xkI`|HBKUj^>6K=~WTAJ?~oRpKF>ikGbB1<K1<*)cNWQAa>3L0jxv
z+Ope)Q@;H^{nJEJ_gnqOo+Qus7x`2FDlW?`wQch{Ubb=Tv2VRgcl<QbdwS81f1O)`
zxz73}p2?fs|I45L_x?U_+1AJMzxKcTu9(hR=B|9cUak6ReWXR?Gy8?^|AIA>)j!SO
zTl3dGUh~(|qxV1UpRv3(_UHXHezOY~k3TI=558jc%31d7spkCte`^0vE7$)i)8ioE
m=uzp>5Eu=C(GVC7fzc2c4FPgP;J~%NEDm#Conv57U;qF<XAwLA

literal 0
HcmV?d00001

diff --git a/tests/f_collapse_extent_tree/name b/tests/f_collapse_extent_tree/name
new file mode 100644
index 0000000..83e506f
--- /dev/null
+++ b/tests/f_collapse_extent_tree/name
@@ -0,0 +1 @@
+extent tree can be collapsed one level
diff --git a/tests/f_collapse_extent_tree/script b/tests/f_collapse_extent_tree/script
new file mode 100644
index 0000000..ee18438
--- /dev/null
+++ b/tests/f_collapse_extent_tree/script
@@ -0,0 +1,118 @@
+if [ "$DESCRIPTION"x != x ]; then
+	test_description="$DESCRIPTION"
+fi
+if [ "$IMAGE"x = x ]; then
+	IMAGE=$test_dir/image.gz
+fi
+
+if [ "$FSCK_OPT"x = x ]; then
+	FSCK_OPT=-yf
+fi
+
+if [ "$SECOND_FSCK_OPT"x = x ]; then
+	SECOND_FSCK_OPT=-yf
+fi
+
+if [ "$OUT1"x = x ]; then
+	OUT1=$test_name.1.log
+fi
+
+if [ "$OUT2"x = x ]; then
+	OUT2=$test_name.2.log
+fi
+
+if [ "$EXP1"x = x ]; then
+	if [ -f $test_dir/expect.1.gz ]; then
+		EXP1=$test_name.1.tmp
+		gunzip < $test_dir/expect.1.gz > $EXP1
+	else
+		EXP1=$test_dir/expect.1
+	fi
+fi
+
+if [ "$EXP2"x = x ]; then
+	if [ -f $test_dir/expect.2.gz ]; then
+		EXP2=$test_name.2.tmp
+		gunzip < $test_dir/expect.2.gz > $EXP2
+	else
+		EXP2=$test_dir/expect.2
+	fi
+fi
+
+if [ "$SKIP_GUNZIP" != "true" ] ; then
+	gunzip < $IMAGE > $TMPFILE
+fi
+
+cp /dev/null $OUT1
+
+eval $PREP_CMD
+
+echo 'ex /a' > $TMPFILE.cmd
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE > $OUT1.new 2>&1
+rm -rf $TMPFILE.cmd
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT1.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT1.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT1.new >> $OUT1
+rm -f $OUT1.new
+
+if [ "$ONE_PASS_ONLY" != "true" ]; then
+	$FSCK $SECOND_FSCK_OPT -N test_filesys $TMPFILE > $OUT2.new 2>&1 
+	status=$?
+	echo Exit status is $status >> $OUT2.new
+	echo 'ex /a' > $TMPFILE.cmd
+	$DEBUGFS -f $TMPFILE.cmd $TMPFILE >> $OUT2.new 2>&1
+	rm -rf $TMPFILE.cmd
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT2.new > $OUT2
+	rm -f $OUT2.new
+fi
+
+eval $AFTER_CMD
+
+if [ "$SKIP_VERIFY" != "true" ] ; then
+	rm -f $test_name.ok $test_name.failed
+	cmp -s $OUT1 $EXP1
+	status1=$?
+	if [ "$ONE_PASS_ONLY" != "true" ]; then
+		cmp -s $OUT2 $EXP2
+		status2=$?
+	else
+		status2=0
+	fi
+	if [ "$PASS_ZERO" = "true" ]; then
+		cmp -s $test_name.0.log	$test_dir/expect.0
+		status3=$?
+	else
+		status3=0
+	fi
+
+	if [ -z "$test_description" ] ; then
+		description="$test_name"
+	else
+		description="$test_name: $test_description"
+	fi
+
+	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
+		echo "$description: ok"
+		touch $test_name.ok
+	else
+		echo "$description: failed"
+		rm -f $test_name.failed
+		if [ "$PASS_ZERO" = "true" ]; then
+			diff $DIFF_OPTS $test_dir/expect.0 \
+				$test_name.0.log >> $test_name.failed
+		fi
+		diff $DIFF_OPTS $EXP1 $OUT1 >> $test_name.failed
+		if [ "$ONE_PASS_ONLY" != "true" ]; then
+			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
+		fi
+	fi
+	rm -f tmp_expect
+fi
+
+if [ "$SKIP_CLEANUP" != "true" ] ; then
+	unset IMAGE FSCK_OPT SECOND_FSCK_OPT OUT1 OUT2 EXP1 EXP2 
+	unset SKIP_VERIFY SKIP_CLEANUP SKIP_GUNZIP ONE_PASS_ONLY PREP_CMD
+	unset DESCRIPTION SKIP_UNLINK AFTER_CMD PASS_ZERO
+fi
+
diff --git a/tests/f_compress_extent_tree_level/expect.1 b/tests/f_compress_extent_tree_level/expect.1
new file mode 100644
index 0000000..9db4131
--- /dev/null
+++ b/tests/f_compress_extent_tree_level/expect.1
@@ -0,0 +1,23 @@
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  2     0 -    16     9             17
+ 1/ 1   1/  4     0 -     0    10 -    10      1 
+ 1/ 1   2/  4    11 -    11   100 -   100      1 
+ 1/ 1   3/  4    13 -    13   101 -   101      1 
+ 1/ 1   4/  4    15 -    15   102 -   102      1 
+ 0/ 1   2/  2    17 -    21    12              5
+ 1/ 1   1/  3    17 -    17   103 -   103      1 
+ 1/ 1   2/  3    19 -    19   104 -   104      1 
+ 1/ 1   3/  3    21 -    21   105 -   105      1 
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extent tree could be more compact.  Fix? yes
+
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 26/512 blocks
+Exit status is 1
diff --git a/tests/f_compress_extent_tree_level/expect.2 b/tests/f_compress_extent_tree_level/expect.2
new file mode 100644
index 0000000..07d1082
--- /dev/null
+++ b/tests/f_compress_extent_tree_level/expect.2
@@ -0,0 +1,17 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 26/512 blocks
+Exit status is 0
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 1   1/  1     0 -    21     9             22
+ 1/ 1   1/  7     0 -     0    10 -    10      1 
+ 1/ 1   2/  7    11 -    11   100 -   100      1 
+ 1/ 1   3/  7    13 -    13   101 -   101      1 
+ 1/ 1   4/  7    15 -    15   102 -   102      1 
+ 1/ 1   5/  7    17 -    17   103 -   103      1 
+ 1/ 1   6/  7    19 -    19   104 -   104      1 
+ 1/ 1   7/  7    21 -    21   105 -   105      1 
diff --git a/tests/f_compress_extent_tree_level/image.gz b/tests/f_compress_extent_tree_level/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..a552a586ce20e4fbc01d6f332ec800c5c5b6011f
GIT binary patch
literal 2581
zcmb2|=3rR!C_IFT`RyHR9}!0hh6gkEYCmX@`O&3zM1osdIA^Jlw(gQiEytLI<J9c9
z&L3%E^Y!W3JGZlUZ`ds<>4n?Hq`jLtg`|b&q_WGat95BG-FN>tx4!H<U)lS-AJ6lO
z6&ZG4&Dp8pWHDvdcEgsixcDa#cN4c|Jrj3xXS?6icVxq+qB_I2E!8u;UtfEt{cM|d
zx!<y9uDd4Byy90XBb_r>eqZ_jr)RIH>*?If{BP|Sv-8%k+sAkPd2;YL_u=Paa{ab8
z7R65wT$X5aDi6&4{msJ6yZ%?_>ox0_zxZ;6nIVCD%G3ArMBKw){||e0eSc1N>&EnR
z0t^fcIrZA@uO9}lJ$3)OSwS^W;KBazx_|d&lMDq`Wi#$_4&>npx&GlDckiQ5TVJnz
zJo$QFjI93l)(@*BAG_wy2C6@>?b21V|Nk$ndG;T~<GcJ?1V}ghv<H$2|M-C<2;?k1
z7G&FVWc^>G+?H3>jHhdCT>a0f2bmPx&0M7aJXrJFvl^?T|K`LORWSmc@PEdCYgULx
zh7E5`r)9;j`(JJgG7%fdIpei?Ey$ub7WWu|+Q|hE%FpQb^sPCXXZ5ap`Q=61t^WO#
zxjHTCMMSQ(lh5g6K|Ejc^Tfly|0w>exlI4=-q>Te9zVFr@rQf!_Dhd`Ua)#xf9CQ1
zW2IZaKK4Jh|J#3OInf{H^QM12f1&DYykOsxU+Qau|6eK2ar?V@>iYlgPk)$;9sa}r
zHJ&GZ|LXr;C41uCH=MikZRv}1mHu*%)xaV1=-A3zpVnWgPo1*Aeytb_x&9i}HyQ$?
fAut*OqaiRF0;3^7AOs$KuVp*dzh0JsL4g4PCSfgc

literal 0
HcmV?d00001

diff --git a/tests/f_compress_extent_tree_level/name b/tests/f_compress_extent_tree_level/name
new file mode 100644
index 0000000..fde4f4a
--- /dev/null
+++ b/tests/f_compress_extent_tree_level/name
@@ -0,0 +1 @@
+compress an extent tree level
diff --git a/tests/f_compress_extent_tree_level/script b/tests/f_compress_extent_tree_level/script
new file mode 100644
index 0000000..ee18438
--- /dev/null
+++ b/tests/f_compress_extent_tree_level/script
@@ -0,0 +1,118 @@
+if [ "$DESCRIPTION"x != x ]; then
+	test_description="$DESCRIPTION"
+fi
+if [ "$IMAGE"x = x ]; then
+	IMAGE=$test_dir/image.gz
+fi
+
+if [ "$FSCK_OPT"x = x ]; then
+	FSCK_OPT=-yf
+fi
+
+if [ "$SECOND_FSCK_OPT"x = x ]; then
+	SECOND_FSCK_OPT=-yf
+fi
+
+if [ "$OUT1"x = x ]; then
+	OUT1=$test_name.1.log
+fi
+
+if [ "$OUT2"x = x ]; then
+	OUT2=$test_name.2.log
+fi
+
+if [ "$EXP1"x = x ]; then
+	if [ -f $test_dir/expect.1.gz ]; then
+		EXP1=$test_name.1.tmp
+		gunzip < $test_dir/expect.1.gz > $EXP1
+	else
+		EXP1=$test_dir/expect.1
+	fi
+fi
+
+if [ "$EXP2"x = x ]; then
+	if [ -f $test_dir/expect.2.gz ]; then
+		EXP2=$test_name.2.tmp
+		gunzip < $test_dir/expect.2.gz > $EXP2
+	else
+		EXP2=$test_dir/expect.2
+	fi
+fi
+
+if [ "$SKIP_GUNZIP" != "true" ] ; then
+	gunzip < $IMAGE > $TMPFILE
+fi
+
+cp /dev/null $OUT1
+
+eval $PREP_CMD
+
+echo 'ex /a' > $TMPFILE.cmd
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE > $OUT1.new 2>&1
+rm -rf $TMPFILE.cmd
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT1.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT1.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT1.new >> $OUT1
+rm -f $OUT1.new
+
+if [ "$ONE_PASS_ONLY" != "true" ]; then
+	$FSCK $SECOND_FSCK_OPT -N test_filesys $TMPFILE > $OUT2.new 2>&1 
+	status=$?
+	echo Exit status is $status >> $OUT2.new
+	echo 'ex /a' > $TMPFILE.cmd
+	$DEBUGFS -f $TMPFILE.cmd $TMPFILE >> $OUT2.new 2>&1
+	rm -rf $TMPFILE.cmd
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT2.new > $OUT2
+	rm -f $OUT2.new
+fi
+
+eval $AFTER_CMD
+
+if [ "$SKIP_VERIFY" != "true" ] ; then
+	rm -f $test_name.ok $test_name.failed
+	cmp -s $OUT1 $EXP1
+	status1=$?
+	if [ "$ONE_PASS_ONLY" != "true" ]; then
+		cmp -s $OUT2 $EXP2
+		status2=$?
+	else
+		status2=0
+	fi
+	if [ "$PASS_ZERO" = "true" ]; then
+		cmp -s $test_name.0.log	$test_dir/expect.0
+		status3=$?
+	else
+		status3=0
+	fi
+
+	if [ -z "$test_description" ] ; then
+		description="$test_name"
+	else
+		description="$test_name: $test_description"
+	fi
+
+	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
+		echo "$description: ok"
+		touch $test_name.ok
+	else
+		echo "$description: failed"
+		rm -f $test_name.failed
+		if [ "$PASS_ZERO" = "true" ]; then
+			diff $DIFF_OPTS $test_dir/expect.0 \
+				$test_name.0.log >> $test_name.failed
+		fi
+		diff $DIFF_OPTS $EXP1 $OUT1 >> $test_name.failed
+		if [ "$ONE_PASS_ONLY" != "true" ]; then
+			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
+		fi
+	fi
+	rm -f tmp_expect
+fi
+
+if [ "$SKIP_CLEANUP" != "true" ] ; then
+	unset IMAGE FSCK_OPT SECOND_FSCK_OPT OUT1 OUT2 EXP1 EXP2 
+	unset SKIP_VERIFY SKIP_CLEANUP SKIP_GUNZIP ONE_PASS_ONLY PREP_CMD
+	unset DESCRIPTION SKIP_UNLINK AFTER_CMD PASS_ZERO
+fi
+
diff --git a/tests/f_convert_bmap/expect.1 b/tests/f_convert_bmap/expect.1
new file mode 100644
index 0000000..7d2ca86
--- /dev/null
+++ b/tests/f_convert_bmap/expect.1
@@ -0,0 +1,26 @@
+debugfs: stat /a
+Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
+Generation: 1573716129    Version: 0x00000000:00000001
+User:     0   Group:     0   Size: 524288
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 1030
+Fragment:  Address: 0    Number: 0    Size: 0
+ ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
+ atime: 0x5457f87a:61ba0598 -- Mon Nov  3 21:49:46 2014
+ mtime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
+crtime: 0x5457f87a:61ba0598 -- Mon Nov  3 21:49:46 2014
+Size of extra inode fields: 28
+BLOCKS:
+(0-11):1025-1036, (IND):24, (12-267):1037-1292, (DIND):25, (IND):41, (268-511):1293-1536
+TOTAL: 515
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 570/2048 blocks
+Exit status is 1
diff --git a/tests/f_convert_bmap/expect.2 b/tests/f_convert_bmap/expect.2
new file mode 100644
index 0000000..632d411
--- /dev/null
+++ b/tests/f_convert_bmap/expect.2
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 570/2048 blocks
+Exit status is 0
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  1     0 -   511  1025 -  1536    512 
diff --git a/tests/f_convert_bmap/image.gz b/tests/f_convert_bmap/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..7c22532397ba8d42e928f75190dc545cae2140cf
GIT binary patch
literal 3548
zcmeH{TTD|27{|LAMF+@(0Tox+B<ivR0l73*3mPNpq{>AKJy;kpC>$)zXsxs>&77h{
z5d{R1Tf|{+oO3i%(L%x52w{Q@ZBMl=7l%+hhteTCTuLv?;vP1$_wAwI!}sN%d{4js
zKY#y=D@kV;l8$`5%sjNJl`~FyG$XVKkeS>DH}6f}NR0H7XZeLMHZ~n7S%IBv`1#=N
zvthAe6*sSJFDc(vQMvN!_C4jFe<j65!*^OUm={)9=G$@69F1o=F+fw#*9&#jyvB6W
zL}KW^E$$xb{J^bs+dN*RTpr^8kjSR!^SeC_oE_k?>(^gS=<hNObc@YMH>Kvk-p-E5
z35ksKaBDTb(PT!@CVwq0qb~h&i*n<*7OXbTS(15(N<89733W!X1W$_EjVBkiwdO+O
zgdm1$#XPIm+f@lYY^0qqFBCAP$X(HIv%QKlVn5zT?)`;ZVOpN;uzxq3w!?I(<aK$X
zaS!SJe5<2`goNateEzncYj1mM?y%OZ3HI8cvU9NDh)8IB%F@##rq|m2I-85nb<Z2w
zU2pNJ`vVSvg$htSs_DKP485(ZoNIkL`xm<MpHIzr^#yEhcYn0tc1iSaYjk?luhhO5
z90Xc?kWFAOAghA2z*hiVg?NKc04W0&pkFFLh%qk{=rBd}kQi-QLIK4oC}Cc{q-zD*
zP`R6C8NQns<?n~mydY0dt(W*QypVmG06dPE)IW%j((~@|V>qd0P#|_(kwxolh)vP1
z!4D|7w1*Ax2F-m!!v{D?hY_}Bj_Bhv%&`NoNpo3|U_RQefeE7?I)#|DeuRy`+sqVb
zhZToacT$fmp+(`UIb^NwAlA&?)i0^me$S019}PlkxcgO2tDz)Rj%kS-d=8m`$kjMO
z6!SC5aRssfTtZb|mQr*n*h?xr3>3)6@Uzsrhh!CaB~>w;YLUFa>Is<7Q;82Dp_q#3
z<csQ={t_?rJf<eDT62Ug&tzq~S40U_9La2yoxnS+C+pK1rS8~c>oFl5nU*FALaVW-
z#5F6(I+7;8h~wM?EMP?P6ssj5Wk)A#L~23336-^o#f*~pqh(kRQDM!sx4^PST@Y4H
z$d$?>mQGWE>8%_)T$Cn~;8+<UR(9q~qI9L)1bcHnoC0S2?i-o4t{d#wtbKDMepYK!
z><UbF*FFwcpxc%|-kFy%XsC0WSf9P?uV}qL5AcUQmFdYp`an;>8K9}Er5St++^&Mg
z!A0OEqvaYnu4F^;aunnuN*<J&rxAkvO3UQwWiHGAd&`@O7ag;OUt9kyt+v8kM|<{I
zIyy5D-6rU+%SLL#@YyT-x{F^mR@l1kJP-CwGEIen(_^EFs~!aO?fhmP`84O<$bd6b
zozXVSD_9JACTbIs-$@>k$83X+0lqWGS@2!*G{ZnA+mYmpn#n71w;rbdEhKizylA>_
zMx@ViZ17o^Z5wioybK<B(`9y+686({S#NlAG;TtcgFgWhA6R-TGwW2%xanw*RK0hH
z?Vcg(1Qg2i3)j1S%5oZoyZ;f(55(v*iZt4vOKqNzFP<OV(zIHAX4?0IAD46ya1n43
aa1n43a1r?55SY$(e6qN4MIedv8R-w=i-Ai3

literal 0
HcmV?d00001

diff --git a/tests/f_convert_bmap/name b/tests/f_convert_bmap/name
new file mode 100644
index 0000000..67e0d47
--- /dev/null
+++ b/tests/f_convert_bmap/name
@@ -0,0 +1 @@
+convert blockmap file to extents file
diff --git a/tests/f_convert_bmap/script b/tests/f_convert_bmap/script
new file mode 100644
index 0000000..c463e3d
--- /dev/null
+++ b/tests/f_convert_bmap/script
@@ -0,0 +1,119 @@
+if [ "$DESCRIPTION"x != x ]; then
+	test_description="$DESCRIPTION"
+fi
+if [ "$IMAGE"x = x ]; then
+	IMAGE=$test_dir/image.gz
+fi
+
+if [ "$FSCK_OPT"x = x ]; then
+	FSCK_OPT=-yf
+fi
+
+if [ "$SECOND_FSCK_OPT"x = x ]; then
+	SECOND_FSCK_OPT=-yf
+fi
+
+if [ "$OUT1"x = x ]; then
+	OUT1=$test_name.1.log
+fi
+
+if [ "$OUT2"x = x ]; then
+	OUT2=$test_name.2.log
+fi
+
+if [ "$EXP1"x = x ]; then
+	if [ -f $test_dir/expect.1.gz ]; then
+		EXP1=$test_name.1.tmp
+		gunzip < $test_dir/expect.1.gz > $EXP1
+	else
+		EXP1=$test_dir/expect.1
+	fi
+fi
+
+if [ "$EXP2"x = x ]; then
+	if [ -f $test_dir/expect.2.gz ]; then
+		EXP2=$test_name.2.tmp
+		gunzip < $test_dir/expect.2.gz > $EXP2
+	else
+		EXP2=$test_dir/expect.2
+	fi
+fi
+
+if [ "$SKIP_GUNZIP" != "true" ] ; then
+	gunzip < $IMAGE > $TMPFILE
+fi
+
+cp /dev/null $OUT1
+
+eval $PREP_CMD
+
+echo 'stat /a' > $TMPFILE.cmd
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE > $OUT1.new 2>&1
+rm -rf $TMPFILE.cmd
+$TUNE2FS -O extent $TMPFILE >> $OUT1.new 2>&1
+$FSCK $FSCK_OPT -E bmap2extent -N test_filesys $TMPFILE >> $OUT1.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT1.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT1.new >> $OUT1
+rm -f $OUT1.new
+
+if [ "$ONE_PASS_ONLY" != "true" ]; then
+	$FSCK $SECOND_FSCK_OPT -N test_filesys $TMPFILE > $OUT2.new 2>&1 
+	status=$?
+	echo Exit status is $status >> $OUT2.new
+	echo 'ex /a' > $TMPFILE.cmd
+	$DEBUGFS -f $TMPFILE.cmd $TMPFILE >> $OUT2.new 2>&1
+	rm -rf $TMPFILE.cmd
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT2.new > $OUT2
+	rm -f $OUT2.new
+fi
+
+eval $AFTER_CMD
+
+if [ "$SKIP_VERIFY" != "true" ] ; then
+	rm -f $test_name.ok $test_name.failed
+	cmp -s $OUT1 $EXP1
+	status1=$?
+	if [ "$ONE_PASS_ONLY" != "true" ]; then
+		cmp -s $OUT2 $EXP2
+		status2=$?
+	else
+		status2=0
+	fi
+	if [ "$PASS_ZERO" = "true" ]; then
+		cmp -s $test_name.0.log	$test_dir/expect.0
+		status3=$?
+	else
+		status3=0
+	fi
+
+	if [ -z "$test_description" ] ; then
+		description="$test_name"
+	else
+		description="$test_name: $test_description"
+	fi
+
+	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
+		echo "$description: ok"
+		touch $test_name.ok
+	else
+		echo "$description: failed"
+		rm -f $test_name.failed
+		if [ "$PASS_ZERO" = "true" ]; then
+			diff $DIFF_OPTS $test_dir/expect.0 \
+				$test_name.0.log >> $test_name.failed
+		fi
+		diff $DIFF_OPTS $EXP1 $OUT1 >> $test_name.failed
+		if [ "$ONE_PASS_ONLY" != "true" ]; then
+			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
+		fi
+	fi
+	rm -f tmp_expect
+fi
+
+if [ "$SKIP_CLEANUP" != "true" ] ; then
+	unset IMAGE FSCK_OPT SECOND_FSCK_OPT OUT1 OUT2 EXP1 EXP2 
+	unset SKIP_VERIFY SKIP_CLEANUP SKIP_GUNZIP ONE_PASS_ONLY PREP_CMD
+	unset DESCRIPTION SKIP_UNLINK AFTER_CMD PASS_ZERO
+fi
+
diff --git a/tests/f_extent_too_deep/expect.1 b/tests/f_extent_too_deep/expect.1
new file mode 100644
index 0000000..a595482
--- /dev/null
+++ b/tests/f_extent_too_deep/expect.1
@@ -0,0 +1,23 @@
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 7   1/  1     0 -     0    12              1
+ 1/ 7   1/  1     0 -     0    13              1
+ 2/ 7   1/  1     0 -     0    14              1
+ 3/ 7   1/  1     0 -     0    15              1
+ 4/ 7   1/  1     0 -     0    16              1
+ 5/ 7   1/  1     0 -     0    17              1
+ 6/ 7   1/  1     0 -     0     9              1
+ 7/ 7   1/  1     0 -     0    10 -    10      1 
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extent tree could be more shallow (7; could be <= 4)
+Fix? yes
+
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 1
diff --git a/tests/f_extent_too_deep/expect.2 b/tests/f_extent_too_deep/expect.2
new file mode 100644
index 0000000..a1d28b1
--- /dev/null
+++ b/tests/f_extent_too_deep/expect.2
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 0
+debugfs: ex /a
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  1     0 -     0    10 -    10      1 
diff --git a/tests/f_extent_too_deep/image.gz b/tests/f_extent_too_deep/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..0f5adff562c7f45f275a4401344e784b6c61ef0b
GIT binary patch
literal 2592
zcmb2|=3wx?6duCF{PymCf8jtGh7aG@g)R_rT-?mre9>1}CPu>N$ctAhoXss6N_=iF
z5@Jgn)7j0{g?;~U$MjrWSXgN2BJ`haZVz)`*522$TUX9#P_RGs-1*+#-}m|t)ke$R
z5APFT+7Par(yh|6IP<$^TY&yHb=Pd!4HL>YcLz^?KYf{6a)z0HeXpXe&6y>)!{oHZ
z{w4_aEWdmEi{rbce>>ZI-7<e&n#^wgT>k9*+V6{hzqYV7kN<!F`meNSFQ+Q6*V|Y3
z^T*9EtryRSC(q!xs&fB&rR?lflfNCSbM%+z9`NR8Xvm!~b$|P%vOS^yuV3DA=UzC!
zdV2~70|P_Z{%7a+eb~FD@iQX>LxZgT@4xk?M^bd2d}j)Ap48L(^!o=nzNt^b-j@Bn
z(tB&}&(}Bi3E1%+uQ+>K4XAm;YM!#Q|M&Ag|6C8`EjZre0W^eR#(!oY`RqTC0D%K#
zt8|VVNY)>}nWdV0b3e-(v5!&LK$gwTUKeJq&J9t;uwnPp@BiQDA9oI70*csL0e#oU
z@4*RVe|hm||DC?}r7S>pRms2jtmDcsHU76gI%<N<lAHVgc$tlYDp1LV;#slvAMS%y
z_mw*UMaTsa{WFiQJUMmS^mV^a|12?_6#qZx;wRgs7w*6M?d&ss>QjkRvd@oR6O=Ze
zwT(YrEiNVZY2}A3mTiX){VlmTBO>)r|Ir`c-?Qz0^ke$R^}nA_NN3&Vro6gdEo}Aw
zNd;?G)F0CN>c2B%cHsY<=imQ-{{3@@$#3_+;+waWT&=Ht`+1dYa@5urll#5~9k0rL
z`R+&5tNm+I=hrV419@x|jE2By2#kinXb6mkz-S22A_Nlt)-hg8%bdf&puhkC@B%oQ

literal 0
HcmV?d00001

diff --git a/tests/f_extent_too_deep/name b/tests/f_extent_too_deep/name
new file mode 100644
index 0000000..7e8654a
--- /dev/null
+++ b/tests/f_extent_too_deep/name
@@ -0,0 +1 @@
+extent tree is deeper than it needs to be
diff --git a/tests/f_extent_too_deep/script b/tests/f_extent_too_deep/script
new file mode 100644
index 0000000..ee18438
--- /dev/null
+++ b/tests/f_extent_too_deep/script
@@ -0,0 +1,118 @@
+if [ "$DESCRIPTION"x != x ]; then
+	test_description="$DESCRIPTION"
+fi
+if [ "$IMAGE"x = x ]; then
+	IMAGE=$test_dir/image.gz
+fi
+
+if [ "$FSCK_OPT"x = x ]; then
+	FSCK_OPT=-yf
+fi
+
+if [ "$SECOND_FSCK_OPT"x = x ]; then
+	SECOND_FSCK_OPT=-yf
+fi
+
+if [ "$OUT1"x = x ]; then
+	OUT1=$test_name.1.log
+fi
+
+if [ "$OUT2"x = x ]; then
+	OUT2=$test_name.2.log
+fi
+
+if [ "$EXP1"x = x ]; then
+	if [ -f $test_dir/expect.1.gz ]; then
+		EXP1=$test_name.1.tmp
+		gunzip < $test_dir/expect.1.gz > $EXP1
+	else
+		EXP1=$test_dir/expect.1
+	fi
+fi
+
+if [ "$EXP2"x = x ]; then
+	if [ -f $test_dir/expect.2.gz ]; then
+		EXP2=$test_name.2.tmp
+		gunzip < $test_dir/expect.2.gz > $EXP2
+	else
+		EXP2=$test_dir/expect.2
+	fi
+fi
+
+if [ "$SKIP_GUNZIP" != "true" ] ; then
+	gunzip < $IMAGE > $TMPFILE
+fi
+
+cp /dev/null $OUT1
+
+eval $PREP_CMD
+
+echo 'ex /a' > $TMPFILE.cmd
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE > $OUT1.new 2>&1
+rm -rf $TMPFILE.cmd
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE >> $OUT1.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT1.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT1.new >> $OUT1
+rm -f $OUT1.new
+
+if [ "$ONE_PASS_ONLY" != "true" ]; then
+	$FSCK $SECOND_FSCK_OPT -N test_filesys $TMPFILE > $OUT2.new 2>&1 
+	status=$?
+	echo Exit status is $status >> $OUT2.new
+	echo 'ex /a' > $TMPFILE.cmd
+	$DEBUGFS -f $TMPFILE.cmd $TMPFILE >> $OUT2.new 2>&1
+	rm -rf $TMPFILE.cmd
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT2.new > $OUT2
+	rm -f $OUT2.new
+fi
+
+eval $AFTER_CMD
+
+if [ "$SKIP_VERIFY" != "true" ] ; then
+	rm -f $test_name.ok $test_name.failed
+	cmp -s $OUT1 $EXP1
+	status1=$?
+	if [ "$ONE_PASS_ONLY" != "true" ]; then
+		cmp -s $OUT2 $EXP2
+		status2=$?
+	else
+		status2=0
+	fi
+	if [ "$PASS_ZERO" = "true" ]; then
+		cmp -s $test_name.0.log	$test_dir/expect.0
+		status3=$?
+	else
+		status3=0
+	fi
+
+	if [ -z "$test_description" ] ; then
+		description="$test_name"
+	else
+		description="$test_name: $test_description"
+	fi
+
+	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
+		echo "$description: ok"
+		touch $test_name.ok
+	else
+		echo "$description: failed"
+		rm -f $test_name.failed
+		if [ "$PASS_ZERO" = "true" ]; then
+			diff $DIFF_OPTS $test_dir/expect.0 \
+				$test_name.0.log >> $test_name.failed
+		fi
+		diff $DIFF_OPTS $EXP1 $OUT1 >> $test_name.failed
+		if [ "$ONE_PASS_ONLY" != "true" ]; then
+			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
+		fi
+	fi
+	rm -f tmp_expect
+fi
+
+if [ "$SKIP_CLEANUP" != "true" ] ; then
+	unset IMAGE FSCK_OPT SECOND_FSCK_OPT OUT1 OUT2 EXP1 EXP2 
+	unset SKIP_VERIFY SKIP_CLEANUP SKIP_GUNZIP ONE_PASS_ONLY PREP_CMD
+	unset DESCRIPTION SKIP_UNLINK AFTER_CMD PASS_ZERO
+fi
+
diff --git a/tests/f_opt_extent/expect b/tests/f_opt_extent/expect
new file mode 100644
index 0000000..6d4863b
--- /dev/null
+++ b/tests/f_opt_extent/expect
@@ -0,0 +1,55 @@
+tune2fs metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+
+
+Change in FS metadata:
+@@ -10,7 +10,7 @@
+ Inode count:              65536
+ Block count:              524288
+ Reserved block count:     26214
+-Free blocks:              570
++Free blocks:              567
+ Free inodes:              65047
+ First block:              1
+ Block size:               1024
+@@ -47,8 +47,8 @@
+   Block bitmap at 262 (+261)
+   Inode bitmap at 278 (+277)
+   Inode table at 294-549 (+293)
+-  21 free blocks, 535 free inodes, 3 directories, 535 unused inodes
+-  Free blocks: 4414-4434
++  18 free blocks, 535 free inodes, 3 directories, 535 unused inodes
++  Free blocks: 4417-4434
+   Free inodes: 490-1024
+ Group 1: (Blocks 8193-16384) [INODE_UNINIT]
+   Backup superblock at 8193, Group descriptors at 8194-8197
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/f_opt_extent/name b/tests/f_opt_extent/name
new file mode 100644
index 0000000..7d4389c
--- /dev/null
+++ b/tests/f_opt_extent/name
@@ -0,0 +1 @@
+optimize extent tree
diff --git a/tests/f_opt_extent/script b/tests/f_opt_extent/script
new file mode 100644
index 0000000..2da5e91
--- /dev/null
+++ b/tests/f_opt_extent/script
@@ -0,0 +1,64 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit,metadata_csum
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /xyz
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# check
+$FSCK -fyD -N test_filesys $TMPFILE >> $OUT 2>&1
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+unset IMAGE FSCK_OPT OUT EXP CONF
diff --git a/tests/f_opt_extent_ext3/expect b/tests/f_opt_extent_ext3/expect
new file mode 100644
index 0000000..de1fdf6
--- /dev/null
+++ b/tests/f_opt_extent_ext3/expect
@@ -0,0 +1,45 @@
+rebuild extent metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+mke2fs: Operation not supported for inodes containing extents while creating huge files
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+Pass 1: Checking inodes, blocks, and sizes
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+
+
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype sparse_super large_file huge_file dir_nlink
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent sparse_super large_file huge_file dir_nlink
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/f_opt_extent_ext3/name b/tests/f_opt_extent_ext3/name
new file mode 100644
index 0000000..b369685
--- /dev/null
+++ b/tests/f_opt_extent_ext3/name
@@ -0,0 +1 @@
+convert ext3 to extent tree
diff --git a/tests/f_opt_extent_ext3/script b/tests/f_opt_extent_ext3/script
new file mode 100644
index 0000000..931eae7
--- /dev/null
+++ b/tests/f_opt_extent_ext3/script
@@ -0,0 +1,65 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,^extent,huge_file,^flex_bg,^uninit_bg,dir_nlink,^extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,^64bit,^metadata_csum
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		num_hugefiles = 100
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "rebuild extent metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# check
+$FSCK -fyD -N test_filesys -E bmap2extent $TMPFILE >> $OUT 2>&1
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+unset IMAGE FSCK_OPT OUT EXP CONF

