Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88BA3B8BDB
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308292; cv=none; b=DV/KtslWI9tfFv9j5tIgCw/IcwC490Idzle4fdqeUd9XYTd6s2rjpIhky5nhZUfDfdS7kj+P9vrJ2Ggf0W7rVc3AXCupjUJ2pd1O5r58gjy06XodVrgkm9CQLmPxU5QjUdMoV70dJ+h9KSp8xQa1o+SSN3HnJaNnXKjtvGKJWFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308292; c=relaxed/simple;
	bh=Lqs9sCLd3QRHAAyWuTSB9v25SFwhyjx3dOd//d8uDHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmOj/uG9TaV0OjwO0OXm7k50nAL41nSKlfdSoetCLUMyBaHghX44127MiWtN/siKtZaB1XMke8HUMZ6zJvPE55z+NBVac30tXJSw+aopkwoXnvpglZ28HrIZZSspT5HLWUCbq4j9e/qANdg93IuSdZ3qYdTlwWkmN5/ZkEp4YFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGLQS/de; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGLQS/de"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49241896317so4772895e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308289; x=1782913089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu3FsoAEA+RWc5na4nUgF6GGk7CSaVrmt0cEvIhgaPs=;
        b=LGLQS/deGUSYn+oZzHtlyKs5AeaIcHtbH9K8CCAsma55Wbyk0lU5q5x2QVvqB5yxmN
         KhItc1plIi6YKENwubc9R++4qzwKmFEW/hE2flJjGuciws3eymf/lWiDDVu3/gWOzpD3
         1LK3370ko0uCLX9ByK+TmqsyfhnWZgECJUxZgov94xBj0rICDbO6FzRlFZMqh91aD4C8
         djKRO0bql6VXpDZHpp8e2q8FZ2Y11vMLuwbf6yFSCqpKrRAu5Y1fs1bxvIpmW15m0rCb
         N/FJy5BZSWCD+D6Ty/0Wv5rZYoMDZ6gy+SPkWKp+3lbhtoe1ToptZqIowEijOhXdKfKJ
         FPfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308289; x=1782913089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uu3FsoAEA+RWc5na4nUgF6GGk7CSaVrmt0cEvIhgaPs=;
        b=tXFVplzTxqAfpLQLEtSg3N8FX4X+IKbe53dHfmxgWaQlnFT197QnrmZIrQ3aU7xOFF
         cfX5Qk8oXKZYimKr6f7IoDHf0CIefYc9vO6vZ0589bbkCYWaMRIol3WDEEwUgTfgqKTK
         yekl5p9jsLn8Oc8KBtgnbQScDQzUkia/XIBMTE+AjVz0RqfmHBfQAfSgjQKPLKRXCMxt
         s45k5EzYbS0CldqfprzGXkJ5WFX4Zkxlx+x2pQUlZoo45wOIekhm0s2XMVdYReDeuamA
         Te1slqNW8+b6mvw5IMfCLl5M6jfVpvkkUOPVm/toQzobrkc8R1BbenXE6UyaJFsP7CUj
         4+Mg==
X-Gm-Message-State: AOJu0YxEr0jPztMnnFECWHWJ37zUC3ymgsNfCad6T00p5FjI0KjQK1R7
	JUAbbgWl/7ny0ePVCMUrplLvZez+hJoHoBgRxqYTM5aFPY9Xac6nFLkgM54Love2llY=
X-Gm-Gg: AfdE7ckQtOW874Hzaf5bDk+1KrRyRXU2oE3jAKgUtWYEKoYjVrlQHeqczvxDIg0iqq1
	gCFFx1MZFn94sxobJLRLesb6TKZtflJTyuO5FTDTyXZH/FgKRhaPTjRUw/q3VCrPA4rdDSpv9T7
	g/Cv++zh/uY5PImQk7wIBAwNbKtL/6x3X0qIGUXTbgCVLmrv3v/cxBUY1EZ65FFCfT65/42DHHr
	DTRz34rjVFRaAuiRo4cExS64X0J9Cq7TbVlWcevzulWCGHG3tT9DZjZCtOlaVRb5SqTdbYf3mYG
	nI4Prq+sjOh4I0U1vpzblzaltZ3d4j2W1+r5KLuqMcbrgvOioQmksaEpyFz9hqKsRUW/32rtHYK
	0c3mVP8Vmlcntcdw5PCucTsBF5pE7Ape19R2f0Ua2ciL4GwfNNLlWV63uRRKAuy9e5PWOT5XDtd
	iblz030/0+MtV78Nn64ZuBpEBYpiztVrpg94DMvYzCyFzQ
X-Received: by 2002:a05:600c:190c:b0:490:e170:b7ee with SMTP id 5b1f17b1804b1-4926086e695mr50542375e9.17.1782308289089;
        Wed, 24 Jun 2026 06:38:09 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:08 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 07/11] ext4: add ext4_dir_entry_len() and harden dirdata parsing
Date: Wed, 24 Jun 2026 09:36:36 -0400
Message-ID: <20260624133642.18438-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h  | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/namei.c | 23 ++++++++++++++--------
 2 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2f29f50a12ac..a369a0cd04bc 100644
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
@@ -4106,6 +4126,31 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
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
index 61410fa0effa..e2dda8dee77c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -578,11 +578,15 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
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
@@ -858,10 +862,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
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
 
@@ -2286,10 +2293,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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

