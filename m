From: akpm@linux-foundation.org
Subject: [patch 2/8] jbd2: remove printk() from J_ASSERT macros
Date: Thu, 29 Nov 2007 12:52:48 -0800
Message-ID: <200711292052.lATKqnQx006828@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, csnook@redhat.com, sct@redhat.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759485AbXK2UyJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 15:54:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Remove printk from J_ASSERT to preserve registers during BUG.

Signed-off-by: Chris Snook <csnook@redhat.com>
Cc: "Stephen C. Tweedie" <sct@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd2.h |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN include/linux/jbd2.h~jbd2-remove-printk-from-j_assert-macros include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd2-remove-printk-from-j_assert-macros
+++ a/include/linux/jbd2.h
@@ -283,17 +283,7 @@ typedef struct journal_superblock_s
 #include <linux/fs.h>
 #include <linux/sched.h>
 
-#define JBD2_ASSERTIONS
-#ifdef JBD2_ASSERTIONS
-#define J_ASSERT(assert)						\
-do {									\
-	if (!(assert)) {						\
-		printk (KERN_EMERG					\
-			"Assertion failure in %s() at %s:%d: \"%s\"\n",	\
-			__FUNCTION__, __FILE__, __LINE__, # assert);	\
-		BUG();							\
-	}								\
-} while (0)
+#define J_ASSERT(assert)	BUG_ON(!(assert))
 
 #if defined(CONFIG_BUFFER_DEBUG)
 void buffer_assertion_failure(struct buffer_head *bh);
@@ -309,10 +299,6 @@ void buffer_assertion_failure(struct buf
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
 #endif
 
-#else
-#define J_ASSERT(assert)	do { } while (0)
-#endif		/* JBD2_ASSERTIONS */
-
 #if defined(JBD2_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
 #define J_EXPECT_BH(bh, expr, why...)	J_ASSERT_BH(bh, expr)
_
