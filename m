From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 06/11] fs/ubifs: use rbtree postorder iteration helper
 instead of opencoding
Date: Wed,  6 Nov 2013 17:42:35 -0800
Message-ID: <1383788572-25938-7-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-mtd@lists.infradead.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
 LKML <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
 EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
 rostedt@goodmis.org, Adrian Hunter <adrian.hunter@intel.com>,
 Artem Bityutskiy <dedekind1@gmail.com>
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
 fs/ubifs/debug.c    | 22 +++-------------------
 fs/ubifs/log.c      | 21 ++-------------------
 fs/ubifs/orphan.c   | 21 ++-------------------
 fs/ubifs/recovery.c | 21 +++------------------
 fs/ubifs/super.c    | 24 ++++--------------------
 fs/ubifs/tnc.c      | 22 +++-------------------
 6 files changed, 17 insertions(+), 114 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 6e025e0..378c179 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2118,26 +2118,10 @@ out_free:
  */
 static void free_inodes(struct fsck_data *fsckd)
 {
-	struct rb_node *this = fsckd->inodes.rb_node;
-	struct fsck_inode *fscki;
+	struct fsck_inode *fscki, *n;
 
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			fscki = rb_entry(this, struct fsck_inode, rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &fscki->rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
-			kfree(fscki);
-		}
-	}
+	rbtree_postorder_for_each_entry_safe(fscki, n, &fsckd->inodes, rb)
+		kfree(fscki);
 }
 
 /**
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index 36bd4ef..a902c59 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -574,27 +574,10 @@ static int done_already(struct rb_root *done_tree, int lnum)
  */
 static void destroy_done_tree(struct rb_root *done_tree)
 {
-	struct rb_node *this = done_tree->rb_node;
-	struct done_ref *dr;
+	struct done_ref *dr, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		dr = rb_entry(this, struct done_ref, rb);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &dr->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
+	rbtree_postorder_for_each_entry_safe(dr, n, done_tree, rb)
 		kfree(dr);
-	}
 }
 
 /**
diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index ba32da3..f1c3e5a1 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -815,27 +815,10 @@ static int dbg_find_check_orphan(struct rb_root *root, ino_t inum)
 
 static void dbg_free_check_tree(struct rb_root *root)
 {
-	struct rb_node *this = root->rb_node;
-	struct check_orphan *o;
+	struct check_orphan *o, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		o = rb_entry(this, struct check_orphan, rb);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &o->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
+	rbtree_postorder_for_each_entry_safe(o, n, root, rb)
 		kfree(o);
-	}
 }
 
 static int dbg_orphan_check(struct ubifs_info *c, struct ubifs_zbranch *zbr,
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index 065096e..c14adb2 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -1335,29 +1335,14 @@ static void remove_ino(struct ubifs_info *c, ino_t inum)
  */
 void ubifs_destroy_size_tree(struct ubifs_info *c)
 {
-	struct rb_node *this = c->size_tree.rb_node;
-	struct size_entry *e;
+	struct size_entry *e, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		e = rb_entry(this, struct size_entry, rb);
+	rbtree_postorder_for_each_entry_safe(e, n, &c->size_tree, rb) {
 		if (e->inode)
 			iput(e->inode);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &e->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
 		kfree(e);
 	}
+
 	c->size_tree = RB_ROOT;
 }
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3e4aa72..14a5891 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -873,26 +873,10 @@ static void free_orphans(struct ubifs_info *c)
  */
 static void free_buds(struct ubifs_info *c)
 {
-	struct rb_node *this = c->buds.rb_node;
-	struct ubifs_bud *bud;
-
-	while (this) {
-		if (this->rb_left)
-			this = this->rb_left;
-		else if (this->rb_right)
-			this = this->rb_right;
-		else {
-			bud = rb_entry(this, struct ubifs_bud, rb);
-			this = rb_parent(this);
-			if (this) {
-				if (this->rb_left == &bud->rb)
-					this->rb_left = NULL;
-				else
-					this->rb_right = NULL;
-			}
-			kfree(bud);
-		}
-	}
+	struct ubifs_bud *bud, *n;
+
+	rbtree_postorder_for_each_entry_safe(bud, n, &c->buds, rb)
+		kfree(bud);
 }
 
 /**
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 349f31a..9083bc7 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -178,27 +178,11 @@ static int ins_clr_old_idx_znode(struct ubifs_info *c,
  */
 void destroy_old_idx(struct ubifs_info *c)
 {
-	struct rb_node *this = c->old_idx.rb_node;
-	struct ubifs_old_idx *old_idx;
+	struct ubifs_old_idx *old_idx, *n;
 
-	while (this) {
-		if (this->rb_left) {
-			this = this->rb_left;
-			continue;
-		} else if (this->rb_right) {
-			this = this->rb_right;
-			continue;
-		}
-		old_idx = rb_entry(this, struct ubifs_old_idx, rb);
-		this = rb_parent(this);
-		if (this) {
-			if (this->rb_left == &old_idx->rb)
-				this->rb_left = NULL;
-			else
-				this->rb_right = NULL;
-		}
+	rbtree_postorder_for_each_entry_safe(old_idx, n, &c->old_idx, rb)
 		kfree(old_idx);
-	}
+
 	c->old_idx = RB_ROOT;
 }
 
-- 
1.8.4.2


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
