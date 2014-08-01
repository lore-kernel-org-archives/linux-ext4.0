From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/19] tests: add regression tests for superblocks with bad
 checksums
Date: Fri, 01 Aug 2014 11:13:36 -0700
Message-ID: <20140801181336.12496.46953.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36888 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHASNk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:40 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add regression tests to examine how e2fsck deals with random
superblock corruption such as obviously wrong fields and the checksum
itself being incorrect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_super_bad_csum/expect.1  |   13 +++++++++++++
 tests/f_super_bad_csum/expect.2  |    7 +++++++
 tests/f_super_bad_csum/image.bz2 |  Bin
 tests/f_super_bad_csum/name      |    1 +
 tests/f_super_bad_csum/script    |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 54 insertions(+)
 create mode 100644 tests/f_super_bad_csum/expect.1
 create mode 100644 tests/f_super_bad_csum/expect.2
 create mode 100644 tests/f_super_bad_csum/image.bz2
 create mode 100644 tests/f_super_bad_csum/name
 create mode 100755 tests/f_super_bad_csum/script

diff --git a/tests/f_super_bad_csum/expect.1 b/tests/f_super_bad_csum/expect.1
new file mode 100644
index 0000000..25ced5c
--- /dev/null
+++ b/tests/f_super_bad_csum/expect.1
@@ -0,0 +1,13 @@
+ext2fs_open2: Superblock checksum does not match superblock
+../e2fsck/e2fsck: Superblock invalid, trying backup blocks...
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Inode bitmap differences: Group 1 inode bitmap does not match checksum.
+FIXED.
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/1024 files (0.0% non-contiguous), 1557/16384 blocks
+Exit status is 0
diff --git a/tests/f_super_bad_csum/expect.2 b/tests/f_super_bad_csum/expect.2
new file mode 100644
index 0000000..dd20919
--- /dev/null
+++ b/tests/f_super_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/1024 files (0.0% non-contiguous), 1557/16384 blocks
+Exit status is 0
diff --git a/tests/f_super_bad_csum/image.bz2 b/tests/f_super_bad_csum/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..cd80d4b837fd0e966595e70d4bb0854b8b63a78b
GIT binary patch
literal 1181
zcmZ>Y%CIzaj8qGbG&$qO$-t0W{~rU~v2+!vn5cJQvuwM{xqY@5Sn7D6eNd27s1g;G
zG&H%mOmO0|9?s6m$^s`+F1}FXIM61nHq$79!N)Db*=JUQ56k8MUtJw~W*SN{Ge}MH
zUBbY?_{xNrts&!t5d$1#fLXjO{$GPu<@&&dQ5jq-m-PobE;zyL?B?UZ);NKe&6h{O
z$b=zLO3LKo0uzP|Heacf%MKUVdKnlvrgRzwA6s!GagoX8REaB<raTTAQj81O8W@1e
zdVEbTNJ&-onk2E!GRffOHL98=w|sKY?nTd2FVB&=G2`3JBcZ7~_09$a9f+MOD#jg>
zZLq%H&hN|D(@j@i_Pq2JoHFIin{Q>N$HFG%*Y97o=tE~h!$lw7XKJ4gtxIW|<8$`;
zo_lp&;d57YXvpWdI7D}>(3<u@X;sJ09|}z3maU<Sw3ds8YrACYc`5Ex%zwIl&YE?f
z9fQ)9#4lWUu_cPrfSXVKEW1+Ub93is2l7kH%B?;WeC&{m>uXU}y3XIf{=~#3;rt&s
z6%x9eCoi5jZHZpel(VL`j*IjC*qIq#zM8da=Lgn^-%+)!1rF<-+72B%b?(x&TlXG4
z`K6L6bT@X{p1u40>l+rc`WOY=h{$Swl=L|Hi4lX>r%hLwjm<6N>e~9I%{uEFn_K9A
zxYIdXX5Fs&g4^tpgTiu>H+FF?V34~gClb-|IABq+P^(-~=TZU5ljjsBcuZjFWEK~m
z(QxF!KD#O|1{EO&P6ig1hGR#bF|aJ?(s{<x0Th4$mIkF>;Tb{-9OnX;{|5?bC>3+6
zr24X~=$_`rx=E|7h1HdT;YGKJEt6StN>gOx8s(6n7t@3^rl)LX;d(GdK`C5N%E95L
ztFW3vD3gN#3j^2RTdbSZ#Qa_@xD^{55vgA|>D8mhuMJOeMmlv)HU7f;F=2D?^j=pt
zRp-NJo@idUJ8RQ5bFL?MkC?M|rLKL&we5}Bab=%tro2C8_v~xFFZ5z|6GPlNrl~Vn
z)~v6Vej}69svYhBDo|gkI)yp+z`}hB+22*gpQ~>6bp9daAr4IQ3$}Z8NN-|Gh~=2>
z^rAEJ_?&h7B_Fq6PP|fDUiC!N>#1hUQO#STO;eU?X=-`}U-Al?az=fJ-~*P2f_Cgv
z7BMg_;M~Bu02mO=msmSQKnxzAkd3aB#GS-8#B!VHvh%S8v8~GW^mJlM6G%#)9L#WZ
z#<mx-DJJh`EIjY>%_GW4RW`-l!r|fMXhRQq^~=sqXEVh`+pH$BdtF#Cqm^BxNhXtF
zD_fhSvtPv(=a~vGd%lXZUc9ii(CLq&31f=J)Lg~ePX8oQO!hnoxMcOIwZNRml1Yq1
z%8awv+Q{aP$*-tHPrg^`GY<W1|J%C3i05McE}b^dhZoiyvtNFsU=910g)Q}}itHCG
z8g4euvfNsj9w}kyqbbnHx#G~y6XCZ~PJe4*X#KH-;q$U@;_Z5YKC`bZuyzg$csS8j
hgn?P_V=I@(%tyK$eZ1yBZN&cn7cX+P2$%pWjsRs0<w^hm

literal 0
HcmV?d00001

diff --git a/tests/f_super_bad_csum/name b/tests/f_super_bad_csum/name
new file mode 100644
index 0000000..745562f
--- /dev/null
+++ b/tests/f_super_bad_csum/name
@@ -0,0 +1 @@
+bad csum in superblock (metadata_csum)
diff --git a/tests/f_super_bad_csum/script b/tests/f_super_bad_csum/script
new file mode 100755
index 0000000..cfd4189
--- /dev/null
+++ b/tests/f_super_bad_csum/script
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+FSCK_OPT=-fy
+IMAGE=$test_dir/image.bz2
+
+bzip2 -d < $IMAGE > $TMPFILE
+#e2label $TMPFILE test_filesys
+
+# Run fsck to fix things?
+EXP1=$test_dir/expect.1
+OUT1=$test_name.1.log
+rm -rf $test_name.failed $test_name.ok
+
+$FSCK $FSCK_OPT $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT1
+echo "Exit status is $?" >> $OUT1
+
+# Run a second time
+EXP2=$test_dir/expect.2
+OUT2=$test_name.2.log
+
+$FSCK $FSCK_OPT $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT2
+echo "Exit status is $?" >> $OUT2
+
+# Figure out what happened
+if cmp -s $EXP1 $OUT1 && cmp -s $EXP2 $OUT2; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP1 $OUT1 >> $test_name.failed
+	diff -u $EXP2 $OUT2 >> $test_name.failed
+fi
+unset EXP1 OUT1 EXP2 OUT2 FSCK_OPT IMAGE

