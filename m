From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4/004: Add new resize2fs functional test
Date: Tue,  9 Dec 2014 23:27:26 +0400
Message-ID: <1418153247-17435-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:21323 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaLIT1g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2014 14:27:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Perform online fs-resize(from 1T to 15T) and check that fs is usable

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/004     | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/004.out |  16 +++++++++
 tests/ext4/group   |   1 +
 3 files changed, 117 insertions(+)
 create mode 100755 tests/ext4/004
 create mode 100644 tests/ext4/004.out

diff --git a/tests/ext4/004 b/tests/ext4/004
new file mode 100755
index 0000000..0c54ade
--- /dev/null
+++ b/tests/ext4/004
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. 004
+#
+# Online resize2fs functional test
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
+
+_cleanup()
+{
+    _scratch_unmount
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+E2FSCK_PROG="`set_prog_path e2fsck`"
+RESIZE2FS_PROG="`set_prog_path resize2fs`"
+_supported_fs ext4
+_supported_os Linux
+_require_command $MKFS_EXT4_PROG mkfs.ext4
+_require_command $E2FSCK_PROG e2fsck
+_require_command $RESIZE2FS_PROG resize2fs
+_require_scratch
+
+# real QA test starts here
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+mkdir $SCRATCH_MNT/mnt
+touch $SCRATCH_MNT/img
+truncate --size 1G $SCRATCH_MNT/img || _fail "Can not grow $SCRATCH_MNT/img"
+$MKFS_EXT4_PROG -F -b 4096 -i $((1024*1024*64)) $MKFS_OPTIONS -O 64bit $SCRATCH_MNT/img \
+    >> $seqres.full 2>&1 || _fail "$MKFS_EXT4_PROG failed see $seqres.full"
+
+for ((size = 1; size < 16; size++))
+do
+    truncate --size ${size}T $SCRATCH_MNT/img || _fail "Can not grow $SCRATCH_MNT/img file"
+    loop=`_create_loop_device $SCRATCH_MNT/img`
+    _mount -t $FSTYP $MOUNT_OPTIONS $loop $SCRATCH_MNT/mnt
+
+    echo "Resize to ${size}T"
+    $RESIZE2FS_PROG $loop  >> $seqres.full 2>&1 || \
+	_fail "Could not resize FS to $size Tb"
+
+    du -sch $SCRATCH_MNT/img >> $seqres.full
+    # Create space-holders
+    for ((i=0 ; i < 1000;i++))
+    do
+	fallocate -l 1001M $SCRATCH_MNT/mnt/space-$size-$i
+    done
+
+    # Consume all space remaining
+    fallocate -l 1T $SCRATCH_MNT/mnt/space-$size-last 2> /dev/null && \
+	_fail "Too may space consumed"
+
+    # Cut 1Mb for eash space-holders in order to create very fragmented fs
+    for ((i=0 ; i < 1000;i++))
+    do
+	truncate --size 1000M $SCRATCH_MNT/mnt/space-$size-$i
+    done
+
+    out=$SCRATCH_MNT/mnt/fsstress-$size
+    args=`_scale_fsstress_args -p8 -n200 -f setattr=1 $FSSTRESS_AVOID -d $out`
+    echo "Run fsstress $args" >> $seqres.full
+    $FSSTRESS_PROG $args -d $out > /dev/null 2>&1
+
+    du -sch $SCRATCH_MNT/img >> $seqres.full
+    umount $SCRATCH_MNT/mnt || _fail " umount fail"
+    _destroy_loop_device $loop
+    _check_generic_filesystem $SCRATCH_MNT/img
+done
+
+status=0
+exit
diff --git a/tests/ext4/004.out b/tests/ext4/004.out
new file mode 100644
index 0000000..ff2efcf
--- /dev/null
+++ b/tests/ext4/004.out
@@ -0,0 +1,16 @@
+QA output created by 004
+Resize to 1T
+Resize to 2T
+Resize to 3T
+Resize to 4T
+Resize to 5T
+Resize to 6T
+Resize to 7T
+Resize to 8T
+Resize to 9T
+Resize to 10T
+Resize to 11T
+Resize to 12T
+Resize to 13T
+Resize to 14T
+Resize to 15T
diff --git a/tests/ext4/group b/tests/ext4/group
index aa6a53b..e60d8fb 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -6,6 +6,7 @@
 001 auto prealloc quick
 002 auto quick prealloc
 003 auto quick
+004 auto ioctl resize
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
-- 
1.8.3.1

