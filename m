Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F15C433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Dec 2020 13:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6DE92222B
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Dec 2020 13:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgLXNXC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:23:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9988 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgLXNXC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Dec 2020 08:23:02 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D1rM4407jzhrnS;
        Thu, 24 Dec 2020 21:21:36 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 24 Dec 2020 21:22:10 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 -next] ext4: use DEFINE_MUTEX() for mutex lock
Date:   Thu, 24 Dec 2020 21:22:44 +0800
Message-ID: <20201224132244.30907-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 fs/ext4/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 94472044f4c1..8776f06a639d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -59,7 +59,7 @@
 #include <trace/events/ext4.h>
 
 static struct ext4_lazy_init *ext4_li_info;
-static struct mutex ext4_li_mtx;
+static DEFINE_MUTEX(ext4_li_mtx);
 static struct ratelimit_state ext4_mount_msg_ratelimit;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
@@ -6640,7 +6640,6 @@ static int __init ext4_init_fs(void)
 
 	ratelimit_state_init(&ext4_mount_msg_ratelimit, 30 * HZ, 64);
 	ext4_li_info = NULL;
-	mutex_init(&ext4_li_mtx);
 
 	/* Build-time check for flags consistency */
 	ext4_check_flag_values();
-- 
2.22.0

