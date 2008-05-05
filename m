From: akpm@linux-foundation.org
Subject: + jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch added to -mm tree
Date: Mon, 05 May 2008 14:43:31 -0700
Message-ID: <200805052143.m45LhVDO006604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: tidy up revoke cache initialisation and destruction
has been added to the -mm tree.  Its filename is
     jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: tidy up revoke cache initialisation and destruction
From: "Duane Griffin" <duaneg@dghda.com>

Make revoke cache destruction safe to call if initialisation fails partially
or entirely.  This allows it to be used to cleanup in the case of
initialisation failure, simplifying that code slightly.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/revoke.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN fs/jbd/revoke.c~jbd-tidy-up-revoke-cache-initialisation-and-destruction fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~jbd-tidy-up-revoke-cache-initialisation-and-destruction
+++ a/fs/jbd/revoke.c
@@ -166,33 +166,41 @@ static struct jbd_revoke_record_s *find_
 	return NULL;
 }
 
+void journal_destroy_revoke_caches(void)
+{
+	if (revoke_record_cache) {
+		kmem_cache_destroy(revoke_record_cache);
+		revoke_record_cache = NULL;
+	}
+	if (revoke_table_cache) {
+		kmem_cache_destroy(revoke_table_cache);
+		revoke_table_cache = NULL;
+	}
+}
+
 int __init journal_init_revoke_caches(void)
 {
+	J_ASSERT(!revoke_record_cache);
+	J_ASSERT(!revoke_table_cache);
+
 	revoke_record_cache = kmem_cache_create("revoke_record",
 					   sizeof(struct jbd_revoke_record_s),
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
 	if (!revoke_record_cache)
-		return -ENOMEM;
+		goto record_cache_failure;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (!revoke_table_cache) {
-		kmem_cache_destroy(revoke_record_cache);
-		revoke_record_cache = NULL;
-		return -ENOMEM;
-	}
-	return 0;
-}
+	if (!revoke_table_cache)
+		goto table_cache_failure;
 
-void journal_destroy_revoke_caches(void)
-{
-	kmem_cache_destroy(revoke_record_cache);
-	revoke_record_cache = NULL;
-	kmem_cache_destroy(revoke_table_cache);
-	revoke_table_cache = NULL;
+table_cache_failure:
+	journal_destroy_revoke_caches();
+record_cache_failure:
+	return -ENOMEM;
 }
 
 static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
jbd-replace-potentially-false-assertion-with-if-block.patch

