From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] tests: clean up the temp file if test_one is interrupted
Date: Mon,  9 Jun 2014 10:50:51 -0400
Message-ID: <1402325451-5275-2-git-send-email-tytso@mit.edu>
References: <20140609144901.GE8418@thunk.org>
 <1402325451-5275-1-git-send-email-tytso@mit.edu>
Cc: bensberg@justemail.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57579 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495AbaFIOvC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 10:51:02 -0400
In-Reply-To: <1402325451-5275-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/test_one.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/test_one.in b/tests/test_one.in
index 01a9260..eb28313 100644
--- a/tests/test_one.in
+++ b/tests/test_one.in
@@ -31,6 +31,7 @@ fi
 test_name=`echo $test_dir | sed -e 's;.*/;;'`
 
 TMPFILE=$(mktemp -t e2fsprogs-tmp-$test_name.XXXXXX)
+trap 'rm -f $TMPFILE ; exit' 1 2 15
 
 if [ -f $test_dir ] ; then
 	exit 0;
-- 
2.0.0

