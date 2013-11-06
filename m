From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] rbtree/test: test rbtree_postorder_for_each_entry_safe()
Date: Wed,  6 Nov 2013 13:37:23 -0800
Message-ID: <1383773843-19981-1-git-send-email-cody@linux.vnet.ibm.com>
References: <527AA418.7010009@linux.vnet.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	EXT4 <linux-ext4@vger.kernel.org>,
	Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <527AA418.7010009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 lib/rbtree_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index df6c125..8b3c9dc 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -114,6 +114,16 @@ static int black_path_count(struct rb_node *rb)
 	return count;
 }
 
+static void check_postorder_foreach(int nr_nodes)
+{
+	struct test_node *cur, *n;
+	int count = 0;
+	rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
+		count++;
+
+	WARN_ON_ONCE(count != nr_nodes);
+}
+
 static void check_postorder(int nr_nodes)
 {
 	struct rb_node *rb;
@@ -148,6 +158,7 @@ static void check(int nr_nodes)
 	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
 
 	check_postorder(nr_nodes);
+	check_postorder_foreach(nr_nodes);
 }
 
 static void check_augmented(int nr_nodes)
-- 
1.8.4.2
