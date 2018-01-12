From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/8] ext4: decrypt all contiguous blocks in a page
Date: Fri, 12 Jan 2018 19:41:24 +0530
Message-ID: <20180112141129.27507-4-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933728AbeALOKi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:38 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CEA78b024355
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:37 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fevhtf8em-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:36 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:35 -0700
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With blocksize < pagesize, a page can contain more than one block. Hence
this commit changes completion_pages() to invoke fscrypt_decrypt_page()
in order to decrypt all the contiguous blocks mapped by the page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/crypto/bio.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 0d5e6a5..eb6e06a 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -40,8 +40,23 @@ static void completion_pages(struct work_struct *work)
 
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
-		int ret = fscrypt_decrypt_page(page->mapping->host, page,
-				PAGE_SIZE, 0, page->index);
+		struct inode *inode = page->mapping->host;
+		const unsigned long blocksize = inode->i_sb->s_blocksize;
+		const unsigned blkbits = inode->i_blkbits;
+		int page_blk = page->index << (PAGE_SHIFT - blkbits);
+		int blk = page_blk + (bv->bv_offset >> blkbits);
+		int nr_blks = bv->bv_len >> blkbits;
+		int ret = 0;
+		int j;
+
+		for (j = 0; j < nr_blks; j++, blk++) {
+			ret = fscrypt_decrypt_page(page->mapping->host,
+						page, blocksize,
+						bv->bv_offset + (j << blkbits),
+						blk);
+			if (ret)
+				break;
+		}
 
 		if (ret) {
 			WARN_ON_ONCE(1);
-- 
2.9.5
