Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3FAC433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Mar 2022 06:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiCaGjl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Mar 2022 02:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiCaGjj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2022 02:39:39 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E204109A53;
        Wed, 30 Mar 2022 23:37:51 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KTYWZ2KXYz1GDG6;
        Thu, 31 Mar 2022 14:37:30 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 14:37:48 +0800
Message-ID: <34889f32-7dd9-125e-2f7a-734faa395d20@huawei.com>
Date:   Thu, 31 Mar 2022 14:37:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <corbet@lwn.net>
CC:     <linux-ext4@vger.kernel.org>, <linux-doc@vger.kernel.org>
From:   "wangjianjian (C)" <wangjianjian3@huawei.com>
Subject: [PATCH] ext4, doc: Fix incorrect h_reserved size
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.108.234.194]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

According to document and code, ext4_xattr_header's size is 32 bytes, so
h_reserved size should be 3.

Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
  Documentation/filesystems/ext4/attributes.rst | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4/attributes.rst 
b/Documentation/filesystems/ext4/attributes.rst
index 54386a010a8d..871d2da7a0a9 100644
--- a/Documentation/filesystems/ext4/attributes.rst
+++ b/Documentation/filesystems/ext4/attributes.rst
@@ -76,7 +76,7 @@ The beginning of an extended attribute block is in
       - Checksum of the extended attribute block.
     * - 0x14
       - \_\_u32
-     - h\_reserved[2]
+     - h\_reserved[3]
       - Zero.

  The checksum is calculated against the FS UUID, the 64-bit block number
--
2.32.0

