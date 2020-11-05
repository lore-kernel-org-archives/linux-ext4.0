Return-Path: <SRS0=Ja7Y=EL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED07FC55179
	for <linux-ext4@archiver.kernel.org>; Thu,  5 Nov 2020 16:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8891320739
	for <linux-ext4@archiver.kernel.org>; Thu,  5 Nov 2020 16:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgKEQSA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 5 Nov 2020 11:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgKEQR7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2020 11:17:59 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5102AC0613D2
        for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2020 08:17:59 -0800 (PST)
Received: from xps.home (unknown [IPv6:2a01:e35:2fb5:1510:4a7e:bc14:686e:75db])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aferraris)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 346C21F4611D;
        Thu,  5 Nov 2020 16:17:58 +0000 (GMT)
From:   Arnaud Ferraris <arnaud.ferraris@collabora.com>
To:     linux-ext4@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>
Subject: [PATCH 02/11] tune2fs: Fix casefold+encrypt error message
Date:   Thu,  5 Nov 2020 17:16:34 +0100
Message-Id: <20201105161642.87488-3-arnaud.ferraris@collabora.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105161642.87488-1-arnaud.ferraris@collabora.com>
References: <20201105161642.87488-1-arnaud.ferraris@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

Refering to EXT4_INCOMPAT_CASEFOLD as encoding is not as meaningful as
saying casefold.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
---
 misc/tune2fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0809e565..c182f4d5 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1470,7 +1470,7 @@ mmp_error:
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
 		if (ext2fs_has_feature_casefold(sb)) {
 			fputs(_("Cannot enable encrypt feature on filesystems "
-				"with the encoding feature enabled.\n"),
+				"with the casefold feature enabled.\n"),
 			      stderr);
 			return 1;
 		}
-- 
2.28.0

