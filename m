Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2A9C433C1
	for <linux-ext4@archiver.kernel.org>; Wed, 31 Mar 2021 03:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B44619BD
	for <linux-ext4@archiver.kernel.org>; Wed, 31 Mar 2021 03:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCaDYG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:24:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14650 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbhCaDXu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2021 23:23:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9BRT708fznVqS;
        Wed, 31 Mar 2021 11:21:09 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Wed, 31 Mar 2021
 11:23:38 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <yi.zhang@huawei.com>
Subject: [PATCH] ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()
Date:   Wed, 31 Mar 2021 11:31:38 +0800
Message-ID: <20210331033138.918975-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When CONFIG_QUOTA is enabled, if we failed to mount the filesystem due
to some error happens behind ext4_orphan_cleanup(), it will end up
triggering a after free issue of super_block. The problem is that
ext4_orphan_cleanup() will set SB_ACTIVE flag if CONFIG_QUOTA is
enabled, after we cleanup the truncated inodes, the last iput() will put
them into the lru list, and these inodes' pages may probably dirty and
will be write back by the writeback thread, so it could be raced by
freeing super_block in the error path of mount_bdev().

After check the setting of SB_ACTIVE flag in ext4_orphan_cleanup(), it
was used to ensure updating the quota file properly, but evict inode and
trash data immediately in the last iput does not affect the quotafile,
so setting the SB_ACTIVE flag seems not required[1]. Fix this issue by
just remove the SB_ACTIVE setting.

[1] https://lore.kernel.org/linux-ext4/99cce8ca-e4a0-7301-840f-2ace67c551f3@huawei.com/T/#m04990cfbc4f44592421736b504afcc346b2a7c00

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Tested-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b9693680463a..2a33c53b57d8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3023,9 +3023,6 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		sb->s_flags &= ~SB_RDONLY;
 	}
 #ifdef CONFIG_QUOTA
-	/* Needed for iput() to work correctly and not trash data */
-	sb->s_flags |= SB_ACTIVE;
-
 	/*
 	 * Turn on quotas which were not enabled for read-only mounts if
 	 * filesystem has quota feature, so that they are updated correctly.
-- 
2.25.4

