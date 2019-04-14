Return-Path: <SRS0=CYDl=SQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E2AC10F13
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8C7C218D3
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfDNLiX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 14 Apr 2019 07:38:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727235AbfDNLiX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Apr 2019 07:38:23 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3EBYLP4091635
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:38:22 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ruuvjcs3n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:38:22 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 14 Apr 2019 12:38:21 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e15.ny.us.ibm.com (146.89.104.202) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Apr 2019 12:38:17 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3EBcHKv30736474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Apr 2019 11:38:17 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E73F32805A;
        Sun, 14 Apr 2019 11:38:16 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E9DB28058;
        Sun, 14 Apr 2019 11:38:13 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.71.201])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Apr 2019 11:38:12 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH V2 14/14] ext4: Enable encryption for subpage-sized blocks
Date:   Sun, 14 Apr 2019 17:08:04 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190414113804.26769-1-chandan@linux.ibm.com>
References: <20190414113804.26769-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19041411-0068-0000-0000-000003B4E121
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010925; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01188935; UDB=6.00622896; IPR=6.00969712;
 MB=3.00026436; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-14 11:38:20
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041411-0069-0000-0000-00004827D543
Message-Id: <20190414113804.26769-15-chandan@linux.ibm.com>
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

Now that we have the code to support encryption for subpage-sized
blocks, this commit removes the conditional check in filesystem mount
code.

The commit also changes the support statement in
Documentation/filesystems/fscrypt.rst to reflect the fact that
encryption of filesystems with blocksize less than page size now works.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 Documentation/filesystems/fscrypt.rst | 4 ++--
 fs/ext4/super.c                       | 7 -------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 08c23b60e016..ff2fea121da9 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -213,8 +213,8 @@ Contents encryption
 -------------------
 
 For file contents, each filesystem block is encrypted independently.
-Currently, only the case where the filesystem block size is equal to
-the system's page size (usually 4096 bytes) is supported.
+Starting from Linux kernel 5.3, encryption of filesystems with block
+size less than system's page size is supported.
 
 Each block's IV is set to the logical block number within the file as
 a little endian number, except that:
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cadf50f9503f..549e5bec1aba 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4433,13 +4433,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
-	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
-	    (blocksize != PAGE_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Unsupported blocksize for fs encryption");
-		goto failed_mount_wq;
-	}
-
 	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !sb_rdonly(sb) &&
 	    !ext4_has_feature_encrypt(sb)) {
 		ext4_set_feature_encrypt(sb);
-- 
2.19.1

