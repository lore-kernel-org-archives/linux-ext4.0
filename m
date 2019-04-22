Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67227C10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B373214AE
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555967337;
	bh=1z1z1BdZ1zUkUm9CeEJfMh6RmQK/v/QBwx668zMxjgU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=l+i/yx7rAckKhDYSNZDcD1n+lGsAAcQPpm0M77mRhZr8Glu6O8q7D5gKKdESKORe5
	 7Alg5IBzS/Fqe87PR2kTT2SodkCR8XUZMUqSMFYfhUf9LeQy4ZZvnNYXRCr1fAVS0s
	 qPCiRU/TwgQKxhnl7XdL3vYgcVFQ80ekVpiB+Sl0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfDVVI4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbfDVVI4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 17:08:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C0E20896;
        Mon, 22 Apr 2019 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555967336;
        bh=1z1z1BdZ1zUkUm9CeEJfMh6RmQK/v/QBwx668zMxjgU=;
        h=From:To:Cc:Subject:Date:From;
        b=Z/AHytqvuluf4BmC/FVT36M3iAIAI7HeLHwU9vpmUhqnQiLZ8l5KbuUSLCWJFR9hJ
         ce8V9z6MP4+F5d8g1kV7V1Mtiu8x7kESrKGr2glL9ghcDxnZJYhime9E2J9qi2QbPx
         gdAkWc2MV6V2Qtf0Qg9wlqiQjIZYsZ9Oj4CNAXUU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH] libext2fs: remove unused variable 'buff'
Date:   Mon, 22 Apr 2019 14:08:43 -0700
Message-Id: <20190422210843.185382-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In ext2fs_dirhash2(), the outer 'buff' variable is never used.

Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/ext2fs/dirhash.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index f1e7734d..97fd2431 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -279,7 +279,6 @@ errcode_t ext2fs_dirhash2(int version, const char *name, int len,
 {
 	errcode_t r;
 	int dlen;
-	unsigned char *buff;
 
 	if (len && charset) {
 		char buff[PATH_MAX];
-- 
2.21.0.593.g511ec345e18-goog

