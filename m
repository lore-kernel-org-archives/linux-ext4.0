From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] tests: add more tests for off-line resizing
Date: Sun, 31 Mar 2013 20:44:03 -0400
Message-ID: <1364777043-20610-5-git-send-email-tytso@mit.edu>
References: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
 <1364777043-20610-1-git-send-email-tytso@mit.edu>
Cc: john.jolly@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57583 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab3DAAoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Mar 2013 20:44:10 -0400
In-Reply-To: <1364777043-20610-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/r_1024_small_bg/script       |  27 +++++++
 tests/r_64bit_big_expand/script    |  27 +++++++
 tests/r_bigalloc_big_expand/script |  27 +++++++
 tests/r_ext4_big_expand/script     |  27 +++++++
 tests/r_ext4_small_bg/script       |  27 +++++++
 tests/scripts/resize_test          | 139 +++++++++++++++++++++++++++++++++++++
 6 files changed, 274 insertions(+)
 create mode 100644 tests/r_1024_small_bg/script
 create mode 100644 tests/r_64bit_big_expand/script
 create mode 100644 tests/r_bigalloc_big_expand/script
 create mode 100644 tests/r_ext4_big_expand/script
 create mode 100644 tests/r_ext4_small_bg/script
 create mode 100755 tests/scripts/resize_test

