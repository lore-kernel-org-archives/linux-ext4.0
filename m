Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE92C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 140D320850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLqg9rFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732503AbfCAOGd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:33 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41524 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfCAOGd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:33 -0500
Received: by mail-pl1-f193.google.com with SMTP id y5so11545136plk.8;
        Fri, 01 Mar 2019 06:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vYFcWm2lxNCGpDqnRq6Cc0aOJmVRGHqyv2wC07or3ag=;
        b=KLqg9rFsNhHTJ+KS36XY9zPI5P8wqvSlk9SU88lmKCPi68JGkbRkiXtROWaKP3bZSS
         UrXTYJxLsOPrahmjrRWeZ5Hm2robirROkYzGU/aF/2u5TzIMzzACBQdtWmvvctSf9j/Z
         E3HIg1pNm1/5IHTDflIGt44kM7cQ+M4zslI6CbAMZjF+2fV8McMcg1ju3HjH7XFUY5mX
         QXQo4p+P4tdxTLKBUcPkSkbNv/hxYVFi4dbHWkTxdATuXT6ccS+PasRksatcqLTfqxFI
         Llc4y3AWPVQ0s1yjv3Qnb911d8uI1gFIR2+PGnkd+V+LC9MEK/zr6DylwLE9hSKevb/E
         3FVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vYFcWm2lxNCGpDqnRq6Cc0aOJmVRGHqyv2wC07or3ag=;
        b=eBkg/wg5e1EG17nwfuM+FleQeINQlThDZ1+vTgbsHuuZ+HgvLh8fByPM06JthPTnDP
         XJE3SsaNlNsZ0Npb6KkIbRao+BoSx+DwuDB/RgWxlpZheEvnlCmyvROXDIXvgu/eEcNH
         +3wCgB6b+ELhrtlOzRS9uUfqq2/9QEfxfTyCK1hn6ZJSgphuXiYTR9Aup8f2nayq29Cb
         BreUd4/oruWCLQK344CtatjRkGkUgzByKAEGPpxBXxl/j0bQ0II17/bYH6eURFesUdab
         WTcMeYclEnRvHPB7yMydzTRbjgis0pIRsrFc67Ka5OifHXnN5unCKP2m0YgRBY8U9oGP
         OSIA==
X-Gm-Message-State: APjAAAUSUPLiOXVQC2n8a+UAWS+Lf6ByPiqEKhgEA69n8uicP1hdpemw
        r0CSJuxhptJwiUt/rQmLJ6zCkh+9
X-Google-Smtp-Source: APXvYqzKtmyVr6zEU/pA3oSR/TbLxlblZCQLkJ4ij2tmeN8WmL4fxNV1oysstLrjecYiyiLaK4iKaQ==
X-Received: by 2002:a17:902:3f81:: with SMTP id a1mr5652866pld.238.1551449192141;
        Fri, 01 Mar 2019 06:06:32 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id o2sm36534917pfa.76.2019.03.01.06.06.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:31 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>,
        linux-man@vger.kernel.org
Subject: [PATCH 1/2] fchownat.2: add project support updates
Date:   Fri,  1 Mar 2019 23:06:22 +0900
Message-Id: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Cc: linux-man@vger.kernel.org
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 man2/chown.2 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man2/chown.2 b/man2/chown.2
index 50db789ac..fad74df20 100644
--- a/man2/chown.2
+++ b/man2/chown.2
@@ -217,6 +217,11 @@ instead operate on the link itself, like
 .BR fchownat ()
 dereferences symbolic links, like
 .BR chown ().)
+.TP
+.B AT_FCHOWN_PROJID
+Use
+.I group
+to change file's project ID instead of its group ID.
 .PP
 See
 .BR openat (2)
-- 
2.19.1

