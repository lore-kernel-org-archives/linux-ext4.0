Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42313CAE95
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354876; cv=none; b=STuxJncFFyoB6l13eCbYFsCorUrdxKF3wXi8br/4UP4W7KERYqijzLZARQLBjjG18A4iPV439azo8eeuqUmpPEfYShUswxMn3TGQu1IGWAn9PFi5TbXlkRXNdk+Vithbhb54mtgZfMwUMTGXKEw+xEuXJSf/L/jv8HG/OwKhm0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354876; c=relaxed/simple;
	bh=bzU5Z94OAwVjt/dRXiB1YsWc/wuErsUsiCw9KWEBZBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjFOrVij5WPLv/e8YyprkuF76a9bk8FfKtPGaAfp1yETsMRv5GpcH+KlAFvHhbGrd4oZpe8PFni3XWx2bO9/y6KydKnp/3g7KpPioQ0oZtOT1HRYPW5JSvF0EbkLr9u6Y2HPN7mNJW36hxEq30/0z1KJBdsZcdIYw9WSonhBv+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AcEH9LjN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcEH9LjN"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4955158f26aso9389925e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354872; x=1785959672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=66CY1a1ksHp7c9drR4fOo7DcGpDumEhA6nSmcoAR8EM=;
        b=AcEH9LjN4u/tEu/7GPgAGt591JcG+opCcLxh6K838NqR6DAInuJsN+6qO/t2wJ8r5a
         eUAgnztdYk7gFOijaYspMMb2XrXD2BQx50LEGFkOVwU67zSK62m9SRj5AB+0vb1OQQc6
         ridts7KYLCKRxflmwXO2/tdhRTiQrFWvXCl8IHz8jydmd2oNXIETJG0kSY44b+47WvQb
         93PUQh66X+B5IUtcCcnOcGVhG4xpuuJ0kIfV/MfPZeB6FrlkaVmSukYjjJ4UbMBrPh8b
         0vcpGbW+pntWRIhCsPjlY9EdI5TMvmd5W0E2i6NWDuDa8p8x00r+4asqF/So+kxvgqq7
         1OlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354872; x=1785959672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=66CY1a1ksHp7c9drR4fOo7DcGpDumEhA6nSmcoAR8EM=;
        b=EUqagp6y8C8UE5/70w2LFvFzVjDvh6Zgjx9DvGzVUNTAGFknveNsofTqUrUgqpSiSU
         klCbDNTnKmmrPnA9cVgBKaAQqNHrZ+y7ZyYse8CI/L+uJRH+wvFknanHfJdvMCnexZdL
         +IYElkYri+RPrEiG78juNDD1F3soO1LkrkdrDOtS1IeAKJDS/NJbGNyn8RjnYHPg/AOy
         Bub/i8zM0jXendaek2TK+w/jeWE8+MBlGQYDKFGmVRGLqLPx4tCS5zLfA1cK6SvyJGps
         fXVO0NWzAS+aEOIzdN3iiUsVOcYmHhQNCNdwZzrWRM+SjOncUz04M0faBT+8TFdnyjId
         5rmw==
X-Gm-Message-State: AOJu0YwLVZuCxQZZBxpUKxojUsDUtfDH4Y0iEPioMdvpb56Wtgi7iUiq
	5VwuLqVxicy//evu1TU8nX6wWn/MED3C0dE79eSuRz0TiUyYcux1P/zE+ksZnFkF
X-Gm-Gg: AR+sD10xOy59cJzN0W10jqOY6DYvaiPQsIAaooS7pxmBm4cZ54Iu8OpYtT6qfDcN4uk
	895marnuPLk2f33ZB9MF9fjboJ7D2WjgYkMLvcpjtcpT3YOn9OHjTA71IOYFjbkv7tNC1cDenLv
	OB/4HiBvqNVcS/7q1dpF6qLdRZ+MJPcPAZfh6YTtONpPtYKY0hLtu3AAsODlKuVtmwzGvGdiTHB
	K0+p5+XyrScYN+YQdxHug0ug3/5yC5TqZ3+r7qwluVR02CRkpAXDpl+vnAeAATVOWkErB3XGyLq
	TdfEBHk2T4cIf8v4uPwHsNHtnOF6/HK9JLH9y0HJHG/zr07x8S2Ak0hkN7xkuNC5oLUJ4hm+jxl
	EUl3VE2eYOwVqr7Lp2lvEjGm9hoDUrsXZf1BQxM4gM6zmyzZavAwB4yRf70Dc471JJBoVtOwbRc
	cwz9ix+fwDNWtKCi3BckoWx8ZiEvKGbTsL24vbIhoBE7WApFNt9z1asluzlaYHZEuRAXCqGZLum
	yoMnqEa2AZEOrM9/VEw
X-Received: by 2002:a05:600c:4fd2:b0:493:f262:b8 with SMTP id 5b1f17b1804b1-496c641e88bmr101078575e9.1.1785354871976;
        Wed, 29 Jul 2026 12:54:31 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v8 05/11] ext4: add dirdata format definitions and access helpers
Date: Wed, 29 Jul 2026 15:53:23 -0400
Message-ID: <20260729195333.20626-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
References: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8d8d92391bf..c2aa4fee8c37 100644
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
@@ -4018,6 +4067,66 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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

