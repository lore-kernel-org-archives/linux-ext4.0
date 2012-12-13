From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 2/8] lib/ext2fs/rbtree.h: Fix container_of() undefined
 behavior
Date: Fri, 14 Dec 2012 00:04:12 +0200
Message-ID: <20121213220412.GJ9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:52325 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab2LMWjO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:39:14 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4FgJ022292
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:15 +0200
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 08212-1429 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:15 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4Dxf022287
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:13 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code before the macro definition #undefs and redefines offsetof().
Unfortunately the new definition actually causes undefined behavior.

The code checks for __compiler_offsetof() before redefining. However
I'm not sure where it is supposed to be defined.

Just enclose the redefinition in #ifndef __GNUC__ for now.

Caught using clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/rbtree.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ext2fs/rbtree.h b/lib/ext2fs/rbtree.h
index 16defb5..088c352 100644
--- a/lib/ext2fs/rbtree.h
+++ b/lib/ext2fs/rbtree.h
@@ -96,12 +96,14 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 
 #include <stdlib.h>
 
+#ifndef __GNUC__
 #undef offsetof
 #ifdef __compiler_offsetof
 #define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
 #else
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
+#endif
 
 #define container_of(ptr, type, member) ({			\
 	const __typeof__( ((type *)0)->member ) *__mptr = (ptr);	\
-- 
1.7.10.4
