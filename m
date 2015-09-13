From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 07/39] fs: ext4: drop null test before destroy functions
Date: Sun, 13 Sep 2015 14:15:00 +0200
Message-ID: <1442146532-9100-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: sergey.senozhatsky@gmail.com, kernel-janitors@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression x; @@
-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/ext4/crypto.c         |    9 +++------
 fs/ext4/extents_status.c |    3 +--
 fs/ext4/mballoc.c        |    3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 26724ae..42096d3 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -161,8 +161,7 @@ int __init ext4_init_es(void)
 
 void ext4_exit_es(void)
 {
-	if (ext4_es_cachep)
-		kmem_cache_destroy(ext4_es_cachep);
+	kmem_cache_destroy(ext4_es_cachep);
 }
 
 void ext4_es_init_tree(struct ext4_es_tree *tree)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34b610e..b5adfb9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2520,8 +2520,7 @@ static void ext4_groupinfo_destroy_slabs(void)
 	int i;
 
 	for (i = 0; i < NR_GRPINFO_CACHES; i++) {
-		if (ext4_groupinfo_caches[i])
-			kmem_cache_destroy(ext4_groupinfo_caches[i]);
+		kmem_cache_destroy(ext4_groupinfo_caches[i]);
 		ext4_groupinfo_caches[i] = NULL;
 	}
 }
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 4573155..e4d6d30 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -153,17 +153,14 @@ void ext4_exit_crypto(void)
 	list_for_each_entry_safe(pos, n, &ext4_free_crypto_ctxs, free_list)
 		kmem_cache_free(ext4_crypto_ctx_cachep, pos);
 	INIT_LIST_HEAD(&ext4_free_crypto_ctxs);
-	if (ext4_bounce_page_pool)
-		mempool_destroy(ext4_bounce_page_pool);
+	mempool_destroy(ext4_bounce_page_pool);
 	ext4_bounce_page_pool = NULL;
 	if (ext4_read_workqueue)
 		destroy_workqueue(ext4_read_workqueue);
 	ext4_read_workqueue = NULL;
-	if (ext4_crypto_ctx_cachep)
-		kmem_cache_destroy(ext4_crypto_ctx_cachep);
+	kmem_cache_destroy(ext4_crypto_ctx_cachep);
 	ext4_crypto_ctx_cachep = NULL;
-	if (ext4_crypt_info_cachep)
-		kmem_cache_destroy(ext4_crypt_info_cachep);
+	kmem_cache_destroy(ext4_crypt_info_cachep);
 	ext4_crypt_info_cachep = NULL;
 }
 
