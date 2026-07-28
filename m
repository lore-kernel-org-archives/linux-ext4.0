Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1042742587A
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282252; cv=none; b=QKAzt1vlq92GYQCoB2GFBDLWcyxqZvVoReqnhtCJVHz9WcUyMshurRV079PQ28KgNA7nxu5d0nddRzMnm6pzKQ4M8cjLJbChhhC7KR460GD7qtnahpaikny66y3Cmcu8AKDbZwQ7/U5gqrPBVPSnY7K/kRjCZzIMgztCBVh+Lp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282252; c=relaxed/simple;
	bh=1ZFaU6XA3bR1zq3XGZ4Kd9476P52UVlbqgFSVniktx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rfINORoMF23HGD+plthXfAfL/9lnhmFMdldqPy0IVM7nv+b2YA7L1tH4UO7Z/yxgtXsVHyeGdu14U/YZhQibYnRONBV62kC5RzMGmc7kEUAaEcfgTyZnPsIV8O6wkVbI9bfG7O/LTfkSlS6LeHMNC7mVev0P1x8lBx9CzCAvvro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HgW/qhjH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgW/qhjH"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b966dd74so2035755e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282249; x=1785887049; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kJntrgu0Grjnq3wjlHEamnbUmhRVVAh1WgPl8xtoSuU=;
        b=HgW/qhjH9JR/G2h55xLsQp2EovsyTWFp5erlIBPQp/EnxoNY750UJO3CJeP78E41sj
         ZLuAQVaHLBt9ztZFeOLIxes8OOf/qMZu3qPIorncs0zYZEnhRora7mj27y2Z2/ZjQNvA
         uvLIjYlkDlZoizGR0NyXkozXnNoRELa6WG+F3LzWLIwtS/zwzQg9As4qOCmBfPQjCoeT
         mLpZ/TR2ooc8WYZ90NhIbp5emcSveNVes5raAfIEMdX7JoygXsIOVL1KyLykJUqN9rn0
         Jr784qgM74K8iXLaj0wvUhelBUKPf/VpD8PuDUgznR2ROy5BpO96BnKdbl5M8TDso+Gk
         MDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282249; x=1785887049;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJntrgu0Grjnq3wjlHEamnbUmhRVVAh1WgPl8xtoSuU=;
        b=X6nXFu+f5uaOtr6DEah6kHK49lx1wb7mvZxFUPCjpZxUpym56XQJfvLI1lMIv2LFFc
         yIS7+Xh4bWcxitnb9EsUZPsZDQXTb4hJzTitYqP6lmwt0Eb5S8uUl4FhLOL54ZVKmfZI
         Jvif/ghlzsq3QsoU5bEocwelTcZiKOFvwjflw8DOW/GBX9gn8Hiq/N+vOYg1HsIlpaEO
         Gt9otCEKQQCH76vK9fKqzWZFsaaEikpo7kewZMv9br+03HyYIjaZwTwpXnAYaIAjVzVh
         CyIEHw4m7VA9H/jvd6o4MLLpWczrtFy8wnW2le+3j00BpPvOGYF1fAgzPbsmS1WPwAaA
         u0cQ==
X-Gm-Message-State: AOJu0Yw2egxfqT8f6vaXkPMeMzCqaWDctXIHmqZ04P8/9PwrGrP3TYUr
	c40mcLpYDiBabiO+bm4dvdX+UwKXqEciB/StXmknsBdtJMqJ20o1fV0TBPckvB7U
X-Gm-Gg: AR+sD13cw+au5avmWU6Yj8WzJmhlM5weG75hQAX6QemuzwV/aY+UeoqqR5acgU3LngY
	0gSgpNmSSiaUWSV0wpCj4hQ7nepadTDVJc8aYqR/FNpb2XxPYe7iBL+9FW97D8Bk8jlbunKs6bv
	jHrGdCv4qLKyc56j7Hrze55CSYr6sqzU4UqZe3Wz0zNlu511jJUSfRmUzBoULOgW+wPllU2FiU1
	tb2dxMc1XeUBl0S7CQAkhs7UfRProPokAArhj0YCw1A0pIb2+Ra8WKhJ1SQqSoQ/tgqihgHJjq0
	i/6bf7SQnlxNnCAFahy2E/53xIjoVBZgFnfWFtKCIuQd2PALh7+j9s70rhcM5rlSeTWVgHBzdmC
	fQhfpZIwePc3aBA0EXCK3wyzEA/J95XgzzmgTaPhsbz2zMRzpmxRyXeBUnA/AHt4OFormcJj1B0
	qO5lUm9NunENt9WPsrYYgNYjJjR5NWBMV71iaEvJciqvlz79vmyWLJf/V4m+M9RoNpWaawEw46U
	7AnR6r1nFSll0rkG8Eh
X-Received: by 2002:a05:600c:c83:b0:495:636b:e4e9 with SMTP id 5b1f17b1804b1-496c6568d35mr45144845e9.22.1785282249108;
        Tue, 28 Jul 2026 16:44:09 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:08 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v7 05/11] ext4: add dirdata format definitions and access helpers
