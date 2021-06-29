Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8A2C11F66
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jun 2021 14:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 098FE61DB4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jun 2021 14:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhF2O35 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jun 2021 10:29:57 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:9298 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbhF2O3x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jun 2021 10:29:53 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GDmrX47Kpz1BT6b;
        Tue, 29 Jun 2021 22:22:04 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 29
 Jun 2021 22:27:22 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jack@suse.cz>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH 0/2] Fix use-after-free about sbi->s_mmp_tsk
Date:   Tue, 29 Jun 2021 22:36:01 +0800
Message-ID: <20210629143603.2166962-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Ye Bin (2):
  ext4: Fix use-after-free about sbi->s_mmp_tsk
  ext4: Fix potential uas-after-free about sbi->s_mmp_tsk when kmmpd
    kthread exit before set sbi->s_mmp_tsk

 fs/ext4/ext4.h  |  1 +
 fs/ext4/mmp.c   | 34 ++++++++++++++++++++++++++++------
 fs/ext4/super.c |  1 +
 3 files changed, 30 insertions(+), 6 deletions(-)

-- 
2.31.1

