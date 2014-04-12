From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] generic/022: update expected output after the test was renamed
Date: Sat, 12 Apr 2014 18:55:16 -0400
Message-ID: <1397343317-14669-3-git-send-email-tytso@mit.edu>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53315 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbaDLWza (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 18:55:30 -0400
In-Reply-To: <1397343317-14669-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After generic/022 was renamed by commit 21723cdb, the wrong test
number was put into generic/022.out.  Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Lukas Czerner <lczerner@redhat.com>
---
 tests/generic/022.out | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/022.out b/tests/generic/022.out
index 96c2d33..fbffa59 100644
--- a/tests/generic/022.out
+++ b/tests/generic/022.out
@@ -1,4 +1,4 @@
-QA output created by 009
+QA output created by 022
 	1. into a hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
-- 
1.9.0

