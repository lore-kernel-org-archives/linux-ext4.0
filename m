Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A983C1097
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105139; cv=none; b=UfQuIdl1kF6ax+1ZlgWDhw8nvCnpePnE9gH1GoYS6rK8b50GISI/K6HOZPzGGwJlJ+bPZCmKQcRA0kraUlxVIvR+FyiqQn2yDRdsRUSYa22dnsJ3cv8XlnLpamlmmdsDk7B1aIsTkCHNovOrER9KP/mOEMo/LDxuskNIzleB3KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105139; c=relaxed/simple;
	bh=pRHmqs++g7AYW9yzXw1MCJfEDJmTJ78DYj3kjOLnPK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKOvbMCD9DgR2nZ9JQJ1IcB9vtoos1lynAuGi83Y+8RaTc4mafPx2mvarb4jw8EMDN+mKFmrjCUYGMIOww65acf0pBd0fM3kOZDRl1lWkkwUV/uidHt+gjbEouYlVwip2k97ka2RHTBXfTW2xa98ihTDtlwnpETDOj0pPl5GvGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ldu/KGOb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ldu/KGOb"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b3e03939so57525755e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105136; x=1781709936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwrLSFVLQcV85XLCMGJAKYa5DYgnFMd5sAZu1lSv8K0=;
        b=Ldu/KGObzrSfvazjirSKFZt1TpidUVQQwsoi6tP6KJyEOUtIKmV8EEyyxYG1Y17a3E
         XWFa9AuucG++fwcenYkmuDsMq2IYHdyGMBw4X5IJhSTOlfQAF32Un6qhYCSLh7xW/+C4
         D8LxyyBPIOJ5XRUGzwlXsI95p61Bg5SgTtVAVh96pBGDPMfH/3lWU251CIO5ykiNmPHx
         2PrMwk61lpCbs5PuY2N/s0r8iWwkQdiETvj2sq+5OUBQ8tkQ1MimlD77Sn3iLC6TN/me
         ofHd1MZ9jZw9JtuEHghW8lWztBiAa9KsodpwUCib/BwgKpmOHF7QIyAlzoGDp63sWvb7
         QbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105136; x=1781709936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jwrLSFVLQcV85XLCMGJAKYa5DYgnFMd5sAZu1lSv8K0=;
        b=d4I95OMBFqyEXGTw1i0k4Kyy0JZ0YlqNtck+DBZoOIDJ3H6Tv1BPSyx48zDEWKcSeR
         q9ch3Uk1cqt+Ahuk9JLXjjn4JhHHDrUOZ2gasi6QYs3EOKX8f7H6BoTu6v6O8CFObC+C
         uMCoxAcubDjPFLI1DmjFB0egtWAfX3Uwv9Kvb87TGWHkGoJwk1YylYk0ueYTBNHS+FzJ
         7c5DT7jAy6XQ0EdDR2+71vajGPlV8DSa/TM3ONt0pulwypCAPZB2ZpHC9VOw7sIrNiky
         yKil+1/UyUqim7T4yxx7DdPq1f3DS/C5hQ0OUfzUUPYx9bFghlw0uCMKQ2iCalT5FCB+
         SlgA==
X-Gm-Message-State: AOJu0YzrtQg3LR+ZYFFBnMyclFSKKdxUpRnAIr7c8UckKcG2YQWRj8Qi
	xKfzlzYfgP/vvmgjRQ4+6ZBlqM3K3vpWFEMhOkrHsHBvr63TV7AjK0jfqupaGJ1vZe0=
X-Gm-Gg: Acq92OF7sCnG3/UpI+mec2FI+q14Mfz4nOwkymo1K2k9Ix/h+JzCDHyF2QsLqn2Sn95
	3AdakUS0Oxwl0KhmLRrSrz1JPHs6g7XJlft4AjMtQnzBT6Pc5l7KbIj4TcJCrUcsP1MAySxFzOz
	/ZgJlX55xSLA2Lr7OvtndRRYW4X9adqTRmgFzZoxB5UsdarukQejmnmjfudCFVp97cccncydlTU
	tBKw+0mb4kmqAhlCakOgOuOHAzxOiUhljl1nYgkqH5WgTTtJna7z3RtOM64cmqbqiLKwwiLsXiS
	tIozfQyOH7FJHRY0xaAXXZ0OToLs9gDQakJJC6L0HFc11epHM9mXoxVupOQMnGG2Y9zVwVJ/gSF
	QC7ZPR4K8usiznxmsj9c5M+LWnnsV1e9i5lTZItVPIQDVNqdI0jdunHg9npmkRWhZVyuNPlvKVG
	ip+Wir2eNH3MGS4TeDQ8WaROcHvZ3d971rbL9BD/yv3xCsPKeVpdP5L/C604j0qws=
X-Received: by 2002:a05:600c:83cf:b0:490:b26c:64ad with SMTP id 5b1f17b1804b1-490c2cc3103mr305872095e9.5.1781105136287;
        Wed, 10 Jun 2026 08:25:36 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:35 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 06/10] ext4: add ext4_dir_entry_len() and harden dirdata parsing
Date: Wed, 10 Jun 2026 11:24:09 -0400
Message-ID: <20260610152417.13576-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
References: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
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
index f833f6ef0040..45e90b8be9e8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3988,6 +3988,7 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 /*
  * ext4_dirent_get_data_len() - Compute the total dirdata length for an entry.
  * @de: directory entry
+ * @rec_len: the record length of the directory entry (decoded)
  *
  * Computes the length of optional data stored after the filename (and its
  * implicit NUL terminator).  Each extension is indicated by a bit in the
@@ -3996,22 +3997,41 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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
@@ -4019,6 +4039,25 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
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
index 87d8cd2c6377..0635eac2de8d 100644
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

