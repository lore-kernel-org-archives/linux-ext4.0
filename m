Return-Path: <SRS0=IjjL=DX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E41C433E7
	for <linux-ext4@archiver.kernel.org>; Fri, 16 Oct 2020 03:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A272074F
	for <linux-ext4@archiver.kernel.org>; Fri, 16 Oct 2020 03:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Unqo6Ht8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394320AbgJPD4F (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394317AbgJPD4E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2020 23:56:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04289C0613CF
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2020 20:56:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j8so676845pjy.5
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2020 20:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=acRwBv3y2+bW/N3+ev7tL2j1uYBkUN9rml//C4A4mhQ=;
        b=Unqo6Ht80vp0KBzkdXy80vjV17n/uSJ9ZJDGqzzHvHHDDRXwC5lEA1HTI9vvFwpjxP
         NhV2CdGxV0QA5un27PLhetbOijfAoGWos3BGTXyDVMHSoERkcha2dVP2cLpOriFGfO1l
         2jUZutQI84oHXVQWoLF5hv3Zr2GiB85oTs3l9nBO9vVHrGAN/eLAcFn7u0k4W2hZhNZq
         cZwe7sye9Ou6ln9XmNR3DsQwDZw3dKchBrJZ/9RqtnUpBW/uxXRJRelOB25v212ltxJS
         7boHhat59uipqPmV74qoHOzPNkf54zmSHWPDMEJhaOPQjxl6ftpoXIqw21Mks4Npf8A4
         1x+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=acRwBv3y2+bW/N3+ev7tL2j1uYBkUN9rml//C4A4mhQ=;
        b=eFndKp/b0u07xlWymzv4R61Ob9s2iNgI1XTmRGK7OsYfUWUTgPJgIZxOhELXdAJl1L
         JvhtUwNZrkAW5cOUjMK3oVHrzfw19uco5jTMiCBbPClF7zn+gIWP2mEfORgurL+SxIRu
         b0UU/7FXAwukfbOZ2GvilmMBtZjlrZsZHTU7MJbBz8T+D1ntIc+GFpaoh3wTW7dOUJT/
         9tcUpFXXhrBl96qE6t7cwpx3HZt18OtDaxvHL7eJKF8H01s+8SgCH1nSwwLb2OtLbA2S
         87S2ys+JJ/hu15br9oisDOH/6IRFjPhanG87dexNfl5zZYFuzwcoVpwUEUuQXQOupPwf
         dKFg==
X-Gm-Message-State: AOAM530/s0S3fLNInjz4SwEECwh0CEpVHw5S6BJMCxLdFmuVRRq0RZqM
        rotHKS8BdO/hFE+9Mx51o4w=
X-Google-Smtp-Source: ABdhPJyC9Z5ERMJwJbtxgs7VsUauVrW7N/Mg55IolNgvpTLkQQxEK8kkGEQOxSjfYZTqNgVfpA7y8w==
X-Received: by 2002:a17:90a:450d:: with SMTP id u13mr2005372pjg.148.1602820563605;
        Thu, 15 Oct 2020 20:56:03 -0700 (PDT)
Received: from VM-0-6-centos.localdomain ([119.28.90.140])
        by smtp.gmail.com with ESMTPSA id v12sm861555pgr.4.2020.10.15.20.56.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 20:56:03 -0700 (PDT)
From:   Chunguang Xu <brookxu.cn@gmail.com>
X-Google-Original-From: Chunguang Xu <brookxu@tencent.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH 3/8] ext4: use do_div() to calculate block offset
Date:   Fri, 16 Oct 2020 11:55:47 +0800
Message-Id: <1602820552-4082-3-git-send-email-brookxu@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602820552-4082-1-git-send-email-brookxu@tencent.com>
References: <1602820552-4082-1-git-send-email-brookxu@tencent.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Use do_div() to calculate the block offset and the offset
within the block, make the code more concise.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 fs/ext4/balloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index db7fa3e..4013676 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -265,7 +265,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 					     ext4_group_t block_group,
 					     struct buffer_head **bh)
 {
-	unsigned int group_desc;
+	unsigned int group_desc = block_group;
 	unsigned int offset;
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	struct ext4_group_desc *desc;
@@ -279,8 +279,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 		return NULL;
 	}
 
-	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
-	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
+	offset = do_div(group_desc, EXT4_DESC_PER_BLOCK(sb));
 	bh_p = sbi_array_rcu_deref(sbi, s_group_desc, group_desc);
 	/*
 	 * sbi_array_rcu_deref returns with rcu unlocked, this is ok since
-- 
1.8.3.1

