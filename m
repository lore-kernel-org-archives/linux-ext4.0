Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECF9448D19
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033626; cv=none; b=kmcH168cj93r2wp+dByUi9Ro35yqzEH4VX/qB2ry/XysC2yhqEtIvae9GqZ2bsdq3nbqvryxImxZ2ArU3T4Zb5z326sBK94gVmFLVQX/jsQKb4HT5YJGCpysJ+FgnfdVaMt2oMoH7crfC60ufns65HuDASyD/ebL9pCBJxaq52U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033626; c=relaxed/simple;
	bh=Uvm0H5qHNzhlMD9xZfi4hpvKhvqMCF3N2jCv41z/Df4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOt+uQGPNQYOvIbBCah+iHKVgmVqo0Aa6Zs8Ts77glT58C+qwOqAuyBM2nucKosEEMtKSnBPUTA8R/D+1gpWfiBkzNKLifuBTW7+17L7ImIjRK9LWfwJoQ1lnoMtKVHgTcEFU45G8Kwv6maUZtHSABKVcsKE9U7dq+2BMU3lHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kjoze0XR; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kjoze0XR"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493f431e317so7858335e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033623; x=1784638423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c3NUjZrhkx9QrWpS4FCvlNytPpzZZtm6t7oRtwzWsRg=;
        b=Kjoze0XR7fsk2vifrsfssXSJMOaxU9DcgnVnBTD2zzgAuIEL+PhEwxBF/wNZu+hkz1
         EUT3/QsrMezI+yD0YSOJbXhG6CduhFCLPV8eyNDmyb24nJPISEqf4mK1dHoUGyBEk6Kr
         4xbsp5aS8JiXMBgMtkJjmklmEtUE9JihiUB1urpICjt8DWaFq3rMaJkprG4/8JF3CP1F
         65ziaO/BnTAdxofPxWzLi79kNtskiuw85x8+ogJVj5Xl1rsrzrLLssWCQyS+5mAIUoG2
         2vqSu3kdjQgFgDK5dmGIM3JSATywBeAoHY0hiV7iD1J+XRtG2j/a1b7BSB84M0qGroLm
         Y9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033623; x=1784638423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c3NUjZrhkx9QrWpS4FCvlNytPpzZZtm6t7oRtwzWsRg=;
        b=bRpgdcn/qpp91aez6IPeiUbyp80o+saqe281H7wxQYAJ8fJnL+zVlFOS4enaTZTE7m
         cJZB2uz5PPIJ4Vby0p5fDLNt1oxA1X9b6X1Z3sPIMgXNgz5uBjS/2tOOzFBXWv77YkTJ
         /Vn+dDsiMpcPPjfegoFDcnPUju/8wVZW0oHwYmWLwTpDuK0BIu/qdBRJd7Cfcvdwnvr8
         Zv0kWgJQQOh7IjL/Uj2r1AFU/MYHmr3zc0ZY2qbAsRkZ0RUoxGvsnMsvy8gXNF1doA/U
         TnUt+Lg7pPkqVs3fHQRMW/qgkSnFliulUmLei00CvT0N9AIMVQYLo3LzHQ7pEKtd/8yP
         N+xg==
X-Gm-Message-State: AOJu0Yw262FsE/PQ2sHXo8bKxcE87xTuZDe28nXSeDfkAxa+aZjsRvhm
	ylyVwOl+nAJfzaDvhar4S1mlMvkZIlO+0WkIXT7RajVVil5+j9jaeI6UYXwUOrDYKcY=
X-Gm-Gg: AfdE7cmmR6mob6tOkuUvo3NWOJQJwf2gxbZSF/LTyDLei5Qei4I7KLwiNWf0kYEGq1y
	Ogg04fpPGxq/UKThPbZxEKFvxRVbdzSGmCHD1f1iUqCm9/xfW/0PnYAic4vW2nICVeTe9qVYNAv
	h0qMvil33QhSViBC/I+mE2IVJVMG2aFjHGMg+4B/H5YoQb35K1C5/0U6lNKs54qtCb+/2sjTbFv
	6uXkITDbGPG6r3AmQt6wN+5jaMv/yXXJmsyQfcSCbfYZZmSeywshR8UT4sEc+QH0BGy3CXWLPuM
	zNgHtDa1HQs1p6o0grp+3ybwAJO0fCqVRIoz/xLdBMCsVFGU2IDj29RiBB3uBHpympzK+k4KDpl
	UiSVeui/Kv3sqOIEg4qMB1dhWe4kRn/cev1GXsEyhy//5CvNz4D+inewAMTB+we6KJ6y8LdMol7
	c/2DF0gPvPDgPi/T7AZ/rNWJvfQo4loU/+7LQx8Q2iGDVb0NW3EZ9yRKnb
X-Received: by 2002:a05:600c:6304:b0:493:bb2e:11a5 with SMTP id 5b1f17b1804b1-493f87e4a48mr139974055e9.15.1784033623024;
        Tue, 14 Jul 2026 05:53:43 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:42 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v5 06/11] ext4: add ext4_dir_entry_len()
Date: Tue, 14 Jul 2026 08:51:04 -0400
Message-ID: <20260714125111.14699-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
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
index b42c918b9cb4..4c3147387e47 100644
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
@@ -4123,6 +4133,31 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
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
index 897b6fe2430a..44f5a83155b1 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -592,16 +592,17 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
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
@@ -886,10 +887,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
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
 
@@ -2326,10 +2330,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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

