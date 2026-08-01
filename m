Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB303BF662
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607999; cv=none; b=ZSRMG2bP6y3cbeqvsuNya5uxHra5B5+y9shgpaZFJLLAU0FA4/1ShmqMI1c4xC4neY4SZ3kGnnaKo+Aw8f1sfVauE+/vEX9MfrKVwIeO/1lb1gE3J/pcvGwxDj44w2lFBtzeBKVjwbIcdKmYSS8AO4tpmG3jLngwbZF/5S2/jPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607999; c=relaxed/simple;
	bh=ZoQ7jxK26ZHeUMc57f6b0kljBQOXdkfz1yyMaNlbOX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZE8YfNZVEsRMZFpGnR2bO116CMa3fhEFQA66r29c58rK9dVVvxJSnPjW9kPXQRVtvPJBbZys4v9WPwgEGtGUVbH/mLfVaGtdYpjq9/DGMN/AawHxoprRaki2zxn4i8xOCSdQgeif01EzkuQzujDTHWr6BGPuWxc4TwCzYGoXc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=saJ3f9lJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="saJ3f9lJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f7027ca11so1322242f8f.3
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607995; x=1786212795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RlnGFCq7/iCJ0nyAT3abgDiE34jH0stNWtCaL7wJ0t0=;
        b=saJ3f9lJ0R4eT2Mr4EafaVaOKqZEsxCju/IlQmZmijZrpOUrnbG0JIr0LaQIb4MiAZ
         SVEKV6lKoCRFJaDGac4ZisuFNYnV/XSkXiuxFDdEXT3AI57Z2MZgMJsl3uzz5qv8soKJ
         c/iAcnduz/ndvD99FPaFeaPewqPs0+DWDCukQisybAVHmpWfvXso5KZe+gee7PQaWG5y
         pwcqHjSxSmeR24yZZG6n7KODTkmwfjyVny7R3ei//ULb/GKHQIGmb/ZYSwDEpFUgsTsi
         2Q6Q5qR7qOBZlVFvbKTaRka9+L8El5E5rLKvQZ2p48E0IrfhUz2sKE3LvVa8J0umHPOl
         ohKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607995; x=1786212795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RlnGFCq7/iCJ0nyAT3abgDiE34jH0stNWtCaL7wJ0t0=;
        b=cYq8A/JwvWoXwhXrq9HkKe+BmXTZbb5kO1NuV2mWrt4OiqeLH1tbLwzrl1d6zqLxhw
         cS/u+K8GpdTcpTkcNnZdjT6zzGZijn8gZWA7QvI6r0SP38bxfz0hm4UTVy1l5SBRQwO+
         loHIrRcdb4HC82wlbsj445rmObzhslqU5z3A0Ji/8TdTGch+x+UZS/KtQ+OTSB3iSpAc
         w103ePGSsNuagZA7+AhWqggxS9QbFqcDksqHpE9/irNI3Uosmz/oNMaOyqYnXIbiIrRl
         yIdKMhd1XhuPZILForcXq+TNWaSKbmKyXgZGwDIEXIIuKU2n8hLpjBKCg91wYAj5ouvb
         3MHg==
X-Gm-Message-State: AOJu0YxcutYjtni0sGhB/IANbbyiWnmig5rkcTrQYyVUUuHDK8AwSm6a
	fZkKGHOQO7LDHc5IXfk3DEgtTZn8k26EKeAI41PODv0u/0eSjDX/4rijA4EaaMjM
X-Gm-Gg: AR+sD11OejiPe7osXwt4fagXG/0NMp9piCESoKap8PSO2wlf5OhZ6twHTqxZujFKQQT
	IT5PLTC86IwJoYXktTfaceATIfweRdBJO/U3awJYI826/l3JuPz/Xx/Iu5QTY77nmW2JGS4Au2i
	fmRDsr4u7VSJXVF2Xs30bCt+l/V9peSPNsL0kv2B3IhWI42yc5g7WJeAYqNGJ8sBkPKUBmmtWS9
	g8IYls/AhLE5u+NApiyT4Z/Q0BZFME7kCCvmaAZ8I0UnVV032ngCvuahnkmmRefQTUWur8pABnY
	yNSrhBkytlnpWEQ1d+bsp9xJOcLZIFtkXQ+a2Xan7NG2PZS5xY3jpRv6HF9Bl9uqvQeNR4MKUlW
	4MitxmO1jvY2aVL1LCB29TTsTR+04vNwxy1oZBMk7jZ3l7nxejw+UaoaJPB+gXuSv530hbCu1Zq
	3gULOaqrT1qODkQahGOsi0xshWp8zlzSKfPdzCRE70EqcZzKzOSRQbicxuLc5A9nz95DRGJNhp0
	nkOQz3Khql68okJd7Fc
X-Received: by 2002:a05:6000:2203:b0:47f:8b2c:3d98 with SMTP id ffacd0b85a97d-47fd72c74c8mr9785714f8f.4.1785607995437;
        Sat, 01 Aug 2026 11:13:15 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:15 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 04/11] ext4: add dirdata format definitions and access helpers
Date: Sat,  1 Aug 2026 14:12:18 -0400
Message-ID: <20260801181227.5198-5-ablagodarenko@thelustrecollective.com>
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

