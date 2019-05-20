Return-Path: <SRS0=1GTa=TU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB9BC04AAF
	for <linux-ext4@archiver.kernel.org>; Mon, 20 May 2019 16:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CD84217F5
	for <linux-ext4@archiver.kernel.org>; Mon, 20 May 2019 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558369829;
	bh=2VfMQcWxI7izVssKpNPFzAKV9+cNy5lJmumqc5qr+wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=c/LIha8Bgf6a3yOqcTqYN6A/cWMqg9Wd3KfR4J3Hte+ANiHKUGbzUaSoapEBXuTCt
	 eaircLXh8rdOujSe7Ngzx0EJ4GQye3SQknuAC3x89ltVJm0rFu+1VaGTHNcEky6I96
	 jbiANWA0u1CptXbSmHL/07HhhTj3TdYhT7MpvlyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392324AbfETQa0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 20 May 2019 12:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392210AbfETQaZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 20 May 2019 12:30:25 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771892177B;
        Mon, 20 May 2019 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369824;
        bh=2VfMQcWxI7izVssKpNPFzAKV9+cNy5lJmumqc5qr+wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBgj5saciLvVrwohSAaTQGyUQML0D8dweuFggK7JAxrYNJ48w0hn6cbW3A61PEndn
         VWVdGZePP4z9MBXf+bcI3cwBzkOjpe9uXrFMc9wSSVEBr4oVVJt9lXYqQoehFSDNWo
         9USOUK7vN2q8D+I+jQeoXnirC0yTEic2JTH89jSU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 11/14] ext4: clear BH_Uptodate flag on decryption error
Date:   Mon, 20 May 2019 09:29:49 -0700
Message-Id: <20190520162952.156212-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520162952.156212-1-ebiggers@kernel.org>
References: <20190520162952.156212-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Chandan Rajendra <chandan@linux.ibm.com>

If decryption fails, ext4_block_write_begin() can return with the page's
buffer_head marked with the BH_Uptodate flag.  This commit clears the
BH_Uptodate flag in such cases.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34fda4864c0eb..0e6536a22a465 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1229,10 +1229,14 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (!buffer_uptodate(*wait_bh))
 			err = -EIO;
 	}
-	if (unlikely(err))
+	if (unlikely(err)) {
 		page_zero_new_buffers(page, from, to);
-	else if (decrypt)
+	} else if (decrypt) {
 		err = fscrypt_decrypt_pagecache_blocks(page, PAGE_SIZE, 0);
+		if (err)
+			clear_buffer_uptodate(*wait_bh);
+	}
+
 	return err;
 }
 #endif
-- 
2.21.0.1020.gf2820cf01a-goog

