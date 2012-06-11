From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] tests: allow e2fsck tests to run on OS/X
Date: Mon, 11 Jun 2012 01:49:20 -0600
Message-ID: <1339400960-26140-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20343 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2FKHtc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2012 03:49:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The "mktemp" program requires a template on OS/X.  Allow the test
TMPFILE to be created in the local /tmp directory for both OS/X
and Linux.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 tests/test_one.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/test_one.in b/tests/test_one.in
index 238b4b7..d053fd7 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -28,7 +28,7 @@ fi
 
 . $TEST_CONFIG
 
-TMPFILE=$(mktemp)
+TMPFILE=$(mktemp -t e2fsprogs-tmp.XXXXXX)
 
 test_name=`echo $test_dir | sed -e 's;.*/;;'`
 if [ -f $test_dir ] ; then
-- 
1.7.3.4

