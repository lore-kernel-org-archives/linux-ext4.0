Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130D4C07E9D
	for <linux-ext4@archiver.kernel.org>; Sat, 24 Sep 2022 02:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiIXCBk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 23 Sep 2022 22:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIXCBa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2022 22:01:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F73A407F;
        Fri, 23 Sep 2022 19:01:30 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZBy43kdjzpVHx;
        Sat, 24 Sep 2022 09:58:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 10:01:27 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next v2 1/2] ext4: remove unnecessary drop path references in mext_check_coverage()
Date:   Sat, 24 Sep 2022 10:12:10 +0800
Message-ID: <20220924021211.3831551-2-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220924021211.3831551-1-yebin10@huawei.com>
References: <20220924021211.3831551-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

According to Jan Kara's suggestion:
"The use in mext_check_coverage() can be actually removed
- get_ext_path() -> ext4_find_extent() takes care of dropping the references."
So remove unnecessary call ext4_ext_drop_refs() in mext_check_coverage().

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/move_extent.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 701f1d6a217f..782bbda2a717 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -103,7 +103,6 @@ mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
 		if (unwritten != ext4_ext_is_unwritten(ext))
 			goto out;
 		from += ext4_ext_get_actual_len(ext);
-		ext4_ext_drop_refs(path);
 	}
 	ret = 1;
 out:
-- 
2.31.1

