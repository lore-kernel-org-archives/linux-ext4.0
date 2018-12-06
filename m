Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56090 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbeLFXJo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:09:44 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 08/23] nls: Let charsets define the behavior of tolower/toupper
Date: Thu,  6 Dec 2018 18:08:48 -0500
Message-Id: <20181206230903.30011-9-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Instead of always reading from a table, give the charset a chance to
implement tolower() and toupper() algorithmically.

This allow us to drop a lot of tables which hardcode the identity
functions (like ASCII), and replace them with a few lines of code in the
hooks.

This patch was created using the semantic patch below, with the
exception of the header files (hook definitions) and a fix to files that
didn't have the tables statically allocated (koi8-u and cp932).

<smpl>

@tbl@
identifier p;
expression lower_tbl;
expression upper_tbl;
@@

static struct nls_table p = {
-       .charset2lower = lower_tbl,
-       .charset2upper = upper_tbl,
};

@@
identifier charset_ops;
expression tbl.lower_tbl;
expression tbl.upper_tbl;
@@

+ static unsigned char charset_tolower(const struct nls_table *table, unsigned int c)
+ {
+	return lower_tbl[c];
+ }
+
+ static unsigned char charset_toupper(const struct nls_table *table, unsigned int c)
+ {
+	return upper_tbl[c];
+ }

static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
};

@@
struct nls_table *t;
expression A;
expression nc;
@@

(
- nc = t->charset2lower[A]
+ nc = nls_tolower(t, A)

|
- nc = t->charset2upper[A]
+ nc = nls_toupper(t, A)
)
<...
- if(!nc)
-	  nc = A;
...>

