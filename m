From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 08/11] fs/jffs2: use rbtree postorder iteration helper
 instead of opencoding
Date: Wed,  6 Nov 2013 17:42:37 -0800
Message-ID: <1383788572-25938-9-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-mtd@lists.infradead.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
 LKML <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
 EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
 rostedt@goodmis.org, David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 fs/jffs2/nodelist.c  | 28 ++--------------------------
 fs/jffs2/readinode.c | 26 +++-----------------------
 2 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/fs/jffs2/nodelist.c b/fs/jffs2/nodelist.c
index 975a1f5..9a5449b 100644
--- a/fs/jffs2/nodelist.c
+++ b/fs/jffs2/nodelist.c
@@ -564,25 +564,10 @@ struct jffs2_node_frag *jffs2_lookup_node_frag(struct rb_root *fragtree, uint32_
    they're killed. */
 void jffs2_kill_fragtree(struct rb_root *root, struct jffs2_sb_info *c)
 {
-	struct jffs2_node_frag *frag;
-	struct jffs2_node_frag *parent;
-
-	if (!root->rb_node)
-		return;
+	struct jffs2_node_frag *frag, *next;
 
 	dbg_fragtree("killing\n");
-
-	frag = (rb_entry(root->rb_node, struct jffs2_node_frag, rb));
-	while(frag) {
-		if (frag->rb.rb_left) {
-			frag = frag_left(frag);
-			continue;
-		}
-		if (frag->rb.rb_right) {
-			frag = frag_right(frag);
-			continue;
-		}
-
+	rbtree_postorder_for_each_entry_safe(frag, next, root, rb) {
 		if (frag->node && !(--frag->node->frags)) {
 			/* Not a hole, and it's the final remaining frag
 			   of this node. Free the node */
@@ -591,17 +576,8 @@ void jffs2_kill_fragtree(struct rb_root *root, struct jffs2_sb_info *c)
 
 			jffs2_free_full_dnode(frag->node);
 		}
-		parent = frag_parent(frag);
-		if (parent) {
-			if (frag_left(parent) == frag)
-				parent->rb.rb_left = NULL;
-			else
-				parent->rb.rb_right = NULL;
-		}
 
 		jffs2_free_node_frag(frag);
-		frag = parent;
-
 		cond_resched();
 	}
 }
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index ae81b01..386303d 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -543,33 +543,13 @@ static int jffs2_build_inode_fragtree(struct jffs2_sb_info *c,
 
 static void jffs2_free_tmp_dnode_info_list(struct rb_root *list)
 {
-	struct rb_node *this;
-	struct jffs2_tmp_dnode_info *tn;
-
-	this = list->rb_node;
+	struct jffs2_tmp_dnode_info *tn, *next;
 
-	/* Now at bottom of tree */
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			tn = rb_entry(this, struct jffs2_tmp_dnode_info, rb);
+	rbtree_postorder_for_each_entry_safe(tn, next, list, rb) {
 			jffs2_free_full_dnode(tn->fn);
 			jffs2_free_tmp_dnode_info(tn);
-
-			this = rb_parent(this);
-			if (!this)
-				break;
-
-			if (this->rb_left == &tn->rb)
-				this->rb_left = NULL;
-			else if (this->rb_right == &tn->rb)
-				this->rb_right = NULL;
-			else BUG();
-		}
 	}
+
 	*list = RB_ROOT;
 }
 
-- 
1.8.4.2


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
