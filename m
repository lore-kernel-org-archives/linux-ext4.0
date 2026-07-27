Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E630F36B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186787; cv=none; b=TNE1RMTySBcn/oFgFeHzuyDZUsdsuCiAemo8PrHiBoyR3VBNaZkIAG3cNXCZ5Rr3+5chGVyrTBw4KOiBcLx/pVgq1XrfB+IZfS3u6K19nPuteUKidkeDsZCGW2OVszo3O3IZ2W4K09nGzXJwtHFjH14YTJ5DAL3SlgwRMfOcw6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186787; c=relaxed/simple;
	bh=1ZFaU6XA3bR1zq3XGZ4Kd9476P52UVlbqgFSVniktx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOptCu97cZdzONXw+NNs7Rep1Ao2aVHt2Pponk5a73Tk/ih5nG5WhsMJshbxyTAEqC7BYN/HY49hgQBy+pIOW3V8M8bzCRcmYJnTbCGuT/hfsPjFAkFiNBvBojniMzlxNtgWKUFt+6sBgq0BkdomIceOvVR8+KGySo5IZ4iznnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rZdwFwzt; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZdwFwzt"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495590dde14so35040645e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186784; x=1785791584; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kJntrgu0Grjnq3wjlHEamnbUmhRVVAh1WgPl8xtoSuU=;
        b=rZdwFwztC3y7F5DyZyEAx5c9ZmsHSv537lwY7avOYYBVXhe39Zmi8uz0vBQ+0IBFhF
         A18aAupELzkfANUXOCUFQMnOFKt5Xu+k+hg10DqB6QjzQuSGZIwIFgiR+PC0C/QY0+Vp
         fHkqihDbcMC/C2/mdevUTCt+uR3GInRbpVgveauNllL6VSofVUR64ltz9pkNq0UJzcCn
         YMr5QTj7i+W8xQonqfLysSZcf7O+Urx4d6ZoGmLRGZ0mwTF+e+iPBAWnS4cpSl4Rfdiu
         z22/DaAfVSsDdPVYHA8GQCAsQy/QwXnkPXeguAYehNYkHuVx8WhJs7NrSe3439VAbAGr
         y1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186784; x=1785791584;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJntrgu0Grjnq3wjlHEamnbUmhRVVAh1WgPl8xtoSuU=;
        b=ElKEj9dIMUL7EFOoTxkXK7Lofno7jKAe1XaTvnSLaCBbgO07r2xiQdugHzZGJSqxie
         as39JplpoxUV88Iw58VjMimP0x1ME1GmE0fS2+qtOZApzT4AithY2Yhl2CFAIjvUGU5W
         a/lbKc9jhYDGxfMF/U9J4E1IfnnFmdjiV12TH05f3byUILJHwAocr1E80sDn+93brbpd
         rYGTP8XB6Coa5yE4n7JwIPBTiOf3/FrNFR9vDNrJQgi0uHYb3goJfEhxFZd3gDPtyIL4
         QyXS26LO9Diux4ClcNbDfptwNFBcj/M8yFvmb3Yx/XKN8Cv+k2ocIoDmrLHzbJfMZXgk
         saiw==
X-Gm-Message-State: AOJu0YxusD8GHwMR/6oa+faYLEug5WVIcqHOSZ4qF6O4iqdWxmqfjCtA
	megzsYXe7vc1rVAi2RZimvCcs1s4+A8Jadg6A48J6FNMx7xRP2K9ENoY3Yro6/vt
X-Gm-Gg: AR+sD11sSgB6MZGvMuss1cBFsGmiMxDFMQcRYDwwcRmLCVfQDnCCgBWMP2OVDRHHvBq
	AezbDRN2r5QW53HGs1GvfHwZTH3SyZl5uJB8ASzhfsrLvN2wGi+pQ13VksGugto6mSYRrL1kgz9
	qd0VOYOtGX386gniQsj8iJv6GW7Rx6+ewZfjbg6iNxZW5IeY6caJv1bZ5+2CLNb34PBCd7XyEor
	4bOkL+V83KSVzkwR5m4BdBxVxnL9Ye4wxlRysbSRq/4pNmfgcayh+O4G8HhKAqg80l0/Ppty8kk
	qqJ+n90SqnfuXGVxlV9Ogfv0cQJ9ZgOG6y5XRdP2DEGLru07atdTzW/qHlWuwWTn3JMyrAD58La
	7haT67ZC+6j1QzOMqNNZR/iARcZDCaD3nirex2n8/ZGl/eDB6esdI3eWg61BG12jx+LzL3X7ocM
	Acxn249kLRdHWCkX4K5BCXolZ1qhn88yjC2g==
X-Received: by 2002:a05:600c:c4ab:b0:495:6b55:f938 with SMTP id 5b1f17b1804b1-496c4f8d52dmr5373605e9.10.1785186784104;
        Mon, 27 Jul 2026 14:13:04 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:03 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v6 05/11] ext4: add dirdata format definitions and access helpers
Date: Mon, 27 Jul 2026 17:11:17 -0400
Message-ID: <20260727211125.19632-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
References: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
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

