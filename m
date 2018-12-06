Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56078 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbeLFXJa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:09:30 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 05/23] nls: Split struct nls_charset from struct nls_table
Date: Thu,  6 Dec 2018 18:08:45 -0500
Message-Id: <20181206230903.30011-6-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

In order to support multiple versions of the same encoding, we want to
split the charset registering data, which enrolls it with the NLS
subsystem and is valid for all versions of the encoding, from the
version specific data, that is actually going to be returned when the
caller loads an NLS charset.

With the exception of the following files (files declaration and default
charset), which were edited by hand, the other files were generated with
the following Coccinelle patch:

Files edited by hand:
  - fs/nls/nls_base.c
  - include/linux/nls.h
  - fs/nls/nls_default.c

<smpl>
@nlstable@
identifier p;
expression charset_str;
@@

static struct nls_table p = {
-	.charset = charset_str,
};

@createops@
identifier nlstable.p;
expression nlstable.charset_str;

@@

+static struct nls_charset nls_charset;

static struct nls_table p = {
+      .charset = &nls_charset,
};
+
+static struct nls_charset nls_charset = {
+	.charset = charset_str,
+	.tables = &p,
+};

@@
expression A;
@@
? return
- register_nls(A);
+ register_nls(&nls_charset);

@@
expression A;
@@

- unregister_nls(A);
+ unregister_nls(&nls_charset);

@mvalias@
identifier p;
expression alias_str;
@@
static struct nls_table p = {
-	.alias = alias_str,
};

@@
expression mvalias.alias_str;
@@
static struct nls_charset nls_charset = {
+	.alias = alias_str,
};

</smpl>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/nls/mac-celtic.c     | 12 ++++++++---
 fs/nls/mac-centeuro.c   | 12 ++++++++---
 fs/nls/mac-croatian.c   | 12 ++++++++---
 fs/nls/mac-cyrillic.c   | 12 ++++++++---
 fs/nls/mac-gaelic.c     | 12 ++++++++---
 fs/nls/mac-greek.c      | 12 ++++++++---
 fs/nls/mac-iceland.c    | 12 ++++++++---
 fs/nls/mac-inuit.c      | 12 ++++++++---
 fs/nls/mac-roman.c      | 12 ++++++++---
 fs/nls/mac-romanian.c   | 12 ++++++++---
 fs/nls/mac-turkish.c    | 12 ++++++++---
 fs/nls/nls_ascii.c      | 12 ++++++++---
 fs/nls/nls_core.c       | 48 +++++++++++++++++++++++++++--------------
 fs/nls/nls_cp1250.c     | 12 ++++++++---
 fs/nls/nls_cp1251.c     | 12 ++++++++---
 fs/nls/nls_cp1255.c     | 14 ++++++++----
 fs/nls/nls_cp437.c      | 12 ++++++++---
 fs/nls/nls_cp737.c      | 12 ++++++++---
 fs/nls/nls_cp775.c      | 12 ++++++++---
 fs/nls/nls_cp850.c      | 12 ++++++++---
 fs/nls/nls_cp852.c      | 12 ++++++++---
 fs/nls/nls_cp855.c      | 12 ++++++++---
 fs/nls/nls_cp857.c      | 12 ++++++++---
 fs/nls/nls_cp860.c      | 12 ++++++++---
 fs/nls/nls_cp861.c      | 12 ++++++++---
 fs/nls/nls_cp862.c      | 12 ++++++++---
 fs/nls/nls_cp863.c      | 12 ++++++++---
 fs/nls/nls_cp864.c      | 12 ++++++++---
 fs/nls/nls_cp865.c      | 12 ++++++++---
 fs/nls/nls_cp866.c      | 12 ++++++++---
 fs/nls/nls_cp869.c      | 12 ++++++++---
 fs/nls/nls_cp874.c      | 14 ++++++++----
 fs/nls/nls_cp932.c      | 14 ++++++++----
 fs/nls/nls_cp936.c      | 14 ++++++++----
 fs/nls/nls_cp949.c      | 14 ++++++++----
 fs/nls/nls_cp950.c      | 14 ++++++++----
 fs/nls/nls_default.c    |  9 ++++++--
 fs/nls/nls_euc-jp.c     | 12 ++++++++---
 fs/nls/nls_iso8859-1.c  | 12 ++++++++---
 fs/nls/nls_iso8859-13.c | 12 ++++++++---
 fs/nls/nls_iso8859-14.c | 12 ++++++++---
 fs/nls/nls_iso8859-15.c | 12 ++++++++---
 fs/nls/nls_iso8859-2.c  | 12 ++++++++---
 fs/nls/nls_iso8859-3.c  | 12 ++++++++---
 fs/nls/nls_iso8859-4.c  | 12 ++++++++---
 fs/nls/nls_iso8859-5.c  | 12 ++++++++---
 fs/nls/nls_iso8859-6.c  | 12 ++++++++---
 fs/nls/nls_iso8859-7.c  | 12 ++++++++---
 fs/nls/nls_iso8859-9.c  | 12 ++++++++---
 fs/nls/nls_koi8-r.c     | 12 ++++++++---
 fs/nls/nls_koi8-ru.c    | 12 ++++++++---
 fs/nls/nls_koi8-u.c     | 12 ++++++++---
 fs/nls/nls_utf8.c       | 12 ++++++++---
 include/linux/nls.h     | 18 ++++++++++------
 54 files changed, 516 insertions(+), 183 deletions(-)

