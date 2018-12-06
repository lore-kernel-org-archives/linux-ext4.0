Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55610 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLFWEt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 17:04:49 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 02/23] nls: Wrap charset field access
Date: Thu,  6 Dec 2018 17:04:08 -0500
Message-Id: <20181206220429.10722-3-krisman@collabora.com>
In-Reply-To: <20181206220429.10722-1-krisman@collabora.com>
References: <20181206220429.10722-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

The goal is to simplify the following patches that split nls_table. No
behavior changes intended.

<smpl>

@@
struct nls_table *c;
@@

- c->charset
+ nls_charset_name(c)

</smpl>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/befs/linuxvfs.c     | 4 ++--
 fs/cifs/cifs_unicode.c | 6 +++---
 fs/cifs/cifsfs.c       | 2 +-
 fs/cifs/connect.c      | 2 +-
 fs/fat/inode.c         | 6 ++++--
 fs/hfs/super.c         | 6 ++++--
 fs/hfsplus/options.c   | 2 +-
 fs/isofs/inode.c       | 5 +++--
 fs/jfs/jfs_unicode.c   | 2 +-
 fs/jfs/super.c         | 3 ++-
 fs/nls/nls_base.c      | 2 +-
 fs/ntfs/inode.c        | 2 +-
 fs/ntfs/super.c        | 6 +++---
 fs/ntfs/unistr.c       | 5 +++--
 fs/udf/super.c         | 3 ++-
 include/linux/nls.h    | 5 +++++
 16 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 0ba368fbfad4..8b7af0a9011a 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -555,7 +555,7 @@ befs_utf2nls(struct super_block *sb, const char *in,
 
 conv_err:
 	befs_error(sb, "Name using character set %s contains a character that "
-		   "cannot be converted to unicode.", nls->charset);
+		   "cannot be converted to unicode.", nls_charset_name(nls));
 	befs_debug(sb, "<--- %s", __func__);
 	kfree(result);
 	return -EILSEQ;
@@ -635,7 +635,7 @@ befs_nls2utf(struct super_block *sb, const char *in,
 
 conv_err:
 	befs_error(sb, "Name using character set %s contains a character that "
-		   "cannot be converted to unicode.", nls->charset);
+		   "cannot be converted to unicode.", nls_charset_name(nls));
 	befs_debug(sb, "<--- %s", __func__);
 	kfree(result);
 	return -EILSEQ;
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index ffad8b4f90d1..2a9396d24f60 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -153,7 +153,7 @@ cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 
 surrogate_pair:
 	/* convert SURROGATE_PAIR and IVS */
-	if (strcmp(cp->charset, "utf8"))
+	if (strcmp(nls_charset_name(cp), "utf8"))
 		goto unknown;
 	len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
 	if (len <= 0)
@@ -268,7 +268,7 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	wchar_t wchar_to; /* needed to quiet sparse */
 
 	/* special case for utf8 to handle no plane0 chars */
