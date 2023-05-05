Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B11C77B7C
	for <linux-ext4@archiver.kernel.org>; Fri,  5 May 2023 13:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjEENZy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 5 May 2023 09:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjEENZr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 May 2023 09:25:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC5321552;
        Fri,  5 May 2023 06:25:44 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QCWZg0WdfzLpV9;
        Fri,  5 May 2023 21:22:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 21:25:38 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>, <libaokun1@huawei.com>,
        <syzbot+08106c4b7d60702dbc14@syzkaller.appspotmail.com>
Subject: [PATCH] ext4: check iomap type only if ext4_iomap_begin() does not fail
Date:   Fri, 5 May 2023 21:24:29 +0800
Message-ID: <20230505132429.714648-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When ext4_iomap_overwrite_begin() calls ext4_iomap_begin() map blocks may
fail for some reason (e.g. memory allocation failure, bare disk write), and
later because "iomap->type ! = IOMAP_MAPPED" triggers WARN_ON(). When ext4
iomap_begin() returns an error, it is normal that the type of iomap->type
may not match the expectation. Therefore, we only determine if iomap->type
is as expected when ext4_iomap_begin() is executed successfully.

Reported-by: syzbot+08106c4b7d60702dbc14@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/00000000000015760b05f9b4eee9@google.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0d5ba922e411..19c884abe52b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3375,7 +3375,7 @@ static int ext4_iomap_overwrite_begin(struct inode *inode, loff_t offset,
 	 */
 	flags &= ~IOMAP_WRITE;
 	ret = ext4_iomap_begin(inode, offset, length, flags, iomap, srcmap);
-	WARN_ON_ONCE(iomap->type != IOMAP_MAPPED);
+	WARN_ON_ONCE(!ret && iomap->type != IOMAP_MAPPED);
 	return ret;
 }
 
-- 
2.31.1

