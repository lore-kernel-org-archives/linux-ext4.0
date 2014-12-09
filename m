From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4/005: Add new resize2fs stress test
Date: Tue,  9 Dec 2014 23:27:27 +0400
Message-ID: <1418153247-17435-2-git-send-email-dmonakhov@openvz.org>
References: <1418153247-17435-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:44866 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaLIT1g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2014 14:27:36 -0500
In-Reply-To: <1418153247-17435-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Run several rounds of resize2fs. Increment fs-size on random amount bytes on each
iteration while fsstress is in progress.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/005     | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/005.out |  36 ++++++++++++++++++
 tests/ext4/group   |   1 +
 3 files changed, 143 insertions(+)
 create mode 100755 tests/ext4/005
 create mode 100644 tests/ext4/005.out

diff --git a/tests/ext4/005 b/tests/ext4/005
new file mode 100755
index 0000000..3b81aab
--- /dev/null
+++ b/tests/ext4/005
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 004
+#
+# Online resize2fs stress test
+# Run resize2fs and fsstress concurently
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Dmitry Monakhov.  All Rights Reserved.
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
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+E2FSCK_PROG="`set_prog_path e2fsck`"
+RESIZE2FS_PROG="`set_prog_path resize2fs`"
+
+_require_command $MKFS_EXT4_PROG mkfs.ext4
+_require_command $E2FSCK_PROG e2fsck
+_require_command $RESIZE2FS_PROG resize2fs
+_require_scratch
+
+#Real testing starts here
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+mkdir $SCRATCH_MNT/mnt
+touch $SCRATCH_MNT/img
+
+size=$((1024*1024))
+truncate --size ${size}k $SCRATCH_MNT/img || _fail "Can not grow $SCRATCH_MNT/img"
+$MKFS_EXT4_PROG -F -b 4096 -i $((1024*1024*64)) $MKFS_OPTIONS -O 64bit $SCRATCH_MNT/img \
+    >> $seqres.full 2>&1 || _fail "$MKFS_EXT4_PROG failed see $seqres.full"
+truncate --size 15T $SCRATCH_MNT/img || _fail "Can not grow $SCRATCH_MNT/img file"
+loop=`_create_loop_device $SCRATCH_MNT/img`
+
+_workout ()
+{
+    tst_nr=$1
+    _mount -t $FSTYP $MOUNT_OPTIONS $loop $SCRATCH_MNT/mnt
+    for ((it = 0; it <= tst_nr/2; it++))
+    do
+	echo "Start Round:$tst_nr iteration:$it"
+	size=$(($size + $RANDOM * 503 * ($tst_nr+1)));
+	out=$SCRATCH_MNT/mnt/fsstress-$size
+	args=`_scale_fsstress_args -p16 -n200 -f setattr=1 $FSSTRESS_AVOID -d $out`
+	
+	echo "Run fsstress $args" >> $seqres.full
+	$FSSTRESS_PROG $args -d $out > /dev/null 2>&1 &
+	fsstress_pid=$!
+	echo "Resize to ${size}k" >> $seqres.full
+	$RESIZE2FS_PROG $loop  >> $seqres.full ${size}k 2>&1 || \
+	    _fail "Could not resize FS to $size kb"
+	wait $fsstress_pid
+	fallocate -l 32M $SCRATCH_MNT/mnt/rsv-$tst_nr-$it
+	# Consume all space available
+	fallocate -l 1T $SCRATCH_MNT/mnt/space-$tst_nr-$it 2> /dev/null && \
+	    _fail "Too may space consumed"
+	unlink $SCRATCH_MNT/mnt/rsv-$tst_nr-$it
+	du -sch $SCRATCH_MNT/img >> $seqres.full
+	
+    done
+    umount $SCRATCH_MNT/mnt || _fail " umount fail"
+    _check_generic_filesystem $loop
+}
+
+for ((i=1; i <= 10; i++))
+do
+    _workout $i
+done
+
+_destroy_loop_device $loop
+
+status=0
+exit
diff --git a/tests/ext4/005.out b/tests/ext4/005.out
new file mode 100644
index 0000000..662c272
--- /dev/null
+++ b/tests/ext4/005.out
@@ -0,0 +1,36 @@
+QA output created by 005
+Start Round:1 iteration:0
+Start Round:2 iteration:0
+Start Round:2 iteration:1
+Start Round:3 iteration:0
+Start Round:3 iteration:1
+Start Round:4 iteration:0
+Start Round:4 iteration:1
+Start Round:4 iteration:2
+Start Round:5 iteration:0
+Start Round:5 iteration:1
+Start Round:5 iteration:2
+Start Round:6 iteration:0
+Start Round:6 iteration:1
+Start Round:6 iteration:2
+Start Round:6 iteration:3
+Start Round:7 iteration:0
+Start Round:7 iteration:1
+Start Round:7 iteration:2
+Start Round:7 iteration:3
+Start Round:8 iteration:0
+Start Round:8 iteration:1
+Start Round:8 iteration:2
+Start Round:8 iteration:3
+Start Round:8 iteration:4
+Start Round:9 iteration:0
+Start Round:9 iteration:1
+Start Round:9 iteration:2
+Start Round:9 iteration:3
+Start Round:9 iteration:4
+Start Round:10 iteration:0
+Start Round:10 iteration:1
+Start Round:10 iteration:2
+Start Round:10 iteration:3
+Start Round:10 iteration:4
+Start Round:10 iteration:5
diff --git a/tests/ext4/group b/tests/ext4/group
index e60d8fb..833c5c7 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -7,6 +7,7 @@
 002 auto quick prealloc
 003 auto quick
 004 auto ioctl resize
+005 auto ioctl resize
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
-- 
1.8.3.1

