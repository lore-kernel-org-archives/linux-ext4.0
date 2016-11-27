From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 1/5] mbcache: correctly handle 'e_referenced' bit
Date: Sat, 26 Nov 2016 22:17:57 -0800
Message-ID: <1480227481-98535-1-git-send-email-ebiggers@google.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36644 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbcK0GSd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:18:33 -0500
Received: by mail-pg0-f52.google.com with SMTP id f188so44197938pgc.3
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:18:12 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mbcache entries have an 'e_referenced' bit which users can set with
mb_cache_entry_touch() to indicate that an entry should be given another
pass through the LRU list before the shrinker can delete it.  However,
mb_cache_shrink() actually would, when seeing an e_referenced entry at
the front of the list (the least-recently used end), place it right at
the front of the list again.  The next iteration would then remove the
entry from the list and delete it.  Consequently, e_referenced had
essentially no effect, so ext2/ext4 xattr blocks would sometimes not be
reused as often as expected.

Fix this by making the shrinker move e_referenced entries to the back of
the list rather than the front.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/mbcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index c5bd19f..31e54c2 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -286,7 +286,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 					 struct mb_cache_entry, e_list);
 		if (entry->e_referenced) {
 			entry->e_referenced = 0;
-			list_move_tail(&cache->c_list, &entry->e_list);
+			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
 		}
 		list_del_init(&entry->e_list);
-- 
2.8.0.rc3.226.g39d4020

