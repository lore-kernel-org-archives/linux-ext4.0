Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA60C433E0
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Feb 2021 22:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E40E064EDC
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Feb 2021 22:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZWPs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Feb 2021 17:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhBZWPr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Feb 2021 17:15:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6DBC06174A
        for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2021 14:15:07 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d13-20020a17090abf8db02900c0590648b1so2369pjs.1
        for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2021 14:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cSPaSClt+uo6Y/kmY2yO/ZDm+u6iS+o8rwLcwzKp/pg=;
        b=Jq1w2xRbWh+l4OEusyeBz69rbK6+PDoF19xCLPqn5z/hhSvC+9ZWIDwxCrE4Lv1Grb
         Hh8D0xc8sLEzjz9fbFwNbk8rED1x9CPmSZ4j+sDtuwJIc78CV5/SoIuePGA/DMilE8fX
         gVffpOaRCNM5BSkFjnhmef8yDeF0ECLTk5Mj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cSPaSClt+uo6Y/kmY2yO/ZDm+u6iS+o8rwLcwzKp/pg=;
        b=DF8le26DUOMUWgk8zVxS0L6KfOS7OVxKW+wwLal4xk2t41yFgbqO40Vn4+FPoiz+Aw
         fPhsDGeBMzfphJrEPplyQ/6auxdZYrreGt/R7CTlXq5xMVFM4wIRAOqexHTfeKhNxj+L
         eIP7cHlzdWklqP40moqn8Yuz5Cr53FPq2r52B1CHRpjwnJRW9u8Bt2KISiJ7ziVz1boI
         ODvrajgwbacyXqJvd8CTMPFTro7igrPzUH2glVaVxT0dgbhL9afrnsRLjZEHsdgnLgMq
         vvWGupI3KSIFl4Fmx5Vs+hspfjIOm/52aSdcDiCx1QFRy4z9WQrpfxMuitWR5au6rcjD
         JziQ==
X-Gm-Message-State: AOAM531pbR1nBvw53dKEEmotkiMQzNsPnHTepV8/SHukyTVURb747VLu
        UESrGiY0hasbv7GCWjyoTizvxg==
X-Google-Smtp-Source: ABdhPJwYIJLDOJiNMCUOi9wxgZrIh9V1GRLS1EHTu4/84IuxT4jWvwmOUpSSAMEIaLaevH2c0j0uIg==
X-Received: by 2002:a17:90a:b782:: with SMTP id m2mr5437024pjr.220.1614377707290;
        Fri, 26 Feb 2021 14:15:07 -0800 (PST)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net ([2601:647:5a81:1d70::c086])
        by smtp.gmail.com with ESMTPSA id k5sm9374519pjl.50.2021.02.26.14.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 14:15:06 -0800 (PST)
From:   Sarthak Kukreti <sarthakkukreti@chromium.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Sarthak Kukreti <sarthakkukreti@chromium.org>
Subject: [PATCH] ext4: Add xattr commands to compat ioctl handler
Date:   Fri, 26 Feb 2021 14:14:41 -0800
Message-Id: <20210226221441.70071-1-sarthakkukreti@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This allows 32-bit userspace utils to use FS_IOC_FSGETXATTR and 
FS_IOC_FSSETXATTR on a 64-bit kernel.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 fs/ext4/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f0381876a7e5b..055c26296ab46 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1371,6 +1371,8 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 		return ext4_ioctl_group_add(file, &input);
 	}
+	case EXT4_IOC_FSGETXATTR:
+	case EXT4_IOC_FSSETXATTR:
 	case EXT4_IOC_MOVE_EXT:
 	case EXT4_IOC_RESIZE_FS:
 	case FITRIM:
-- 
2.30.1.766.gb4fecdf3b7-goog

