Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276833;
	b=VpZ+XxDFsklpIr7Ik3r2s30U4gskegP6n3MwkYPP+cow6p5wyaMWX0MklNNBl6U/ndBf
	 +xcXnZmcr3PUfBy1ZtvHoR4cbo2iZ7AofrEmU6k5BVZWn0o8YKPGDXyU/ypz2lh5woI9g
	 2AcGR1DNd/9OsB3dq9odEEq0hXHIKNNGeKchGdiGewfgrnISpH4o8hXJ6S9LhhzzSqv4j
	 yczMgOyuuDMEv+mKFf6pHSst8U9k/srdVhdUFQh1qhM/yDg54H/XLsZucbf+fyT0qtdfw
	 BR/aGVh5P4EfCWSqEXYfcCAoujrVYHumzmUxybEnFNPHuY7Jex41V2j8L371wN2BZKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276833;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=a1OhDZ7gav16JfUYX7UTFW4ueHi+JFtPWSB8cHLb34Q=;
	b=dELn2JwPozyg0MvTFVFCxre+mUcMHF8wGc8K+KTjQPrRqJ027QaANFO/qSIQm8mahuyN
	 giyKPPEs6TrApaDzlhS46jO2hcW03dUpFQ/ptzbKHKY9r8LnoZewEeJQJzvz+n+qEtF1I
	 Kfbd4t5UIukQb2OZTrBbdwPKb2IgETvJFKlbnI5Wv0iFLKBEwTbFiSrt3AoSFFZqFt+Ty
	 /Nsqfekq9zK2jmiL+Wr++jd78BALdRxir3UDNgx72XxrLv5AHhSWT2+/Up/V9Gx/j2iMC
	 iAIlKmtjVdwICsz6tQue2pAJSvfK4tARXyGrg/R3njt4OawIgB0pYVauWjtfZixhphg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BTUWn4xe;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E4606A330
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B68E4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BTUWn4xe
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso1542595f8f.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276831; x=1793881631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1OhDZ7gav16JfUYX7UTFW4ueHi+JFtPWSB8cHLb34Q=;
        b=BTUWn4xeoJKf5DnsI2WKJuiXyldmkKNC5O6v3JzkFZeqGoYWH6kRcJc5eZFJskIfiT
         GWkc0D1c6a0wGE6qmbiyQL4mOVStHrAhUmVjGmYZRlnwzH+lmgwG8Zy3kux5CGu8fl1e
         GWrrhFKEqJBdbRkNlhDtPviWKwT9oDnuBHgOaXhy4Zz8hanyjEAFFp9YZnvnLguUCcgt
         bZ3cSbENPaKWio2OkTwH7fyMss0UfATIVolU9wI2dibi7k3rhFJbvYocJxt8jsca30Dk
         1Msze81vvIu5iPslGp/33YItXWoMLRb9T9Jta6oG7MdyUYjy30QJllMXndBeW4dw5Stf
         Gg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276831; x=1793881631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a1OhDZ7gav16JfUYX7UTFW4ueHi+JFtPWSB8cHLb34Q=;
        b=L1bsMhs3xq0wia6/wEtrUW1VOPZPiCPRNRPcFoQJwtJOilulwPpdqB8VpIwAYYN1V0
         qSwjEiTR/EHYmU063XK7US3lu+fj5t5HGlDoQnGAQV/mS0jyhxSTz6QNNhmHPdxtMk96
         0FRJc5a41StjoT7LRrr53ucOex2F3qmCvpsGtJjyF5IDr55D9ESAiM4/06OOxd5DsmeD
         3n26cUPi4hJrwXdNaMwHiyqTXI9fD4vJUp3dUxMuRjODz8jqp41Wemv7APKs9snsrRzA
         iFjCcsdwrb1J/w4fJH7/YVJOJSWdveZHfdAN08J5uyJdVw6KOfDH4Fvd/FHfN4W+d0cj
         V6rQ==
X-Gm-Message-State: AFq9FYKZNiDv4nSGhEhdg/wtFTw8ucxLOBQvf3SjDjIw5Vw61Au4C4yr
	becFWIcUPKdvHvVeu7uVPGDpHWYiWIsQPEnNd2reEFJ3ouGsMH0+FBwu2YGpGqL3
X-Gm-Gg: AYBFou1145tkeqL06liWzQX2wqJbYvXRv9r55DJj3kBmzYzfyLGh1d9C6sg4lGAM4P6
	EdhaSFdmzmqESGVLNzcvirMZPsikRuHU3njaCtGBGhhUYtdXrBKOKqvbX4+FgIDUvpBPJcqvREE
	z95xqQmKC7ZjvUHXSiqqT1nDohp3xxC9FySzAWIcWDDS2tA65zHQCjtLBF3oeG75MMtUZpr7fjl
	PkizagmYYH1y33BJ1F21G707FQpgCr+Q/yyh1FRWXlMC+uRmGM7wmUsmag7udcshulZYmS7AQGf
	v4oSJIKHCWAx3F6PUF4WMC2zyAS4h8oz/KT9PBP+Mv5cc9FNbV7mAm9a3eAzXqNbAsN0UZqH0NE
	RBDdahpmUINNiC2ACM3W3cOaZs5AGnwd1P+jMAEECVyw4IVfWeXWLv1ZIroOe4xkUQKWzml17uw
	uU/TJD7RShfTJQJbfRLuzXhReUTnq5qi1u4vnz2i9i7Mq0NKecoe2m3yIP1fbLkEV1mopGt4KnR
	eyUvY44ZkaOSEgKJEKV1GpcR98ng7lnz6JWPIDDQREtGhHu7jbaUznbH6WIdy7sJW4csqfvkyZd
	/V1qTwH5WUfFfAk6SWuL8TP1Ms85twc+WQchbg9x3/ernzLpRU/bc4Y6LZIB
X-Received: by 2002:a05:6000:2308:b0:48e:5e20:1371 with SMTP id ffacd0b85a97d-48e5e20139dmr11862924f8f.4.1793276831015;
        Thu, 29 Oct 2026 05:27:11 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:10 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Pravin Shelar <pravin.shelar@sun.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 04/11] ext4: add dirdata format definitions and access helpers
Date: Thu, 29 Oct 2026 12:24:03 +0000
Message-ID: <20261029122413.230409-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
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
index 41152914aa6c..c79295415c07 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2589,6 +2589,49 @@ struct ext4_dir_entry_tail {
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
 
@@ -4117,6 +4160,80 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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
 extern const struct iomap_ops ext4_iomap_buffered_write_ops;
-- 
2.52.0

