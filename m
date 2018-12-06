Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56082 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbeLFXJb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:09:31 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 06/23] nls: Add support for multiple versions of an encoding
Date: Thu,  6 Dec 2018 18:08:46 -0500
Message-Id: <20181206230903.30011-7-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This allows a user to request a specific version of an encoding, like
the version 10.0.0 of Unicode encoded in utf8.

Supporting specific versions of encodings is important to ensure
stability of names in filesystems, specially when doing transformations
like casefold and normalization.  Even for unicode, where defined
code-points are stable, there is instability for code points that
weren't defined on a previous version, so the user might want to use an
older version of the encoding to ensure the encoding is exact.

Not every NLS charset supports this feature.  It doesn't make sense for
many of them, like ASCII.  Others just don't implement it yet, and never
will.  In those cases, the interface allows the caller to get the
un-versioned charset, which is the same original behavior as if this
patch weren't applied.  A user that is not interested in a specific
version can also ask for a versioned charset without specifying the
version, and in this case, NLS will return the latest version available
of that charset.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/nls_core.c   | 45 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/nls.h |  8 ++++++++
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/fs/nls/nls_core.c b/fs/nls/nls_core.c
index 200a7f8165e6..20e00a8b968c 100644
--- a/fs/nls/nls_core.c
+++ b/fs/nls/nls_core.c
@@ -19,10 +19,26 @@
 extern struct nls_charset default_charset;
 static struct nls_charset *charsets = &default_charset;
 static DEFINE_SPINLOCK(nls_lock);
-static struct nls_table *nls_load_table(struct nls_charset *charset)
+
+static struct nls_table *nls_load_table(struct nls_charset *charset,
+					const char *version,
+					unsigned int flags)
 {
-	/* For now, return the default table, which is the first one found. */
-	return charset->tables;
+	struct nls_table *tbl;
+
+	/* If there is no load_table hook, only 1 table is supported and
+	 * it must have been loaded statically.
+	 */
+	if (charset->load_table)
+		tbl = charset->load_table(version, flags);
+	else
+		tbl = charset->tables;
+
+	if (IS_ERR(tbl))
+		return tbl;
+
+	tbl->flags = flags;
+	return tbl;
 }
 
 int __register_nls(struct nls_charset *nls, struct module *owner)
@@ -85,21 +101,36 @@ static struct nls_charset *find_nls(const char *charset)
 	return nls;
 }
 
-struct nls_table *load_nls(char *charset)
+struct nls_table *load_nls_version(const char *charset, const char *version,
+				   unsigned int flags)
 {
 	struct nls_charset *nls_charset;
 
 	nls_charset = try_then_request_module(find_nls(charset),
 					      "nls_%s", charset);
-	if (!IS_ERR(nls_charset))
+	if (IS_ERR(nls_charset))
+		return ERR_PTR(-EINVAL);
+
+	return nls_load_table(nls_charset, version, flags);
+}
+EXPORT_SYMBOL(load_nls_version);
+
+struct nls_table *load_nls(char *charset)
+{
+	struct nls_table *table = load_nls_version(charset, NULL, 0);
+
+	/* Pre-versioned load_nls() didn't return error pointers. Let's
+	 * keep the abi for now to prevent breakage.
+	 */
+	if (IS_ERR(table))
 		return NULL;
 
-	return nls_load_table(nls_charset);
+	return table;
 }
 
 void unload_nls(struct nls_table *nls)
 {
-	if (nls)
+	if (!IS_ERR_OR_NULL(nls))
 		module_put(nls->charset->owner);
 }
 
diff --git a/include/linux/nls.h b/include/linux/nls.h
index cdc95cd9e5d4..91524bb4477b 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -30,6 +30,9 @@ struct nls_ops {
 
 struct nls_table {
 	const struct nls_charset *charset;
+	unsigned int version;
+	unsigned int flags;
+
 	const struct nls_ops *ops;
 	const unsigned char *charset2lower;
 	const unsigned char *charset2upper;
@@ -42,6 +45,8 @@ struct nls_charset {
 	struct module *owner;
 	struct nls_table *tables;
 	struct nls_charset *next;
+	struct nls_table *(*load_table)(const char *version,
+					unsigned int flags);
 };
 
 /* this value hold the maximum octet of charset */
@@ -58,6 +63,9 @@ enum utf16_endian {
 extern int __register_nls(struct nls_charset *, struct module *);
 extern int unregister_nls(struct nls_charset *);
 extern struct nls_table *load_nls(char *);
+extern struct nls_table *load_nls_version(const char *charset,
+					  const char *version,
+					  unsigned int flags);
 extern void unload_nls(struct nls_table *);
 extern struct nls_table *load_nls_default(void);
 #define register_nls(nls) __register_nls((nls), THIS_MODULE)
-- 
2.20.0.rc2
