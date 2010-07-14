From: shenghui <crosslonelyover@gmail.com>
Subject: [PATCH]trivial: clear the comment on parameters for ext2_xattr_set
Date: Wed, 14 Jul 2010 08:51:12 +0800
Message-ID: <4C3D0A00.4000900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-janitors@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, error27@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52859 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0GNAvR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jul 2010 20:51:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry. I changed to another mail client.
Please recheck the patch.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..194269e 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -355,7 +355,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 /*
  * ext2_xattr_set()
  *
- * Create, replace or remove an extended attribute for this inode. Buffer
+ * Create, replace or remove an extended attribute for this inode. Value
  * is NULL to remove an existing extended attribute, and non-NULL to
  * either replace an existing extended attribute, or create a new extended
  * attribute. The flags XATTR_REPLACE and XATTR_CREATE
-- 
1.6.3.3

