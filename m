Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50094 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbeJRExE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 00:53:04 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 01/23] nls: Wrap uni2char/char2uni callers
Date: Wed, 17 Oct 2018 16:55:02 -0400
Message-Id: <20181017205524.23360-2-krisman@collabora.co.uk>
In-Reply-To: <20181017205524.23360-1-krisman@collabora.co.uk>
References: <20181017205524.23360-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a cosmetic change at this point, this patch will simplify the
following Coccinelle patches which will move the hooks into a dedicated
structure, with the goal of splitting the nls_table structure to support
versioning.

This was generated with the following coccinele script:

<smpl>

@@
expression A, B, C, D;
@@
(
- A->uni2char(B, C, D)
+ nls_uni2char(A, B, C, D)
|
- A->char2uni(B, C, D)
+ nls_char2uni(A, B, C, D)
)

</smpl>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/befs/linuxvfs.c     |  4 ++--
 fs/cifs/cifs_unicode.c |  9 +++++----
 fs/cifs/dir.c          |  7 ++++---
 fs/fat/dir.c           |  8 ++++----
 fs/fat/namei_vfat.c    |  6 +++---
 fs/hfs/trans.c         |  9 +++++----
 fs/hfsplus/unicode.c   |  6 +++---
 fs/isofs/joliet.c      |  3 ++-
 fs/jfs/jfs_unicode.c   |  7 +++----
 fs/nls/nls_euc-jp.c    |  4 ++--
 fs/nls/nls_koi8-ru.c   |  6 +++---
 fs/ntfs/unistr.c       |  8 ++++----
 include/linux/nls.h    | 13 +++++++++++++
 13 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 4700b4534439..0ba368fbfad4 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -542,7 +542,7 @@ befs_utf2nls(struct super_block *sb, const char *in,
 		/* convert from Unicode to nls */
 		if (uni > MAX_WCHAR_T)
 			goto conv_err;
-		unilen = nls->uni2char(uni, &result[o], in_len - o);
+		unilen = nls_uni2char(nls, uni, &result[o], in_len - o);
 		if (unilen < 0)
 			goto conv_err;
 	}
