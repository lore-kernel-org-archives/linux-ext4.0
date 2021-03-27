Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F46C433DB
	for <linux-ext4@archiver.kernel.org>; Sat, 27 Mar 2021 10:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17C3619FC
	for <linux-ext4@archiver.kernel.org>; Sat, 27 Mar 2021 10:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhC0KdL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 27 Mar 2021 06:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhC0KdL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2021 06:33:11 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F242FC0613B1;
        Sat, 27 Mar 2021 03:33:10 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id y2so6009877qtw.13;
        Sat, 27 Mar 2021 03:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8050P/+NMRsStepvjm7LOtGR7Xxv9ZU7XHSFS13QaVs=;
        b=iwqWeSAkmd/6wG5GmUqvXdjyCS7evR5E0n8KfwyErUro3TZ78UTsY4nHwuaWAW1W7k
         CsdtBMbh5rv5P9iW7Wfm7AeSJNQwphxazy2mwtfupNO104y2bOMsk9Z/FFqTVVugQ+8Y
         RgmAKHdwTcKYuKwJmy87e65CGFLdiGKVck2YFiz6G78HIHu9bd32/im2ESnfITQTDXcs
         2iAn04ivDy2O+83C9UE+WI/6aM/wQL5I67nOmLCG21YnT/MplbhApemlV9asmiWQ+8xD
         +pEWlBxhHAFqRHITFTb7rC0bbare0ixzGy/vowMYML2Cz/5l8joT1lCtpMhWUCHiqJWg
         +FbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8050P/+NMRsStepvjm7LOtGR7Xxv9ZU7XHSFS13QaVs=;
        b=pBFleOyQmhTacsWIwuwz+U6CRwFbrt28aR5y72RUATNdc05Tf9SO+1A+rg14saY2AP
         kHedTU4kK/NN+wDi04xWiMTXtV2cXpiEsg0rrJUXa2rGrss3pKpz4766MUxj/iJxo2Y7
         s3daXzQ2VP1CiqiEe+N4owKDwUbnLnxwN/RhN44B/uBpdVeyhBqe7zNrQrjFk+CC4WKk
         jGdKC65j7+xR5TMKQmjIl/BMASXbCZLFgRExNuP52zTqyzVRCc2x8gVwzRvpn9zZW/uq
         EedPkNP7UO7eTLHe4BkGdia7r0N9v6uZad5u/UFOgSxhA4WQ/nCCGY4TOzW4ghTMmjLp
         ky8Q==
X-Gm-Message-State: AOAM5330P+yCxhKpYU5kRH5De3I/+lvYbz5wLFkfNyu4ov9Dkt7cOAQ/
        Hb2ics82YodxRnI3RiGWhIQ=
X-Google-Smtp-Source: ABdhPJw8ACT1kPEyPdkwhhTI4efKINQu4Qnc//ttbfE0BhSw5PgrVu8354RzZ+j+E84xILVa10RFJg==
X-Received: by 2002:ac8:7768:: with SMTP id h8mr15523667qtu.185.1616841190315;
        Sat, 27 Mar 2021 03:33:10 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.35])
        by smtp.gmail.com with ESMTPSA id a14sm7292364qtw.80.2021.03.27.03.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 03:33:09 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        linux-ext4@vger.kernel.org, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] EXT4: fast_commit.c: A mere typo fix
Date:   Sat, 27 Mar 2021 16:00:11 +0530
Message-Id: <c5f9131c6234524a2779ef91623d618e720579eb.1616840203.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616840203.git.unixbhaskar@gmail.com>
References: <cover.1616840203.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

s/ineligiblity/ineligibility/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 fs/ext4/fast_commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 7541d0b5d706..8691634044e3 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -66,7 +66,7 @@
  * Fast Commit Ineligibility
  * -------------------------
  * Not all operations are supported by fast commits today (e.g extended
- * attributes). Fast commit ineligiblity is marked by calling one of the
+ * attributes). Fast commit ineligibility is marked by calling one of the
  * two following functions:
  *
  * - ext4_fc_mark_ineligible(): This makes next fast commit operation to fall
--
2.26.2

