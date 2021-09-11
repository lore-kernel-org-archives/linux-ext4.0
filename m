Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DC1C4321E
	for <linux-ext4@archiver.kernel.org>; Sat, 11 Sep 2021 08:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 496A6611BF
	for <linux-ext4@archiver.kernel.org>; Sat, 11 Sep 2021 08:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhIKIwT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 11 Sep 2021 04:52:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16191 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbhIKIwP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Sep 2021 04:52:15 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H65zL4vNNz1DGps;
        Sat, 11 Sep 2021 16:50:06 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Sat, 11
 Sep 2021 16:51:01 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next v2 4/6] ext4: avoid to re-read mmp check data get from page cache
Date:   Sat, 11 Sep 2021 17:00:57 +0800
Message-ID: <20210911090059.1876456-5-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210911090059.1876456-1-yebin10@huawei.com>
References: <20210911090059.1876456-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

As call read_mmp_block pass bh_check which value is NULL, then call
sb_getblk to get buffer_head. But mmp_block's buffer_head is already exist
 which also is uptodate. Lead to compare the same data.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/mmp.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 4433fe7e9e86..007bde3c12b8 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -213,10 +213,7 @@ static int kmmpd(void *data)
 		 * we need to check if the MMP block is as we write it.
 		 */
 		if (jiffies - last_check_time > mmp_check_interval * HZ) {
-			struct buffer_head *bh_check = NULL;
-			struct mmp_struct *mmp_check;
-
-			retval = read_mmp_block(sb, &bh_check, mmp_block);
+			retval = read_mmp_block(sb, &bh, mmp_block);
 			if (retval) {
 				ext4_error_err(sb, -retval,
 					       "error reading MMP data: %d",
@@ -224,20 +221,18 @@ static int kmmpd(void *data)
 				goto wait_to_exit;
 			}
 
-			mmp_check = (struct mmp_struct *)(bh_check->b_data);
-			if (seq != mmp_check->mmp_seq ||
-			    memcmp(nodename, mmp_check->mmp_nodename,
-				   sizeof(mmp->mmp_nodename))) {
-				dump_mmp_msg(sb, mmp_check,
+			mmp = (struct mmp_struct *)(bh->b_data);
+			if (seq != le32_to_cpu(mmp->mmp_seq) ||
+			    memcmp(nodename, mmp->mmp_nodename,
+				    sizeof(nodename))) {
+				dump_mmp_msg(sb, mmp,
 					     "Error while updating MMP info. "
 					     "The filesystem seems to have been"
 					     " multiply mounted.");
 				ext4_error_err(sb, EBUSY, "abort");
-				put_bh(bh_check);
 				retval = -EBUSY;
 				goto wait_to_exit;
 			}
-			put_bh(bh_check);
 			last_check_time = jiffies;
 		}
 
-- 
2.31.1

