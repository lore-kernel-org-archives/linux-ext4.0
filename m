Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A40EB64DA
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Jun 2023 11:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjF3LKw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 30 Jun 2023 07:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjF3LKu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jun 2023 07:10:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A93170F;
        Fri, 30 Jun 2023 04:10:49 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QssxC5SfczpWLF;
        Fri, 30 Jun 2023 19:07:59 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 30 Jun
 2023 19:10:45 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <jack@suse.cz>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
        <yukuai3@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH v3 0/5] quota: fix race condition between dqput() and dquot_mark_dquot_dirty()
Date:   Fri, 30 Jun 2023 19:08:17 +0800
Message-ID: <20230630110822.3881712-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello Honza,

This is a solution that uses dquot_srcu to avoid race condition between
dqput() and dquot_mark_dquot_dirty(). I performed a 12+h fault injection
stress test (6 VMs, 4 test threads per VM) and have not found any problems.
And I tested the performance based on the next branch (5c875096d590), this
patch set didn't degrade performance, but rather had a ~5% improvement.

V1->V2:
	Modify the solution to use dquot_srcu.
V2->V3:
	Merge some patches, optimize descriptions.
	Simplify solutions, and fix some spelling errors.

Baokun Li (5):
  quota: factor out dquot_write_dquot()
  quota: rename dquot_active() to inode_quota_active()
  quota: add new helper dquot_active()
  quota: fix dqput() to follow the guarantees dquot_srcu should provide
  quota: simplify drop_dquot_ref()

 fs/quota/dquot.c | 244 ++++++++++++++++++++++++-----------------------
 1 file changed, 125 insertions(+), 119 deletions(-)

-- 
2.31.1

