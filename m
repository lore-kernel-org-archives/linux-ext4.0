Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56140 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbeLFXKM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:10:12 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 17/23] nls: utf8: Integrate utf8 normalization code with utf8 charset
Date: Thu,  6 Dec 2018 18:08:57 -0500
Message-Id: <20181206230903.30011-18-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This patch integrates the utf8n patches with the NLS utf8 charset by
implementing the nls_ops operations and nls_charset table.  The
Normalization is done with NFKD, and Casefold is implemented using the
NFKD+CF algorithm, implemented by Olaf Weber and SGI.  The high level,
strcmp, strncmp functions are implemented on top of the same utf8 code.

Utf-8 with normalization is exposed as optional on top of the existing
utf8 charset, and disabled by default, to avoid changing the behavior of
existing nls_utf8 users.  To enable normalization, the specific
normalization type must be set at load_table() time.

Changes since RFC v2:
  - Integrate with NLS
  - Merge utf8n with nls_utf8.

Changes since RFC v1:
  - Change error return code from EIO to EINVAL. (Olaf Weber)
  - Fix issues with strncmp/strcmp.  (Olaf Weber)
  - Remove stack buffer in normalization/casefold. (Olaf Weber)
  - Include length parameter for second string on comparison functions.
  - Change length type to size_t.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/nls_utf8-core.c | 269 ++++++++++++++++++++++++++++++++++++++---
 fs/nls/nls_utf8-norm.c |   6 +
 fs/nls/utf8n.h         |   1 +
 include/linux/nls.h    |   8 ++
 4 files changed, 270 insertions(+), 14 deletions(-)

diff --git a/fs/nls/nls_utf8-core.c b/fs/nls/nls_utf8-core.c
index fe1ac5efaa37..1b7320bd9c34 100644
--- a/fs/nls/nls_utf8-core.c
+++ b/fs/nls/nls_utf8-core.c
@@ -6,10 +6,15 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
 #include <linux/nls.h>
 #include <linux/errno.h>
 
+#include "utf8n.h"
+
 static unsigned char identity[256];
