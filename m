From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] Revert "fs/mbcache.c: make count_objects() more robust"
Date: Sat,  6 Jan 2018 10:06:54 -0800
Message-ID: <20180106180654.7373-1-ebiggers3@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Jiang Biao <jiang.biao2@zte.com.cn>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44165 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbeAFSKO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Jan 2018 13:10:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

This reverts commit d5dabd633922ac5ee5bcc67748f7defb8b211469.

This patch did absolutely nothing, because ->c_entry_count is unsigned.

In addition if there is a bug in how mbcache maintains its entry count,
it needs to be fixed, not just hacked around.  (There is no obvious bug,
though.)

Cc: Jan Kara <jack@suse.cz>
Cc: Jiang Biao <jiang.biao2@zte.com.cn>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/mbcache.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index b8b8b9ced9f8..d818fd236787 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -269,9 +269,6 @@ static unsigned long mb_cache_count(struct shrinker *shrink,
 	struct mb_cache *cache = container_of(shrink, struct mb_cache,
 					      c_shrink);
 
-	/* Unlikely, but not impossible */
-	if (unlikely(cache->c_entry_count < 0))
-		return 0;
 	return cache->c_entry_count;
 }
 
-- 
2.15.1
