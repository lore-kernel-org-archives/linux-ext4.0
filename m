From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/24] libext2fs: fix bounds check of the bitmap test range
 in get_free_blocks2
Date: Fri, 18 Jul 2014 15:53:59 -0700
Message-ID: <20140718225359.31374.84989.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33226 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbaGRWyF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:54:05 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the loop in ext2fs_get_free_blocks2, we ask the bitmap if there's a
range of free blocks starting at "b" and ending at "b + num - 1".
That quantity is the number of the last block in the range.  Since
ext2fs_blocks_count() returns the number of blocks and not the number
of the last block in the filesystem, the check is incorrect.

Put in a shortcut to exit the loop if finish > start, because in that
case it's obvious that we don't need to reset to the beginning of the
FS to continue the search for blocks.  This is needed to terminate the
loop because the broken test meant that b could get large enough to
equal finish, which would end the while loop.

The attached testcase shows that with the off by one error, it is
possible to throw e2fsck into an infinite loop while it tries to
find space for the inode table even though there's no space for one.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc.c            |    5 ++++-
 tests/f_boundscheck/expect.1  |   25 +++++++++++++++++++++++++
 tests/f_boundscheck/expect.2  |   25 +++++++++++++++++++++++++
 tests/f_boundscheck/image.bz2 |  Bin
 tests/f_boundscheck/name      |    1 +
 tests/f_boundscheck/script    |   32 ++++++++++++++++++++++++++++++++
 6 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_boundscheck/expect.1
 create mode 100644 tests/f_boundscheck/expect.2
 create mode 100644 tests/f_boundscheck/image.bz2
 create mode 100644 tests/f_boundscheck/name
 create mode 100755 tests/f_boundscheck/script


diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index b36d288..578fd7f 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -255,8 +255,11 @@ errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
 	b &= ~(c_ratio - 1);
 	finish &= ~(c_ratio -1);
 	do {
-		if (b+num-1 > ext2fs_blocks_count(fs->super))
+		if (b + num - 1 >= ext2fs_blocks_count(fs->super)) {
+			if (finish > start)
+				return EXT2_ET_BLOCK_ALLOC_FAIL;
 			b = fs->super->s_first_data_block;
+		}
 		if (ext2fs_fast_test_block_bitmap_range2(map, b, num)) {
 			*ret = b;
 			return 0;
diff --git a/tests/f_boundscheck/expect.1 b/tests/f_boundscheck/expect.1
new file mode 100644
index 0000000..c2170b8
--- /dev/null
+++ b/tests/f_boundscheck/expect.1
@@ -0,0 +1,25 @@
+ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
+../e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
+../e2fsck/e2fsck: Bad magic number in super-block while using the backup blocks../e2fsck/e2fsck: going back to original superblock
+Note: if several inode or block bitmap blocks or part
+of the inode table require relocation, you may wish to try
+running e2fsck with the '-b 8193' option first.  The problem
+may lie only with the primary block group descriptors, and
+the backup block group descriptors may be OK.
+
+Inode table for group 1 is not in group.  (block 4294967295)
+WARNING: SEVERE DATA LOSS POSSIBLE.
+Relocate? yes
+
+One or more block group descriptor checksums are invalid.  Fix? yes
+
+Group descriptor 1 checksum is 0x6ea2, should be 0x7edd.  FIXED.
+Pass 1: Checking inodes, blocks, and sizes
+Error allocating 256 contiguous block(s) in block group 1 for inode table: Could not allocate block in ext2 filesystem
+e2fsck: aborted
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+Exit status is 0
diff --git a/tests/f_boundscheck/expect.2 b/tests/f_boundscheck/expect.2
new file mode 100644
index 0000000..c2170b8
--- /dev/null
+++ b/tests/f_boundscheck/expect.2
@@ -0,0 +1,25 @@
+ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
+../e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
+../e2fsck/e2fsck: Bad magic number in super-block while using the backup blocks../e2fsck/e2fsck: going back to original superblock
+Note: if several inode or block bitmap blocks or part
+of the inode table require relocation, you may wish to try
+running e2fsck with the '-b 8193' option first.  The problem
+may lie only with the primary block group descriptors, and
+the backup block group descriptors may be OK.
+
+Inode table for group 1 is not in group.  (block 4294967295)
+WARNING: SEVERE DATA LOSS POSSIBLE.
+Relocate? yes
+
+One or more block group descriptor checksums are invalid.  Fix? yes
+
+Group descriptor 1 checksum is 0x6ea2, should be 0x7edd.  FIXED.
+Pass 1: Checking inodes, blocks, and sizes
+Error allocating 256 contiguous block(s) in block group 1 for inode table: Could not allocate block in ext2 filesystem
+e2fsck: aborted
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+Exit status is 0
diff --git a/tests/f_boundscheck/image.bz2 b/tests/f_boundscheck/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..098d02e9f51694b6c34273eff00d4646487bfe35
GIT binary patch
literal 986
zcmV<0110=IT4*^jL0KkKS!@T;Y5)L7fB*mg|NsC0|NsAxJrKWd-YIU-z`>Bx0gJ_8
z1O$Skj#<zHlgYD)b#`G2sMFMB02%-^Vrip8C#V3?kYvC^CV&UMs)#ZG8ZrhT!UhQ>
znhI)qC#H$&dYP%Fnqo3~jW(lbfCh$u&;T+3&;S`4G|*^fri{@DdZ{1=hJXzLplAR9
zXaL9n0000Q000000u3@Snl!=;LlaB^85&|3m;o|i0GS4i009{=nJ@&xFhr!O?M+Ro
zrXe0E+B5)0n1(}WWM~1P&>-{%kThZ*qfIox05mkv`7wMwxMQ;-MP8RQ2~iwbW5<=l
z+z`k#qfP2V(PUu|5lwW3*!@2NhD}kiUck1EBM30*IOQ@GZF`Ez-RhVaRoH+i7m*PG
zR@4v`RLqK~qN-OFKtST!qXfAXX&|aU4fpwb%VZI>HSqLcnTpW@iHPHrBF4577A;v^
zFpHL$GBx$v8x57y+|fab;MvWi*m<>L>ho;{?QJc-;`)_4{0+|PUhaWOx0~JcSDAT?
z4l^9w?EMBuqh`3wv|2T6-NTn!T6&bu;G0$H#&J71d7YxgGsH;pj@uPb{fYM#@J+or
zl5%KZkl*3c0~&*gE}(#@00o-LC1enITjG?7AjlUn3PwUrRXP<aJR>F*K>-jD5C9Ya
z000005EK9a5C9Ya0003{00000009sH6cIsXk(&&JVM?J9Qlv-H;GhyUS)$-U0Z;%7
zGDWC`>lDSPqP0OSiml>Qf?L3GA_HKEBYzZ6OjfvvDgXf_A#6iHOo%wJmTNCPg+^Gy
z_{uEZz-*t%Lp(y>CU!j?Co1H)EG?+oARM{v?fE{XSV@_#NXlUqZe)SYY^S*HTe@=z
zK3kJDAYHJ(BADcSk;^PPA{BZi=^Nq#TD3=fO!*v*6u^B(1z5{GZ(?QnsODukje?GL
zH0ip`YkGH7FfFgZ2Y>(=;dlT501H3>ISa^$h=`t%ZlHn)emG{(fMMiOL->Jvj8c+>
zaAGDD|K-yI)WyYtbU`ta6E;Dn@;7taWTB7x&@Lxq%TKMFm-}ce7UPX0EJTJGBwt~U
zfVYImC}ft3$~I+ZgzS3BGX8Yp%C*aCW_D-Xl^<lZRdO;+&v9Z|8Bd!<f$j>1Z}mb=
z=U>r3%HsB+p5&xqCV<W!L3gMviG#f%nU1`}@Kq7h#>C*&P*Y5PFh>f4MS~=XkZ8}+
z(2^N#pql{Is=8i6tX0Mm-elz1{OYB7jXV(mQ~(1?q>P9Vi233)rc@7fO1<LlNT&)C
I4S@O$K;###8UO$Q

literal 0
HcmV?d00001

diff --git a/tests/f_boundscheck/name b/tests/f_boundscheck/name
new file mode 100644
index 0000000..192d279
--- /dev/null
+++ b/tests/f_boundscheck/name
@@ -0,0 +1 @@
+infinite loop due to off by one error when finding free space for inode table relocation
diff --git a/tests/f_boundscheck/script b/tests/f_boundscheck/script
new file mode 100755
index 0000000..fbbce62
--- /dev/null
+++ b/tests/f_boundscheck/script
@@ -0,0 +1,32 @@
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

