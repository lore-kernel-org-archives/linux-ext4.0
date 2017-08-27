From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH] fstests: regression test for ext4 crash consistency bug
Date: Sun, 27 Aug 2017 13:21:30 +0300
Message-ID: <1503829290-10103-1-git-send-email-amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37620 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdH0KVG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Aug 2017 06:21:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This test is motivated by a bug found in ext4 during random crash
consistency tests.

This test uses device mapper flakey target to demonstrate the bug
found using device mapper log-writes target.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Ted,

While working on crash consistency xfstests [1], I stubmled on what
appeared to be an ext4 crash consistency bug.

The tests I used rely on the log-writes dm target code written
by Josef Bacik, which had little exposure to the wide community
as far as I know.  I wanted to prove to myself that the found
inconsistency was not due to a test bug, so I bisected the failed
test to the minimal operations that trigger the failure and wrote
a small independent test to reproduce the issue using dm flakey target.

The following fsck error is reliably reproduced by replaying 3 fsx ops
(write, zero_range, mapwrite) on overlapping regions, then
emulating a crash, followed by mount and umount:

  ./ltp/fsx -d --replay-ops /tmp/8995.fsxops /mnt/scratch/testfile
  1 write 0x3e5ec thru    0x3ffff (0x1a14 bytes)
  2 zero  from 0x20fac to 0x27d48, (0x6d9c bytes)
  3 mapwrite      0x216ad thru    0x23dfb (0x274f bytes)
  All 4 operations completed A-OK!
  _check_generic_filesystem: filesystem on /dev/mapper/ssd-scratch is inconsistent
  *** fsck.ext4 output ***
  fsck from util-linux 2.27.1
  e2fsck 1.42.13 (17-May-2015)
  Pass 1: Checking inodes, blocks, and sizes
  Inode 12, i_size is 147456, should be 163840.  Fix? no

Note that the inconsistency is "applied" by journal replay during mount.
fsck -nf before mount does not report any errors.

I did not intend for this test to be merged as is, but rather to be used
by ext4 developers to analyze the problem and then re-write the test with
more comments and less arbitrary offset/length values.

P.S.: crash consistency tests also reliably reproduce a btrfs fsck error.
      a detailed report with I/O recording was sent to Josef.
P.S.2: crash consistency tests report file data checksum errors on xfs
       after fsync+crash, but I still need to prove the reliability of
       these reports.
 
[1] https://github.com/amir73il/xfstests/commits/dm-log-writes

 tests/generic/501     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/501.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/generic/501
 create mode 100644 tests/generic/501.out

diff --git a/tests/generic/501 b/tests/generic/501
new file mode 100755
index 0000000..6e672b9
--- /dev/null
+++ b/tests/generic/501
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test No. 501
+#
+# This test is motivated by a bug found in ext4 during random crash
+# consistency tests.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+
+_cleanup()
+{
+	_cleanup_flakey
+	cd /
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_dm_target flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+_init_flakey
+_mount_flakey
+
+fsxops=$tmp.fsxops
+cat <<EOF > $fsxops
+write 0x3e5ec 0x1a14 0x21446
+zero_range 0x20fac 0x6d9c 0x40000 keep_size
+mapwrite 0x216ad 0x274f 0x40000
+EOF
+run_check $here/ltp/fsx -d --replay-ops $fsxops $SCRATCH_MNT/testfile
+
+_flakey_drop_and_remount
+_unmount_flakey
+_cleanup_flakey
+_check_scratch_fs
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/generic/501.out b/tests/generic/501.out
new file mode 100644
index 0000000..00133b6
--- /dev/null
+++ b/tests/generic/501.out
@@ -0,0 +1,2 @@
+QA output created by 501
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 044ec3f..f22b635 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -453,3 +453,4 @@
 448 auto quick rw
 449 auto quick acl enospc
 450 auto quick rw
+501 auto quick metadata
-- 
2.7.4
