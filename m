Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35085C07E9D
	for <linux-ext4@archiver.kernel.org>; Sat, 24 Sep 2022 07:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiIXHl5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 24 Sep 2022 03:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiIXHly (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Sep 2022 03:41:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8A6118B02;
        Sat, 24 Sep 2022 00:41:51 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZLTG5vLwzlW19;
        Sat, 24 Sep 2022 15:37:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 15:41:49 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next 0/3] fix potential out of bound read in ext4_fc_replay_scan()
Date:   Sat, 24 Sep 2022 15:52:30 +0800
Message-ID: <20220924075233.2315259-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Ye Bin (3):
  ext4: introduce EXT4_FC_TAG_BASE_LEN helper
  ext4: factor out ext4_fc_get_tl()
  ext4: fix potential out of bound read in ext4_fc_replay_scan()

 fs/ext4/fast_commit.c | 122 ++++++++++++++++++++++++++++--------------
 fs/ext4/fast_commit.h |   3 ++
 2 files changed, 84 insertions(+), 41 deletions(-)

-- 
2.31.1

