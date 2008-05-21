From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix delalloc sync hang with journal lock inversion
Date: Wed, 21 May 2008 23:14:17 +0530
Message-ID: <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:49976 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936636AbYEURpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 13:45:07 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4LHithX026827
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:55 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHihic1220778
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:43 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4LHid4B018587
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 23:14:39 +0530
In-Reply-To: <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 46cc610..076d00f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1571,13 +1571,17 @@ static int ext4_da_writepages(struct address_space *mapping,
 		 */
 		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
 			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
-		to_write -= wbc->nr_to_write;
 
+		to_write -= wbc->nr_to_write;
 		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
 		ext4_journal_stop(handle);
-		to_write +=wbc->nr_to_write;
+		if (wbc->nr_to_write) {
+			/* We failed to write what we requested for */
+			to_write += wbc->nr_to_write;
+			break;
+		}
+		wbc->nr_to_write = to_write;
 	}
