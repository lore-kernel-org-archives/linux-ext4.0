Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F68C4360F
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E3A2085A
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3lqbvQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfCAOGM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:12 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42522 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbfCAOGJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:09 -0500
Received: by mail-pg1-f193.google.com with SMTP id b2so11501046pgl.9;
        Fri, 01 Mar 2019 06:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5ZOo25C1X8MHB6X+yY67EB2Q2uI08yHOFb+79kFGpJY=;
        b=r3lqbvQA/d4kIxnHqjsA46pRTNiHnLsDWuoCZ0zAqWo351hyHV9IIlyY6+dvZH7WTz
         fuf/AfX1guPBIYCuVwFdLPzAkQWCbDG1/XIGbSiv2MnBEfZqJr8YQDpHZ3Cm9wB5glOh
         76E4UkJpBKy/1oG8YZUeQaXKmmCbHywWG/Y+ojMORct1cV75NYRUKFjTYtieLn8RsDLF
         RcxHFx5ZcedKl/VVoAtU+DUb0sFsED+Q8O9LVARX0RNiphSAqOty0GQR0Gk6Sr5IaqR5
         0HXirqFrckJDpK9STXvZonrp1nsPSk2ObsEC79mOmBtvRTKbYx4EzLHnvQRsyVEimOee
         s7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5ZOo25C1X8MHB6X+yY67EB2Q2uI08yHOFb+79kFGpJY=;
        b=Ixhoa2dFJ5EnuF76wpWyGCeTr8Ukb2a3FmqoC+6+PV38S6XaXIrBrBj43UQW+vlhqV
         6MWXGI7XiqhV5lWNFSpxY8Yjgbz4mZpFxLzae8vdG+qT8tcAjTIWTbrvT2Rf9isyiN6E
         oglmStqMIZ7394dJzSi5AX2WzT2y+GJYlIZK0uwKDoUAkG/odIlPPJqFjrDMYxk+ZI9c
         hzl06dxVgwkthqt40xdDLBl3oGJOLXgVazYNCf4bTx834BWRUi2OM7VwJwBpQTFBj1is
         AamfN+FnD9E/ror6CLN4f0BIDAnKYii7uXtvY2D74MpuZTHbiqaYmOY1z7IMMVf/Im3z
         w+cQ==
X-Gm-Message-State: AHQUAubWIJ6en1/Yxl8SVGd1BpUD8Kl8Q1eyJqlqv76z05WPom+IhzUH
        +RyAasIyxkyQkXG6NYGFJKC+1bp7
X-Google-Smtp-Source: APXvYqyUZu++7exWaPKHL4xSlOddzvHNCEV0P6JJJ4IFKeKX+Of/yHIW/rRHbQDQX/uk3rDUiYoEPw==
X-Received: by 2002:aa7:8150:: with SMTP id d16mr5773209pfn.172.1551449168800;
        Fri, 01 Mar 2019 06:06:08 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.06.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:08 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 7/8] f2fs: support project in f2fs_getattr()
Date:   Fri,  1 Mar 2019 23:05:40 +0900
Message-Id: <1551449141-7884-8-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8eaca056e857..2db5883cc1b0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -705,6 +705,7 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 		stat->btime.tv_sec = fi->i_crtime.tv_sec;
 		stat->btime.tv_nsec = fi->i_crtime.tv_nsec;
 	}
+	stat->projid = fi->i_projid;
 
 	flags = fi->i_flags & F2FS_FL_USER_VISIBLE;
 	if (flags & F2FS_APPEND_FL)
@@ -717,12 +718,15 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & F2FS_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (flags & F2FS_PROJINHERIT_FL)
+		stat->attributes |= STATX_ATTR_PROJINHERIT;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_PROJINHERIT);
 
 	generic_fillattr(inode, stat);
 
-- 
2.19.1

