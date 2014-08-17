From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/27] libext2fs: write_journal_inode should check iterate
 return value
Date: Sun, 17 Aug 2014 10:23:45 -0700
Message-ID: <20140817172345.GC11105@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaHQRXv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2014 13:23:51 -0400
Content-Disposition: inline
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When creating a journal inode, check the return value from
block_iterate3() because otherwise we fail to capture errors such as
being unable to allocate an extent tree block, which leads to e2fsck
(re)creating broken journals.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/mkjournal.c              |    2 ++
 tests/f_jnl_etb_alloc_fail/expect.1 |   31 +++++++++++++++++++++++++++++++
 tests/f_jnl_etb_alloc_fail/expect.2 |   20 ++++++++++++++++++++
 tests/f_jnl_etb_alloc_fail/image.gz |  Bin
 tests/f_jnl_etb_alloc_fail/name     |    1 +
 5 files changed, 54 insertions(+)
 create mode 100644 tests/f_jnl_etb_alloc_fail/expect.1
 create mode 100644 tests/f_jnl_etb_alloc_fail/expect.2
 create mode 100644 tests/f_jnl_etb_alloc_fail/image.gz
 create mode 100644 tests/f_jnl_etb_alloc_fail/name

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index e2e9ce7..de30a7d 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -371,6 +371,8 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 
 	retval = ext2fs_block_iterate3(fs, journal_ino, BLOCK_FLAG_APPEND,
 				       0, mkjournal_proc, &es);
