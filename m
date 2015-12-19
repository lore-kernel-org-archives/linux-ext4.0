From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/11] reflink: test ENOSPC when expanding btrees during
 reflink operations
Date: Sat, 19 Dec 2015 01:11:39 -0800
Message-ID: <20151219091139.15320.86780.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

See what happens when we ENOSPC while growing a btree on behalf of
some reflink operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/805     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/805.out |    8 +++++
 tests/xfs/806     |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/806.out |    7 ++++
 tests/xfs/group   |    2 +
 5 files changed, 188 insertions(+)
 create mode 100755 tests/xfs/805
 create mode 100644 tests/xfs/805.out
 create mode 100755 tests/xfs/806
 create mode 100644 tests/xfs/806.out


diff --git a/tests/xfs/805 b/tests/xfs/805
new file mode 100755
index 0000000..17a7743
--- /dev/null
+++ b/tests/xfs/805
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. 806
+#
+# Try to ENOSPC while expanding the refcntbt by CoWing every block
+# of a file that eats the whole AG.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+
+echo "Create the original files"
+SZ=$((48 * 1048576))
+NR=$((SZ / BLKSZ))
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "CoW every other block"
+_pwrite_byte 0x62 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+#filefrag -v "$TESTDIR/file1" "$TESTDIR/file2"
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/805.out b/tests/xfs/805.out
new file mode 100644
index 0000000..d36ab27
--- /dev/null
+++ b/tests/xfs/805.out
@@ -0,0 +1,8 @@
+QA output created by 805
+Format and mount
+Create the original files
+CoW every other block
+Compare files
+673c759fb131ccf3336c4f8c549a497e  /opt/test-805/file1
+dc802351f6717547cbf4c951b294f952  /opt/test-805/file2
+Check scratch fs
diff --git a/tests/xfs/806 b/tests/xfs/806
new file mode 100755
index 0000000..5e96b8a
--- /dev/null
+++ b/tests/xfs/806
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 806
+#
+# Try to ENOSPC while expanding the refcntbt by CoWing every other block
+# of a file that eats the whole AG.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+BLKSZ="$(stat -f -c '%S' "$TESTDIR")"
+
+echo "Create the original files"
+SZ=$((48 * 1048576))
+NR=$((SZ / BLKSZ))
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 do not match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+echo "CoW every other block"
+seq 1 2 $NR | while read f; do
+	_pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+	_pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 must not match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/806.out b/tests/xfs/806.out
new file mode 100644
index 0000000..be89ea0
--- /dev/null
+++ b/tests/xfs/806.out
@@ -0,0 +1,7 @@
+QA output created by 806
+Format and mount
+Create the original files
+Compare files
+CoW every other block
+Compare files
+Check scratch fs
diff --git a/tests/xfs/group b/tests/xfs/group
index 9884329..b654005 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -226,3 +226,5 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+805 auto quick clone
+806 auto quick clone

