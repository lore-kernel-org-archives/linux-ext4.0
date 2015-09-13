From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 19/39] jbd2: drop null test before destroy functions
Date: Sun, 13 Sep 2015 14:15:12 +0200
Message-ID: <1442146532-9100-20-git-send-email-Julia.Lawall@lip6.fr>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: sergey.senozhatsky@gmail.com, kernel-janitors@vger.kernel.org,
	Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
@@

-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);

@@
expression x;
@@

-if (x != NULL) {
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
  x = NULL;
-}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/jbd2/journal.c     |   15 +++++----------
 fs/jbd2/revoke.c      |   12 ++++--------
 fs/jbd2/transaction.c |    6 ++----
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 6b8338e..ab26122 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -51,10 +51,8 @@ int __init jbd2_journal_init_transaction_cache(void)
 
 void jbd2_journal_destroy_transaction_cache(void)
 {
-	if (transaction_cache) {
-		kmem_cache_destroy(transaction_cache);
-		transaction_cache = NULL;
-	}
+	kmem_cache_destroy(transaction_cache);
+	transaction_cache = NULL;
 }
 
 void jbd2_journal_free_transaction(transaction_t *transaction)
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8270fe9..6b8c2c5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2240,8 +2240,7 @@ static void jbd2_journal_destroy_slabs(void)
 	int i;
 
 	for (i = 0; i < JBD2_MAX_SLABS; i++) {
-		if (jbd2_slab[i])
-			kmem_cache_destroy(jbd2_slab[i]);
+		kmem_cache_destroy(jbd2_slab[i]);
 		jbd2_slab[i] = NULL;
 	}
 }
@@ -2360,10 +2359,8 @@ static int jbd2_journal_init_journal_head_cache(void)
 
 static void jbd2_journal_destroy_journal_head_cache(void)
 {
-	if (jbd2_journal_head_cache) {
-		kmem_cache_destroy(jbd2_journal_head_cache);
-		jbd2_journal_head_cache = NULL;
-	}
+	kmem_cache_destroy(jbd2_journal_head_cache);
+	jbd2_journal_head_cache = NULL;
 }
 
 /*
@@ -2621,10 +2618,8 @@ static int __init jbd2_journal_init_handle_cache(void)
 
 static void jbd2_journal_destroy_handle_cache(void)
 {
-	if (jbd2_handle_cache)
-		kmem_cache_destroy(jbd2_handle_cache);
-	if (jbd2_inode_cache)
-		kmem_cache_destroy(jbd2_inode_cache);
+	kmem_cache_destroy(jbd2_handle_cache);
+	kmem_cache_destroy(jbd2_inode_cache);
 
 }
 
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 0abf2e7..1e77a9d 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -183,14 +183,10 @@ static struct jbd2_revoke_record_s *find_revoke_record(journal_t *journal,
 
 void jbd2_journal_destroy_revoke_caches(void)
 {
-	if (jbd2_revoke_record_cache) {
-		kmem_cache_destroy(jbd2_revoke_record_cache);
-		jbd2_revoke_record_cache = NULL;
-	}
-	if (jbd2_revoke_table_cache) {
-		kmem_cache_destroy(jbd2_revoke_table_cache);
-		jbd2_revoke_table_cache = NULL;
-	}
+	kmem_cache_destroy(jbd2_revoke_record_cache);
+	jbd2_revoke_record_cache = NULL;
+	kmem_cache_destroy(jbd2_revoke_table_cache);
+	jbd2_revoke_table_cache = NULL;
 }
 
 int __init jbd2_journal_init_revoke_caches(void)
