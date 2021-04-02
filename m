Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3379C433ED
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Apr 2021 10:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971E9610D1
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Apr 2021 10:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhDBKQr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Apr 2021 06:16:47 -0400
Received: from mail-m17639.qiye.163.com ([59.111.176.39]:27958 "EHLO
        mail-m17639.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBKQp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Apr 2021 06:16:45 -0400
Received: from SZ-11126892.vivo.xyz (unknown [58.251.74.232])
        by mail-m17639.qiye.163.com (Hmail) with ESMTPA id 4AB53380187;
        Fri,  2 Apr 2021 18:16:41 +0800 (CST)
From:   Fengnan Chang <changfengnan@vivo.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc:     Fengnan Chang <changfengnan@vivo.com>
Subject: [PATCH v2] ext4: fix error code in ext4_commit_super
Date:   Fri,  2 Apr 2021 18:16:31 +0800
Message-Id: <20210402101631.561-1-changfengnan@vivo.com>
X-Mailer: git-send-email 2.29.2.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZH08eHRgeSUlIQkIYVkpNSkxITkNNS0pNT09VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhA6ESo6Aj8XOCkMAjYcAg83
        MRQaFDBVSlVKTUpMSE5DTUtKQ0xLVTMWGhIXVRgTGhUcHR4VHBUaFTsNEg0UVRgUFkVZV1kSC1lB
        WU5DVUlOSlVMT1VJSElZV1kIAVlBSk5DTDcG
X-HM-Tid: 0a789215bce7d994kuws4ab53380187
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We should set the error code when ext4_commit_super check argument failed.
Found in code review.
Fixes: c4be0c1dc4cdc ("filesystem freeze: add error handling of write_super_lockfs/unlockfs").

Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
---
 fs/ext4/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 03373471131c..1130599c87dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5500,8 +5500,10 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
 	int error = 0;

-	if (!sbh || block_device_ejected(sb))
-		return error;
+	if (!sbh)
+		return -EINVAL;
+	if (block_device_ejected(sb))
+		return -ENODEV;

 	/*
 	 * If the file system is mounted read-only, don't update the
--
2.29.0

