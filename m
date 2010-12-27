From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH] Resolve 'dereferencing pointer to incomplete type' when enabling EXT2_XATTR_DEBUG
Date: Mon, 27 Dec 2010 13:46:38 -0800
Message-ID: <1293486398-25909-1-git-send-email-johunt@akamai.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:44159 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab0L0VzD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Dec 2010 16:55:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When I enable EXT2_XATTR_DEBUG in fs/ext2/xattr.c I get a build error stating
the following:

  CC      fs/ext2/xattr.o
fs/ext2/xattr.c: In function 'ext2_xattr_cache_insert':
fs/ext2/xattr.c:841: error: dereferencing pointer to incomplete type
fs/ext2/xattr.c:846: error: dereferencing pointer to incomplete type
make[2]: *** [fs/ext2/xattr.o] Error 1
make[1]: *** [fs/ext2] Error 2
make: *** [fs] Error 2

These lines reference ext2_xattr_cache->c_entry_count which is defined
in struct mb_cache. struct mb_cache is currently only defined in fs/mbcache.c.
Moving struct mb_cache definition to include/linux/mbcache.h to resolve the
issue.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 fs/mbcache.c            |   12 ------------
 include/linux/mbcache.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 9344474..a25444a 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -76,18 +76,6 @@ EXPORT_SYMBOL(mb_cache_entry_find_first);
 EXPORT_SYMBOL(mb_cache_entry_find_next);
 #endif
 
-struct mb_cache {
-	struct list_head		c_cache_list;
-	const char			*c_name;
-	atomic_t			c_entry_count;
-	int				c_max_entries;
-	int				c_bucket_bits;
-	struct kmem_cache		*c_entry_cache;
-	struct list_head		*c_block_hash;
-	struct list_head		*c_index_hash;
-};
-
-
 /*
  * Global data: list of all mbcache's, lru list, and a spinlock for
  * accessing cache data structures on SMP machines. The lru list is
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 54cbbac..5525d37 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -18,6 +18,17 @@ struct mb_cache_entry {
 	} e_index;
 };
 
+struct mb_cache {
+	struct list_head		c_cache_list;
+	const char			*c_name;
+	atomic_t			c_entry_count;
+	int				c_max_entries;
+	int				c_bucket_bits;
+	struct kmem_cache		*c_entry_cache;
+	struct list_head		*c_block_hash;
+	struct list_head		*c_index_hash;
+};
+
 /* Functions on caches */
 
 struct mb_cache *mb_cache_create(const char *, int);
-- 
1.7.0.4

