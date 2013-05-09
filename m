From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfstests: regression test for ext4 resize with non-extent
 files
Date: Thu, 09 May 2013 17:02:48 -0500
Message-ID: <518C1D08.4080309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3EIWCz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 May 2013 18:02:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression test for:

c5c72d8 ext4: fix online resizing for ext3-compat file systems

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/ext4/306 b/tests/ext4/306
new file mode 100755
index 0000000..6a961ee
--- /dev/null
+++ b/tests/ext4/306
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. ext4/306
+#
+# Test that blocks are available to non-extent files after a resize2fs
+# Regression test for commit:
+# c5c72d8 ext4: fix online resizing for ext3-compat file systems
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
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
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+
+# This needs to mount ext3; might require ext3 driver, or ext4
+# might handle it itself.  Find out if we have it one way or another.
+modprobe ext3 > /dev/null 2>&1
+grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
+
+rm -f $seqres.full
+echo "Silence is golden"
+
+# Make a small ext3 fs, (extents disabled) & mount it
+yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
+_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
+# Create a small non-extent-based file
+echo "Create 1m testfile1"
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
+echo "Create testfile2 to fill the fs"
+# A large non-extent-based file filling the fs; this will run out & fail
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
+
+# Remount as ext4
+_scratch_unmount
+_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
+df -h $SCRATCH_MNT >> $seqres.full
+
+# Grow it by 512m
+echo "Resize to 1g"
+resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize to 1g"
+df -h $SCRATCH_MNT >> $seqres.full
+
+# See if we can add more blocks to the files
+echo "append 2m to testfile1"
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 1m 2m" | _filter_xfs_io
+echo "append 2m to testfile2"
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 512m 2m" | _filter_xfs_io
+
+status=0
+exit
diff --git a/tests/ext4/306.out b/tests/ext4/306.out
new file mode 100644
index 0000000..654637d
--- /dev/null
+++ b/tests/ext4/306.out
@@ -0,0 +1,14 @@
+QA output created by 306
+Silence is golden
+Create 1m testfile1
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Create testfile2 to fill the fs
+pwrite64: No space left on device
+Resize to 1g
+append 2m to testfile1
+wrote 2097152/2097152 bytes at offset 1048576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+append 2m to testfile2
+wrote 2097152/2097152 bytes at offset 536870912
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/ext4/group b/tests/ext4/group
index 53af708..4c3e2f4 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -9,3 +9,4 @@
 303 aio dangerous ioctl rw stress
 304 aio dangerous ioctl rw stress
 305 auto
+306 dangerous rw resize quick

