Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45538 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeIYECK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:10 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 11/25] nls: ascii: Support validation and normalization operations
Date: Mon, 24 Sep 2018 17:56:41 -0400
Message-Id: <20180924215655.3676-12-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

validation is trivial.  Any byte that has the MSB set is an invalid
sequence.

Casefold can be implemented with uppercase or lowercase, and we have no
specification on that. Callers should be safe using either of them, as
long as it doesn't change.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/nls_ascii.c  | 50 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nls.h |  8 ++++++++
 2 files changed, 58 insertions(+)

diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 2f4826478d3d..079a1574c19d 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/nls.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 
 static const wchar_t charset2uni[256] = {
 	/* 0x00*/
@@ -117,6 +118,8 @@ static const unsigned char charset2upper[256] = {
 	0x58, 0x59, 0x5a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, /* 0x78-0x7f */
 };
 
+#define VALID_ASCII(c) (c < 128)
+
 static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
@@ -142,6 +145,16 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static int ascii_validate(const struct nls_table *table,
+			  const unsigned char *str, size_t len)
+{
+	int i;
+	for (i = 0; i < len && str[i]; i++)
+		if (!VALID_ASCII(str[i]))
+			return -1;
+	return 0;
+}
+
 static unsigned char charset_tolower(const struct nls_table *table,
 				     unsigned int c){
 	return charset2lower[c];
@@ -152,11 +165,36 @@ static unsigned char charset_toupper(const struct nls_table *table,
 	return charset2upper[c];
 }
 
+static int ascii_casefold(const struct nls_table *charset,
+			  const unsigned char *str, size_t len,
+			  unsigned char *dest, size_t dlen)
+{
+	unsigned int i;
+
+	if (dlen < len)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		if (IS_STRICT_MODE(charset) && !VALID_ASCII(str[i]))
+			return -EINVAL;
+
+		if (IS_CASEFOLD_TYPE_ASCII_TOLOWER(charset))
+			dest[i] = charset_tolower(charset, str[i]);
+		else
+			dest[i] = charset_toupper(charset, str[i]);
+	}
+	dest[len] = '\0';
+
+	return len;
+}
+
 static const struct nls_ops charset_ops = {
+	.validate = ascii_validate,
 	.lowercase = charset_toupper,
 	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
+	.casefold = ascii_casefold,
 };
 
 static struct nls_charset nls_charset;
@@ -165,9 +203,21 @@ static struct nls_table table = {
 	.ops = &charset_ops,
 };
 
+struct nls_table *ascii_load_table(const char *version, unsigned int flags)
+{
+	if (flags & ~(NLS_STRICT_MODE) ||
+	    (flags & NLS_NORMALIZATION_TYPE_MASK) != NLS_NORMALIZATION_TYPE_PLAIN)
+		return ERR_PTR(-EINVAL);
+
+	table.flags = flags;
+	return &table;
+}
+
+
 static struct nls_charset nls_charset = {
 	.charset = "ascii",
 	.tables = &table,
+	.load_table = ascii_load_table,
 };
 
 static int __init init_nls_ascii(void)
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 44a06a9c69e7..aab60d4858ee 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -178,6 +178,14 @@ IS_CASEFOLD_TYPE_##charset##_##type(const struct nls_table *c)		\
 NLS_NORMALIZATION_FUNCS(ALL, PLAIN, NLS_NORMALIZATION_TYPE_PLAIN)
 NLS_CASEFOLD_FUNCS(ALL, TOUPPER, NLS_CASEFOLD_TYPE_TOUPPER)
 
+/* ASCII */
+
+#define NLS_ASCII_CASEFOLD_TOUPPER NLS_CASEFOLD_TYPE_TOUPPER
+#define NLS_ASCII_CASEFOLD_TOLOWER NLS_CASEFOLD_TYPE(1)
+
+NLS_CASEFOLD_FUNCS(ASCII, TOUPPER, NLS_ASCII_CASEFOLD_TOUPPER)
+NLS_CASEFOLD_FUNCS(ASCII, TOLOWER, NLS_ASCII_CASEFOLD_TOLOWER)
+
 /* nls_base.c */
 extern int __register_nls(struct nls_charset *, struct module *);
 extern int unregister_nls(struct nls_charset *);
-- 
2.19.0
