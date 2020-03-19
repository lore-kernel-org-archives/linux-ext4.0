Return-Path: <SRS0=UXlx=5E=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3838C4332E
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Mar 2020 23:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A572076C
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Mar 2020 23:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sDHkvhhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCSXe4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 Mar 2020 19:34:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38870 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgCSXez (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2020 19:34:55 -0400
Received: by mail-pl1-f194.google.com with SMTP id w3so1734589plz.5
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2020 16:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EVFLZH0z8TckMFHPr5r1zTW75UHizWORYUAUg9vHmFc=;
        b=sDHkvhhYIiXv9YOHsh3oYxlZd7mmP2GjbxCdTD9TDrkNa10ugs3DgMHjxYOvC6s/ZF
         +4YpqsR2vrUztnr3gz9B58PEDs7UvJBpEnk41vnuesLsOKNnSygPQCEibOKzV5m5C8RN
         GBKmWQO60PqueDaGM8a3hFuYvi3ZFsCUnMaoH7UZyIZe6iuduc2Oc9eyp6yqqSv3dYva
         i/rbBaEXZ8PXLz7qkcGvVJ4Ws8qBVBhg4qQ5CFS3kpZUnAnjZgdxvZu/EiFAzA5YbVXc
         ywXXWn4qFmnz3oM/Cd1z0v05TXyOyVbZNqOA3hvND7KrwDCGI/Fpu9cGc2+xL2CEcGSG
         cLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EVFLZH0z8TckMFHPr5r1zTW75UHizWORYUAUg9vHmFc=;
        b=kaSI30gp40Nz0PtsWUvEYR9k8fWQhQY6ksC2dliYcKy4vFZNgWVdMlXsUUsFyRXJEz
         pKtDmOTc6dzyFObd+aknh04cGJVubtSiCvDfdScMMATcF5VgV3AIDnKR+H9GYCwicjSk
         +nl3LEhVa6DV/YHx82Au3oiCeCsXR7I2VwRJ6Cke3X+svoXKqjG8ALSgd93L2DTMfwtN
         v9qN7GZOLNsnXqay0morO5WMH3/9ykjdqhhgX/JV1HZ5eJBykTO4HGdtympmV2sFNwBc
         XJ66m7+xiT6OCFVaSOXWKat+4oGukUA6zL1e6W3vKSK6zhRhxGE8CL5iZFPTWh/2sScC
         HxnQ==
X-Gm-Message-State: ANhLgQ1ZmoC+aydFUXfa2Pa1yjGuN0YPTjUYKZ7jSZZUugo9wbsgtIv6
        WX+hM4orNA8HWxKJtUPFwttPx/t9
X-Google-Smtp-Source: ADFU+vudf1deGWULUlGODJyYY1bWi6YiE4YiPT1DeKd6g6Z39qygSVIyUZk575fZNVsk8WEQnnMATQ==
X-Received: by 2002:a17:90a:346f:: with SMTP id o102mr6349975pjb.162.1584660893857;
        Thu, 19 Mar 2020 16:34:53 -0700 (PDT)
Received: from harshads0.svl.corp.google.com ([2620:15c:2cd:202:ec1e:207a:e951:9a5b])
        by smtp.googlemail.com with ESMTPSA id j17sm204353pga.18.2020.03.19.16.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 16:34:53 -0700 (PDT)
From:   Harshad Shirwadkar <harshadshirwadkar@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [PATCH 4/7] e2fsck/jbd2: add fast commit feature in jbd2
Date:   Thu, 19 Mar 2020 16:34:30 -0700
Message-Id: <20200319233433.117144-5-harshadshirwadkar@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <20200319233433.117144-1-harshadshirwadkar@gmail.com>
References: <20200319233433.117144-1-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add fast_commit feature flag in jbd2. These changes are present in
kernel code too.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
---
 lib/ext2fs/kernel-jbd.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index cb1bc308..1250f5f0 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -259,6 +259,7 @@ typedef struct journal_superblock_s
 #define JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT	0x00000004
 #define JBD2_FEATURE_INCOMPAT_CSUM_V2		0x00000008
 #define JBD2_FEATURE_INCOMPAT_CSUM_V3		0x00000010
+#define JBD2_FEATURE_INCOMPAT_FAST_COMMIT	0x00000020
 
 /* Features known to this kernel version: */
 #define JBD2_KNOWN_COMPAT_FEATURES	0
@@ -267,7 +268,8 @@ typedef struct journal_superblock_s
 					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT| \
 					 JBD2_FEATURE_INCOMPAT_64BIT|\
 					 JBD2_FEATURE_INCOMPAT_CSUM_V2|	\
-					 JBD2_FEATURE_INCOMPAT_CSUM_V3)
+					 JBD2_FEATURE_INCOMPAT_CSUM_V3 | \
+					 JBD2_FEATURE_INCOMPAT_FAST_COMMIT)
 
 #ifdef NO_INLINE_FUNCS
 extern size_t journal_tag_bytes(journal_t *journal);
@@ -384,6 +386,7 @@ JBD2_FEATURE_INCOMPAT_FUNCS(64bit,		64BIT)
 JBD2_FEATURE_INCOMPAT_FUNCS(async_commit,	ASYNC_COMMIT)
 JBD2_FEATURE_INCOMPAT_FUNCS(csum2,		CSUM_V2)
 JBD2_FEATURE_INCOMPAT_FUNCS(csum3,		CSUM_V3)
+JBD2_FEATURE_INCOMPAT_FUNCS(fast_commit,	FAST_COMMIT)
 
 #if (defined(E2FSCK_INCLUDE_INLINE_FUNCS) || !defined(NO_INLINE_FUNCS))
 /*
-- 
2.25.1.696.g5e7596f4ac-goog