</smpl>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/fat/dir.c            |  5 +----
 fs/nls/mac-celtic.c     | 14 ++++++++++++--
 fs/nls/mac-centeuro.c   | 14 ++++++++++++--
 fs/nls/mac-croatian.c   | 14 ++++++++++++--
 fs/nls/mac-cyrillic.c   | 14 ++++++++++++--
 fs/nls/mac-gaelic.c     | 14 ++++++++++++--
 fs/nls/mac-greek.c      | 14 ++++++++++++--
 fs/nls/mac-iceland.c    | 14 ++++++++++++--
 fs/nls/mac-inuit.c      | 14 ++++++++++++--
 fs/nls/mac-roman.c      | 14 ++++++++++++--
 fs/nls/mac-romanian.c   | 14 ++++++++++++--
 fs/nls/mac-turkish.c    | 14 ++++++++++++--
 fs/nls/nls_ascii.c      | 14 ++++++++++++--
 fs/nls/nls_cp1250.c     | 14 ++++++++++++--
 fs/nls/nls_cp1251.c     | 14 ++++++++++++--
 fs/nls/nls_cp1255.c     | 14 ++++++++++++--
 fs/nls/nls_cp437.c      | 14 ++++++++++++--
 fs/nls/nls_cp737.c      | 14 ++++++++++++--
 fs/nls/nls_cp775.c      | 14 ++++++++++++--
 fs/nls/nls_cp850.c      | 14 ++++++++++++--
 fs/nls/nls_cp852.c      | 14 ++++++++++++--
 fs/nls/nls_cp855.c      | 14 ++++++++++++--
 fs/nls/nls_cp857.c      | 14 ++++++++++++--
 fs/nls/nls_cp860.c      | 14 ++++++++++++--
 fs/nls/nls_cp861.c      | 14 ++++++++++++--
 fs/nls/nls_cp862.c      | 14 ++++++++++++--
 fs/nls/nls_cp863.c      | 14 ++++++++++++--
 fs/nls/nls_cp864.c      | 14 ++++++++++++--
 fs/nls/nls_cp865.c      | 14 ++++++++++++--
 fs/nls/nls_cp866.c      | 14 ++++++++++++--
 fs/nls/nls_cp869.c      | 14 ++++++++++++--
 fs/nls/nls_cp874.c      | 14 ++++++++++++--
 fs/nls/nls_cp932.c      | 14 ++++++++++++--
 fs/nls/nls_cp936.c      | 14 ++++++++++++--
 fs/nls/nls_cp949.c      | 14 ++++++++++++--
 fs/nls/nls_cp950.c      | 14 ++++++++++++--
 fs/nls/nls_default.c    | 14 ++++++++++++--
 fs/nls/nls_euc-jp.c     |  7 ++++---
 fs/nls/nls_iso8859-1.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-13.c | 14 ++++++++++++--
 fs/nls/nls_iso8859-14.c | 14 ++++++++++++--
 fs/nls/nls_iso8859-15.c | 14 ++++++++++++--
 fs/nls/nls_iso8859-2.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-3.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-4.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-5.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-6.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-7.c  | 14 ++++++++++++--
 fs/nls/nls_iso8859-9.c  | 14 ++++++++++++--
 fs/nls/nls_koi8-r.c     | 14 ++++++++++++--
 fs/nls/nls_koi8-ru.c    |  6 +++---
 fs/nls/nls_koi8-u.c     | 14 ++++++++++++--
 fs/nls/nls_utf8.c       | 14 ++++++++++++--
 include/linux/nls.h     | 17 +++++++++++------
 54 files changed, 619 insertions(+), 116 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index d5f856651a08..6518886ee5cf 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -215,10 +215,7 @@ fat_short2lower_uni(struct nls_table *t, unsigned char *c,
 		*uni = 0x003f;	/* a question mark */
 		charlen = 1;
 	} else if (charlen <= 1) {
-		unsigned char nc = t->charset2lower[*c];
-
-		if (!nc)
-			nc = *c;
+		unsigned char nc = nls_tolower(t, *c);
 
 		charlen = nls_char2uni(t, &nc, 1, uni);
 		if (charlen < 0) {
diff --git a/fs/nls/mac-celtic.c b/fs/nls/mac-celtic.c
index 4fe7347c55d6..7207f9a14342 100644
--- a/fs/nls/mac-celtic.c
+++ b/fs/nls/mac-celtic.c
@@ -577,7 +577,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -586,8 +598,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-centeuro.c b/fs/nls/mac-centeuro.c
index 2d115aae4240..0664408e4451 100644
--- a/fs/nls/mac-centeuro.c
+++ b/fs/nls/mac-centeuro.c
@@ -507,7 +507,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -516,8 +528,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-croatian.c b/fs/nls/mac-croatian.c
index b496b85fcde1..a4b7992ef8ec 100644
--- a/fs/nls/mac-croatian.c
+++ b/fs/nls/mac-croatian.c
@@ -577,7 +577,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -586,8 +598,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-cyrillic.c b/fs/nls/mac-cyrillic.c
index 18c9e0eb8e58..cb60563911ea 100644
--- a/fs/nls/mac-cyrillic.c
+++ b/fs/nls/mac-cyrillic.c
@@ -472,7 +472,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -481,8 +493,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-gaelic.c b/fs/nls/mac-gaelic.c
index 8f8d6ae20f02..e683881f4a13 100644
--- a/fs/nls/mac-gaelic.c
+++ b/fs/nls/mac-gaelic.c
@@ -542,7 +542,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -551,8 +563,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-greek.c b/fs/nls/mac-greek.c
index 0e2c12fe3447..bd2245238512 100644
--- a/fs/nls/mac-greek.c
+++ b/fs/nls/mac-greek.c
@@ -472,7 +472,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -481,8 +493,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-iceland.c b/fs/nls/mac-iceland.c
index 414767fa47a4..3ce3e27b3660 100644
--- a/fs/nls/mac-iceland.c
+++ b/fs/nls/mac-iceland.c
@@ -577,7 +577,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -586,8 +598,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-inuit.c b/fs/nls/mac-inuit.c
index 0e06fd3a0c8f..6f12cccccb37 100644
--- a/fs/nls/mac-inuit.c
+++ b/fs/nls/mac-inuit.c
@@ -507,7 +507,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -516,8 +528,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-roman.c b/fs/nls/mac-roman.c
index fcfd387cfaa8..d8e411c82c69 100644
--- a/fs/nls/mac-roman.c
+++ b/fs/nls/mac-roman.c
@@ -612,7 +612,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -621,8 +633,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-romanian.c b/fs/nls/mac-romanian.c
index 74027022a135..cd638dfe9d7c 100644
--- a/fs/nls/mac-romanian.c
+++ b/fs/nls/mac-romanian.c
@@ -577,7 +577,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -586,8 +598,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/mac-turkish.c b/fs/nls/mac-turkish.c
index 0edc0f8b1f4d..82ba6f6b4c24 100644
--- a/fs/nls/mac-turkish.c
+++ b/fs/nls/mac-turkish.c
@@ -577,7 +577,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -586,8 +598,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 3c3ee908d1ed..2f4826478d3d 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -142,7 +142,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -151,8 +163,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp1250.c b/fs/nls/nls_cp1250.c
index 080717694405..1cfe65851185 100644
--- a/fs/nls/nls_cp1250.c
+++ b/fs/nls/nls_cp1250.c
@@ -323,7 +323,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
         return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -332,8 +344,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp1251.c b/fs/nls/nls_cp1251.c
index 2fba498ab289..061eb23892f1 100644
--- a/fs/nls/nls_cp1251.c
+++ b/fs/nls/nls_cp1251.c
@@ -277,7 +277,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -286,8 +298,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp1255.c b/fs/nls/nls_cp1255.c
index c268e8d8c038..2a71dc175c9b 100644
--- a/fs/nls/nls_cp1255.c
+++ b/fs/nls/nls_cp1255.c
@@ -358,7 +358,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -367,8 +379,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp437.c b/fs/nls/nls_cp437.c
index f24f8691e720..4f763761b699 100644
--- a/fs/nls/nls_cp437.c
+++ b/fs/nls/nls_cp437.c
@@ -363,7 +363,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -372,8 +384,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp737.c b/fs/nls/nls_cp737.c
index f5a8b9e88165..2f2ab91340e7 100644
--- a/fs/nls/nls_cp737.c
+++ b/fs/nls/nls_cp737.c
@@ -326,7 +326,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -335,8 +347,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp775.c b/fs/nls/nls_cp775.c
index d268bfb873e4..92f311e620f3 100644
--- a/fs/nls/nls_cp775.c
+++ b/fs/nls/nls_cp775.c
@@ -295,7 +295,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -304,8 +316,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp850.c b/fs/nls/nls_cp850.c
index b698b0df65e3..77cdce20ced6 100644
--- a/fs/nls/nls_cp850.c
+++ b/fs/nls/nls_cp850.c
@@ -291,7 +291,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -300,8 +312,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp852.c b/fs/nls/nls_cp852.c
index 738e95346b34..47722904e9f1 100644
--- a/fs/nls/nls_cp852.c
+++ b/fs/nls/nls_cp852.c
@@ -313,7 +313,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -322,8 +334,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp855.c b/fs/nls/nls_cp855.c
index 9a1c4e307cb1..b52709886900 100644
--- a/fs/nls/nls_cp855.c
+++ b/fs/nls/nls_cp855.c
@@ -275,7 +275,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -284,8 +296,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp857.c b/fs/nls/nls_cp857.c
index 782e31cb9f5a..fcdf30a540f8 100644
--- a/fs/nls/nls_cp857.c
+++ b/fs/nls/nls_cp857.c
@@ -277,7 +277,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -286,8 +298,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp860.c b/fs/nls/nls_cp860.c
index 2ad1954b84e6..a1504424e923 100644
--- a/fs/nls/nls_cp860.c
+++ b/fs/nls/nls_cp860.c
@@ -340,7 +340,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -349,8 +361,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp861.c b/fs/nls/nls_cp861.c
index 5930b0e6e8f1..9fa1f54cee0d 100644
--- a/fs/nls/nls_cp861.c
+++ b/fs/nls/nls_cp861.c
@@ -363,7 +363,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -372,8 +384,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp862.c b/fs/nls/nls_cp862.c
index 63c27b24a011..00474e2b2102 100644
--- a/fs/nls/nls_cp862.c
+++ b/fs/nls/nls_cp862.c
@@ -397,7 +397,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -406,8 +418,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp863.c b/fs/nls/nls_cp863.c
index aa815cdc7481..908e573c1c42 100644
--- a/fs/nls/nls_cp863.c
+++ b/fs/nls/nls_cp863.c
@@ -357,7 +357,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -366,8 +378,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp864.c b/fs/nls/nls_cp864.c
index a20725f661e9..6cae9e9c73aa 100644
--- a/fs/nls/nls_cp864.c
+++ b/fs/nls/nls_cp864.c
@@ -383,7 +383,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -392,8 +404,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp865.c b/fs/nls/nls_cp865.c
index 3d22ec2bd7af..5aa6415ec357 100644
--- a/fs/nls/nls_cp865.c
+++ b/fs/nls/nls_cp865.c
@@ -363,7 +363,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -372,8 +384,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp866.c b/fs/nls/nls_cp866.c
index 35dc7b2f023a..f24b73839680 100644
--- a/fs/nls/nls_cp866.c
+++ b/fs/nls/nls_cp866.c
@@ -281,7 +281,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -290,8 +302,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp869.c b/fs/nls/nls_cp869.c
index 56504ab0f405..c2ba80140906 100644
--- a/fs/nls/nls_cp869.c
+++ b/fs/nls/nls_cp869.c
@@ -291,7 +291,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -300,8 +312,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp874.c b/fs/nls/nls_cp874.c
index 41394620d000..844bb205deee 100644
--- a/fs/nls/nls_cp874.c
+++ b/fs/nls/nls_cp874.c
@@ -249,7 +249,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -258,8 +270,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp932.c b/fs/nls/nls_cp932.c
index 25fe26fb2603..0a5db2a0a6b3 100644
--- a/fs/nls/nls_cp932.c
+++ b/fs/nls/nls_cp932.c
@@ -7907,7 +7907,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 		return -EINVAL;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -7916,8 +7928,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp936.c b/fs/nls/nls_cp936.c
index 766f86b53a7b..6b0d725cdfab 100644
--- a/fs/nls/nls_cp936.c
+++ b/fs/nls/nls_cp936.c
@@ -11085,7 +11085,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 	return n;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -11094,8 +11106,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 138eec74bb3f..292c2d02d2c2 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -13920,7 +13920,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 	return n;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -13929,8 +13941,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_cp950.c b/fs/nls/nls_cp950.c
index 899da09fe0d7..d4e35bfd8dbd 100644
--- a/fs/nls/nls_cp950.c
+++ b/fs/nls/nls_cp950.c
@@ -9456,7 +9456,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 	return n;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -9465,8 +9477,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_default.c b/fs/nls/nls_default.c
index ef8c0efb8a3c..602eeec24b3d 100644
--- a/fs/nls/nls_default.c
+++ b/fs/nls/nls_default.c
@@ -447,7 +447,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -455,8 +467,6 @@ static const struct nls_ops charset_ops = {
 static struct nls_table default_table = {
 	.charset = &default_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 struct nls_charset default_charset = {
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 8bc5d9991452..b3a81350cbea 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -549,7 +549,7 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 	return euc_offset;
 }
 
-static const struct nls_ops charset_ops = {
+static struct nls_ops charset_ops = {
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -570,8 +570,9 @@ static int __init init_nls_euc_jp(void)
 	p_nls = load_nls("cp932");
 
 	if (p_nls) {
-		table.charset2upper = p_nls->charset2upper;
-		table.charset2lower = p_nls->charset2lower;
+
+		charset_ops.uppercase = p_nls->ops->uppercase;
+		charset_ops.lowercase = p_nls->ops->lowercase;
 		return register_nls(&nls_charset);
 	}
 
diff --git a/fs/nls/nls_iso8859-1.c b/fs/nls/nls_iso8859-1.c
index 78e9c0169f69..a98298bd5de5 100644
--- a/fs/nls/nls_iso8859-1.c
+++ b/fs/nls/nls_iso8859-1.c
@@ -233,7 +233,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -242,8 +254,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-13.c b/fs/nls/nls_iso8859-13.c
index eb8665629e0f..811f4cf1d1a3 100644
--- a/fs/nls/nls_iso8859-13.c
+++ b/fs/nls/nls_iso8859-13.c
@@ -261,7 +261,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -270,8 +282,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-14.c b/fs/nls/nls_iso8859-14.c
index c8d5a48f869c..d8dafca31d26 100644
--- a/fs/nls/nls_iso8859-14.c
+++ b/fs/nls/nls_iso8859-14.c
@@ -317,7 +317,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -326,8 +338,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-15.c b/fs/nls/nls_iso8859-15.c
index 0611c6cb56b4..9de12c9e25a3 100644
--- a/fs/nls/nls_iso8859-15.c
+++ b/fs/nls/nls_iso8859-15.c
@@ -283,7 +283,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -292,8 +304,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-2.c b/fs/nls/nls_iso8859-2.c
index 5255d92a25eb..c59e2424f2b5 100644
--- a/fs/nls/nls_iso8859-2.c
+++ b/fs/nls/nls_iso8859-2.c
@@ -284,7 +284,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -293,8 +305,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-3.c b/fs/nls/nls_iso8859-3.c
index ad1b84f3e102..4bab1b607059 100644
--- a/fs/nls/nls_iso8859-3.c
+++ b/fs/nls/nls_iso8859-3.c
@@ -284,7 +284,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -293,8 +305,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-4.c b/fs/nls/nls_iso8859-4.c
index 82469deee0ba..1a3cf5f507f6 100644
--- a/fs/nls/nls_iso8859-4.c
+++ b/fs/nls/nls_iso8859-4.c
@@ -284,7 +284,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -293,8 +305,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-5.c b/fs/nls/nls_iso8859-5.c
index 3f3cd0c28797..0a26cea9d578 100644
--- a/fs/nls/nls_iso8859-5.c
+++ b/fs/nls/nls_iso8859-5.c
@@ -248,7 +248,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -257,8 +269,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-6.c b/fs/nls/nls_iso8859-6.c
index 43e6675998bc..d5a230888eed 100644
--- a/fs/nls/nls_iso8859-6.c
+++ b/fs/nls/nls_iso8859-6.c
@@ -239,7 +239,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -248,8 +260,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-7.c b/fs/nls/nls_iso8859-7.c
index 83893e487f82..a5a171849ae4 100644
--- a/fs/nls/nls_iso8859-7.c
+++ b/fs/nls/nls_iso8859-7.c
@@ -293,7 +293,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -302,8 +314,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_iso8859-9.c b/fs/nls/nls_iso8859-9.c
index df03f97cd9d1..795093547cd6 100644
--- a/fs/nls/nls_iso8859-9.c
+++ b/fs/nls/nls_iso8859-9.c
@@ -248,7 +248,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -257,8 +269,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_koi8-r.c b/fs/nls/nls_koi8-r.c
index 22918e154dbe..bbce9a608419 100644
--- a/fs/nls/nls_koi8-r.c
+++ b/fs/nls/nls_koi8-r.c
@@ -299,7 +299,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -308,8 +320,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index f4edbc313706..d3e946652bf6 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -51,7 +51,7 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 	return n;
 }
 
-static const struct nls_ops charset_ops = {
+static struct nls_ops charset_ops = {
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -72,8 +72,8 @@ static int __init init_nls_koi8_ru(void)
 	p_nls = load_nls("koi8-u");
 
 	if (p_nls) {
-		table.charset2upper = p_nls->charset2upper;
-		table.charset2lower = p_nls->charset2lower;
+		charset_ops.uppercase = p_nls->ops->uppercase;
+		charset_ops.lowercase = p_nls->ops->lowercase;
 		return register_nls(&nls_charset);
 	}
 
diff --git a/fs/nls/nls_koi8-u.c b/fs/nls/nls_koi8-u.c
index b2421625e98b..5de52a74f0b3 100644
--- a/fs/nls/nls_koi8-u.c
+++ b/fs/nls/nls_koi8-u.c
@@ -306,7 +306,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return 1;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return charset2lower[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return charset2upper[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -315,8 +327,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= charset2lower,
-	.charset2upper	= charset2upper,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index aecf460827ac..fe1ac5efaa37 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -40,7 +40,19 @@ static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 	return n;
 }
 
+static unsigned char charset_tolower(const struct nls_table *table,
+				     unsigned int c){
+	return identity[c];
+}
+
+static unsigned char charset_toupper(const struct nls_table *table,
+				     unsigned int c) {
+	return identity[c];
+}
+
 static const struct nls_ops charset_ops = {
+	.lowercase = charset_toupper,
+	.uppercase = charset_tolower,
 	.uni2char = uni2char,
 	.char2uni = char2uni,
 };
@@ -49,8 +61,6 @@ static struct nls_charset nls_charset;
 static struct nls_table table = {
 	.charset = &nls_charset,
 	.ops = &charset_ops,
-	.charset2lower	= identity,	/* no conversion */
-	.charset2upper	= identity,
 };
 
 static struct nls_charset nls_charset = {
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 9f61015a54bf..c43746bd390e 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -38,6 +38,10 @@ struct nls_ops {
 	 **/
 	int (*validate)(const struct nls_table *charset,
 			const unsigned char *str, size_t len);
+	unsigned char (*lowercase)(const struct nls_table *charset,
+				   unsigned int c);
+	unsigned char (*uppercase)(const struct nls_table *charset,
+				   unsigned int c);
 };
 
 struct nls_table {
@@ -46,9 +50,8 @@ struct nls_table {
 	unsigned int flags;
 
 	const struct nls_ops *ops;
-	const unsigned char *charset2lower;
-	const unsigned char *charset2upper;
 	struct nls_table *next;
+
 };
 
 struct nls_charset {
@@ -120,16 +123,18 @@ static inline const char *nls_charset_name(const struct nls_table *table)
 	return table->charset->charset;
 }
 
-static inline unsigned char nls_tolower(struct nls_table *t, unsigned char c)
+static inline unsigned char nls_tolower(const struct nls_table *t,
+					unsigned char c)
 {
-	unsigned char nc = t->charset2lower[c];
+	unsigned char nc = t->ops->lowercase(t, c);
 
 	return nc ? nc : c;
 }
 
-static inline unsigned char nls_toupper(struct nls_table *t, unsigned char c)
+static inline unsigned char nls_toupper(const struct nls_table *t,
+					unsigned char c)
 {
-	unsigned char nc = t->charset2upper[c];
+	unsigned char nc = t->ops->uppercase(t, c);
 
 	return nc ? nc : c;
 }
-- 
2.20.0.rc2
