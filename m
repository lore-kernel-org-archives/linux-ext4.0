From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] xfstests 299-305: remove fio config files after finished test
Date: Sun, 24 Mar 2013 20:14:26 +0800
Message-ID: <1364127266-13325-1-git-send-email-wenqing.lz@taobao.com>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46487 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3CXL65 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Mar 2013 07:58:57 -0400
Received: by mail-pb0-f41.google.com with SMTP id mc8so375577pbc.14
        for <linux-ext4@vger.kernel.org>; Sun, 24 Mar 2013 04:58:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After finished test, temporarily fio config file should be removed.
Meanwhile in #305 poweron_scratch_dev is removed because no one uses
it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>
---
 299 |  9 +++++----
 300 |  9 +++++----
 301 |  9 +++++----
 302 |  9 +++++----
 303 |  9 +++++----
 304 |  9 +++++----
 305 | 11 ++++++-----
 7 files changed, 36 insertions(+), 29 deletions(-)
 mode change 100644 => 100755 299
 mode change 100644 => 100755 300
 mode change 100644 => 100755 301
 mode change 100644 => 100755 302
 mode change 100644 => 100755 303
 mode change 100644 => 100755 304
 mode change 100644 => 100755 305

diff --git a/299 b/299
old mode 100644
new mode 100755
index 4305ead..20bef89
--- a/299
+++ b/299
@@ -31,6 +31,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -48,7 +49,7 @@ NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 FILE_SIZE=$((BLK_DEV_SIZE * 512))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 ###########
 # $seq test fio activity
 # Filenames derived from jobsname and jobid like follows:
@@ -109,15 +110,15 @@ rw=randrw
 filename=buffered-aio-verifier
 EOF
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _workout()
 {
 	echo ""
 	echo "Run fio with random aio-dio pattern"
 	echo ""
-	cat $tmp-$seq.fio >>  $seq.full
-	run_check $FIO_PROG $tmp-$seq.fio &
+	cat $fio_config >>  $seq.full
+	run_check $FIO_PROG $fio_config &
 	pid=$!
 	echo "Start fallocate/truncate loop"
 
diff --git a/300 b/300
old mode 100644
new mode 100755
index 73c9ea7..54349c0
--- a/300
+++ b/300
@@ -31,6 +31,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -52,7 +53,7 @@ then
 fi
 FS_SIZE=$((BLK_DEV_SIZE * 512))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 ###########
 # $seq test fio activity
 # Run DIO, fallocate and punch_hole threads on a single in parallel
@@ -129,11 +130,11 @@ _workout()
 	echo ""
 	echo "Run fio with random aio-dio pattern"
 	echo ""
-	cat $tmp-$seq.fio >>  $seq.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seq.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs_sized $FS_SIZE >> $seq.full 2>&1
 _scratch_mount
diff --git a/301 b/301
old mode 100644
new mode 100755
index fe2e59f..280fd02
--- a/301
+++ b/301
@@ -29,6 +29,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -50,7 +51,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # reserve 30% in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -103,11 +104,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seq.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seq.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seq.full 2>&1
 _scratch_mount
diff --git a/302 b/302
old mode 100644
new mode 100755
index e3dceb8..6a987ad
--- a/302
+++ b/302
@@ -30,6 +30,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -50,7 +51,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # reserve 30% in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -119,11 +120,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seq.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seq.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seq.full 2>&1
 _scratch_mount
diff --git a/303 b/303
old mode 100644
new mode 100755
index 4141442..8af56b3
--- a/303
+++ b/303
@@ -30,6 +30,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -50,7 +51,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # Reserve space for 4 files in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (3+1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -129,11 +130,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seq.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seq.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seq.full 2>&1
 _scratch_mount
diff --git a/304 b/304
old mode 100644
new mode 100755
index 5c414bd..45b9e2b
--- a/304
+++ b/304
@@ -31,6 +31,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -51,7 +52,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # reserve 30% in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -106,11 +107,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seq.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seq.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seq.full 2>&1
 _scratch_mount
diff --git a/305 b/305
old mode 100644
new mode 100755
index 6393461..7e5b1a2
--- a/305
+++ b/305
@@ -30,6 +30,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 
 # get standard environment, filters and checks
@@ -78,8 +79,8 @@ stop_fail_scratch_dev()
 
 _cleanup()
 {
-    poweron_scratch_dev
     disallow_fail_make_request
+    rm -f $tmp.*
 }
 trap "_cleanup; exit \$status" 1 2 3 15
 
@@ -88,7 +89,7 @@ NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 FILE_SIZE=$((BLK_DEV_SIZE * 512))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 ###########
 # $seq test's fio activity
 # Filenames derived from jobsname and jobid like follows:
@@ -128,7 +129,7 @@ time_based
 
 EOF
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 # Disable all sync operations to get higher load
 FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0 -f setattr=1"
@@ -144,8 +145,8 @@ _workout()
 	$FSSTRESS_PROG $args > /dev/null 2>&1 &
 	fs_pid=$!
 	echo "Start fio.."
-	cat $tmp-$seq.fio >>  $seq.full
-	$FIO_PROG $tmp-$seq.fio >> $here/$seq.full 2>&1 &
+	cat $fio_config >>  $seq.full
+	$FIO_PROG $fio_config >> $here/$seq.full 2>&1 &
 	fio_pid=$!
 
 	# Let's it work for awhile, and force device failure
-- 
1.7.12.rc2.18.g61b472e

