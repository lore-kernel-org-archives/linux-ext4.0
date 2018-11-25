Return-Path: <SRS0=jmd0=OE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:54106 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbeKYLsA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Nov 2018 06:48:00 -0500
From: Pan Bian <bianpan2016@163.com>
To: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] ext2: fix potential use after free
Date: Sun, 25 Nov 2018 08:58:02 +0800
Message-Id: <1543107482-97334-1-git-send-email-bianpan2016@163.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function ext2_xattr_set calls brelse(bh) to drop the reference count
of bh. After that, bh may be freed. However, following brelse(bh),
it reads bh->b_data via macro HDR(bh). This may result in a
use-after-free bug. This patch moves brelse(bh) after reading field.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/ext2/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 62d9a659a..dd8f10d 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -612,9 +612,9 @@ bad_block:		ext2_error(sb, "ext2_xattr_set",
 	}
 
 cleanup:
-	brelse(bh);
 	if (!(bh && header == HDR(bh)))
 		kfree(header);
+	brelse(bh);
 	up_write(&EXT2_I(inode)->xattr_sem);
 
 	return error;
-- 
2.7.4
