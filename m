From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/19] tests: add regression tests for MMP blocks with bad
 checksums
Date: Fri, 01 Aug 2014 11:13:29 -0700
Message-ID: <20140801181329.12496.49234.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36827 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbaHASNe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:34 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add regression tests to examine how e2fsck deals with MMP blocks with
(a) a bad magic number; and (b) an incorrect checksum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c                  |    4 +++-
 tests/m_mmp_bad_csum/expect    |    9 +++++++++
 tests/m_mmp_bad_csum/image.gz  |  Bin
 tests/m_mmp_bad_csum/name      |    1 +
 tests/m_mmp_bad_csum/script    |   30 ++++++++++++++++++++++++++++++
 tests/m_mmp_bad_magic/.log     |    9 +++++++++
 tests/m_mmp_bad_magic/expect   |    9 +++++++++
 tests/m_mmp_bad_magic/image.gz |  Bin
 tests/m_mmp_bad_magic/name     |    1 +
 tests/m_mmp_bad_magic/script   |   30 ++++++++++++++++++++++++++++++
 10 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 tests/m_mmp_bad_csum/expect
 create mode 100644 tests/m_mmp_bad_csum/image.gz
 create mode 100644 tests/m_mmp_bad_csum/name
 create mode 100644 tests/m_mmp_bad_csum/script
 create mode 100644 tests/m_mmp_bad_magic/.log
 create mode 100644 tests/m_mmp_bad_magic/expect
 create mode 100644 tests/m_mmp_bad_magic/image.gz
 create mode 100644 tests/m_mmp_bad_magic/name
 create mode 100644 tests/m_mmp_bad_magic/script

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index d883c9e..f71afbc 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1166,7 +1166,9 @@ check_error:
 			ext2fs_mmp_clear(fs);
 			retval = 0;
 		}
-	}
+	} else
+		com_err(ctx->program_name, retval, "%s",
+			_("while reading MMP block"));
 	return retval;
 }
 
