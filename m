From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5/5] mbcache: document that "find" functions only return reusable entries
Date: Sat, 26 Nov 2016 22:18:01 -0800
Message-ID: <1480227481-98535-5-git-send-email-ebiggers@google.com>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33637 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbcK0GSd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:18:33 -0500
Received: by mail-pg0-f41.google.com with SMTP id 3so44465641pgd.0
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:18:33 -0800 (PST)
In-Reply-To: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mb_cache_entry_find_first() and mb_cache_entry_find_next() only return
cache entries with the 'e_reusable' bit set.  This should be documented.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/mbcache.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index bf65906..b19be42 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -155,12 +155,12 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 }
 
 /*
- * mb_cache_entry_find_first - find the first entry in cache with given key
+ * mb_cache_entry_find_first - find the first reusable entry with the given key
  * @cache: cache where we should search
  * @key: key to look for
  *
- * Search in @cache for entry with key @key. Grabs reference to the first
- * entry found and returns the entry.
+ * Search in @cache for a reusable entry with key @key. Grabs reference to the
+ * first reusable entry found and returns the entry.
  */
 struct mb_cache_entry *mb_cache_entry_find_first(struct mb_cache *cache,
 						 u32 key)
@@ -170,14 +170,14 @@ struct mb_cache_entry *mb_cache_entry_find_first(struct mb_cache *cache,
 EXPORT_SYMBOL(mb_cache_entry_find_first);
 
 /*
- * mb_cache_entry_find_next - find next entry in cache with the same
+ * mb_cache_entry_find_next - find next reusable entry with the same key
  * @cache: cache where we should search
  * @entry: entry to start search from
  *
- * Finds next entry in the hash chain which has the same key as @entry.
- * If @entry is unhashed (which can happen when deletion of entry races
- * with the search), finds the first entry in the hash chain. The function
- * drops reference to @entry and returns with a reference to the found entry.
+ * Finds next reusable entry in the hash chain which has the same key as @entry.
+ * If @entry is unhashed (which can happen when deletion of entry races with the
+ * search), finds the first reusable entry in the hash chain. The function drops
+ * reference to @entry and returns with a reference to the found entry.
  */
 struct mb_cache_entry *mb_cache_entry_find_next(struct mb_cache *cache,
 						struct mb_cache_entry *entry)
-- 
2.8.0.rc3.226.g39d4020

