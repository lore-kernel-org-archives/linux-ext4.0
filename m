Return-Path: <SRS0=KjRz=NV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:38595 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbeKKBAo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 10 Nov 2018 20:00:44 -0500
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <fstests@vger.kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Subject: [PATCH v2] Fstest: ext4: regression test for a ENOSPC warning
Date: Sat, 10 Nov 2018 23:14:49 +0800
Message-Id: <1541862889-34010-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a regression test for a ENOSPC warning which can be triggered if
'-odioread_nolock,nodelalloc' and quota are used.

The bug was fixed by patch
"Ext4: fix ENOSPC when both quota and dioread_nolock are enabled".

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2:
    - Add several _require and fix style and typos.
    - So with 'sync' instead of 'syncfs' the regression couldn't be
      reproduced due to 'sync' could have dirtied quota files ahead of
      writeback.

 tests/ext4/034     | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/034.out |  8 ++++++
 tests/ext4/group   |  1 +
 3 files changed, 85 insertions(+)
 create mode 100755 tests/ext4/034
 create mode 100644 tests/ext4/034.out

diff --git a/tests/ext4/034 b/tests/ext4/034
new file mode 100755
index 00000000..892d7687
--- /dev/null
+++ b/tests/ext4/034
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Liu Bo, Alibaba.  All Rights Reserved.
+#
+# FS QA Test 034
+#
+# Regression test for a ENOSPC warning when both quota and
+# "-o dioread_nolock,nodelalloc" is used.
+#
+# The bug was fixed by commit
+# "Ext4: fix ENOSPC when both quota and dioread_nolock are enabled"
+#
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
+. ./common/quota
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs ext4
+_supported_os Linux
+_require_scratch
+_require_quota
+_require_nobody
+_require_xfs_io_command "syncfs"
+
+echo "Format and mount"
+_scratch_mkfs "-O quota" > $seqres.full 2>&1
+_scratch_mount "-o dioread_nolock,nodelalloc" > $seqres.full 2>&1
+
+echo "Create the original file"
+touch $SCRATCH_MNT/foobar >> $seqres.full
+chown nobody $SCRATCH_MNT/foobar >> $seqres.full
+
+echo "Set hard quota"
+setquota -u nobody 0 10M 0 0 $SCRATCH_MNT
+_report_quota_blocks $SCRATCH_MNT >> $seqres.full
+
+echo "Create 2 level extent tree (btree) for foobar with a unwritten extent"
+$XFS_IO_PROG -f -c "pwrite 0 4k" -c "falloc 4k 4k" -c "pwrite 8k 4k" \
+	     -c "pwrite 20k 4k"  -c "pwrite 28k 4k" -c "pwrite 36k 4k" \
+	     -c "fsync" $SCRATCH_MNT/foobar >> $seqres.full
+
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar >> $seqres.full
+
+echo "Convert unwritten extent to written and collapse extent tree to inode"
+$XFS_IO_PROG -c "pwrite 4k 4k" $SCRATCH_MNT/foobar >> $seqres.full
+
+echo "Create a new file and do fsync to force a jbd2 commit"
+$XFS_IO_PROG -f -c "pwrite 0 4k" -c "fsync" $SCRATCH_MNT/dummy >> $seqres.full
+
+echo "sync $SCRATCH_MNT to writeback"
+$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/034.out b/tests/ext4/034.out
new file mode 100644
index 00000000..0791ef76
--- /dev/null
+++ b/tests/ext4/034.out
@@ -0,0 +1,8 @@
+QA output created by 034
+Format and mount
+Create the original file
+Set hard quota
+Create 2 level extent tree (btree) for foobar with a unwritten extent
+Convert unwritten extent to written and collapse extent tree to inode
+Create a new file and do fsync to force a jbd2 commit
+sync /mnt/scratch to writeback
diff --git a/tests/ext4/group b/tests/ext4/group
index b850f568..eb744a12 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -36,6 +36,7 @@
 031 auto quick dax
 032 auto quick ioctl resize
 033 auto ioctl resize
+034 auto quick quota
 271 auto rw quick
 301 aio auto ioctl rw stress defrag
 302 aio auto ioctl rw stress defrag
-- 
2.14.2
