Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6124CC6FD1D
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Mar 2023 06:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjC3G5p (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 30 Mar 2023 02:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjC3G5m (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Mar 2023 02:57:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5CA61B3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Mar 2023 23:57:37 -0700 (PDT)
Received: from dggpeml500016.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PnDfx2RsWzgZyt;
        Thu, 30 Mar 2023 14:54:17 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500016.china.huawei.com
 (7.185.36.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 30 Mar
 2023 14:57:34 +0800
From:   zhanchengbin <zhanchengbin1@huawei.com>
To:     <tytso@mit.edu>, <djwong@kernel.org>
CC:     <linux-ext4@vger.kernel.org>, <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>, <liuzhiqiang26@huawei.com>,
        zhanchengbin <zhanchengbin1@huawei.com>
Subject: [PATCH v2 0/2] Add some msg for io error
Date:   Thu, 30 Mar 2023 14:56:54 +0800
Message-ID: <20230330065656.3275785-1-zhanchengbin1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If there is an EIO during the process of fsck, the user can be notified of it.

Diff v2 Vs v1:
1) Optimize printing information
2) Remove the interaction after fsync failed and return an error.
3) Rearrange the patch sets.

zhanchengbin (2):
  lib/ext2fs: add error handle in unix_flush and unix_write_byte
  e2fsck: add sync error handle to e2fsck.

 e2fsck/ehandler.c    | 22 ++++++++++++++++++++++
 lib/ext2fs/ext2_io.h |  2 ++
 lib/ext2fs/unix_io.c | 37 ++++++++++++++++++++++++++-----------
 3 files changed, 50 insertions(+), 11 deletions(-)

-- 
2.31.1

