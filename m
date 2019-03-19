Return-Path: <SRS0=iy/Z=RW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4E1C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 20:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E082083D
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 20:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553027942;
	bh=Ll1HfZsyYwSDTpX3gvk16wUOdeITMs0LZjM2G7agXAw=;
	h=From:To:Subject:Date:List-ID:From;
	b=E8Ehes1ojSAwvUxk4uybvPzz6gLl5kgGf9igdJa002ArvAF/PJqi2waY1j9QC95ft
	 TA1UTaXdoXSNngTGHEb39FF7D1UvMDloc9rJ03SW0dong88pWlqJREF/Mn69AQc5Ao
	 MXOcyNqEP/mA5F0k3OFAPkXdVla/zR2SrHJ61fFk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfCSUjA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfCSUi7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Mar 2019 16:38:59 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A00E20700
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2019 20:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553027939;
        bh=Ll1HfZsyYwSDTpX3gvk16wUOdeITMs0LZjM2G7agXAw=;
        h=From:To:Subject:Date:From;
        b=MiKQSub2Zho9fNljf3jZA6yjEkKS+AKTdV5LAkAD3g/L1Rl+5gwOIjeUuUFsAJcIt
         TbL7/mB9b7YhBxz3LEts1nVQAVSgrwypYoRXdBqkXOHGPI3+scNu9Qe+s4RfXeaA2t
         dbWQvxDeoYpqEVxJBj0uYW9UBhUSSLV2asPXXnqQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: remove incorrect comment for NEXT_ORPHAN()
Date:   Tue, 19 Mar 2019 13:38:18 -0700
Message-Id: <20190319203818.34159-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The comment above NEXT_ORPHAN() was meant for ext4_encrypted_inode(),
which was moved by commit a7550b30ab70 ("ext4 crypto: migrate into vfs's
crypto engine") but the comment was accidentally left in place.  Since
ext4_encrypted_inode() has now been removed, just remove the comment.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ext4.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fac..2a2e6ed9aab4f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1592,9 +1592,6 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_SB(sb)	(sb)
 #endif
 
-/*
- * Returns true if the inode is inode is encrypted
- */
 #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
 
 /*
-- 
2.21.0.225.g810b269d1ac-goog

