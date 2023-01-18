Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0DAC38159
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Jan 2023 05:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjARF0q (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Jan 2023 00:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjARF0F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jan 2023 00:26:05 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5254B21;
        Tue, 17 Jan 2023 21:25:52 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NxZ1f5H3dz16Mpf;
        Wed, 18 Jan 2023 13:24:06 +0800 (CST)
Received: from huawei.com (10.113.189.238) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 18 Jan
 2023 13:25:49 +0800
From:   Wang Jianjian <wangjianjian3@huawei.com>
To:     <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <lczerner@redhat.com>
CC:     <wangjianjian3@huawei.com>, <zhangzhikang1@huawei.com>
Subject: [PATCH] ext4: Add default commit interval test
Date:   Wed, 18 Jan 2023 13:25:49 +0800
Message-ID: <20230118052549.4068332-1-wangjianjian3@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.113.189.238]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
---
 tests/ext4/053 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/ext4/053 b/tests/ext4/053
index 4f20d217..f83fe1b1 100755
--- a/tests/ext4/053
+++ b/tests/ext4/053
@@ -450,6 +450,8 @@ for fstype in ext2 ext3 ext4; do
 	mnt bh removed
 	mnt nobh removed
 	not_ext2 mnt commit=7
+	# default commit interval won't show
+	not_ext2 mnt commit=0 ""
 	mnt min_batch_time=200
 	mnt max_batch_time=10000
 	only_ext4 mnt journal_checksum
-- 
2.32.0

