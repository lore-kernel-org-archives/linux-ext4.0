Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6607336885
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896320; cv=none; b=eMmO+c7LyhDRBEv11XYHT1tI2FkzvbjJZU5J7PDGNkIYmG4Gr+/TJqJwxfMazD/fDYMJwzZd/5CiEz6lyBGdv30cDlHUWZXo45vJPVo59JqtnWrAv9YlN5HR+nqYVe+FhzBDLYcz22KNrWdwig+w/RwA+3pxQI5LgbIPkcqeOnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896320; c=relaxed/simple;
	bh=QrUS2kUQ4CJVMCU51QxH9UwPWHDUTVLOGXa5dwTAyJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiIO3AyBY60K+czMTHOtBjTaMSyViaEMwxMxhU2tdj3ND9UbxeysVl91sYnBoZ1FjFF0ZjbBwofSej99lF/Atkel2nJYg7Ie08XLB6HYrkwI+IG2svTcZPaPqPislIbw5kL/fqgkySHVBWZaUPxt29BVL3AqcEWSic6Uzl33rk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=huFuj6oe; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="huFuj6oe"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-46255b269c2so1861922f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896317; x=1782501117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5ETFTmziePAVgi2M57B5xKWFF0neUIbLN1YzU0PbpU=;
        b=huFuj6oe8T3SVAcLAUCPTnI22cIjR+Sg35ueq3P3XqZ6dI6V4C+xgOEpLXdNq9dhQQ
         Qz1Fu/pQ48Rdjn9rTCBfBWMNVORp62lwkLnpyYMoGCO85zs/4nB308MB82u2O+3fgL5w
         Nn6TecdTQ4prgItRkwK2f//9B3OnLSjVEpfghSXyh8Zd3qukAwtMjwOvI8EUIFzHf8pc
         6FIdEeHaMvsN2bMV3AdOyJrzVulu9llQUR5g7KfzKUvOl/R/m/rsOc/NQhVRTF6hmFd3
         C98yWEu2/b8vRe6iS5fz1nB5Gcy6pqmovmCVLa+zmpiV7DgI7dQbXDnyVgikg8AvraGO
         14hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896317; x=1782501117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o5ETFTmziePAVgi2M57B5xKWFF0neUIbLN1YzU0PbpU=;
        b=jmuG28AJuyXR7vMwf2QE3cYRFVp+kdVxNrxlOirPm84chdYvcDOUx8fuPDdmB8TUkS
         ztW59YAlOryRF/iv29VHEghE3q47heJ26Qc1uxsFOp7NaoFKatpr2W28PWDABItpmzC1
         Tmbj+LpmPMDoasjy4u7r9WnAKes4gtKUAK94roMV8YdlPmuGxr+TCKkblvN6KeydlNsu
         14yMtwqFcVMGpkzLqMvSoNypH19P3RaUq4z9OUd2pPt0YDm4Y/3dvZOCCliRBTsRvkZj
         4Un9qadvZupeled0239l+x5ph2HxHDFXVc2kn3UFtZk/yoEvIcC66aY1n57wOBWcWUxg
         nYHg==
X-Gm-Message-State: AOJu0Yw/keCj4tqk+yRIJXrQayqlLxOIs921SDrrkpvIMHsSa51VkKdY
	UE6jbmcMZkx+QdFk5qxSD8Axu4ps/e0Z0CwxnVhIPRtd5MsmhW9VHVAiyWaF+5E5TA1Csw==
X-Gm-Gg: AfdE7cngNjAJaJl/r7SG9220bqf57x6N7xGew3cESj6z5a+YdmVKHfC6ZrXsjsAD67y
	37ty6JfE9xVV+Yv/RaryO8k3DyC2VtRCuvhom2L7G526CKg8QnPdrlIdX3mSqAPdXdkUN6NjST9
	ATaeVTjWMDXYgE0BQVYqtBI8dsGQ6jfS96gr+zduoG11NIk6KixVwZ1WwvzQOV00b1TTSr+JMBu
	5XTBQA90LMiApUfC0ZW7DTFDy4lGeBVv/9geg05aykJS1p40euM7LRYiqJx9Rh+Q+1jWMba8tlz
	JECVOia1ur8rKY/gffnLSHASxh4keCtQrIkVRCapMJhVsay2fkk7TclmLigkZ8BnL9PDtLFHlXt
	aiJ5i3yBfxDTHve4hW9vqKKeR4sA9xh8eafuJ6YWTzSX/Rm/dphafJyveQ8/9Yreh7I9HYgvoKe
	BtqafHyBz7UnFqkzWaXEvRiqStFx/nH+h6lM7rJa4N2AQZCHLUp5O5
