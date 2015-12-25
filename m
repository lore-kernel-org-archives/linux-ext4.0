From: Xiong Zhou <xzhou@redhat.com>
Subject: [PATCH v2] shared: test mount needs_recovery extN partition with noload option
Date: Fri, 25 Dec 2015 10:20:49 +0800
Message-ID: <1451010049-14761-1-git-send-email-xzhou@redhat.com>
References: <20151224081010.GI2535@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	dmonakhov@openvz.org, Xiong Zhou <xzhou@redhat.com>
To: eguan@redhat.com
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20151224081010.GI2535@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Once upon a time, ext4 encounter NULL pointer dereference under this
situaiton due to jump to a wrong label. Part of this commit fixed
this Oops:

744692d ext4: use ext4_get_block_write in buffer write

We can also run this test on ext2/3.

This case is based on a script from Monakhov Dmitriy @ openvz.

Cc: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---

v2: skip fsck on scratch.

 tests/shared/003     | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/003.out |  2 ++
 tests/shared/group   |  1 +
 3 files changed, 73 insertions(+)
 create mode 100755 tests/shared/003
 create mode 100644 tests/shared/003.out

diff --git a/tests/shared/003 b/tests/shared/003
new file mode 100755
index 0000000..8e02e82
--- /dev/null
+++ b/tests/shared/003
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test 003
+#
+# Test mount a needs_recovery partition with noload option.
+# ext4 used to Oops until part of this commit:
+#
+# 744692d ext4: use ext4_get_block_write in buffer write
+#
+# Also test on ext2/3.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat Inc.  All Rights Reserved.
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
+# real QA test starts here
+_supported_fs ext2 ext3 ext4
+_supported_os Linux
+
+# nofsck as we modify sb via debugfs
+_require_scratch_nocheck
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+echo "Silence is golden"
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# set needs_recovery feature bit
+debugfs -w -R "feature +needs_recovery" $SCRATCH_DEV \
+	>>$seqres.full 2>&1
+
+# mount with noload option
+_scratch_mount "-o noload" >>$seqres.full 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/shared/003.out b/tests/shared/003.out
new file mode 100644
index 0000000..6895fc8
--- /dev/null
+++ b/tests/shared/003.out
@@ -0,0 +1,2 @@
+QA output created by 003
+Silence is golden
diff --git a/tests/shared/group b/tests/shared/group
index 00d42c8..ba8a3f0 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -5,6 +5,7 @@
 #
 001 auto quick
 002 auto metadata quick
+003 auto quick
 006 auto enospc
 032 mkfs auto quick
 051 acl udf auto quick
-- 
2.5.0
