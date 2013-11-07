From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 02/11] rbtree/test: move rb_node to the middle of the test struct
Date: Wed,  6 Nov 2013 17:42:31 -0800
Message-ID: <1383788572-25938-3-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
	Davidlohr Bueso <davidlohr.bueso@hp.com>,
	Michel Lespinasse <walken@google.com>,
	Seth Jennings <sjenning@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avoid making the rb_node the first entry to catch some bugs around NULL
checking the rb_node.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 lib/rbtree_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 31dd4cc..df6c125 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -8,8 +8,8 @@
 #define CHECK_LOOPS 100
 
 struct test_node {
-	struct rb_node rb;
 	u32 key;
+	struct rb_node rb;
 
 	/* following fields used for testing augmented rbtree functionality */
 	u32 val;
-- 
1.8.4.2
