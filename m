From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4/4] f2fs: don't bother checking for encryption key in ->write_iter()
Date: Mon, 22 May 2017 17:39:45 -0700
Message-ID: <20170523003945.14279-5-ebiggers3@gmail.com>
References: <20170523003945.14279-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35720 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934067AbdEWAkJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 May 2017 20:40:09 -0400
In-Reply-To: <20170523003945.14279-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Since only an open file can be written to, and we only allow open()ing
an encrypted file when its key is available, there is no need to check
for the key again before permitting each ->write_iter().

This code was also broken in that it wouldn't actually have failed if
the key was in fact unavailable.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ff4db3efc0ac..3ccc63089a47 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2318,11 +2318,6 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct blk_plug plug;
 	ssize_t ret;
 
-	if (f2fs_encrypted_inode(inode) &&
-				!fscrypt_has_encryption_key(inode) &&
-				fscrypt_get_encryption_info(inode))
-		return -EACCES;
