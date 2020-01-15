Return-Path: <SRS0=L4/Z=3E=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CC7C33CB1
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jan 2020 09:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2B6F207FF
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jan 2020 09:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgAOJwC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Jan 2020 04:52:02 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:46471 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729504AbgAOJwB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Jan 2020 04:52:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TnnrDC4_1579081908;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TnnrDC4_1579081908)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Jan 2020 17:51:48 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/ext4: remove MPAGE_DA_EXTENT_TAIL
Date:   Wed, 15 Jan 2020 17:51:28 +0800
Message-Id: <1579081888-6244-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

After commit 4e7ea81db534 ("ext4: restructure writeback path"), this
macro isn't used anymore. so better to remove it.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "Theodore Ts'o" <tytso@mit.edu> 
Cc: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca> 
Cc: linux-ext4@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 fs/ext4/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 629a25d999f0..bb2d8c9205b7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -48,8 +48,6 @@
 
 #include <trace/events/ext4.h>
 
-#define MPAGE_DA_EXTENT_TAIL 0x01
-
 static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 			      struct ext4_inode_info *ei)
 {
-- 
1.8.3.1