@@ -616,7 +616,7 @@ befs_nls2utf(struct super_block *sb, const char *in,
 	for (i = o = 0; i < in_len; i += unilen, o += utflen) {
 
 		/* convert from nls to unicode */
-		unilen = nls->char2uni(&in[i], in_len - i, &uni);
+		unilen = nls_char2uni(nls, &in[i], in_len - i, &uni);
 		if (unilen < 0)
 			goto conv_err;
 
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index a2b2355e7f01..ffad8b4f90d1 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -145,7 +145,7 @@ cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 		return len;
 
 	/* if character not one of seven in special remap set */
-	len = cp->uni2char(src_char, target, NLS_MAX_CHARSET_SIZE);
+	len = nls_uni2char(cp, src_char, target, NLS_MAX_CHARSET_SIZE);
 	if (len <= 0)
 		goto surrogate_pair;
 
@@ -289,7 +289,7 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	}
 
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
-		charlen = codepage->char2uni(from, len, &wchar_to);
+		charlen = nls_char2uni(codepage, from, len, &wchar_to);
 		if (charlen < 1) {
 			cifs_dbg(VFS, "strtoUTF16: char2uni of 0x%x returned %d\n",
 				 *from, charlen);
@@ -515,7 +515,8 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		 * as they use backslash as separator.
 		 */
 		if (dst_char == 0) {
-			charlen = cp->char2uni(source + i, srclen - i, &tmp);
+			charlen = nls_char2uni(cp, source + i, srclen - i,
+					       &tmp);
 			dst_char = cpu_to_le16(tmp);
 
 			/*
@@ -605,7 +606,7 @@ cifs_local_to_utf16_bytes(const char *from, int len,
 	wchar_t wchar_to;
 
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
-		charlen = codepage->char2uni(from, len, &wchar_to);
+		charlen = nls_char2uni(codepage, from, len, &wchar_to);
 		/* Failed conversion defaults to a question mark */
 		if (charlen < 1)
 			charlen = 1;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 3713d22b95a7..f8bb9285f630 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -910,7 +910,7 @@ static int cifs_ci_hash(const struct dentry *dentry, struct qstr *q)
 
 	hash = init_name_hash(dentry);
 	for (i = 0; i < q->len; i += charlen) {
-		charlen = codepage->char2uni(&q->name[i], q->len - i, &c);
+		charlen = nls_char2uni(codepage, &q->name[i], q->len - i, &c);
 		/* error out if we can't convert the character */
 		if (unlikely(charlen < 0))
 			return charlen;
@@ -939,8 +939,9 @@ static int cifs_ci_compare(const struct dentry *dentry,
 
 	for (i = 0; i < len; i += l1) {
 		/* Convert characters in both strings to UTF-16. */
-		l1 = codepage->char2uni(&str[i], len - i, &c1);
-		l2 = codepage->char2uni(&name->name[i], name->len - i, &c2);
+		l1 = nls_char2uni(codepage, &str[i], len - i, &c1);
+		l2 = nls_char2uni(codepage, &name->name[i], name->len - i,
+				  &c2);
 
 		/*
 		 * If we can't convert either character, just declare it to
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 7f5f3699fc6c..1aba3aaad32b 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -153,7 +153,7 @@ static int uni16_to_x8(struct super_block *sb, unsigned char *ascii,
 
 	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
 		ec = *ip++;
-		charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE);
+		charlen = nls_uni2char(nls, ec, op, NLS_MAX_CHARSET_SIZE);
 		if (charlen > 0) {
 			op += charlen;
 			len -= charlen;
@@ -195,7 +195,7 @@ fat_short2uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *uni)
 {
 	int charlen;
 
-	charlen = t->char2uni(c, clen, uni);
+	charlen = nls_char2uni(t, c, clen, uni);
 	if (charlen < 0) {
 		*uni = 0x003f;	/* a question mark */
 		charlen = 1;
@@ -210,7 +210,7 @@ fat_short2lower_uni(struct nls_table *t, unsigned char *c,
 	int charlen;
 	wchar_t wc;
 
-	charlen = t->char2uni(c, clen, &wc);
+	charlen = nls_char2uni(t, c, clen, &wc);
 	if (charlen < 0) {
 		*uni = 0x003f;	/* a question mark */
 		charlen = 1;
@@ -220,7 +220,7 @@ fat_short2lower_uni(struct nls_table *t, unsigned char *c,
 		if (!nc)
 			nc = *c;
 
-		charlen = t->char2uni(&nc, 1, uni);
+		charlen = nls_char2uni(t, &nc, 1, uni);
 		if (charlen < 0) {
 			*uni = 0x003f;	/* a question mark */
 			charlen = 1;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 82cd1e69cbdf..7f1b01e3eb7a 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -289,7 +289,7 @@ static inline int to_shortname_char(struct nls_table *nls,
 		return 1;
 	}
 
-	len = nls->uni2char(*src, buf, buf_size);
+	len = nls_uni2char(nls, *src, buf, buf_size);
 	if (len <= 0) {
 		info->valid = 0;
 		buf[0] = '_';
@@ -544,8 +544,8 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 				ip += 5;
 				i += 5;
 			} else {
-				charlen = nls->char2uni(ip, len - i,
-							(wchar_t *)op);
+				charlen = nls_char2uni(nls, ip, len - i,
+						       (wchar_t *)op);
 				if (charlen < 0)
 					return -EINVAL;
 				ip += charlen;
diff --git a/fs/hfs/trans.c b/fs/hfs/trans.c
index 39f5e343bf4d..2fae312edb31 100644
--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -49,7 +49,8 @@ int hfs_mac2asc(struct super_block *sb, char *out, const struct hfs_name *in)
 
 		while (srclen > 0) {
 			if (nls_disk) {
-				size = nls_disk->char2uni(src, srclen, &ch);
+				size = nls_char2uni(nls_disk, src, srclen,
+						    &ch);
 				if (size <= 0) {
 					ch = '?';
 					size = 1;
@@ -62,7 +63,7 @@ int hfs_mac2asc(struct super_block *sb, char *out, const struct hfs_name *in)
 			}
 			if (ch == '/')
 				ch = ':';
-			size = nls_io->uni2char(ch, dst, dstlen);
+			size = nls_uni2char(nls_io, ch, dst, dstlen);
 			if (size < 0) {
 				if (size == -ENAMETOOLONG)
 					goto out;
@@ -110,7 +111,7 @@ void hfs_asc2mac(struct super_block *sb, struct hfs_name *out, const struct qstr
 		wchar_t ch;
 
 		while (srclen > 0) {
-			size = nls_io->char2uni(src, srclen, &ch);
+			size = nls_char2uni(nls_io, src, srclen, &ch);
 			if (size < 0) {
 				ch = '?';
 				size = 1;
@@ -120,7 +121,7 @@ void hfs_asc2mac(struct super_block *sb, struct hfs_name *out, const struct qstr
 			if (ch == ':')
 				ch = '/';
 			if (nls_disk) {
-				size = nls_disk->uni2char(ch, dst, dstlen);
+				size = nls_uni2char(nls_disk, ch, dst, dstlen);
 				if (size < 0) {
 					if (size == -ENAMETOOLONG)
 						goto out;
diff --git a/fs/hfsplus/unicode.c b/fs/hfsplus/unicode.c
index c8d1b2be7854..057dc7e57cb1 100644
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -190,7 +190,7 @@ int hfsplus_uni2asc(struct super_block *sb,
 				c0 = ':';
 				break;
 			}
-			res = nls->uni2char(c0, op, len);
+			res = nls_uni2char(nls, c0, op, len);
 			if (res < 0) {
 				if (res == -ENAMETOOLONG)
 					goto out;
@@ -233,7 +233,7 @@ int hfsplus_uni2asc(struct super_block *sb,
 			cc = c0;
 		}
 done:
-		res = nls->uni2char(cc, op, len);
+		res = nls_uni2char(nls, cc, op, len);
 		if (res < 0) {
 			if (res == -ENAMETOOLONG)
 				goto out;
@@ -256,7 +256,7 @@ int hfsplus_uni2asc(struct super_block *sb,
 static inline int asc2unichar(struct super_block *sb, const char *astr, int len,
 			      wchar_t *uc)
 {
-	int size = HFSPLUS_SB(sb)->nls->char2uni(astr, len, uc);
+	int size = nls_char2uni(HFSPLUS_SB(sb)->nls, astr, len, uc);
 	if (size <= 0) {
 		*uc = '?';
 		size = 1;
diff --git a/fs/isofs/joliet.c b/fs/isofs/joliet.c
index be8b6a9d0b92..56fac73b27a5 100644
--- a/fs/isofs/joliet.c
+++ b/fs/isofs/joliet.c
@@ -25,7 +25,8 @@ uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table *nls)
 
 	while ((ch = get_unaligned(ip)) && len) {
 		int llen;
-		llen = nls->uni2char(be16_to_cpu(ch), op, NLS_MAX_CHARSET_SIZE);
+		llen = nls_uni2char(nls, be16_to_cpu(ch), op,
+				    NLS_MAX_CHARSET_SIZE);
 		if (llen > 0)
 			op += llen;
 		else
diff --git a/fs/jfs/jfs_unicode.c b/fs/jfs/jfs_unicode.c
index 0148e2e4d97a..4ca88ef661e9 100644
--- a/fs/jfs/jfs_unicode.c
+++ b/fs/jfs/jfs_unicode.c
@@ -41,9 +41,8 @@ int jfs_strfromUCS_le(char *to, const __le16 * from,
 		for (i = 0; (i < len) && from[i]; i++) {
 			int charlen;
 			charlen =
-			    codepage->uni2char(le16_to_cpu(from[i]),
-					       &to[outlen],
-					       NLS_MAX_CHARSET_SIZE);
+			    nls_uni2char(codepage, le16_to_cpu(from[i]),
+					 &to[outlen], NLS_MAX_CHARSET_SIZE);
 			if (charlen > 0)
 				outlen += charlen;
 			else
@@ -88,7 +87,7 @@ static int jfs_strtoUCS(wchar_t * to, const unsigned char *from, int len,
 	if (codepage) {
 		for (i = 0; len && *from; i++, from += charlen, len -= charlen)
 		{
-			charlen = codepage->char2uni(from, len, &to[i]);
+			charlen = nls_char2uni(codepage, from, len, &to[i]);
 			if (charlen < 1) {
 				jfs_err("jfs_strtoUCS: char2uni returned %d.",
 					charlen);
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 162b3f160353..eec257545f04 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -413,7 +413,7 @@ static int uni2char(const wchar_t uni,
 
 	if (!p_nls)
 		return -EINVAL;
-	if ((n = p_nls->uni2char(uni, out, boundlen)) < 0)
+	if ((n = nls_uni2char(p_nls, uni, out, boundlen)) < 0)
 		return n;
 
 	/* translate SJIS into EUC-JP */
@@ -543,7 +543,7 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 		sjis_temp[1] = 0x00;
 	}
 
-	if ( (n = p_nls->char2uni(sjis_temp, sizeof(sjis_temp), uni)) < 0)
+	if ( (n = nls_char2uni(p_nls, sjis_temp, sizeof(sjis_temp), uni)) < 0)
 		return n;
 
 	return euc_offset;
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index a80a741a8676..32781252110d 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -28,12 +28,12 @@ static int uni2char(const wchar_t uni,
 		else if (uni == 0x255d || uni == 0x256c)
 			return 0;
 		else
-			return p_nls->uni2char(uni, out, boundlen);
+			return nls_uni2char(p_nls, uni, out, boundlen);
 		return 1;
 	}
 	else
 		/* fast path */
-		return p_nls->uni2char(uni, out, boundlen);
+		return nls_uni2char(p_nls, uni, out, boundlen);
 }
 
 static int char2uni(const unsigned char *rawstring, int boundlen,
@@ -47,7 +47,7 @@ static int char2uni(const unsigned char *rawstring, int boundlen,
 		return 1;
 	}
 
-	n = p_nls->char2uni(rawstring, boundlen, uni);
+	n = nls_char2uni(p_nls, rawstring, boundlen, uni);
 	return n;
 }
 
diff --git a/fs/ntfs/unistr.c b/fs/ntfs/unistr.c
index 005ca4b0f132..e0a5f33441df 100644
--- a/fs/ntfs/unistr.c
+++ b/fs/ntfs/unistr.c
@@ -269,8 +269,8 @@ int ntfs_nlstoucs(const ntfs_volume *vol, const char *ins,
 		ucs = kmem_cache_alloc(ntfs_name_cache, GFP_NOFS);
 		if (likely(ucs)) {
 			for (i = o = 0; i < ins_len; i += wc_len) {
-				wc_len = nls->char2uni(ins + i, ins_len - i,
-						&wc);
+				wc_len = nls_char2uni(nls, ins + i,
+						      ins_len - i, &wc);
 				if (likely(wc_len >= 0 &&
 						o < NTFS_MAX_NAME_LEN)) {
 					if (likely(wc)) {
@@ -355,8 +355,8 @@ int ntfs_ucstonls(const ntfs_volume *vol, const ntfschar *ins,
 				goto mem_err_out;
 		}
 		for (i = o = 0; i < ins_len; i++) {
-retry:			wc = nls->uni2char(le16_to_cpu(ins[i]), ns + o,
-					ns_len - o);
+retry:			wc = nls_uni2char(nls, le16_to_cpu(ins[i]),
+						ns + o, ns_len - o);
 			if (wc > 0) {
 				o += wc;
 				continue;
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 499e486b3722..5073ecd57279 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -59,6 +59,19 @@ extern int utf8s_to_utf16s(const u8 *s, int len,
 extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
 		enum utf16_endian endian, u8 *s, int maxlen);
 
+static inline int nls_uni2char(const struct nls_table *table, wchar_t uni,
+			       unsigned char *out, int boundlen)
+{
+	return table->uni2char(uni, out, boundlen);
+}
+
+static inline int nls_char2uni(const struct nls_table *table,
+			       const unsigned char *rawstring,
+			       int boundlen, wchar_t *uni)
+{
+	return table->char2uni(rawstring, boundlen, uni);
+}
+
 static inline unsigned char nls_tolower(struct nls_table *t, unsigned char c)
 {
 	unsigned char nc = t->charset2lower[c];
-- 
2.19.1
