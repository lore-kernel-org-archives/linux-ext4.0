Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDB7C43219
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B472075D
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfD1Ecn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 00:32:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725924AbfD1Ecm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 28 Apr 2019 00:32:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3S4T95w090229
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:32:41 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s54649fnf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:32:41 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 28 Apr 2019 05:32:41 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 28 Apr 2019 05:32:35 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3S4VK8H32244078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Apr 2019 04:31:20 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B7A112062;
        Sun, 28 Apr 2019 04:31:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36054112061;
        Sun, 28 Apr 2019 04:31:16 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.75.21])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 28 Apr 2019 04:31:15 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, hch@infradead.org
Subject: [PATCH V2 11/13] ext4: Compute logical block and the page range to be encrypted
Date:   Sun, 28 Apr 2019 10:01:19 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190428043121.30925-1-chandan@linux.ibm.com>
References: <20190428043121.30925-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042804-2213-0000-0000-0000038361B5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011008; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01195431; UDB=6.00626836; IPR=6.00976273;
 MB=3.00026628; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-28 04:32:39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042804-2214-0000-0000-00005E3539B8
Message-Id: <20190428043121.30925-12-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-28_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904280030
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

For subpage-sized blocks, the initial logical block number mapped by a
page can be different from page->index. Hence this commit adds code to
compute the first logical block mapped by the page and also the page
range to be encrypted.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/ext4/page-io.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 3e9298e6a705..75485ee9e800 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -418,6 +418,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 {
 	struct page *data_page = NULL;
 	struct inode *inode = page->mapping->host;
+	u64 page_blk;
 	unsigned block_start;
 	struct buffer_head *bh, *head;
 	int ret = 0;
@@ -478,10 +479,14 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 
 	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode) && nr_to_submit) {
 		gfp_t gfp_flags = GFP_NOFS;
+		unsigned int page_bytes;
+
+		page_bytes = round_up(len, i_blocksize(inode));
+		page_blk = page->index << (PAGE_SHIFT - inode->i_blkbits);
 
 	retry_encrypt:
-		data_page = fscrypt_encrypt_page(inode, page, PAGE_SIZE, 0,
-						page->index, gfp_flags);
+		data_page = fscrypt_encrypt_page(inode, page, page_bytes, 0,
+						page_blk, gfp_flags);
 		if (IS_ERR(data_page)) {
 			ret = PTR_ERR(data_page);
 			if (ret == -ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
-- 
2.19.1

