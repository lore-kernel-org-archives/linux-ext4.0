From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] don't use ext4_error in ext4_check_descriptors
Date: Fri, 11 Apr 2008 16:11:13 -0400
Message-ID: <20080411201113.GC2757@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021AbYDKUTM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 16:19:12 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Because ext4_check_descriptors is called at mount time you can't use ext4_error
as it calls ext4_commit_sb, which since the sb isn't all the way initialized
causes bad things to happen (ie a panic).  This patch changes the ext4_error's
to printk's to keep this problem from happening.  Thanks much,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -1543,36 +1543,33 @@ static int ext4_check_descriptors(struct
 		block_bitmap = ext4_block_bitmap(sb, gdp);
 		if (block_bitmap < first_block || block_bitmap > last_block)
 		{
-			ext4_error (sb, "ext4_check_descriptors",
-				    "Block bitmap for group %lu"
-				    " not in group (block %llu)!",
-				    i, block_bitmap);
+			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			       "Block bitmap for group %lu not in group "
+			       "(block %llu)!", i, block_bitmap);
 			return 0;
 		}
 		inode_bitmap = ext4_inode_bitmap(sb, gdp);
 		if (inode_bitmap < first_block || inode_bitmap > last_block)
 		{
-			ext4_error (sb, "ext4_check_descriptors",
-				    "Inode bitmap for group %lu"
-				    " not in group (block %llu)!",
-				    i, inode_bitmap);
+			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			       "Inode bitmap for group %lu not in group "
+			       "(block %llu)!", i, inode_bitmap);
 			return 0;
 		}
 		inode_table = ext4_inode_table(sb, gdp);
 		if (inode_table < first_block ||
 		    inode_table + sbi->s_itb_per_group - 1 > last_block)
 		{
-			ext4_error (sb, "ext4_check_descriptors",
-				    "Inode table for group %lu"
-				    " not in group (block %llu)!",
-				    i, inode_table);
+			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			       "Inode table for group %lu not in group "
+			       "(block %llu)!", i, inode_table);
 			return 0;
 		}
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
-			ext4_error(sb, __func__,
-				   "Checksum for group %lu failed (%u!=%u)\n",
-				    i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
-				    gdp)), le16_to_cpu(gdp->bg_checksum));
+			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			       "Checksum for group %lu failed (%u!=%u)\n",
+			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
+			       gdp)), le16_to_cpu(gdp->bg_checksum));
 			return 0;
 		}
 		if (!flexbg_flag)
