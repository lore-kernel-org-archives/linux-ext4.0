Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAAF3BED4F
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033626; cv=none; b=ALwobN1SSgBI0S8sWzjeLFB699dz0ME82Ax7+qyyGdzD+CKWo5Z2SWKznCwPOgSuBFLeutglQ+4uJfh1CFfQow0lHuNcspjBBi3dqqRFb+DcD5IQSd+VAEtMFpOmcFChDHV8av7liOk22iuCqq1bfwpbgGDOKF87GQP7XBd4pQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033626; c=relaxed/simple;
	bh=V5BgrC3MxjCQpU3LjWLqGikV+wzpqFsJGac+hlYWxTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4La08liojDVTCZbDlgEyqvsU1R4ld3yDZxkr5DUM9OeNeOLJf6oz8eRnoqRjof8nARLOj6q6zba6oiq282BkEP6+h1wLrYbxpeiM5O8LQjmyOYcrl+hGER7n0xVHBy/gfPPLvLfQ+lRZR5UvReg3IwRm/HP9cBJZECqXhx/5bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5QTnMX2; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5QTnMX2"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so6512145e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033622; x=1784638422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m+asDn64RfQFwU0XMuQH2Yn1vCWe2M70Yw35vYkMX+Y=;
        b=S5QTnMX2wAPStHh49ES5aPjq0zgl1EaOZBqGvmFUcBQm+KKGdJyMk5vKnd9y2vkqyi
         KGmye3YS8gWeBYuj+idb9zhXdjHWqW+iJ0LF+vWierCmcV9gpZOySnnF2J1b9UhKQ9gA
         Cm+rXkFW/OgncusCTWV10D8Jo6cCEh68DETwdxTrtEuumjc4CxZtjMkWz/9OZXc759hC
         RV58NX7TmSD9AbSjaJFHCX8YCoQa4ARwHlnKP97mCw9erKwwwE6xkG81UMSAuPc0MhOq
         ujzPhOg7+jwamhLYrFLKOzgRablngZjQITDbRhbOgVi0oQum1Njbg5p8qvufMBDWDprJ
         SJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033622; x=1784638422;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m+asDn64RfQFwU0XMuQH2Yn1vCWe2M70Yw35vYkMX+Y=;
        b=p71UqtGPeNKMoSuh7tecBpWkMAihHphifkblpJr17PDeqbif1VrV5kdFFT774jbCSF
         6twjFvmQpycg3WzBCuumYnB6X2MmZEUbar8cLy+m2EI2lA6+HhuR8L0vPm0kTxJWX3y/
         Jx7WLagQBz7xLbM25HPM2839BWnilccvFvSPKtikhFCSi0fiYIvQJXC1/KlnB7aS9OX8
         gtOcxu7q2vwUpAdNrDbSuEoRvqgxInUzIHOsKUGTzWn0UnQPn7lomaF6Hy/S16E0iVp9
         Gze7o+lx/FHmQI3qD0Xg8czSFo6QqBvvd6nEePgt2yeEeXOsNsHSgQeI84osrDeHkD/2
         SMfQ==
X-Gm-Message-State: AOJu0Yz9z9PfcZlInlZXpFTIfOhXBvrVGG5Dxhnhiqm7tvgDJ5qIew/4
	YqbqyGGeqiONJdX15jjH3Es/PK7vbSvGzufYE8fpb7DCuGISFCVPDypLSpaCsjjYlPY=
X-Gm-Gg: AfdE7cnAQnKs9Lc44M5Ty0WnstRt/B1zVHfZm7cnern4AbAmEiXO1QNibUB6bQfXsnV
	A2oGOrlDeMHDrHkjUVKjO2v1E5zKIFdCKvBnfXfx23VaNfPM56cVtvtNkRqj/8hjZMhQz4t6vXY
	u+AVOt4DVwSVl8zY/cK8v3/yhp1dFG9uWJjCH52GOzsdry/U3rk9LqD7XkNnRurtJXTogycS65I
	A/7c9awRxbI2iA4Z1mRHWUtG4eRd01KmyItN0ern5bPcoCGqSWCLZgttnWoQNAoar4DCTmWMWiS
	jg482FGLQrua1rQ13H+CxWYOCbBzWqavilBVKG93FtgLmJVDT8HAHbjTn0/gVWl1W70wGmip9D/
	5TjWzjLuwBf5QhFvoC0nSp8AkcX2/+VUbJL0kAk+pjC45Sh6zUxDnR33vWi4kINYCaCBtMA8Iz7
	bVPy7tIx44EYG88mCvqP1FmJZj0aWPqGaQy7txtXO4UFhxmw==
X-Received: by 2002:a05:600c:1d0a:b0:493:c991:8e56 with SMTP id 5b1f17b1804b1-493f887bc07mr136332855e9.4.1784033622191;
        Tue, 14 Jul 2026 05:53:42 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:41 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v5 05/11] ext4: add dirdata format definitions and access helpers
Date: Tue, 14 Jul 2026 08:51:03 -0400
Message-ID: <20260714125111.14699-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h | 105 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8d8d92391bf..b42c918b9cb4 100644
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
@@ -4018,6 +4067,62 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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
+			}
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

