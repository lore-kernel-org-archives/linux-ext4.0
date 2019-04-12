Return-Path: <SRS0=VzNY=SO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8EDC10F0E
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 17:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9492C218A3
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 17:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfDLRKY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Apr 2019 13:10:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726890AbfDLRKY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Apr 2019 13:10:24 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3CH8e9Q017367
        for <linux-ext4@vger.kernel.org>; Fri, 12 Apr 2019 13:10:23 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rtwasc8as-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Apr 2019 13:10:23 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 12 Apr 2019 18:10:22 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Apr 2019 18:10:19 +0100
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3CHAI4a21561420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 17:10:18 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 223746A058;
        Fri, 12 Apr 2019 17:10:18 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 679F26A054;
        Fri, 12 Apr 2019 17:10:14 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.82.25])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 12 Apr 2019 17:10:14 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH 04/14] fsverity: Add call back to determine readpage limit
Date:   Fri, 12 Apr 2019 22:40:31 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190412171041.31995-1-chandan@linux.ibm.com>
References: <20190412171041.31995-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19041217-0012-0000-0000-000017263A2A
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010914; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01188095; UDB=6.00622387; IPR=6.00968863;
 MB=3.00026412; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-12 17:10:22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041217-0013-0000-0000-000056D87B5B
Message-Id: <20190412171041.31995-5-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-12_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904120115
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

