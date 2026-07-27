Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC4C3E5A1D
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186788; cv=none; b=Umh4SAT1uTdkaMwLnz4lWX1KgCKJJ0ezAYtCQPatfQMN4KJwdWR7SNAHY+griyMP+RT0Fpin/6GiFpKyxu53H+OWKmcYUutoEOlczUgtQ1J3D4ikrCRyo72E/kVjXLBoVvp6ZeXMrzyT4pNJlytNYYYlbi6sw4XBEz8+6/0M4A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186788; c=relaxed/simple;
	bh=CbDw+fjYRyXLgjbeEsTSnrlBFxLPcAoNc5jfDPf2qR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhSX2LfAI+Qu/d1abU7bhdhvSGMsv/Ni5MN7H6uA4nclcfWTEzI02klKIoTLiz339RDdqFjaY0CMKSWFqfco2hCkz7OTKfhtR3olHYk5Y+h9HsWL+mNVb3sp2FNEFJDfdIx0EtD0jjswdLDrhS1LQa8LJSmEXQ+Wqv9euJXpvro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n9WJv71B; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n9WJv71B"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-496b7622a83so14889375e9.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186785; x=1785791585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5cLq3l213qCX3ohZHGBbCJcSRulTjS0jIwCcsAUbXyM=;
        b=n9WJv71BOeEv7+MQxRK2x17KWN7dcWpZgkJsks0EidUy5b31ja044IqDJRn7IZO8cq
         4ZtUl8qEC+lC8320C/ab/e2yFNTPitFlJO2dvTqSBuU/El3vIYm2EIpr+wRh5k0WKS2r
         LsFvNQ5fVQKL4tPohaZj2EfG4qYNAZAPzpKpHHUBusgk/oTdjJtg0l9f+u6X4r/UOFlL
         Mkpg/NhZfO9u2wXyXJkFC0MA2cawd/iAjFCyNnZ/+zkrYas3dsaaHOI7DqMI4PpiUItF
         Y+DUCW9WMft6As752LhMAWyBdVppmiw4KiPbYabNAkzQD78LgCg0dlXxtneYo4Ku9Q0m
         H+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186785; x=1785791585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5cLq3l213qCX3ohZHGBbCJcSRulTjS0jIwCcsAUbXyM=;
        b=Nplf3V69zgZgWa+qDmb6LvyqMS+5U7UDa42S1W0KtwVpqgA4esyG8JlMjbRBFu5QMW
         5819C/3fiFGpbRvPLtBBGZu8WpjCDH6jIQVJmMkf2eDlzVvChShze2dycEvc8XDh0s+X
         VpfTbn0vW91T8Co3bLNBg/o76ANTIjVJh7O8hePuj60AFOZHkZD/JJHwlGpfFZJuXuNY
         pob9Typd39ofSA1qX/pUhlAXbl1Bsng0bxjieG39dRQO0ELxDo7Eg0BD0WkMfa7hr+Ds
         DjdfzVaGd5ecUtgiAXCMi7NzuPSPpJsI3OJbpC9pIrB+Wlj7qE3kJE7DGMiuY2pgb52c
         jyIg==
X-Gm-Message-State: AOJu0Yy0xWbtGEk5lWx4v54yd+f/adbgOTshCsn4VrU2S7/Z5D5VNiYu
	MGmHxr2ieLZnbJCcOgwnit3eEpN+fgqCPM5QyVLq30iPa+BNcr0Lixfrto0m2PeP
X-Gm-Gg: AR+sD11yrSFW9GPrYAexNJRylKnTJvU5bb+6dY6I5gnocHWWpZSGmFLHxB7cJOMtwnz
	GoCtY+4QWRZbrgMNXY3teqmz5BIl4hX21tdZb9crmwbFqixA9b0H5BtFbCry6T+C+hZP7PsLkok
	cPlPGnLvgLhwaSgXAqAFsW+D6ncgRfxtQyOf98Jg6a8hYvtl09got7GXrZKW+3uSW+1g/3CPVjI
	pO4Ts2DkBok/ww/jLi6lc8/17a40gGWOeW1t9T+ts85NjKQUzAP7VmujRZ+/Bc+l1sSLRwP7v8w
	siKC/sMZkmd0eObZN/9ApGLnrAH9a0FZVEsZ2vEtCg7DR0PkNdUz0HG+RF4JRTY6zaAGwTXuJfJ
	2CazUTfqvutuJ0Z/08fpKnO9qXWkMn5lAB+o/sELenHXUGlkw3im0RUq90uGRrrdOdz3IusEAd1
	5QV6GEDdsfiyPDBMlsdozqRGvnUu5Cm0bmSw==
