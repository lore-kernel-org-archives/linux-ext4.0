From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: get rid of ext4_sb_has_crypto()
Date: Mon, 21 Nov 2016 16:22:12 -0800
Message-ID: <1479774132-11457-1-git-send-email-ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33533 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754042AbcKVAXF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 19:23:05 -0500
Received: by mail-pg0-f49.google.com with SMTP id 3so899055pgd.0
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 16:23:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_sb_has_crypto() just called through to ext4_has_feature_encrypt(),
and all callers except one were already using the latter.  So remove it
and switch its one caller to ext4_has_feature_encrypt().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ext4.h  | 5 -----
 fs/ext4/ioctl.c | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a8a750f..cc83482 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2277,11 +2277,6 @@ extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
 					      struct ext4_group_desc *gdp);
 ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
 
-static inline int ext4_sb_has_crypto(struct super_block *sb)
-{
-	return ext4_has_feature_encrypt(sb);
-}
