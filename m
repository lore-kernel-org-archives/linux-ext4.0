From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: don't leave temporary files at end of test
Date: Tue, 10 Oct 2017 16:39:52 -0600
Message-ID: <1507675192-70000-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:35243 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932114AbdJJWoj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 18:44:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't leave temp files around after test has completed successfully.
Some test scripts were creating their own temporary files, and in
some cases test_one was skipping a test completely (e.g. slow) after
the temp file had been created.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/d_fallocate/script          | 2 +-
 tests/d_fallocate_bigalloc/script | 2 +-
 tests/d_xattr_edits/script        | 2 +-
 tests/test_one.in                 | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/d_fallocate/script b/tests/d_fallocate/script
index ae8956e..b3982a3 100644
--- a/tests/d_fallocate/script
+++ b/tests/d_fallocate/script
@@ -165,8 +165,8 @@ if [ "$status" = 0 ] ; then
 else
 	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-	rm -f $test_name.tmp
 fi
+rm -f $EXP
 
 unset IMAGE FSCK_OPT OUT EXP
 
diff --git a/tests/d_fallocate_bigalloc/script b/tests/d_fallocate_bigalloc/script
index 6b6bf97..9022a2b 100644
--- a/tests/d_fallocate_bigalloc/script
+++ b/tests/d_fallocate_bigalloc/script
@@ -166,8 +166,8 @@ if [ "$status" = 0 ] ; then
 else
 	echo "$test_name: $test_description: failed"
 	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
-	rm -f $test_name.tmp
 fi
+rm -f $EXP
 
 unset IMAGE FSCK_OPT OUT EXP
 
diff --git a/tests/d_xattr_edits/script b/tests/d_xattr_edits/script
index df2a530..cd9d039 100644
--- a/tests/d_xattr_edits/script
+++ b/tests/d_xattr_edits/script
@@ -122,7 +122,7 @@ sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 # Do the verification
 #
 
-rm -f $TMPFILE $OUT.new
+rm -f $TMPFILE $OUT.new $TEST_DATA $VERIFY_DATA
 cmp -s $OUT $EXP
 status=$?
 
diff --git a/tests/test_one.in b/tests/test_one.in
index 9bf1185..c1f18dc 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -36,9 +36,6 @@ fi
 
 test_name=`echo $test_dir | sed -e 's;.*/;;'`
 
-TMPFILE=$(mktemp ${TMPDIR:-/tmp}/e2fsprogs-tmp-$test_name.XXXXXX)
-trap 'rm -f $TMPFILE ; exit' 1 2 15
