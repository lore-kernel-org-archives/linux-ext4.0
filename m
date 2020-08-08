Return-Path: <SRS0=/7A9=BS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB07C433E0
	for <linux-ext4@archiver.kernel.org>; Sat,  8 Aug 2020 15:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6853620747
	for <linux-ext4@archiver.kernel.org>; Sat,  8 Aug 2020 15:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="WppCPe6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHHPSk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 8 Aug 2020 11:18:40 -0400
Received: from m15112.mail.126.com ([220.181.15.112]:45296 "EHLO
        m15112.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgHHPSf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2020 11:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=WHXhFzIbKFdevwIdD+
        ipgUf5p6qP87QN0gbQI3/2iqo=; b=WppCPe6B9k1QK5HY1ceyHrHO1nR9zeVsAe
        VebFryE2Othe2r0zK+dVn0RcwfrlmRzDnepQ8RllrcD4+9umPS747sny5KU9yIAE
        VBMXsXtQosL4Qre+57G6u5QWbSLR9fLaScIeBfCRuh/FXkMo9o0mvgVKkmRGcUAI
        VpTyIOxKs=
Received: from 192.168.137.133 (unknown [112.10.84.202])
        by smtp2 (Coremail) with SMTP id DMmowABHzSGArC5fXMmZGA--.43065S3;
        Sat, 08 Aug 2020 21:45:38 +0800 (CST)
From:   Xianting Tian <xianting_tian@126.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] ext4: use kmemdup_nul() instead of kstrndup()
Date:   Sat,  8 Aug 2020 09:45:36 -0400
Message-Id: <1596894336-49052-1-git-send-email-xianting_tian@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DMmowABHzSGArC5fXMmZGA--.43065S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7JryrZFy5Kw4DWrW3WryfZwb_yoW3uFX_XF
        WxJF4DWryftr4IkF1Fkay5tFsYkrs2vr13Xan3Ary5Xw1qq3WYgw1DZry7XF98Wr43JFZ8
        u34kJrnFqrn2vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8G2NJUUUUU==
X-Originating-IP: [112.10.84.202]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbi3AJ6pFpD-WPjfAAAsY
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

kmemdup_nul() is more efficient than kmemdup_nul() if
the size is known exactly.

The description of kstrndup() already suggested:
Note: Use kmemdup_nul() instead if the size is known exactly.

Signed-off-by: Xianting Tian <xianting_tian@126.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 330957e..be37556 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4016,7 +4016,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (sbi->s_es->s_mount_opts[0]) {
-		char *s_mount_opts = kstrndup(sbi->s_es->s_mount_opts,
+		char *s_mount_opts = kmemdup_nul(sbi->s_es->s_mount_opts,
 					      sizeof(sbi->s_es->s_mount_opts),
 					      GFP_KERNEL);
 		if (!s_mount_opts)
-- 
1.8.3.1

