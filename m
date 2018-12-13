Return-Path: <SRS0=vjzE=OW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:56045 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMVch (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2018 16:32:37 -0500
Received: by mail-it1-f196.google.com with SMTP id o19so5929924itg.5
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2018 13:32:37 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca
Subject: [PATCH 1/2] e2fsck: allow to check >2GB sized directory
Date: Fri, 14 Dec 2018 00:31:55 +0300
Message-Id: <20181213213156.44773-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After large_dir feature has been added, e2fsprogs is
ready for directories > 2GB, so we can remove e2fsck
directory size check.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/pass1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5c0b92d5..3318d881 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3647,9 +3647,10 @@ static int process_block(ext2_filsys fs,
 		}
 	}
 
-	if (p->is_dir && blockcnt > (1 << (21 - fs->super->s_log_block_size)))
+	if (p->is_dir && !ext2fs_has_feature_largedir(fs->super) &&
+	    blockcnt > (1 << (21 - fs->super->s_log_block_size)))
 		problem = PR_1_TOOBIG_DIR;
-	if (p->is_reg && p->num_blocks+1 >= p->max_blocks)
+	if ((p->is_reg || p->is_dir) && p->num_blocks + 1 >= p->max_blocks)
 		problem = PR_1_TOOBIG_REG;
 	if (!p->is_dir && !p->is_reg && blockcnt > 0)
 		problem = PR_1_TOOBIG_SYMLINK;
-- 
2.14.3
