From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 09/11] fs/ext3: use rbtree postorder iteration helper instead of opencoding
Date: Wed,  6 Nov 2013 17:42:38 -0800
Message-ID: <1383788572-25938-10-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35733 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3KGBn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Nov 2013 20:43:58 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <cody@linux.vnet.ibm.com>;
	Wed, 6 Nov 2013 20:43:57 -0500
In-Reply-To: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 fs/ext3/dir.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index bafdd48..a331ad1 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -309,43 +309,17 @@ struct fname {
  */
 static void free_rb_tree_fname(struct rb_root *root)
 {
-	struct rb_node	*n = root->rb_node;
-	struct rb_node	*parent;
-	struct fname	*fname;
-
-	while (n) {
-		/* Do the node's children first */
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		/*
-		 * The node has no children; free it, and then zero
-		 * out parent's link to it.  Finally go to the
-		 * beginning of the loop and try to free the parent
-		 * node.
-		 */
-		parent = rb_parent(n);
-		fname = rb_entry(n, struct fname, rb_hash);
+	struct fname *fname, *next;
+
+	rbtree_postorder_for_each_entry_safe(fname, next, root, rb_hash)
 		while (fname) {
 			struct fname * old = fname;
 			fname = fname->next;
 			kfree (old);
 		}
-		if (!parent)
-			*root = RB_ROOT;
-		else if (parent->rb_left == n)
-			parent->rb_left = NULL;
-		else if (parent->rb_right == n)
-			parent->rb_right = NULL;
-		n = parent;
-	}
-}
 
+	*root = RB_ROOT;
+}
 
 static struct dir_private_info *ext3_htree_create_dir_info(struct file *filp,
 							   loff_t pos)
-- 
1.8.4.2

