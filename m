From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] generic: test I/O on dm error device
Date: Tue, 15 Mar 2016 16:12:14 +0800
Message-ID: <1458029534-17578-1-git-send-email-eguan@redhat.com>
References: <1457710822-30532-2-git-send-email-eguan@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1457710822-30532-2-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a test that performs simple I/O on dm error device, which
returns EIO on all I/O request.

This is motivated by an ext4 bug that crashes kernel on error path when
trying to update atime. Following kernel patch should fix the issue

  ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

v2:
- use SCRATCH_DEV directly instead of loop device and call
  blockdev --flushbufs $SCRATCH_DEV before drop caches (suggested by Dave)

 tests/generic/338     | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/338.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/generic/338
 create mode 100644 tests/generic/338.out

diff --git a/tests/generic/338 b/tests/generic/338
new file mode 100755
index 0000000..235549a
--- /dev/null
+++ b/tests/generic/338
@@ -0,0 +1,80 @@
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
+_require_scratch
+_require_dm_target error
+# If SCRATCH_DEV is not a valid block device, FSTYP cannot be mkfs'ed either
+_require_block_device $SCRATCH_DEV
+
+echo "Silence is golden"
+
+_dmerror_init
+_mkfs_dev $DMERROR_DEV
+
+# Use strictatime mount option here to force atime updates, which could help
+# trigger the NULL pointer dereference on ext4 more easily
+_dmerror_mount "-o strictatime"
+_dmerror_load_error_table
+
+# flush dmerror block device buffers and drop all caches, force reading from
+# error device
+blockdev --flushbufs $DMERROR_DEV
+echo 3 > /proc/sys/vm/drop_caches
+
+# do some test I/O
+ls -l $SCRATCH_MNT >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "pwrite 0 1M" $SCRATCH_MNT/testfile >>$seqres.full 2>&1
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
1.8.3.1
