From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfstests: make defrag test 222 generic
Date: Tue, 12 Mar 2013 11:42:50 -0500
Message-ID: <513F5B0A.4030405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3CLQmw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 12:42:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

test 222 is just a stress test defragging the test device:

# xfs_fsr QA tests
# run xfs_fsr over the test filesystem to give it a wide and varied set of
# inodes to try to defragment. This is effectively a crash/assert failure
# test looking for corruption induced by xfs_fsr runs.

There's no reason we can't do the same for other filesystems.

Define a new _defrag_dir() helper which just runs noisy/debug
dir defrag for ext4 and/or btrfs as well, and use that in 222
instead of hardcoded xfs_fsr.

Make 222 (and 218) generic; if no defrag is supported it just won't
run.

Change the comments at the top while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/218 b/218
index 77782c6..e337bbf 100755
--- a/218
+++ b/218
@@ -44,7 +44,7 @@ _cleanup()
 . ./common.defrag
 
 # real QA test starts here
-_supported_fs xfs ext4 btrfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/222 b/222
index df2672f..dc4d621 100755
--- a/222
+++ b/222
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 222
 #
-# xfs_fsr QA tests
-# run xfs_fsr over the test filesystem to give it a wide and varied set of
+# defrag QA tests
+# run defrag over the test filesystem to give it a wide and varied set of
 # inodes to try to defragment. This is effectively a crash/assert failure
-# test looking for corruption induced by xfs_fsr runs.
+# test looking for corruption induced by defragmentation runs.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2010 Dave Chinner.  All Rights Reserved.
@@ -44,14 +44,15 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.defrag
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
-[ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
+_require_defrag
 
-xfs_fsr -d -v $TEST_DIR > $seq.full 2>&1
+_defrag_dir $TEST_DIR > $seq.full 2>&1
 
 echo "--- silence is golden ---"
 status=0 ; exit
diff --git a/common.defrag b/common.defrag
index 9c9eb9b..7736330 100644
--- a/common.defrag
+++ b/common.defrag
@@ -69,3 +69,19 @@ _defrag()
 	rm -f $1
 }
 
+# Defrag a whole directory.  No checking as above, just run it, noisily
+# output should be sent to $seq.full since it's very fs-specific
+_defrag_dir()
+{
+    case "$FSTYP" in
+    xfs)
+	$DEFRAG_PROG -d -v $1
+	;;
+    ext4|ext4dev|btrfs)
+	$DEFRAG_PROG -v $1
+	;;
+    *)
+	$DEFRAG_PROG $1
+	;;
+    esac
+}


