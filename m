Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4013C29D267
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459338; cv=none; b=bPyc6MYgWGrDyvKxJc3vVFvwqpKH6Ouh12AU7RJlhULJJRO/2KhSk/HhB3KaM1ksQ1qy9ptg3xhtsA2x3LYpgPU5mHDOqlavN1cl4hIBUonhOA2OGU35HbjVf+TY+VWHd62IX4deuLIV41kW1gvgg1O+hfuQBhNjDNXkJ12DiH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459338; c=relaxed/simple;
	bh=Em/lORVQ9XvCWEvcAepYAGpCNFH82RDdQoI2eoWPApU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxF9JdJyCVeWIQnPsvI0Wznp5HjOzbhOElosY8gH/bxQT5c4I6DzIKSMkkt+pFCCUiQ/6PKQFlCJIeyRxGx98hyPp0DSDUFco7WX6M5QDMKC4fRWPfrYaguN4PkjvQaZ9M+pOxTdkdcozJQe2aEBy4TMyfW/PIScZNz24GnCZiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DUrxKq1N; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUrxKq1N"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f6609c657so132051f8f.2
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459335; x=1786064135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B8iBhFbWe9T7ZfRzSTy+4mYBv43TZEEUUW5aED81rmU=;
        b=DUrxKq1NMX5/xKU7QvOwxZLQMSmlmXjT73XYLs5O1LeYU8IksyCZZwWejqnuRjKYeL
         MgR4Cls15x0CZ+9UhR1eYjijG15CwleXBND5xxthYjvekXJuD5XlqAFHh/1jf5um3uwH
         E2Fw9D5X6Ncw2YQS0JhtW2gWHZKpmJJpfuFruUiPoaZmYj9yqSfOD6xj5WcMDrrl5zPK
         n/FU+cZqIbB7uIZfaDvV/YXY8+64YzVe11SBdxXlaFmq4j6dt8g/LG24HveLfbKqsDdy
         JUEgSglCNZhavl1+lQVcw/ZmmAbbPX3RLoqeDq4v6zkLCTPqZxCXXWCWeQmHfDP/GNkJ
         lyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459335; x=1786064135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B8iBhFbWe9T7ZfRzSTy+4mYBv43TZEEUUW5aED81rmU=;
        b=Bc1fDXeHWg205isp31BKdG2dJwFYt+DzIz83xjQn3hiIpt4RhWf6K4xZOBQEgWXPvJ
         rB8cpWzKFKIaxQGDfUbj9AhxiYLlLFXZS+0kMzWUky7jShi6tgsy0E0bvc7VfgFkauF2
         E8L5160TiclPMsjX87we+U+9MCV9CAcT82XW2rV9xOJQAy4ZvsI2PW0tSbefgGAoj1bc
         fudfWlPdXXk1GipCyavVCapAru7q6xQGuIWZZ5gMPAoZlfuqez3cdzMlMzBZ7LBEvBZk
         +PzIbx5EGWuPPZ6OXTYqrrUeYcjgZ8/HdwCk5rdR/VDyuWwzyUudKl7FhEoP/S4YAohz
         uCpg==
X-Gm-Message-State: AOJu0YxxLfYQm41O9b3raAeIiILnJ9K2ooKseoAZlTj92CHlCccCzkh+
	Z7kj+zpXaqj6B4Q9SJRehJ2yFVpZxR64thJ3EhYGFjiYEJoFMJTJOjsKFqwxI9Ve
X-Gm-Gg: AR+sD10X5CXFaiAiCwk84QBT3qRN86sT/a08pKf+BwC152dpakmxxs/kLTK6m3dMIN9
	4qEaKNpl0jqNKi3CVdnjq1Fz3Xa8oVPurDPTEh3dSs/x97kvk29ZBgBVyMll1/hhxZbd86fTDTM
	6xrYeR4QLHY3XQjvAxBs1RQ7MRANLIysTAuWdlCDeSutUe7g3ha4fJLf6GFlon44CqYd/16SRKS
	rj2+DkWQoM+r6uOFX8ioUu2zmbkYf8V36jI48et64ZMbOITRfhpG8uc/My3wPRtd30ALN3LSixb
	sMJ1+Vf3bbwWASoGF2xPkT7RVuBjm2fIQQ6M5c8y8b6ycrt9SlouOiMc3kX4jataN+VcAcTTfeJ
	QckQ9dLNYnkdml1hcqjedfu+5M2ah4evbjUiblWE4QzJj9mpcMKe2GfaYyYawf4UJQiGej59IDS
	/5mfKvxQU8SdDprPOm/EiBdNyt3di27pzZblvNNSBvqJz7aKFVY1hTh6KctoZ95pfu/Rw+6O9vF
	fayQ5l+aMoSTS4aiGRf
X-Received: by 2002:a05:6000:2401:b0:47f:6fd6:cfc with SMTP id ffacd0b85a97d-47fd2b664ccmr276531f8f.41.1785459335277;
        Thu, 30 Jul 2026 17:55:35 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:34 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v9 06/11] ext4: add ext4_dir_entry_len()
Date: Thu, 30 Jul 2026 20:54:23 -0400
Message-ID: <20260731005430.36801-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
References: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
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
index 0c5da7d39b48..08f214d2e043 100644
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
@@ -4121,6 +4131,31 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
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

