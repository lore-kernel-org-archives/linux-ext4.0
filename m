From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH] ext4: Remove unnecessary NULL checks in ext4.
Date: Tue,  6 Feb 2018 19:15:30 +0800
Message-ID: <1517915730-11198-1-git-send-email-fxinrong@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sean Fu <fxinrong@gmail.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

NULL check is done in kmem_cache_destroy. So remove NULL checks in ext4.

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 fs/ext4/extents_status.c | 3 +--
 fs/ext4/mballoc.c        | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 763ef18..c4e6fb1 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -162,8 +162,7 @@ int __init ext4_init_es(void)
 
 void ext4_exit_es(void)
 {
-	if (ext4_es_cachep)
-		kmem_cache_destroy(ext4_es_cachep);
+	kmem_cache_destroy(ext4_es_cachep);
 }
 
 void ext4_es_init_tree(struct ext4_es_tree *tree)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d9f8b90a..4fd1349 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2549,8 +2549,7 @@ static void ext4_groupinfo_destroy_slabs(void)
 	int i;
 
 	for (i = 0; i < NR_GRPINFO_CACHES; i++) {
-		if (ext4_groupinfo_caches[i])
-			kmem_cache_destroy(ext4_groupinfo_caches[i]);
+		kmem_cache_destroy(ext4_groupinfo_caches[i]);
 		ext4_groupinfo_caches[i] = NULL;
 	}
 }
-- 
2.6.2
