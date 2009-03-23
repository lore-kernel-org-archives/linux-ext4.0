From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] remove whole-disk entries from cache when partitions are
 found
Date: Mon, 23 Mar 2009 11:51:51 -0500
Message-ID: <49C7BE27.2090702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbZCWQwJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Mar 2009 12:52:09 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n2NGq7eL027839
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2009 12:52:07 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NGq2wb021159
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2009 12:52:03 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n2NGq69w032172
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2009 12:52:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can get into a situation in blkid where whole disks remain
in the cache, even though partitions are found.  For labels
such as sun disklabels which may have the first partition
beginning at sector 0, this is even somewhat likely.

1) create a sun disklabel w/partitions
2) mkfs the first partition (at sector 0)
3) remove the partition table
4) run blkid - this finds the fs on the whole disk, places in cache
5) recreate the partition table
6) run blkid - this finds the partition, places in cache

And now we have both /dev/sda and /dev/sda1 in cache.

There are heuristics in probe_all to avoid putting the whole disk
in cache if it has partitions, but there is nothing to remove the
whole-disk entry in the above case.  I think the below patch 
suffices, although I haven't quite convinced myself that setting 
the lens[which]=0; is the right logic for that bit of state...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/blkid/devname.c
===================================================================
--- e2fsprogs.orig/lib/blkid/devname.c
+++ e2fsprogs/lib/blkid/devname.c
@@ -365,6 +365,7 @@ static int probe_all(blkid_cache cache, 
 	unsigned long long sz;
 	int lens[2] = { 0, 0 };
 	int which = 0, last = 0;
+	struct list_head *p, *pnext;
 
 	ptnames[0] = ptname0;
 	ptnames[1] = ptname1;
@@ -425,6 +428,29 @@ static int probe_all(blkid_cache cache, 
 		}
 
 		/*
+		 * If last was a whole disk and we just found a partition
+		 * on it, remove the whole-disk dev from the cache if
+		 * it exists.
+		 */
+		if (lens[last] && !strncmp(ptnames[last], ptname, lens[last])) {
+			list_for_each_safe(p, pnext, &cache->bic_devs) {
+				blkid_dev tmp;
+
+				/* find blkid dev for the whole-disk devno */
+				tmp = list_entry(p, struct blkid_struct_dev,
+						 bid_devs);
+				if (tmp->bid_devno == devs[last]) {
+					DBG(DEBUG_DEVNAME,
+						printf("freeing %s\n",
+						       tmp->bid_name));
+					blkid_free_dev(tmp);
+					cache->bic_flags |= BLKID_BIC_FL_CHANGED;
+					break;
+				}
+			}
+			lens[last] = 0;
+		}
+		/*
 		 * If last was not checked because it looked like a whole-disk
 		 * dev, and the device's base name has changed,
 		 * check last as well.


