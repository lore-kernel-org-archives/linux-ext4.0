From: Mingming <cmm@us.ibm.com>
Subject: [PATCH] Ext4: avoid multiple quota reservation when retry block
 reservation for delalloc
Date: Mon, 21 Sep 2009 09:52:30 -0700
Message-ID: <1253551950.9099.10.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:55519 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZIUQwt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Sep 2009 12:52:49 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8LGmomG027732
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 10:48:50 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8LGqX8p195732
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 10:52:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8LGqV5S025277
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 10:52:32 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4: release reserved quota before block reservation for delalloc retry

ext4_da_reserve_space() can reserve quota blocks multiple times if
ext4_claim_free_blocks() fail and we retry the allocation. We should
release the quota reservation before restarting.

Bug found be Jan Kara.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -1785,11 +1785,11 @@ repeat:
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
-		vfs_dq_release_reservation_block(inode, total);
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;


