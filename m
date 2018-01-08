From: Jiang Biao <jiang.biao2@zte.com.cn>
Subject: [PATCH v2] fs/mbcache: make sure mb_cache_count() not return negative value.
Date: Tue, 9 Jan 2018 07:38:11 +0800
Message-ID: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, ebiggers@google.com,
        akpm@linux-foundation.org, jack@suse.cz, jiang.biao2@zte.com.cn,
        zhong.weidong@zte.com.cn
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When running ltp stress test for 7*24 hours, vmscan occasionally emits the
following warning continuously:

mb_cache_scan+0x0/0x3f0 negative objects to delete
nr=-9232265467809300450
....

Trace info shows the freeable(mb_cache_count returns) is -1, which causes
the continuous accumulation and overflow of total_scan.

This patch makes sure that mb_cache_count() not return a negative value,
which makes the mbcache shrinker more robust.

Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Eric Biggers <ebiggers@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
---
 fs/mbcache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index b8b8b9c..2a800e3 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -238,7 +238,11 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
 			spin_lock(&cache->c_list_lock);
 			if (!list_empty(&entry->e_list)) {
 				list_del_init(&entry->e_list);
-				cache->c_entry_count--;
+				if (cache->c_entry_count > 0)
+					cache->c_entry_count--;
+				else
+					WARN_ONCE(1, "mbcache: Entry count "
+                          "going negative!\n");
 				atomic_dec(&entry->e_refcnt);
 			}
 			spin_unlock(&cache->c_list_lock);
-- 
2.7.4
