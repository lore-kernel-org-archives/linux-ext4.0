Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ACBC433EF
	for <linux-ext4@archiver.kernel.org>; Sat, 11 Sep 2021 08:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7906D6113A
	for <linux-ext4@archiver.kernel.org>; Sat, 11 Sep 2021 08:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhIKIwR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 11 Sep 2021 04:52:17 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16189 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbhIKIwP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Sep 2021 04:52:15 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H65zK69W3z1DFxg;
        Sat, 11 Sep 2021 16:50:05 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Sat, 11
 Sep 2021 16:51:00 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next v2 2/6] ext4: introduce last_check_time record previous check time
Date:   Sat, 11 Sep 2021 17:00:55 +0800
Message-ID: <20210911090059.1876456-3-yebin10@huawei.com>
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

kmmpd:
...
    diff = jiffies - last_update_time;
    if (diff > mmp_check_interval * HZ) {
...
As "mmp_check_interval = 2 * mmp_update_interval", 'diff' always little
than 'mmp_update_interval', so there will never trigger detection.
Introduce last_check_time record previous check time.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/mmp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 12af6dc8457b..c781b09a78c9 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -152,6 +152,7 @@ static int kmmpd(void *data)
 	int mmp_update_interval = le16_to_cpu(es->s_mmp_update_interval);
 	unsigned mmp_check_interval;
 	unsigned long last_update_time;
+	unsigned long last_check_time;
 	unsigned long diff;
 	int retval = 0;
 
@@ -170,6 +171,7 @@ static int kmmpd(void *data)
 
 	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
 	       sizeof(mmp->mmp_nodename));
+	last_check_time = jiffies;
 
 	while (!kthread_should_stop() && !sb_rdonly(sb)) {
 		if (!ext4_has_feature_mmp(sb)) {
@@ -198,17 +200,18 @@ static int kmmpd(void *data)
 		}
 
 		diff = jiffies - last_update_time;
-		if (diff < mmp_update_interval * HZ)
+		if (diff < mmp_update_interval * HZ) {
 			schedule_timeout_interruptible(mmp_update_interval *
 						       HZ - diff);
+			diff = jiffies - last_update_time;
+		}
 
 		/*
 		 * We need to make sure that more than mmp_check_interval
-		 * seconds have not passed since writing. If that has happened
-		 * we need to check if the MMP block is as we left it.
+		 * seconds have not passed since check. If that has happened
+		 * we need to check if the MMP block is as we write it.
 		 */
-		diff = jiffies - last_update_time;
-		if (diff > mmp_check_interval * HZ) {
+		if (jiffies - last_check_time > mmp_check_interval * HZ) {
 			struct buffer_head *bh_check = NULL;
 			struct mmp_struct *mmp_check;
 
@@ -234,6 +237,7 @@ static int kmmpd(void *data)
 				goto wait_to_exit;
 			}
 			put_bh(bh_check);
+			last_check_time = jiffies;
 		}
 
 		 /*
-- 
2.31.1

