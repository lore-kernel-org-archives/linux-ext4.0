Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2280C4332F
	for <linux-ext4@archiver.kernel.org>; Fri,  3 Nov 2023 06:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjKCG6G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjKCG6F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Nov 2023 02:58:05 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698CEE3
        for <linux-ext4@vger.kernel.org>; Thu,  2 Nov 2023 23:58:02 -0700 (PDT)
Received: from kwepemm000013.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SMBM35HmFzrTjT;
        Fri,  3 Nov 2023 14:54:55 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 3 Nov
 2023 14:57:59 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <chengzhihao1@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH 0/5] jbd2: Add errseq to detect writeback
Date:   Fri, 3 Nov 2023 22:52:45 +0800
Message-ID: <20231103145250.2995746-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000013.china.huawei.com (7.193.23.81)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

According to discussions in [1], this patchset adds errseq in journal to
enable JDB2 detecting meatadata writeback error of fs dev. Then, orginal
checking mechanism could be removed.

[1] https://lore.kernel.org/all/20230908124317.2955345-1-chengzhihao1@huawei.com/T/

Zhihao Cheng (5):
  jbd2: Add errseq to detect client fs's bdev writeback error
  jbd2: Replace journal state flag by checking errseq
  jbd2: Remove unused 'JBD2_CHECKPOINT_IO_ERROR' and 'j_atomic_flags'
  jbd2: Abort journal when detecting metadata writeback error of fs dev
  ext4: Move ext4_check_bdev_write_error() into nojournal mode

 fs/ext4/ext4_jbd2.c   |  5 ++---
 fs/jbd2/checkpoint.c  | 11 -----------
 fs/jbd2/journal.c     | 11 ++++++-----
 fs/jbd2/recovery.c    |  7 +------
 fs/jbd2/transaction.c | 14 ++++++++++++++
 include/linux/jbd2.h  | 37 ++++++++++++++++++++++++++-----------
 6 files changed, 49 insertions(+), 36 deletions(-)

-- 
2.39.2

