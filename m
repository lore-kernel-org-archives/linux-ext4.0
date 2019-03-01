Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1E1C10F03
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D50620851
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tnMY0d9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388723AbfCAOGK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40269 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOGH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id u9so11500589pgo.7;
        Fri, 01 Mar 2019 06:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8M7ToG3O1S9sqar8nQDsp8+aMrMtLN5hbYhPmE6LHpQ=;
        b=tnMY0d9zmNppFPAIaNz7KSLA3lDh0TnUSMuUH8EBbMjRa5x3BSi7rFqifWUkuMJdvt
         DSNek2cAyLSIIMCUEIoausZJYK1vbAKJeLyUdmGOmNszmD0vf/bZQx12+6uqUPJNoDll
         2uoXQAJRxVQ6wVCjdg0stT8m/bp/0qepkS9cjE4S38el5LWjNlwkjO3Vp7QdM8Ub4mhT
         nnk/pFbAiM7qupaa4RZUToZERzbuBDuBTsCwm9aJS6IMvIwujh5oGVqk1Rmn3jERoL7y
         OsWelAswjqRRDn+G8rmBILzmiMaN5upPCknsdBuos5WkchzgTpCt3j5Sz2Qn7/mWn7WU
         xkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8M7ToG3O1S9sqar8nQDsp8+aMrMtLN5hbYhPmE6LHpQ=;
        b=G23ZqzqyZl6rsQ21RRq/8VktFK0mi4AAlF4xb3OAC9VJQYN8sOvg/uMZDbA28XV87Q
         ch6Vo4udTwb/lQwc5iXa0UEGW2xcIQZ5hFZSwh6Qv7fzI9F0ESufbMqY0wpojYCKORSk
         pozYRHl0cXyNI80xo3MWk4gMMQ3qT1tbI/mSg0l6sBe3kV1kLtGzABv2FkHjZvT+pSQo
         gejpUkN0fNJEgr7SlOTLDQvTKklQdrO2T3zKeSJtSdGWA61aVVMFjJeQPhlgghSR+yu8
         E1uZXUjEFs39C46zwpcn8ydlCXF+g0Drdr1fOOfSR80HwEGyhRGc5EEvKj2xXRCorCbj
         Olpg==
X-Gm-Message-State: AHQUAuZr4e7ZdKN3zyd+PR3RtpHBS/KCEdOMYCj9RzM3KKjaNSxAV9zh
        fQfcHf8mPS//kl8LDQ3OL93wViPQ
X-Google-Smtp-Source: APXvYqw4ZE8cAUcw/WLaL+uRKDHZL7AMHmapDLx3UASq2zVCYm80LC8mSMTCQpBFLe2G60UuMykRyQ==
X-Received: by 2002:a62:61c4:: with SMTP id v187mr5553885pfb.133.1551449166402;
        Fri, 01 Mar 2019 06:06:06 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.06.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:05 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 6/8] ext4: support project in ext4_getattr()
Date:   Fri,  1 Mar 2019 23:05:39 +0900
Message-Id: <1551449141-7884-7-git-send-email-wshilong1991@gmail.com>
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
 fs/ext4/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b6c451407dcd..cd7b3f997c3b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5703,6 +5703,8 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 
+	stat->projid = ei->i_projid;
+
 	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime.tv_sec = ei->i_crtime.tv_sec;
@@ -5720,12 +5722,15 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & EXT4_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (flags & EXT4_PROJINHERIT_FL)
+		stat->attributes |= STATX_ATTR_PROJINHERIT;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_PROJINHERIT);
 
 	generic_fillattr(inode, stat);
 	return 0;
-- 
2.19.1

