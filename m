From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] tests: fix resize test tmpfs max-file-size checking
Date: Fri, 21 Mar 2014 03:51:54 -0600
Message-ID: <1395395514-5548-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:63489 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759875AbaCUJv4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Mar 2014 05:51:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Old distros may not have the "truncate" tool, so use "dd" instead.

If tmpfs cannot handle a 2GB temp file (e.g. old RHEL5 and SLES 11
kernels) then skip the test instead of failing it.  If this fails,
try to report better error messages instead of failing silently.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 tests/r_1024_small_bg/script       |    9 +++++++--
 tests/r_64bit_big_expand/script    |    1 +
 tests/r_bigalloc_big_expand/script |    1 +
 tests/r_ext4_big_expand/script     |    1 +
 tests/r_ext4_small_bg/script       |    9 +++++++--
 tests/scripts/resize_test          |   17 ++++++++++++++---
 6 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/tests/r_1024_small_bg/script b/tests/r_1024_small_bg/script
index fafcf91..f86537e 100644
--- a/tests/r_1024_small_bg/script
+++ b/tests/r_1024_small_bg/script
@@ -10,12 +10,17 @@ E2FSCK=../e2fsck/e2fsck
 
 . $cmd_dir/scripts/resize_test
 
-if resize_test
-then
+resize_test
+RC=$?
+if [ $RC -eq 0 ]; then
 	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
+elif [ $RC -eq 111 ]; then
+	echo "$test_name: $test_description: skipped"
+	touch $test_name.ok
 else
 	echo "$test_name: $test_description: failed"
+ 	ln $LOG $test_name.failed
 	touch $test_name.failed
 fi
 
diff --git a/tests/r_64bit_big_expand/script b/tests/r_64bit_big_expand/script
index 51f36e9..2a8fef0 100644
--- a/tests/r_64bit_big_expand/script
+++ b/tests/r_64bit_big_expand/script
@@ -20,6 +20,7 @@ elif [ $RC -eq 111 ]; then
 	touch $test_name.ok
 else
 	echo "$test_name: $test_description: failed"
+	ln $LOG $test_name.failed
 	touch $test_name.failed
 fi
 
diff --git a/tests/r_bigalloc_big_expand/script b/tests/r_bigalloc_big_expand/script
index 56c8c15..2f28c67 100644
--- a/tests/r_bigalloc_big_expand/script
+++ b/tests/r_bigalloc_big_expand/script
@@ -20,6 +20,7 @@ elif [ $RC -eq 111 ]; then
 	touch $test_name.ok
 else
 	echo "$test_name: $test_description: failed"
+	ln $LOG $test_name.failed
 	touch $test_name.failed
 fi
 
diff --git a/tests/r_ext4_big_expand/script b/tests/r_ext4_big_expand/script
index a4f8fe6..3b969d2 100644
--- a/tests/r_ext4_big_expand/script
+++ b/tests/r_ext4_big_expand/script
@@ -20,6 +20,7 @@ elif [ $RC -eq 111 ]; then
 	touch $test_name.ok
 else
 	echo "$test_name: $test_description: failed"
+	ln $LOG $test_name.failed
 	touch $test_name.failed
 fi
 
diff --git a/tests/r_ext4_small_bg/script b/tests/r_ext4_small_bg/script
index 553cbd8..dafb008 100644
--- a/tests/r_ext4_small_bg/script
+++ b/tests/r_ext4_small_bg/script
@@ -10,12 +10,17 @@ E2FSCK=../e2fsck/e2fsck
 
 . $cmd_dir/scripts/resize_test
 
-if resize_test
-then
+resize_test
+RC=$?
+if [ $RC -eq 0 ]; then
 	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
+elif [ $RC -eq 111 ]; then
+	echo "$test_name: $test_description: skipped"
+	touch $test_name.ok
 else
 	echo "$test_name: $test_description: failed"
+	ln $LOG $test_name.failed
 	touch $test_name.failed
 fi
 
diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index 6a8b0e9..b09731c 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -1,25 +1,36 @@
 #!/bin/sh
 
+# old distros are missing "truncate", emulate it with "dd"
+truncate()
+{
+	[ "$1" = "-s" ] && size=$2 && shift 2
+
+	dd if=/dev/zero of=$1 bs=1 count=0 seek=$size >> $LOG 2>&1
+}
+
 resize_test () {
 
+echo $test_description starting > $LOG
 rm -f $TMPFILE
 touch $TMPFILE
 
 # Verify that the $TMP filesystem handles $SIZE_2 sparse files.
 # If that fails, try the local filesystem instead.
 if truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
-        > $TMPFILE
+	echo "using $TMPFILE" >> $LOG
 else
 	rm $TMPFILE
 	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.XXXXXX.tmp)
 	touch $TMPFILE
-	if ! truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
+	echo "using $TMPFILE" >> $LOG
+	if ! truncate -s $SIZE_2 $TMPFILE >> $LOG 2>&1; then
 		rm $TMPFILE
 		return 111
 	fi
 fi
+> $TMPFILE
 
-echo $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 > $LOG
+echo $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 >> $LOG
 $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 >> $LOG
 
 OUT_TMP=$(mktemp -t csum-tmp.XXXXXX)
-- 
1.7.3.4

