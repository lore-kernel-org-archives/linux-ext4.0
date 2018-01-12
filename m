From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 4/8] ext4: decrypt all boundary blocks when doing buffered write
Date: Fri, 12 Jan 2018 19:41:25 +0530
Message-ID: <20180112141129.27507-5-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934000AbeALOKk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:40 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CE9wlT006278
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:40 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fevxax7eg-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:39 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:38 -0700
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With block size < page size, ext4_block_write_begin() may have two
blocks to decrypt. Hence this commit invokes fscrypt_decrypt_page() for
those blocks.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/inode.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6f6589e..d3baa15 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1158,12 +1158,13 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 	unsigned to = from + len;
 	struct inode *inode = page->mapping->host;
 	unsigned block_start, block_end;
-	sector_t block;
+	sector_t block, page_blk_nr;
 	int err = 0;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	unsigned bbits;
 	struct buffer_head *bh, *head, *wait[2], **wait_bh = wait;
 	bool decrypt = false;
+	int i;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(from > PAGE_SIZE);
@@ -1224,16 +1225,28 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 	/*
 	 * If we issued read requests, let them complete.
 	 */
-	while (wait_bh > wait) {
-		wait_on_buffer(*--wait_bh);
-		if (!buffer_uptodate(*wait_bh))
+	for (i = 0; (wait + i) < wait_bh; i++) {
+		wait_on_buffer(wait[i]);
+		if (!buffer_uptodate(wait[i]))
 			err = -EIO;
 	}
-	if (unlikely(err))
+	if (unlikely(err)) {
 		page_zero_new_buffers(page, from, to);
-	else if (decrypt)
-		err = fscrypt_decrypt_page(page->mapping->host, page,
-				PAGE_SIZE, 0, page->index);
+	} else if (decrypt) {
+		page_blk_nr = (sector_t)page->index << (PAGE_SHIFT - bbits);
+
+		while (wait_bh > wait) {
+			--wait_bh;
+			block = page_blk_nr + (bh_offset(*wait_bh) >> bbits);
+			err = fscrypt_decrypt_page(page->mapping->host, page,
+						(*wait_bh)->b_size,
+						bh_offset(*wait_bh),
+						block);
+			if (err)
+				break;
+		}
+	}
+
 	return err;
 }
 #endif
-- 
2.9.5
