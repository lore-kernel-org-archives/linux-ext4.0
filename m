Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303E0EB64DD
	for <linux-ext4@archiver.kernel.org>; Mon, 24 Jul 2023 05:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjGXFqQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 24 Jul 2023 01:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjGXFqP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jul 2023 01:46:15 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 4E48EA6;
        Sun, 23 Jul 2023 22:46:13 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 7544F60801374;
        Mon, 24 Jul 2023 13:45:53 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Su Hui <suhui@nfschina.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, kernel-janitors@vger.kernel.org,
        Su Hui <suhui@nfschina.com>
Subject: [PATCH] ext4: mballoc: avoid garbage value from err
Date:   Mon, 24 Jul 2023 13:45:39 +0800
Message-Id: <20230724054538.163319-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

clang warning: fs/ext4/mballoc.c, line 4178, column 6
Branch condition evaluates to a garbage value.

err is uninitialized and will be judged when it enters the
loop first time and the condition "!ext4_sb_block_valid()"
is true. Although this can't make problems now, it's better
to correct it.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 21b903fe546e..769000c970b0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4084,7 +4084,7 @@ void ext4_mb_mark_bb(struct super_block *sb, ext4_fsblk_t block,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
 	ext4_grpblk_t blkoff;
-	int i, err;
+	int i, err = 0;
 	int already;
 	unsigned int clen, clen_changed, thisgrp_len;
 
-- 
2.30.2

