From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 1/8] lib/blkid/list.h: Fix undefined behavior in list_entry()
 macro
Date: Fri, 14 Dec 2012 00:04:09 +0200
Message-ID: <20121213220408.GI9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:51092 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2LMW37 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:29:59 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4Gpa023712
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:16 +0200
Received: from smtp-1.hut.fi ([130.233.228.91])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 30841-200 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:16 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM49v2023708
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:09 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update list_entry() macro, which is basically the same as the
container_of() macro in the kernel, to use offsetof() to fix undefined
behavior.

Caught using clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/blkid/list.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/blkid/list.h b/lib/blkid/list.h
index c1cbfec..d15228e 100644
--- a/lib/blkid/list.h
+++ b/lib/blkid/list.h
@@ -148,8 +148,9 @@ _INLINE_ void list_splice(struct list_head *list, struct list_head *head)
  * @type:	the type of the struct this is embedded in.
  * @member:	the name of the list_struct within the struct.
  */
-#define list_entry(ptr, type, member) \
-	((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
+#define list_entry(ptr, type, member) ({		       \
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);   \
+	(type *)( (char *)__mptr - offsetof(type,member) );})
 
 /**
  * list_for_each - iterate over elements in a list
-- 
1.7.10.4
