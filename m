Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6DDC10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 08:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9FF2183E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 08:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="eFVSDnoo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733205AbfDRIc0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:32:26 -0400
Received: from m50-135.163.com ([123.125.50.135]:59006 "EHLO m50-135.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfDRIc0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 04:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Z3FcbH42f4xw6Z9GUm
        qLeXJgANWBMj/tTbsd4TmaRzc=; b=eFVSDnooKzAg5mdVPIxQmx5wVoHsE+vOQL
        3Iw4QH0lE4SSp+X3Xd7Dd6sGsksNNUEZrmU52vkGRbWV+brHMY0+nXqQ37pVKspu
        VQA1Ux+jtYavRtKeYGlIft+5S3H8rSGxHRXCmwoVyyg3pwpk5qJRDQYn2x5EJeA6
        obHSJcLMA=
Received: from bp.localdomain (unknown [218.106.182.174])
        by smtp5 (Coremail) with SMTP id D9GowAD3nEXXNbhcfaHTAQ--.2956S3;
        Thu, 18 Apr 2019 16:31:21 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: ext4: avoid drop reference to iloc.bh twice
Date:   Thu, 18 Apr 2019 16:31:18 +0800
Message-Id: <1555576278-3917-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: D9GowAD3nEXXNbhcfaHTAQ--.2956S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw1fZrWUWrW7tw4Dtry8Grg_yoW3CFg_Wa
        17Ja1xZrZ3Gr1fCFyxXF4rtr4SyFy8Ar45uF4Sq3Z8Way5t3yUZw1qqFZrCrnrWr4ay345
        Cr1jq343GayrWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjZjjPUUUUU==
X-Originating-IP: [218.106.182.174]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBURqaclaD2Ivj0wAAsV
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The reference to iloc.bh has been dropped in ext4_mark_iloc_dirty.
However, the reference is dropped again if error occurs during
ext4_handle_dirty_metadata, which may result in use-after-free bugs.

Fixes: fb265c9cb49e("ext4: add ext4_sb_bread() to disambiguate ENOMEM
cases")

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/ext4/resize.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index e7ae26e..4d5c0fc 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -874,6 +874,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
 	if (unlikely(err)) {
 		ext4_std_error(sb, err);
+		iloc.bh = NULL;
 		goto errout;
 	}
 	brelse(dind);
-- 
2.7.4


