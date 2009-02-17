From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 23/24] jbd2: On a __journal_expect() assertion failure printk "JBD2", not "EXT3-fs"
Date: Tue, 17 Feb 2009 10:58:43 -0500
Message-ID: <1234886324-15105-24-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
 <1234886324-15105-6-git-send-email-tytso@mit.edu>
 <1234886324-15105-7-git-send-email-tytso@mit.edu>
 <1234886324-15105-8-git-send-email-tytso@mit.edu>
 <1234886324-15105-9-git-send-email-tytso@mit.edu>
 <1234886324-15105-10-git-send-email-tytso@mit.edu>
 <1234886324-15105-11-git-send-email-tytso@mit.edu>
 <1234886324-15105-12-git-send-email-tytso@mit.edu>
 <1234886324-15105-13-git-send-email-tytso@mit.edu>
 <1234886324-15105-14-git-send-email-tytso@mit.edu>
 <1234886324-15105-15-git-send-email-tytso@mit.edu>
 <1234886324-15105-16-git-send-email-tytso@mit.edu>
 <1234886324-15105-17-git-send-email-tytso@mit.edu>
 <1234886324-15105-18-git-send-email-tytso@mit.edu>
 <1234886324-15105-19-git-send-email-tytso@mit.edu>
 <1234886324-15105-20-git-send-email-tytso@mit.edu>
 <1234886324-15105-21-git-send-email-tytso@mit.edu>
 <1234886324-15105-22-git-send-email-tytso@mit.edu>
 <1234886324-15105-23-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40526 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZBQQbb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:31:31 -0500
In-Reply-To: <1234886324-15105-23-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise it can be very confusing to find a "EXT3-fs: " failure in
the middle of EXT4-fs failures, and it makes it harder to track the
source of the failure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 08ec8c3878cea0bf91f2ba3c0badf44b383752d0)
---
 include/linux/jbd2.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e8e9133..0e1bd70 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -308,7 +308,8 @@ void buffer_assertion_failure(struct buffer_head *bh);
 		int val = (expr);					     \
 		if (!val) {						     \
 			printk(KERN_ERR					     \
-				"EXT3-fs unexpected failure: %s;\n",# expr); \
+			       "JBD2 unexpected failure: %s: %s;\n",	     \
+			       __func__, #expr);			     \
 			printk(KERN_ERR why "\n");			     \
 		}							     \
 		val;							     \
-- 
1.5.6.3

