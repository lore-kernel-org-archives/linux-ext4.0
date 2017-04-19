From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: make ext4_shutdown() static
Date: Tue, 18 Apr 2017 22:48:25 -0700
Message-ID: <20170419054825.9880-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34761 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759674AbdDSFur (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Apr 2017 01:50:47 -0400
Received: by mail-pf0-f196.google.com with SMTP id g23so2182253pfj.1
        for <linux-ext4@vger.kernel.org>; Tue, 18 Apr 2017 22:50:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Make the ext4_shutdown() function static, as suggested by running sparse
('make C=2 fs/ext4/').  This was the only such warning in fs/ext4/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a4273ddb9922..06471430ea47 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -443,7 +443,7 @@ static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
 	return iflags;
 }
 
-int ext4_shutdown(struct super_block *sb, unsigned long arg)
+static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	__u32 flags;
-- 
2.12.2
