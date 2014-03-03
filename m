From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH 1/2] ext4: fix wrong assert in ext4_mb_normalize_request()
Date: Mon,  3 Mar 2014 15:00:27 +0100
Message-ID: <1393855228-13592-2-git-send-email-mlombard@redhat.com>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbaCCOAk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2014 09:00:40 -0500
In-Reply-To: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

the variable "size" is expressed as number of blocks and not as
number of clusters, this could trigger a kernel panic when using
ext4 with the size of a cluster different from the size of a block.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 04a5c75..08ddfda 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3135,7 +3135,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size > EXT4_CLUSTERS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 
-- 
Maurizio Lombardi

