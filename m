From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v4 1/4] ext4 crypto: add missing locking for keyring_key access
Date: Wed, 16 Dec 2015 17:46:05 -0500
Message-ID: <1450305968-21785-2-git-send-email-tytso@mit.edu>
References: <1450305968-21785-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50786 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbbLPWqY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Dec 2015 17:46:24 -0500
In-Reply-To: <1450305968-21785-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_key.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index c5882b3..9a16d1e 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -213,9 +213,11 @@ retry:
 		res = -ENOKEY;
 		goto out;
 	}
+	down_read(&keyring_key->sem);
 	ukp = user_key_payload(keyring_key);
 	if (ukp->datalen != sizeof(struct ext4_encryption_key)) {
 		res = -EINVAL;
+		up_read(&keyring_key->sem);
 		goto out;
 	}
 	master_key = (struct ext4_encryption_key *)ukp->data;
@@ -226,10 +228,12 @@ retry:
 			    "ext4: key size incorrect: %d\n",
 			    master_key->size);
 		res = -ENOKEY;
+		up_read(&keyring_key->sem);
 		goto out;
 	}
 	res = ext4_derive_key_aes(ctx.nonce, master_key->raw,
 				  raw_key);
+	up_read(&keyring_key->sem);
 	if (res)
 		goto out;
 got_key:
-- 
2.5.0

