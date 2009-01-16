From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] jbd2: On a __journal_expect() assertion failure printk "JBD2", not "EXT3-fs"
Date: Fri, 16 Jan 2009 12:00:58 -0500
Message-ID: <1232125258-14384-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45274 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZAPRBA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 12:01:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise it can be very confusing to find a "EXT3-fs: " failure in
the middle of EXT4-fs failures, and it makes it harder to track the
source of the failure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 include/linux/jbd2.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b45109c..b28b37e 100644
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
1.6.0.4.8.g36f27.dirty

