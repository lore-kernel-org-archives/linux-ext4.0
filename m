From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 1/3] jbd: eliminate duplicated code in revocation table init/destroy functions
Date: Sat,  3 May 2008 17:47:13 +0100
Message-ID: <1209833235-30521-2-git-send-email-duaneg@dghda.com>
References: <1209833235-30521-1-git-send-email-duaneg@dghda.com>
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3831 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314AbYECRHX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 May 2008 13:07:23 -0400
In-Reply-To: <1209833235-30521-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The revocation table initialisation/destruction code is repeated for each of
the two revocation tables stored in the journal. Refactoring the duplicated
code into functions is tidier, simplifies the logic in initialisation in
particular, and slightly reduces the code size.

There should not be any functional change.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd/revoke.c |  127 ++++++++++++++++++++++---------------------------------
 1 files changed, 51 insertions(+), 76 deletions(-)

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 1bb43e9..8ff5a7b 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -195,109 +195,84 @@ void journal_destroy_revoke_caches(void)
 	revoke_table_cache = NULL;
 }
 
-/* Initialise the revoke table for a given journal to a given size. */
-
-int journal_init_revoke(journal_t *journal, int hash_size)
+static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
 {
-	int shift, tmp;
+	int shift = 0;
+	int tmp = hash_size;
+	struct jbd_revoke_table_s *table;
 
-	J_ASSERT (journal->j_revoke_table[0] == NULL);
+	table = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
+	if (!table)
+		goto out;
 
-	shift = 0;
-	tmp = hash_size;
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
+	table->hash_size = hash_size;
+	table->hash_shift = shift;
+	table->hash_table =
 		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
-	if (!journal->j_revoke->hash_table) {
-		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
-		journal->j_revoke = NULL;
-		return -ENOMEM;
+	if (!table->hash_table) {
+		kmem_cache_free(revoke_table_cache, table);
+		table = NULL;
+		goto out;
 	}
 
 	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
+		INIT_LIST_HEAD(&table->hash_table[tmp]);
 
-	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
-	if (!journal->j_revoke_table[1]) {
-		kfree(journal->j_revoke_table[0]->hash_table);
-		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
-		return -ENOMEM;
+out:
+	return table;
+}
+
+static void journal_destroy_revoke_table(struct jbd_revoke_table_s *table)
+{
+	int i;
+	struct list_head *hash_list;
+
+	for (i = 0; i < table->hash_size; i++) {
+		hash_list = &table->hash_table[i];
+		J_ASSERT(list_empty(hash_list));
 	}
 
-	journal->j_revoke = journal->j_revoke_table[1];
+	kfree(table->hash_table);
+	kmem_cache_free(revoke_table_cache, table);
+}
 
-	/* Check that the hash_size is a power of two */
+/* Initialise the revoke table for a given journal to a given size. */
+int journal_init_revoke(journal_t *journal, int hash_size)
+{
+	J_ASSERT(journal->j_revoke_table[0] == NULL);
 	J_ASSERT(is_power_of_2(hash_size));
 
-	journal->j_revoke->hash_size = hash_size;
+	journal->j_revoke_table[0] = journal_init_revoke_table(hash_size);
+	if (!journal->j_revoke_table[0])
+		goto fail0;
 
-	journal->j_revoke->hash_shift = shift;
+	journal->j_revoke_table[1] = journal_init_revoke_table(hash_size);
+	if (!journal->j_revoke_table[1])
+		goto fail1;
 
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
+fail1:
+	journal_destroy_revoke_table(journal->j_revoke_table[0]);
+fail0:
+	return -ENOMEM;
+}
 
+/* Destroy a journal's revoke table.  The table must already be empty! */
 void journal_destroy_revoke(journal_t *journal)
 {
-	struct jbd_revoke_table_s *table;
-	struct list_head *hash_list;
-	int i;
-
-	table = journal->j_revoke_table[0];
-	if (!table)
-		return;
-
-	for (i=0; i<table->hash_size; i++) {
-		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
-	}
-
-	kfree(table->hash_table);
-	kmem_cache_free(revoke_table_cache, table);
-	journal->j_revoke = NULL;
-
-	table = journal->j_revoke_table[1];
-	if (!table)
-		return;
-
-	for (i=0; i<table->hash_size; i++) {
-		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
-	}
