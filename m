From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 2/3] ext4: check for need init flag in ext4_mb_load_buddy
Date: Mon,  7 Sep 2009 15:08:13 +0530
Message-ID: <1252316294-10164-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46145 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZIGJi2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 05:38:28 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id n879a7KC000647
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:36:07 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n879cUnd1167578
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:38:30 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n879cT5t014760
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:38:30 +1000
In-Reply-To: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should check for need init flag with group info alloc_sem
held. That would make sure when we are loading the buddy cache
and holding a reference to it a file system resize can't add
new blocks to same group.

The patch also drops for the need init flag check in
ext4_mb_regular_allocator because doing the check without holding
alloc_sem is racy


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 78e907d..4ed869e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1032,8 +1032,26 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	 * groups mapped by the page is blocked
 	 * till we are done with allocation
 	 */
+repeat_load_buddy:
 	down_read(e4b->alloc_semp);
 
+	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+		/* we need to check for group need init flag
+		 * with alloc_semp held so that we can be sure
+		 * that new blocks didn't get added to the group
+		 * when we are loading the buddy cache
+		 */
+		up_read(e4b->alloc_semp);
+		/*
+		 * we need full data about the group
+		 * to make a good selection
+		 */
+		ret = ext4_mb_init_group(sb, group);
+		if (ret)
+			return ret;
+		goto repeat_load_buddy;
+	}
+
 	/*
 	 * the buddy cache inode stores the block bitmap
 	 * and buddy information in consecutive blocks.
@@ -2015,27 +2033,6 @@ repeat:
 			if (grp->bb_free == 0)
 				continue;
 
-			/*
-			 * if the group is already init we check whether it is
-			 * a good group and if not we don't load the buddy
-			 */
-			if (EXT4_MB_GRP_NEED_INIT(grp)) {
-				/*
-				 * we need full data about the group
-				 * to make a good selection
-				 */
-				err = ext4_mb_init_group(sb, group);
-				if (err)
-					goto out;
-			}
-
-			/*
-			 * If the particular group doesn't satisfy our
-			 * criteria we continue with the next group
-			 */
-			if (!ext4_mb_good_group(ac, group, cr))
-				continue;