+	if (retval)
+		goto errout;
 	if (es.err) {
 		retval = es.err;
 		goto errout;
diff --git a/tests/f_jnl_etb_alloc_fail/expect.1 b/tests/f_jnl_etb_alloc_fail/expect.1
new file mode 100644
index 0000000..8f4ebbb
--- /dev/null
+++ b/tests/f_jnl_etb_alloc_fail/expect.1
@@ -0,0 +1,31 @@
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
+Block bitmap differences:  -(32--33) -(35--49) -(83--511) -(513--1087) -1089
+Fix? yes
+
+Free blocks count wrong for group #0 (0, counted=1022).
+Fix? yes
+
+Free blocks count wrong (0, counted=1022).
+Fix? yes
+
+Recreate journal? yes
+
+Creating journal (1024 blocks): Could not allocate block in ext2 filesystem: while trying to create journal
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 2048/2048 blocks
+Exit status is 1
diff --git a/tests/f_jnl_etb_alloc_fail/expect.2 b/tests/f_jnl_etb_alloc_fail/expect.2
new file mode 100644
index 0000000..69859dd
--- /dev/null
+++ b/tests/f_jnl_etb_alloc_fail/expect.2
@@ -0,0 +1,20 @@
+Pass 1: Checking inodes, blocks, and sizes
+Journal inode is not in use, but contains data.  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(32--33) -(35--49) -(83--511) -(513--1087) -1089
+Fix? yes
+
+Free blocks count wrong for group #0 (0, counted=1022).
+Fix? yes
+
+Free blocks count wrong (0, counted=1022).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 1026/2048 blocks
+Exit status is 1
diff --git a/tests/f_jnl_etb_alloc_fail/image.gz b/tests/f_jnl_etb_alloc_fail/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..4cf2dbf400ce2d113b886919a4448176b3999956
GIT binary patch
literal 3450
zcmeIwX;6}R90zd9HfzhQX*(uO(q@(#O~N!yBf4v}!VS&R6pbx!v9vT5pPEW7uNv=M
zCG*IGXQ^Dp3&{>lNlDEk4XKb*Nx=hAc>X)RbY@@gD}Uda-^};zXTIp<6(}3g1Zk;(
zQgAxJw0|pV!oIOm>0Ak)bd+sNx@z6Be5kxRch)!AG!B>6<hpx#!Go5vbH92YTDEV8
zYaGt{_OgsS>GhJY#!L4(T#uQ+J)860Zo2YX@V$*+NP&L{hw|X#-4;hn6~XZYl`!vf
zL9eXiM=W(1I^krFa<|J5OS>CheLjr)zTMK4za7>DHTTYH4p*&vt-eOt8O+SVN*(#5
zmK&|#wvmI(KfIN{Pt8kA#<Y5A68<JUZdQN&ILHxwD5#M1xkQ8r@F$!nSzZ(xcHF0V
zZcMJPueZ-guO7Q3V~W$+NtZ`yUdH&+>EL6k;CIw`EY}H_tuVK32!niky90D>4UDW>
z)x6m_{)W&uWj&7jV32Itd+W;V2z_QPYT@a?E`zMB=AkmepEW(^pfDeCttvQB044In
zWw8E-h+s<;=%Qm3EcuJIh$sIg(KbJP+Z0>@K)G}pUA{ti%uqpif*AbQL&XkG8h1h)
zFmjt|xe)5U{3?CG($$F9+Gk~u)m5RvO1x6fxK-%AnlhyXAEqV5rXBpW&s0Inhn+J@
z49bc^2ate3gv{y$?4Wr%{;G~_d5N?I)@sQ>nSMfvci1fgF)8a!7@lF<JF_IM&XY$<
zwG3NAZi8#ANeZ~l_IoayB4OffY$=IsoA%Iz3hX}*QHGJa95vm)Q49t9mEe_y;FRze
zrzWEzw0Ct=kCx9QB-^968m(UiAICVp>DL%b#r%d$z;p046OP=BAm}GXJ{=bW?GTz-
zx`NIr44@LuM9tB*0nW@cxeY|c>REPx?lZnw4aRJRz^K>G%k;Y-C1YHK>xk@P>HAgt
zyJMJ_gqaqrc)Zk72HU5equ9@6p09gomY&*v>aVmfxi{;guQgq#%I1pYmd0yfy;J9x
zyr3|)ZEK%^bRbW4BbYHR7Vtdics9Xab47hM+k3UXCQC#gW=*@(;@}<e@NCEUyJ!se
z>=&ZINq*aoHZN1qE}R^y6GPSm29^2RIF>-yh9X@qorDzmp?kK#_wIkg2;-hj-_^sB
z2+`33&uXc><0p<QRM#I=PUYfPKIacYbl^TWNf1Hd2z?SfX{d}xh!j5!A84oENHaRY
zk{j(ITR@>wenE)%D<jag-v<wD1}q+W`C*n?T9JMRp;So|#yZs7frnN{X0!;@P<53W
zsu~5FV+i(i_0vPM5jg0DKNtZEXS%T6O6{eTxMU+1+@j6$m(S#tOioIdNilY$KUVLa
zQf$r{RvmoLj9NWLt~O_m*&m7DC6c>d<kyL!%>vmTlko8eR#sU1?3Xh!;!(S(!hR2{
zizn0j59i+Rd1SK3coQ*=^~1;;vZaYzifW+NJSS2IoFf@%h)v6sP+8nLpJ8^~^yi-W
zhzRQMX#daeK9YH87xBQH-LT=gU8!6;gXbA&!is6q4AA%l2jH&SD4cS7+2xtLIbPin
zHDhL)G)Lc%2&8+@Uw<BearCCZpOl)x4AeYB&-snoDG|}nL_VH<)V-oo6I!c4;ly_m
zSbp=x!Pz`fTfxM%ze-YE?02cCS9bK7S1btkK^QJtP739f>a-aSOufk<nPdSe6>7@1
zh(ltYvh@yv3N_ZFuTeSGYU6g^v7E4uV#RIym;xit#eJ(uWSRN5ua9@FQH=mGs0cxr
z=SINZV+eYUo1Q3eQ)Gz2lFDv`2Y%*`j-w;EwTE0y!T>BFUY>+%EC6e#8iYSlK#H=n
zwIZkkL`iyfzxH2(nlIAlfS)ncLRzRi^Yiz$M1+jc6`lm7D&d{W&3hpX6VRJnaz&#e
zH&6o_xtzeJO`;xSI`Ld6sOD+uS$wdDI<qge?=_X1?W1cOHdr`>#kMH0D6lB7D6lB7
UDDZy@+!CnJ_LxKFDAYF8zeHzNwEzGB

literal 0
HcmV?d00001

diff --git a/tests/f_jnl_etb_alloc_fail/name b/tests/f_jnl_etb_alloc_fail/name
new file mode 100644
index 0000000..7651fdc
--- /dev/null
+++ b/tests/f_jnl_etb_alloc_fail/name
@@ -0,0 +1 @@
+can't allocate extent tree block while recreating journal
