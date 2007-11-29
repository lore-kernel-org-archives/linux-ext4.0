From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] e2fsprogs: fix blkid whole-disk scanning heuristics
Date: Thu, 29 Nov 2007 12:57:35 -0600
Message-ID: <474F0B9F.5070902@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:19758 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762883AbXK2TbP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 14:31:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The heuristics in blkid/devname.c probe_all() for scanning whole disks
with no partitions assume that a device name with no digit on the end
will always be present as a delineator, i.e.:

sda
sda1
sdb
sdc

In this case, when sdc is seen, it's the clue to go back and scan sdb.

however, for something like:

sda
sda1
sdb
loop0

this falls down, and sdb is never scanned.
(thanks to Karel Zak for pointing this out).

I believe the following patch will fix this up, but when messing
with partition scanning, I don't mind a second opinion.  :)

Thanks,

-Eric

---

Addresses-Red-Hat-Bugzilla: #400321
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/lib/blkid/devname.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/blkid/devname.c
+++ e2fsprogs-1.40.2/lib/blkid/devname.c
@@ -490,10 +490,11 @@ static int probe_all(blkid_cache cache, 
 
 		DBG(DEBUG_DEVNAME, printf("read partition name %s\n", ptname));
 
-		/* Skip whole disk devs unless they have no partitions
-		 * If we don't have a partition on this dev, also
+		/* Skip whole disk devs unless they have no partitions.
+		 * If base name of device has changed, also
 		 * check previous dev to see if it didn't have a partn.
-		 * heuristic: partition name ends in a digit.
+		 * heuristic: partition name ends in a digit, & partition
+		 * names contain whole device name as substring.
 		 *
 		 * Skip extended partitions.
 		 * heuristic: size is 1
@@ -502,6 +503,8 @@ static int probe_all(blkid_cache cache, 
 		 */
 
 		lens[which] = strlen(ptname);
+
+		/* ends in a digit, clearly a partition, so check */
 		if (isdigit(ptname[lens[which] - 1])) {
 			DBG(DEBUG_DEVNAME,
 			    printf("partition dev %s, devno 0x%04X\n",
@@ -510,10 +513,15 @@ static int probe_all(blkid_cache cache, 
 			if (sz > 1)
 				probe_one(cache, ptname, devs[which], 0, 
 					  only_if_new);
-			lens[which] = 0;
-			lens[last] = 0;
-		} else if (lens[last] && strncmp(ptnames[last], ptname,
-						 lens[last])) {
+			lens[which] = 0;	/* mark as checked */
+		}
+
+		/*
+		 * If last was not checked because it looked like a whole-disk
+		 * dev, and the device's base name has changed,
+		 * check last as well.
+		 */
+		if (lens[last] && strncmp(ptnames[last], ptname, lens[last])) {
 			DBG(DEBUG_DEVNAME,
 			    printf("whole dev %s, devno 0x%04X\n",
 				   ptnames[last], (unsigned int) devs[last]));
