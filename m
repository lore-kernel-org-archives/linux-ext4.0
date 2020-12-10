Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21A4C0018C
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 15:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84EF523B45
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 15:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389069AbgLJPFS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 10 Dec 2020 10:05:18 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49154 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388924AbgLJPEs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2020 10:04:48 -0500
Received: from xps.home (unknown [IPv6:2a01:e35:2fb5:1510:1626:c942:e0f1:c77c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aferraris)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id D60A11F458EF;
        Thu, 10 Dec 2020 15:04:04 +0000 (GMT)
From:   Arnaud Ferraris <arnaud.ferraris@collabora.com>
To:     linux-ext4@vger.kernel.org
Cc:     drosen@google.com, krisman@collabora.com, ebiggers@kernel.org,
        tytso@mit.edu, Arnaud Ferraris <arnaud.ferraris@collabora.com>
Subject: [PATCH RESEND v2 11/12] e2fsck.8.in: Document check_encoding extended option
Date:   Thu, 10 Dec 2020 16:03:52 +0100
Message-Id: <20201210150353.91843-12-arnaud.ferraris@collabora.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210150353.91843-1-arnaud.ferraris@collabora.com>
References: <20201210150353.91843-1-arnaud.ferraris@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
---
 e2fsck/e2fsck.8.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 4e3890b2..019a34ec 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -267,6 +267,10 @@ Only fix damaged metadata; do not optimize htree directories or compress
 extent trees.  This option is incompatible with the -D and -E bmap2extent
 options.
 .TP
+.BI check_encoding
+Force verification of encoded filenames in case-insensitive directories.
+This is the default mode if the filesystem has the strict flag enabled.
+.TP
 .BI unshare_blocks
 If the filesystem has shared blocks, with the shared blocks read-only feature
 enabled, then this will unshare all shared blocks and unset the read-only
-- 
2.29.2

