Return-Path: <SRS0=naN3=57=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AD5C2BA19
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 20:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A041E20774
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Apr 2020 20:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEi9Qi+p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636962AbgDOUcY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Apr 2020 16:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636951AbgDOUcK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Apr 2020 16:32:10 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F875C061A41
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2020 13:32:09 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id x66so18927794qkd.9
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2020 13:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JVhvXIyE1otDTmSwMpwKKzsR3aGec5RSI64yCk2ZXU4=;
        b=oEi9Qi+p9qlyLi/abaSgvZz0r2f/aj6DAwnsUA0PhXivQ6sDcSQqAoglrFsfowQbvR
         SQd4PoSJ8Vp+850LN6XsEu/3keM+v0lOFxcx9a2TSV5w4XSmjyEwPLxcy509cDRwN3p+
         c2CWgbpwotM1F/fH8OhRoSfKhfOtwttS8spF4W/68Jpi/utRj1P1WZu9z1hciwVCWsKg
         o7iEYBx5Sd4I70ZwWWo3CM+tphbs3LevE57z7PUGupbOH3bxpCsoN2ivWh+I4wMWfGpb
         FHA5AibZTO0UapPZYBQxKHwQrMHZO98dub2TY3nQWNnbycJfL6gXzNFx9LM34eCs58D+
         nFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JVhvXIyE1otDTmSwMpwKKzsR3aGec5RSI64yCk2ZXU4=;
        b=kGEjDG9Y3foiMwJGfyUK97Nr5t2V9/29I1ThK6dzbewrsKcG2WeoBDRrUbg82kBvpB
         7TpfHMSFudlNEakCwRfbfu0sIsZGhUGJAoCpq7vQS4jY24oxpcjp0coFWc6snnKtV90s
         k9ygXf3fVab1LyCS8IX+3sMnxczy/xNSOOwp58ToOv+ZqRj0zumASqElRknA4k417bLE
         ivUsbSBWhTHnQ3dhmZxWtJBUZ1jtyEsGkxFMNuqcw8a/ETIFZrfzb3swFRLomUhy8Ugl
         5IS0b0gNztwd2ueCmYikCCqhyeJkP5jsrQkKKJVtcji7KCFItBFHZ3UULtaoDYXGLGSG
         iJGw==
X-Gm-Message-State: AGi0PuaWc1W0Av4zDZvMF8AUYq0JB8cMgVSI0XcmfsoLellrzplgmllS
        0MRofphXJP7bPx3YjrgvsjE9CaQL
X-Google-Smtp-Source: APiQypKHwpsQnhA7wKuqnevKQGN9uNwNtgfB78l/LVkahjCjvNqHVfnzLmhgVhU5LmX8ez7+Qabjag==
X-Received: by 2002:a37:8d86:: with SMTP id p128mr28859282qkd.250.1586982728675;
        Wed, 15 Apr 2020 13:32:08 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id x8sm13198305qti.51.2020.04.15.13.32.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 13:32:08 -0700 (PDT)
From:   Eric Whitney <enwlinux@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 2/2] ext4: translate a few more map flags to strings in tracepoints
Date:   Wed, 15 Apr 2020 16:31:40 -0400
Message-Id: <20200415203140.30349-3-enwlinux@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200415203140.30349-1-enwlinux@gmail.com>
References: <20200415203140.30349-1-enwlinux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

As new ext4_map_blocks() flags have been added, not all have gotten flag
bit to string translations to make tracepoint output more readable.
Fix that, and go one step further by adding a translation for the
EXT4_EX_NOCACHE flag as well.  The EXT4_EX_FORCE_CACHE flag can never
be set in a tracepoint in the current code, so there's no need to
bother with a translation for it right now.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 include/trace/events/ext4.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 40ff8a2fc763..280475c1cecc 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -45,7 +45,10 @@ struct partial_cluster;
 	{ EXT4_GET_BLOCKS_CONVERT,		"CONVERT" },		\
 	{ EXT4_GET_BLOCKS_METADATA_NOFAIL,	"METADATA_NOFAIL" },	\
 	{ EXT4_GET_BLOCKS_NO_NORMALIZE,		"NO_NORMALIZE" },	\
-	{ EXT4_GET_BLOCKS_ZERO,			"ZERO" })
+	{ EXT4_GET_BLOCKS_CONVERT_UNWRITTEN,	"CONVERT_UNWRITTEN" },  \
+	{ EXT4_GET_BLOCKS_ZERO,			"ZERO" },		\
+	{ EXT4_GET_BLOCKS_IO_SUBMIT,		"IO_SUBMIT" },		\
+	{ EXT4_EX_NOCACHE,			"EX_NOCACHE" })
 
 /*
  * __print_flags() requires that all enum values be wrapped in the
-- 
2.11.0

