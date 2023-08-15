Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B24C04A6A
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Aug 2023 11:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbjHOLaG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Aug 2023 07:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbjHOL3u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Aug 2023 07:29:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D691BE5;
        Tue, 15 Aug 2023 04:29:39 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RQ89Y3R6TzFqdq;
        Tue, 15 Aug 2023 19:26:41 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 15 Aug
 2023 19:29:37 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jack@suse.cz>, <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Ye Bin <yebin10@huawei.com>
Subject: [PATCH v2 0/4] ext2: fix race between setxattr and write back
Date:   Tue, 15 Aug 2023 19:26:08 +0800
Message-ID: <20230815112612.221145-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Diff v2 vs v1:
1. Do not use reservation window when allocate block for xattr.
2. Remove BUG() in ext2_try_to_allocate_with_rsv().

Ye Bin (4):
  ext2: remove ext2_new_block()
  ext2: introduce flag argument for ext2_new_blocks()
  ext2: fix race between setxattr and write back
  ext2: dump current reservation window info

 fs/ext2/balloc.c | 32 +++++++++++++++++---------------
 fs/ext2/ext2.h   |  8 ++++++--
 fs/ext2/inode.c  |  2 +-
 fs/ext2/xattr.c  |  4 +++-
 4 files changed, 27 insertions(+), 19 deletions(-)

-- 
2.31.1

