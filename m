Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E8CC43218
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBE32075D
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfD1EcH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 00:32:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbfD1EcG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 28 Apr 2019 00:32:06 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3S4T9b7027059
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:32:05 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s53yrsm54-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:32:05 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 28 Apr 2019 05:32:04 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 28 Apr 2019 05:32:01 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3S4UjW825756094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Apr 2019 04:30:45 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1DE1112062;
        Sun, 28 Apr 2019 04:30:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04AFA112063;
        Sun, 28 Apr 2019 04:30:42 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.75.21])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 28 Apr 2019 04:30:41 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, hch@infradead.org
Subject: [PATCH V2 03/13] fsverity: Add call back to decide if verity check has to be performed
Date:   Sun, 28 Apr 2019 10:01:11 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190428043121.30925-1-chandan@linux.ibm.com>
References: <20190428043121.30925-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042804-2213-0000-0000-0000038361AA
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011008; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01195431; UDB=6.00626836; IPR=6.00976273;
 MB=3.00026628; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-28 04:32:04
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042804-2214-0000-0000-00005E353977
Message-Id: <20190428043121.30925-4-chandan@linux.ibm.com>
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

Ext4 and F2FS store verity metadata in data extents (beyond
inode->i_size) associated with a file. But other filesystems might
choose alternative means to store verity metadata. Hence this commit
adds a callback function pointer to 'struct fsverity_operations' to help
in deciding if verity operation needs to performed against a page-cache
page holding file data.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/ext4/super.c          | 6 ++++++
 fs/f2fs/super.c          | 6 ++++++
 fs/read_callbacks.c      | 4 +++-
 include/linux/fsverity.h | 1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aba724f82cc3..63d73b360f1d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1428,10 +1428,16 @@ static struct page *ext4_read_verity_metadata_page(struct inode *inode,
 	return read_mapping_page(inode->i_mapping, index, NULL);
 }
 
+static bool ext4_verity_required(struct inode *inode, pgoff_t index)
+{
+	return index < (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+}
+
 static const struct fsverity_operations ext4_verityops = {
 	.set_verity		= ext4_set_verity,
 	.get_metadata_end	= ext4_get_verity_metadata_end,
 	.read_metadata_page	= ext4_read_verity_metadata_page,
+	.verity_required	= ext4_verity_required,
 };
 #endif /* CONFIG_FS_VERITY */
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2f75f06c784a..cd1299e1f92d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2257,10 +2257,16 @@ static struct page *f2fs_read_verity_metadata_page(struct inode *inode,
 	return read_mapping_page(inode->i_mapping, index, NULL);
 }
 
+static bool f2fs_verity_required(struct inode *inode, pgoff_t index)
+{
+	return index < (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+}
+
 static const struct fsverity_operations f2fs_verityops = {
 	.set_verity		= f2fs_set_verity,
 	.get_metadata_end	= f2fs_get_verity_metadata_end,
 	.read_metadata_page	= f2fs_read_verity_metadata_page,
+	.verity_required	= f2fs_verity_required,
 };
 #endif /* CONFIG_FS_VERITY */
 
diff --git a/fs/read_callbacks.c b/fs/read_callbacks.c
index b6d5b95e67d7..6dea54b0baa9 100644
--- a/fs/read_callbacks.c
+++ b/fs/read_callbacks.c
@@ -86,7 +86,9 @@ struct read_callbacks_ctx *get_read_callbacks_ctx(struct inode *inode,
 		read_callbacks_steps |= 1 << STEP_DECRYPT;
 #ifdef CONFIG_FS_VERITY
 	if (inode->i_verity_info != NULL &&
-		(index < ((i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT)))
+		((inode->i_sb->s_vop->verity_required
+			&& inode->i_sb->s_vop->verity_required(inode, index))
+			|| (inode->i_sb->s_vop->verity_required == NULL)))
 		read_callbacks_steps |= 1 << STEP_VERITY;
 #endif
 	if (read_callbacks_steps) {
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 7c33b42abf1b..b83712d6c79a 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -18,6 +18,7 @@ struct fsverity_operations {
 	int (*set_verity)(struct inode *inode, loff_t data_i_size);
 	int (*get_metadata_end)(struct inode *inode, loff_t *metadata_end_ret);
 	struct page *(*read_metadata_page)(struct inode *inode, pgoff_t index);
+	bool (*verity_required)(struct inode *inode, pgoff_t index);
 };
 
 #ifdef CONFIG_FS_VERITY
-- 
2.19.1

