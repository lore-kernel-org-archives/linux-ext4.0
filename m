Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96AFC43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845CB20850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZiu7ote"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbfCAOGQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:16 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39327 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbfCAOGO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:14 -0500
Received: by mail-pf1-f178.google.com with SMTP id i20so11479617pfo.6;
        Fri, 01 Mar 2019 06:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rzE52lPnGyt0Q/ORpvyzYDAG9Oki7in7KfRHwtaApSM=;
        b=fZiu7otecETTH+B+2uMb13Dp9h1u1Ylbn2WZ/H28FKOmw3Y/EKziXNytlk7r+h0O4K
         Y6sMxaH+1vQU9qz7M+CNCpzznUGv8XJY8R7LwdEbJIKVoNapUCk6NFiLunsIQfPlGplO
         OXDusnzHoJeNTZWPbkVqxTRBMEYtib+rIwua7uy5a8ba1GS8mkQ81FqNKeRHK32Wm52c
         iMZ2rJ32L4k/mFcAWIt+ANUBzIDgNcrqZe3wq7sqpmdbo64edbIQySMlD/WqbG5NKyB4
         A5wpdt0IlAxsPrnuO/vmbXqYHJg8HElEB6NmSRp+Q5ixYCKchBDs/lcgWVz+z7SUmHBg
         USKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rzE52lPnGyt0Q/ORpvyzYDAG9Oki7in7KfRHwtaApSM=;
        b=J+puOOh2lyDyNkF2d5IoM7MWnJfg0AFOjl1oRJ4LdRsJzWOSmEiCTOk4LdF9+waCwt
         yOJEBhL4cC7ufXIFZ+anMBhvnI0MoiezYkqJJP1RAFxe6+Th2bi75H0us7pTJVuyoDxw
         E2Ssjkob0qmNddOAvMS+/j6saSvAynvuYfXNMmD1zxOdq1vt2xGdc9UIG3LLb91jL/Y2
         yFXCENLiJub+X5qC6R9JgjoasdUIWHN4jkNFKrIvMC+Lerva4F44zogV7YZVNgG8y1Uv
         58EJs2JXzC4kh/PODDVEt0W1zONNx7CuC06qC+lxB0v909qsosS+jKFCoLs7zkV3iBVW
         WuNw==
X-Gm-Message-State: APjAAAWzlLXEFQkRlkiJOqSl8r+8TZhNZ0f//orWzSUImlBMincGwPvt
        kkaV6Dt9AHutbX0M0xkbNCOT0OqX
X-Google-Smtp-Source: APXvYqyLDBCTmNmFKZQtVEhrEXO2Z23jBhA+CgOfO2y6lbFtgjaE6GywaSWADPgQsWRlomaErASTjg==
X-Received: by 2002:a63:8bc7:: with SMTP id j190mr5038177pge.382.1551449171247;
        Fri, 01 Mar 2019 06:06:11 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id a184sm12458089pge.68.2019.03.01.06.06.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:10 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: [PATCH 8/8] xfs: support project in xfs_getattr()
Date:   Fri,  1 Mar 2019 23:05:41 +0900
Message-Id: <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
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
 fs/xfs/xfs_iops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c10466fe6ed4..a2f8c0f048cf 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -501,6 +501,7 @@ xfs_vn_getattr(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	stat->projid = xfs_projid_to_kprojid(xfs_get_projid(ip));
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;
 	stat->mode = inode->i_mode;
@@ -528,6 +529,8 @@ xfs_vn_getattr(
 		stat->attributes |= STATX_ATTR_APPEND;
 	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		stat->attributes |= STATX_ATTR_PROJINHERIT;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
-- 
2.19.1

