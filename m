Return-Path: <SRS0=QTyG=PS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:60676 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727039AbfAJDdW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Jan 2019 22:33:22 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 897F5A5C59155F2C0128
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2019 11:33:20 +0800 (CST)
From: yangerkun <yangerkun@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <miaoxie@huawei.com>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 0/4] fix bugs for ioctl EXT4_IOC_SWAP_BOOT
Date: Thu, 10 Jan 2019 11:36:46 +0800
Message-ID: <20190110033650.108403-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

yangerkun (4):
  ext4: fix check of inode in swap_inode_boot_loader
  ext4: cleanup pagecache before swap i_data
  ext4: update quota information while swapping boot loader inode
  ext4: add mask of ext4 flags to swap

 fs/ext4/ext4.h  |  4 ++++
 fs/ext4/ioctl.c | 73 ++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 61 insertions(+), 16 deletions(-)

-- 
2.9.5
