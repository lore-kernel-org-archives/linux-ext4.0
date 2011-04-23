From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
Date: Sat, 23 Apr 2011 01:44:18 -0700
Message-ID: <1303548259-28311-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, cmm@us.ibm.com,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54962 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1DWIrN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 04:47:13 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so602376pvg.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 01:47:13 -0700 (PDT)
In-Reply-To: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_zeroout_mem() zero out blocks in mem.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9e7c7b3..30663b6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2555,6 +2555,76 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 }
 
 /*
+ * ext4_ext_zeroout_mem() zero specified pages in page cache.
+ * this function is used by ext4_ext_convert_to_initialized() to
+ * zeroout small extents.
+ *
+ * @inode: the file inode
+ * @ex: the extent to be zeroout
+ *
+ * return 0 on success
+ */
+static int ext4_ext_zeroout_mem(struct inode *inode,
+				  struct ext4_extent *ex)
+{
+	ext4_fsblk_t pblk;
+	ext4_lblk_t lblk;
+	ext4_lblk_t end;
+	struct page *page;
+	struct buffer_head *bh;
+	struct block_device *bdev;
+	pgoff_t index;
+	unsigned blocksize, blks_per_page_bits;
+
+	bdev = inode->i_sb->s_bdev;
+
+	blocksize = 1 << inode->i_blkbits;
+	blks_per_page_bits = PAGE_CACHE_SHIFT - inode->i_blkbits;
+
+	pblk = ext4_ext_pblock(ex);
+	lblk = le32_to_cpu(ex->ee_block);
+	end = lblk + ext4_ext_get_actual_len(ex);
+
+	while (lblk < end) {
+		struct ext4_extent ext;
+		char *kaddr;
+
+		/* grab page */
+		index = lblk >> blks_per_page_bits;
+		page = grab_cache_page_write_begin(inode->i_mapping,
+						   index, AOP_FLAG_NOFS);
+		if (!page) {
+			ext.ee_block = cpu_to_le32(lblk);
+			ext.ee_len = cpu_to_le16(end - lblk);
+			ext4_ext_store_pblock(&ext, pblk);
+			return ext4_ext_zeroout(inode, &ext);
+		}
+
+		/* map buffers, mark dirty */
+		if (!page_has_buffers(page))
+			create_empty_buffers(page, blocksize, 0);
+
+		kaddr = kmap_atomic(page, KM_USER0);
+		bh = page_buffers(page);
+		do {
+			unmap_underlying_metadata(bdev, pblk);
+			memset(kaddr, 0, blocksize);
+			map_bh(bh, inode->i_sb, pblk++);
+			set_buffer_uptodate(bh);
+			mark_buffer_dirty(bh);
+			bh = bh->b_this_page;
+			lblk++;
+		} while (bh != page_buffers(page) && lblk < end);
+		kunmap_atomic(kaddr, KM_USER0);
+
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
+	return 0;
+}
+
+/*
  * used by extent splitting.
  */
 #define EXT4_EXT_MAY_ZEROOUT	0x1  /* safe to zeroout if split fails \
-- 
1.7.4.4

