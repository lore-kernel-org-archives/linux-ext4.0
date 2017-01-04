From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH v2 1/1] xfstests: ext4/023: reproduces incorrect right shift (insert range)
Date: Wed,  4 Jan 2017 20:08:06 +0100
Message-ID: <20170104190806.10795-1-roman.penyaev@profitbricks.com>
Cc: Roman Pen <roman.penyaev@profitbricks.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Test tries to insert many blocks at the same offset to reproduce
the following layout:

   block #0  block #1
   |ext0 ext1|ext2 ext3 ...|
        ^
     insert of a new block

Because of an incorrect range first block is never reached,
thus ext1 is untouched, resulting to a hole at a wrong offset:

What we got:

   block #0   block #1
   |ext0 ext1|   ext2 ext3 ...|
              ^
              hole at a wrong offset

What we expect:

   block #0    block #1
   |ext0   ext1|ext2 ext3 ...|
        ^
        hole at a correct offset

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: "Theodore Ts'o <tytso@mit.edu>"
Cc: linux-ext4@vger.kernel.org
Cc: fstests@vger.kernel.org
---
v1..v2:

'_require_xfs_io_command "finsert"' line was added to prevent
the test to fail on "ext3", "bigalloc" and "bigalloc_1k"
configurations.

 tests/ext4/023     | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/023.out |   2 +
 tests/ext4/group   |   1 +
 3 files changed, 128 insertions(+)
 create mode 100755 tests/ext4/023
 create mode 100644 tests/ext4/023.out

diff --git a/tests/ext4/023 b/tests/ext4/023
new file mode 100755
index 000000000000..2cd890731eb5
--- /dev/null
+++ b/tests/ext4/023
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test 023
+#
+# Regression test which reproduces an incorrect right shift
+# (insert range) for the first extent in a range.
+#
+# Test tries to insert many blocks at the same offset to reproduce
+# the following layout:
+#
+#    block #0  block #1
+#    |ext0 ext1|ext2 ext3 ...|
+#         ^
+#      insert of a new block
+#
+# Because of an incorrect range first block is never reached,
+# thus ext1 is untouched, resulting to a hole at a wrong offset:
+#
+# What we got:
+#
+#    block #0   block #1
+#    |ext0 ext1|   ext2 ext3 ...|
+#               ^
+#               hole at a wrong offset
+#
+# What we expect:
+#
+#    block #0    block #1
+#    |ext0   ext1|ext2 ext3 ...|
+#         ^
+#         hole at a correct offset
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Roman Penyaev.  All Rights Reserved.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs ext4
+_supported_os Linux
+_require_test
+_require_dumpe2fs
+_require_xfs_io_command "finsert"
+
+pattern=$tmp
+testfile=$TEST_DIR/023.file
+
+blksize=`$DUMPE2FS_PROG -h $TEST_DEV 2>/dev/null | grep "Block size" | \
+	awk '{print $3}'`
+
+# Generate a block with a repeating number represented as 4 bytes decimal.
+function generate_pattern() {
+	blkind=$1
+	printf "%04d" $blkind | awk  '{ while (c++ < '$(($blksize/4))') \
+		printf "%s", $0 }' > $pattern
+}
+
+echo -n > $testfile
+$XFS_IO_PROG -c "falloc 0 $(($blksize * 2))" $testfile \
+			 >> $seqres.full 2>&1
+
+# First block, has 0001 as a pattern
+generate_pattern 1
+$XFS_IO_PROG -c "pwrite -i $pattern        0 $blksize" $testfile \
+			 >> $seqres.full 2>&1
+
+# Second block, has 0002 as a pattern
+generate_pattern 2
+$XFS_IO_PROG -c "pwrite -i $pattern $blksize $blksize" $testfile \
+			 >> $seqres.full 2>&1
+
+# Insert 998 blocks after the first block
+for (( block=3; block<=1000; block++ )); do
+	$XFS_IO_PROG -c "finsert $blksize $blksize" $testfile \
+				 >> $seqres.full 2>&1
+
+	generate_pattern $block
+	$XFS_IO_PROG -c "pwrite -i $pattern $blksize $blksize" $testfile \
+				 >> $seqres.full 2>&1
+done
+
+# Avoid offsets because block size can vary.
+# Expected blocks content is the following:
+#   0001 1000 0999 0998 ... 0002
+hexdump -e '16/1 "%_p" "\n"' $testfile | md5sum
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/023.out b/tests/ext4/023.out
new file mode 100644
index 000000000000..383e305d43fa
--- /dev/null
+++ b/tests/ext4/023.out
@@ -0,0 +1,2 @@
+QA output created by 023
+d1c3b6f63c5420ca8248ca380a8c00cb  -
diff --git a/tests/ext4/group b/tests/ext4/group
index 53fe03e87083..ace5cf1a3d47 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -25,6 +25,7 @@
 020 auto quick ioctl rw
 021 auto quick
 022 auto quick attr dangerous
+023 auto quick
 271 auto rw quick
 301 aio auto ioctl rw stress
 302 aio auto ioctl rw stress
-- 
2.10.2
