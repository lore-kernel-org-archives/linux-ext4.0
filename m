From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext4: Return unwritten buffer head when trying to read from prealloc space.
Date: Fri, 21 Mar 2008 11:48:57 +0530
Message-ID: <1206080337-8732-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	Solofo.Ramangalahy@bull.net, dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:35836 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYCUGTL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Mar 2008 02:19:11 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2L6InA5008372
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 17:18:49 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2L6Ms3Z240410
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 17:22:54 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2L6J7p8028192
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 17:19:08 +1100
In-Reply-To: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_get_blocks  returns number of blocks allocated with buffer head
unmapped for a read from prealloc space. This is needed so that delayed
allocation doesn't do block reservation for prealloc space since the blocks
are already resevred on disk. Fix ext4_ext_get_blocks to not return greater
than max_blocks and also mark the buffer head unwritten. Some code path tries
to read the block if buffer_head is not new and no uptodate. Marking the buffer
head unwritten avoid this reading.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d6ae40a..edd1bf2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2600,8 +2600,20 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			}
 			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
 				goto out;
-			if (!create)
+			if (!create) {
+				/*
+				 * We have blocks reserved already. We
+				 * return allocated blocks so that delalloc
+				 * won't do block reservation for us. But
+				 * the buffer head will be unmapped so that
+				 * a read from the block return 0
+				 */
+				if (allocated > max_blocks)
+					allocated = max_blocks;
+				/* mark the buffer unwritten */
+				__set_bit(BH_Unwritten, &bh_result->b_state);
 				goto out2;
+			}
 
 			ret = ext4_ext_convert_to_initialized(handle, inode,
 								path, iblock,
-- 
1.5.5.rc0.16.g02b00.dirty

