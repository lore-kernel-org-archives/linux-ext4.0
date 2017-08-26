From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: report if a test is taking a long time
Date: Fri, 25 Aug 2017 23:19:48 -0600
Message-ID: <1503724788-84776-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:49791 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdHZFTu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Aug 2017 01:19:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Print out a message if a test takes longer than 60s, with a
reminder to potentially add is_slow_test to that test, so
that it is easier to find which tests are taking a long time,
especially if running with "make -j check" or similar.

Add an exclusion for r_expand_full on MacOS since HFS+ does
not support sparse devices and doesn't like large test images.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/r_expand_full/script | 6 ++++++
 tests/test_one.in          | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/tests/r_expand_full/script b/tests/r_expand_full/script
index a2c09db..2fd4461 100644
--- a/tests/r_expand_full/script
+++ b/tests/r_expand_full/script
@@ -23,6 +23,12 @@ cat > $CONF << ENDL
 	}
 ENDL
 
+if [ $(uname -s) = "Darwin" ]; then
+	# creates a 786MB filesystem
+	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
+	return 0
+fi
+
 echo "resize2fs test" > $OUT
 
 MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 786432 >> $OUT 2>&1
diff --git a/tests/test_one.in b/tests/test_one.in
index 35465b6..d046380 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -61,6 +61,7 @@ fi
 rm -f $test_name.ok $test_name.failed
 #echo -e -n "$test_name: $test_description:\r"
 
+start=$SECONDS
 if [ -f $test_dir/script ]; then
 	. $test_dir/script
 else
@@ -72,6 +73,11 @@ else
 		echo "$test_name: Missing test script $default_script!"
 	fi
 fi
+elapsed=$((SECONDS - start))
+if [ $elapsed -gt 60 -a ! -f $test_dir/is_slow_test ]; then
+	echo "$test_name:  *** took $elapsed seconds to finish ***"
+	echo "$test_name:  consider adding $test_dir/is_slow_test"
+fi
 
 if [ "$SKIP_UNLINK" != "true" ] ; then
 	rm -f $TMPFILE
-- 
1.8.0