diff --git a/tests/r_1024_small_bg/script b/tests/r_1024_small_bg/script
new file mode 100644
index 0000000..fafcf91
--- /dev/null
+++ b/tests/r_1024_small_bg/script
@@ -0,0 +1,27 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+test_description="ext2 1024 blocksize with small block groups"
+FEATURES="-t ext2 -O ^resize_inode -b 1024 -g 1024"
+SIZE_1=64M
+SIZE_2=2G
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+
+
+. $cmd_dir/scripts/resize_test
+
+if resize_test
+then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	touch $test_name.failed
+fi
+
+unset FEATURES SIZE_1 SIZE_2 LOG E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
+
diff --git a/tests/r_64bit_big_expand/script b/tests/r_64bit_big_expand/script
new file mode 100644
index 0000000..3b34a62
--- /dev/null
+++ b/tests/r_64bit_big_expand/script
@@ -0,0 +1,27 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+test_description="very large fs growth using ext4 w/64bit"
+FEATURES="-t ext4 -O 64bit"
+SIZE_1=512M
+SIZE_2=2T
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+
+
+. $cmd_dir/scripts/resize_test
+
+if resize_test
+then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	touch $test_name.failed
+fi
+
+unset FEATURES SIZE_1 SIZE_2 LOG E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
+
diff --git a/tests/r_bigalloc_big_expand/script b/tests/r_bigalloc_big_expand/script
new file mode 100644
index 0000000..2b9cc63
--- /dev/null
+++ b/tests/r_bigalloc_big_expand/script
@@ -0,0 +1,27 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+test_description="ext4 with bigalloc"
+FEATURES="-t ext4 -O bigalloc"
+SIZE_1=512M
+SIZE_2=2T
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+RESIZE2FS_OPTS=-f
+
+. $cmd_dir/scripts/resize_test
+
+if resize_test
+then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	touch $test_name.failed
+fi
+
+unset FEATURES SIZE_1 SIZE_2 LOG E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
+
diff --git a/tests/r_ext4_big_expand/script b/tests/r_ext4_big_expand/script
new file mode 100644
index 0000000..fb31d7a
--- /dev/null
+++ b/tests/r_ext4_big_expand/script
@@ -0,0 +1,27 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+test_description="very large fs growth using ext4"
+FEATURES="-t ext4"
+SIZE_1=512M
+SIZE_2=2T
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+
+
+. $cmd_dir/scripts/resize_test
+
+if resize_test
+then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	touch $test_name.failed
+fi
+
+unset FEATURES SIZE_1 SIZE_2 LOG E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
+
diff --git a/tests/r_ext4_small_bg/script b/tests/r_ext4_small_bg/script
new file mode 100644
index 0000000..553cbd8
--- /dev/null
+++ b/tests/r_ext4_small_bg/script
@@ -0,0 +1,27 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+test_description="ext4 1024 blocksize with small block groups"
+FEATURES="-t ext4 -O ^resize_inode -b 1024 -g 512"
+SIZE_1=64M
+SIZE_2=2G
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+
+
+. $cmd_dir/scripts/resize_test
+
+if resize_test
+then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	touch $test_name.failed
+fi
+
+unset FEATURES SIZE_1 SIZE_2 LOG E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
+
diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
new file mode 100755
index 0000000..964150e
--- /dev/null
+++ b/tests/scripts/resize_test
@@ -0,0 +1,139 @@
+#!/bin/sh
+
+resize_test () {
+
+rm -f $TMPFILE
+touch $TMPFILE
+echo $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 > $LOG
+$MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 >> $LOG
+
+OUT_TMP=$(mktemp -t csum-tmp.XXXXXX)
+
+date > $OUT_TMP
+cat $E2FSCK >> $OUT_TMP
+echo $CRCSUM $OUT_TMP >> $LOG 2>&1
+CSUM_1=$($CRCSUM $OUT_TMP)
+echo Checksum is $CSUM_1 >> $LOG
+
+echo Setting up file system >> $LOG
+$DEBUGFS -w $TMPFILE  >> $LOG 2>&1 << EOF
+mkdir test
+cd test
+write $OUT_TMP e2fsck
+ls /test
+stat /test/e2fsck
+quit
+EOF
+echo " " >> $LOG
+
+rm -f $OUT_TMP
+
+echo $FSCK -fy $TMPFILE >> $LOG 2>&1 
+$FSCK -fy $TMPFILE >> $LOG 2>&1 
+
+echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 $TMPFILE $SIZE_2 >> $LOG 2>&1
+then
+	return 1
+fi
+
+echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
+if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+then
+	dumpe2fs $TMPFILE >> $LOG
+	return 1
+fi
+
+echo $DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+$DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+
+echo $CRCSUM $OUT_TMP >> $LOG 2>&1
+CSUM_2=$($CRCSUM $OUT_TMP)
+echo Checksum is $CSUM_2 >> $LOG
+
+if test "$CSUM_1" != "$CSUM_2"
+then
+	return 1
+fi
+
+echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+then
+	return 1
+fi
+
+echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
+if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+then
+	dumpe2fs $TMPFILE >> $LOG
+	return 1
+fi
+
+echo $DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+$DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+
+echo $CRCSUM $OUT_TMP >> $LOG 2>&1
+CSUM_2=$($CRCSUM $OUT_TMP)
+echo Checksum is $CSUM_2 >> $LOG
+
+if test "$CSUM_1" != "$CSUM_2"
+then
+	return 1
+fi
+
+echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+then
+	return 1
+fi
+
+echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
+if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+then
+	dumpe2fs $TMPFILE >> $LOG
+	return 1
+fi
+
+echo $DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+$DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+
+echo $CRCSUM $OUT_TMP >> $LOG 2>&1
+CSUM_2=$($CRCSUM $OUT_TMP)
+echo Checksum is $CSUM_2 >> $LOG
+
+if test "$CSUM_1" != "$CSUM_2"
+then
+	return 1
+fi
+
+echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+then
+	return 1
+fi
+
+echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
+if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+then
+	dumpe2fs $TMPFILE >> $LOG
+	return 1
+fi
+
+echo $DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+$DEBUGFS -R "dump /test/e2fsck $OUT_TMP" $TMPFILE >> $LOG 2>&1
+
+echo $CRCSUM $OUT_TMP >> $LOG 2>&1
+CSUM_2=$($CRCSUM $OUT_TMP)
+echo Checksum is $CSUM_2 >> $LOG
+
+rm $OUT_TMP
+unset OUT_TMP
+
+if test "$CSUM_1" != "$CSUM_2"
+then
+	return 1
+fi
+
+return 0
+
+}
-- 
1.7.12.rc0.22.gcdd159b

