Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24495C282DA
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 03:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6BAC2075B
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 03:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fnvln70V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfDPDAY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 23:00:24 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:51011 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfDPDAX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Apr 2019 23:00:23 -0400
Received: by mail-yw1-f73.google.com with SMTP id j66so14500634ywa.17
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2019 20:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iuIeQUAMTWIOwz/+wMTVC2rJ1Jb9H2uzMsmhSpHr4CI=;
        b=fnvln70VUPw8oAUv8pSlp933t24EC4v+L98kvjdUpdJV4unSaz0qaOTJ4kDANowngl
         NtuNYmQdXEUi3aUzo8wfkTBm9Rrpk90shG1sf+UrhAN6KqHBmwdNI7Z6/j9GpEoVWfzO
         jDWNm0mGYxWzZIb+tLycnSLI2ii0+IfKuKfQW+JKVXoc7L+SW3yybK6t5eu+loHtcS7W
         3OOE3krCnH+4rh0WORSthgLMvG9YtQakpQmGRlGVtUKvmw/P7uMY23GVkIuGwjA6yZYI
         pASm7Re41+k8ZTIqhR+fufOMSNYjSKowxRrqHebAZWwt98Kasc1teI2Xf/5UwSkeIFPP
         0mGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iuIeQUAMTWIOwz/+wMTVC2rJ1Jb9H2uzMsmhSpHr4CI=;
        b=PWlq2FHNQs01SC0kJVNeYkYGhYx8O1KG9xTXB1Z2ERennplvDiqhbmuqqSq0U8pxY0
         KLuGnVEsde2ljlDMnVSxjf5Uf92fuXziCH7PRqTkpAZNlMNczfa/pVtNPl07eOS3iZXz
         AHjU9N5fJRZIbopq5vSx/XxpeJSlZnNn6ZP9lNQXlpPprl31/qCPETPNB8x0pQvjW78/
         cTgwwAngnH1MlHC8dRlzRxQvYfcpz5F0OdB9N/1Fn/bIw2TxdIq2HJhfNBYLCyrRmebh
         nYNtid3uy3iH2XM7iDvcsLfGviWij2FhQYVrC4IIfzYzsfcjpqtDTdHZ9jbrY9RXHun7
         stDw==
X-Gm-Message-State: APjAAAVjZHdGcZVaV2O1Aest0TR10byWfRoDzkKsCp3lAjYZQr/+4z6d
        /irIgKi5OUZGWt07oKiUzp47uQhlkLU=
X-Google-Smtp-Source: APXvYqxJ0n4CrJ+xX1bgAW5Q+EiNwMnYERC+ma2ULiuIf80Csy4LG8zlbeeW+APAZewrxoWS1g66vv4I9kA=
X-Received: by 2002:a25:202:: with SMTP id 2mr14734788ybc.66.1555383622714;
 Mon, 15 Apr 2019 20:00:22 -0700 (PDT)
Date:   Mon, 15 Apr 2019 19:59:34 -0700
Message-Id: <20190416025934.115252-1-khazhy@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
Subject: [PATCH] ext4: add cond_resched() to ext4_mb_init_backend()
From:   Khazhismel Kumykov <khazhy@google.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khazhismel Kumykov <khazhy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

on non-preempt kernels for filesystems with large number of groups we
may take a long time (>50 ticks) initializing all the groups.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 fs/ext4/mballoc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8ef5f12bbee2..c89f497ccf50 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2490,6 +2490,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
+		cond_resched();
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
 			ext4_msg(sb, KERN_ERR, "can't read descriptor %u", i);
-- 
2.21.0.392.gf8f6787159e-goog