+static struct nls_charset utf8_info;
 
 static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
 {
@@ -50,22 +55,257 @@ static unsigned char charset_toupper(const struct nls_table *table,
 	return identity[c];
 }
 
-static const struct nls_ops charset_ops = {
-	.lowercase = charset_toupper,
-	.uppercase = charset_tolower,
-	.uni2char = uni2char,
-	.char2uni = char2uni,
-};
+#ifdef CONFIG_NLS_UTF8_NORMALIZATION
+
+static int utf8_validate(const struct nls_table *charset,
+			 const unsigned char *str, size_t len)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+
+	if (utf8nlen(data, str, len) < 0)
+		return -1;
+	return 0;
+}
+
+static int utf8_strncmp(const struct nls_table *charset,
+			const unsigned char *str1, size_t len1,
+			const unsigned char *str2, size_t len2)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+	struct utf8cursor cur1, cur2;
+	int c1, c2;
+
+	if (utf8ncursor(&cur1, data, str1, len1) < 0)
+		goto invalid_seq;
+
+	if (utf8ncursor(&cur2, data, str2, len2) < 0)
+		goto invalid_seq;
+
+	do {
+		c1 = utf8byte(&cur1);
+		c2 = utf8byte(&cur2);
+
+		if (c1 < 0 || c2 < 0)
+			goto invalid_seq;
+		if (c1 != c2)
+			return 1;
+	} while (c1);
+
+	return 0;
+
+invalid_seq:
+	if(IS_STRICT_MODE(charset))
+		return -EINVAL;
+
+	/* Treat the sequence as a binary blob. */
+	if (len1 != len2)
+		return 1;
+
+	return !!memcmp(str1, str2, len1);
+}
+
+static int utf8_strncasecmp(const struct nls_table *charset,
+			    const unsigned char *str1, size_t len1,
+			    const unsigned char *str2, size_t len2)
+{
+	const struct utf8data *data = utf8nfkdicf(charset->version);
+	struct utf8cursor cur1, cur2;
+	int c1, c2;
+
+	if (utf8ncursor(&cur1, data, str1, len1) < 0)
+		goto invalid_seq;
+
+	if (utf8ncursor(&cur2, data, str2, len2) < 0)
+		goto invalid_seq;
+
+	do {
+		c1 = utf8byte(&cur1);
+		c2 = utf8byte(&cur2);
+
+		if (c1 < 0 || c2 < 0)
+			goto invalid_seq;
+		if (c1 != c2)
+			return 1;
+	} while (c1);
+
+	return 0;
+
+invalid_seq:
+	if(IS_STRICT_MODE(charset))
+		return -EINVAL;
+
+	/* Treat the sequence as a binary blob. */
+	if (len1 != len2)
+		return 1;
+
+	return !!memcmp(str1, str2, len1);
+}
+
+static int utf8_casefold_nfkdcf(const struct nls_table *charset,
+				const unsigned char *str, size_t len,
+				unsigned char *dest, size_t dlen)
+{
+	const struct utf8data *data = utf8nfkdicf(charset->version);
+	struct utf8cursor cur;
+	size_t nlen = 0;
+
+	if (utf8ncursor(&cur, data, str, len) < 0)
+		goto invalid_seq;
+
+	for (nlen = 0; nlen < dlen; nlen++) {
+		dest[nlen] = utf8byte(&cur);
+		if (!dest[nlen])
+			return nlen;
+		if (dest[nlen] == -1)
+			break;
+	}
+
+invalid_seq:
+	if (IS_STRICT_MODE(charset))
+		return -EINVAL;
+
+	/* Treat the sequence as a binary blob. */
+	memcpy(dest, str, len);
+	return len;
+}
+
+static int utf8_normalize_nfkd(const struct nls_table *charset,
+			       const unsigned char *str,
+			       size_t len, unsigned char *dest, size_t dlen)
+{
+	const struct utf8data *data = utf8nfkdi(charset->version);
+	struct utf8cursor cur;
+	ssize_t nlen = 0;
+
+	if (utf8ncursor(&cur, data, str, len) < 0)
+		goto invalid_seq;
 
-static struct nls_charset nls_charset;
-static struct nls_table table = {
-	.charset = &nls_charset,
-	.ops = &charset_ops,
+	for (nlen = 0; nlen < dlen; nlen++) {
+		dest[nlen] = utf8byte(&cur);
+		if (!dest[nlen])
+			return nlen;
+		if (dest[nlen] == -1)
+			break;
+	}
+
+invalid_seq:
+	if (IS_STRICT_MODE(charset))
+		return -EINVAL;
+
+	/* Treat the sequence as a binary blob. */
+	memcpy(dest, str, len);
+	return len;
+}
+
+static int utf8_parse_version(const char *version, unsigned int *maj,
+			      unsigned int *min, unsigned int *rev)
+{
+	substring_t args[3];
+	char version_string[12];
+	const struct match_token token[] = {
+		{1, "%d.%d.%d"},
+		{0, NULL}
+	};
+
+	strncpy(version_string, version, sizeof(version_string));
+
+	if (match_token(version_string, token, args) != 1)
+		return -EINVAL;
+
+	if (match_int(&args[0], maj) || match_int(&args[1], min) ||
+	    match_int(&args[2], rev))
+		return -EINVAL;
+
+	return 0;
+}
+#endif
+
+struct utf8_table {
+	struct nls_table tbl;
+	struct nls_ops ops;
 };
 
-static struct nls_charset nls_charset = {
+static void utf8_set_ops(struct utf8_table *utbl)
+{
+	utbl->ops.lowercase = charset_toupper;
+	utbl->ops.uppercase = charset_tolower;
+	utbl->ops.uni2char = uni2char;
+	utbl->ops.char2uni = char2uni;
+
+#ifdef CONFIG_NLS_UTF8_NORMALIZATION
+	utbl->ops.validate = utf8_validate;
+
+	if (IS_NORMALIZATION_TYPE_UTF8_NFKD(&utbl->tbl)) {
+		utbl->ops.normalize = utf8_normalize_nfkd;
+		utbl->ops.strncmp = utf8_strncmp;
+	}
+
+	if (IS_CASEFOLD_TYPE_UTF8_NFKDCF(&utbl->tbl)) {
+		utbl->ops.casefold = utf8_casefold_nfkdcf;
+		utbl->ops.strncasecmp = utf8_strncasecmp;
+	}
+#endif
+
+	utbl->tbl.ops = &utbl->ops;
+}
+
+static struct nls_table *utf8_load_table(const char *version, unsigned int flags)
+{
+	struct utf8_table *utbl = NULL;
+	unsigned int nls_version;
+
+#ifdef CONFIG_NLS_UTF8_NORMALIZATION
+	if (version) {
+		unsigned int maj, min, rev;
+
+		if (utf8_parse_version(version, &maj, &min, &rev) < 0)
+			return ERR_PTR(-EINVAL);
+
+		if (!utf8version_is_supported(maj, min, rev))
+			return ERR_PTR(-EINVAL);
+
+		nls_version = UNICODE_AGE(maj, min, rev);
+	} else {
+		nls_version = utf8version_latest();
+		printk(KERN_WARNING"UTF-8 version not specified. "
+		       "Assuming latest supported version (%d.%d.%d).",
+		       (nls_version >> 16) & 0xff, (nls_version >> 8) & 0xff,
+		       (nls_version & 0xff));
+	}
+#else
+	nls_version = 0;
+#endif
+
+	utbl = kzalloc(sizeof(struct utf8_table), GFP_KERNEL);
+	if (!utbl)
+		return ERR_PTR(-ENOMEM);
+
+	utbl->tbl.charset = &utf8_info;
+	utbl->tbl.version = nls_version;
+	utbl->tbl.flags = flags;
+	utf8_set_ops(utbl);
+
+	utbl->tbl.next = utf8_info.tables;
+	utf8_info.tables = &utbl->tbl;
+
+	return &utbl->tbl;
+}
+
+static void utf8_cleanup_tables(void)
+{
+	struct nls_table *tmp, *tbl = utf8_info.tables;
+
+	while (tbl) {
+		tmp = tbl;
+		tbl = tbl->next;
+		kfree(tmp);
+	}
+	utf8_info.tables = NULL;
+}
+
+static struct nls_charset utf8_info = {
 	.charset = "utf8",
-	.tables = &table,
+	.load_table = utf8_load_table,
 };
 
 static int __init init_nls_utf8(void)
@@ -74,12 +314,13 @@ static int __init init_nls_utf8(void)
 	for (i=0; i<256; i++)
 		identity[i] = i;
 
-        return register_nls(&nls_charset);
+        return register_nls(&utf8_info);
 }
 
 static void __exit exit_nls_utf8(void)
 {
-        unregister_nls(&nls_charset);
+	unregister_nls(&utf8_info);
+	utf8_cleanup_tables();
 }
 
 module_init(init_nls_utf8)
diff --git a/fs/nls/nls_utf8-norm.c b/fs/nls/nls_utf8-norm.c
index 64c3cc74a2ca..abee8b376a87 100644
--- a/fs/nls/nls_utf8-norm.c
+++ b/fs/nls/nls_utf8-norm.c
@@ -38,6 +38,12 @@ int utf8version_is_supported(u8 maj, u8 min, u8 rev)
 }
 EXPORT_SYMBOL(utf8version_is_supported);
 
