From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/52] ext4: improve some code in rb tree part of dir.c
Date: Sat,  5 Jul 2008 13:35:31 -0400
Message-ID: <1215279378-30504-6-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33112 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755686AbYGERge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:34 -0400
In-Reply-To: <1215279378-30504-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shen Feng <shen@cn.fujitsu.com>

* remove unnecessary code in free_rb_tree_fname

* rename free_rb_tree_fname to ext4_htree_create_dir_info
  since it and ext4_htree_free_dir_info are a pair

* replace kmalloc with kzalloc in ext4_htree_free_dir_info

All these make the code more readable and simple.
PS: this patch is also suitable for ext3.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/dir.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 2bf0331..5ed5108 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -272,7 +272,7 @@ static void free_rb_tree_fname(struct rb_root *root)
 
 	while (n) {
 		/* Do the node's children first */
-		if ((n)->rb_left) {
+		if (n->rb_left) {
 			n = n->rb_left;
 			continue;
 		}
@@ -301,24 +301,18 @@ static void free_rb_tree_fname(struct rb_root *root)
 			parent->rb_right = NULL;
 		n = parent;
 	}
-	root->rb_node = NULL;
 }
 
 
-static struct dir_private_info *create_dir_info(loff_t pos)
+static struct dir_private_info *ext4_htree_create_dir_info(loff_t pos)
 {
 	struct dir_private_info *p;
 
-	p = kmalloc(sizeof(struct dir_private_info), GFP_KERNEL);
+	p = kzalloc(sizeof(struct dir_private_info), GFP_KERNEL);
 	if (!p)
 		return NULL;
-	p->root.rb_node = NULL;
-	p->curr_node = NULL;
-	p->extra_fname = NULL;
-	p->last_pos = 0;
 	p->curr_hash = pos2maj_hash(pos);
 	p->curr_minor_hash = pos2min_hash(pos);
-	p->next_hash = 0;
 	return p;
 }
 
@@ -433,7 +427,7 @@ static int ext4_dx_readdir(struct file * filp,
 	int	ret;
 
 	if (!info) {
-		info = create_dir_info(filp->f_pos);
+		info = ext4_htree_create_dir_info(filp->f_pos);
 		if (!info)
 			return -ENOMEM;
 		filp->private_data = info;
-- 
1.5.6.rc3.1.g36b7.dirty

