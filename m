From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] tests: fix the e2fsck test script to handle a missing test name
Date: Thu, 31 May 2012 20:14:58 -0400
Message-ID: <1338509698-24349-4-git-send-email-tytso@mit.edu>
References: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46859 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab2FAAPF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 20:15:05 -0400
In-Reply-To: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/run_e2fsck | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tests/run_e2fsck b/tests/run_e2fsck
index 937a171..ab623e8 100644
--- a/tests/run_e2fsck
+++ b/tests/run_e2fsck
@@ -82,12 +82,23 @@ if [ "$SKIP_VERIFY" != "true" ] ; then
 		status3=0
 	fi
 
+	if [ -z "$test_description" ] ; then
+		description="$test_name"
+	else
+		description="$test_name: $test_description"
+	fi
+
 	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
-		echo "$test_name: $test_description: ok"
+		echo "$description: ok"
 		touch $test_name.ok
 	else
-		echo "$test_name: $test_description: failed"
-		diff $DIFF_OPTS $EXP1 $OUT1 > $test_name.failed
+		echo "$description: failed"
+		rm -f $test_name.failed
+		if [ "$PASS_ZERO" = "true" ]; then
+			diff $DIFF_OPTS $test_dir/expect.0 \
+				$test_name.0.log >> $test_name.failed
+		fi
+		diff $DIFF_OPTS $EXP1 $OUT1 >> $test_name.failed
 		if [ "$ONE_PASS_ONLY" != "true" ]; then
 			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
 		fi
-- 
1.7.10.2.552.gaa3bb87

