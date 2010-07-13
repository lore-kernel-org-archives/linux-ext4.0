From: Wang Sheng-Hui <crosslonelyover@gmail.com>
Subject: [PATCH]trivial: clear the comment on parameters for ext2_xattr_set
Date: Tue, 13 Jul 2010 23:03:31 +0800
Message-ID: <4C3C8043.3030700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: kernel-janitors <kernel-janitors@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0GMPDU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jul 2010 11:03:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Hi,

The comment for ext2_xattr_get is confusing for it has
no parameter named "buffer". I checked the code and think the
description is suitable for the parameter "value".
Following patch is against 2.6.35-rc5. Please check it.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
fs/ext2/xattr.c | 2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 5ecbbd8..f56b599 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -355,7 +355,7 @@ static void ext2_xattr_update_super_block(struct
super_block *sb)
/*
* ext2_xattr_set()
*
- * Create, replace or remove an extended attribute for this inode. Buffer
+ * Create, replace or remove an extended attribute for this inode. Value
* is NULL to remove an existing extended attribute, and non-NULL to
* either replace an existing extended attribute, or create a new extended
* attribute. The flags XATTR_REPLACE and XATTR_CREATE
-- 
1.7.1.1


-- 
Thanks and Regards,
shenghui

