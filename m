From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 05/11] trace/trace_stat: use rbtree postorder iteration helper instead of opencoding
Date: Wed,  6 Nov 2013 17:42:34 -0800
Message-ID: <1383788572-25938-6-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 kernel/trace/trace_stat.c | 42 ++++++------------------------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 847f88a..fa53acc 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -43,46 +43,16 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 /* The root directory for all stat files */
 static struct dentry		*stat_dir;
 
-/*
- * Iterate through the rbtree using a post order traversal path
- * to release the next node.
- * It won't necessary release one at each iteration
- * but it will at least advance closer to the next one
- * to be released.
- */
-static struct rb_node *release_next(struct tracer_stat *ts,
-				    struct rb_node *node)
+static void __reset_stat_session(struct stat_session *session)
 {
-	struct stat_node *snode;
-	struct rb_node *parent = rb_parent(node);
-
-	if (node->rb_left)
-		return node->rb_left;
-	else if (node->rb_right)
-		return node->rb_right;
-	else {
-		if (!parent)
-			;
-		else if (parent->rb_left == node)
-			parent->rb_left = NULL;
-		else
-			parent->rb_right = NULL;
+	struct stat_node *snode, *n;
 
-		snode = container_of(node, struct stat_node, node);
-		if (ts->stat_release)
-			ts->stat_release(snode->stat);
+	rbtree_postorder_for_each_entry_safe(snode, n, &session->stat_root,
+			node) {
+		if (session->ts->stat_release)
+			session->ts->stat_release(snode->stat);
 		kfree(snode);
-
-		return parent;
 	}
-}
-
-static void __reset_stat_session(struct stat_session *session)
-{
-	struct rb_node *node = session->stat_root.rb_node;
-
-	while (node)
-		node = release_next(session->ts, node);
 
 	session->stat_root = RB_ROOT;
 }
-- 
1.8.4.2
