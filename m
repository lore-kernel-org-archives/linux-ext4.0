From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] e2fsck: Fix access after free for dx_db structure
Date: Mon, 30 Oct 2017 16:32:14 +0300
Message-ID: <20171030133214.24279-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:46004 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdJ3NcT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Oct 2017 09:32:19 -0400
Received: by mail-lf0-f66.google.com with SMTP id n69so14985131lfn.2
        for <linux-ext4@vger.kernel.org>; Mon, 30 Oct 2017 06:32:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dx_db structure is freed after fixing of PR_2_HTREE_BAD_ROOT
problem. Next code block use this structure to unerstand if leaf
is beeng processed.

If dx_db is freed, then root block is being processed and if_leaf
need to be set to 0.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/pass2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 09c16179..7bda37a7 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1109,7 +1109,7 @@ inline_read_fail:
 			    ((fs->blocksize - (8 + dx_csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
 			dx_db->type = DX_DIRBLOCK_NODE;
-		is_leaf = (dx_db->type == DX_DIRBLOCK_LEAF);
+		is_leaf = dx_db ? (dx_db->type == DX_DIRBLOCK_LEAF) : 0;
 	}
 out_htree:
 
-- 
2.13.5 (Apple Git-94)
