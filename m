Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BEAC11F6A
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B4D261D0B
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 08:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhF3IaM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 04:30:12 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6027 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhF3IaL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 04:30:11 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GFDq24fynzXmmV
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jun 2021 16:22:22 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 16:27:34 +0800
Received: from huawei.com (10.175.104.170) by dggpemm500014.china.huawei.com
 (7.185.36.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 30 Jun
 2021 16:27:33 +0800
From:   wuguanghao <wuguanghao3@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <artem.blagodarenko@gmail.com>
CC:     <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>,
        <wuguanghao3@huawei.com>
Subject: [PATCH v2 08/12] misc: fix potential segmentation fault problem in scandir()
Date:   Wed, 30 Jun 2021 16:27:20 +0800
Message-ID: <20210630082724.50838-9-wuguanghao3@huawei.com>
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

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

In scandir(), temp_list[num_dent] is allocated by calling
malloc(), we should check whether malloc() returns NULL before
accessing temp_list[num_dent].

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 misc/create_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index d62e1cb4..869b0614 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -771,6 +771,9 @@ static int scandir(const char *dir_name, struct dirent ***name_list,
 		}
 		// add the copy of dirent to the list
 		temp_list[num_dent] = (struct dirent*)malloc((dent->d_reclen + 3) & ~3);
+		if (!temp_list[num_dent]) {
+			goto out;
+		}
 		memcpy(temp_list[num_dent], dent, dent->d_reclen);
 		num_dent++;
 	}
-- 
2.19.1

