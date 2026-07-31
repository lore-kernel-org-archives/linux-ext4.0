Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37713331ECF
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 23:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541868; cv=none; b=EJ5t0Nm51hwhk5orgAix4QmKKrT1dN/8SUBumb6xs8/YmA2deh09wIdqW7qNZZZaXETyDBTx7XOmMZwmcrrcylA19Nva3V7A1VziZBQa9v9fIfYfANDdOmEi0wpFhbIZyX2+4WqzTolXjAS0LXnibenqw2+KDbsROqYluhRHsEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541868; c=relaxed/simple;
	bh=4h2/6qD5pR0qT7s6SW1H4JGhx8CIJrQOvMA1K8tF64Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV+w4GFCf5+pyRseI6efu5Z/uJktO3QIptF8lbRKTanIU8MOhZB9rFL36r57Zg4y5H8D6oW+1iE3hCVV0owBUcc/vrD7YUDdMsP2mPBRVqNmrQiUZpnSoa5CWY8ydGAUMNFNnOojoppaZXsJwDGip5TO8c/zL7wl0OMpnwf25B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=egsUBkpk; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egsUBkpk"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49800c6a846so2088055e9.3
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 16:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785541865; x=1786146665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xXCJXznpnad+ctuf77995xRRJrHzHUwfM7l6wbZHb3A=;
        b=egsUBkpkm6LiBhRop1Yf8Hc1ZA78BIykb9utcZ0s1W7XVOe7/R5Ka4Set2mDailZXw
         b4ofhvRS/7RVWVbqmYpkF5HNlilarG4X48pTi3HaE5lJD1sCSq7wP0VwyjfIh2UY3wTL
         8hZ8Pha6uC/4vuyCd5nUEmYA9nDrdx9fM/j8NdjXn7dgB61uoRYrCaNuzN290xWd57o/
         UhkTygylN7QXdOSZwSoGfRyk6e37JSrdRf49sj/nj4BsjU3HERpN/7zI/yZrTQ1qIPlL
         vtsCgX5TVkB0/LaffzrRwxLkGiecJbXw2yUR6AyUuM5iAPD9HpV9O8X1MZj8DpK9LrBA
         6TUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785541865; x=1786146665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xXCJXznpnad+ctuf77995xRRJrHzHUwfM7l6wbZHb3A=;
        b=GcaZgr5emzJnnvFHq/EfjpphFnX+DPQvM5frm1akFgqYkqBTZU2XnLrgK2j3EfCki8
         IIEMEyHCD+eZ+BYmMsYjvPr1E5kEev5LuV/V5jkXUbzRNdMr5nE3YDuL5LrCjeGliV3P
         +K0aoJJNYfjHJav0Jp3z5BWvDq2C4buXvyEAf5gy30hV0ieqGGTayrYMwtZSIE4lsAtq
         wpTPJ5IdI9xmww6rGlpmHnzQuTkNTfO1xTIrA1/XynbqOD2Q7LEdjM+pi5A0gbpEIh9X
         1JPfN2huUTpHgxTAkMvRh2Pcv9Emy36y4/zDtI8/6p+m/j0NKOWumixupKH7MekeY+kl
         9Y3A==
X-Gm-Message-State: AOJu0YyDCT5jL9KZKL1f/p4uJ+K1Klbje45xqV+BqtI1qe6qu+2aaS1P
	1PpbcQtHEgPKDPVjaQRWu+8QaXuKM/aMkIVY+HzpJRqegkXnJLfYlBZ0UajjJam6
X-Gm-Gg: AR+sD11fwD00ZYr1lbeISBXEWrpISHVRRWNOcBbKHFyyjIwam1a9YuU4Xvwu+1kvfr8
	TZJVqJL6xcQdPkd3B4LKQpeQVq9LWfSStE/5kgqSEAYHyBir84keaxAYWCYTln523nOYHDlOWvi
	sma4hJKaG0Yw0lisXOPdl06xa6FmHAC2D0ekpCohCghwGsdpDB69dPgjBpErHEBCaQAmL3aO3N4
	TtzeNYZRMYw4O7M+plUKOY9gAZhb0ZJe7lR2fS/lOWzxp7obPR7ilJyzO3TGCq5ZKc7C2vQgv06
	ok6v1C8ent6vsrIZWug8jmLozJoKy4eDfgVCkZtHpkiHZnn3Y4LyFW/+zn6mtZvpK3QM+6WlGcZ
	E9mFtNj2bLtHlb9Pte5yLnNI4V11mjjWm5OjEqTQTAAXupTWa6u9STdcRtKJfrsHLdScfxI+sfO
	dv0BBFTJeQdBCU7dEkNpI3UH0bD3sllps4nMIcvBPXdBqoHc9tXTvzWJntxd/J+obpMXVk5tpyW
	dYfz63YYsuLpPIjZdg0
X-Received: by 2002:a05:600c:a42:b0:492:68bc:3237 with SMTP id 5b1f17b1804b1-4980c6a923cmr1999455e9.32.1785541865395;
        Fri, 31 Jul 2026 16:51:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b85be7sm5338715e9.2.2026.07.31.16.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 16:51:05 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v11 06/11] ext4: add ext4_dir_entry_len()
Date: Fri, 31 Jul 2026 19:50:36 -0400
Message-ID: <20260731235043.44068-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
References: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
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

