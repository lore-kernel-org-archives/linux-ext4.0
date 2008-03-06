From: "Duane Griffin" <duaneg@dghda.com>
Subject: [RFC, PATCH 1/6] jbd: eliminate duplicated code in revocation table init/destroy functions
Date: Thu,  6 Mar 2008 01:59:09 +0000
Message-ID: <1204768754-29655-2-git-send-email-duaneg@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1426 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYCFCGB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2008 21:06:01 -0500
In-Reply-To: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
Message-Id: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The revocation table initialisation/destruction code is repeated for each of
the two revocation tables stored in the journal. Refactoring the duplicated
code into functions is tidier, simplifies the logic in initialisation in
particular, and slightly reduces the code size.

There should not be any functional change.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

This change is an independent cleanup which is not required by following
patches in this series. Also it should perhaps be two separate patches?

 fs/jbd/revoke.c |  126 +++++++++++++++++++++++--------------------------------
 1 files changed, 52 insertions(+), 74 deletions(-)

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index ad2eacf..5f64df4 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -195,108 +195,86 @@ void journal_destroy_revoke_caches(void)
 	revoke_table_cache = NULL;
 }
 
-/* Initialise the revoke table for a given journal to a given size. */
-
-int journal_init_revoke(journal_t *journal, int hash_size)
+static int journal_init_revoke_table(struct jbd_revoke_table_s *table, int size)
 {
-	int shift, tmp;
-
-	J_ASSERT (journal->j_revoke_table[0] == NULL);
-
-	shift = 0;
-	tmp = hash_size;
+	int shift = 0;
+	int tmp = size;
 	while((tmp >>= 1UL) != 0UL)
 		shift++;
 
-	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
-	if (!journal->j_revoke_table[0])
-		return -ENOMEM;
-	journal->j_revoke = journal->j_revoke_table[0];
-
-	/* Check that the hash_size is a power of two */
-	J_ASSERT(is_power_of_2(hash_size));
-
-	journal->j_revoke->hash_size = hash_size;
-
-	journal->j_revoke->hash_shift = shift;
-
-	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
-	if (!journal->j_revoke->hash_table) {
-		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
-		journal->j_revoke = NULL;
+	table->hash_size = size;
+	table->hash_shift = shift;
+	table->hash_table = kmalloc(
+		size * sizeof(struct list_head), GFP_KERNEL);
+	if (!table->hash_table)
 		return -ENOMEM;
-	}
-
-	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
 
-	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
-	if (!journal->j_revoke_table[1]) {
-		kfree(journal->j_revoke_table[0]->hash_table);
-		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
-		return -ENOMEM;
-	}
+	for (tmp = 0; tmp < size; tmp++)
+		INIT_LIST_HEAD(&table->hash_table[tmp]);
 
-	journal->j_revoke = journal->j_revoke_table[1];
+	return 0;
+}
 
-	/* Check that the hash_size is a power of two */
+/* Initialise the revoke table for a given journal to a given size. */
+int journal_init_revoke(journal_t *journal, int hash_size)
+{
+	J_ASSERT(journal->j_revoke_table[0] == NULL);
 	J_ASSERT(is_power_of_2(hash_size));
 
-	journal->j_revoke->hash_size = hash_size;
+	journal->j_revoke_table[0] = kmem_cache_alloc(
+		revoke_table_cache, GFP_KERNEL);
+	if (!journal->j_revoke_table[0])
+		goto failed_alloc1;
+	if (journal_init_revoke_table(journal->j_revoke_table[0], hash_size))
+		goto failed_init1;
 
-	journal->j_revoke->hash_shift = shift;
+	journal->j_revoke_table[1] = kmem_cache_alloc(
+		revoke_table_cache, GFP_KERNEL);
+	if (!journal->j_revoke_table[1])
+		goto failed_alloc2;
+	if (journal_init_revoke_table(journal->j_revoke_table[1], hash_size))
+		goto failed_init2;
 
-	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
-	if (!journal->j_revoke->hash_table) {
-		kfree(journal->j_revoke_table[0]->hash_table);
-		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
-		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[1]);
-		journal->j_revoke = NULL;
-		return -ENOMEM;
-	}
-
-	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
+	journal->j_revoke = journal->j_revoke_table[1];
 
 	spin_lock_init(&journal->j_revoke_lock);
 
 	return 0;
-}
 
-/* Destoy a journal's revoke table.  The table must already be empty! */
+failed_init2:
+	kmem_cache_free(revoke_table_cache, journal->j_revoke_table[1]);
+failed_alloc2:
+	kfree(journal->j_revoke_table[0]->hash_table);
+failed_init1:
+	kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
+failed_alloc1:
+	return -ENOMEM;
+}
 
-void journal_destroy_revoke(journal_t *journal)
+static void journal_destroy_revoke_table(struct jbd_revoke_table_s *table)
 {
-	struct jbd_revoke_table_s *table;
-	struct list_head *hash_list;
 	int i;
-
-	table = journal->j_revoke_table[0];
-	if (!table)
-		return;
-
-	for (i=0; i<table->hash_size; i++) {
+	struct list_head *hash_list;
+	for (i = 0; i < table->hash_size; i++) {
 		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
+		J_ASSERT(list_empty(hash_list));
 	}
 
 	kfree(table->hash_table);
 	kmem_cache_free(revoke_table_cache, table);
-	journal->j_revoke = NULL;
+}
 
-	table = journal->j_revoke_table[1];
-	if (!table)
+/* Destroy a journal's revoke table.  The table must already be empty! */
+void journal_destroy_revoke(journal_t *journal)
+{
+	if (!journal->j_revoke_table[0])
 		return;
+	journal_destroy_revoke_table(journal->j_revoke_table[0]);
+	journal->j_revoke = NULL;
 
-	for (i=0; i<table->hash_size; i++) {
-		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
-	}
