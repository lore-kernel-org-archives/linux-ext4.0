Return-Path: <SRS0=CYDl=SQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE91EC10F14
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B890D2084D
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfDNLhj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 14 Apr 2019 07:37:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbfDNLhi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Apr 2019 07:37:38 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3EBYC9a091029
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:37:37 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ruuvjcrnu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:37:37 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 14 Apr 2019 12:37:36 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Apr 2019 12:37:34 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3EBbXSf36962350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Apr 2019 11:37:33 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04DFA28058;
        Sun, 14 Apr 2019 11:37:33 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6695228059;
        Sun, 14 Apr 2019 11:37:29 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.71.201])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Apr 2019 11:37:28 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH V2 04/14] fsverity: Add call back to determine readpage limit
Date:   Sun, 14 Apr 2019 17:07:54 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190414113804.26769-1-chandan@linux.ibm.com>
References: <20190414113804.26769-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19041411-0064-0000-0000-000003CAAC84
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010925; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01188935; UDB=6.00622896; IPR=6.00969712;
 MB=3.00026436; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-14 11:37:36
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041411-0065-0000-0000-00003D0F8A76
Message-Id: <20190414113804.26769-5-chandan@linux.ibm.com>
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

Ext4 and F2FS store verity metadata beyond i_size. This commit adds a
call back pointer to "struct fsverity_operations" which helps in
determining the the real file size limit upto which data can be read
from the file.

This call back will be required in order to get do_mpage_readpage()
to read files having verity metadata appended beyond i_size.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/ext4/super.c          | 18 ++++++++++++++++++
 include/linux/fsverity.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 63d73b360f1d..cadf50f9503f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1428,6 +1428,23 @@ static struct page *ext4_read_verity_metadata_page(struct inode *inode,
 	return read_mapping_page(inode->i_mapping, index, NULL);
 }
 
+static loff_t ext4_readpage_limit(struct inode *inode)
+{
+#ifdef CONFIG_FS_VERITY
+	if (IS_VERITY(inode)) {
+		if (inode->i_verity_info)
+			/* limit to end of metadata region */
+			return fsverity_full_i_size(inode);
+		/*
+		 * fsverity_info is currently being set up and no user reads are
+		 * allowed yet.  It's easiest to just not enforce a limit yet.
+		 */
+		return inode->i_sb->s_maxbytes;
+	}
+#endif
+	return i_size_read(inode);
+}
+
 static bool ext4_verity_required(struct inode *inode, pgoff_t index)
 {
 	return index < (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -1438,6 +1455,7 @@ static const struct fsverity_operations ext4_verityops = {
 	.get_metadata_end	= ext4_get_verity_metadata_end,
 	.read_metadata_page	= ext4_read_verity_metadata_page,
 	.verity_required	= ext4_verity_required,
+	.readpage_limit		= ext4_readpage_limit,
 };
 #endif /* CONFIG_FS_VERITY */
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index b83712d6c79a..fc8113acbbfe 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -19,6 +19,7 @@ struct fsverity_operations {
 	int (*get_metadata_end)(struct inode *inode, loff_t *metadata_end_ret);
 	struct page *(*read_metadata_page)(struct inode *inode, pgoff_t index);
 	bool (*verity_required)(struct inode *inode, pgoff_t index);
+	loff_t (*readpage_limit)(struct inode *inode);
 };
 
 #ifdef CONFIG_FS_VERITY
-- 
2.19.1

