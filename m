From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] blkid: use /dev/mapper/<name> rather than /dev/dm-<N>
Date: Mon, 27 Apr 2009 15:00:57 +0200
Message-ID: <1240837258-5440-1-git-send-email-kzak@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Karel Zak <kzak@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41726 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZD0NBJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 09:01:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The libblkid (since v1.41.1) returns private device-mapper names (e.g.
/dev/dm-0). It's because the probe_one() function scans /dev before
/dev/mapper.

brw-rw---- 1 root disk 253, 0 2009-04-27 13:41 /dev/dm-0
brw-rw---- 1 root disk 253, 0 2009-04-27 13:41 /dev/mapper/TestVolGroup-TestLogVolume

Old version:
  # blkid -t LABEL="TEST-LABEL" -o device
  /dev/dm-0

Fixed version:
  # blkid -t LABEL="TEST-LABEL" -o device
  /dev/mapper/TestVolGroup-TestLogVolume

Addresses-Red-Hat-Bug: #497259
Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/blkid/devname.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 8553e9f..59c0919 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -179,6 +179,15 @@ static void probe_one(blkid_cache cache, const char *ptname,
 	if (dev && dev->bid_devno == devno)
 		goto set_pri;
 
+	/* Try to translate private device-mapper dm-<N> names
+	 * to standard /dev/mapper/<name>.
+	 */
+	if (!strncmp(ptname, "dm-", 3) && isdigit(ptname[3])) {
+		blkid__scan_dir("/dev/mapper", devno, 0, &devname);
+		if (devname)
+			goto get_dev;
+	}
+
 	/*
 	 * Take a quick look at /dev/ptname for the device number.  We check
 	 * all of the likely device directories.  If we don't find it, or if
@@ -197,17 +206,16 @@ static void probe_one(blkid_cache cache, const char *ptname,
 		if (stat(device, &st) == 0 && S_ISBLK(st.st_mode) &&
 		    st.st_rdev == devno) {
 			devname = blkid_strdup(device);
-			break;
+			goto get_dev;
 		}
 	}
-	/* Do a short-cut scan of /dev/mapper first */
-	if (!devname)
-		blkid__scan_dir("/dev/mapper", devno, 0, &devname);
 	if (!devname) {
 		devname = blkid_devno_to_devname(devno);
 		if (!devname)
 			return;
 	}
+
+get_dev:
 	dev = blkid_get_dev(cache, devname, BLKID_DEV_NORMAL);
 	free(devname);
 
-- 
1.6.0.6

