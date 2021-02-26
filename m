Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B939C433E9
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Feb 2021 01:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 272A064EE2
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Feb 2021 01:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBZBXx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:53 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12580 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhBZBXt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Feb 2021 20:23:49 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DmsL65bywzMfD1;
        Fri, 26 Feb 2021 09:21:02 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Feb 2021
 09:22:59 +0800
To:     <linux-ext4@vger.kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>
CC:     harshad shirwadkar <harshadshirwadkar@gmail.com>,
        linfeilong <linfeilong@huawei.com>,
        lihaotian <lihaotian9@huawei.com>, <liuzhiqiang26@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] misc: remove useless code in set_inode_xattr()
Message-ID: <283210da-b281-2dd7-6ef7-b31e81e72e01@huawei.com>
Date:   Fri, 26 Feb 2021 09:22:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


In set_inode_xattr(), there are two returns as follows,
-
  return retval;
  return 0;
-
Here, we remove useless 'return 0;' code.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 misc/create_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 54d8d343..d62e1cb4 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -234,7 +234,6 @@ static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino,
 		retval = retval ? retval : close_retval;
 	}
 	return retval;
-	return 0;
 }
 #else /* HAVE_LLISTXATTR */
 static errcode_t set_inode_xattr(ext2_filsys fs EXT2FS_ATTR((unused)),
-- 
2.19.1

