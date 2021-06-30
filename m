Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A126C11F69
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB2061CA2
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhF3IaM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:30:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5946 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbhF3IaL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 04:30:11 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GFDsH3sNQz75SM
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jun 2021 16:24:19 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 16:27:31 +0800
Received: from huawei.com (10.175.104.170) by dggpemm500014.china.huawei.com
 (7.185.36.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 30 Jun
 2021 16:27:31 +0800
From:   wuguanghao <wuguanghao3@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <artem.blagodarenko@gmail.com>
CC:     <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>,
        <wuguanghao3@huawei.com>
Subject: [PATCH v2 02/12] tdb_transaction_recover: fix memory leak
Date:   Wed, 30 Jun 2021 16:27:14 +0800
Message-ID: <20210630082724.50838-3-wuguanghao3@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210630082724.50838-2-wuguanghao3@huawei.com>
References: <20210630082724.50838-2-wuguanghao3@huawei.com>
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

In tdb_transaction_recover(), need free data before return,
otherwise it will cause memory leak.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
---
 lib/ext2fs/tdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/ext2fs/tdb.c b/lib/ext2fs/tdb.c
index 5091b128..0fb94815 100644
--- a/lib/ext2fs/tdb.c
+++ b/lib/ext2fs/tdb.c
@@ -2186,6 +2186,7 @@ int tdb_transaction_recover(struct tdb_context *tdb)
 				   rec.data_len, 0) == -1) {
 		TDB_LOG((tdb, TDB_DEBUG_FATAL, "tdb_transaction_recover: failed to read recovery data\n"));
 		tdb->ecode = TDB_ERR_IO;
+		free(data);
 		return -1;
 	}
 
-- 
2.19.1

