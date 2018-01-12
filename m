From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 11/13] fscrypt: Introduce charset-based matching functions
Date: Fri, 12 Jan 2018 05:12:32 -0200
Message-ID: <20180112071234.29470-12-krisman@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43090 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754316AbeALHOM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 02:14:12 -0500
In-Reply-To: <20180112071234.29470-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 include/linux/fscrypt.h         |  1 +
 include/linux/fscrypt_notsupp.h | 16 ++++++++++++++++
 include/linux/fscrypt_supp.h    | 27 +++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 08b4b40c5aa8..8ca010ef2871 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -21,6 +21,7 @@
 #include <linux/dcache.h>
 #include <crypto/skcipher.h>
 #include <uapi/linux/fs.h>
+#include <linux/charsets.h>
 
 #define FS_CRYPTO_BLOCK_SIZE		16
 
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 63e58808519a..2227db69d6ba 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -160,6 +160,22 @@ static inline bool fscrypt_match_name(const struct fscrypt_name *fname,
 	return !memcmp(de_name, fname->disk_name.name, fname->disk_name.len);
 }
 
+static inline bool fscrypt_charset_match_name(const struct fscrypt_name *fname,
+					      const struct charset *charset,
+					      const u8 *de_name,
+					      u32 de_name_len, bool ignorecase)
+{
+	if (!ignorecase) {
+		return !charset_strncmp(charset, (char *) de_name,
+					fname->disk_name.name,
+					fname->disk_name.len);
+	}
+
+	return !charset_strncasecmp(charset, (char *) de_name,
+				    fname->disk_name.name,
+				    fname->disk_name.len);
+}
+
 /* bio.c */
 static inline void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx,
 					     struct bio *bio)
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index cf9e9fc02f0a..4e6f25521b99 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -138,6 +138,33 @@ static inline bool fscrypt_match_name(const struct fscrypt_name *fname,
 	return !memcmp(de_name, fname->disk_name.name, fname->disk_name.len);
 }
 
+static inline bool fscrypt_charset_match_name(const struct fscrypt_name *fname,
+					      const struct charset *charset,
+					      const u8 *de_name,
+					      u32 de_name_len, bool ignorecase)
+{
+	if (unlikely(!fname->disk_name.name)) {
+		const struct fscrypt_digested_name *n =
+			(const void *)fname->crypto_buf.name;
+		if (WARN_ON_ONCE(fname->usr_fname->name[0] != '_'))
+			return false;
+		if (de_name_len <= FSCRYPT_FNAME_MAX_UNDIGESTED_SIZE)
+			return false;
+		return !memcmp(FSCRYPT_FNAME_DIGEST(de_name, de_name_len),
+			       n->digest, FSCRYPT_FNAME_DIGEST_SIZE);
+	}
+
+	if (!ignorecase) {
+		return !charset_strncmp(charset, (char *) de_name,
+					fname->disk_name.name,
+					fname->disk_name.len);
+	}
+
+	return !charset_strncasecmp(charset, (char *) de_name,
+				    fname->disk_name.name,
+				    fname->disk_name.len);
+}
+
 /* bio.c */
 extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *, struct bio *);
 extern void fscrypt_pullback_bio_page(struct page **, bool);
-- 
2.15.1
