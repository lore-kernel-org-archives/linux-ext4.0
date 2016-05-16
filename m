From: Chao Yu <chao@kernel.org>
Subject: [PATCH] mbcache: fix to detect failure of register_shrinker
Date: Mon, 16 May 2016 23:16:38 +0800
Message-ID: <1463411798-2597-1-git-send-email-chao@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>
To: tytso@mit.edu, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40638 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbcEPPTF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2016 11:19:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Chao Yu <yuchao0@huawei.com>

register_shrinker in mb_cache_create may fail due to no memory. This
patch fixes to do the check of return value of register_shrinker and
handle the error case, otherwise mb_cache_create may return with no
error, but losing the inner shrinker.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 fs/mbcache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index eccda3a..c5bd19f 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -366,7 +366,11 @@ struct mb_cache *mb_cache_create(int bucket_bits)
 	cache->c_shrink.count_objects = mb_cache_count;
 	cache->c_shrink.scan_objects = mb_cache_scan;
 	cache->c_shrink.seeks = DEFAULT_SEEKS;
-	register_shrinker(&cache->c_shrink);
+	if (register_shrinker(&cache->c_shrink)) {
+		kfree(cache->c_hash);
+		kfree(cache);
+		goto err_out;
+	}
 
 	INIT_WORK(&cache->c_shrink_work, mb_cache_shrink_worker);
 
-- 
2.7.2

