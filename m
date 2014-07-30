From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3] xfstests/ext4: regression test for wrong assert in ext4_mb_normalize_request()
Date: Wed, 30 Jul 2014 17:27:17 +0800
Message-ID: <1406712437-2184-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <alpine.LFD.2.00.1407231048490.2207@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <lczerner@redhat.com>, Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64585 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751758AbaG3J2J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 05:28:09 -0400
In-Reply-To: <alpine.LFD.2.00.1407231048490.2207@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression test for:
    b5b6077 ext4: fix wrong assert in ext4_mb_normalize_request()

Meanwhile make minor changes to _scratch_mkfs_ext4() in common/rc, _scratch_mkfs_ext4()
might fail due to conflicts between being passed options and MKFS_OPTIONS. We fix this
by ignoring MKFS_OPTIONS if it fails the first time(see _scratch_mkfs_xfs()), as suggested
by Lukas Czerner.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 common/rc          | 39 +++++++++++++++++++++++++++++++++++++-
 tests/ext4/003     | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/003.out |  2 ++
 tests/ext4/group   |  1 +
 4 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100755 tests/ext4/003
 create mode 100644 tests/ext4/003.out

diff --git a/common/rc b/common/rc
index 2c83340..f39e472 100644
--- a/common/rc
+++ b/common/rc
@@ -446,12 +446,31 @@ _setup_large_ext4_fs()
 
 _scratch_mkfs_ext4()
 {
+	# extra mkfs options can be added by tests
+	local extra_mkfs_options=$*
+
 	local tmp_dir=/tmp/
 
-	/sbin/mkfs -t $FSTYP -- -F $MKFS_OPTIONS $* $SCRATCH_DEV \
+	/sbin/mkfs -t ext4 -- -F $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
 			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
 	local mkfs_status=$?
 
+	# a mkfs failure may be caused by conflicts between
+	# $MKFS_OPTIONS and $extra_mkfs_options
+	if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
+		(
+		echo -n "** mkfs failed with extra mkfs options "
+		echo "added to \"$MKFS_OPTIONS\" by test $seq **"
+		echo -n "** attempting to mkfs using only test $seq "
+		echo "options: $extra_mkfs_options **"
+		) >> $seqres.full
+
+		# running mkfs again. overwrite previous mkfs output files
+		/sbin/mkfs -t ext4 -- -F $extra_mkfs_options $SCRATCH_DEV \
+				2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
+		local mkfs_status=$?
+	fi
+
 	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
 		# manually parse the mkfs output to get the fs size in bytes
 		fs_size=`cat $tmp_dir.mkfsstd | awk ' \
@@ -1113,6 +1132,24 @@ _require_xfs_crc()
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

