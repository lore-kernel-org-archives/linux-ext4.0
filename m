From: Vignesh Babu BM <vignesh.babu@wipro.com>
Subject: [KJ][PATCH] is_power_of_2 in ext3
Date: Tue, 20 Feb 2007 13:19:16 +0530
Message-ID: <1171957756.6127.63.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:32797 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbXBTHvC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Feb 2007 02:51:02 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index b348867..6a86e98 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/log2.h>
 
 #include <asm/uaccess.h>
 
@@ -1565,7 +1566,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT3_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    !is_power_of_2(sbi->s_inode_size) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk (KERN_ERR
 				"EXT3-fs: unsupported inode size: %d\n",

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"
