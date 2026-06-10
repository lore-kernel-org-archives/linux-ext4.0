Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615863BADB1
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105139; cv=none; b=OsrU9f58Szgh+mtohvI8G6b3s1AWHyFZTYIoGyxugSTSKJGa/PV5CbbDf2iG+VG91pD1LhqpfdW7slaEAzyRIsaJn/KY5DM+UXe9WkDglp5eoD/0XurxalYE3k+/MKdaYHg4d6vc2pT43VA+KpuwcaschHtbTNcfLF3igU34534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105139; c=relaxed/simple;
	bh=k1RWy+bjLQpQpvbWfbRG5SuQHgMSBVToIxQxvqlRcjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bghCNzjPgjqeZnuNgEUBgxp/N7XmHnF4oHnqNhrTrhoqjI4XrQ/DPYm5ktkrz8a7Zfwq/aL1mwA9iejGrU+EMn6AB0QOQ0BzclP/ZIihpUHaihzrWOIQUi1NkdRGXsBwxAGeaqwCmF1GDU902n8PVfYJQqObfBBXuInp7+cacEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+ns3iPX; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+ns3iPX"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b915ded5so60840505e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105136; x=1781709936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFxMpRHnXYBeGUjrqG6d6E6CMCdx4flSSG14eoqXNSc=;
        b=F+ns3iPXniLdWkhF9mwi2OcVhCxv3OndtzylOX4CVViyYwp5xCxK10xgSY1NkiO7cq
         C6Zw9n1+3rtHzPLlkowC3czT+GHBH6Q1DgnavSmiewEipT0C1wZOxjjhHTeBPAA2LOyS
         CXkD0HN0yiJ4Zbx60PpvYD/wHeUAuYCDCcoKrGomAm/TNUTYzI7DczkiOFYLCBMxR4LR
         +Soqt0xpPog+o2PsGD1YolWtlDKkckYXIOZ4jm3EyXhXWvFW0ogcZ+O55OyJ3aJyH0b6
         r3I4ekgO6HqZuBHJPIxhCioosa/z9pdqMi+MrXKPKe5hLrkoAjIuExbXfOtBgCWs26dD
         mjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105136; x=1781709936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nFxMpRHnXYBeGUjrqG6d6E6CMCdx4flSSG14eoqXNSc=;
        b=WevacRSG5eqeJKokzu2tmVwGBR149GrBgwbpmDH4mF/iLy5FRop3UyxpijNyeN8fjx
         W+etX0lIQWK8nFxZH+8Z0XIq8N3XF2u773Ycut3BD6jY4RzUgoVRNr64SLSoGEJavPDQ
         5q/xQ8MkHs4vh13H7FDlFi1jOzYUBaPZkcgMQWjVEkex+iHOfGi/qq/HrNQ6g0j4AUxO
         RzkOPsqs5AcPWpLF280/eWphm7QaZKLp/1gxh1IJqdi1rkfbn6U8GJew57/yIPp8e6DQ
         PHZd2EKye1nByOTCy6ZITeXFCL2oh8SrB8+Lf9kt+9BtPa8Vod0XZBxERxBdoe+vlijz
         tmTA==
X-Gm-Message-State: AOJu0YxcsK5mTZm5suS2OGDZKQnGoqLMqcPegwBb/SYyhqd5O7+dI7xa
	7A6ehP+vs3Xe9Ukr44DdOn8bK8RAV3eBO77dlBVX4l6+VXSdJuqEAESX0EyQZ6ad7mM=
X-Gm-Gg: Acq92OGjbGFRVp2ZoDC2soAFwbCPSPLUC7GDrC62DytO/01b8+pSjqkyaqzjUnpKNpe
	5ZwRT6DtxzMLWBMh8FUvagMLREKkhVeaBJzYSO1bUnqXO8ZMqazqLEXjHozjZkTQyXXYL+yS2zO
	1/Vk1jqYdoBO+eo0mlz3QogBzaQq1VjTQyZv29Ss1VPOjcN8x9nUWUOeREbHUyYwFG+d7QmH0s/
	KL0FGzZ2XIPqJaHUteQD3kHXSzXXAhGWEr1IF84jPijN+3EnnoiyJBVvRaVSyQbOZyn74ayWaD7
	O4UmQ+35e5caGBfSuIAKyeZa4uZuTHbYI57lRrpMyWkiY7DMx6jXoNw/+iEhmOHSfWra9r7mwF6
	lM5FNv2IzbNPCJkvVlrl9orB2nBGm4dhBnkG329Csk+CDHCjXskUJoBIeEnhyNnVe3WJv8/uQOg
	lTWPBkig5jAxy1HLWI4YPwIIfquz5WZsJVZ+o6kqXGG6mfzFKNjy2EYGgODj1gt5c=
X-Received: by 2002:a05:600c:5010:b0:490:bb20:de64 with SMTP id 5b1f17b1804b1-490c25b337amr404978215e9.5.1781105134894;
        Wed, 10 Jun 2026 08:25:34 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:34 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v2 04/10] ext4: add dirdata format definitions and access helpers
Date: Wed, 10 Jun 2026 11:24:07 -0400
Message-ID: <20260610152417.13576-5-ablagodarenko@thelustrecollective.com>
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
index 01b1222b1454..c36c3bf54590 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2470,6 +2470,49 @@ struct ext4_dir_entry_tail {
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
 
@@ -3917,6 +3960,12 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
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
@@ -3933,6 +3982,40 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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

