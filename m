Return-Path: <SRS0=rNFB=6I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE64C54FD0
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Apr 2020 17:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986A8206D7
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Apr 2020 17:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H+1ctwBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgDXRQb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 Apr 2020 13:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgDXRQb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2020 13:16:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13836C09B047;
        Fri, 24 Apr 2020 10:16:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n24so3950320plp.13;
        Fri, 24 Apr 2020 10:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=XeCopMuBc3DJcGEdXSLf4g+3WGXZ443aKjmJX9lblR8=;
        b=H+1ctwBJRMai4A599+enc4H9TWeKZOhU5BLwMzAuZMrVk1omrtL0LmLoWGbMVVf+nZ
         H5WnAEUdch6QO6fVOhwBg/fh/pFX/63pr0e7PFFbzoKyHspAggEh/5VX/LMIdhVheMGj
         rSWS5zD3ZyrNcHbwh8tQzWL6qclcCiTmSX8uaV+CDBeKogWzHGkBFXlgjrFmQek+wdnH
         2voesFXxWkII5Vh6HAt0r9rsqhZanqYU0RQVgQiR+k08otT4xHi2PQ2/uNktYHGLZt05
         ri58vooXvvIKD0LH0acN09JfAeQN0FNmYw/kd7dPXoCdHDldidJiIqAQUol6VwaunYFF
         3rIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=XeCopMuBc3DJcGEdXSLf4g+3WGXZ443aKjmJX9lblR8=;
        b=f73O2yRaasiR+Lt1v4424HYNQl5k/ngvP+EaEi3yATxYwGk35vCfzKNiunXutaHfSY
         SGJphyKiAQasnlbppZpGqwzbQOUY3UaPNXVbSLYHS2UETrEqY/gckquF46RXVM+4rJ6D
         cNbzuTMpQf3ukYebShmTMAQLLRDxm/D9rw8/O9JehaIeB/j8CrlPhEidbTexg68mt4nG
         u7/IzlBgNJoAYC3NgoGtjWQ1PvFpg22sNqc6z2C5pPl5lT7KSQS4VRlHe3/rJet/X7lJ
         0qBqyYFl38sWD/A4RGmW/ZmpVlx8RG2MdkdN50GybNKOz0VbXXABhitcL0vnZRYClbgT
         VYVg==
X-Gm-Message-State: AGi0PuaWednyyDDHDLW/EYXRu9cEf+hviUXq/n6q36NUuW+xLkBhbnHn
        nYJyAv0btfZ4RpZYqN6RXKg=
X-Google-Smtp-Source: APiQypK05CXoPELmaPPcPsNMl6XoQTSS/JdihH6zlFvpVbn0UXesvRl3xWb0EK6WVVFTXEvjWrJVFA==
X-Received: by 2002:a17:90a:64cc:: with SMTP id i12mr7206907pjm.65.1587748590205;
        Fri, 24 Apr 2020 10:16:30 -0700 (PDT)
Received: from koo-Z370-HD3 ([143.248.230.14])
        by smtp.gmail.com with ESMTPSA id l30sm5453069pgu.29.2020.04.24.10.16.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Apr 2020 10:16:29 -0700 (PDT)
Date:   Sat, 25 Apr 2020 02:16:24 +0900
From:   kyoungho koo <rnrudgh@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: Fix comment typo "the the".
Message-ID: <20200424171620.GA11943@koo-Z370-HD3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I have found double typed comments "the the". So i modified it to
one "the"

Signed-off-by: kyoungho koo <rnrudgh@gmail.com>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f35e289e17aa..bb8d7cb7bdec 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -276,7 +276,7 @@ static int ext4_create_inline_data(handle_t *handle,
 		len = 0;
 	}
 
-	/* Insert the the xttr entry. */
+	/* Insert the xttr entry. */
 	i.value = value;
 	i.value_len = len;
 
-- 
2.17.1

