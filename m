Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC25C11F65
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71CF61D0C
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhF3IaQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:30:16 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:9326 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhF3IaN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 04:30:13 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GFDrL13qQz74H7
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jun 2021 16:23:30 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 16:27:31 +0800
Received: from huawei.com (10.175.104.170) by dggpemm500014.china.huawei.com
 (7.185.36.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 30 Jun
 2021 16:27:30 +0800
From:   wuguanghao <wuguanghao3@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <artem.blagodarenko@gmail.com>
CC:     <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>,
        <wuguanghao3@huawei.com>
Subject: [PATCH v2 01/12] profile_create_node: set magic before strdup(name) to avoid memory leak
Date:   Wed, 30 Jun 2021 16:27:13 +0800
Message-ID: <20210630082724.50838-2-wuguanghao3@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.170]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If new->magic != PROF_MAGIC_NODE, profile_free_node() don't free node.
This will cause the node to be unable to be released correctly and
a memory leak will occur.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
---
 lib/support/profile.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/support/profile.c b/lib/support/profile.c
index 585ed595..2eb3a9d1 100644
--- a/lib/support/profile.c
+++ b/lib/support/profile.c
@@ -1093,6 +1093,8 @@ errcode_t profile_create_node(const char *name, const char *value,
 	if (!new)
 		return ENOMEM;
 	memset(new, 0, sizeof(struct profile_node));
+	new->magic = PROF_MAGIC_NODE;
+
 	new->name = strdup(name);
 	if (new->name == 0) {
 	    profile_free_node(new);
@@ -1105,7 +1107,6 @@ errcode_t profile_create_node(const char *name, const char *value,
 		    return ENOMEM;
 		}
 	}
-	new->magic = PROF_MAGIC_NODE;
 
 	*ret_node = new;
 	return 0;
-- 
2.19.1

