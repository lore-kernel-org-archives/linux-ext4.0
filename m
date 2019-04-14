Return-Path: <SRS0=CYDl=SQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AECDC10F13
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A0B2084D
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfDNLiC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 14 Apr 2019 07:38:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbfDNLiB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Apr 2019 07:38:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3EBYJVZ033364
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:38:00 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ruw2x2uf4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:38:00 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 14 Apr 2019 12:37:59 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e17.ny.us.ibm.com (146.89.104.204) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Apr 2019 12:37:55 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3EBbsNc35455222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Apr 2019 11:37:54 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CA4828059;
        Sun, 14 Apr 2019 11:37:54 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 674D22805A;
        Sun, 14 Apr 2019 11:37:50 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.71.201])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Apr 2019 11:37:50 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH V2 09/14] ext4: Decrypt all boundary blocks when doing buffered write
Date:   Sun, 14 Apr 2019 17:07:59 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190414113804.26769-1-chandan@linux.ibm.com>
References: <20190414113804.26769-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19041411-0040-0000-0000-000004E0B1A1
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010925; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01188935; UDB=6.00622896; IPR=6.00969712;
 MB=3.00026436; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-14 11:37:57
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041411-0041-0000-0000-000008EBBAB9
Message-Id: <20190414113804.26769-10-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904140086
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

With subpage sized blocks, ext4_block_write_begin() can have up to two
blocks to decrypt. Hence this commit invokes fscrypt_decrypt_page() for
each of those blocks.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/ext4/inode.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1327e04334df..51744a3c3964 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1156,12 +1156,14 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 	unsigned to = from + len;
 	struct inode *inode = page->mapping->host;
 	unsigned block_start, block_end;
-	sector_t block;
+	sector_t block, page_blk_nr;
 	int err = 0;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	unsigned bbits;
-	struct buffer_head *bh, *head, *wait[2], **wait_bh = wait;
+	struct buffer_head *bh, *head, *wait[2];
+	int nr_wait = 0;
 	bool decrypt = false;
+	int i;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(from > PAGE_SIZE);
@@ -1213,25 +1215,36 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 		    !buffer_unwritten(bh) &&
 		    (block_start < from || block_end > to)) {
 			ll_rw_block(REQ_OP_READ, 0, 1, &bh);
-			*wait_bh++ = bh;
+			wait[nr_wait++] = bh;
 			decrypt = IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode);
 		}
 	}
 	/*
 	 * If we issued read requests, let them complete.
 	 */
-	while (wait_bh > wait) {
-		wait_on_buffer(*--wait_bh);
-		if (!buffer_uptodate(*wait_bh))
+	for (i = 0; i < nr_wait; i++) {
+		wait_on_buffer(wait[i]);
+		if (!buffer_uptodate(wait[i]))
 			err = -EIO;
 	}
 	if (unlikely(err)) {
 		page_zero_new_buffers(page, from, to);
 	} else if (decrypt) {
-		err = fscrypt_decrypt_page(page->mapping->host, page,
-				PAGE_SIZE, 0, page->index);
-		if (err)
-			clear_buffer_uptodate(*wait_bh);
+		page_blk_nr = (sector_t)page->index << (PAGE_SHIFT - bbits);
+
+		for (i = 0; i < nr_wait; i++) {
+			int err2;
+
+			block = page_blk_nr + (bh_offset(wait[i]) >> bbits);
+			err2 = fscrypt_decrypt_page(page->mapping->host, page,
+						wait[i]->b_size,
+						bh_offset(wait[i]),
+						block);
+			if (err2) {
+				clear_buffer_uptodate(wait[i]);
+				err = err2;
+			}
+		}
 	}
 
 	return err;
-- 
2.19.1

