Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbeKGXRx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 18:17:53 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext2: avoid unnecessary operation in ext2_error()
Date: Wed,  7 Nov 2018 21:47:04 +0800
Message-Id: <20181107134704.15821-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If filesystem has already mounted as read-only, then we don't have
to do it again.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index cb91baa4275d..5e2861b947a6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -73,7 +73,7 @@ void ext2_error(struct super_block *sb, const char *function,
 
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT2-fs: panic from previous error\n");
-	if (test_opt(sb, ERRORS_RO)) {
+	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO)) {
 		ext2_msg(sb, KERN_CRIT,
 			     "error: remounting filesystem read-only");
 		sb->s_flags |= SB_RDONLY;
-- 
2.17.2
