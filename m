Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC2E3CA49A
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354876; cv=none; b=aFC0HHkbYlLz26+XNGW7VxR3GGY/61394D/l1X+vGySIeRVgyaYQuwcSam5b0T9Dq9rdE9t3T4G0Ah0GZuaCpa2xyMgEn6WPTPxSwdmF/g09SiH7qwVfbkgDTk+n6eRSgoz6lA3I2TDv4q5O0AyJsSedtubmzc1G93l8ov5rmrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354876; c=relaxed/simple;
	bh=Xd/q/l008yQNV29JOq71B4H0agY6V/JndYlkCN3xaeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbNOlbWSFnmLrAqmNmo53dUDVIHrnPAT58CnTWqo6KTCGbpNvnxhE1oCoQ+Q4AK83l0EaZQLiyA6q3h5UPoST5pmg0Xoh/o8PvUR1dFST+umE1ivEcJz0SArCKnZwHmeZWq64hY4zZqGOSU0tXk8wbOAE5IZNNxeKGGXqUcJAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GzB2Rj8G; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzB2Rj8G"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4955de8797cso9365235e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354873; x=1785959673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pw47f5d0tJz2FQJvd5mkhw1j1FBPWqejaFPpc9YqHas=;
        b=GzB2Rj8G2tutkbLoKY/Jf28J2rkj1Z2ai2lj2cUrWDrBgBoD4/Z4cYZdvlo825F3N9
         CAka7tEIXYg9IU2Kp9JOEkal9xf5vt0xLEUqri4oNdXY5liBkKvgWvDC4vPyhlg+8WzB
         YbH1E47LmCjPT/7YyZz/pe5n/BFLgIoE36ZEDVAN/5iIq7EhUXWgFbfhQHx7fF2TCmFz
         3hrYczEhU4YWDS0g2qERBnDghFB5bKNrxTB0PDFgtR8xR+qfVAWc44uAupb6xb1PdhYr
         MrEMCM+CcElOfof3Sxx2uYV8roHVYFwtYAw1M1fMe2nbSV74DyCabQ7QMzT1+gA7VMHV
         oRjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354873; x=1785959673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pw47f5d0tJz2FQJvd5mkhw1j1FBPWqejaFPpc9YqHas=;
        b=gCPdY/A5mLC+JGfn/0LptPKiUsva5KyoBkZoFo+yCuEHRct66Ylse2Dw+HSuBjFc0e
         Xsc5JZ5KWIdHpZDZZrL3lAIlFDAVCm9tfF6cv+ZskvW3ouHjsaCc1KY7VimxJwe8zlMk
         bjxYBIirQPebntkvVmVVqqXDc819KKmq1EviavqVbUO2Ko235nfXIA01qdwX7E6Q/EFs
         k3MnYjRG1ocJFcZtb8JOqEcnOO6/uBDxfHL9iGUaatvztnxTGxsByqhQ5TwH3713jSwt
         6gdWJ46AXv5YKawHX3rdnTsBLgBxHojQ7IchyDFn5Y1f79fHx2tkHiFFdIyErPHQ2UME
         drtQ==
X-Gm-Message-State: AOJu0YzNQ8UhiNswx5EmtU9EMdaoBBfLeFKsqxszUdl381aMFJE5xfWa
	MIsPsCZFFR+CFMt4Rly/Db66sLDmIJQuya7X873ekEctlN/PLHw6vcuB7/3m6ApI
X-Gm-Gg: AR+sD10SKQmIb+UC56wAHBQn1xWzm5lsLPPr3Lm20dEmKwb/8e1+HFLU/xFwazIM9qC
	uODI8+9VCFfl9IKOrSmRe50Ptr64tyjX8k3MayyVg7vtyDa/N713JGnSUKOyMM+rBwLeswjSClw
	ATzvo4THz3zTFcPplpjYoySskFwx9M3cd/DqzQasUlTHN3AF038qo8zFXm3ci7M5qENWpV4yNa6
	xjxNIcBucVj6y4oe+P/kfL7lkvvStwPX7eqEEIP9eE0SE1e3c6Z3yYX5saehVJhZnQuEgHBKUd9
	muwB6naE7jz8SlVYzdxkYJA3RNLgKIXzTsmYzhAkewZYXgspE4fY7S7qbTvDLj+y9nzAXYR8IGR
	pQg1hDUzzWDkU4HUwRLoLOtURZy5b+5z1hxPO9Xe4zVEOaW+HlHZQUnwHCKL7jHy+X4hDpa0RpU
	6rWA2K8otSk+ScFS6KKMTl7rhxWKwfftQRm7fPISufb1lwVwdQXVcL578yM30syaBUYd+QQyGvd
	oj4Z/9hsQnJwe8nI5Gh
X-Received: by 2002:a05:600c:a44:b0:496:bba5:33a7 with SMTP id 5b1f17b1804b1-496c659679emr89731745e9.27.1785354872720;
        Wed, 29 Jul 2026 12:54:32 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:32 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v8 06/11] ext4: add ext4_dir_entry_len()
Date: Wed, 29 Jul 2026 15:53:24 -0400
Message-ID: <20260729195333.20626-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
References: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
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
index c2aa4fee8c37..b93460a28c17 100644
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
@@ -4127,6 +4137,31 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
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
index aa2474379f37..22938ce6f1a3 100644
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
 
@@ -2338,10 +2342,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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

