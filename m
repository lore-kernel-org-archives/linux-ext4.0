From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Return error if we fail to allocate block in noalloc_get_block_write
Date: Wed,  1 Jul 2009 15:16:15 +0530
Message-ID: <1246441575-20311-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:55449 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZGAJqR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 05:46:17 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n619kIYT012755
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 15:16:18 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n619kI9w2396188
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 15:16:18 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id n619kHi1012747
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 19:46:18 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

block_write_full_page consider a zero return from get_block as success.
noalloc_get_block_write returned zero even if we failed to find a mapping
blocks. Returning non zero ensures we fallback to the error handling path
of block_write_full_page which would properly redirty the page after
the below patch is applied.

http://article.gmane.org/gmane.linux.file-systems/33145

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

NOTE: I am not sure whether -EGAIN is the right error to be returned error.
This patch should enable us to push the pending ext4 patches in the patch
queue without depending on the full series from Jan. Will reply to this
email with patch ordering.

 fs/ext4/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 25638bc..6c814af 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2514,7 +2514,10 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
-	}
+	} else if (create && ret == 0)
+		/* write request on unmapped buffer head. */
+		ret = -EAGAIN;
+
 	return ret;
 }
 
-- 
1.6.3.2.363.gc5764

