Return-Path: <SRS0=R85w=SP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FA7C10F14
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6FA20850
	for <linux-ext4@archiver.kernel.org>; Sat, 13 Apr 2019 05:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfDMFn0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 Apr 2019 01:43:26 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37478 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfDMFn0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2019 01:43:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 86246281C30
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH e2fsprogs 01/10] e2p: encoding: Fix default flags lookup
Date:   Sat, 13 Apr 2019 01:43:08 -0400
Message-Id: <20190413054317.7388-2-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413054317.7388-1-krisman@collabora.com>
References: <20190413054317.7388-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/e2p/encoding.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
index 88433310a1dd..27e93305172b 100644
--- a/lib/e2p/encoding.c
+++ b/lib/e2p/encoding.c
@@ -67,7 +67,7 @@ int e2p_get_encoding_flags(int encoding)
 
 	for (i = 0 ; i < ARRAY_SIZE(ext4_encoding_map); i++)
 		if (ext4_encoding_map[i].encoding_magic == encoding)
-			return ext4_encoding_map[encoding].default_flags;
+			return ext4_encoding_map[i].default_flags;
 
 	return 0;
 }
-- 
2.20.1

