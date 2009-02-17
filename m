From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 23/24] jbd2: On a __journal_expect() assertion failure printk "JBD2", not "EXT3-fs"
Date: Tue, 17 Feb 2009 10:32:41 -0500
Message-ID: <1234884762-13580-24-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
 <1234884762-13580-8-git-send-email-tytso@mit.edu>
 <1234884762-13580-9-git-send-email-tytso@mit.edu>
 <1234884762-13580-10-git-send-email-tytso@mit.edu>
 <1234884762-13580-11-git-send-email-tytso@mit.edu>
 <1234884762-13580-12-git-send-email-tytso@mit.edu>
 <1234884762-13580-13-git-send-email-tytso@mit.edu>
 <1234884762-13580-14-git-send-email-tytso@mit.edu>
 <1234884762-13580-15-git-send-email-tytso@mit.edu>
 <1234884762-13580-16-git-send-email-tytso@mit.edu>
 <1234884762-13580-17-git-send-email-tytso@mit.edu>
 <1234884762-13580-18-git-send-email-tytso@mit.edu>
 <1234884762-13580-19-git-send-email-tytso@mit.edu>
 <1234884762-13580-20-git-send-email-tytso@mit.edu>
 <1234884762-13580-21-git-send-email-tytso@mit.edu>
 <1234884762-13580-22-git-send-email-tytso@mit.edu>
 <1234884762-13580-23-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZBQQLd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:11:33 -0500
In-Reply-To: <1234884762-13580-23-git-send-email-tytso@mit.edu>
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
index f366457..7c31d67 100644
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

