From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 2/2] blkid: fix broken garbage collection
Date: Thu, 20 Jun 2013 01:14:01 +0800
Message-ID: <1371662041-20710-2-git-send-email-guaneryu@gmail.com>
References: <1371662041-20710-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54874 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934968Ab3FSRPS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jun 2013 13:15:18 -0400
Received: by mail-pd0-f180.google.com with SMTP id 10so5281719pdi.39
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jun 2013 10:15:17 -0700 (PDT)
In-Reply-To: <1371662041-20710-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'blkid -g' fails to perform garbage collection on the blkid cache
since commit

fe144e1 libblkid: Refuse to create a device structure for a non-existent device

Non-existent devices won't be added to the cache->bic_devs list, so
blkid_gc_cache() couldn't even know the to-be-gc'ed devices.

To fix that a new cache flag BLKID_BIC_FL_GC is added to indicate that
there are stale devices in cache to be gc'ed, as devices are all valid
in cache->bic_devs we can just write out the cache to disk to perform
the garbage collection.

Tested by adding non-existent device entry to blkid.tab and running
'blkid -g' to see whether the entry is removed. 'make -C lib/blkid
check' reported no failures too.

Also fix the return value of 'blkid -g', return 0 instead.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 lib/blkid/blkidP.h  |  1 +
 lib/blkid/cache.c   | 25 +++++++------------------
 lib/blkid/devname.c |  4 +++-
 misc/blkid.c        |  1 +
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/lib/blkid/blkidP.h b/lib/blkid/blkidP.h
index a99b242..f236400 100644
--- a/lib/blkid/blkidP.h
+++ b/lib/blkid/blkidP.h
@@ -100,6 +100,7 @@ struct blkid_struct_cache
 
 #define BLKID_BIC_FL_PROBED	0x0002	/* We probed /proc/partition devices */
 #define BLKID_BIC_FL_CHANGED	0x0004	/* Cache has changed from disk */
+#define BLKID_BIC_FL_GC		0x0008	/* Cache has stale devices */
 
 extern char *blkid_strdup(const char *s);
 extern char *blkid_strndup(const char *s, const int length);
diff --git a/lib/blkid/cache.c b/lib/blkid/cache.c
index 1b6a86d..0a68639 100644
--- a/lib/blkid/cache.c
+++ b/lib/blkid/cache.c
@@ -159,26 +159,15 @@ void blkid_put_cache(blkid_cache cache)
 
 void blkid_gc_cache(blkid_cache cache)
 {
-	struct list_head *p, *pnext;
-	struct stat st;
-
-	if (!cache)
+	if (!cache || !(cache->bic_flags & BLKID_BIC_FL_GC))
 		return;
 
-	list_for_each_safe(p, pnext, &cache->bic_devs) {
-		blkid_dev dev = list_entry(p, struct blkid_struct_dev, bid_devs);
-		if (!p)
-			break;
-		if (stat(dev->bid_name, &st) < 0) {
-			DBG(DEBUG_CACHE,
-			    printf("freeing %s\n", dev->bid_name));
-			blkid_free_dev(dev);
-			cache->bic_flags |= BLKID_BIC_FL_CHANGED;
-		} else {
-			DBG(DEBUG_CACHE,
-			    printf("Device %s exists\n", dev->bid_name));
-		}
-	}
+	/*
+	 * Only valid devices are kept in cache, set BLKID_BIC_FL_CHANGED
+	 * to write cache to disk to perform a garbage collection.
+	 */
+	cache->bic_flags |= BLKID_BIC_FL_CHANGED;
+	return;
 }
 
 
diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index a6673c1..0d8e66f 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -66,8 +66,10 @@ blkid_dev blkid_get_dev(blkid_cache cache, const char *devname, int flags)
 	}
 
 	if (!dev && (flags & BLKID_DEV_CREATE)) {
-		if (access(devname, F_OK) < 0)
+		if (access(devname, F_OK) < 0) {
+			cache->bic_flags |= BLKID_BIC_FL_GC;
 			return NULL;
+		}
 		dev = blkid_new_dev();
 		if (!dev)
 			return NULL;
diff --git a/misc/blkid.c b/misc/blkid.c
index a4a8db0..b269eeb 100644
--- a/misc/blkid.c
+++ b/misc/blkid.c
@@ -365,6 +365,7 @@ int main(int argc, char **argv)
 	err = 2;
 	if (gc) {
 		blkid_gc_cache(cache);
+		err = 0;
 		goto exit;
 	}
 	if (output_format & OUTPUT_PRETTY_LIST)
-- 
1.8.2.1

