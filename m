From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 2/2] ext4: undo ei->i_da_metadata_calc_len increment if
 we fail to claim space
Date: Mon, 02 Apr 2012 11:14:20 -0400
Message-ID: <4F79C24C.7070907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab2DBPOj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 11:14:39 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q32FEcdT027083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 11:14:38 -0400
Received: from bfoster.bfoster (dhcp-187-76.bos.redhat.com [10.16.187.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q32FEc0k030190
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 11:14:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Brian Foster <bfoster@redhat.com>

If we call ext4_calc_metadata_amount() and then fail to claim
the space, a subsequent successful request to a block covered
by the same ext2 indirect block will set md_needed to 0, fail
to update the associated counters and result in a delayed md
block allocation without a reservation. Decrement
i_da_metadata_calc_len on failure to ensure the next
reservation sets md_needed correctly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/ext4/inode.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b58845c..7d2a3c0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1138,13 +1138,14 @@ repeat:
 	 * We do still charge estimated metadata to the sb though;
 	 * we cannot afford to run out of free blocks.
 	 */
-	if (ext4_claim_free_clusters(sbi, md_needed + 1, 0)) {
+	ret = ext4_claim_free_clusters(sbi, md_needed + 1, 0);
+	if (ret) {
 		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
-		return -ENOSPC;
+		goto error;
 	}
 	spin_lock(&ei->i_block_reservation_lock);
 	ei->i_reserved_data_blocks++;
@@ -1152,6 +1153,19 @@ repeat:
 	spin_unlock(&ei->i_block_reservation_lock);
 
 	return 0;       /* success */
+
+error:
+	/*
+	 * We've failed to reserve the space. Undo the effect
+	 * of ext4_calc_metadata_amount() to ensure the next
+	 * attempt correctly accounts for metadata.
+	 */
+	spin_lock(&ei->i_block_reservation_lock);
+	if (ei->i_da_metadata_calc_len)
+		ei->i_da_metadata_calc_len--;
+	spin_unlock(&ei->i_block_reservation_lock);
+
+	return ret;
 }
 
 static void ext4_da_release_space(struct inode *inode, int to_free)
-- 
1.7.7.6

