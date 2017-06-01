From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] tests: add new test f_del_dup_quota
Date: Thu, 1 Jun 2017 17:32:58 -0400
Message-ID: <20170601213258.GA3167@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:33197 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdFAVa3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jun 2017 17:30:29 -0400
Received: by mail-qt0-f171.google.com with SMTP id t26so46769101qtg.0
        for <linux-ext4@vger.kernel.org>; Thu, 01 Jun 2017 14:30:28 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a test to validate the changes in commit b0f5fa880c36: "e2fsck:
fix multiply-claimed block quota accounting when deleting files".

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/f_del_dup_quota/expect.1  |  39 +++++++++++++++++++++++++++++++++++++++
 tests/f_del_dup_quota/expect.2  |   7 +++++++
 tests/f_del_dup_quota/image.bz2 | Bin 0 -> 1472 bytes
 tests/f_del_dup_quota/name      |   1 +
 tests/f_del_dup_quota/script    |  34 ++++++++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+)
 create mode 100644 tests/f_del_dup_quota/expect.1
 create mode 100644 tests/f_del_dup_quota/expect.2
 create mode 100644 tests/f_del_dup_quota/image.bz2
 create mode 100644 tests/f_del_dup_quota/name
 create mode 100644 tests/f_del_dup_quota/script

