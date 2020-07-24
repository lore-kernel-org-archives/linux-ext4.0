Return-Path: <SRS0=NbOM=BD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E5AC433E1
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Jul 2020 01:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A175320737
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Jul 2020 01:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgGXBs5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 Jul 2020 21:48:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8268 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbgGXBs5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 23 Jul 2020 21:48:57 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B9CFEE3FB2599799F25D;
        Fri, 24 Jul 2020 09:48:52 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Jul 2020
 09:48:47 +0800
From:   Shijie Luo <luoshijie1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>
Subject: [PATCH] ext4:remove some redundant function declarations
Date:   Thu, 23 Jul 2020 21:47:47 -0400
Message-ID: <20200724014747.15924-1-luoshijie1@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

ext4 update feature functions do not exist now, remove these useless
function declarations.

Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
---
 fs/ext4/ext4.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42f5060f3cdf..196b52c75422 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2924,12 +2924,6 @@ do {									\
 
 #endif
 
-extern int ext4_update_compat_feature(handle_t *handle, struct super_block *sb,
-					__u32 compat);
-extern int ext4_update_rocompat_feature(handle_t *handle,
-					struct super_block *sb,	__u32 rocompat);
-extern int ext4_update_incompat_feature(handle_t *handle,
-					struct super_block *sb,	__u32 incompat);
 extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
-- 
2.19.1

