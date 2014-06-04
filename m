From: Benno Schulenberg <bensberg@justemail.net>
Subject: [PATCH] tests: for mktemp the exes must be the final characters of the name
Date: Wed,  4 Jun 2014 14:28:46 +0200
Message-ID: <1401884926-31722-1-git-send-email-bensberg@justemail.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53750 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaFDM2v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 08:28:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
---
 tests/scripts/resize_test |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index c9a7a1c..1e5756c 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -21,7 +21,7 @@ if truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
 	echo "using $TMPFILE" >> $LOG
 else
 	rm $TMPFILE
-	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.XXXXXX.tmp)
+	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.tmp.XXXXXX)
 	touch $TMPFILE
 	echo "using $TMPFILE" >> $LOG
 	if ! truncate -s $SIZE_2 $TMPFILE >> $LOG 2>&1; then
-- 
1.7.0.4