X-Received: by 2002:a05:600c:a102:b0:493:c77c:108a with SMTP id 5b1f17b1804b1-496b575ded2mr96825465e9.36.1785186785243;
        Mon, 27 Jul 2026 14:13:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:04 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v6 06/11] ext4: add ext4_dir_entry_len()
Date: Mon, 27 Jul 2026 17:11:18 -0400
Message-ID: <20260727211125.19632-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
References: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Introduce ext4_dir_entry_len() helper to compute the required
rec_len for a directory entry, taking into account dirdata and
casefold+fscrypt hash space.

Update dx_root_limit() to use ext4_dir_entry_len() instead of
open-coded ext4_dir_rec_len() for '.' and '..' entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  | 43 +++++++++++++++++++++++++++++++++++++++----
 fs/ext4/namei.c | 20 ++++++++++++--------
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a43f36c05549..a6e857690352 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2620,7 +2620,15 @@ static inline unsigned int ext4_dir_rec_len(__u8 name_len,
 {
 	int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
-	if (dir && ext4_hash_in_dirent(dir))
+	/*
+	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position
+	 * after the filename and must be reserved explicitly.  With dirdata the
+	 * hash is stored as a CFHASH extension and is already counted in the
+	 * name_len argument (via ext4_dirent_get_data_len), so adding it again
+	 * would double-count.
+	 */
+	if (dir && ext4_hash_in_dirent(dir) &&
+	    !ext4_has_feature_dirdata(dir->i_sb))
 		rec_len += sizeof(struct ext4_dir_entry_hash);
 	return (rec_len & ~EXT4_DIR_ROUND);
 }
@@ -3044,12 +3052,14 @@ static const unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
+static inline unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	unsigned char fl_index = filetype & EXT4_FT_MASK;
+
+	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	return ext4_filetype_table[fl_index];
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
@@ -4126,6 +4136,31 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
 	return dlen;
 }
 
+/*
+ * ext4_dir_entry_len() - Compute the required rec_len for a directory entry.
+ * @de:        directory entry (used to read name_len and any dirdata length)
+ * @blocksize: size of the buffer @de lives in (the real directory block
+ *             size, or the smaller inline-data buffer size for inline
+ *             directories) -- used only to decode @de->rec_len's "0/65535
+ *             means rest of buffer" sentinel correctly.
+ * @dir:       directory inode (may be NULL for '.' and '..' entries, which
+ *             never carry the casefold+fscrypt hash regardless of the
+ *             directory's feature flags)
+ *
+ * Returns the minimum record length needed to hold @de, rounded up to the
+ * directory alignment and including room for the casefold+fscrypt hash if
+ * the directory requires it.
+ */
+static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
+					      unsigned int blocksize,
+					      const struct inode *dir)
+{
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
+
+	return ext4_dir_rec_len(de->name_len + dirdata, dir);
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a774ef6529aa..5115d660d9fc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -595,16 +595,17 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(struct inode *dir,
+	struct ext4_dir_entry_2 *dot_de)
 {
-	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(1, NULL) -
-			ext4_dir_rec_len(2, NULL) - infosize;
 	struct dx_root_info *info;
+	unsigned int entry_space;
 
 	info = dx_get_dx_info(dir, dot_de);
 	if (IS_ERR(info))
 		return 0;
+	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
+		info->info_length;
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -889,10 +890,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
 	entries = (struct dx_entry *)(((char *)info) + info->info_length);
 
-	if (dx_get_limit(entries) != dx_root_limit(dir, info->info_length)) {
+	if (dx_get_limit(entries) !=
+	    dx_root_limit(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data)) {
 		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
 				   dx_get_limit(entries),
-				   dx_root_limit(dir, info->info_length));
+				   dx_root_limit(dir,
+				   (struct ext4_dir_entry_2 *)frame->bh->b_data
+				   ));
 		goto fail;
 	}
 
@@ -2333,10 +2337,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		dx_info->hash_version =
 				EXT4_SB(dir->i_sb)->s_def_hash_version;
 
-	entries = (void *)dx_info + sizeof(*dx_info);
+	entries = (void *)dx_info + dx_info->info_length;
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
+	dx_set_limit(entries, dx_root_limit(dir, dot_de));
 
 	/* Initialize as for dx_probe */
 	fname->hinfo.hash_version = dx_info->hash_version;
-- 
2.43.7

