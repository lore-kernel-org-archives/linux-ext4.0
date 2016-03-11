From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/2] generic: test I/O on dm error device
Date: Fri, 11 Mar 2016 23:40:22 +0800
Message-ID: <1457710822-30532-2-git-send-email-eguan@redhat.com>
References: <1457710822-30532-1-git-send-email-eguan@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbcCKPlw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Mar 2016 10:41:52 -0500
In-Reply-To: <1457710822-30532-1-git-send-email-eguan@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a test that performs simple I/O on dm error device, which
returns EIO on all I/O request.

This is motivated by an ext4 bug that crashes kernel on error path when
trying to update atime. Following kernel patch should fix the issue

  ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/338     | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/338.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 93 insertions(+)
 create mode 100755 tests/generic/338
 create mode 100644 tests/generic/338.out

diff --git a/tests/generic/338 b/tests/generic/338
new file mode 100755
index 0000000..cea4d82
--- /dev/null
+++ b/tests/generic/338
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test 338
+#
+# Test I/O on dm error device.
+#
+# Motivated by an ext4 bug that crashes kernel on error path when trying to
+# update atime.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc.,  All Rights Reserved.
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
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+	_destroy_loop_device $LOOP_DEV
+	rm -f $LOOP_FILE
+	rm -rf $LOOP_MNT
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_loop
+_require_dm_target error
+# If TEST_DEV is not a valid block device, FSTYP cannot be mkfs'ed either
+_require_block_device $TEST_DEV
+
+echo "Silence is golden"
+
+# Use loop device as backend of dm error device, because drop_caches drops
+# caches hold by loop device too and forces reading inode info from disk and
+# triggers NULL pointer dereference on buggy ext4
+LOOP_FILE=$TEST_DIR/$seq-$$.img
+LOOP_MNT=$TEST_DIR/$seq-$$.mnt
+mkdir -p $LOOP_MNT
+$XFS_IO_PROG -fc "truncate 512M" $LOOP_FILE >>$seqres.full 2>&1
+LOOP_DEV=`_create_loop_device $LOOP_FILE`
+
+_dmerror_init $LOOP_DEV $LOOP_MNT
+_mkfs_dev $DMERROR_DEV
+# Use strictatime mount option here to force atime updates, which could help
+# trigger the NULL pointer dereference on ext4 more easily
+_dmerror_mount "-o strictatime"
+_dmerror_load_error_table
+
+# drop all caches, force reading from error device
+echo 3 > /proc/sys/vm/drop_caches
+
+# do some test I/O
+ls -l $LOOP_MNT >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "pwrite 0 1M" $LOOP_MNT/testfile >>$seqres.full 2>&1
+
+# no panic no hang, success, all done
+status=0
+exit
diff --git a/tests/generic/338.out b/tests/generic/338.out
new file mode 100644
index 0000000..3482cf4
--- /dev/null
+++ b/tests/generic/338.out
@@ -0,0 +1,2 @@
+QA output created by 338
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 727648c..8818827 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -340,3 +340,4 @@
 335 auto quick metadata
 336 auto quick metadata
 337 auto quick metadata
+338 auto quick rw
-- 
2.5.0

