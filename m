From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2] generic: regression tests for ext4 ^extents punch hole
Date: Fri, 27 Feb 2015 17:29:06 -0800
Message-ID: <b4af323097a2bf6b792f1b8bd6beac774a6cf3bf.1425085875.git.osandov@osandov.com>
Cc: Omar Sandoval <osandov@osandov.com>
To: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Czerner?= <lczerner@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43063 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbbB1B30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Feb 2015 20:29:26 -0500
Received: by paceu11 with SMTP id eu11so26852661pac.10
        for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2015 17:29:25 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linux commit 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
fixes several bugs in the FALLOC_FL_PUNCH_HOLE implementation for an
ext4 filesystem with indirect blocks. This is a regression test when run
on ext4 with 4K blocks and a generic fpunch test on anything else, with
the advantage that it doesn't depend on falloc like the other fpunch
tests.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
Hi, everyone,

Here's another go at this, now as a generic test. It turns out that making the
output blocksize-independent isn't easy. We can't just scale things linearly
because the number of blocks in an indirect level is different based on the
blocksize. So, I just settled on using 4k blocks. If the test is run on ext4
with a different block size, it doesn't actually test the original bugs, but I
think that's okay.

I also went for the special case for ext4, because, like Lukas mentioned, I
don't know how much coverage that code will get otherwise. It looks like
_scratch_mkfs_ext4 already handles conflicting test options in the same way as
_scratch_mkfs_xfs.

Summary of changes from v1:

- Move test to generic with special case for ext4
- Use 4k blocks by default

Thanks!

 tests/generic/080     | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/080.out |  29 ++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 156 insertions(+)
 create mode 100755 tests/generic/080
 create mode 100644 tests/generic/080.out

diff --git a/tests/generic/080 b/tests/generic/080
new file mode 100755
index 0000000..1e67493
--- /dev/null
+++ b/tests/generic/080
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FS QA Test No. 080
+#
+# Test fpunch on an ^extents ext4 filesystem.
+# Regression test for commit:
+# 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
+#
+# The regression is exercised on ext4 when the blocksize is 4K. Otherwise, this
+# is just a generic fpunch test which doesn't depend on falloc.
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
+# The test output depends on this blocksize, but this doesn't have to be the
+# same as the filesystem block size for the test to pass.
+BLOCKSIZE=4096
+NDIR=12
+ADDRS=$((BLOCKSIZE / 4))
+
+_write_blocks()
+{
+	$XFS_IO_PROG -f -c "pwrite $((BLOCKSIZE * $2)) $((BLOCKSIZE * ($3 - $2)))" $SCRATCH_MNT/$1 | _filter_xfs_io
+	_scratch_unmount
+	_scratch_mount
+}
+
+_punch_blocks()
+{
+	$XFS_IO_PROG -c "fpunch $((BLOCKSIZE * $2)) $((BLOCKSIZE * ($3 - $2)))" $SCRATCH_MNT/$1
+}
+
+_check_blocks()
+{
+	$XFS_IO_PROG -c 'fiemap -v' $SCRATCH_MNT/$1 | _filter_hole_fiemap
+	_md5_checksum $SCRATCH_MNT/$1
+}
+
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+if [ "$FSTYP" = "ext4" ]; then
+	# Special case to ensure that this configuration gets some coverage.
+	_scratch_mkfs -O ^extents >> $seqres.full 2>&1
+else
+	_scratch_mkfs >> $seqres.full 2>&1
+fi
+_scratch_mount || _fail "couldn't mount fs"
+
+# Bug 1: whole level of indirection is not freed when end is first block of a
+# level.
+_write_blocks testfile1 0 $((NDIR + ADDRS + ADDRS * ADDRS + 4))
+_punch_blocks testfile1 0 $((NDIR + ADDRS + ADDRS * ADDRS))
+_check_blocks testfile1
+
+# Bug 2: end is at higher level than start, end shared branch is not freed.
+_write_blocks testfile2 0 $((NDIR + ADDRS + 2 * ADDRS + 8))
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
+_write_blocks testfile4 0 $((NDIR + ADDRS + 8 * ADDRS))
+_punch_blocks testfile4 $((NDIR + ADDRS + ADDRS)) $((NDIR + ADDRS + ADDRS + 4))
+_punch_blocks testfile4 $((NDIR + ADDRS + ADDRS + 4)) $((NDIR + ADDRS + 4 * ADDRS))
+_check_blocks testfile4
+
+# Bug 5: start and end are within one level of indirection, extra blocks beyond
+# end of range are freed when end has top branch.
+_write_blocks testfile5 0 $((NDIR + ADDRS + 4 * ADDRS))
+_punch_blocks testfile5 $((NDIR + ADDRS + 2 * ADDRS)) $((NDIR + ADDRS + 2 * ADDRS + ADDRS / 2))
+_punch_blocks testfile5 $((NDIR + ADDRS + 2)) $((NDIR + ADDRS + 2 * ADDRS + 2))
+_check_blocks testfile5
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/080.out b/tests/generic/080.out
new file mode 100644
index 0000000..5301f80
--- /dev/null
+++ b/tests/generic/080.out
@@ -0,0 +1,29 @@
+QA output created by 080
+wrote 4299227136/4299227136 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..8396895]: hole
+1: [8396896..8396927]: extent
+ca385f8981956660e3d698c0ca810e1b
+wrote 12664832/12664832 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..24703]: hole
+1: [24704..24735]: extent
+1e2dda6f86f5d983a4a02c64da902fe4
+wrote 12632064/12632064 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..12383]: extent
+1: [12384..16479]: hole
+2: [16480..24671]: extent
+e47bb56af5783e0a1022e00b25abefb2
+wrote 37797888/37797888 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..16479]: extent
+1: [16480..41055]: hole
+2: [41056..73823]: extent
+337983ee561a9b756d21a29757fb4f62
+wrote 21020672/21020672 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0: [0..8303]: extent
+1: [8304..28767]: hole
+2: [28768..41055]: extent
+eb0e1b76f866926089efe70d713a938c
diff --git a/tests/generic/group b/tests/generic/group
index e5db772..2c717b3 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -77,6 +77,7 @@
 076 metadata rw udf auto quick stress
 077 acl attr auto enospc
 079 acl attr ioctl metadata auto quick
+080 auto
 083 rw auto enospc stress
 088 perms auto quick
 089 metadata auto
-- 
2.3.1

