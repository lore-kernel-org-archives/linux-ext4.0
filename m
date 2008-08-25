From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Mon, 25 Aug 2008 22:48:36 +0200
Message-ID: <1219697316-5632-1-git-send-email-kzak@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Karel Zak <kzak@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbYHYUsj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2008 16:48:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 * devname.c: probe_one(): call dm_device_is_leaf() with *constant*
   devno argument in the list_for_each_safe loop does not make sense at
   all.

 * devname.c: probe_one(): call dm_device_is_leaf() for already
   checked DM devices is unnecessary. DM devices are already checked
   in dm_probe_all(). The dm_probe_all() function never returns slave
   devices.

 * devname.c: dm_device_is_leaf(): stop checking for dependences when
   a first dependence is detected.

Performance test:

  # for i in $(seq 1 100); do dmsetup create $i --table "0 1 zero"; done

 new version:

  # blkid &> /dev/null

  real    0m0.267s
  user    0m0.047s
  sys     0m0.212s

 old version:

  # blkid &> /dev/null

  real    0m2.149s
  user    0m0.291s
  sys     0m1.820s

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/blkid/devname.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 86fd44c..4967b96 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -133,25 +133,27 @@ static void probe_one(blkid_cache cache, const char *ptname,
 	const char **dir;
 	char *devname = NULL;
 
-	/* See if we already have this device number in the cache. */
-	list_for_each_safe(p, pnext, &cache->bic_devs) {
-		blkid_dev tmp = list_entry(p, struct blkid_struct_dev,
-					   bid_devs);
 #ifdef HAVE_DEVMAPPER
-		if (!dm_device_is_leaf(devno))
-			continue;
+	/* call dm_device_is_leaf() for non-DM device only */
+	if (pri == BLKID_PRI_DM || dm_device_is_leaf(devno))
 #endif
-		if (tmp->bid_devno == devno) {
-			if (only_if_new && !access(tmp->bid_name, F_OK))
-				return;
-			dev = blkid_verify(cache, tmp);
-			if (dev && (dev->bid_flags & BLKID_BID_FL_VERIFIED))
-				break;
-			dev = 0;
+	{
+		/* See if we already have this device number in the cache. */
+		list_for_each_safe(p, pnext, &cache->bic_devs) {
+			blkid_dev tmp = list_entry(p, struct blkid_struct_dev,
+						   bid_devs);
+			if (tmp->bid_devno == devno) {
+				if (only_if_new && !access(tmp->bid_name, F_OK))
+					return;
+				dev = blkid_verify(cache, tmp);
+				if (dev && (dev->bid_flags & BLKID_BID_FL_VERIFIED))
+					break;
+				dev = 0;
+			}
 		}
+		if (dev && dev->bid_devno == devno)
+			goto set_pri;
 	}
-	if (dev && dev->bid_devno == devno)
-		goto set_pri;
 
 	/*
 	 * Take a quick look at /dev/ptname for the device number.  We check
@@ -271,9 +273,10 @@ static int dm_device_is_leaf(const dev_t dev)
 	do {
 		names = (struct dm_names *) ((char *)names + next);
 
-		if (dm_device_has_dep(dev, names->name))
+		if (dm_device_has_dep(dev, names->name)) {
 			ret = 0;
