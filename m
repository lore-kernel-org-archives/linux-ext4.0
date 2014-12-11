From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Subject: max_dir_size_kb option list
Date: Thu, 11 Dec 2014 15:06:42 +0300
Message-ID: <548988D2.3030100@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060506000908010104030506"
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLKMHR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Dec 2014 07:07:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060506000908010104030506
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've prepared test for xfstests suite that runs some checks for ext4 
mount option max_dir_size_kb introduced in Linux Kernel 3.7, could 
someone please look on it?

Thanks,
Alexander Tsvetkov

--------------060506000908010104030506
Content-Type: text/x-patch;
 name="max_dir_size_kb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="max_dir_size_kb.patch"

>From 21b1da618d0fcb4cd4666d10c41583274ed4eeed Mon Sep 17 00:00:00 2001
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Date: Wed, 10 Dec 2014 15:31:02 +0300
Subject: [PATCH] added test for max_dir_size_kb mount option

---
 tests/ext4/309     | 213 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/309.out |   2 +
 tests/ext4/group   |   3 +-
 3 files changed, 217 insertions(+), 1 deletion(-)
 create mode 100755 tests/ext4/309
 create mode 100755 tests/ext4/309.out

diff --git a/tests/ext4/309 b/tests/ext4/309
new file mode 100755
index 0000000..e2f4e43
--- /dev/null
+++ b/tests/ext4/309
@@ -0,0 +1,213 @@
+#! /bin/bash
+# FS QA Test
+#
+# Test for mount option max_dir_size_kb
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Oracle and/or its affiliates.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+tmp=/tmp/$$
+
+testdir=$SCRATCH_MNT/testdir
+testfile=$SCRATCH_MNT/testfile
+sdir=`dirname $0`
+sdir=`cd "$sdir"; pwd`
+
+echo "QA output created by $seq"
+echo "Silence is golden"
+rm -f $seqres.full
+
+status=1 # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup() {
+   if [ ! -z SCRATCH_MNT ]; then
+      rm -fr $SCRATCH_MNT/test*
+      _scratch_unmount
+   fi
+}
+
+_filter_error() {
+   sed -n -e "s/.*\($1\).*/\"\1\"/p"
+}
+
+_clear_testdir() {
+   dirs="$testdir *$"
+   for i in $dirs; do
+      rm -fr $i/*
+   done
+}
+
+# $1 - device
+# $2 - options
+_make_ext4fs() {
+   device=$1
+   opts=$2
+   umount $device 1>/dev/null 2>&1
+   mkfs.ext4 $opts $device 1>/dev/null 2>&1
+}
+
+# $1 - options
+# $2 - mount point
+_make_loopfs() {
+   lpf=$testfile
+   dd if=/dev/zero of=$lpf bs=4k count=256 1>/dev/null 2>&1
+   loopdev=$(losetup -f)
+   losetup $loopdev $lpf
+   mkfs.ext4 -O ^dir_index,^has_journal $loopdev 1>/dev/null 2>&1
+   mount -t ext4 $1 $loopdev $2
+}
+
+# $1 - expected limit after items creation
+# $2 - command to create item
+# $3 - where to create (testdir by default)
+_create_items() {
+    limit=$1
+    create_cmd=$2
+    dir=${3:-$testdir}
+    sync
+    echo 3 > /proc/sys/vm/drop_caches
+    MAX_INUM=$(((limit*1024*2)/24))
+    for i in $(seq 0 $MAX_INUM); do
+       tmp_name=`mktemp -u`
+       item=`basename $tmp_name`
+       if [ -e $dir/$item ]; then
+          continue
+       fi 
+       create_cmd="$2 $dir/$item 2>$tmp.out 1>/dev/null"
+       eval "$create_cmd"
+       res=$?
+       if [ $res -ne 0 ]; then
+          _filter_error "No space left on device" < $tmp.out > $tmp.out2
+          if [ -s $tmp.out2 ]; then
+             cat $tmp.out2 | tr -d '\n' >> $seqres.full
+          else
+             echo "FAIL! expected ENOSPC" | tee -a $seqres.full
+          fi
+          break
+      fi
+   done
+   size=$(stat -c %s $dir)
+   size=$((size/1024))
+   if [ $size -gt $limit ]; then
+      echo "FAIL! expected dir size: $limit, actually: $size" | tee -a $seqres.full
+   fi
+   rm -f $tmp*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+
+_supported_fs ext4
+_supported_os Linux
+_require_scratch
+
+LIMIT1=8
+LIMIT2=16
+
+_make_ext4fs $SCRATCH_DEV "-O ^dir_index,^filetype"
+_scratch_mount "-o max_dir_size_kb=$LIMIT1"
+mkdir $testdir 2>/dev/null
+
+echo -e "\nExceed $LIMIT1 Kb limit with new files in testdir/: " >> $seqres.full
+_create_items $LIMIT1 "touch"
+
+echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >>$seqres.full
+_scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+_create_items $LIMIT1 "touch"
+
+echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir/: " >> $seqres.full
+_scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+_create_items $LIMIT2 "touch"
+
+echo -e "\nExceed $LIMIT2 Kb limit with new files in testdir2/: " >> $seqres.full
+mkdir $SCRATCH_MNT/testdir2 2>/dev/null
+_create_items $LIMIT2 "touch" "$SCRATCH_MNT/testdir2"
+
+echo -e "\nRemount with $LIMIT1 Kb limit,\nnew item in testdir/ should result to ENOSPC: " >> $seqres.full
+_scratch_mount "-o remount,max_dir_size_kb=$LIMIT1"
+_create_items $LIMIT2 "touch"
+echo -e "\nnew item in testdir2/ should result to ENOSPC: " >> $seqres.full
+_create_items $LIMIT2 "touch" "$SCRATCH_MNT/testdir2"
+_clear_testdir "$SCRATCH_MNT/testdir2"
+rmdir $testdir
+mkdir $testdir
+
+echo -e "\nExceed $LIMIT1 Kb directory limit with new subdirectories: " >> $seqres.full
+_create_items $LIMIT1 "mkdir"
+_clear_testdir
+
+echo -e "\nExceed $LIMIT1 Kb directory limit with symlinks: " >> $seqres.full
+dd if=/dev/urandom of=$testfile bs=1 seek=4096 count=4096 > /dev/null 2>&1
+_create_items $LIMIT1 "ln -s $testfile"
+_clear_testdir
+
+echo -e "\nExceed $LIMIT1 Kb directory limit with hardlinks: " >> $seqres.full
+_create_items $LIMIT1 "ln $testfile"
+_clear_testdir
+
+echo -e "\nExceed $LIMIT1 Kb directory limit with FIFOs: " >> $seqres.full
+_create_items $LIMIT1 "mkfifo"
+_clear_testdir
+
+echo -e "\nCreate ext4 fs on testdir/subdir with $LIMIT2 Kb limit," >> $seqres.full
+mkdir $testdir/subdir 2>/dev/null
+_make_ext4fs $TEST_DEV "-O ^dir_index,^filetype"
+mount -t ext4 -o max_dir_size_kb=$LIMIT2 $TEST_DEV $testdir/subdir
+
+echo "exceed $LIMIT1 Kb limit of testdir/:" >> $seqres.full
+_create_items $LIMIT1 "touch"
+
+echo -e "\nexceed $LIMIT2 Kb limit of testdir/subdir:" >> $seqres.full
+_create_items $LIMIT2 "touch" "$testdir/subdir"
+
+echo -e "\ntestdir/ limit $LIMIT2 Kb, testdir/subdir limit $LIMIT1 Kb," >> $seqres.full
+umount $TEST_DEV 1>/dev/null 2>&1
+_scratch_mount "-o remount,max_dir_size_kb=$LIMIT2"
+mount -t ext4 -o max_dir_size_kb=$LIMIT1 $TEST_DEV $testdir/subdir
+
+echo "exceed new $LIMIT2 Kb limit of testdir/ with a set of files:" >> $seqres.full
+_create_items $LIMIT2 "touch"
+echo -e "\nnew item in testdir/subdir should result to ENOSPC: " >> $seqres.full
+_create_items $LIMIT2 "touch" "$testdir/subdir"
+
+umount $TEST_DEV 1>/dev/null 2>&1
+_clear_testdir
+
+echo -e "\ntestdir/ limit $LIMIT2 Kb, loop fs: testdir/subdir limit $LIMIT1 Kb," >> $seqres.full
+mkdir $testdir/subdir
+
+_make_loopfs "-o max_dir_size_kb=$LIMIT1" "$testdir/subdir"
+
+echo "exceed $LIMIT1 Kb limit of testdir/subdir with a set of files:" >> $seqres.full
+_create_items $LIMIT1 "touch" "$testdir/subdir"
+
+echo -e "\nexceed $LIMIT2 Kb limit of testdir/ with a set of files:" >> $seqres.full
+_create_items $LIMIT2 "touch"
+
+umount $testdir/subdir
+losetup -d $loopdev
+_clear_testdir
+
+# success, all done
+status=0
+exit 0
diff --git a/tests/ext4/309.out b/tests/ext4/309.out
new file mode 100755
index 0000000..56330d6
--- /dev/null
+++ b/tests/ext4/309.out
@@ -0,0 +1,2 @@
+QA output created by 309
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index aa6a53b..9bf1061 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -14,4 +14,5 @@
 305 auto
 306 auto rw resize quick
 307 auto ioctl rw
-308 auto ioctl rw prealloc quick
\ No newline at end of file
+308 auto ioctl rw prealloc quick
+309 auto
-- 
1.9.3


--------------060506000908010104030506--
