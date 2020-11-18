Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FACEC63798
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Nov 2020 15:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D536C24790
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Nov 2020 15:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DYfUx3kp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgKRPmO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Nov 2020 10:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbgKRPmK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Nov 2020 10:42:10 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F06CC061A4D
        for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2020 07:42:10 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h9so2932148ybj.10
        for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2020 07:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6IeNjD+JbZWYlVnUDIDclFUs22c3oVDKirYNwy4hr2M=;
        b=DYfUx3kpNmLUUozvKg+jllUuffkVzXz6e3G6nLUHL+uB/3tCfo23jtvrPgq2WUXzi4
         yRkSTCqZ6zrMkvlINLISX6ue6XgKz6gfzVf3ch0tBBC+fv+eOvJ7rArT1DOqtpH0g5U8
         bFsII9Lwa7ZUMGdF0CBTeNz9zPTtxPMQekyjuyewFH/D8f1hlxpQRd/IMuShSTXosrzA
         Kv1zUmyl1FtkY7t7+HfzWrqTwGv2OqipSy+6HrPx7I9XuTZQCFfJj1Gpe1gdDx2fs+2Z
         HB5BXHE/i7hqDkmpPdMtSNUu9+d4M4ag+36mSL35MoVJLxeW7/Og3Rhm78oW+Cm4oUO2
         nYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6IeNjD+JbZWYlVnUDIDclFUs22c3oVDKirYNwy4hr2M=;
        b=tmTZ36M4l7MEqWTsoG+ArqJ5fDaiTqjYa8DoO7C1lFDZjCW25VRK2BSpwlhNegUKa9
         qRHRuwHUSTm/jpjWDk9pye4lOkjOluKNLeIUZOptDzhhMhXk/68RqJ+0bHRu4JO1seab
         kusbgTDe+D7M2eWasY11PIx/k3z3KL3rRRoHaah8ZwaapDf/5ORHb9X+cW3dccgl5vES
         D9g7XLQuKnIHh8lQQyHLAQ4KS2WSR5A0MIk2vBHdWBM6iyap0AW5zTEwmKdOp8NcCMEJ
         u/RSV6mZbKnjXHbXxh49mqWmll41qCRGWgMKXMH/tYuvzcYHjW1OUnPnwai3z8rBxquK
         iZqQ==
X-Gm-Message-State: AOAM533B8vf8c+UPwjFttedcW/Cg0T0vwOnbMaGZGHKboK25nGWSvFB/
        sKoHjG/Sk5i28UoFUTwhnx63z6yR2a6tyjZXwGgXiciBOiKkwmrAHPk0KLxFwllfY6XlLjvoC6x
        CML9b7nw8gRJwtIMJ7k9F45wy22CHqj6xam0CpuOF1mRFo7SMvp8fh9IaEyPkfNLLj45rYryMWq
        ldlE04Ago=
X-Google-Smtp-Source: ABdhPJwaV+fw9msfxNnip3r/s7hmtYOcPB9NZ5AZr3kW28rV5jmlpr01GboLsvLOBK+wiRlUxE3fb4s0M6IAOSjFnAQ=
Sender: "saranyamohan via sendgmr" 
        <saranyamohan@saranyamohan.svl.corp.google.com>
X-Received: from saranyamohan.svl.corp.google.com ([100.116.76.178])
 (user=saranyamohan job=sendgmr) by 2002:a5b:b45:: with SMTP id
 b5mr7588636ybr.355.1605714129778; Wed, 18 Nov 2020 07:42:09 -0800 (PST)
Date:   Wed, 18 Nov 2020 07:39:41 -0800
In-Reply-To: <20201118153947.3394530-1-saranyamohan@google.com>
Message-Id: <20201118153947.3394530-56-saranyamohan@google.com>
Mime-Version: 1.0
References: <20201118153947.3394530-1-saranyamohan@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH v3 55/61] e2fsck: fix readahead for pass1 without pfsck
From:   Saranya Muruganandam <saranyamohan@google.com>
To:     linux-ext4@vger.kernel.org, tytso@mit.edu
Cc:     adilger.kernel@dilger.ca, Wang Shilong <wshilong@ddn.com>,
        Saranya Muruganandam <saranyamohan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

If admin try fsck without -m option, codes try old
behavior, thread information won't be inited either.
@et_group_end is 0 thus readahead for pass1 will be
totally disabled.

With the patch applied, we could get same performance
number without pfsck as before.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
Signed-off-by: Saranya Muruganandam <saranyamohan@google.com>
---
 e2fsck/pass1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3899d710..70826866 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1100,7 +1100,8 @@ static void pass1_readahead(e2fsck_t ctx, dgrp_t *group, ext2_ino_t *next_ino)
 	errcode_t err = EXT2_ET_INVALID_ARGUMENT;
 
 #ifdef CONFIG_PFSCK
-	grp_end = ctx->thread_info.et_group_end;
+	if (ctx->fs->fs_num_threads > 1)
+		grp_end = ctx->thread_info.et_group_end;
 #endif
 	if (ctx->readahead_kb == 0)
 		goto out;
-- 
2.29.2.299.gdc1121823c-goog

