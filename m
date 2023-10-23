Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC80CDB474
	for <linux-ext4@archiver.kernel.org>; Mon, 23 Oct 2023 01:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjJWB0U (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 22 Oct 2023 21:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjJWB0U (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Oct 2023 21:26:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13C7D6;
        Sun, 22 Oct 2023 18:26:17 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SDHVX2LshzVlxt;
        Mon, 23 Oct 2023 09:22:28 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 23 Oct
 2023 09:26:15 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH v2 0/4] ext4: fix WARN_ON in alloc_flex_gd()
Date:   Mon, 23 Oct 2023 09:30:53 +0800
Message-ID: <20231023013057.2117948-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Changes since v1:
* Modified the comments in patch 4.

Baokun Li (4):
  ext4: unify the type of flexbg_size to unsigned int
  ext4: remove unnecessary check from alloc_flex_gd()
  ext4: avoid online resizing failures due to oversized flex bg
  ext4: reduce unnecessary memory allocation in alloc_flex_gd()

 fs/ext4/resize.c | 49 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

-- 
2.31.1

