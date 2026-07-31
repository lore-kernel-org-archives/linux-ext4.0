Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1FE47DF90
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541867; cv=none; b=MXwwMT/inInuLhtogYzkHMhRmoSWX8mCstW5iEJr9fV1OlrtybkvlwD2ApIesZMxv2n2ivjSTw5zRnjZtYCgJNO79wndX1/7hH0wxjE+ZQoRU0j0f9pOAMs8ta2culurjz8f+PXjJuEKuh3Qo75P3n5S5oIsY6anYkRFMaa6IAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541867; c=relaxed/simple;
	bh=ZoQ7jxK26ZHeUMc57f6b0kljBQOXdkfz1yyMaNlbOX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRoSo4IPmQEPGzFBYUaHQDkKAQIcGFcmlslFcbFPMmAfGv0YV1GdCkwseuaKZ+hIlm312nnqUp672C8HZVz4V+uaDQCuKJA7j/RIungdJLVZN0mnrZKbm9IEo9PwLop0FTEAAhmVM8aIHUO4uGaGw/p12+DaknW3mSSRHu6viGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hkhlXQtz; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hkhlXQtz"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4956242332dso2543515e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 16:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785541864; x=1786146664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RlnGFCq7/iCJ0nyAT3abgDiE34jH0stNWtCaL7wJ0t0=;
        b=hkhlXQtz/SM0kQEN8VqBnh+FauGge6zX9wLxH5utALfkxg2KHouMzXlodRzz2/S6J2
         DSIXanLCcyGk4Dx39esHWyDT0K0DiFPdcCw83wqKsUPrVJuOYpGH4zH7i/5RjMibO9OE
         2h4AO0c0chsP1RIG84nTE7nw4h+FmNf3fNE+GO9FmdOiFdnlZMuL4V/Ogt023/8gRzXY
         1yuPJ9W/gKhbDQOL/wlF6BQc58RG2e6/j1K0QM9TJKpRxk4CXdkJXy6XMqO1bqpL4zWf
         IgdCBkpOEUZDg5eJel/MJWf9pr89AZPtln3JdPCnZBgMdW4ZWGxqbwhweGkxnPmGGic4
         LSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785541864; x=1786146664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RlnGFCq7/iCJ0nyAT3abgDiE34jH0stNWtCaL7wJ0t0=;
        b=of5W88+iUOltywI9YVQSNT+aNujvHwKH/9vBa4wDsFVnMkMi9UMfhh7OYHaD3a4yN8
         2stOtyxMN9mth3Hmd2w6EAerAiqJ0/B55MrZ5rsiRENHoHIIU9o1H1j/btjneDciTkvG
         RXCiB0nb19WMMPz+aTOH1qc7TLFt9VWRAhYpNBt2k4MsDvJ8pyrOYR7XTdDBG0Y5Fbo6
         dor/7Xf5iRs9woLs5oVjSr3uAbAT2KmbyYm8nnUbK1+jEXOmJz4vXtgQsWsc1/cLc+D5
         L3aR+vyRzbAvBHYsHEM1Cu0XTWl9FZoMCYlOYLR+oyS25oJGKOVk4R0jwHAtEcCtq8hW
         imhA==
X-Gm-Message-State: AOJu0Yz0xC7ZnpwiuR61ciVQVYPILKkTtTSwV/1v4qwn7uMzxRjF9AY7
	cFilpyXx0jo9IzYU/mhZZEzwFek64c7OfSsppI6miXBSRmGWpCqjN3xGjxU1m9N2
X-Gm-Gg: AR+sD13gU3duLpzhrjmToLB293sqlhjm0JUfRx14B08ZrZ0YBfaJSSpnOBIsG9c+Fma
	21AdfeoPXJlMGSV3GsBCtKFm3K+3spkT8g8qeymhgin4YFh3XnUWG8yF5Pln582A155CslVzc8d
	3anskVh+Jv2yw//ESwIEaIkZwZHKBw9bT8faAri5qJhY8n4HwryKzp6NkocROQG1k+BBZgQOZrq
	s/BNRoeqWJowACxrF9jGT2GHCjZsXfu1duawHaFcJz56Eu6dgcT8uhjINe9Bu4Ix/7JndQ32T+C
	qSLaJsdXil8c/J6oUowu+ejre3arE0gax1PyNzD2AqwXFVyIxS5e5R9kAdlTodkejeSn5KXgKmQ
	WuQ5DchB8IffikXAGUFr9aYdI7xFnscV0wH9b9I5zezUuNYmwFDwsax3uHF95a2NdJm1c8NjrYD
	JakmDHd58EKq3si88+1vDFUKIB/YxBnhxbvQ2TicAXxefBiSpdw6HiRxAHNIGtKntdor7ZAnmhK
	NQYaDntZfVR2Hm1pTm4
X-Received: by 2002:a05:600c:b95:b0:495:4d2d:82f2 with SMTP id 5b1f17b1804b1-4980c69ee76mr2672065e9.26.1785541864108;
        Fri, 31 Jul 2026 16:51:04 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b85be7sm5338715e9.2.2026.07.31.16.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 16:51:03 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v11 04/11] ext4: add dirdata format definitions and access helpers
Date: Fri, 31 Jul 2026 19:50:34 -0400
Message-ID: <20260731235043.44068-5-ablagodarenko@thelustrecollective.com>
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
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h | 117 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8d8d92391bf..edeb63407c3f 100644
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
+	__u32	edp_magic;	/* EXT4_LUFID_MAGIC */
+	__u8	edp_dfid[];	/* struct ext4_dirent_fid payload */
+};
+
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header	dh_header;
+	struct ext4_dir_entry_hash	dh_hash;
+} __packed;
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
@@ -4018,6 +4061,80 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
 }
 
+/*
+ * Advance to the next dirdata record header starting from @ddh.
+ *
+ * Uses READ_ONCE() on ddh_length to prevent the compiler from re-fetching this
+ * on-disk field and to guard against a concurrent write racing with any bounds
+ * check the caller performs on the returned pointer.
+ */
+static inline struct ext4_dirent_data_header *
+ext4_dirdata_next(struct ext4_dirent_data_header *ddh)
+{
+	return (struct ext4_dirent_data_header *)
+		((char *)ddh + READ_ONCE(ddh->ddh_length));
+}
+
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
+				return 0;
+
+			/* Use READ_ONCE to prevent the compiler from re-fetching
+			 * this disk field and to guard against a concurrent
+			 * write racing with our bounds check below (TOCTOU). */
+			{
+				u8 ddh_len = READ_ONCE(ddh->ddh_length);
+
+				if (ddh_len == 0 || ddh_len > rec_len - offset)
+					return 0;
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

