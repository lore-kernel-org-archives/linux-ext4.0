From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Subject: [PATCH] obsolete config in kernel source (BUFFER_DEBUG)
Date: Fri, 5 Feb 2010 14:13:33 +0100
Message-ID: <20100205131333.GB6540@faui49.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: vamos@i4.informatik.uni-erlangen.de
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Kazuo Moriwaka <moriwaka@redhat.com>,
	H Hartley Sweet
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56856 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432Ab0BENNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Feb 2010 08:13:20 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	With some commit somewhere around 2.4.15 the last hint of
CONFIG_BUFFER_DEBUG (apart from the 2 occurences this patch addresses)
-- some documentation -- was removed from the kernel source. However
this one piece of code made it till today. Time to go forward and
remove it?

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From cb255f19dc90e027c2f903e24c16d1f179bac67e Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 13:08:06 +0100
Subject: [PATCH] remove references to BUFFER_DEBUG

CONFIG_BUFFER_DEBUG seems to have been removed from the documentation
somewhere around 2.4.15 and seemingly hasn't been available even
longer. It is, however, still referenced at one place from the jbd
code (one is a copy of the other header). Time to clean it up

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 include/linux/jbd.h  |   11 -----------
 include/linux/jbd2.h |   11 -----------
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 331530c..f3aa59c 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -246,19 +246,8 @@ typedef struct journal_superblock_s
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
-#if defined(CONFIG_BUFFER_DEBUG)
-void buffer_assertion_failure(struct buffer_head *bh);
-#define J_ASSERT_BH(bh, expr)						\
-	do {								\
-		if (!(expr))						\
-			buffer_assertion_failure(bh);			\
-		J_ASSERT(expr);						\
-	} while (0)
-#define J_ASSERT_JH(jh, expr)	J_ASSERT_BH(jh2bh(jh), expr)
-#else
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
-#endif
 
 #if defined(JBD_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 638ce45..4cf6191 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -284,19 +284,8 @@ typedef struct journal_superblock_s
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
-#if defined(CONFIG_BUFFER_DEBUG)
-void buffer_assertion_failure(struct buffer_head *bh);
-#define J_ASSERT_BH(bh, expr)						\
-	do {								\
-		if (!(expr))						\
-			buffer_assertion_failure(bh);			\
-		J_ASSERT(expr);						\
-	} while (0)
-#define J_ASSERT_JH(jh, expr)	J_ASSERT_BH(jh2bh(jh), expr)
-#else
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
-#endif
 
 #if defined(JBD2_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
-- 
1.6.3.3

