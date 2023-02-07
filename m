Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7425C636CC
	for <linux-ext4@archiver.kernel.org>; Tue,  7 Feb 2023 06:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBGGqK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjBGGqJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Feb 2023 01:46:09 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5716F18B
        for <linux-ext4@vger.kernel.org>; Mon,  6 Feb 2023 22:46:08 -0800 (PST)
Received: from dggpeml500016.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4P9ttj6QlxzfZ09;
        Tue,  7 Feb 2023 14:45:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500016.china.huawei.com
 (7.185.36.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Feb
 2023 14:46:05 +0800
From:   zhanchengbin <zhanchengbin1@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <yi.zhang@huawei.com>,
        <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        zhanchengbin <zhanchengbin1@huawei.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH v3 1/2] ext4: fix inode tree inconsistency caused by ENOMEM in ext4_split_extent_at
Date:   Tue, 7 Feb 2023 15:09:30 +0800
Message-ID: <20230207070931.2189663-2-zhanchengbin1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230207070931.2189663-1-zhanchengbin1@huawei.com>
References: <20230207070931.2189663-1-zhanchengbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If ENOMEM fails when the extent is splitting, we need to restore the length
of the split extent.
In the call stack of the ext4_split_extent_at function, only in
ext4_ext_create_new_leaf will it alloc memory and change the shape of the
extent tree,even if an ENOMEM is returned at this time, the extent tree is
still self-consistent, Just restore the split extent lens in the function
ext4_split_extent_at.

ext4_split_extent_at
 ext4_ext_insert_extent
  ext4_ext_create_new_leaf
   1)ext4_ext_split
     ext4_find_extent
   2)ext4_ext_grow_indepth
     ext4_find_extent

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9de1c9d1a13d..3559ea6b0781 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3251,7 +3251,7 @@ static int ext4_split_extent_at(handle_t *handle,
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err != -ENOSPC && err != -EDQUOT)
+	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
 		goto out;
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {
-- 
2.31.1

