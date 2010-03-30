From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix quota accounting in case of fallocate
Date: Tue, 30 Mar 2010 18:24:35 +0400
Message-ID: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, aneesh.kumar@linux.vnet.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61489 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C3OYv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 10:24:51 -0400
Received: by bwz1 with SMTP id 1so4414034bwz.21
        for <linux-ext4@vger.kernel.org>; Tue, 30 Mar 2010 07:24:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

allocated_meta_data is already included in 'used' variable.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bec222c..bf989fb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1110,7 +1110,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		 */
 		if (allocated_meta_blocks)
 			dquot_claim_block(inode, allocated_meta_blocks);
-		dquot_release_reservation_block(inode, mdb_free + used);
+		dquot_release_reservation_block(inode, mdb_free + used -
+			allocated_meta_blocks);
 	}
 
 	/*
-- 
1.6.6.1

