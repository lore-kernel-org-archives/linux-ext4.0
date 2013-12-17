From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: delete temporary resize test files
Date: Mon, 16 Dec 2013 23:26:39 -0700
Message-ID: <1387261599-24122-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:5025 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3LQG0m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 01:26:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since commit 5ad07acad if $TMP cannot hold large test filesystems
for resize testing the resize_test creates temporary test files
in the local working directory.  Since it overrides TMPFILE locally
the calling program does not delete the generated file correctly.

Delete the large $TMPFILE within resize_test if it passes, but leave
it for debugging if the test failed.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/scripts/resize_test |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index 30532a5..6a8b0e9 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -149,6 +149,7 @@ then
 	return 1
 fi
 
+rm $TMPFILE
 return 0
 
 }
-- 
1.7.3.4

