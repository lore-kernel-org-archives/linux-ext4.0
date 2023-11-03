Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EF6C4167B
	for <linux-ext4@archiver.kernel.org>; Fri,  3 Nov 2023 06:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjKCG6P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjKCG6K (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Nov 2023 02:58:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32A7131
        for <linux-ext4@vger.kernel.org>; Thu,  2 Nov 2023 23:58:07 -0700 (PDT)
Received: from kwepemm000013.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SMBQZ0jFRzVjpN;
        Fri,  3 Nov 2023 14:57:58 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 3 Nov
 2023 14:58:02 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <tytso@mit.edu>, <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <chengzhihao1@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH 5/5] ext4: Move ext4_check_bdev_write_error() into nojournal mode
Date:   Fri, 3 Nov 2023 22:52:50 +0800
Message-ID: <20231103145250.2995746-6-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231103145250.2995746-1-chengzhihao1@huawei.com>
References: <20231103145250.2995746-1-chengzhihao1@huawei.com>
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

Since JBD2 takes care of all metadata writeback errors of fs dev,
ext4_check_bdev_write_error() is useful only in nojournal mode.
Move it into '!ext4_handle_valid(handle)' branch.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index d1a2e6624401..5d8055161acd 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -235,8 +235,6 @@ int __ext4_journal_get_write_access(const char *where, unsigned int line,
 
 	might_sleep();
 
-	ext4_check_bdev_write_error(sb);
-
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_write_access(handle, bh);
 		if (err) {
@@ -244,7 +242,8 @@ int __ext4_journal_get_write_access(const char *where, unsigned int line,
 						  handle, err);
 			return err;
 		}
-	}
+	} else
+		ext4_check_bdev_write_error(sb);
 	if (trigger_type == EXT4_JTR_NONE || !ext4_has_metadata_csum(sb))
 		return 0;
 	BUG_ON(trigger_type >= EXT4_JOURNAL_TRIGGER_COUNT);
-- 
2.39.2

