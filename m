From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] ext4: test partial blocksize defrag integrity issue
Date: Wed, 10 Feb 2016 23:17:44 +0800
Message-ID: <1455117464-15565-1-git-send-email-eguan@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Calling EXT4_IOC_MOVE_EXTENT on file not aligned with block size and
block size is smaller than page size would cause integrity issue on the
partial-blocksize part when copying data between orign file and donor
file.

This ext4 kernel patch would fix it, titled
"ext4: don't read blocks from disk after extents being swapped in
move_extent_per_page())"

Though this bug only happens in the blocksize smaller than pagesize
case, there's no harm to test on various block size fs, so no block size
is specified in the test, it depends on the test configurations.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/ext4/020     | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/020.out |  6 ++++
 tests/ext4/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/ext4/020
 create mode 100644 tests/ext4/020.out

diff --git a/tests/ext4/020 b/tests/ext4/020
new file mode 100755
index 0000000..6740c7e
--- /dev/null
+++ b/tests/ext4/020
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test 020
+#
+# Test partial blocksize defrag integrity issue.
+#
+# Calling EXT4_IOC_MOVE_EXTENT on file not aligned with block size and block
+# size is smaller than page size would cause integrity issue on the
+# partial-blocksize part when copying data between orign file and donor file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc. All Rights Reserved.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/defrag
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+_require_scratch
+_require_defrag
+
+e4compact=$here/src/e4compact
+if [ ! -x $d4compact ]; then
+	_notrun "$e4compact executable not found"
+fi
+
+testfile=$SCRATCH_MNT/$seq.orig
+donorfile=$SCRATCH_MNT/$seq.donor
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# reserve space for donor file, written by 0xaa and sync to disk to avoid
+# EBUSY on EXT4_IOC_MOVE_EXT
+$XFS_IO_PROG -fc "pwrite -S 0xaa 0 1m" -c "fsync" $donorfile | _filter_xfs_io
+
+# create test file with 1023 in size, written by 0xbb
+# 1023 is smaller than 1k and works for any block size filesystems
+$XFS_IO_PROG -fc "pwrite -S 0xbb 0 1023" -c "fsync" $testfile | _filter_xfs_io
+
+# compute initial md5sum
+md5sum $testfile > $tmp.md5sum
+
+# drop cache, force e4compact to read data from disk
+echo 3 > /proc/sys/vm/drop_caches
+
+# test defrag
+echo "$testfile" | $e4compact -i -v -f $donorfile >>$seqres.full
+
+# check md5sum
+md5sum -c $tmp.md5sum | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/020.out b/tests/ext4/020.out
new file mode 100644
index 0000000..74d0543
--- /dev/null
+++ b/tests/ext4/020.out
@@ -0,0 +1,6 @@
+QA output created by 020
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1023/1023 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+SCRATCH_MNT/020.orig: OK
diff --git a/tests/ext4/group b/tests/ext4/group
index 1191441..9e28159 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -22,6 +22,7 @@
 017 fuzzers
 018 fuzzers
 019 fuzzers
+020 auto quick ioctl rw
 271 auto rw quick
 301 aio auto ioctl rw stress
 302 aio auto ioctl rw stress
-- 
2.5.0
