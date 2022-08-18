Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DBDC00140
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Aug 2022 21:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346998AbiHRVkz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Aug 2022 17:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346078AbiHRVkx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Aug 2022 17:40:53 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42682BD28E
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2022 14:40:53 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id w7-20020a5d9607000000b0067c6030dfb8so1595208iol.10
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2022 14:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=ggYZcW/jiHht2+YSvHf2xzH9Vi0hSCfs2RkxdmXJjMU=;
        b=nejJkqLn39bRDQq7wbN19Ph5a2ZdHTa4Sd2es/UeWHwznTnN+IgKm9+hJKcYJK/zsi
         axeEP4d4aVZMHLgZ4TFSrj7qsbSrsiflvI3BmQW1l4+zR08ZElug1lMTRzZoukpt+aZv
         i8NvIdeiRCGOKsEMqlknSUrlH0z+hNn/FfK8WxNE6PKCKd/63862nyp7MlZHD88Bpqqh
         Sw4YQ1L1kfJBczrSy60QlE6wfbHa08MTkkQCQJXbHsogjeBoBf72TGi4aG8BfRzWNrdi
         FPRJrpfuJSLjkxldNomRCjr2nudoKJLyjQFU9/7/PXoI4xqdpvNQtJXhOHuFXu25H/Kr
         peBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=ggYZcW/jiHht2+YSvHf2xzH9Vi0hSCfs2RkxdmXJjMU=;
        b=XDc9qUV3uQ7/vVOoYgMYBIJ5eJA1fcFxKHEyaRaWa6gMsC3zQs3v6T70CnHSGLjuBI
         4ivn1cLPikPUm4iN1HP12qZB7Q50W/4o8ag/SnfOrw7h7w8PpS9qvFyfJ3d9OeISlvlK
         nyAtIJ8FkRi1T1/sLRMd7kYWPW9fNYWh7nAvvTWC3JSwEzmOYuNOsjNEwRIVZsxrVRTR
         d4glBIWehVfy83jz1+zpEIYELHBj/0GWwph0bf64fEMf6ohdwGoWkzA0FEOfBJZvyNiB
         lPscrFI2Thy6wEaySMgsqw8xXe1CS1q5H0vAdw0Uhf+mlRAoE1U+w2Sdhq26r8SJlCoc
         3Iuw==
X-Gm-Message-State: ACgBeo3MOLSTWtrnDn68Y3hron+8EZF1Upv92NIGYM3hXg3Gk4IEdk4x
        fVUPX+TRwE48eB9S9DUZ6RVf4ujtbNO+7RM/
X-Google-Smtp-Source: AA6agR76jW71LoHot4oYwaCwArah91ZBIVUMk461/DWSHQ4gWA7HioWs5nxJIJHYT6GietUGrPQKS405pFDnBIXR
X-Received: from lalithkraj-spec-glinux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:b94])
 (user=lalithkraj job=sendgmr) by 2002:a05:6e02:661:b0:2e2:be22:67f0 with SMTP
 id l1-20020a056e02066100b002e2be2267f0mr2327973ilt.91.1660858852679; Thu, 18
 Aug 2022 14:40:52 -0700 (PDT)
Date:   Thu, 18 Aug 2022 21:40:49 +0000
Message-Id: <20220818214049.1519544-1-lalithkraj@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] ext4: Make ext4_lazyinit_thread freezable.
From:   Lalith Rajendran <lalithkraj@google.com>
To:     tytso@mit.edu, dilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lalith Rajendran <lalithkraj@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

ext4_lazyinit_thread is not set freezable. Hence when the thread calls
try_to_freeze it doesn't freeze during suspend and continues to send
requests to the storage during suspend, resulting in suspend failures.

Signed-off-by: Lalith Rajendran <lalithkraj@google.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9a66abcca1a85..d77e0904a1327 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3767,6 +3767,7 @@ static int ext4_lazyinit_thread(void *arg)
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {
-- 
2.31.0

