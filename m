From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 6/8] lib/ext2fs/kernel-list.h: Fix undefined behavior in
 list_entry() macro
Date: Fri, 14 Dec 2012 00:04:29 +0200
Message-ID: <20121213220429.GN9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:57570 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab2LMWiy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:38:54 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4fOO019955
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:41 +0200
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 18978-120 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:41 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4UiB019947
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:30 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the macro, which is essentially a copy of the container_of() in
the kernel, to use offsetof instead of a null pointer dereference.

Caught by clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/kernel-list.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/kernel-list.h b/lib/ext2fs/kernel-list.h
index e07d06b..85ae213 100644
--- a/lib/ext2fs/kernel-list.h
+++ b/lib/ext2fs/kernel-list.h
@@ -103,8 +103,10 @@ static __inline__ void list_splice(struct list_head *list, struct list_head *hea
 	}
 }
 
-#define list_entry(ptr, type, member) \
-	((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
+#define list_entry(ptr, type, member) ({                      \
+       const typeof( ((type *)0)->member ) *__mptr = (ptr);   \
+       (type *)( (char *)__mptr - offsetof(type,member) );})
+
 
 #define list_for_each(pos, head) \
         for (pos = (head)->next; pos != (head); pos = pos->next)
-- 
1.7.10.4
