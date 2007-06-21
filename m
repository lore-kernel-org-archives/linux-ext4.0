From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 4/10] Get free blocks distribution of the target block group
Date: Thu, 21 Jun 2007 10:53:39 +0900
Message-ID: <20070621105339t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63574 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbXFUBxk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 21:53:40 -0400
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l5L1rcAj017407
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:53:39 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l5L1rcq24939 for linux-ext4@vger.kernel.org; Thu, 21 Jun 2007 10:53:38 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l5L1rcB15882 for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:53:38 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070621.105337.31202060 for <linux-ext4@vger.kernel.org>
	; Thu, 21 Jun 2007 10:53:37 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Get free blocks distribution of the target block group to know
  how many free blocks it has.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/extents.c Online-Defrag_linux-2.6.19-rc6-git-EXTENTS_INFO/fs/ext4/extents.c
--- Online-Defrag_linux-2.6.19-rc6-git-FREE_BLOCKS_INFO/fs/ext4/extents.c	2007-06-20 09:05:37.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-EXTENTS_INFO/fs/ext4/extents.c	2007-06-20 08:50:57.000000000 +0900
@@ -2478,6 +2478,99 @@ ext4_ext_next_extent(struct inode *inode
 	return 1;
 }
 
+/**
+ * ext4_ext_fblocks_distribution - Search free block distribution
+ * @filp      target file
+ * @ex_info   ext4_extents_info
+ *
+ * This function returns 0 if succeeded, otherwise
+ * returns error value
+ */
+static int ext4_ext_fblocks_distribution(struct inode *inode,
+			struct ext4_extents_info *ext_info)
+{
+	handle_t *handle;
+	struct buffer_head *bitmap_bh = NULL;
+	struct super_block *sb = inode->i_sb;
+	struct ext4_super_block *es;
+	unsigned long group_no;
+	int max_entries = ext_info->max_entries;
+	ext4_grpblk_t blocks_per_group;
+	ext4_grpblk_t start;
+	ext4_grpblk_t end;
+	int num = 0;
+	int len = 0;
+	int i = 0;
+	int err = 0;
+	int block_set = 0;
+	int start_block = 0;
+
+	if (!sb) {
+		printk("ext4_ext_fblock_distribution: nonexitent device\n");
+		return -ENOSPC;
+	}
+	es = EXT4_SB(sb)->s_es;
+
+	group_no = (inode->i_ino -1) / EXT4_INODES_PER_GROUP(sb);
+	start = ext_info->offset;
+	blocks_per_group = EXT4_BLOCKS_PER_GROUP(sb);
+	end = blocks_per_group -1;
+
+	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		return err;
+	}
+
+	bitmap_bh = read_block_bitmap(sb, group_no);
+	if (!bitmap_bh) {
+		err = -EIO;
+		goto out;
+	}
+
+	BUFFER_TRACE(bitmap_bh, "get undo access for new block");
+	err = ext4_journal_get_undo_access(handle, bitmap_bh);
+	if (err)
+		goto out;
+
+	for (i = start; i <= end ; i++) {
+		if (bitmap_search_next_usable_block(i, bitmap_bh, i+1) >= 0) {
+			len++;
+			/* if the free block is the first one in a region */
+			if (!block_set) {
+				start_block =
+					i + group_no * blocks_per_group;
+				block_set = 1;
+			}
+		} else if (len) {
+			ext_info->ext[num].start = start_block;
+			ext_info->ext[num].len = len;
+			num++;
+			len = 0;
+			block_set = 0;
+			if (num == max_entries) {
+				ext_info->offset = i + 1;
+				break;
+			}
+		}
+		if ((i == end) && len) {
+			ext_info->ext[num].start = start_block;
+			ext_info->ext[num].len = len;
+			num++;
+		}
+	}
+
+	ext_info->entries = num;
+out:
+	ext4_journal_release_buffer(handle, bitmap_bh);
+	brelse(bitmap_bh);
+
+	if (handle)
+		ext4_journal_stop(handle);
+
+	return err;
+}
+
 int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			unsigned long arg)
 {
@@ -2545,6 +2638,21 @@ int ext4_ext_ioctl(struct inode *inode, 
 		if (copy_to_user((struct ext4_group_data_info *)arg,
 			&grp_data, sizeof(grp_data)))
 			return -EFAULT;
+	} else if (cmd == EXT4_IOC_FREE_BLOCKS_INFO) {
+		struct ext4_extents_info ext_info;
+
+		if (copy_from_user(&ext_info,
+			(struct ext4_extents_info __user *)arg,
+			sizeof(ext_info)))
+			return -EFAULT;
+
+		BUG_ON(ext_info.ino != inode->i_ino);
+
+		err = ext4_ext_fblocks_distribution(inode, &ext_info);
+
+		if (!err)
+			err = copy_to_user((struct ext4_extents_info*)arg,
+				&ext_info, sizeof(ext_info));
 	} else if (cmd == EXT4_IOC_DEFRAG) {
 		struct ext4_ext_defrag_data defrag;
 