diff --git a/tests/m_mmp_bad_csum/expect b/tests/m_mmp_bad_csum/expect
new file mode 100644
index 0000000..e15e7b4
--- /dev/null
+++ b/tests/m_mmp_bad_csum/expect
@@ -0,0 +1,9 @@
+Superblock MMP block checksum does not match MMP block.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 0
diff --git a/tests/m_mmp_bad_csum/image.gz b/tests/m_mmp_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c896ff60dbbdf68a566007262c54a99b0b912fde
GIT binary patch
literal 2594
zcmb2|=3qEtbUm1f`R!fX4B<cqh6m->JGQP}+o9CR^Xh@pHia(x6(L^Y2jyR^P-qG}
z5_V9{qj05&pdgo(hLr|~)((rV2LY_%?Bb#>EaHJ(&UclLo$e2E(#}}Ab?1BT_j~tD
z-~Hs??%l_$rz>+ZdaRyUB+@>?cT%TDi_==0b*-nEl(#+=S}Yy^wKYKNYi*~~7wve_
ztCy}trDadD$>w^PqSkWq{89d$%lD?|&A+?z_0y{dXa7ug{(1PXI$IwvFaO!l*zJ4j
zw<uL7`hUCj@1cM4^|F{Ar}B*M<=0-{Kc(8AHCu=4Z15>#&xcm+a-ZK6?pfuo&EW8B
zO8frPlQ(QL`lqk*(`RYT=a27`TLWrrFISZp>&s=>GB7YiNO*Z0J&eArbB!Iy`&a$+
z{r}reBIRwb_A=xu_E}r6{{CU#+l)?jKmMoJzt7j3WA!SE6R1$fBv)~db<N^h-|V}8
z{wKSa{^JLVnjHJHzheE5J%9dWw|@ij8{FppUoW$>=I$SPAn(k7Mxaou{eSxn<@p{?
zFQ5O9=YMuS=f<{|@9%HV{t&Y7^@%g<^)G$-5U=t7-|{e^4kEyUiBrU`KLr`w_Lz%<
z2o1QD)F+iZUcGOA;yOFy>hyoFZ8utXPV)`_zwAPc=jy`KDI!L}*SfX5&zxJ{uK488
zho!&%PMDVb?&0Z@`Nex%ORn!Pt>5+fzuK(-xe}K1T^`@P{G~o{?ep13|E)cJJ^cHF
zl%4;pi|p6_y??3prQN^kPcPT~pZfOme%{AVKl*<!c|6}@&A+oh)PuP<7rqPl`6vJX
qjBB4kAvOv|Ltr!nMnhmU1V%$(Gz4f70uA-=*?&|mS7u;PU;qF)f;ad8

literal 0
HcmV?d00001

diff --git a/tests/m_mmp_bad_csum/name b/tests/m_mmp_bad_csum/name
new file mode 100644
index 0000000..61c31d4
--- /dev/null
+++ b/tests/m_mmp_bad_csum/name
@@ -0,0 +1 @@
+mmp with bad csum (metadata_csum)
diff --git a/tests/m_mmp_bad_csum/script b/tests/m_mmp_bad_csum/script
new file mode 100644
index 0000000..d101294
--- /dev/null
+++ b/tests/m_mmp_bad_csum/script
@@ -0,0 +1,30 @@
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
+
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? = 0 ]; then
+	rm -f $TMPFILE
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
+	return 0
+fi
+gzip -dc < $test_dir/image.gz > $TMPFILE
+
+OUT=$test_dir.log
+EXP=$test_dir/expect
+$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
+echo Exit status is $? >> $OUT
+
+rm -f $TMPFILE
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
+unset OUT EXP
diff --git a/tests/m_mmp_bad_magic/.log b/tests/m_mmp_bad_magic/.log
new file mode 100644
index 0000000..b5dfb89
--- /dev/null
+++ b/tests/m_mmp_bad_magic/.log
@@ -0,0 +1,9 @@
+Superblock has invalid MMP magic.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 0
diff --git a/tests/m_mmp_bad_magic/expect b/tests/m_mmp_bad_magic/expect
new file mode 100644
index 0000000..b5dfb89
--- /dev/null
+++ b/tests/m_mmp_bad_magic/expect
@@ -0,0 +1,9 @@
+Superblock has invalid MMP magic.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 19/512 blocks
+Exit status is 0
diff --git a/tests/m_mmp_bad_magic/image.gz b/tests/m_mmp_bad_magic/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..2d57fbf5fa2ee4939a41f00ea1d3d0b096346d3e
GIT binary patch
literal 2597
zcmb2|=3rQDbUm1f`R!d_50O9yh6m=4+m<a8bmfp+<vjg_Ls#7jgCpJvta98cFWNOk
zi>6P|YjbfCxVmtKvtxjxtd-k^g-z>Z_k;)tmP~ZAx{<p$_uKLbN1K9-%J=10zJFV7
zz1jNx*)xy#-b^%SQCREN9Vp`zJ;}#S@rl;cLe(i^5^Hs)OT4bRD(<xK!gouqi|1=1
zLp*0|&D8b$v`4Sy@l1hbc2DiM*uS={e0`;F?&EN_ycB-^^xyq5)`b-nDL>+`mVW;2
ze){&gcX_*amOpuXboK4?t_!tIj$eLly8YH<_np3Ct!<f4XD%sN>)c=Y%_8pRT2Tgt
z+OEU*Q#~VsrT#ykRI@B(-^&-<yLV2g|GWC@yDj_otpCcuz>turp>wWfed*>1c_8n{
zd(r*>^Z5er2%h@RWYTW&?uEwv!@sv}HMBD{nG;){qG4WfVyh5PVMN9(=Zfp~ds9n;
zul}iDwAJQ6J5V$$`QQBgv+DzE{w)oy2J#)&p8Fr(6SpJnA3u=y>_3n=aA^L2@p|Th
z`275b$N$Ikr}(eCzw6`s`{joZB$ORK7{7m?$K}KIi9eVAVvk}3swWH@qJmbeKgA4G
zXnI^!fUtU;D*hdbc)og{{KNR#wA*iguK)gIol2Bd@ZZ-?&YHT%dxHZ{_(bb#=^9$g
z%eP&Sb2}IQzI}^KG5_()wdcM*xfJ_<+1{7y{?E?%w>|NTkC5%#SquMnYuVn{`IaBL
zZ`ZEh%e(&GpIn{!_W!gup5H&-pX*!xS3iID|J;fwng1ncP5yNrUUk2x-e{_U^m2ZY
s^Z%!HZkY!Pu2C==0;3@?8UmvsFd71*AwZK5IJ5Wt>VIch85k5800I{>HUIzs

literal 0
HcmV?d00001

diff --git a/tests/m_mmp_bad_magic/name b/tests/m_mmp_bad_magic/name
new file mode 100644
index 0000000..15a2d4d
--- /dev/null
+++ b/tests/m_mmp_bad_magic/name
@@ -0,0 +1 @@
+mmp with bad magic (metadata_csum)
diff --git a/tests/m_mmp_bad_magic/script b/tests/m_mmp_bad_magic/script
new file mode 100644
index 0000000..d101294
--- /dev/null
+++ b/tests/m_mmp_bad_magic/script
@@ -0,0 +1,30 @@
+# use current directory instead of /tmp becase tmpfs doesn't support DIO
+rm -f $TMPFILE
+TMPFILE=$(mktemp ./tmp-$test_name.XXXXXX)
+
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? = 0 ]; then
+	rm -f $TMPFILE
+	echo "$test_name: $test_description: skipped for tmpfs (no O_DIRECT)"
+	return 0
+fi
+gzip -dc < $test_dir/image.gz > $TMPFILE
+
+OUT=$test_dir.log
+EXP=$test_dir/expect
+$FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
+echo Exit status is $? >> $OUT
+
+rm -f $TMPFILE
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
+unset OUT EXP

