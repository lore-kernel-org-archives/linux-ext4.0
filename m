Return-Path: <SRS0=tv+E=2V=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28013C32764
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Dec 2019 18:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A66B206E4
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Dec 2019 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577815567;
	bh=lRevvk/BGh4eOEV8yfRUsu7wUsxde4URMzdRn+MBeMQ=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=S7ett48ORdgt9SW3Cc6kMjyUMokOoqvVqvWomA6deVr7bgpF7D2RUUW3WvkOEvvEb
	 ptfEZmbsSOMZkw/FxPpp6J+nb5R+J9BotSOyQqIjwEk/+ObwsaPFIt0NGU/VQYqqeR
	 FOf1sMqFM6DaUQZCIgmIKiioXEHS52qIUjE9JLlE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfLaSGG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 31 Dec 2019 13:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 31 Dec 2019 13:06:04 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6DE206E4
        for <linux-ext4@vger.kernel.org>; Tue, 31 Dec 2019 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577815563;
        bh=lRevvk/BGh4eOEV8yfRUsu7wUsxde4URMzdRn+MBeMQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JK8OabYRDRO3h1vwqVa6aoES9KhN/7Xs9CvuHJHhzIXaDTnbzOViDoagkpA+VYTvh
         Rwa45EQEmzUL/RUPE4i8hKdpCgE5B/f36STU3jc4IxwPHWKzqQkbWxjv2gqx/M5P9U
         CEYp8TdAk55SG6MMybgE8WT+BNQqEKm5/rgtJh/U=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH 8/8] ext4: add missing braces in ext4_ext_drop_refs()
Date:   Tue, 31 Dec 2019 12:04:44 -0600
Message-Id: <20191231180444.46586-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231180444.46586-1-ebiggers@kernel.org>
References: <20191231180444.46586-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For clarity, add braces to the loop in ext4_ext_drop_refs().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1cdcd9b0934d..640c3681dcc6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -689,11 +689,12 @@ void ext4_ext_drop_refs(struct ext4_ext_path *path)
 	if (!path)
 		return;
 	depth = path->p_depth;
-	for (i = 0; i <= depth; i++, path++)
+	for (i = 0; i <= depth; i++, path++) {
 		if (path->p_bh) {
 			brelse(path->p_bh);
 			path->p_bh = NULL;
 		}
+	}
 }
 
 /*
-- 
2.24.1

