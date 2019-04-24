Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBC0C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 04:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6EEC218DA
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 04:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfDXEgy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 00:36:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbfDXEgy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Apr 2019 00:36:54 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3O4Y14o058061
        for <linux-ext4@vger.kernel.org>; Wed, 24 Apr 2019 00:36:52 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s2eq1vyts-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 24 Apr 2019 00:36:52 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 24 Apr 2019 05:36:51 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Apr 2019 05:36:47 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3O4akkV28049564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 04:36:46 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AE11B205F;
        Wed, 24 Apr 2019 04:36:46 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D286B2064;
        Wed, 24 Apr 2019 04:36:43 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.81.252])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 24 Apr 2019 04:36:42 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [PATCH V1 01/14] ext4: Clear BH_Uptodate flag on decryption error
Date:   Wed, 24 Apr 2019 10:07:17 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190424043730.13683-1-chandan@linux.ibm.com>
References: <20190424043730.13683-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042404-0064-0000-0000-000003D026C9
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010984; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01193533; UDB=6.00625685; IPR=6.00974357;
 MB=3.00026570; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-24 04:36:50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042404-0065-0000-0000-00003D2EF9C2
Message-Id: <20190424043730.13683-2-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-24_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904240038
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On an error return from fscrypt_decrypt_page(), ext4_block_write_begin()
can return with the page's buffer_head marked with BH_Uptodate
flag. This commit clears the BH_Uptodate flag in such cases.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c2e7f5a6c84..05b258db8673 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1225,11 +1225,15 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (!buffer_uptodate(*wait_bh))
 			err = -EIO;
 	}
-	if (unlikely(err))
+	if (unlikely(err)) {
 		page_zero_new_buffers(page, from, to);
-	else if (decrypt)
+	} else if (decrypt) {
 		err = fscrypt_decrypt_page(page->mapping->host, page,
 				PAGE_SIZE, 0, page->index);
+		if (err)
+			clear_buffer_uptodate(*wait_bh);
+	}
+
 	return err;
 }
 #endif
-- 
2.19.1

