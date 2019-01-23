Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3276FC282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 13:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E8120855
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 13:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfAWNKc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:10:32 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:55954 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfAWNKc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 08:10:32 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 11BB3D7B25E365E1D3AE
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 21:10:30 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.408.0; Wed, 23 Jan 2019 21:10:23 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <jack@suse.cz>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <yangerkun@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: [PATCH 0/2] fix a bug in ext2_max_size
Date:   Wed, 23 Jan 2019 21:14:07 +0800
Message-ID: <20190123131409.126156-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When mkfs.ext2 with '-b 65536' and mount(arm 64KB page size),
function mount_fs will trigger WARNNING since ext2_max_size will
return value less than 0. Also, we cannot write any file in this
fs since the sb->maxbytes is less than 0.

Fix it by get the exact max file size.

yangerkun (2):
  ext2: remove static of ext2_block_to_path
  ext2: get the exact max filesize in ext2_max_size

 fs/ext2/ext2.h  |   1 +
 fs/ext2/inode.c |  16 ++++----
 fs/ext2/super.c | 115 ++++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 101 insertions(+), 31 deletions(-)

-- 
2.9.5

