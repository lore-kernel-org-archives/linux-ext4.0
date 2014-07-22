From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] xfstests: add data integtiry test for e4defrag ext4/307
Date: Wed, 23 Jul 2014 00:37:34 +0400
Message-ID: <1406061455-731-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:33829 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaGVUhp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:37:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/307     |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/307.out |    5 +++
 tests/ext4/group   |    1 +
 3 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100755 tests/ext4/307
 create mode 100644 tests/ext4/307.out

diff --git a/tests/ext4/307 b/tests/ext4/307
new file mode 100755
index 0000000..99da61f
--- /dev/null
+++ b/tests/ext4/307
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. ext4/307
+# 
+# Test defrag for a single file
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+PIDS=""
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    _scratch_unmount
+}
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/defrag
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_need_to_be_root
+_require_scratch
+_require_defrag
+
+rm -f $seqres.full
+
+_workout()
+{
+    	nr=$1
+	echo "Defragment file with $nr * 2 fragments"
+	# Create sparse file
+    	for ((i=0;i<nr;i++))
+	do
+	    fallocate -l 4k -o $((409600*i)) $SCRATCH_MNT/test.$nr
+	done
+	# Fill holes for half of range , as result file will contain nr*1.5 fragments
+	fallocate -l $((204800*nr)) $SCRATCH_MNT/test.$nr
+	# Data wrilte will convert extetns to inialized ones
+    	for ((i=0;i<nr;i++))
+	do
+	    dd if=/dev/urandom bs=1234 seek=$((100*i)) of=$SCRATCH_MNT/test.$nr \
+		conv=notrunc count=3 >> $seqres.full 2>&1
+	done
+	filefrag -v $SCRATCH_MNT/test.$nr >> $seqres.full
+	sha1sum $SCRATCH_MNT/test.$nr > $SCRATCH_MNT/test.$nr.sha1sum
+	$DEFRAG_PROG $SCRATCH_MNT $SCRATCH_DEV >> $seqres.full 2>&1
+	filefrag -v $SCRATCH_MNT/test.$nr >> $seqres.full
+	run_check sha1sum -c $SCRATCH_MNT/test.$nr.sha1sum
+}
+
+
+# Actual testing starting from here
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+_workout 10
+_workout 250
+_workout 500
+_workout 1000
+_check_scratch_fs
+status=$?
diff --git a/tests/ext4/307.out b/tests/ext4/307.out
new file mode 100644
index 0000000..e231d11
--- /dev/null
+++ b/tests/ext4/307.out
@@ -0,0 +1,5 @@
+QA output created by 307
+Defragment file with 10 * 2 fragments
+Defragment file with 250 * 2 fragments
+Defragment file with 500 * 2 fragments
+Defragment file with 1000 * 2 fragments
diff --git a/tests/ext4/group b/tests/ext4/group
index 7e66035..5c5cb05 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -12,3 +12,4 @@
 304 aio dangerous ioctl rw stress
 305 auto
 306 auto rw resize quick
+307 auto ioctl rw quick
-- 
1.7.1