diff --git a/fs/nls/mac-celtic.c b/fs/nls/mac-celtic.c
index 1b59b04f26f2..4fe7347c55d6 100644
--- a/fs/nls/mac-celtic.c
+++ b/fs/nls/mac-celtic.c
@@ -582,21 +582,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macceltic",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macceltic",
+	.tables = &table,
+};
+
 static int __init init_nls_macceltic(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macceltic(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macceltic)
diff --git a/fs/nls/mac-centeuro.c b/fs/nls/mac-centeuro.c
index d5b8f38f97b6..2d115aae4240 100644
--- a/fs/nls/mac-centeuro.c
+++ b/fs/nls/mac-centeuro.c
@@ -512,21 +512,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "maccenteuro",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "maccenteuro",
+	.tables = &table,
+};
+
 static int __init init_nls_maccenteuro(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_maccenteuro(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_maccenteuro)
diff --git a/fs/nls/mac-croatian.c b/fs/nls/mac-croatian.c
index 32de6accd526..b496b85fcde1 100644
--- a/fs/nls/mac-croatian.c
+++ b/fs/nls/mac-croatian.c
@@ -582,21 +582,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "maccroatian",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "maccroatian",
+	.tables = &table,
+};
+
 static int __init init_nls_maccroatian(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_maccroatian(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_maccroatian)
diff --git a/fs/nls/mac-cyrillic.c b/fs/nls/mac-cyrillic.c
index 34d5c1c05ff1..18c9e0eb8e58 100644
--- a/fs/nls/mac-cyrillic.c
+++ b/fs/nls/mac-cyrillic.c
@@ -477,21 +477,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "maccyrillic",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "maccyrillic",
+	.tables = &table,
+};
+
 static int __init init_nls_maccyrillic(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_maccyrillic(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_maccyrillic)
diff --git a/fs/nls/mac-gaelic.c b/fs/nls/mac-gaelic.c
index 2aabf5213176..8f8d6ae20f02 100644
--- a/fs/nls/mac-gaelic.c
+++ b/fs/nls/mac-gaelic.c
@@ -547,21 +547,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macgaelic",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macgaelic",
+	.tables = &table,
+};
+
 static int __init init_nls_macgaelic(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macgaelic(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macgaelic)
diff --git a/fs/nls/mac-greek.c b/fs/nls/mac-greek.c
index df62909ef57e..0e2c12fe3447 100644
--- a/fs/nls/mac-greek.c
+++ b/fs/nls/mac-greek.c
@@ -477,21 +477,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macgreek",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macgreek",
+	.tables = &table,
+};
+
 static int __init init_nls_macgreek(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macgreek(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macgreek)
diff --git a/fs/nls/mac-iceland.c b/fs/nls/mac-iceland.c
index 8daa68b995bc..414767fa47a4 100644
--- a/fs/nls/mac-iceland.c
+++ b/fs/nls/mac-iceland.c
@@ -582,21 +582,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "maciceland",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "maciceland",
+	.tables = &table,
+};
+
 static int __init init_nls_maciceland(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_maciceland(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_maciceland)
diff --git a/fs/nls/mac-inuit.c b/fs/nls/mac-inuit.c
index b0799693502a..0e06fd3a0c8f 100644
--- a/fs/nls/mac-inuit.c
+++ b/fs/nls/mac-inuit.c
@@ -512,21 +512,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macinuit",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macinuit",
+	.tables = &table,
+};
+
 static int __init init_nls_macinuit(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macinuit(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macinuit)
diff --git a/fs/nls/mac-roman.c b/fs/nls/mac-roman.c
index ba358b864b05..fcfd387cfaa8 100644
--- a/fs/nls/mac-roman.c
+++ b/fs/nls/mac-roman.c
@@ -617,21 +617,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macroman",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macroman",
+	.tables = &table,
+};
+
 static int __init init_nls_macroman(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macroman(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macroman)
diff --git a/fs/nls/mac-romanian.c b/fs/nls/mac-romanian.c
index 7a8a7f9a0bbc..74027022a135 100644
--- a/fs/nls/mac-romanian.c
+++ b/fs/nls/mac-romanian.c
@@ -582,21 +582,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macromanian",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macromanian",
+	.tables = &table,
+};
+
 static int __init init_nls_macromanian(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macromanian(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macromanian)
diff --git a/fs/nls/mac-turkish.c b/fs/nls/mac-turkish.c
index eb3c5e53ec88..0edc0f8b1f4d 100644
--- a/fs/nls/mac-turkish.c
+++ b/fs/nls/mac-turkish.c
@@ -582,21 +582,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "macturkish",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "macturkish",
+	.tables = &table,
+};
+
 static int __init init_nls_macturkish(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_macturkish(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_macturkish)
diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 6bad3e779284..3c3ee908d1ed 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -147,21 +147,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "ascii",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "ascii",
+	.tables = &table,
+};
+
 static int __init init_nls_ascii(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_ascii(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_ascii)
diff --git a/fs/nls/nls_core.c b/fs/nls/nls_core.c
index 3f7de8f4c5b2..200a7f8165e6 100644
--- a/fs/nls/nls_core.c
+++ b/fs/nls/nls_core.c
@@ -16,13 +16,18 @@
 #include <linux/kmod.h>
 #include <linux/spinlock.h>
 
-static struct nls_table default_table;
-static struct nls_table *tables = &default_table;
+extern struct nls_charset default_charset;
+static struct nls_charset *charsets = &default_charset;
 static DEFINE_SPINLOCK(nls_lock);
+static struct nls_table *nls_load_table(struct nls_charset *charset)
+{
+	/* For now, return the default table, which is the first one found. */
+	return charset->tables;
+}
 
-int __register_nls(struct nls_table *nls, struct module *owner)
+int __register_nls(struct nls_charset *nls, struct module *owner)
 {
-	struct nls_table ** tmp = &tables;
+	struct nls_charset **tmp = &charsets;
 
 	if (nls->next)
 		return -EBUSY;
@@ -36,16 +41,16 @@ int __register_nls(struct nls_table *nls, struct module *owner)
 		}
 		tmp = &(*tmp)->next;
 	}
