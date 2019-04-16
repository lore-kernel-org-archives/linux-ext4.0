Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF984C10F14
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 19:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB24120663
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 19:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfDPTom (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:44:42 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51834 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfDPTom (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2019 15:44:42 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 5A979281F5C
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH 2/2] ext4: Update to use unicode 12.1
Date:   Tue, 16 Apr 2019 15:44:33 -0400
Message-Id: <20190416194433.8664-2-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190416194433.8664-1-krisman@collabora.com>
References: <20190413192533.2549-1-krisman@collabora.com>
 <20190416194433.8664-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/ext4/ext4.h  | 2 +-
 fs/ext4/super.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c0b98e882b33..7bc3859458f0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1341,7 +1341,7 @@ struct ext4_super_block {
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 3
 
-#define EXT4_ENC_UTF8_12_0	1
+#define EXT4_ENC_UTF8_12_1	1
 
 /*
  * Flags for ext4_sb_info.s_encoding_flags.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3870866840f9..44d22955afa6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1760,7 +1760,7 @@ static const struct ext4_sb_encodings {
 	char *name;
 	char *version;
 } ext4_sb_encoding_map[] = {
-	{EXT4_ENC_UTF8_12_0, "utf8", "12.0.0"},
+	{EXT4_ENC_UTF8_12_1, "utf8", "12.1.0"},
 };
 
 static int ext4_sb_read_encoding(const struct ext4_super_block *es,
-- 
2.20.1

