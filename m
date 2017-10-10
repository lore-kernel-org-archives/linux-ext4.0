From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: log tests that are taking a long time
Date: Tue, 10 Oct 2017 16:40:04 -0600
Message-ID: <1507675204-70036-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:35243 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756647AbdJJWov (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Oct 2017 18:44:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create a .slow file for tests that take too long to run, so it is
possible to find them easily after all of the tests have run.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 .gitignore        | 1 +
 tests/Makefile.in | 3 ++-
 tests/test_one.in | 5 +++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index baf9b1a..e002298 100644
--- a/.gitignore
+++ b/.gitignore
@@ -206,6 +206,7 @@ tests/*.ok
 tests/*.failed
 tests/*.log
 tests/*.tmp
+tests/*.slow
 tests/mke2fs.conf
 tests/test_script
 tests/test_one
diff --git a/tests/Makefile.in b/tests/Makefile.in
index 7b76354..7b9df62 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -93,7 +93,8 @@ testend: test_one ${TDIR}/image
 	@echo "If all is well, edit ${TDIR}/name and rename ${TDIR}."
 
 clean::
-	$(RM) -f *~ *.log *.new *.failed *.ok *.tmp test_one test_script mke2fs.conf
+	$(RM) -f *~ *.log *.new *.failed *.ok *.tmp *.slow
+	$(RM) -f test_one test_script mke2fs.conf
 
 distclean:: clean
 	$(RM) -f Makefile
diff --git a/tests/test_one.in b/tests/test_one.in
index b20e207..9bf1185 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -22,7 +22,7 @@ case "$1" in
 esac
 
 case "$1" in
-    *.failed|*.new|*.ok|*.log|*.tmp)	exit 0 ;;
+    *.failed|*.new|*.ok|*.log|*.tmp|*.slow)	exit 0 ;;
 esac
 
 test_dir=$1
@@ -77,7 +77,8 @@ else
 fi
 elapsed=$((SECONDS - start))
 if [ $elapsed -gt 60 -a ! -f $test_dir/is_slow_test ]; then
-	echo "$test_name:  *** took $elapsed seconds to finish ***"
+	echo "$test_name:  *** took $elapsed seconds to finish ***" |
+		tee $test_name.slow
 	echo "$test_name:  consider adding $test_dir/is_slow_test"
 fi
 
-- 
1.8.0
