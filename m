From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4 crypto: check for too-short encrypted file names
Date: Sat, 18 Jul 2015 08:50:30 -0400
Message-ID: <1437223830-28205-2-git-send-email-tytso@mit.edu>
References: <1437223830-28205-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47737 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbbGRMug (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2015 08:50:36 -0400
In-Reply-To: <1437223830-28205-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An encrypted file name should never be shorter than an 16 bytes, the
AES block size.  The 3.10 crypto layer will oops and crash the kernel
if ciphertext shorter than the block size is passed to it.

Fortunately, in modern kernels the crypto layer will not crash the
kernel in this scenario, but nevertheless, it represents a corrupted
directory, and we should detect it and mark the file system as
corrupted so that e2fsck can fix this.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_fname.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index 7dc4eb5..86ee996 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -329,6 +329,10 @@ int _ext4_fname_disk_to_usr(struct inode *inode,
 			return oname->len;
 		}
 	}
+	if (iname->len < EXT4_CRYPTO_BLOCK_SIZE) {
+		EXT4_ERROR_INODE(inode, "encrypted inode too small");
+		return -EUCLEAN;
+	}
 	if (EXT4_I(inode)->i_crypt_info)
 		return ext4_fname_decrypt(inode, iname, oname);
 
-- 
2.3.0

