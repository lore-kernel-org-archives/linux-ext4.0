From: Vignesh Babu BM <vignesh.babu@wipro.com>
Subject: [KJ][PATCH] is_power_of_2 in ext2
Date: Tue, 20 Feb 2007 13:18:53 +0530
Message-ID: <1171957733.6127.62.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:32787 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbXBTHuj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Feb 2007 02:50:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/fs/ext2/super.c b/fs/ext2/super.c 
index 6347c2d..9f71032 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -29,6 +29,7 @@
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -802,7 +803,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    !is_power_of_2(sbi->s_inode_size) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk ("EXT2-fs: unsupported inode size: %d\n",
 				sbi->s_inode_size);

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"
