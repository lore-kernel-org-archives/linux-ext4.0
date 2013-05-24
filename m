From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] add generic/286 to the auto and quick groups
Date: Fri, 24 May 2013 00:33:01 -0400
Message-ID: <1369369981-7035-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51410 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3EXEdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 May 2013 00:33:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The generic/286 test tests SEEK_HOLE and SEEK_DATA, and is reasonably
fast.  We should just run the test by default.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/generic/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/group b/tests/generic/group
index e2ef70e..bd443c1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -103,7 +103,7 @@
 277 auto ioctl quick metadata
 280 auto quota freeze dangerous
 285 auto rw
-286 other
+286 auto quick other
 288 auto quick ioctl trim
 294 auto quick
 299 auto aio enospc rw stress
-- 
1.7.12.rc0.22.gcdd159b

