Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB434C04FF3
	for <linux-ext4@archiver.kernel.org>; Mon, 24 May 2021 11:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6FEB610FA
	for <linux-ext4@archiver.kernel.org>; Mon, 24 May 2021 11:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhEXLZt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 24 May 2021 07:25:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3925 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhEXLZ1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 May 2021 07:25:27 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FpZXM1MZhzCx5q
        for <linux-ext4@vger.kernel.org>; Mon, 24 May 2021 19:21:07 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 19:23:57 +0800
Received: from [10.174.179.184] (10.174.179.184) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 19:23:57 +0800
Subject: [PATCH 07/12] argv_parse: check return value of malloc in
 argv_parse()
From:   Wu Guanghao <wuguanghao3@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
References: <266bc52e-e279-ce84-0e1f-1405b9bc6174@huawei.com>
Message-ID: <5d711bbc-50bb-c8a5-a118-e22a691c0d7f@huawei.com>
Date:   Mon, 24 May 2021 19:23:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <266bc52e-e279-ce84-0e1f-1405b9bc6174@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.184]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In argv_parse(), return value of malloc should be checked
whether it is NULL, otherwise, it may cause a segfault error.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 lib/support/argv_parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/support/argv_parse.c b/lib/support/argv_parse.c
index d22f6344..1ef9c014 100644
--- a/lib/support/argv_parse.c
+++ b/lib/support/argv_parse.c
@@ -116,6 +116,8 @@ int argv_parse(char *in_buf, int *ret_argc, char ***ret_argv)
 	if (argv == 0) {
 		argv = malloc(sizeof(char *));
 		free(buf);
+		if (!arcv)
+			return -1;
 	}
 	argv[argc] = 0;
 	if (ret_argc)
-- 