Date: Tue, 28 Jul 2026 19:42:16 -0400
Message-ID: <20260728234226.51753-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
References: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Define the on-disk format for ext4 directory entry extension data.

The upper four bits of de->file_type indicate the presence of
optional data stored after the filename NUL terminator.  This patch
defines flags for LUFID, 64-bit inode numbers, and casefold hash
data stored in that area.

Add struct ext4_dirent_data_header to describe variable-length
extension records and struct ext4_dirent_hash for hash storage used
by casefold and fscrypt.

Provide ext4_dirdata_next() to advance to the next extension record
and ext4_dirent_get_data_len() to compute the total extension data
length associated with a directory entry.

No functional changes.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@diliger.ca>
---
 fs/ext4/ext4.h | 108 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8d8d92391bf..a43f36c05549 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2554,6 +2554,49 @@ struct ext4_dir_entry_tail {
 #define EXT4_FT_SYMLINK		7
 
 #define EXT4_FT_MAX		8
+#define EXT4_FT_MASK		0xf
+
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
+
+/*
+ * d_type has 4 unused bits, so it can hold four types of data. These different
+ * types of data (e.g. fscypt hash, high 32 bits of 64-bit inode number) can be
+ * stored, in flag order, after file-name in ext4 dirent.
+ *
+ * These flags are added to d_type if ext4 dirent has extra data after
+ * filename. This data length is variable and length is stored in first byte
+ * of data. Data starts after filename NUL byte.
+ */
+#define EXT4_DIRENT_LUFID		0x10
+#define EXT4_DIRENT_INO64		0x20
+#define EXT4_DIRENT_CFHASH		0x40
+
+struct ext4_fid {
+	char    fid[16];     /* 128-bit unique file identifier */
+};
+
+struct ext4_dirent_data_header {
+	/* length of this header + the whole data blob */
+	__u8	ddh_length;
+} __packed;
+
+struct ext4_dirent_fid {
+	struct ext4_dirent_data_header df_header;
+	struct ext4_fid                df_fid[];
+};
+
+#define EXT4_LUFID_MAGIC    0xAD200907UL
+struct ext4_dentry_param {
+	__u32			edp_magic;	/* EXT4_LUFID_MAGIC */
+	struct ext4_dirent_fid	edp_dfid;
+};
+
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header	dh_header;
+	struct ext4_dir_entry_hash	dh_hash;
+} __packed;
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
@@ -4002,6 +4045,12 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
+/*
+ * Advance to the next dirdata record header starting from @ddh.
+ */
+#define ext4_dirdata_next(ddh) \
+	((struct ext4_dirent_data_header *)((char *)(ddh) + (ddh)->ddh_length))
+
 /*
  * ext4_dir_entry_is_tail() - Check if a directory entry is a tail entry.
  * @de: directory entry to check
@@ -4018,6 +4067,65 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
 }
 
+/*
+ * ext4_dirent_get_data_len() - Compute the total dirdata length for an entry.
+ * @de: directory entry
+ * @rec_len: the record length of the directory entry (decoded)
+ *
+ * Computes the length of optional data stored after the filename (and its
+ * implicit NUL terminator).  Each extension is indicated by a bit in the
+ * high 4 bits of de->file_type; the first byte of each extension is its
+ * length (including that length byte itself).
+ *
+ * Returns 0 for tail entries and for entries with no dirdata.
+ */
+static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
+					   unsigned int rec_len)
+{
+	__u8 extra_data_flags;
+	struct ext4_dirent_data_header *ddh;
+	int dlen = 0;
+	unsigned int offset;
+
+	if (ext4_dir_entry_is_tail(de))
+		return 0;
+
+	extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
+	/* offset from start of entry to after filename + NUL */
+	offset = EXT4_BASE_DIR_LEN + de->name_len + 1;
+
+	/* bounds check: ensure we start reading within the entry */
+	if (offset >= rec_len)
+		return 0;
+
+	ddh = (struct ext4_dirent_data_header *)((char *)de + offset);
+
+	while (extra_data_flags) {
+		if (extra_data_flags & 1) {
+			/* bounds check before reading ddh_length */
+			if (offset + sizeof(*ddh) > rec_len)
+				return dlen;
+
+			/* validate ddh_length is reasonable — read once to
+			 * avoid a TOCTOU double-fetch on the disk field */
+			{
+				u8 ddh_len = ddh->ddh_length;
+
+				if (ddh_len == 0 || ddh_len > rec_len - offset)
+					return dlen;
+				dlen += ddh_len + (dlen == 0);
+				offset += ddh_len;
+				/* advance using the already-validated local copy
+				 * to avoid re-fetching ddh->ddh_length */
+				ddh = (struct ext4_dirent_data_header *)
+					((char *)ddh + ddh_len);
+			}
+		}
+		extra_data_flags >>= 1;
+	}
+	return dlen;
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
-- 
2.43.7

