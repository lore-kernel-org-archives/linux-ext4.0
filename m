From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/8] ext4 crypto: clean up error handling in ext4_fname_setup_filename
Date: Thu, 28 May 2015 19:47:46 -0400
Message-ID: <1432856867-5710-7-git-send-email-tytso@mit.edu>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35479 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbbE1Xs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 19:48:27 -0400
In-Reply-To: <1432856867-5710-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a potential memory leak where fname->crypto_buf.name wouldn't get
freed in some error paths, and also make the error handling easier to
understand/audit.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/crypto_fname.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index 29a2dc9..23af41f 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -401,7 +401,7 @@ int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
 	      ((iname->name[1] == '.') && (iname->len == 2))))) {
 		fname->disk_name.name = (unsigned char *) iname->name;
 		fname->disk_name.len = iname->len;
-		goto out;
+		return 0;
 	}
 	ret = ext4_get_encryption_info(dir);
 	if (ret)
@@ -411,19 +411,16 @@ int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
 		ret = ext4_fname_crypto_alloc_buffer(dir, iname->len,
 						     &fname->crypto_buf);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ret = ext4_fname_encrypt(dir, iname, &fname->crypto_buf);
 		if (ret < 0)
-			goto out;
+			goto errout;
 		fname->disk_name.name = fname->crypto_buf.name;
 		fname->disk_name.len = fname->crypto_buf.len;
-		ret = 0;
-		goto out;
-	}
-	if (!lookup) {
-		ret = -EACCES;
-		goto out;
+		return 0;
 	}
+	if (!lookup)
+		return -EACCES;
 
 	/* We don't have the key and we are doing a lookup; decode the
 	 * user-supplied name
@@ -431,19 +428,17 @@ int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
 	if (iname->name[0] == '_')
 		bigname = 1;
 	if ((bigname && (iname->len != 33)) ||
-	    (!bigname && (iname->len > 43))) {
-		ret = -ENOENT;
-	}
+	    (!bigname && (iname->len > 43)))
+		return -ENOENT;
+
 	fname->crypto_buf.name = kmalloc(32, GFP_KERNEL);
-	if (fname->crypto_buf.name == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (fname->crypto_buf.name == NULL)
+		return -ENOMEM;
 	ret = digest_decode(iname->name + bigname, iname->len - bigname,
 			    fname->crypto_buf.name);
 	if (ret < 0) {
 		ret = -ENOENT;
-		goto out;
+		goto errout;
 	}
 	fname->crypto_buf.len = ret;
 	if (bigname) {
@@ -453,8 +448,10 @@ int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
 		fname->disk_name.name = fname->crypto_buf.name;
 		fname->disk_name.len = fname->crypto_buf.len;
 	}
-	ret = 0;
-out:
+	return 0;
+errout:
+	kfree(fname->crypto_buf.name);
+	fname->crypto_buf.name = NULL;
 	return ret;
 }
 
-- 
2.3.0

