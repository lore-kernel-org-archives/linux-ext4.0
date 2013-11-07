From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: check backing filesystem can handle large file
Date: Wed,  6 Nov 2013 23:35:04 -0700
Message-ID: <1383806104-26239-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:59524 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3KGGfH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Nov 2013 01:35:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The new resize tests create 2TB test files, but tmpfs in kernels
before 3.1 have a max file size of 256GB.  Ext3 may also have
a size limit for smaller blocksize filesystems.

Fix the resize_test script to verify that $TMPFILE can be resized
to the final test size, and if that fails try creating the file on
the local filesystem instead of in $TMPDIR.  If that cannot hold
the large filesystem, skip the test.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/r_64bit_big_expand/script    |    8 ++++++--
 tests/r_bigalloc_big_expand/script |    8 ++++++--
 tests/r_ext4_big_expand/script     |    8 ++++++--
 tests/scripts/resize_test          |   15 +++++++++++++++
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/tests/r_64bit_big_expand/script b/tests/r_64bit_big_expand/script
index 3b34a62..51f36e9 100644
--- a/tests/r_64bit_big_expand/script
+++ b/tests/r_64bit_big_expand/script
@@ -10,10 +10,14 @@ E2FSCK=../e2fsck/e2fsck
 
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
 	touch $test_name.failed
diff --git a/tests/r_bigalloc_big_expand/script b/tests/r_bigalloc_big_expand/script
index 2b9cc63..56c8c15 100644
--- a/tests/r_bigalloc_big_expand/script
+++ b/tests/r_bigalloc_big_expand/script
@@ -10,10 +10,14 @@ RESIZE2FS_OPTS=-f
 
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
 	touch $test_name.failed
diff --git a/tests/r_ext4_big_expand/script b/tests/r_ext4_big_expand/script
index fb31d7a..a4f8fe6 100644
--- a/tests/r_ext4_big_expand/script
+++ b/tests/r_ext4_big_expand/script
@@ -10,10 +10,14 @@ E2FSCK=../e2fsck/e2fsck
 
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
 	touch $test_name.failed
diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index 964150e..30532a5 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -4,6 +4,21 @@ resize_test () {
 
 rm -f $TMPFILE
 touch $TMPFILE
+
+# Verify that the $TMP filesystem handles $SIZE_2 sparse files.
+# If that fails, try the local filesystem instead.
+if truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
+        > $TMPFILE
+else
+	rm $TMPFILE
+	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.XXXXXX.tmp)
+	touch $TMPFILE
+	if ! truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
+		rm $TMPFILE
+		return 111
+	fi
+fi
+
 echo $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 > $LOG
 $MKE2FS $FEATURES -qF $TMPFILE $SIZE_1 >> $LOG
 
-- 
1.7.3.4