diff --git a/tests/f_del_dup_quota/expect.1 b/tests/f_del_dup_quota/expect.1
new file mode 100644
index 0000000..71b7440
--- /dev/null
+++ b/tests/f_del_dup_quota/expect.1
@@ -0,0 +1,39 @@
+Pass 1: Checking inodes, blocks, and sizes
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 12: 8129
+Multiply-claimed block(s) in inode 13: 8129
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 2 inodes containing multiply-claimed blocks.)
+
+File /testfile1 (inode #12, mod time Wed May 24 23:10:38 2017) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/testfile2 (inode #13, mod time Wed May 24 23:10:45 2017)
+Clone multiply-claimed blocks<y>? no
+Delete file<y>? yes
+File /testfile2 (inode #13, mod time Wed May 24 23:10:45 2017) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/testfile1 (inode #12, mod time Wed May 24 23:10:38 2017)
+Multiply-claimed blocks already reassigned or cloned.
+
+Pass 2: Checking directory structure
+Entry 'testfile1' in / (2) has deleted/unused inode 12.  Clear<y>? yes
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -1374
+Fix<y>? yes
+Free blocks count wrong for group #0 (6815, counted=6816).
+Fix<y>? yes
+Free blocks count wrong (6815, counted=6816).
+Fix<y>? yes
+[QUOTA WARNING] Usage inconsistent for ID 0:actual (15360, 3) != expected (17408, 4)
+Update quota info for quota type 0<y>? yes
+[QUOTA WARNING] Usage inconsistent for ID 0:actual (15360, 3) != expected (17408, 4)
+Update quota info for quota type 1<y>? yes
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/2048 files (33.3% non-contiguous), 1376/8192 blocks
+Exit status is 0
diff --git a/tests/f_del_dup_quota/expect.2 b/tests/f_del_dup_quota/expect.2
new file mode 100644
index 0000000..14f99b8
--- /dev/null
+++ b/tests/f_del_dup_quota/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/2048 files (25.0% non-contiguous), 1376/8192 blocks
+Exit status is 0
diff --git a/tests/f_del_dup_quota/image.bz2 b/tests/f_del_dup_quota/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..fc91e2a18239bcc30ef32551efd08e397dd10624
GIT binary patch
literal 1472
zcmV;x1wZ;iT4*^jL0KkKS!PJip#T8T|NsC0|NsC0|Ns3SS^xik-<|)<ig}TyuRr@}
za^b$q{vXf<UdpAA003o;ft55#kU^78FdB?T36Yc3!edAcrka=oL81&35W+Og6A_~b
z(7+IA#M4bMYG}!$0%8P|K{83|dQ66oNYEMpXa<^S0MIlZnm`7C14BRqKmZy5&>8>(
zKs`o{0QC?68U}%rKn($*iKa}3fEoY*&=?TWiIXN12r>ge(?*R9OpJig216hO00x1e
zWY7aZXkuxTA)p3;05k>!G-71Qgu)Df&@|DbLlYw)Gy#yv07Q~PDdH!RWQVmHOrDx)
zrYQ9urY28KP31K5rW4amBNJ$9Hl}4flhoQkU>X6VNHL_sZ5lF0YH5UNr<B<}QtT&q
z;upf`;EsYjZRnVJ<3{}V@WL3N)3a2VglV!mogXuVQUoFrGKigEnFPUP2?a4(?SO?a
z-y+m%ts%oF-%%*4IF34=3<$*G1nE$>>QdYfyfK7?)Kl|L-S=DN;z(ja+jtZgMnVu6
zrhii`j&v{#1f{Vg8WtQPt7zdQlRP<o`qaC-(Mq5op-B8VK?A}CR|FJQ13?s36+Aei
zprV$DOIX(tUcgumc_O~>lR+vS$q89j#%`Wtu&ZjTL{`N}PdL=0xcu21V}iLS!O{4W
z)NcY<`6etJ5lgUw|8*F|469|_$j}=7DM8e1FC~Ljd}vL6=`%AkZ-*kRfhfrxc~@Xr
zODZzyOeAJzrqg{3)`T%o135Z|X-`kWP*Aj@qwIEh{iVh1_TiYh(lDi_r)N;CGDw*^
z5P{sOK&ncfuY)3OSjClLc;;oe9eQRoF~3duM_a$#Ixnwy6Q(c}LKqnA2%4G77rA>3
z<!B40Qbhzn05eXgdMhe4Izo^i{Si1E419}$bIcGmEH>;#M$k{Fk<XD6?zv6=PvbjH
z)0*K10oFXzjd7G^7O@~cixK)na#f4gF#|R!FoKXl004s*0eC3{<(P%U04%`^gO+NW
z!)TN?L3SepgAhLf7{PT!yf8<11so;{DP|pk6)>18A^-)8vCBUH_R^JFbF(!JZ=hco
z#s|bgu-r3%amxms2#4r6<`4m&G17oNUKw9(f@`3e<dK|Te$F;CcoQZrC|EYFgTXY1
zAy4>x2J-%iFx*u*_dgH1Qh|sQO#=i6LTXy(8T+}1eYkmY^OpHfl<%M7UJQ~vofQIT
z=%%RSSuZgSK`JgSEeW$d2B^A-Vba+3DQ~h4K^n`B0t5A##6QPQryAvVFbs&NLPbyO
zvahqjW`L9oqLVX;LWH?4Ee00u+x%uAaUBf~v4ce2&+nVzwrpCvXg>7hy`TFtOR9E|
z){*$;DHqgY<PkKlh$xuJVB*8ja!NLxAXPLK(vf`jLVu`i$;a1gZL6MH{Wj&eoH~Tz
z8=c_HQtrGVh-jMmMgVsPKJd1=hd_R^xegQaCA9uDr1iUsaYJb7tY}*LES)3+WdQTB
z56*q3ie4U+RxsbNQQF%Nrot>7sRJa-DB(vTitw&4nRgvlbtt1p8ER8eT(%_AI;s@K
zVv1EsTv=IAFL`4waYj^D9_i1rMV}>P(J-1WB(;b`5pVhsCaTGasTEYpZM+`1ygEpU
zHIGn%W3N^b+mJ$#*s<((Et5R#auFg|FbS*%uw^e~WxWUD7CEFXSa<>c1qahyks*-w
z6&!kkfu51*pYWIpPzXkg+dnmN0huGEuAbu45SZFO4O!26tLyd1*-)_!tdjv_=h-)>
z#R6pX!a#EaQh@P3*mMkf*;$_p$Y~yU6k__sD%#eB%0}mV#&7)Zt({?te8&M#{jgGp
z(R5d~`begC12xsZkmm(2+<uajtQ*^9V}%eQ*zc`)xkW$#4C7XYcU*l1m-u@$KAb~1
aV}?L?q*7`-3LW$R#oUoj6eJmvGpIm75t76J

literal 0
HcmV?d00001

diff --git a/tests/f_del_dup_quota/name b/tests/f_del_dup_quota/name
new file mode 100644
index 0000000..8b29fd4
--- /dev/null
+++ b/tests/f_del_dup_quota/name
@@ -0,0 +1 @@
+delete file containing multiply claimed blocks with quota
diff --git a/tests/f_del_dup_quota/script b/tests/f_del_dup_quota/script
new file mode 100644
index 0000000..5480c3f
--- /dev/null
+++ b/tests/f_del_dup_quota/script
@@ -0,0 +1,34 @@
+#!/bin/bash
+
+IMAGE=$test_dir/image.bz2
+
+bzip2 -d < $IMAGE > $TMPFILE
+
+# Run fsck to fix the multiply-claimed block breakage
+FSCK_OPT=-f
+EXP1=$test_dir/expect.1
+OUT1=$test_name.1.log
+
+echo "nyyyyyyy" | E2FSCK_FORCE_INTERACTIVE=y $FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT1
+echo "Exit status is $?" >> $OUT1
+
+# Run a second time to verify that fsck completely repaired everything in
+# the first run, including quota corrections
+FSCK_OPT=-fn
+EXP2=$test_dir/expect.2
+OUT2=$test_name.2.log
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT2
+echo "Exit status is $?" >> $OUT2
+
+# Figure out what happened
+rm -f $test_name.failed $test_name.ok
+if cmp -s $EXP1 $OUT1 && cmp -s $EXP2 $OUT2; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP1 $OUT1 >> $test_name.failed
+	diff -u $EXP2 $OUT2 >> $test_name.failed
+fi
+unset EXP1 OUT1 EXP2 OUT2 FSCK_OPT IMAGE
-- 
2.1.4
