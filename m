From: vignesh babu <vignesh.babu@wipro.com>
Subject: [PATCH]is_pwoer_of_2-jbd
Date: Wed, 13 Jun 2007 09:33:22 +0530
Message-ID: <1181707402.13391.30.camel@merlin.linuxcoe.com>
Reply-To: vignesh.babu@wipro.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Kernel Janitors List <kernel-janitors@lists.osdl.org>
To: sct@redhat.com, akpm <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:47180 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbXFMECU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2007 00:02:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 824e3b7..a6f9cad 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -68,6 +68,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #endif
+#include <linux/log2.h>
 
 static struct kmem_cache *revoke_record_cache;
 static struct kmem_cache *revoke_table_cache;
@@ -211,7 +212,7 @@ int journal_init_revoke(journal_t *journal, int hash_size)
 	journal->j_revoke = journal->j_revoke_table[0];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT (is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
@@ -238,7 +239,7 @@ int journal_init_revoke(journal_t *journal, int hash_size)
 	journal->j_revoke = journal->j_revoke_table[1];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT (is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 9246e76..dfcbccc 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -68,6 +68,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #endif
+#include <linux/log2.h>
 
 static struct kmem_cache *jbd2_revoke_record_cache;
 static struct kmem_cache *jbd2_revoke_table_cache;
@@ -212,7 +213,7 @@ int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
 	journal->j_revoke = journal->j_revoke_table[0];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT (is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
@@ -239,7 +240,7 @@ int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
 	journal->j_revoke = journal->j_revoke_table[1];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT (is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"
