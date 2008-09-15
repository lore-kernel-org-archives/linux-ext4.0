From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] libblki: fix s_feature_compat usage
Date: Mon, 15 Sep 2008 14:03:29 +0200
Message-ID: <1221480209-982-1-git-send-email-kzak@redhat.com>
Cc: linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYIOMDa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Sep 2008 08:03:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note that this patch also fix minor coding still errors.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/blkid/probe.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 10ac803..7bb7470 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -150,7 +150,7 @@ static void get_ext2_info(blkid_dev dev, struct blkid_magic *id,
 
 	set_uuid(dev, es->s_uuid, 0);
 
-	if ((es->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+	if ((blkid_le32(es->s_feature_compat) & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
 	    !uuid_is_null(es->s_journal_uuid))
 		set_uuid(dev, es->s_journal_uuid, "EXT_JOURNAL");
 
@@ -171,7 +171,7 @@ static int fs_proc_check(const char *fs_name)
 
 	f = fopen("/proc/filesystems", "r");
 	if (!f)
-		return (0);
+		return 0;
 	while (!feof(f)) {
 		if (!fgets(buf, sizeof(buf), f))
 			break;
@@ -190,11 +190,11 @@ static int fs_proc_check(const char *fs_name)
 			*t = 0;
 		if (!strcmp(fs_name, cp)) {
 			fclose(f);
-			return (1);
+			return 1;
 		}
 	}
 	fclose(f);
-	return (0);
+	return 0;
 }
 
 /*
@@ -209,12 +209,12 @@ static int check_for_modules(const char *fs_name)
 	int		i;
 
 	if (uname(&uts))
-		return (0);
+		return 0;
 	snprintf(buf, sizeof(buf), "/lib/modules/%s/modules.dep", uts.release);
 
 	f = fopen(buf, "r");
 	if (!f)
-		return (0);
+		return 0;
 	while (!feof(f)) {
 		if (!fgets(buf, sizeof(buf), f))
 			break;
@@ -231,10 +231,10 @@ static int check_for_modules(const char *fs_name)
 				*t = 0;
 		}
 		if (!strcmp(cp, fs_name))
-			return (1);
+			return 1;
 	}
 	fclose(f);
-	return (0);
+	return 0;
 }
 
 static int system_supports_ext4(void)
@@ -1567,7 +1567,7 @@ int main(int argc, char **argv)
 	dev = blkid_get_dev(cache, argv[1], BLKID_DEV_NORMAL);
 	if (!dev) {
 		printf("%s: %s has an unsupported type\n", argv[0], argv[1]);
-		return (1);
+		return 1;
 	}
 	printf("TYPE='%s'\n", dev->bid_type ? dev->bid_type : "(null)");
 	if (dev->bid_label)
@@ -1576,6 +1576,6 @@ int main(int argc, char **argv)
 		printf("UUID='%s'\n", dev->bid_uuid);
 
 	blkid_free_dev(dev);
-	return (0);
+	return 0;
 }
 #endif
-- 
1.5.5.1

