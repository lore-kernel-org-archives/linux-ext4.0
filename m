Return-Path: <SRS0=l5Yc=DW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3399DC433E7
	for <linux-ext4@archiver.kernel.org>; Thu, 15 Oct 2020 20:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8A6206C1
	for <linux-ext4@archiver.kernel.org>; Thu, 15 Oct 2020 20:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWAgx0cv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbgJOUi0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 15 Oct 2020 16:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388441AbgJOUiU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2020 16:38:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED30DC061755
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2020 13:38:19 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y1so8886plp.6
        for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2020 13:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FJmpv1Chs+4ez0taUQRpf+yDAbThAuGyGWqraQ/2D+8=;
        b=PWAgx0cvqROIOAWFgn4P3uelyVDZYDqKNfF3UJGP8AiXomdXXC1LyBEPzd78F/vqCj
         IbhqJdo3FOXecQOQL93HHsHDtQ8weIfgOfJpOmd/dF1//Rp+Ek/WrfZKSIdW35adiO71
         TmUDvwRkuS5s9XpZlPfP69ydXDNZAFfm+EuqfelAITzKQjMTTnAQKHQiouEBfGvRZ0YR
         jqOBIg3g4V92tF1uNjR/LqYr1t0Ip//79CF/Fj1QWFWXrpgvoytP8WnjF8jV+aa5ZoF1
         JL5zgHcjYpn8qNVQtRqfi2i5cHol5VZWnby4wuXObh4Y2RgGNd0hx5FNe8sxdSSfD05a
         bEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FJmpv1Chs+4ez0taUQRpf+yDAbThAuGyGWqraQ/2D+8=;
        b=HC3LkkzLj6+AyGXul9UTqnfODJ1Y7h5+SWuw4pk/0f+t5uaCOpbT/sSzb2QQmzxa2W
         IcTb+gR645DqEhi8m+WiVybfBjzTH5CYtPkzGd0nVGEmW3EaW6+fuhco4vxkAkAIQRgK
         WGyE1t9pSJMdNgBwORWM+MTT+fZ7nsxGUBrync5YiPollkL2TD6yDnjtqf+os7z7byED
         cXPXWlw0iUpQtShb6gqAwkYYB0TlffZ5HZtmshjh4P+dj9vW6iYRzefjqC62wmYu+peb
         BqCpZSFqS0yw/l1BuCjx+XxECW7HHICOwG5/z9S8WAouxdwQIAJ3fqHnPgaO+Licy6el
         etqQ==
X-Gm-Message-State: AOAM532QFIilIkDNZCWgDl7g2qZhItTNZLEq17ebj1HZIqv4r4sZj4hR
        E/L40GJoXMsTkL92icJ2GS1JhRIq5kg=
X-Google-Smtp-Source: ABdhPJyiKFiy0P5uZFbihMITc37lX0I/k6Md0/gaVAg5kR9ynGXlhkxorExf4EuFP0CWXX4zADQGzg==
X-Received: by 2002:a17:902:dc86:b029:d3:d3cb:7748 with SMTP id n6-20020a170902dc86b02900d3d3cb7748mr544509pld.22.1602794299125;
        Thu, 15 Oct 2020 13:38:19 -0700 (PDT)
Received: from harshads-520.kir.corp.google.com ([2620:15c:17:10:a6ae:11ff:fe11:86a2])
        by smtp.googlemail.com with ESMTPSA id j8sm136860pfr.121.2020.10.15.13.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 13:38:18 -0700 (PDT)
From:   Harshad Shirwadkar <harshadshirwadkar@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [PATCH v10 8/9] ext4: add a mount opt to forcefully turn fast commits on
Date:   Thu, 15 Oct 2020 13:38:00 -0700
Message-Id: <20201015203802.3597742-9-harshadshirwadkar@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201015203802.3597742-1-harshadshirwadkar@gmail.com>
References: <20201015203802.3597742-1-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is a debug only mount option that forcefully turns fast commits
on at mount time.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
---
 fs/ext4/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ced05c6879a6..114753e66391 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1719,8 +1719,9 @@ enum {
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
 	Opt_prefetch_block_bitmaps, Opt_no_fc,
 #ifdef CONFIG_EXT4_DEBUG
-	Opt_fc_debug_max_replay
+	Opt_fc_debug_max_replay,
 #endif
+	Opt_fc_debug_force
 };
 
 static const match_table_t tokens = {
@@ -1808,6 +1809,7 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_no_fc, "no_fc"},
+	{Opt_fc_debug_force, "fc_debug_force"},
 #ifdef CONFIG_EXT4_DEBUG
 	{Opt_fc_debug_max_replay, "fc_debug_max_replay=%u"},
 #endif
@@ -2040,6 +2042,8 @@ static const struct mount_opts {
 	 MOPT_SET},
 	{Opt_no_fc, EXT4_MOUNT2_JOURNAL_FAST_COMMIT,
 	 MOPT_CLEAR | MOPT_2 | MOPT_EXT4_ONLY},
+	{Opt_fc_debug_force, EXT4_MOUNT2_JOURNAL_FAST_COMMIT,
+	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
 #ifdef CONFIG_EXT4_DEBUG
 	{Opt_fc_debug_max_replay, 0, MOPT_GTE0},
 #endif
-- 
2.29.0.rc1.297.gfa9743e501-goog

