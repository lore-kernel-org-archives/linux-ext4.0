Return-Path: <SRS0=CYDl=SQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E654C10F14
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4962B2084D
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfDNLiT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 14 Apr 2019 07:38:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727240AbfDNLiS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Apr 2019 07:38:18 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3EBYCJf078102
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:38:17 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ruw6hjvjb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:38:17 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 14 Apr 2019 12:38:16 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Apr 2019 12:38:13 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3EBcCrE31129748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Apr 2019 11:38:12 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ECA628064;
        Sun, 14 Apr 2019 11:38:12 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1018328059;
        Sun, 14 Apr 2019 11:38:09 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.71.201])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Apr 2019 11:38:08 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH V2 13/14] fscrypt_zeroout_range: Encrypt all zeroed out blocks of a page
Date:   Sun, 14 Apr 2019 17:08:03 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190414113804.26769-1-chandan@linux.ibm.com>
References: <20190414113804.26769-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19041411-0064-0000-0000-000003CAAC8D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010925; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01188935; UDB=6.00622896; IPR=6.00969712;
 MB=3.00026436; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-14 11:38:16
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041411-0065-0000-0000-00003D0F8AB2
Message-Id: <20190414113804.26769-14-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=988 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904140086
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

For subpage-sized blocks, this commit adds code to encrypt all zeroed
out blocks mapped by a page.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/crypto/bio.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 83de1e46f546..2c6ce4218fd4 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -106,29 +106,23 @@ EXPORT_SYMBOL(fscrypt_pullback_bio_page);
 int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 				sector_t pblk, unsigned int len)
 {
-	struct fscrypt_ctx *ctx;
 	struct page *ciphertext_page = NULL;
 	struct bio *bio;
+	u64 total_bytes, page_bytes;
 	int ret, err = 0;
 
-	BUG_ON(inode->i_sb->s_blocksize != PAGE_SIZE);
-
-	ctx = fscrypt_get_ctx(inode, GFP_NOFS);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
+	total_bytes = len << inode->i_blkbits;
 
-	ciphertext_page = fscrypt_alloc_bounce_page(ctx, GFP_NOWAIT);
-	if (IS_ERR(ciphertext_page)) {
-		err = PTR_ERR(ciphertext_page);
-		goto errout;
-	}
+	while (total_bytes) {
+		page_bytes = min_t(u64, total_bytes, PAGE_SIZE);
 
-	while (len--) {
-		err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk,
-					     ZERO_PAGE(0), ciphertext_page,
-					     PAGE_SIZE, 0, GFP_NOFS);
-		if (err)
+		ciphertext_page = fscrypt_encrypt_page(inode, ZERO_PAGE(0),
+						page_bytes, 0, lblk, GFP_NOFS);
+		if (IS_ERR(ciphertext_page)) {
+			err = PTR_ERR(ciphertext_page);
+			ciphertext_page = NULL;
 			goto errout;
+		}
 
 		bio = bio_alloc(GFP_NOWAIT, 1);
 		if (!bio) {
@@ -139,9 +133,8 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 		bio->bi_iter.bi_sector =
 			pblk << (inode->i_sb->s_blocksize_bits - 9);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
-		ret = bio_add_page(bio, ciphertext_page,
-					inode->i_sb->s_blocksize, 0);
-		if (ret != inode->i_sb->s_blocksize) {
+		ret = bio_add_page(bio, ciphertext_page, page_bytes, 0);
+		if (ret != page_bytes) {
 			/* should never happen! */
 			WARN_ON(1);
 			bio_put(bio);
@@ -154,12 +147,15 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 		bio_put(bio);
 		if (err)
 			goto errout;
-		lblk++;
-		pblk++;
+
+		lblk += page_bytes >> inode->i_blkbits;
+		pblk += page_bytes >> inode->i_blkbits;
+		total_bytes -= page_bytes;
 	}
 	err = 0;
 errout:
-	fscrypt_release_ctx(ctx);
+	if (!IS_ERR_OR_NULL(ciphertext_page))
+		fscrypt_restore_control_page(ciphertext_page);
 	return err;
 }
 EXPORT_SYMBOL(fscrypt_zeroout_range);
-- 
2.19.1

