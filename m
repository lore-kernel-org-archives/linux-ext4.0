From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] blkid: use /sys/block/dm-<N>/dm/name
Date: Mon, 27 Apr 2009 15:00:58 +0200
Message-ID: <1240837258-5440-2-git-send-email-kzak@redhat.com>
References: <1240837258-5440-1-git-send-email-kzak@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Karel Zak <kzak@redhat.com>, Milan Broz <mbroz@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZD0NBK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 09:01:10 -0400
In-Reply-To: <1240837258-5440-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The Linux kernel (since 2.6.29, patch 784aae735d9b0bba3f8b9faef4c8b30df3bf0128)
exports the real DM device names in /sys/block/<ptname>/dm/name.

The sysfs based solution is nicer and faster than scan for devno in
/dev/mapper/.

CC: Milan Broz <mbroz@redhat.com>
Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/blkid/devname.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 59c0919..4dde766 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -153,6 +153,30 @@ static int is_dm_leaf(const char *devname)
 }
 
 /*
+ * Since 2.6.29 (patch 784aae735d9b0bba3f8b9faef4c8b30df3bf0128) kernel sysfs
+ * provides the real DM device names in /sys/block/<ptname>/dm/name
+ */
+static char *get_dm_name(const char *ptname)
+{
+	FILE	*f;
+	size_t	sz;
+	char	path[256], name[256], *res = NULL;
+
+	snprintf(path, sizeof(path), "/sys/block/%s/dm/name", ptname);
+	if ((f = fopen(path, "r")) == NULL)
+		return NULL;
+
+	/* read "<name>\n" from sysfs */
+	if (fgets(name, sizeof(name), f) && (sz = strlen(name)) > 1) {
+		name[sz - 1] = '\0';
+		snprintf(path, sizeof(path), "/dev/mapper/%s", name);
+		res = blkid_strdup(path);
+	}
+	fclose(f);
+	return res;
+}
+
+/*
  * Probe a single block device to add to the device cache.
  */
 static void probe_one(blkid_cache cache, const char *ptname,
@@ -183,7 +207,9 @@ static void probe_one(blkid_cache cache, const char *ptname,
 	 * to standard /dev/mapper/<name>.
 	 */
 	if (!strncmp(ptname, "dm-", 3) && isdigit(ptname[3])) {
-		blkid__scan_dir("/dev/mapper", devno, 0, &devname);
+		devname = get_dm_name(ptname);
+		if (!devname)
+			blkid__scan_dir("/dev/mapper", devno, 0, &devname);
 		if (devname)
 			goto get_dev;
 	}
-- 
1.6.0.6