+int utf8version_latest()
+{
+	return utf8vers;
+}
+EXPORT_SYMBOL(utf8version_latest);
+
 /*
  * UTF-8 valid ranges.
  *
diff --git a/fs/nls/utf8n.h b/fs/nls/utf8n.h
index f60827663503..b4697f9bfbab 100644
--- a/fs/nls/utf8n.h
+++ b/fs/nls/utf8n.h
@@ -32,6 +32,7 @@
 
 /* Highest unicode version supported by the data tables. */
 extern int utf8version_is_supported(u8 maj, u8 min, u8 rev);
+extern int utf8version_latest(void);
 
 /*
  * Look for the correct const struct utf8data for a unicode version.
diff --git a/include/linux/nls.h b/include/linux/nls.h
index aab60d4858ee..aee5cbfc07c6 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -186,6 +186,14 @@ NLS_CASEFOLD_FUNCS(ALL, TOUPPER, NLS_CASEFOLD_TYPE_TOUPPER)
 NLS_CASEFOLD_FUNCS(ASCII, TOUPPER, NLS_ASCII_CASEFOLD_TOUPPER)
 NLS_CASEFOLD_FUNCS(ASCII, TOLOWER, NLS_ASCII_CASEFOLD_TOLOWER)
 
+/* UTF-8 */
+
+#define NLS_UTF8_NORMALIZATION_TYPE_NFKD NLS_NORMALIZATION_TYPE(1)
+#define NLS_UTF8_CASEFOLD_TYPE_NFKDCF	 NLS_CASEFOLD_TYPE(1)
+
+NLS_NORMALIZATION_FUNCS(UTF8, NFKD, NLS_UTF8_NORMALIZATION_TYPE_NFKD)
+NLS_CASEFOLD_FUNCS(UTF8, NFKDCF, NLS_UTF8_CASEFOLD_TYPE_NFKDCF)
+
 /* nls_base.c */
 extern int __register_nls(struct nls_charset *, struct module *);
 extern int unregister_nls(struct nls_charset *);
-- 
2.20.0.rc2
