Return-Path: <SRS0=XcEL=A2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1E9C433EA
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jul 2020 03:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E672E2072D
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Jul 2020 03:00:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rhsc93T5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgGODAs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Jul 2020 23:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgGODAs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2020 23:00:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6E1C061755;
        Tue, 14 Jul 2020 20:00:48 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a24so1140438pfc.10;
        Tue, 14 Jul 2020 20:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=1Lox4NjQutxxCAyIeog/I4IOb78DAZQiAZT6VbqqOWw=;
        b=rhsc93T5Y9kvp5CauuOOjj3+KAzVWQFlqvr+llfbQjpyywTVWKnHGGCx8XP0QSgaX3
         GjWr/gtMOkWa2LBLTO83uCM+uOse0ZGxwkXU1Ouipm0dUkHDarbIPjO2aajDMwmBdHuF
         w/sCjTZ9J0dDHAH0FyP1PTU8HC3MFKRrR6NuLeKp+GRvGNN6CRQyuzekGk1/3vLfDs1S
         NcAKgEjanRymaibf76sbJFUZRChbVkbOAtkf39W7a0U1Xv2+fLSOfI1e67KKy5blUhFh
         xYLHhRP0Xk31taV838lQ/WOkl/Ud+pBDr9cT4pceUjFnoPf5tq6UH9biOYiu+OyGl7Zy
         gEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=1Lox4NjQutxxCAyIeog/I4IOb78DAZQiAZT6VbqqOWw=;
        b=PHwo7la0oYIXZOCFfyD4GtYPtNw3q0SYQWiOY0W77KoAyGNr+O2yBGRjhvy6H6era9
         7MRIQfqu5lCXfEPNTTxkx7ZcsrZ++tY5s+ya4lnGE6rKMMX5GZj39vQ1TynSmNXlbKdu
         OCp0/SF8iXFGSSEPENbAqXdSmNw/ke3WmXvYhwqDfXZPbVCi7kC+b7NlA2RaNQ1rusjO
         FoaTBn5YIwB9XMJDnxFLBiApanQok84UTdEovnB3unaaU4QiRx4cp6Q4UG0j2yUgk//T
         Z6tCBGEwFA96CKYWOo2F+vVE/iF2CKLN4OZfxwM1Sml6w+ReEjE+EAols+J7v1GLxMKT
         CH2g==
X-Gm-Message-State: AOAM531yMxV5McUeYGc3ehAMSflb/kt+9b3UO86oAS1zePrCg/F2U2eS
        1lTPcdSv2afBg62eGt3sBMuEk72m8uo=
X-Google-Smtp-Source: ABdhPJwkHJJjR0MotnebLX23BOguIhErOSFz9vxM99gk7lnMHqOVbCr/6+AAWbG7UM8NHUizuOcK9g==
X-Received: by 2002:a63:4e51:: with SMTP id o17mr6299774pgl.315.1594782046935;
        Tue, 14 Jul 2020 20:00:46 -0700 (PDT)
Received: from [127.0.0.1] ([203.205.141.43])
        by smtp.gmail.com with ESMTPSA id g6sm445356pfr.129.2020.07.14.20.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 20:00:46 -0700 (PDT)
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
From:   brookxu <brookxu.cn@gmail.com>
Subject: ext4: fix spelling typos in ext4_mb_initialize_context
Message-ID: <883b523c-58ec-7f38-0bb8-cd2ea4393684@gmail.com>
Date:   Wed, 15 Jul 2020 11:00:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Fix spelling typos in ext4_mb_initialize_context.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c0a331e..6dc2c6c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4399,7 +4399,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
     ac->ac_g_ex = ac->ac_o_ex;
     ac->ac_flags = ar->flags;
 
-    /* we have to define context: we'll we work with a file or
+    /* we have to define context: we'll work with a file or
      * locality group. this is a policy, actually */
     ext4_mb_group_or_file(ac);
 
-- 
1.8.3.1

