From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2] ext4: regression test for wrong assert in ext4_mb_normalize_request()
Date: Mon, 21 Jul 2014 11:27:05 +0800
Message-ID: <1405913225-1920-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <53CC87A0.1060204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <lczerner@redhat.com>, Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16372 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752007AbaGUD14 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2014 23:27:56 -0400
In-Reply-To: <53CC87A0.1060204@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression test for:
    b5b6077 ext4: fix wrong assert in ext4_mb_normalize_request()

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 common/rc          | 18 ++++++++++++++++++
 tests/ext4/003     | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/003.out |  2 ++
 tests/ext4/group   |  1 +
 4 files changed, 76 insertions(+)
 create mode 100755 tests/ext4/003
 create mode 100644 tests/ext4/003.out

diff --git a/common/rc b/common/rc
index 2c83340..018e569 100644
--- a/common/rc
+++ b/common/rc
@@ -1113,6 +1113,24 @@ _require_xfs_crc()
 	umount $SCRATCH_MNT
 }
 
+# this test requires the bigalloc feature to be available in mkfs.ext4
+#
+_require_ext4_mkfs_bigalloc()
+{
+	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1 \
+	   || _notrun "mkfs.ext4 doesn't have bigalloc feature"
+}
+
+# this test requires the ext4 kernel support bigalloc feature
+#
+_require_ext4_bigalloc()
+{
+	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1
+	_scratch_mount >/dev/null 2>&1 \
+	   || _notrun "Ext4 kernel doesn't support bigalloc feature"
+	umount $SCRATCH_MNT
+}
+
 # this test requires the finobt feature to be available in mkfs.xfs
 #
 _require_xfs_mkfs_finobt()
diff --git a/tests/ext4/003 b/tests/ext4/003
new file mode 100755
index 0000000..4ca282f
--- /dev/null
+++ b/tests/ext4/003
@@ -0,0 +1,55 @@
+#! /bin/bash
+# FS QA Test No. ext4/003
+#
+# Regression test for commit:
+# b5b6077 ext4: fix wrong assert in ext4_mb_normalize_request()
+# This testcase checks whether this bug has been fixed.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
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
+_require_ext4_mkfs_bigalloc
+_require_ext4_bigalloc
+
+rm -f $seqres.full
+
+yes | mkfs.ext4 -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
+    >> $seqres.full 2>&1
+_scratch_mount || _fail "couldn't mount fs"
+
+dd if=/dev/zero of=$SCRATCH_MNT/testfile bs=1M count=256 2>&1 | _filter_dd
+
+echo "Slience is golden"
+
+status=0
+exit
diff --git a/tests/ext4/003.out b/tests/ext4/003.out
new file mode 100644
index 0000000..07f245d
--- /dev/null
+++ b/tests/ext4/003.out
@@ -0,0 +1,2 @@
+QA output created by 003
+Slience is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index 7e66035..152196c 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -5,6 +5,7 @@
 #
 001 auto prealloc quick
 002 auto quick prealloc
+003 auto quick
 271 auto rw quick
 301 aio dangerous ioctl rw stress
 302 aio dangerous ioctl rw stress
-- 
1.8.2.1

