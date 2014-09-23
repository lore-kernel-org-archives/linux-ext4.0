From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: get rid of code duplication
Date: Tue, 23 Sep 2014 11:02:31 +0400
Message-ID: <1411455752-2332-2-git-send-email-dmonakhov@openvz.org>
References: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:1182 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbaIWHCl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 03:02:41 -0400
In-Reply-To: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/mballoc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 65cca28..eab825f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3155,9 +3155,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 			 "start %lu, size %lu, fe_logical %lu",
 			 (unsigned long) start, (unsigned long) size,
 			 (unsigned long) ac->ac_o_ex.fe_logical);
+		BUG();
 	}
-	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
-			start > ac->ac_o_ex.fe_logical);
 	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
-- 
1.7.1

