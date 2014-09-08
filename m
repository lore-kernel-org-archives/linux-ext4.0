From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/25] tests: test recovery of 32 and 64-bit journals with
 checksum v2
Date: Mon, 08 Sep 2014 16:13:28 -0700
Message-ID: <20140908231328.25904.94901.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaIHXNd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:13:33 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add tests to ensure that we know how to recover journals with the
csum_v2 feature set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_recover_csum2_32bit/expect.1  |   16 ++++++++++++++++
 tests/j_recover_csum2_32bit/expect.2  |    7 +++++++
 tests/j_recover_csum2_32bit/image.bz2 |  Bin
 tests/j_recover_csum2_32bit/name      |    1 +
 tests/j_recover_csum2_32bit/script    |   31 +++++++++++++++++++++++++++++++
 tests/j_recover_csum2_64bit/expect.1  |   16 ++++++++++++++++
 tests/j_recover_csum2_64bit/expect.2  |    7 +++++++
 tests/j_recover_csum2_64bit/image.bz2 |  Bin
 tests/j_recover_csum2_64bit/name      |    1 +
 tests/j_recover_csum2_64bit/script    |   31 +++++++++++++++++++++++++++++++
 10 files changed, 110 insertions(+)
 create mode 100644 tests/j_recover_csum2_32bit/expect.1
 create mode 100644 tests/j_recover_csum2_32bit/expect.2
 create mode 100644 tests/j_recover_csum2_32bit/image.bz2
 create mode 100644 tests/j_recover_csum2_32bit/name
 create mode 100755 tests/j_recover_csum2_32bit/script
 create mode 100644 tests/j_recover_csum2_64bit/expect.1
 create mode 100644 tests/j_recover_csum2_64bit/expect.2
 create mode 100644 tests/j_recover_csum2_64bit/image.bz2
 create mode 100644 tests/j_recover_csum2_64bit/name
 create mode 100755 tests/j_recover_csum2_64bit/script


diff --git a/tests/j_recover_csum2_32bit/expect.1 b/tests/j_recover_csum2_32bit/expect.1
new file mode 100644
index 0000000..491784a
--- /dev/null
+++ b/tests/j_recover_csum2_32bit/expect.1
@@ -0,0 +1,16 @@
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(1--259) +265 +(274--275) +281 +(290--418) +(1059--1186) +(2211--2352)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/8192 files (0.0% non-contiguous), 7739/131072 blocks
+Exit status is 0
diff --git a/tests/j_recover_csum2_32bit/expect.2 b/tests/j_recover_csum2_32bit/expect.2
new file mode 100644
index 0000000..d223026
--- /dev/null
+++ b/tests/j_recover_csum2_32bit/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/8192 files (0.0% non-contiguous), 7739/131072 blocks
+Exit status is 0
diff --git a/tests/j_recover_csum2_32bit/image.bz2 b/tests/j_recover_csum2_32bit/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..2212edd9ab3c825914a98a21deb10007d5c035d9
GIT binary patch
literal 3371
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

literal 0
HcmV?d00001

diff --git a/tests/j_recover_csum2_32bit/name b/tests/j_recover_csum2_32bit/name
new file mode 100644
index 0000000..6fd378c
--- /dev/null
+++ b/tests/j_recover_csum2_32bit/name
@@ -0,0 +1 @@
+recover 32-bit journal checksum v2
diff --git a/tests/j_recover_csum2_32bit/script b/tests/j_recover_csum2_32bit/script
new file mode 100755
index 0000000..4b0ec48
--- /dev/null
+++ b/tests/j_recover_csum2_32bit/script
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+FSCK_OPT=-fy
+IMAGE=$test_dir/image.bz2
+
+bzip2 -d < $IMAGE > $TMPFILE
+
+# Run fsck to fix things?
+EXP1=$test_dir/expect.1
+OUT1=$test_name.1.log
+rm -rf $test_name.failed $test_name.ok
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT1
+echo "Exit status is $?" >> $OUT1
+
+# Run a second time
+EXP2=$test_dir/expect.2
+OUT2=$test_name.2.log
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT2
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
diff --git a/tests/j_recover_csum2_64bit/expect.1 b/tests/j_recover_csum2_64bit/expect.1
new file mode 100644
index 0000000..491784a
--- /dev/null
+++ b/tests/j_recover_csum2_64bit/expect.1
@@ -0,0 +1,16 @@
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(1--259) +265 +(274--275) +281 +(290--418) +(1059--1186) +(2211--2352)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/8192 files (0.0% non-contiguous), 7739/131072 blocks
+Exit status is 0
diff --git a/tests/j_recover_csum2_64bit/expect.2 b/tests/j_recover_csum2_64bit/expect.2
new file mode 100644
index 0000000..d223026
--- /dev/null
+++ b/tests/j_recover_csum2_64bit/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/8192 files (0.0% non-contiguous), 7739/131072 blocks
+Exit status is 0
diff --git a/tests/j_recover_csum2_64bit/image.bz2 b/tests/j_recover_csum2_64bit/image.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..acf1daed92e6805adee12a099ebff4dd22507a83
GIT binary patch
literal 3486
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
JK7Sr6`Y+b~7ncA4

literal 0
HcmV?d00001

diff --git a/tests/j_recover_csum2_64bit/name b/tests/j_recover_csum2_64bit/name
new file mode 100644
index 0000000..1770502
--- /dev/null
+++ b/tests/j_recover_csum2_64bit/name
@@ -0,0 +1 @@
+recover 64-bit journal checksum v2
diff --git a/tests/j_recover_csum2_64bit/script b/tests/j_recover_csum2_64bit/script
new file mode 100755
index 0000000..4b0ec48
--- /dev/null
+++ b/tests/j_recover_csum2_64bit/script
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+FSCK_OPT=-fy
+IMAGE=$test_dir/image.bz2
+
+bzip2 -d < $IMAGE > $TMPFILE
+
+# Run fsck to fix things?
+EXP1=$test_dir/expect.1
+OUT1=$test_name.1.log
+rm -rf $test_name.failed $test_name.ok
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT1
+echo "Exit status is $?" >> $OUT1
+
+# Run a second time
+EXP2=$test_dir/expect.2
+OUT2=$test_name.2.log
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | head -n 1000 | tail -n +2 > $OUT2
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

