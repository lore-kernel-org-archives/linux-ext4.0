Return-Path: <SRS0=rV8s=XP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86BDC4CECD
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 21:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DBF12080F
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 21:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569015082;
	bh=DsCRwu7FxFK1qUbPs8OD3JaAlD3/NfiI8Yjv5XgveSw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=avaCWC44bGYuTGYeUumzM7q2NRr8SWnAn87OqsAbu2i0skHotVWAxirX9GvfUNVIk
	 aAdo4SD9owNwiG02mZPW95OIR74yeYFzdVN1udYkDHM15IvY+esSmSH9m/epbyXFKz
	 fO+ywXCuKiG6Jomb5xlt5Rqr7Ry+7v+xrCgys6Iw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbfITVbV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Sep 2019 17:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388697AbfITVbV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Sep 2019 17:31:21 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034EE2086A
        for <linux-ext4@vger.kernel.org>; Fri, 20 Sep 2019 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569015081;
        bh=DsCRwu7FxFK1qUbPs8OD3JaAlD3/NfiI8Yjv5XgveSw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kyvzZW/qilQPVDau8g094zDu4WKGrNlP3UTbiSL0B/eHlMFGV3TXEVvXVk8uircEU
         mO3pi1qCird9EOKnGOOs5Ugs6ySWYMKT2hcN5aYg9FN16+YvnpIk8cs8ctOZliqBHR
         DwnDz5MAF0yKFjKK2J04UCPfmMLnpSHdhTbTKnKw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH 5/6] tune2fs.8: document the verity feature
Date:   Fri, 20 Sep 2019 14:29:53 -0700
Message-Id: <20190920212954.205789-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920212954.205789-1-ebiggers@kernel.org>
References: <20190920212954.205789-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/tune2fs.8.in | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index b60db6ed..f7c7d42d 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -631,6 +631,11 @@ keep a high watermark for the unused inodes in a filesystem, to reduce
 time.  The first e2fsck run after enabling this feature will take the
 full time, but subsequent e2fsck runs will take only a fraction of the
 original time, depending on how full the file system is.
+.TP
+.B verity
+Enable support for verity protected files.
+.B Tune2fs
+currently only supports setting this filesystem feature.
 .RE
 .IP
 After setting or clearing
-- 
2.23.0.351.gc4317032e6-goog