-	if (!strcmp(codepage->charset, "utf8")) {
+	if (!strcmp(nls_charset_name(codepage), "utf8")) {
 		/*
 		 * convert utf8 -> utf16, we assume we have enough space
 		 * as caller should have assumed conversion does not overflow
@@ -527,7 +527,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 				goto ctoUTF16;
 
 			/* convert SURROGATE_PAIR */
-			if (strcmp(cp->charset, "utf8") || !wchar_to)
+			if (strcmp(nls_charset_name(cp), "utf8") || !wchar_to)
 				goto unknown;
 			if (*(source + i) & 0x80) {
 				charlen = utf8_to_utf32(source + i, 6, &u);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 865706edb307..b0531986cfd7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -414,7 +414,7 @@ cifs_show_nls(struct seq_file *s, struct nls_table *cur)
 	/* Display iocharset= option if it's not default charset */
 	def = load_nls_default();
 	if (def != cur)
-		seq_printf(s, ",iocharset=%s", cur->charset);
+		seq_printf(s, ",iocharset=%s", nls_charset_name(cur));
 	unload_nls(def);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6f24f129a751..3011276a06f0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3191,7 +3191,7 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	    old->mnt_dir_mode != new->mnt_dir_mode)
 		return 0;
 
-	if (strcmp(old->local_nls->charset, new->local_nls->charset))
+	if (strcmp(nls_charset_name(old->local_nls), nls_charset_name(new->local_nls)))
 		return 0;
 
 	if (old->actimeo != new->actimeo)
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index c0b5b5c3373b..2563dc306e7f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -948,10 +948,12 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",allow_utime=%04o", opts->allow_utime);
 	if (sbi->nls_disk)
 		/* strip "cp" prefix from displayed option */
-		seq_printf(m, ",codepage=%s", &sbi->nls_disk->charset[2]);
+		seq_printf(m, ",codepage=%s",
+			   &nls_charset_name(sbi->nls_disk)[2]);
 	if (isvfat) {
 		if (sbi->nls_io)
-			seq_printf(m, ",iocharset=%s", sbi->nls_io->charset);
+			seq_printf(m, ",iocharset=%s",
+				   nls_charset_name(sbi->nls_io));
 
 		switch (opts->shortname) {
 		case VFAT_SFN_DISPLAY_WIN95 | VFAT_SFN_CREATE_WIN95:
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 173876782f73..b16ca01180a5 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -151,9 +151,11 @@ static int hfs_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbi->session >= 0)
 		seq_printf(seq, ",session=%u", sbi->session);
 	if (sbi->nls_disk)
-		seq_printf(seq, ",codepage=%s", sbi->nls_disk->charset);
+		seq_printf(seq, ",codepage=%s",
+			   nls_charset_name(sbi->nls_disk));
 	if (sbi->nls_io)
-		seq_printf(seq, ",iocharset=%s", sbi->nls_io->charset);
+		seq_printf(seq, ",iocharset=%s",
+			   nls_charset_name(sbi->nls_io));
 	if (sbi->s_quiet)
 		seq_printf(seq, ",quiet");
 	return 0;
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 047e05c57560..2d6644465566 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -230,7 +230,7 @@ int hfsplus_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbi->session >= 0)
 		seq_printf(seq, ",session=%u", sbi->session);
 	if (sbi->nls)
-		seq_printf(seq, ",nls=%s", sbi->nls->charset);
+		seq_printf(seq, ",nls=%s", nls_charset_name(sbi->nls));
 	if (test_bit(HFSPLUS_SB_NODECOMPOSE, &sbi->flags))
 		seq_puts(seq, ",nodecompose");
 	if (test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 488a9e7f8f66..b23a3955b8c6 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -520,8 +520,9 @@ static int isofs_show_options(struct seq_file *m, struct dentry *root)
 
 #ifdef CONFIG_JOLIET
 	if (sbi->s_nls_iocharset &&
-	    strcmp(sbi->s_nls_iocharset->charset, CONFIG_NLS_DEFAULT) != 0)
-		seq_printf(m, ",iocharset=%s", sbi->s_nls_iocharset->charset);
+	    strcmp(nls_charset_name(sbi->s_nls_iocharset), CONFIG_NLS_DEFAULT) != 0)
+		seq_printf(m, ",iocharset=%s",
+			   nls_charset_name(sbi->s_nls_iocharset));
 #endif
 	return 0;
 }
diff --git a/fs/jfs/jfs_unicode.c b/fs/jfs/jfs_unicode.c
index 4ca88ef661e9..1e89b3b8caa7 100644
--- a/fs/jfs/jfs_unicode.c
+++ b/fs/jfs/jfs_unicode.c
@@ -92,7 +92,7 @@ static int jfs_strtoUCS(wchar_t * to, const unsigned char *from, int len,
 				jfs_err("jfs_strtoUCS: char2uni returned %d.",
 					charlen);
 				jfs_err("charset = %s, char = 0x%x",
-					codepage->charset, *from);
+					nls_charset_name(codepage), *from);
 				return charlen;
 			}
 		}
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 65d8fc87ab11..a04ff4bc5afd 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -736,7 +736,8 @@ static int jfs_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbi->flag & JFS_DISCARD)
 		seq_printf(seq, ",discard=%u", sbi->minblks_trim);
 	if (sbi->nls_tab)
