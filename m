Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F40443E2F
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512338; cv=none; b=DRYqnoP4s9KpKSy//YiGoVKCw5PrA5wQqQ81HntSzQTLYaGd6fzkU7Qz8O/qB07GZZUoJf5ByxXfnuqVOm6PxaHDADbzAOiWWOIRnP6qyX9f3HtXzzzrRu8fbCRrZ7eThL+Laqk6Z4p8NBbf1M90D3Clebu30jNST0Ae6p4WVLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512338; c=relaxed/simple;
	bh=d+Jtg1YbQptZhWFIe2NnhyYf/KqYu2YubQhE6+k7GaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxpEfYA8s/Ixl/im7hWEv3dJaiWCak5exZYKqy+VV/jmGpBY8mMxLwkmYAmJNz7L4S7xuDC8Z0cToTIvuin2EQha6adJs87jEpnZCeUVhZxT3tnIaf6gSxbjodPK5mlg9LZ05FG+RVENs8AcpaiU8oWcnse2Ts05DTnRY43C6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXs5HuHi; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXs5HuHi"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f904e80eeso1025520f8f.1
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512333; x=1786117133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=frczxh3TC+j+knUK2h4mK0aCICBb3Zr3cfBq3pV8Kgc=;
        b=dXs5HuHiv0gf5i/qMnWXI6/3mv//MbsnEd0uyk3eSeO1RJIW/EuKxR5TWpqUP/4m+G
         oonh67OMeyaFkEfzqTVFJuUYIfLTFn4MEVwUwlg0XlmSIJziOK1oCXe8U5KN2JBBTFfy
         tEPCf1RLJV2nnn8HvNx4e55Vae45YlVmEwJqhKaTduzIaIW978+1gOixm/jou28t2UWS
         JCXOTmJF3jeC/p6wUebMuddD18t92krntyeht8ZxUH7ll+2r4Vbyg5rohQO8YPABuSmd
         +9aHJQsD4Bh+FsazXTETBbmO38QquUvIFEDo23dnVwtVsbXMqZx0HDiYRP7kymn/IaY8
         o/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512333; x=1786117133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=frczxh3TC+j+knUK2h4mK0aCICBb3Zr3cfBq3pV8Kgc=;
        b=Y+Bq0KqeO38tmFPlblB+ZPtnIdqHfXQvUXNjx3TI5ksp6GOiQ6TmxZFxROEyoD8FQ9
         iEocBRMC0uKsC/tQecmV/oClt3wHq5fiZA2EIK00FSEF6Eyg0FEDygu7bXlzPmjudpH0
         CS+hCpxSBdM2oCFg/BNx3wG1UJShNvluVINUp9IRES2kX4egBmyp2+gXMFCWMCy5TWiL
         oa4nJ73vgrS1JdFdasqpxcGgf54v2KTsvtu67U3d5qCrR8V6trmxXPAXymnNbMRM4fJh
         gGfbK7GAJ/1ehWvo4OIu7G8yvBdStOA0lOuG1VQk1lOPL6/kBzgPpEBRjmvUyH3Js8s4
         4kzw==
X-Gm-Message-State: AOJu0Yy+mlxlJn2aXyVKGL5UB8YuBVQdHN9osMQio72zh0EGxda7LQSS
	nQ1mTrwyHhouUvr+2H6HDXANWg5iTAOqs5dqxilVdYWg1Bbp3i0lStdJmK0rAlzf
X-Gm-Gg: AR+sD12N91hNdVZiIralXFhIdIURcoC/F/+fXSXHLJqkHd8/fwzk8L/gjIkw1NEHSrD
	yrHuLgMPVJDKh51U+scPbj1ROD8e1hPOSAHzn89DBAUEIhbw0ftnyIREZvkF5It7ju1qgaPIvs8
	J80uuvob3bSV7YljmfvEE2b2+ZHk2xTtvk7cnxNrMvE7Wwt6EFLidU3EAuoo8JlkDFHserI6jZE
	Nvac9iD/Yapr/xvyNZemgeCBlNdysKkmnFcTkNEKr2p5W5NFTU1eBgh8kyM0olxvyuYEg347nDu
	Qn2gICXloVRHcwiIUcVmrxybZ9ZFgReZTJa3eHROP0zHoOTls6rPCs24Kquje0LX/j5EMRSiuUG
	8bFMwfezsm6Dn34THTTnOQMhPijHHvqhdc41a8Syy/Dp0T5cQ2RqpiLS/c/mFoNZDdhzxhciESR
	SF7DNeT+o1n77f6CObtKxoVQ9UKA1xeIvNX1iixE6t2vmIfZ4Tr0swcpUM9qQkkEzRaKe2qKjsG
	y9XUxinABwXNDujJKthiw==
X-Received: by 2002:a05:6000:2408:b0:47f:7261:3a58 with SMTP id ffacd0b85a97d-47fd72bbbe3mr268399f8f.1.1785512333104;
        Fri, 31 Jul 2026 08:38:53 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:52 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v10 06/11] ext4: add ext4_dir_entry_len()
Date: Fri, 31 Jul 2026 11:37:40 -0400
Message-ID: <20260731153753.28309-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
References: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
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
index ff43ae8e7d5e..4cc4a1fd290b 100644
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
@@ -4127,6 +4137,32 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
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

