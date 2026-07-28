Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2234248AE
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282253; cv=none; b=Vv9RJVcVvlA6iH9J07gjvNCA4ynpE/rwSUD9o1jfPX0OMnaik6KKTgANJ+ia+B4uVrOg8bV3qJ2dW/lv27M0Bt9teuz3wQB6n6yQqwTtzlIhu4msOnRk6fhXw7miMVLTJmEOmThrm9rw5RjPls4XbgXpu7USYUxGpbrehavqCnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282253; c=relaxed/simple;
	bh=CbDw+fjYRyXLgjbeEsTSnrlBFxLPcAoNc5jfDPf2qR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMZgtPE7x6zGSYJX9yOP1K0trrLbsZnx5dnMNPABMRae1GmXmXHfUlO3p5lCNlrLBZbKu12CgiZ7jtru1xPuWp+Eq19JqlYS8wEndmzT2e1UxqW/2BaXCE89GfZXnIeLqQSIfONxfuokPVWNcYVcYpLpRMzVeNPA8T6Jqsx2Ihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YTfLgErc; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTfLgErc"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954d29264cso1458045e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282250; x=1785887050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5cLq3l213qCX3ohZHGBbCJcSRulTjS0jIwCcsAUbXyM=;
        b=YTfLgErc3HaPM1lpkXbFPCiV65lAU7CNbBxwo3CLYOmCTatNNjogLNKc6enwo2iZVK
         s1VEfB2evS/nEqYW5LlVsm4h6fm87FhTBAlznhJsxALtiZMaslOW2iqzpbW8YNeV2vlP
         n7jIKXMgyeNb4bpzkAib2pKN+YJ61NCBYzZ2PD6UXWxYv5XgoS86xkTJByXJ7fVcCzZJ
         s61zHMPeQX2ouJW5tLx/EHGugArVOibNjxcoOXGf1U2Wm58HEYN1oSeRMk4ceGyhDzHV
         6/ZAj9N+4KkfSNcegAfylzr9Hrqoq4OPge+wd3b2P0isha4xONHzlFS1oHwLIZ3mz0EK
         0h5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282250; x=1785887050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5cLq3l213qCX3ohZHGBbCJcSRulTjS0jIwCcsAUbXyM=;
        b=aTrB5pRBraLHwH6QUfJm4gokUAuBtYrS0B4XSnhyhHvkX5vqX3sE202FEJ8HnaOwnh
         EZfx9DhYvact0Kj/vJIYEUaWPlpqVeWTgjVZGpsR0urkDCWRzU2XEwCdoOhmv/5sMdiS
         uk+kVVT1ZLVlewabu2PvUmKAp0WTUx7bcO7nv28nW3Bf43EOYaieCipxy2g3l7WH72O+
         MSFySv1ZGXgZ5pUNCsXxew7ez12MM0lxzt5z+XOuYlAhXKjzOeI7zdsJLaZxL2wadXZb
         aY9FvNLRTSneKshTn42POZlDYWgAt543P6JWjYAIv3LvjjyDU4CVsnt4XOgX0vycj3o5
         jFtA==
X-Gm-Message-State: AOJu0YxB1C85+Nf9gRCNxYBQAFk2bL+teqxZLHO4dmE5OC+wKmTTHIEY
	++xfNQiq1Vb0sH/A0cuo/5pixRYtnMLeqzsxNneFPdzm25zjS4YUOYfB4rUy9aZn
X-Gm-Gg: AR+sD126GaNAQxEFWzwcPzhJwxXiMxvts4H6Eqkqu1u7V1KhuAux9KLKUdb7VfP7R4Y
	yoXbqvc2lRyL+877d8eiPyT9zzDlsLjdusN9w8WHEWJ4JBEwgWTPbj40Hwde6l4rCmN2o5anRP9
	ezhDj007E6KChb5ODahdgFHFqYlZ2qX52qm51gWX+ljbDPCvhbkNQKLV+sQyfPqVTJUEDrqRZY7
	tmUgriQH6219cFfMjjzekJ6N+75T2kjwgzZVlsdZ2hC+BjAFqplfkwfM9vMzmqsDLsAAJiEkUp0
	tS0g/GPgKLXn8/uF9SCHB6nWF2EAiLftQSholT4mM8XCo76HMGEBKTV5L4YGIueZ0gQdUJo7DvE
	8fyqnWqOmj+0jrzIrLdNrDfaNvjBpf27ljo48S89Pp6lGQqpsBMEHaJaumdlLPdsDThW9wkqWVQ
	BhKoMBNo0jgnSpa+RYCIcWOY4O+p1tyUJ6ma55sM/nu52pL+TZOoh24G4BjN1Bp5F3qeifr/WXd
	O44iaxvnXKbmJ3TaYs4
X-Received: by 2002:a05:600c:1912:b0:495:3b8a:bf11 with SMTP id 5b1f17b1804b1-496c6577941mr48163985e9.26.1785282249760;
        Tue, 28 Jul 2026 16:44:09 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:09 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v7 06/11] ext4: add ext4_dir_entry_len()
Date: Tue, 28 Jul 2026 19:42:17 -0400
Message-ID: <20260728234226.51753-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
References: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
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