X-Received: by 2002:a05:600c:3548:b0:490:c6c2:bdc2 with SMTP id 5b1f17b1804b1-4923ef518bfmr104607845e9.4.1781896317321;
        Fri, 19 Jun 2026 12:11:57 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:57 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 06/10] ext4: add ext4_dir_entry_len() and harden dirdata parsing
Date: Fri, 19 Jun 2026 15:10:10 -0400
Message-ID: <20260619191022.27008-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
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

Convert ext4_dirent_get_data_len() to take the decoded rec_len
as an argument and add bounds checking when walking dirdata
extensions to avoid overruns on malformed entries.

Update dx_root_limit() to use ext4_dir_entry_len() instead of
open-coded ext4_dir_rec_len() for '.' and '..' entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  | 45 ++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/namei.c | 23 +++++++++++++++--------
 2 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2f29f50a12ac..fd979452391f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4075,6 +4075,7 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 /*
  * ext4_dirent_get_data_len() - Compute the total dirdata length for an entry.
  * @de: directory entry
+ * @rec_len: the record length of the directory entry (decoded)
  *
  * Computes the length of optional data stored after the filename (and its
  * implicit NUL terminator).  Each extension is indicated by a bit in the
@@ -4083,22 +4084,41 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
  *
  * Returns 0 for tail entries and for entries with no dirdata.
  */
-static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
+static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
+					   unsigned int rec_len)
 {
 	__u8 extra_data_flags;
 	struct ext4_dirent_data_header *ddh;
 	int dlen = 0;
+	unsigned int offset;
 
 	if (ext4_dir_entry_is_tail(de))
 		return 0;
 
 	extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
-	ddh = (struct ext4_dirent_data_header *)(de->name + de->name_len +
-						 1 /* NUL terminator */);
+	/* offset from start of entry to after filename + NUL */
+	offset = EXT4_BASE_DIR_LEN + de->name_len + 1;
 
+	/* bounds check: ensure we start reading within the entry */
+	if (offset >= rec_len)
+		return 0;
+
+	ddh = (struct ext4_dirent_data_header *)((char *)de + offset);
+ 
 	while (extra_data_flags) {
 		if (extra_data_flags & 1) {
+			/* bounds check before reading ddh_length */
+			if (offset + sizeof(*ddh) >
+			    rec_len)
+				return dlen;
+
+			/* validate ddh_length is reasonable */
+			if (ddh->ddh_length == 0 || ddh->ddh_length >
+			    rec_len - offset)
+				return dlen;
+
 			dlen += ddh->ddh_length + (dlen == 0);
+			offset += ddh->ddh_length;
 			ddh = ext4_dirdata_next(ddh);
 		}
 		extra_data_flags >>= 1;
@@ -4106,6 +4126,25 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
 	return dlen;
 }
 
+/*
+ * ext4_dir_entry_len() - Compute the required rec_len for a directory entry.
+ * @de:  directory entry (used to read name_len and any dirdata length)
+ * @dir: directory inode (may be NULL for '.' and '..' entries)
+ *
+ * Returns the minimum record length needed to hold @de, rounded up to the
+ * directory alignment and including room for the casefold+fscrypt hash if
+ * the directory requires it.
+ */
+static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
+					      const struct inode *dir)
+{
+	unsigned int blocksize = (dir && dir->i_sb) ? dir->i_sb->s_blocksize : 4096;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
+
+	return ext4_dir_rec_len(de->name_len + dirdata, dir);
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 7692cf5184ab..a20ba9a6a15b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -570,11 +570,15 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(struct inode *dir,
+	struct ext4_dir_entry_2 *dot_de)
 {
-	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(1, NULL) -
-			ext4_dir_rec_len(2, NULL) - infosize;
+	struct dx_root_info *info;
+	unsigned int entry_space;
+
+	info = dx_get_dx_info(dot_de);
+	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
+		info->info_length;
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -850,10 +854,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
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
 
@@ -2278,10 +2285,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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

