From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] ext4: Fix return code checking of crypto_alloc_ablkcipher()
Date: Sat,  2 Jan 2016 23:11:59 +0100
Message-ID: <1451772719-2256-1-git-send-email-richard@nod.at>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This function does never return NULL, IS_ERR() is sufficent.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ext4/crypto_key.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index c5882b3..436ea2a 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -234,8 +234,8 @@ retry:
 		goto out;
 got_key:
 	ctfm = crypto_alloc_ablkcipher(cipher_str, 0, 0);
-	if (!ctfm || IS_ERR(ctfm)) {
-		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
+	if (IS_ERR(ctfm)) {
+		res = PTR_ERR(ctfm);
 		printk(KERN_DEBUG
 		       "%s: error %d (inode %u) allocating crypto tfm\n",
 		       __func__, res, (unsigned) inode->i_ino);
-- 
2.5.0
