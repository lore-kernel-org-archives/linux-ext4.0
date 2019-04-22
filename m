Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A230C10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C35972054F
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555968010;
	bh=+mmdZUKOMxVhQJW5HXNQlu9PL8Z+ucPtUohcXt8Ex88=;
	h=From:To:Subject:Date:List-ID:From;
	b=UGfxIjbNRgs5iV8VmWv4jaLj7ixZBPH1bg6dwPe+VRY6fRWOY8W+6auMZTMcjlqcW
	 Mt1RdNp16RBel9fTWas9iThyFlAy907N6ZoPGZ5TDGRrVKTqJuekSMautKdL9FZsKS
	 H2vh+bPWonWbPhu+lwGpTq3uFzqwZOtJ1hL1kkfo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfDVVUK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbfDVVUK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 17:20:10 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A452B2054F
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555968009;
        bh=+mmdZUKOMxVhQJW5HXNQlu9PL8Z+ucPtUohcXt8Ex88=;
        h=From:To:Subject:Date:From;
        b=e2vxHbKN56O7QAkAZzHvOs1uMj3EJcKvD40bKVLKspEqbcR0fC6iBjn7rUk40t5k7
         ylFKxodrzN1u2GAYoeatGlaIFgGUqyLrrgIyPRNoUkjPP2LK5RdZmdh2EaQnoAD3na
         YbDdST/mo+gEMbWzi+tkuA2tLa8OhJMYmUlBp5yU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] debugfs: remove unused variable 'tmp_inode'
Date:   Mon, 22 Apr 2019 14:19:50 -0700
Message-Id: <20190422211950.196986-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In parse_inode_csum(), the outer 'tmp_inode' variable is never used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 debugfs/set_fields.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index a7dd34f7..31356fd0 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -674,7 +674,6 @@ static errcode_t parse_inode_csum(struct field_set_info *info, char *field,
 	errcode_t	retval = 0;
 	__u32		crc;
 	int		is_large_inode = 0;
-	struct ext2_inode_large *tmp_inode;
 
 	if (strcmp(arg, "calc") == 0) {
 		size_t sz = EXT2_INODE_SIZE(current_fs->super);
-- 
2.21.0.593.g511ec345e18-goog

