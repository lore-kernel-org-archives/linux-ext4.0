Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5298A3B8BA1
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308290; cv=none; b=GbagH2uLLusYX4V5gtbJT8I/suxz9/wkIhAweJzr5SDDyyAOSc3G5WuDMfikR98bSJsty4B2swcDnjN0sltOny4GsO8n/ECI5tMQIxItuFxDECHZ7NbFi/OMsmLMFcM+bNPylUZJsIzXpQC1qmWFfHb+6v00+384CUj5/LP0ihQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308290; c=relaxed/simple;
	bh=QeckxND3nDN3zl1CIjxV5NdBBJfjUh2RIIbcEkShKrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKmE86s2KZ8Zeqs/cU4VS2ixhahxBE6Uio6A6dlbPKE38BldGSiqmD97sUSz1HzGUNc1kjHsGPamburekMXURraEux34iizt9124ynfkRBd8K2jrokIZlR1oW6TMg9HP0pqAIEXkAo9xqyJh/LGuyO7rEXdcGdstW/SC7x3hhE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YtGxcSp8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YtGxcSp8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4924593f45dso11839585e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308288; x=1782913088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzkM0Q1hFcFf8NoRp32si9ptcicnnZIjZIxXDx0tujg=;
        b=YtGxcSp84OGQ2f+hLj3ao2ls5yoCoH+EHiWwyKqxjuiP+DkBuKPxTt846xaKpDRqMP
         /2sWoSIa/6BM5PHV1rr/L2Bi63dVSMcV9y5XkPJcrulMmok45zcdyChc1MH6XrV0E1Ji
         fL0NfWnq7AxY6PI8uS8VJ3IIFF/OA/i+mEslVY9eiNFwi5+Wa93ZViJ8sfDeq9xDpW2x
         kP49sgY8qG3NzEKSHYrCkjE88mxNUQNJxY/nqHKPyovP0xhtyxFj0PI6Bbn2JXNE/Fud
         wGoBSPHEpwqTzhQB17VePW3M76oSbj1h8j+YzqeeWAOo3pytfS0j/SMr5WonbpC4AlAG
         pEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308288; x=1782913088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IzkM0Q1hFcFf8NoRp32si9ptcicnnZIjZIxXDx0tujg=;
        b=WlZCjR87JmbxygK1LDnG98eQh/rb/3fn1nPQWG8YFhIYgEPUAS6lnN3aIPLZThnOwn
         aRZZzSiCw5jdDUrGwplA8B+fkUhBFz17qwvFh82AmMCuvdFM1l/aVTLcRRNdm/8k6EI1
         rBlPNoV8/f9EE1qjPj63GDt8eAyVxSOuXTK8f7OByeElx8+IzyNEOMb/cCaHgJagEj2w
         BpgG/cXBFZenIjzG4iAscI2qhLv9Cw7KTT6DIJ956dLQxvqGoJ5lrdJRrtc7NHtKJ5nr
         r86R2UKI2DqqTOdw2J29pShcaOM+s3XxvgtgaExQoNyt7CAhhgs75yfa/EeLMlJaUV6p
         4lcg==
X-Gm-Message-State: AOJu0Yxgw/jfr8LkesRGFjOHmdgKovNbGOMe44zpJvDCYQDwwC+GcNLD
	0UasnhVhYcL/CfDTCbJOFJl5WMv0f+nCl50tpWZzdPDnced6MJWNlsKbEL0whP7WE4k=
X-Gm-Gg: AfdE7ckypiZAoFFaTAOTtS+KER5UZbrxsYf61MnavbfJdsp/D4rfnwzVoWOWNbOPOfN
	y+YAi3hp5w7MUVnnk1McVYl8pR3a0D06lkR+252JieL2rHaEvlgxewv+wJi3+rKoXukZNdmZIdH
	qQPOa4+4B2bN2tZLFPgwLkvQ3NaIqrRbdlLIu4wtL8Ypg6q31bKMZdtmiIOkCKwZbm79lVgJXmd
	05VhYjC5FtOxmfQf/6zqzs0PBehTuBFuVrju9OqVAhZK4LQQQ2x/pmcn2UrLCcCHWbCo1qPUwgS
	4f/p8gRmVlCTqLaMwsDtgfVkS7Tjs9v+tjuauBTa0s/nEsJ7MojRs58t4qADf9xWNRBkpxwJL3K
	rfPwr98GYC1t2iFCW72S4zQYLGeWnWlZhkRvDZVVt5S5zKxVS1E7v0joupvzG5/Z05DYW5YK6xm
	qduwM9pbU0/jedNbhn+AFkJQnmIBnXgDX8CCn6IDlBBAtt
X-Received: by 2002:a05:600c:e547:10b0:492:1e36:bb04 with SMTP id 5b1f17b1804b1-4926087b5d6mr33702945e9.37.1782308287571;
        Wed, 24 Jun 2026 06:38:07 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:06 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v4 05/11] ext4: add dirdata format definitions and access helpers
Date: Wed, 24 Jun 2026 09:36:34 -0400
Message-ID: <20260624133642.18438-6-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9400bc2858a5..98603aa44693 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2556,6 +2556,49 @@ struct ext4_dir_entry_tail {
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
 
@@ -4004,6 +4047,12 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
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
@@ -4020,6 +4069,40 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
 }
 
+/*
+ * ext4_dirent_get_data_len() - Compute the total dirdata length for an entry.
+ * @de: directory entry
+ *
+ * Computes the length of optional data stored after the filename (and its
+ * implicit NUL terminator).  Each extension is indicated by a bit in the
+ * high 4 bits of de->file_type; the first byte of each extension is its
+ * length (including that length byte itself).
+ *
+ * Returns 0 for tail entries and for entries with no dirdata.
+ */
+static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
+{
+	__u8 extra_data_flags;
+	struct ext4_dirent_data_header *ddh;
+	int dlen = 0;
+
+	if (ext4_dir_entry_is_tail(de))
+		return 0;
+
+	extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
+	ddh = (struct ext4_dirent_data_header *)(de->name + de->name_len +
+						 1 /* NUL terminator */);
+
+	while (extra_data_flags) {
+		if (extra_data_flags & 1) {
+			dlen += ddh->ddh_length + (dlen == 0);
+			ddh = ext4_dirdata_next(ddh);
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

