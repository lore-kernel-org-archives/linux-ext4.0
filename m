From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/5 v2] tests: Print out list of failed tests
Date: Fri, 12 Aug 2011 18:43:00 +0200
Message-ID: <1313167380-3283-5-git-send-email-lczerner@redhat.com>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, adilger@dilger.ca,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1HLQnU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 12:43:20 -0400
In-Reply-To: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we need to grep, list or just search for failed tests when
running 'make check' which is annoying. This commit simply prints out
the list of failed test names at the end of the output.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: This is the actually the first version of the patch

 tests/test_script.in |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tests/test_script.in b/tests/test_script.in
index cec09df..b7ac86e 100644
--- a/tests/test_script.in
+++ b/tests/test_script.in
@@ -78,4 +78,12 @@ num_failed=`ls *.failed 2>/dev/null | wc -l`
 
 echo "$num_ok tests succeeded	$num_failed tests failed"
 
-test "$num_failed" -eq 0 || exit 1
+test "$num_failed" -eq 0 && exit 0
+
+echo -n "Tests failed: "
+for fname in $(ls *.failed); do
+	echo -n "${fname%%.failed} "
+done
+echo ""
+
+exit 1
-- 
1.7.4.4

