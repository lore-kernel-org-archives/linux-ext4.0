From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] blkid: add support to the -w option
Date: Mon, 28 Sep 2009 18:53:48 +0800
Message-ID: <1254135228-28428-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f191.google.com ([209.85.222.191]:33132 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZI1KyH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Sep 2009 06:54:07 -0400
Received: by pzk29 with SMTP id 29so2314869pzk.33
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2009 03:54:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blkid -w should write an alternative cache file but it is not implemented.
The patch makes it work properly.

Addresses-Launchpad-bug: #316322

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 lib/blkid/blkid.h |    1 +
 lib/blkid/cache.c |   13 +++++++++++++
 misc/blkid.c      |    1 +
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/lib/blkid/blkid.h b/lib/blkid/blkid.h
index 81f3098..7f66261 100644
--- a/lib/blkid/blkid.h
+++ b/lib/blkid/blkid.h
@@ -51,6 +51,7 @@ typedef struct blkid_struct_dev_iterate *blkid_dev_iterate;
 extern void blkid_put_cache(blkid_cache cache);
 extern int blkid_get_cache(blkid_cache *cache, const char *filename);
 extern void blkid_gc_cache(blkid_cache cache);
+extern void blkid_set_cachefile(blkid_cache cache, const char *filename);
 
 /* dev.c */
 extern const char *blkid_dev_devname(blkid_dev dev);
diff --git a/lib/blkid/cache.c b/lib/blkid/cache.c
index 2b81886..4676375 100644
--- a/lib/blkid/cache.c
+++ b/lib/blkid/cache.c
@@ -175,6 +175,19 @@ void blkid_gc_cache(blkid_cache cache)
 	}
 }
 
+void blkid_set_cachefile(blkid_cache cache, const char *filename)
+{
+	if (!cache || !filename)
+		return;
+
+	if (! strcmp(cache->bic_filename, filename))
+		return;
+	free(cache->bic_filename);
+	cache->bic_filename = blkid_strdup(filename);
+	/* Always mark cache file changed if another cache file is specified */
+	cache->bic_flags |= BLKID_BIC_FL_CHANGED;
+}
+
 
 #ifdef TEST_PROGRAM
 int main(int argc, char** argv)
diff --git a/misc/blkid.c b/misc/blkid.c
index 388abad..5540da7 100644
--- a/misc/blkid.c
+++ b/misc/blkid.c
@@ -417,6 +417,7 @@ int main(int argc, char **argv)
 			err = 0;
 		}
 	}
+	blkid_set_cachefile(cache, write);
 
 exit:
 	free(search_type);
-- 
1.6.5.rc2.262.g5224f