-		seq_printf(seq, ",iocharset=%s", sbi->nls_tab->charset);
+		seq_printf(seq, ",iocharset=%s",
+			   nls_charset_name(sbi->nls_tab));
 	if (sbi->flag & JFS_ERR_CONTINUE)
 		seq_printf(seq, ",errors=continue");
 	if (sbi->flag & JFS_ERR_PANIC)
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 52ccd34b1e79..e5d083b6e2b2 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -277,7 +277,7 @@ static struct nls_table *find_nls(char *charset)
 	struct nls_table *nls;
 	spin_lock(&nls_lock);
 	for (nls = tables; nls; nls = nls->next) {
-		if (!strcmp(nls->charset, charset))
+		if (!strcmp(nls_charset_name(nls), charset))
 			break;
 		if (nls->alias && !strcmp(nls->alias, charset))
 			break;
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index bd3221cbdd95..872ef265b117 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2313,7 +2313,7 @@ int ntfs_show_options(struct seq_file *sf, struct dentry *root)
 		seq_printf(sf, ",fmask=0%o", vol->fmask);
 		seq_printf(sf, ",dmask=0%o", vol->dmask);
 	}
-	seq_printf(sf, ",nls=%s", vol->nls_map->charset);
+	seq_printf(sf, ",nls=%s", nls_charset_name(vol->nls_map));
 	if (NVolCaseSensitive(vol))
 		seq_printf(sf, ",case_sensitive");
 	if (NVolShowSystemFiles(vol))
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index bb7159f697f2..1c68c33e9816 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -224,7 +224,7 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 				}
 				ntfs_error(vol->sb, "NLS character set %s not "
 						"found. Using previous one %s.",
-						v, old_nls->charset);
+					   v, nls_charset_name(old_nls));
 				nls_map = old_nls;
 			} else /* nls_map */ {
 				unload_nls(old_nls);
@@ -274,7 +274,7 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 					"on remount.");
 			return false;
 		} /* else (!vol->nls_map) */
-		ntfs_debug("Using NLS character set %s.", nls_map->charset);
+		ntfs_debug("Using NLS character set %s.", nls_charset_name(nls_map));
 		vol->nls_map = nls_map;
 	} else /* (!nls_map) */ {
 		if (!vol->nls_map) {
@@ -285,7 +285,7 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 				return false;
 			}
 			ntfs_debug("Using default NLS character set (%s).",
-					vol->nls_map->charset);
+				   nls_charset_name(vol->nls_map));
 		}
 	}
 	if (mft_zone_multiplier != -1) {
diff --git a/fs/ntfs/unistr.c b/fs/ntfs/unistr.c
index e0a5f33441df..a30911979a55 100644
--- a/fs/ntfs/unistr.c
+++ b/fs/ntfs/unistr.c
@@ -297,7 +297,7 @@ int ntfs_nlstoucs(const ntfs_volume *vol, const char *ins,
 	if (wc_len < 0) {
 		ntfs_error(vol->sb, "Name using character set %s contains "
 				"characters that cannot be converted to "
-				"Unicode.", nls->charset);
+				"Unicode.", nls_charset_name(nls));
 		i = -EILSEQ;
 	} else /* if (o >= NTFS_MAX_NAME_LEN) */ {
 		ntfs_error(vol->sb, "Name is too long (maximum length for a "
@@ -386,7 +386,8 @@ retry:			wc = nls_uni2char(nls, le16_to_cpu(ins[i]),
 conversion_err:
 	ntfs_error(vol->sb, "Unicode name contains characters that cannot be "
 			"converted to character set %s.  You might want to "
-			"try to use the mount option nls=utf8.", nls->charset);
+			"try to use the mount option nls=utf8.",
+			nls_charset_name(nls));
 	if (ns != *outs)
 		kfree(ns);
 	if (wc != -ENAMETOOLONG)
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8f2f56d9a1bb..284087eb64d0 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -361,7 +361,8 @@ static int udf_show_options(struct seq_file *seq, struct dentry *root)
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
 		seq_puts(seq, ",utf8");
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP) && sbi->s_nls_map)
-		seq_printf(seq, ",iocharset=%s", sbi->s_nls_map->charset);
+		seq_printf(seq, ",iocharset=%s",
+			   nls_charset_name(sbi->s_nls_map));
 
 	return 0;
 }
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 5073ecd57279..cacbcd7d63e6 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -72,6 +72,11 @@ static inline int nls_char2uni(const struct nls_table *table,
 	return table->char2uni(rawstring, boundlen, uni);
 }
 
+static inline const char *nls_charset_name(const struct nls_table *table)
+{
+	return table->charset;
+}
+
 static inline unsigned char nls_tolower(struct nls_table *t, unsigned char c)
 {
 	unsigned char nc = t->charset2lower[c];
-- 
2.20.0.rc2
