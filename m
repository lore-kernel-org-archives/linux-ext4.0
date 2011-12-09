From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: [PATCH] xfstests: 277 new test to check freeze/unfreeze works well or not under heavy load.
Date: Fri, 09 Dec 2011 14:52:31 +0900
Message-ID: <20111209145231.5A5F.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53268 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1LIFwp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2011 00:52:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

unfreeze function, thaw_super(), sometimes hangs up if flush kernel
thread does writeback to the same filesystem concurrently.
(the problem is reported at
 http://marc.info/?l=linux-ext4&m=132339590004560&w=2)

This test runs freeze/unfreeze under heavy load. If the problem is
reproduced, this test will hang up...

Signed-off-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
---
 277     |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 277.out |    5 ++++
 group   |    1 +
 3 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100755 277
 create mode 100644 277.out

diff --git a/277 b/277
new file mode 100755
index 0000000..1cfa1b4
--- /dev/null
+++ b/277
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FSQA Test No. 277
+#
+# Run fsstress and freeze/unfreeze in parallel, check freeze/unfreeze
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
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
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=m.mizuma@jp.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0 # success is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_workout()
+{
+	echo ""
+	echo "Run fsstress"
+	echo ""
+	num_iterations=500
+	out=$SCRATCH_MNT/fsstress.$$
+	args="-p100 -n10000 -d $out"
+	echo "fsstress $args" >> $here/$seq.full
+	$FSSTRESS_PROG $args > /dev/null 2>&1 &
+	pid=$!
+	echo "Run xfs_freeze in parallel"
+	for ((i=0; i < num_iterations; i++))
+	do
+		xfs_freeze -f $SCRATCH_MNT | tee -a $seq.full
+		xfs_freeze -u $SCRATCH_MNT | tee -a $seq.full
+	done
+	kill $pid 2> /dev/null
+	wait $pid
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount
+
+if ! _workout; then
+	umount $SCRATCH_DEV 2>/dev/null
+	exit
+fi
+
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit
diff --git a/277.out b/277.out
new file mode 100644
index 0000000..2cd57ec
--- /dev/null
+++ b/277.out
@@ -0,0 +1,5 @@
+QA output created by 277
+
+Run fsstress
+
+Run xfs_freeze in parallel
diff --git a/group b/group
index dd9f00d..24b8bd1 100644
--- a/group
+++ b/group
@@ -390,3 +390,4 @@ deprecated
 274 auto rw
 275 auto rw
 276 auto rw metadata
+277 other auto
-- 
1.7.1

Thanks,
Masayoshi Mizuma



