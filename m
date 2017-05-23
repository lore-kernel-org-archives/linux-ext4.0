From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/4] ubifs: don't bother checking for encryption key in ->mmap()
Date: Mon, 22 May 2017 17:39:44 -0700
Message-ID: <20170523003945.14279-4-ebiggers3@gmail.com>
References: <20170523003945.14279-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36561 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934067AbdEWAkH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 May 2017 20:40:07 -0400
In-Reply-To: <20170523003945.14279-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Since only an open file can be mmap'ed, and we only allow open()ing an
encrypted file when its key is available, there is no need to check for
the key again before permitting each mmap().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/file.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 2cda3d67e2d0..7dc58bda279b 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1607,15 +1607,6 @@ static const struct vm_operations_struct ubifs_file_vm_ops = {
 static int ubifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int err;
-	struct inode *inode = file->f_mapping->host;
