From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] e2fsck: properly account cluster size
Date: Mon, 12 Feb 2018 15:00:40 +0300
Message-ID: <20180212120040.25441-1-artem.blagodarenko@gmail.com>
Cc: Andrew Perepechko <anserper@ya.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34902 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbeBLMAr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2018 07:00:47 -0500
Received: by mail-it0-f65.google.com with SMTP id e1so6199988ita.0
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:00:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andrew Perepechko <anserper@ya.ru>

The patch fixes the quota_data_add() call so that
not num_blocks * block_size is passed, but instead
num_blocks * blocks_per_cluster * block_size.

Otherwise, any trivial test with -O bigalloc,quota
filesystem leads to check errors like

[QUOTA WARNING] Usage inconsistent for ID 0:actual (8192, 2) != expected
(131072, 2)
Update quota info for quota type 0<y>? cancelled!
[QUOTA WARNING] Usage inconsistent for ID 0:actual (8192, 2) != expected
(131072, 2)
Update quota info for quota type 1<y>? cancelled!

Cray-bug-id: LUS-5373

Signed-off-by: Andrew Perepechko <anserper@ya.ru>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/pass1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5015d938..471162ea 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3387,6 +3387,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
+	pb.num_blocks *= EXT2FS_CLUSTER_RATIO(fs);
+
 	if (ino != quota_type2inum(PRJQUOTA, fs->super) &&
 	    (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super)) &&
 	    !(inode->i_flags & EXT4_EA_INODE_FL)) {
-- 
2.14.3 (Apple Git-98)
