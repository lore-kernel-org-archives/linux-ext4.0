Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E484B302163
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785608000; cv=none; b=HpKqhSTGQI9AQRgh1PT1uOljKgby6Zrot3kKyV4LqnyKWWRVEevIJm16Kjfd4+I5ouPER4wkqbOyv7uWqvE9SGBGQHOH9XLn7CUws8vPrP4J8i6TouBcSbCfE1jyWJRW+BkIOumEmPWxiqWQk++zO0gfWYn3XGmFoAMp6unQZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785608000; c=relaxed/simple;
	bh=4h2/6qD5pR0qT7s6SW1H4JGhx8CIJrQOvMA1K8tF64Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7VXdysjg1HSal0kQoVJgP1mAZEp3asUMjAhl42w6OqaVVhMesRpK6ITKDlzMSOiOjxkOggexNKju/kaL8r9gf/moBjBjnNBRLNdJE9YA/3zvxTm7vrtfqESrQLycstqAOA5DGcIszW7Q0n53zsH02gzgIgu5KQfHMzilBCcvkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QoxpW334; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QoxpW334"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954aff6088so6222285e9.3
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607997; x=1786212797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xXCJXznpnad+ctuf77995xRRJrHzHUwfM7l6wbZHb3A=;
        b=QoxpW334uF3GO0hEqu8FSZogH1OoSg+l5ihszPaXo8FdHyOpdhI382V1fhzZ0cFk8Y
         juiuhRQRRJwzvcHbRBljO1yA/3y9noMke0xNKc8hDm6TwnJ4a/RmP/PhKnZo4LUSjqP4
         0fE6vPA2Y5sIz4o1ntf+6PqYX+65T6uZuH0GJR4hZPuldgyDlexOvknkPCOlb5hBOqwf
         Llgwf4FV4jd9FNVA1IbLq0SpYbiyz1Cs/sJ2eLDiRhgPc0rjlnzEGVY1MmNOYGAnOi5s
         FlAF0XTNRjbWMD++2oBpq/cGhHq5uGmdx/B7u3YKYkFOodqRgdlAnUJaYGX9Lt1nc2K4
         cKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607997; x=1786212797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xXCJXznpnad+ctuf77995xRRJrHzHUwfM7l6wbZHb3A=;
        b=nz+XJpmsGtOzJ96BQoakk7SzJ1HxJkfC1nusHfhiPIQfUkyblKvBRlSo4o4pvGq/U9
         BPqmNA68BqghNHDD6rauhDtT1fY1RY4nN42Al8qslx7c2y4QwJ7tHSP47jjpIYqHASVJ
         9hqMG0/60CXl54bKK5yD0jN8dc3UvRgsywcY6BD+shZwO6fX5vAqrcqH0b/k1LhsPrtu
         +6R7vSzArNo/qLhQgfYUWOsWEXqy8Yk92GCRwmN0fXGd8tEg88rwW19EHuT2e02aj9/f
         DG3EjOkdkXWMZzfjN3xwGTVrJcW4XVmYdd4TIz6bRsJZA0VcOD10r7tvRkpWi9AupTUG
         ydpg==
X-Gm-Message-State: AOJu0YzrcVaR9F0CpvjFGrNOOeeM0X+tZplqgbGzdGWR4fAm6OLqyCAd
	BzgAxCeXLvOZjJmUzgLJ1yuKnaL/ddyZ5HzDUBJ+ybGGjoTPSRyK+shfolNVtw==
X-Gm-Gg: AR+sD12NE6WKsmkmgK4Xv/3hEUBRShWEjSJW+25ZnGo0OFm1LFT9dYEICNwLCCx42eF
	B/foYUY61wyxlgkh2/z0FGiGY8ccDtjyaMdF8rTvyKb71RBQsQYkrcs8NE8VNidk/PhMivuaj0Z
	8JWqWfr6UsInz0cf5PgYy0DwnGIh+4UoEIzCpDnPad0NWAxt05LIXnl2zkrunUIPY9JIwkI3pTv
	V/hJsTqeCAggdZVkqgIJsbkEuRuSrwp2gj2zLcoe0/UuSqo5OQkVryEsBK9i7TYn7yZn56dNSpU
	WmxBZxgPg+E5smKwvsMep8uEwK/VqhaTqMjogqxK7DbT4BYRcnvcrYuvDpcpILm8fcYpUNQm/VB
	jXbkLsAFvb7pdk5iOUZ7TWrt7VBJSuDvLV+6bUQTBsrA4nKD02OhRBMbHZnFaSG5Q06j7gTPfNo
	AnfGgoEnu0ripMMQeWuOxkfplTwQWAirVWah7A2PRINvYcy7rAQfhF6MVlw+m+ax6uBVAnq0Urh
	xSLp8ISkTFWc6RGfeil
X-Received: by 2002:a05:600c:5395:b0:493:faf3:3ea5 with SMTP id 5b1f17b1804b1-4980c66c751mr88274555e9.4.1785607997033;
        Sat, 01 Aug 2026 11:13:17 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:16 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 06/11] ext4: add ext4_dir_entry_len()
Date: Sat,  1 Aug 2026 14:12:20 -0400
Message-ID: <20260801181227.5198-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h  | 44 ++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/namei.c | 20 ++++++++++++--------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index edeb63407c3f..68eaefa93085 100644
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
@@ -4135,6 +4145,32 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
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
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3eefd10133d7..f98e05f9dcf9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -596,16 +596,17 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
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
@@ -890,10 +891,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
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
 
@@ -2339,10 +2343,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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

