From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2] e2fsck: Fix access after free for dx_db structure
Date: Sat,  4 Nov 2017 20:22:18 +0300
Message-ID: <20171104172218.79017-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:44751 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932148AbdKDRWZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Nov 2017 13:22:25 -0400
Received: by mail-lf0-f48.google.com with SMTP id 75so6379891lfx.1
        for <linux-ext4@vger.kernel.org>; Sat, 04 Nov 2017 10:22:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dx_db structure is freed after fixing of PR_2_HTREE_BAD_ROOT
problem. Next code block use this structure to unerstand if leaf
is beeng processed.

If dx_db is freed, then root block is being processed and if_leaf
need to be set to 0.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/pass2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 09c16179..1b0504c8 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1095,7 +1095,7 @@ inline_read_fail:
 			    fix_problem(ctx, PR_2_HTREE_BAD_ROOT, &cd->pctx)) {
 				clear_htree(ctx, ino);
 				dx_dir->numblocks = 0;
-				dx_db = 0;
+				dx_db = NULL;
 			}
 			dx_dir->hashversion = root->hash_version;
 			if ((dx_dir->hashversion <= EXT2_HASH_TEA) &&
@@ -1107,9 +1107,10 @@ inline_read_fail:
 			   (ext2fs_dirent_name_len(dirent) == 0) &&
 			   (ext2fs_le16_to_cpu(limit->limit) ==
 			    ((fs->blocksize - (8 + dx_csum_size)) /
-			     sizeof(struct ext2_dx_entry))))
+			     sizeof(struct ext2_dx_entry)))) {
 			dx_db->type = DX_DIRBLOCK_NODE;
-		is_leaf = (dx_db->type == DX_DIRBLOCK_LEAF);
+		}
+		is_leaf = dx_db ? (dx_db->type == DX_DIRBLOCK_LEAF) : 0;
 	}
 out_htree:
 
-- 
2.13.5 (Apple Git-94)
