Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55634 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbeLFWFG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 17:05:06 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 07/23] nls: Implement NLS_STRICT_MODE flag
Date: Thu,  6 Dec 2018 17:04:13 -0500
Message-Id: <20181206220429.10722-8-krisman@collabora.com>
In-Reply-To: <20181206220429.10722-1-krisman@collabora.com>
References: <20181206220429.10722-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

The flag NLS_STRICT_MODE indicates whether NLS should reject invalid
characters or ignore them.  Support for this relies on the .validate()
hook, which is implemented by each charset and states whether a given
string is valid within that charset.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/nls_core.c   | 11 +++++++++++
 include/linux/nls.h | 25 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/nls/nls_core.c b/fs/nls/nls_core.c
index 20e00a8b968c..49a15bb2174f 100644
--- a/fs/nls/nls_core.c
+++ b/fs/nls/nls_core.c
@@ -20,6 +20,14 @@ extern struct nls_charset default_charset;
 static struct nls_charset *charsets = &default_charset;
 static DEFINE_SPINLOCK(nls_lock);
 
+static int nls_validate_flags(struct nls_table *table, unsigned int flags)
+{
+	if (flags & NLS_STRICT_MODE && !table->ops->validate)
+		return -1;
+
+	return 0;
+}
+
 static struct nls_table *nls_load_table(struct nls_charset *charset,
 					const char *version,
 					unsigned int flags)
@@ -37,6 +45,9 @@ static struct nls_table *nls_load_table(struct nls_charset *charset,
 	if (IS_ERR(tbl))
 		return tbl;
 
+	if (nls_validate_flags(tbl, flags) < 0)
+		return ERR_PTR(-EINVAL);
+
 	tbl->flags = flags;
 	return tbl;
 }
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 91524bb4477b..9f61015a54bf 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -22,10 +22,22 @@ typedef u16 wchar_t;
 /* Arbitrary Unicode character */
 typedef u32 unicode_t;
 
+struct nls_table;
+
 struct nls_ops {
 	int (*uni2char) (wchar_t uni, unsigned char *out, int boundlen);
 	int (*char2uni) (const unsigned char *rawstring, int boundlen,
 			 wchar_t *uni);
+	/**
+	 * @validate:
+	 *
+	 * Returns 0 if the argument is a valid string in this charset.
+	 * Otherwise, return non-zero.
+	 *
+	 * This is required iff the charset supports strict mode.
+	 **/
+	int (*validate)(const struct nls_table *charset,
+			const unsigned char *str, size_t len);
 };
 
 struct nls_table {
@@ -59,6 +71,13 @@ enum utf16_endian {
 	UTF16_BIG_ENDIAN
 };
 
+#define NLS_STRICT_MODE			0x00000001
+
+static inline int IS_STRICT_MODE(const struct nls_table *charset)
+{
+	return (charset->flags & NLS_STRICT_MODE);
+}
+
 /* nls_base.c */
 extern int __register_nls(struct nls_charset *, struct module *);
 extern int unregister_nls(struct nls_charset *);
@@ -90,6 +109,12 @@ static inline int nls_char2uni(const struct nls_table *table,
 	return table->ops->char2uni(rawstring, boundlen, uni);
 }
 
+static inline int nls_validate(const struct nls_table *t, const unsigned char *str,
+			       const size_t len)
+{
+	return t->ops->validate(t, str, len);
+}
+
 static inline const char *nls_charset_name(const struct nls_table *table)
 {
 	return table->charset->charset;
-- 
2.20.0.rc2
