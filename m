Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2420744330F
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512334; cv=none; b=GEMo7V5GzHiIE25wbn2+uo5m0gn8vvJyVms2r0aSrs5D50eDKnNq3FbEQbEuUS83HwQXIoV0sr0XK1BlMTYV6am2qeFRhfvi2R6rHQZtqAIbmWamIP3arEnmdi+FGqqYbktozAGBTpOjqf5gjUDSbnQdOjGOa2vWMmrJ87xrsps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512334; c=relaxed/simple;
	bh=8vfHssKoMHl8hT4OOaRobyWeBNIbzih76SU4UhQkrvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWdT+v47YG2CyjKUBbCLkbOK86i72heXsWl4s9tfeFAVaSw3FUKtOl9uhOaV0latUz+cu3ut7clXlMb4wFRyhT5vdAmB4qGt0foRfGfkEb5d7b8zWH/qw+I6zO43fCnvQbLv0jn67JTVYKDWjq1UHlwg77em7+PFiul5S9wKmYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPZ3HeK1; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPZ3HeK1"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f752b3423so1023625f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512331; x=1786117131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6w0p22qUUb9JeIzwXxUktRDjqmMjpAnmRbVfMU5r4Kk=;
        b=WPZ3HeK1S0ymaS6HxIkCW70oSCYYaQGWf3lYb/arEeCUi+XPYJFKuseH8wvNWJU702
         gkurcm+apbEdaYfKVFB4hQ0gIjiSNF5+g6y/PjHUvn2NttiMnbBsAu9/fjSvJ3eP+Wrn
         oNqQdqMkebPQlOfOZydTC4S7O3TFrvMA2qmrgfj1H1P5Xmir4fUEQCwMaDU11tVpWyKq
         UIQUgmX5B9JPeuFFgGwvgHNuOh8NrGAXYi8QdzsBmK5A/brZ+vha43WZLCrcdzj/AdVG
         yevPzahGan4VP1QAzmfwvuEfkxXq5Hbv/Zzs6cMDVICrMUu9c+8mhgkMVQdTLWNW2Mei
         P7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512331; x=1786117131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6w0p22qUUb9JeIzwXxUktRDjqmMjpAnmRbVfMU5r4Kk=;
        b=aN/rvoE249/2Np3uQBkHPXPPa98dGtqslvscZbeo1+usSl/TuqISBtWju59Azo+0LJ
         FCtdduWUdGdNTNjLrd33uU8ofZa4Mk4O9Y2gJCtAuG/KCEizwy9WLwMQR/Z3kvHSxcBe
         neep1FJ9PUPLq/o6utjn9gMoqrVAnRsE2hNzaJV6E7UMpjy4RKg8vVMaKS72h+5x3k8P
         TkCsGNgw0seYyFKrMC7r+W5W5fqe8cIZ7pJM6L7YG4houe5fG+4Yi4r+1zkW5mJx4dnW
         qJ1337fv4Ud+bLpamcI6ykll/OGIBqn8B+sfqnRefXvu11YyRTiHPIRPVbS8MJ+MbZAz
         uj3g==
X-Gm-Message-State: AOJu0YxOjSrKB0awX2I2S8nVxHfv4KJFIu5PCUjX+no989oZlbvM9mgz
	fA3IiJgt23xRGGSATDCoLrOQk//2/AUNoDxeLntFD9xhxlSWKj0GU5+opZO1/S4j
X-Gm-Gg: AR+sD12otsLjxDDWh0JZ/BBeR5JcTLYcfWrAAUdKXA2K4flMCtQmBsHXQaJVfrZg6O/
	jDHcpTiDz/jILWts5pHOdTeolI8pDf5darGWkEvVY8pwteSdAHQ+lEUEf2Hx0/jKdEeP9lPS3W+
	6xoEtr5Lpr9dc2glGQDXmu8e8ntCMYoIpaitAGLDznVzAQ7IbUOEzQOi3IOHyaQPvZWP+7rpYrX
	43q20fK+Hlm4ntyvLhXLYhpVYABnQ5XFUV8TdlgrjSiT8zCY+gXpE64/RgynRXyJzl1Schy2SJU
	sIQYPbvYcL5JclV9ID42tY3k/2zEcS+5DOklfhVeedf3k8cNN+LI6BoYhg5zSJPnE+l4pisxqBU
	VURJfb1JL+oAH4x9q60C7SWUIlvrF0RCBnBwP25fkTaZOiNSltDbyNC+pEMOXJ1WXbj6m4zT3WT
	rD0x1mWqWCubxecaBMBidUmM9biUC7XjUEm5rJ6DlS1W+IK/B44XV3tzmTGSWZj7sx+MUdUtOT4
	UerHsN5Qwemfy5q7bsckJGY8Q5XXlc=
X-Received: by 2002:a05:6000:40cd:b0:47f:9426:abf9 with SMTP id ffacd0b85a97d-47fd73280a5mr186729f8f.59.1785512331052;
        Fri, 31 Jul 2026 08:38:51 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:50 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v10 04/11] ext4: add dirdata format definitions and access helpers
Date: Fri, 31 Jul 2026 11:37:38 -0400
Message-ID: <20260731153753.28309-5-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8d8d92391bf..ff43ae8e7d5e 100644
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
 
@@ -4018,6 +4061,72 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
 }
 
+/*
+ * Advance to the next dirdata record header starting from @ddh.
+ */
+#define ext4_dirdata_next(ddh) \
+	((struct ext4_dirent_data_header *)((char *)(ddh) + (ddh)->ddh_length))
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

