Return-Path: <SRS0=18j+=WH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4057C32756
	for <linux-ext4@archiver.kernel.org>; Sun, 11 Aug 2019 21:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF43120818
	for <linux-ext4@archiver.kernel.org>; Sun, 11 Aug 2019 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565559436;
	bh=ogxEiq2FStmpdB1nMQQucSgGithBLja/oR9v2LpPzGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ayuxk1/qwRa/gXF2qBG2+JAfodcOybV3uRxTMUVaYAywvge2aIN6FguPmq3w45Z32
	 ynthUrk1k6b91K1MkJKR3jo50+UwKxx+9syNzrBz5Sk8HyUEcjeUKGur43m14zbs+w
	 bZ4jXtFqdSm8JdTI6t79w6WSQIuGN96kqUui7AYQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfHKVhQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 11 Aug 2019 17:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfHKVhO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 310002147A;
        Sun, 11 Aug 2019 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559433;
        bh=ogxEiq2FStmpdB1nMQQucSgGithBLja/oR9v2LpPzGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjKGV8U4TfrNl4xq3zOAIX0wqsItLHGRMeqlb7G26JeK1ekkCb5ZB/ha1mvjDNMcH
         XGaJvYtNHn86tLponsPBakMNcE54w4kLU0WParAktwp5L6K7uRVuj1lmDmqq9kD2Q3
         08W5HT7MXYRs0lrzhllxVQFpqPLuJnTkXGB8OKyI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/6] ext4: remove ext4_bio_encrypted()
Date:   Sun, 11 Aug 2019 14:35:55 -0700
Message-Id: <20190811213557.1970-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190811213557.1970-1-ebiggers@kernel.org>
References: <20190811213557.1970-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

ext4_bio_encrypted() is unused following commit 4e47a0d40dac
("ext4: add fs-verity read support"), so remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/readpage.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index ec8aeab3af65a..a30b203fa461c 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -52,15 +52,6 @@
 static struct kmem_cache *bio_post_read_ctx_cache;
 static mempool_t *bio_post_read_ctx_pool;
 
-static inline bool ext4_bio_encrypted(struct bio *bio)
-{
-#ifdef CONFIG_FS_ENCRYPTION
-	return unlikely(bio->bi_private != NULL);
-#else
-	return false;
-#endif
-}
-
 /* postprocessing steps for read bios */
 enum bio_post_read_step {
 	STEP_INITIAL = 0,
-- 
2.22.0

