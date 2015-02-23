From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Mon, 23 Feb 2015 14:39:36 -0800
Message-ID: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com>
Cc: Omar Sandoval <osandov@osandov.com>
To: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38165 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbBWWjt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Feb 2015 17:39:49 -0500
Received: by pdbfp1 with SMTP id fp1so28649493pdb.5
        for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2015 14:39:49 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linux commit 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
fixes several bugs in the FALLOC_FL_PUNCH_HOLE implementation for an
ext4 filesystem with indirect blocks.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 tests/ext4/005     | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/005.out |  29 ++++++++++++++
 tests/ext4/group   |   1 +
 3 files changed, 145 insertions(+)
 create mode 100755 tests/ext4/005
 create mode 100644 tests/ext4/005.out

diff --git a/tests/ext4/005 b/tests/ext4/005
new file mode 100755
index 0000000..d6fb6e9
--- /dev/null
+++ b/tests/ext4/005
@@ -0,0 +1,115 @@
+#! /bin/bash
+# FS QA Test No. 005
+#
+# Test fpunch on an ^extents ext4 filesystem.
+# Regression test for commit:
+# 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Omar Sandoval.  All Rights Reserved.
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
+. ./common/punch
+
+_write_blocks()
+{
+	$XFS_IO_PROG -f -c "pwrite $((1024 * $2)) $((1024 * ($3 - $2)))" $SCRATCH_MNT/$1 | _filter_xfs_io
+	_scratch_unmount
+	_scratch_mount
+}
+
+_punch_blocks()
+{
+	$XFS_IO_PROG -c "fpunch $((1024 * $2)) $((1024 * ($3 - $2)))" $SCRATCH_MNT/$1
+}
+
+_check_blocks()
+{
+	$XFS_IO_PROG -c 'fiemap -v' $SCRATCH_MNT/$1 | _filter_hole_fiemap
+	_md5_checksum $SCRATCH_MNT/$1
+}
+
+_supported_fs ext3 ext4
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+NDIR=12
+ADDRS=$((1024 / 4))
+
+$MKFS_EXT4_PROG -F -b 1024 -O ^extents $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_mount || _fail "couldn't mount fs"
+
+# Bug 1: whole level of indirection is not freed when end is first block of a
+# level.
+_write_blocks testfile1 0 $((NDIR + ADDRS + ADDRS * ADDRS + 4))
+_punch_blocks testfile1 0 $((NDIR + ADDRS + ADDRS * ADDRS))
+_check_blocks testfile1
+
+# Bug 2: end is at higher level than start, end shared branch is not freed.
+_write_blocks testfile2 0 $((NDIR + ADDRS + 2 * ADDRS + 5))
+_punch_blocks testfile2 $((NDIR + ADDRS + 2 * ADDRS)) $((NDIR + ADDRS + 2 * ADDRS + 4))
+_punch_blocks testfile2 0 $((NDIR + ADDRS + 2 * ADDRS + 4))
+_check_blocks testfile2
+
+# Bug 3: start and end are within one level of indirection, extra blocks are
+# freed because partial branches don't converge. (This bug also masks the
+# remaining 2. That is, the test cases for 4 and 5 are also necessarily
+# affected by bug 3.)
+_write_blocks testfile3 0 $((NDIR + ADDRS + 2 * ADDRS))
+_punch_blocks testfile3 $((NDIR + ADDRS + ADDRS / 2)) $((NDIR + ADDRS + ADDRS))
+_check_blocks testfile3
+
+# Bug 4: start and end are within one level of indirection, top of start is not
+# freed.
+_write_blocks testfile4 0 $((NDIR + ADDRS + 4 * ADDRS))
+_punch_blocks testfile4 $((NDIR + ADDRS + ADDRS)) $((NDIR + ADDRS + ADDRS + 1))
+_punch_blocks testfile4 $((NDIR + ADDRS + ADDRS + 1)) $((NDIR + ADDRS + 3 * ADDRS))
+_check_blocks testfile4
+
+# Bug 5: start and end are within one level of indirection, extra blocks beyond
+# end of range are freed when end has top branch.
+_write_blocks testfile5 0 $((NDIR + ADDRS + 4 * ADDRS))
+_punch_blocks testfile5 $((NDIR + ADDRS + 3 * ADDRS)) $((NDIR + ADDRS + 3 * ADDRS + ADDRS / 2))
+_punch_blocks testfile5 $((NDIR + ADDRS + 2)) $((NDIR + ADDRS + 3 * ADDRS + 2))
+_check_blocks testfile5
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/005.out b/tests/ext4/005.out
new file mode 100644
index 0000000..763b4bb
--- /dev/null
+++ b/tests/ext4/005.out
@@ -0,0 +1,29 @@
+QA output created by 005
+wrote 67387392/67387392 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..131607]: hole
+1: [131608..131615]: extent
+1f9503670a2a125a2110d5ad02e8f3ec
+wrote 803840/803840 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..1567]: hole
+1: [1568..1569]: extent
+f1a1a9c1a1cbdb7203b487a14628dad2
+wrote 798720/798720 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..791]: extent
+1: [792..1047]: hole
+2: [1048..1559]: extent
+b03901363691382cbe8ece10d66488f3
+wrote 1323008/1323008 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..1047]: extent
+1: [1048..2071]: hole
+2: [2072..2583]: extent
+78f879dda9cc67b7f543d27bb7a39882
+wrote 1323008/1323008 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..539]: extent
+1: [540..2327]: hole
+2: [2328..2583]: extent
+32b0d65d038d8804fd36ee8aedeff65b
diff --git a/tests/ext4/group b/tests/ext4/group
index e7f1f2a..f6db1da 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -7,6 +7,7 @@
 002 auto quick prealloc
 003 auto quick
 004 auto dump
+005 auto quick
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
-- 
2.3.0

