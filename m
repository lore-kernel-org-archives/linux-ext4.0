Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D996FC433B4
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Apr 2021 08:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A200B610CA
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Apr 2021 08:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbhDAIL0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Apr 2021 04:11:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14664 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhDAILN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2021 04:11:13 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9wmb2jSYznX8p;
        Thu,  1 Apr 2021 16:08:31 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Thu, 1 Apr 2021
 16:11:02 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [RFC] ext4: Fix fs can't panic when abort by user
Date:   Thu, 1 Apr 2021 16:19:03 +0800
Message-ID: <20210401081903.3421208-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Test steps:
1. mount /dev/sda -o errors=panic test
2. mount /dev/sda -o remount,ro test
3. mount /dev/sda -o remount,abort test

Before 014c9caa29d3 not been merged there will trigger panic. But
014c9caa29d3 change this behavior.

Fixes: 014c9caa29d3 ("ext4: make ext4_abort() use __ext4_error()")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b9693680463a..acb75dc396f8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -667,9 +667,6 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 			ext4_commit_super(sb);
 	}
 
-	if (sb_rdonly(sb) || continue_fs)
-		return;
-
 	/*
 	 * We force ERRORS_RO behavior when system is rebooting. Otherwise we
 	 * could panic during 'reboot -f' as the underlying device got already
@@ -679,6 +676,10 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 		panic("EXT4-fs (device %s): panic forced after error\n",
 			sb->s_id);
 	}
+
+	if (sb_rdonly(sb) || continue_fs)
+		return;
+
 	ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 	/*
 	 * Make sure updated value of ->s_mount_flags will be visible before
-- 
2.25.4

