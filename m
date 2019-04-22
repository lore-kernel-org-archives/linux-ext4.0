Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEB3C10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9720F20896
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555967521;
	bh=XhXEUx+sPz0MP6EXXZTQA9AVbFjvdvpUsUYOYm4cbkc=;
	h=From:To:Subject:Date:List-ID:From;
	b=0mkzmFUgghCJ7W7yH+WWmjfQfzVWO8c0Bkn6Cm7QIaOsO9g1DjpkIjUjD6ALd3fTn
	 De2EkXZmzCzL+/Zldzo1ppw+tMLhomDoCdtgdVqFalx0tk2KeN9CZl4b8G+SbGWT3k
	 l1s5XTajdHFUZ6vwh/oDyzA6A4lXrY3gkvv7CunY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfDVVMB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbfDVVMB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 17:12:01 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BAC320896
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 21:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555967520;
        bh=XhXEUx+sPz0MP6EXXZTQA9AVbFjvdvpUsUYOYm4cbkc=;
        h=From:To:Subject:Date:From;
        b=jgQr5Zxm8XOmVTw1LNr0vRYeFz4jc7arXZZ5Agfj5/uVgdMyshQPffu4CJTDb5IEe
         xcU08Y6DOoPeRP0qcOlxCi/M05rJ/YjsCHFdxlEt1NIjVb41SoGc1SqOXyiVbFEFqR
         TJa9w9q2deluRlcCpiACR3qIZn8zK3CVUkrY10Ko=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] libext2fs: remove unused variable 'old_flags'
Date:   Mon, 22 Apr 2019 14:11:36 -0700
Message-Id: <20190422211136.188952-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In ext2fs_write_inode2(), the 'old_flags' variable is never used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/ext2fs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 2a4be739..75df418d 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -903,7 +903,6 @@ errcode_t ext2fs_write_inode2(ext2_filsys fs, ext2_ino_t ino,
 		return retval;
 
 	if (bufsize < length) {
-		int old_flags = fs->flags;
 		retval = ext2fs_read_inode2(fs, ino,
 					    (struct ext2_inode *)w_inode,
 					    length, READ_INODE_NOCSUM);
-- 
2.21.0.593.g511ec345e18-goog

