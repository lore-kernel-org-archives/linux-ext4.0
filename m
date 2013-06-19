From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2] blkid: use proper statement instead of 0
Date: Thu, 20 Jun 2013 01:14:00 +0800
Message-ID: <1371662041-20710-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59390 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934968Ab3FSRPJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jun 2013 13:15:09 -0400
Received: by mail-pa0-f42.google.com with SMTP id rl6so5400210pac.15
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jun 2013 10:15:09 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

NULL for pointers and '\0' for chars are more proper than 0.

Also fix a comment to match the code, bic_list should be bic_devs.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 lib/blkid/blkidP.h | 2 +-
 lib/blkid/cache.c  | 2 +-
 lib/blkid/read.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/blkid/blkidP.h b/lib/blkid/blkidP.h
index e0f11a0..a99b242 100644
--- a/lib/blkid/blkidP.h
+++ b/lib/blkid/blkidP.h
@@ -83,7 +83,7 @@ typedef struct blkid_struct_tag *blkid_tag;
 #define BLKID_PROBE_INTERVAL	200
 
 /* This describes an entire blkid cache file and probed devices.
- * We can traverse all of the found devices via bic_list.
+ * We can traverse all of the found devices via bic_devs.
  * We can traverse all of the tag types by bic_tags, which hold empty tags
  * for each tag type.  Those tags can be used as list_heads for iterating
  * through all devices with a specific tag type (e.g. LABEL).
diff --git a/lib/blkid/cache.c b/lib/blkid/cache.c
index 8bdd239..1b6a86d 100644
--- a/lib/blkid/cache.c
+++ b/lib/blkid/cache.c
@@ -105,7 +105,7 @@ int blkid_get_cache(blkid_cache *ret_cache, const char *filename)
 	INIT_LIST_HEAD(&cache->bic_tags);
 
 	if (filename && !strlen(filename))
-		filename = 0;
+		filename = NULL;
 	if (!filename)
 		filename = safe_getenv("BLKID_FILE");
 	if (!filename)
diff --git a/lib/blkid/read.c b/lib/blkid/read.c
index efc348b..f182235 100644
--- a/lib/blkid/read.c
+++ b/lib/blkid/read.c
@@ -415,7 +415,7 @@ void blkid_read_cache(blkid_cache cache)
 		unsigned int end;
 
 		lineno++;
-		if (buf[0] == 0)
+		if (buf[0] == '\0')
 			continue;
 		end = strlen(buf) - 1;
 		/* Continue reading next line if it ends with a backslash */
-- 
1.8.2.1

