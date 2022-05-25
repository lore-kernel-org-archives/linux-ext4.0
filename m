Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8410FC433F5
	for <linux-ext4@archiver.kernel.org>; Wed, 25 May 2022 02:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243702AbiEYCwM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 24 May 2022 22:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiEYCwL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2022 22:52:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E556B32059
        for <linux-ext4@vger.kernel.org>; Tue, 24 May 2022 19:52:09 -0700 (PDT)
Received: from kwepemi100002.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L7FtP3ysDzbbZn;
        Wed, 25 May 2022 10:50:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100002.china.huawei.com (7.221.188.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 25 May 2022 10:52:07 +0800
Received: from huawei.com (10.175.101.6) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 25 May
 2022 10:52:07 +0800
From:   Shuqi Zhang <zhangshuqi3@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <adilger.kernel@dilger.ca>, <tytso@mit.edu>,
        <zhangshuqi3@huawei.com>
Subject: [PATCH] ext4: Use kmemdup() to replace kmalloc + memcpy
Date:   Wed, 25 May 2022 11:01:20 +0800
Message-ID: <20220525030120.803330-1-zhangshuqi3@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Replace kmalloc + memcpy with kmemdup()

Signed-off-by: Shuqi Zhang <zhangshuqi3@huawei.com>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 042325349098..564e28a1aa94 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1895,11 +1895,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 			unlock_buffer(bs->bh);
 			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
+			s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
 			error = -ENOMEM;
 			if (s->base == NULL)
 				goto cleanup;
-			memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
 			s->first = ENTRY(header(s->base)+1);
 			header(s->base)->h_refcount = cpu_to_le32(1);
 			s->here = ENTRY(s->base + offset);
-- 
2.31.1

