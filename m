Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B248C64ED6
	for <linux-ext4@archiver.kernel.org>; Wed,  1 Mar 2023 13:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCANiv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 1 Mar 2023 08:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCANit (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Mar 2023 08:38:49 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4E330DF
        for <linux-ext4@vger.kernel.org>; Wed,  1 Mar 2023 05:38:48 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id f18so17671817lfa.3
        for <linux-ext4@vger.kernel.org>; Wed, 01 Mar 2023 05:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677677927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kRrllEfWVEeyaU4zdyImV9+lagJXaUro6x0JCaZf/Ak=;
        b=KlB6YUocmuNUN5HfZXLPemTEXaBiHl4fpRbjOQ+UoXLyiqf0TINeegxAJYZh5eAnWN
         RztrAtkyXZSkeLV3xqviUIArRHEXTefmI71ZzFBxZtfJ9Cn19lVcrv/5LQ+YHC7kuLeQ
         4OL2yrE27GqPMhZOBtlstzFuwGNYdBbyYPQSGgBfBmR7eL4ceo2qDwMIN/7F/5CTlPL4
         3G/Y4xVyRTsi2Sl9Rihoy7lYcyaRamcx23dvgBXYdFwCh0NiLsXclQhN/GXkrO9uqZXD
         NRIdjMs9YFHBSZVWg2N2VE5InRsKu5fhk8SmT1G2mRFjBKEpz5+OQzMk9x02lLSR9U7C
         GIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677677927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kRrllEfWVEeyaU4zdyImV9+lagJXaUro6x0JCaZf/Ak=;
        b=prAch9Qpv4Y8IYLGVgWV4vC0vdatHll4wydWn8aHD57FrMBmPrgJgbHQg+KovaS6qz
         FERsD6/ovj6YAww9YeB1MdQHREMbgqLzz8PGaOaDI6jEf6h3CQsGb/y3At6SxUw0uujU
         ewQWVQCRpVFxK08+Dxq2BhZlpsJwWYJ4bcteQga0VxNVhMvdELkvNiB7a5vZNG1Jn7rx
         IIUJ//XP1esi8XsSBhE4xBTJiPZUiBMu1459x5CY6vj5UWtU72nbvLZWdBrZIHKEQesj
         R0vPM1QzEB2wDVSJFv8+H61bScdT0lLIbzmAqpJSqX8mY5LKZraTMj+asdludI99+kW8
         Z/nA==
X-Gm-Message-State: AO0yUKVDAEUjzJWBEZL914g9JqE7gFcCFlEYjzyzsj4KPaSa/9nHajZK
        Z9kT/GVkpHXHmTCCXp+tgFbdpLX73szZy7X0
X-Google-Smtp-Source: AK7set/dloH+T+Z0/wlD9SGr7KCTSO8QVsPXN4Ydhg2yw1d0WY791lWmvf06pJIPb73SJkfxmsK3jw==
X-Received: by 2002:ac2:5317:0:b0:4dd:af71:a5b7 with SMTP id c23-20020ac25317000000b004ddaf71a5b7mr1775400lfh.41.1677677926794;
        Wed, 01 Mar 2023 05:38:46 -0800 (PST)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id t13-20020a19ad0d000000b004b7033da2d7sm1742523lfc.128.2023.03.01.05.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 05:38:46 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     tytso@mit.edu
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH] ext4: Fix comment about the 64BIT feature
Date:   Wed,  1 Mar 2023 13:38:42 +0000
Message-Id: <20230301133842.671821-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

64BIT is part of the incompatible feature set, update the comment
accordingly.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 140e1eb300d1..85c153e120b9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1387,7 +1387,7 @@ struct ext4_super_block {
 	__le32	s_first_meta_bg;	/* First metablock block group */
 	__le32	s_mkfs_time;		/* When the filesystem was created */
 	__le32	s_jnl_blocks[17];	/* Backup of the journal inode */
-	/* 64bit support valid if EXT4_FEATURE_COMPAT_64BIT */
+	/* 64bit support valid if EXT4_FEATURE_INCOMPAT_64BIT */
 /*150*/	__le32	s_blocks_count_hi;	/* Blocks count */
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
-- 
2.39.2.722.g9855ee24e9-goog

