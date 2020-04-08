Return-Path: <SRS0=dDCy=5Y=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA50C2BA2B
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Apr 2020 10:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7013E20747
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Apr 2020 10:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZsMFfDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgDHKrG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Apr 2020 06:47:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32920 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgDHKrG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2020 06:47:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so2889072pfc.0
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2020 03:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zpCt75xNZByviQmE+AnXigExECBgdAVpN3uQUy9EVLo=;
        b=qZsMFfDj2a1Ldqjx8753NxhY/8S4RrXPGqxxGki/0G3zR00CPd+6knVXel4fIriJFy
         v07NrJtgX06kEx4Zm3hB6bezzAOhDBexDv7CpoxY4hoKGZ+Y0TNmPozar1RZcsTKJuOE
         +4a0IZg8l3XWjLcCYqhGj/ZN7j5fZLXUz17jLHQFfWod46c1OiIaqGjfzw8E/QKPcADf
         Nn25Rz8FON+88iu9YKdcYsF4uLgqqT8PIT6REeRX6ABewtn5/l4otHH/Jp/gWlnQBbLT
         DPx93b9+7Lt0Lsa4O4ZzMtl6CBLopwg7VvUC17HPrp3D3S1dWuGY14VGlP4zaRDRVhSy
         ze9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zpCt75xNZByviQmE+AnXigExECBgdAVpN3uQUy9EVLo=;
        b=QJtMmOyKScSqoZA9E4aubU0d80HgA2Lp5T5S4L1JHAVznkBZPc09IGQ51Gjfiy/xP7
         DTbMaIGr2Abad/M6fQBzPJN4RmGRLuswSNGv/e0kW3DzDv+iMe7zp6xSgpo38qDpW21C
         TW9lcDz4TgkxNOoquQsjEhcyUbNuejcCu5vmfo4VF8tjXFIn0kJMBVs4YOAaZi2VvA+x
         dN+z8t3CH8kI4FEIU4ykKCX1gjivFBv8IfAN4uB0n6cHHK2KZYaZ1pJE4h4vnzJDhFCA
         /zgWu7g9h4rerLI6LhC2GjPZCjMfNbSVq7fGRkIlOZDd2xQDzroLSr01K7c+r6Q01Per
         oj7Q==
X-Gm-Message-State: AGi0PuaHzSGU2yiVtq2mo0/J1anCF7Hl2i27C5h6IBAoXxjPPL8gFaKQ
        gur4Iu64++9cbKBkHGkEJTNE+XWvEvc=
X-Google-Smtp-Source: APiQypIv/zHxO0qEX3SyHzS9jJAvaPYv8+RPN40RiNZiJzGT5cjeisyVttJCmOnR8OmfrTWEl34qPA==
X-Received: by 2002:a63:b214:: with SMTP id x20mr6386559pge.43.1586342824865;
        Wed, 08 Apr 2020 03:47:04 -0700 (PDT)
Received: from localhost.localdomain (ftp.datadirectnet.jp. [182.171.80.51])
        by smtp.gmail.com with ESMTPSA id y17sm16177024pfl.104.2020.04.08.03.47.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 03:47:04 -0700 (PDT)
From:   Wang Shilong <wangshilong1991@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     lixi@ddn.com, adilger@dilger.ca, sihara@ddn.com,
        Wang Shilong <wshilong@ddn.com>
Subject: [RFC PATCH 43/46] e2fsck: merge options after threads finish
Date:   Wed,  8 Apr 2020 19:45:11 +0900
Message-Id: <1586342714-12536-44-git-send-email-wangshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1586342714-12536-1-git-send-email-wangshilong1991@gmail.com>
References: <1586342714-12536-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

It will be possible that threads might append E2F_OPT_YES,
so we need merge options to global, test f_yesall cover this.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 e2fsck/pass1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3c3d9251..19475815 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3005,6 +3005,8 @@ static errcode_t e2fsck_pass1_merge_context(e2fsck_t global_ctx,
 	global_ctx->fs_fragmented_dir += thread_ctx->fs_fragmented_dir;
 	global_ctx->large_files += thread_ctx->large_files;
 	global_ctx->flags |= thread_ctx->flags;
+	/* threads might enable E2F_OPT_YES */
+	global_ctx->options |= thread_ctx->options;
 
 	e2fsck_pass1_merge_dir_info(global_ctx, thread_ctx);
 	e2fsck_pass1_merge_dx_dir(global_ctx, thread_ctx);
-- 
2.25.2

