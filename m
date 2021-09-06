Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B8BC4332F
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Sep 2021 14:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DCD060232
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Sep 2021 14:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbhIFOjD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:39:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19012 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243432AbhIFOi6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Sep 2021 10:38:58 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H39rH3HrRzbmG0;
        Mon,  6 Sep 2021 22:33:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Mon, 6 Sep
 2021 22:37:50 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next 3/6] ext4: compare to local seq and nodename when check conflict
Date:   Mon, 6 Sep 2021 22:47:51 +0800
Message-ID: <20210906144754.2601607-4-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210906144754.2601607-1-yebin10@huawei.com>
References: <20210906144754.2601607-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

As mmp and check_mmp is point to the same data, so there will never
detect conflict.
To solve this issue just compare to local data.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/mmp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 89797f12a815..0fe7b9ac9db6 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -154,6 +154,7 @@ static int kmmpd(void *data)
 	unsigned long last_update_time;
 	unsigned long last_check_time;
 	unsigned long diff;
+	char nodename[64];
 	int retval = 0;
 
 	mmp_block = le64_to_cpu(es->s_mmp_block);
@@ -169,8 +170,8 @@ static int kmmpd(void *data)
 	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
 	bdevname(bh->b_bdev, mmp->mmp_bdevname);
 
-	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
-	       sizeof(mmp->mmp_nodename));
+	memcpy(nodename, init_utsname()->nodename, sizeof(nodename));
+	memcpy(mmp->mmp_nodename, nodename, sizeof(mmp->mmp_nodename));
 	last_update_time = jiffies;
 
 	while (!kthread_should_stop() && !sb_rdonly(sb)) {
@@ -224,8 +225,8 @@ static int kmmpd(void *data)
 			}
 
 			mmp_check = (struct mmp_struct *)(bh_check->b_data);
-			if (mmp->mmp_seq != mmp_check->mmp_seq ||
-			    memcmp(mmp->mmp_nodename, mmp_check->mmp_nodename,
+			if (seq != mmp_check->mmp_seq ||
+			    memcmp(nodename, mmp_check->mmp_nodename,
 				   sizeof(mmp->mmp_nodename))) {
 				dump_mmp_msg(sb, mmp_check,
 					     "Error while updating MMP info. "
-- 
2.31.1

