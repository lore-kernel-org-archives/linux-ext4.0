From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 01/11] rbtree: Fix rbtree_postorder_for_each_entry_safe() iterator
Date: Wed,  6 Nov 2013 17:42:30 -0800
Message-ID: <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
	Seth Jennings <sjenning@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34830 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KGBnc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Nov 2013 20:43:32 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <cody@linux.vnet.ibm.com>;
	Wed, 6 Nov 2013 18:43:31 -0700
In-Reply-To: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
underflow behavior when testing for loop termination. In particular
it expects that
  &rb_entry(NULL, type, field)->field
is NULL. But the result of this expression is not defined by a C standard
and some gcc versions (e.g. 4.3.4) assume the above expression can never
be equal to NULL. The net result is an oops because the iteration is not
properly terminated.

Fix the problem by modifying the iterator to avoid pointer underflows.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/rbtree.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index aa870a4..57e75ae 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -85,6 +85,11 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+#define rb_entry_safe(ptr, type, member) \
+	({ typeof(ptr) ____ptr = (ptr); \
+	   ____ptr ? rb_entry(____ptr, type, member) : NULL; \
+	})
+
 /**
  * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
  * given type safe against removal of rb_node entry
@@ -95,12 +100,9 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
  * @field:	the name of the rb_node field within 'type'.
  */
 #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
-	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field); \
-	     &pos->field; \
-	     pos = n, \
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field))
+	for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
+	     pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
+			typeof(*pos), field); 1; }); \
+	     pos = n)
 
 #endif	/* _LINUX_RBTREE_H */
-- 
1.8.4.2

