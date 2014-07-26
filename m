From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] tests: use e2fsck -f instead of -p for resize tests
Date: Sat, 26 Jul 2014 09:48:29 -0400
Message-ID: <1406382514-8662-2-git-send-email-tytso@mit.edu>
References: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58042 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaGZNsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:38 -0400
In-Reply-To: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using e2sck -f provides better debugging information if things go
wrong.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/scripts/resize_test | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index a12e4b9..0633e0c 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -64,8 +64,8 @@ then
 	return 1
 fi
 
-echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
-if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+echo $FSCK -fy $TMPFILE >> $LOG 2>&1
+if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
 	dumpe2fs $TMPFILE >> $LOG
 	return 1
@@ -94,8 +94,8 @@ then
 	return 1
 fi
 
-echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
-if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+echo $FSCK -fy $TMPFILE >> $LOG 2>&1
+if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
 	dumpe2fs $TMPFILE >> $LOG
 	return 1
@@ -119,8 +119,8 @@ then
 	return 1
 fi
 
-echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
-if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+echo $FSCK -fy $TMPFILE >> $LOG 2>&1
+if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
 	dumpe2fs $TMPFILE >> $LOG
 	return 1
@@ -144,8 +144,8 @@ then
 	return 1
 fi
 
-echo $FSCK -fp $TMPFILE >> $LOG 2>&1 
-if ! $FSCK -fp $TMPFILE >> $LOG 2>&1
+echo $FSCK -fy $TMPFILE >> $LOG 2>&1
+if ! $FSCK -fy $TMPFILE >> $LOG 2>&1
 then
 	dumpe2fs $TMPFILE >> $LOG
 	return 1
-- 
2.0.0

