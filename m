From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfstests 241: run parallel dbench
Date: Tue, 17 Aug 2010 14:39:41 -0500
Message-ID: <4C6AE57D.7090807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0HQTjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Aug 2010 15:39:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 was corrupting inode table bitmaps due to a mishmash of
atomic & nonatomic bitops.  This got broken twice and fixed
twice; let's add a test.

On a 4-way box this reliably ends up with a corrupted filesystem
if we get it wrong (upstream as of 2.6.35 at least is fine again)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

--- /dev/null
+++ b/241
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 241
+#
+# Run parallel dbench & check for filesystem corruption
+# This corrupted ext4 inode bitmaps due to races at one point
+#
+# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
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
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_supported_fs generic
+_supported_os Linux
+
+[ "$DBENCH_PROG" = "" ] && _notrun "dbench not found"
+
+echo "Silence is golden."
+
+# real QA test starts here
+rm -f $seq.full
+
+rm -rf $TEST_DIR/dbench
+mkdir $TEST_DIR/dbench
+
+dbench -t 30 -D $TEST_DIR/dbench 4 >> $seq.full
+
+status=$?
+exit
diff --git a/common.config b/common.config
index 926846b..04bdcf6 100644
--- a/common.config
+++ b/common.config
@@ -149,6 +149,7 @@ export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
 export XFSDUMP_PROG="`set_prog_path xfsdump`"
 export XFSRESTORE_PROG="`set_prog_path xfsrestore`"
 export XFSINVUTIL_PROG="`set_prog_path xfsinvutil`"
+export DBENCH_PROG="`set_prog_path dbench`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.dbench b/common.dbench
index 026acdf..b59be71 100755
--- a/common.dbench
+++ b/common.dbench
@@ -17,7 +17,7 @@
 #
 
 #check dbench is installed
-if [ "`whereis dbench`" == "dbench:"]; then
+if [ "`whereis dbench`" == "dbench:" ]; then
         echo $0 error dbench not installed.
         exit
 fi
diff --git a/group b/group
index afe7614..2baa538 100644
--- a/group
+++ b/group
@@ -354,3 +354,4 @@ deprecated
 238 auto quick metadata ioctl
 239 auto aio rw
 240 auto aio quick rw
+241 auto