-	nls->next = tables;
-	tables = nls;
+	nls->next = charsets;
+	charsets = nls;
 	spin_unlock(&nls_lock);
 	return 0;
 }
 EXPORT_SYMBOL(__register_nls);
 
-int unregister_nls(struct nls_table * nls)
+int unregister_nls(struct nls_charset * nls)
 {
-	struct nls_table ** tmp = &tables;
+	struct nls_charset **tmp = &charsets;
 
 	spin_lock(&nls_lock);
 	while (*tmp) {
@@ -60,31 +65,42 @@ int unregister_nls(struct nls_table * nls)
 	return -EINVAL;
 }
 
-static struct nls_table *find_nls(char *charset)
+static struct nls_charset *find_nls(const char *charset)
 {
-	struct nls_table *nls;
+	struct nls_charset *nls;
 	spin_lock(&nls_lock);
-	for (nls = tables; nls; nls = nls->next) {
-		if (!strcmp(nls_charset_name(nls), charset))
+	for (nls = charsets; nls; nls = nls->next) {
+		if (!strcmp(nls->charset, charset))
 			break;
 		if (nls->alias && !strcmp(nls->alias, charset))
 			break;
 	}
-	if (nls && !try_module_get(nls->owner))
-		nls = NULL;
+
+	if (!nls)
+		nls = ERR_PTR(-EINVAL);
+	else if (!try_module_get(nls->owner))
+		nls = ERR_PTR(-EBUSY);
+
 	spin_unlock(&nls_lock);
 	return nls;
 }
 
 struct nls_table *load_nls(char *charset)
 {
-	return try_then_request_module(find_nls(charset), "nls_%s", charset);
+	struct nls_charset *nls_charset;
+
+	nls_charset = try_then_request_module(find_nls(charset),
+					      "nls_%s", charset);
+	if (!IS_ERR(nls_charset))
+		return NULL;
+
+	return nls_load_table(nls_charset);
 }
 
 void unload_nls(struct nls_table *nls)
 {
 	if (nls)
-		module_put(nls->owner);
+		module_put(nls->charset->owner);
 }
 
 EXPORT_SYMBOL(unregister_nls);
diff --git a/fs/nls/nls_cp1250.c b/fs/nls/nls_cp1250.c
index 08902e86fc8e..080717694405 100644
--- a/fs/nls/nls_cp1250.c
+++ b/fs/nls/nls_cp1250.c
@@ -328,20 +328,26 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp1250",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp1250",
+	.tables = &table,
+};
+
 static int __init init_nls_cp1250(void)
 {
-        return register_nls(&table);
+        return register_nls(&nls_charset);
 }
 static void __exit exit_nls_cp1250(void)
 {
-        unregister_nls(&table);
+        unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp1250)
diff --git a/fs/nls/nls_cp1251.c b/fs/nls/nls_cp1251.c
index 2bb88c8cc5bf..2fba498ab289 100644
--- a/fs/nls/nls_cp1251.c
+++ b/fs/nls/nls_cp1251.c
@@ -282,21 +282,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp1251",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp1251",
+	.tables = &table,
+};
+
 static int __init init_nls_cp1251(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp1251(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp1251)
diff --git a/fs/nls/nls_cp1255.c b/fs/nls/nls_cp1255.c
index c6bf8d575c5b..c268e8d8c038 100644
--- a/fs/nls/nls_cp1255.c
+++ b/fs/nls/nls_cp1255.c
@@ -363,22 +363,28 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp1255",
-	.alias		= "iso8859-8",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.alias = "iso8859-8",
+	.charset = "cp1255",
+	.tables = &table,
+};
+
 static int __init init_nls_cp1255(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp1255(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp1255)
diff --git a/fs/nls/nls_cp437.c b/fs/nls/nls_cp437.c
index 0f3f8bdbb62b..f24f8691e720 100644
--- a/fs/nls/nls_cp437.c
+++ b/fs/nls/nls_cp437.c
@@ -368,21 +368,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp437",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp437",
+	.tables = &table,
+};
+
 static int __init init_nls_cp437(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp437(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp437)
diff --git a/fs/nls/nls_cp737.c b/fs/nls/nls_cp737.c
index 9383359ca25f..f5a8b9e88165 100644
--- a/fs/nls/nls_cp737.c
+++ b/fs/nls/nls_cp737.c
@@ -331,21 +331,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp737",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp737",
+	.tables = &table,
+};
+
 static int __init init_nls_cp737(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp737(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp737)
diff --git a/fs/nls/nls_cp775.c b/fs/nls/nls_cp775.c
index 6c787b9079ed..d268bfb873e4 100644
--- a/fs/nls/nls_cp775.c
+++ b/fs/nls/nls_cp775.c
@@ -300,21 +300,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp775",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp775",
+	.tables = &table,
+};
+
 static int __init init_nls_cp775(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp775(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp775)
diff --git a/fs/nls/nls_cp850.c b/fs/nls/nls_cp850.c
index 50a57138a571..b698b0df65e3 100644
--- a/fs/nls/nls_cp850.c
+++ b/fs/nls/nls_cp850.c
@@ -296,21 +296,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp850",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp850",
+	.tables = &table,
+};
+
 static int __init init_nls_cp850(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp850(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp850)
diff --git a/fs/nls/nls_cp852.c b/fs/nls/nls_cp852.c
index 0cbb199f1cd5..738e95346b34 100644
--- a/fs/nls/nls_cp852.c
+++ b/fs/nls/nls_cp852.c
@@ -318,21 +318,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp852",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp852",
+	.tables = &table,
+};
+
 static int __init init_nls_cp852(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp852(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp852)
diff --git a/fs/nls/nls_cp855.c b/fs/nls/nls_cp855.c
index 530b77c86363..9a1c4e307cb1 100644
--- a/fs/nls/nls_cp855.c
+++ b/fs/nls/nls_cp855.c
@@ -280,21 +280,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp855",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp855",
+	.tables = &table,
+};
+
 static int __init init_nls_cp855(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp855(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp855)
diff --git a/fs/nls/nls_cp857.c b/fs/nls/nls_cp857.c
index 0db642ec6f45..782e31cb9f5a 100644
--- a/fs/nls/nls_cp857.c
+++ b/fs/nls/nls_cp857.c
@@ -282,21 +282,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp857",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp857",
+	.tables = &table,
+};
+
 static int __init init_nls_cp857(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp857(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp857)
diff --git a/fs/nls/nls_cp860.c b/fs/nls/nls_cp860.c
index 44a40dac26bd..2ad1954b84e6 100644
--- a/fs/nls/nls_cp860.c
+++ b/fs/nls/nls_cp860.c
@@ -345,21 +345,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp860",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp860",
+	.tables = &table,
+};
+
 static int __init init_nls_cp860(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp860(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp860)
diff --git a/fs/nls/nls_cp861.c b/fs/nls/nls_cp861.c
index 50e08174fc48..5930b0e6e8f1 100644
--- a/fs/nls/nls_cp861.c
+++ b/fs/nls/nls_cp861.c
@@ -368,21 +368,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp861",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp861",
+	.tables = &table,
+};
+
 static int __init init_nls_cp861(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp861(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp861)
diff --git a/fs/nls/nls_cp862.c b/fs/nls/nls_cp862.c
index 3505f3437972..63c27b24a011 100644
--- a/fs/nls/nls_cp862.c
+++ b/fs/nls/nls_cp862.c
@@ -402,21 +402,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp862",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp862",
+	.tables = &table,
+};
+
 static int __init init_nls_cp862(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp862(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp862)
diff --git a/fs/nls/nls_cp863.c b/fs/nls/nls_cp863.c
index e3489cdc0c04..aa815cdc7481 100644
--- a/fs/nls/nls_cp863.c
+++ b/fs/nls/nls_cp863.c
@@ -362,21 +362,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp863",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp863",
+	.tables = &table,
+};
+
 static int __init init_nls_cp863(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp863(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp863)
diff --git a/fs/nls/nls_cp864.c b/fs/nls/nls_cp864.c
index d4185bc7f1bf..a20725f661e9 100644
--- a/fs/nls/nls_cp864.c
+++ b/fs/nls/nls_cp864.c
@@ -388,21 +388,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp864",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp864",
+	.tables = &table,
+};
+
 static int __init init_nls_cp864(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp864(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp864)
diff --git a/fs/nls/nls_cp865.c b/fs/nls/nls_cp865.c
index 9f468944e577..3d22ec2bd7af 100644
--- a/fs/nls/nls_cp865.c
+++ b/fs/nls/nls_cp865.c
@@ -368,21 +368,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp865",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp865",
+	.tables = &table,
+};
+
 static int __init init_nls_cp865(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp865(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp865)
diff --git a/fs/nls/nls_cp866.c b/fs/nls/nls_cp866.c
index ee46fd5a76b1..35dc7b2f023a 100644
--- a/fs/nls/nls_cp866.c
+++ b/fs/nls/nls_cp866.c
@@ -286,21 +286,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp866",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp866",
+	.tables = &table,
+};
+
 static int __init init_nls_cp866(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp866(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp866)
diff --git a/fs/nls/nls_cp869.c b/fs/nls/nls_cp869.c
index da29a4a53e1d..56504ab0f405 100644
--- a/fs/nls/nls_cp869.c
+++ b/fs/nls/nls_cp869.c
@@ -296,21 +296,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp869",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "cp869",
+	.tables = &table,
+};
+
 static int __init init_nls_cp869(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp869(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp869)
diff --git a/fs/nls/nls_cp874.c b/fs/nls/nls_cp874.c
index 642659b9ed89..41394620d000 100644
--- a/fs/nls/nls_cp874.c
+++ b/fs/nls/nls_cp874.c
@@ -254,22 +254,28 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp874",
-	.alias		= "tis-620",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.alias = "tis-620",
+	.charset = "cp874",
+	.tables = &table,
+};
+
 static int __init init_nls_cp874(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp874(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp874)
diff --git a/fs/nls/nls_cp932.c b/fs/nls/nls_cp932.c
index 3e7bdefdca90..25fe26fb2603 100644
--- a/fs/nls/nls_cp932.c
+++ b/fs/nls/nls_cp932.c
@@ -7912,22 +7912,28 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp932",
-	.alias		= "sjis",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.alias = "sjis",
+	.charset = "cp932",
+	.tables = &table,
+};
+
 static int __init init_nls_cp932(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp932(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp932)
diff --git a/fs/nls/nls_cp936.c b/fs/nls/nls_cp936.c
index b1fa2918992b..766f86b53a7b 100644
--- a/fs/nls/nls_cp936.c
+++ b/fs/nls/nls_cp936.c
@@ -11090,22 +11090,28 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp936",
-	.alias		= "gb2312",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.alias = "gb2312",
+	.charset = "cp936",
+	.tables = &table,
+};
+
 static int __init init_nls_cp936(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp936(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp936)
diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 1d334095d86c..138eec74bb3f 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -13925,22 +13925,28 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp949",
-	.alias		= "euc-kr",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.alias = "euc-kr",
+	.charset = "cp949",
+	.tables = &table,
+};
+
 static int __init init_nls_cp949(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp949(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp949)
diff --git a/fs/nls/nls_cp950.c b/fs/nls/nls_cp950.c
index d936160a48f9..899da09fe0d7 100644
--- a/fs/nls/nls_cp950.c
+++ b/fs/nls/nls_cp950.c
@@ -9461,22 +9461,28 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "cp950",
-	.alias		= "big5",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.alias = "big5",
+	.charset = "cp950",
+	.tables = &table,
+};
+
 static int __init init_nls_cp950(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_cp950(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_cp950)
diff --git a/fs/nls/nls_default.c b/fs/nls/nls_default.c
index c5d7e8391b22..ef8c0efb8a3c 100644
--- a/fs/nls/nls_default.c
+++ b/fs/nls/nls_default.c
@@ -17,7 +17,7 @@
 #include <asm/byteorder.h>
 #include <linux/nls.h>
 
-static struct nls_table default_table;
+struct nls_charset default_charset;
 
 struct utf8_table {
 	int     cmask;
@@ -453,12 +453,17 @@ static const struct nls_ops charset_ops = {
 };
 
 static struct nls_table default_table = {
-	.charset	= "default",
+	.charset = &default_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+struct nls_charset default_charset = {
+	.charset = "default",
+	.tables = &default_table,
+};
+
 /* Returns a simple default translation table */
 struct nls_table *load_nls_default(void)
 {
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 0af73982738b..8bc5d9991452 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -554,11 +554,17 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "euc-jp",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "euc-jp",
+	.tables = &table,
+};
+
 static int __init init_nls_euc_jp(void)
 {
 	p_nls = load_nls("cp932");
@@ -566,7 +572,7 @@ static int __init init_nls_euc_jp(void)
 	if (p_nls) {
 		table.charset2upper = p_nls->charset2upper;
 		table.charset2lower = p_nls->charset2lower;
-		return register_nls(&table);
+		return register_nls(&nls_charset);
 	}
 
 	return -EINVAL;
@@ -574,7 +580,7 @@ static int __init init_nls_euc_jp(void)
 
 static void __exit exit_nls_euc_jp(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 	unload_nls(p_nls);
 }
 
diff --git a/fs/nls/nls_iso8859-1.c b/fs/nls/nls_iso8859-1.c
index 6212b2925fa0..78e9c0169f69 100644
--- a/fs/nls/nls_iso8859-1.c
+++ b/fs/nls/nls_iso8859-1.c
@@ -238,21 +238,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-1",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-1",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_1(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_1(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_1)
diff --git a/fs/nls/nls_iso8859-13.c b/fs/nls/nls_iso8859-13.c
index 8f0a23109207..eb8665629e0f 100644
--- a/fs/nls/nls_iso8859-13.c
+++ b/fs/nls/nls_iso8859-13.c
@@ -266,21 +266,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-13",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-13",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_13(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_13(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_13)
diff --git a/fs/nls/nls_iso8859-14.c b/fs/nls/nls_iso8859-14.c
index 80ab77f37480..c8d5a48f869c 100644
--- a/fs/nls/nls_iso8859-14.c
+++ b/fs/nls/nls_iso8859-14.c
@@ -322,21 +322,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-14",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-14",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_14(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_14(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_14)
diff --git a/fs/nls/nls_iso8859-15.c b/fs/nls/nls_iso8859-15.c
index 5c02f93e7b20..0611c6cb56b4 100644
--- a/fs/nls/nls_iso8859-15.c
+++ b/fs/nls/nls_iso8859-15.c
@@ -288,21 +288,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-15",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-15",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_15(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_15(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_15)
diff --git a/fs/nls/nls_iso8859-2.c b/fs/nls/nls_iso8859-2.c
index 97afc1233da1..5255d92a25eb 100644
--- a/fs/nls/nls_iso8859-2.c
+++ b/fs/nls/nls_iso8859-2.c
@@ -289,21 +289,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-2",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-2",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_2(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_2(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_2)
diff --git a/fs/nls/nls_iso8859-3.c b/fs/nls/nls_iso8859-3.c
index f835fcec3aae..ad1b84f3e102 100644
--- a/fs/nls/nls_iso8859-3.c
+++ b/fs/nls/nls_iso8859-3.c
@@ -289,21 +289,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-3",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-3",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_3(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_3(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_3)
diff --git a/fs/nls/nls_iso8859-4.c b/fs/nls/nls_iso8859-4.c
index 14acb68fb013..82469deee0ba 100644
--- a/fs/nls/nls_iso8859-4.c
+++ b/fs/nls/nls_iso8859-4.c
@@ -289,21 +289,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-4",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-4",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_4(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_4(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_4)
diff --git a/fs/nls/nls_iso8859-5.c b/fs/nls/nls_iso8859-5.c
index f559bbb25045..3f3cd0c28797 100644
--- a/fs/nls/nls_iso8859-5.c
+++ b/fs/nls/nls_iso8859-5.c
@@ -253,21 +253,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-5",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-5",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_5(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_5(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_5)
diff --git a/fs/nls/nls_iso8859-6.c b/fs/nls/nls_iso8859-6.c
index e3d7e28363b8..43e6675998bc 100644
--- a/fs/nls/nls_iso8859-6.c
+++ b/fs/nls/nls_iso8859-6.c
@@ -244,21 +244,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-6",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-6",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_6(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_6(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_6)
diff --git a/fs/nls/nls_iso8859-7.c b/fs/nls/nls_iso8859-7.c
index 49fd2b24e492..83893e487f82 100644
--- a/fs/nls/nls_iso8859-7.c
+++ b/fs/nls/nls_iso8859-7.c
@@ -298,21 +298,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-7",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-7",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_7(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_7(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_7)
diff --git a/fs/nls/nls_iso8859-9.c b/fs/nls/nls_iso8859-9.c
index 876696f89626..df03f97cd9d1 100644
--- a/fs/nls/nls_iso8859-9.c
+++ b/fs/nls/nls_iso8859-9.c
@@ -253,21 +253,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "iso8859-9",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "iso8859-9",
+	.tables = &table,
+};
+
 static int __init init_nls_iso8859_9(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_iso8859_9(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_iso8859_9)
diff --git a/fs/nls/nls_koi8-r.c b/fs/nls/nls_koi8-r.c
index 6a85211402a8..22918e154dbe 100644
--- a/fs/nls/nls_koi8-r.c
+++ b/fs/nls/nls_koi8-r.c
@@ -304,21 +304,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "koi8-r",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "koi8-r",
+	.tables = &table,
+};
+
 static int __init init_nls_koi8_r(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_koi8_r(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_koi8_r)
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index c4e382fd0f13..f4edbc313706 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -56,11 +56,17 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "koi8-ru",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "koi8-ru",
+	.tables = &table,
+};
+
 static int __init init_nls_koi8_ru(void)
 {
 	p_nls = load_nls("koi8-u");
@@ -68,7 +74,7 @@ static int __init init_nls_koi8_ru(void)
 	if (p_nls) {
 		table.charset2upper = p_nls->charset2upper;
 		table.charset2lower = p_nls->charset2lower;
-		return register_nls(&table);
+		return register_nls(&nls_charset);
 	}
 
 	return -EINVAL;
@@ -76,7 +82,7 @@ static int __init init_nls_koi8_ru(void)
 
 static void __exit exit_nls_koi8_ru(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 	unload_nls(p_nls);
 }
 
diff --git a/fs/nls/nls_koi8-u.c b/fs/nls/nls_koi8-u.c
index 5f91e9cdb165..b2421625e98b 100644
--- a/fs/nls/nls_koi8-u.c
+++ b/fs/nls/nls_koi8-u.c
@@ -311,21 +311,27 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "koi8-u",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= charset2lower,
 	.charset2upper	= charset2upper,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "koi8-u",
+	.tables = &table,
+};
+
 static int __init init_nls_koi8_u(void)
 {
-	return register_nls(&table);
+	return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_koi8_u(void)
 {
-	unregister_nls(&table);
+	unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_koi8_u)
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index 6988fffd5cf6..aecf460827ac 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -45,25 +45,31 @@ static const struct nls_ops charset_ops = {
 	.char2uni = char2uni,
 };
 
+static struct nls_charset nls_charset;
 static struct nls_table table = {
-	.charset	= "utf8",
+	.charset = &nls_charset,
 	.ops = &charset_ops,
 	.charset2lower	= identity,	/* no conversion */
 	.charset2upper	= identity,
 };
 
+static struct nls_charset nls_charset = {
+	.charset = "utf8",
+	.tables = &table,
+};
+
 static int __init init_nls_utf8(void)
 {
 	int i;
 	for (i=0; i<256; i++)
 		identity[i] = i;
 
-        return register_nls(&table);
+        return register_nls(&nls_charset);
 }
 
 static void __exit exit_nls_utf8(void)
 {
-        unregister_nls(&table);
+        unregister_nls(&nls_charset);
 }
 
 module_init(init_nls_utf8)
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 5d63fe6aa55e..cdc95cd9e5d4 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -29,15 +29,21 @@ struct nls_ops {
 };
 
 struct nls_table {
-	const char *charset;
-	const char *alias;
+	const struct nls_charset *charset;
 	const struct nls_ops *ops;
 	const unsigned char *charset2lower;
 	const unsigned char *charset2upper;
-	struct module *owner;
 	struct nls_table *next;
 };
 
+struct nls_charset {
+	const char *charset;
+	const char *alias;
+	struct module *owner;
+	struct nls_table *tables;
+	struct nls_charset *next;
+};
+
 /* this value hold the maximum octet of charset */
 #define NLS_MAX_CHARSET_SIZE 6 /* for UTF-8 */
 
@@ -49,8 +55,8 @@ enum utf16_endian {
 };
 
 /* nls_base.c */
-extern int __register_nls(struct nls_table *, struct module *);
-extern int unregister_nls(struct nls_table *);
+extern int __register_nls(struct nls_charset *, struct module *);
+extern int unregister_nls(struct nls_charset *);
 extern struct nls_table *load_nls(char *);
 extern void unload_nls(struct nls_table *);
 extern struct nls_table *load_nls_default(void);
@@ -78,7 +84,7 @@ static inline int nls_char2uni(const struct nls_table *table,
 
 static inline const char *nls_charset_name(const struct nls_table *table)
 {
-	return table->charset;
+	return table->charset->charset;
 }
 
 static inline unsigned char nls_tolower(struct nls_table *t, unsigned char c)
-- 
2.20.0.rc2
