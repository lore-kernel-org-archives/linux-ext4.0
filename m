Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1E82C21DD
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459338; cv=none; b=hw3oEnmWL65hrP5q5+j3OMLj4rPMW5fY/OA1DbxT8VN1jdiuDIhjC0BiYTFxG0msbsqzK4RAEtSNPRVcbD7+QKn/2nTFGACYWuINJhDc+yRKEMUCNRdiLrB77/jUiwX00dEy5GVPVyIZiT0Z2cy+77M3asowccEp2VT0kbQvqH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459338; c=relaxed/simple;
	bh=RnnlrVaEpqwdQ/wQ+ZdL8vttIWSGeW9O6UR5+bi5adg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8UDa9e44oerk/8J9184duvwbiyUDlhPGgW5HLvFBGnz+4rGTIA2pqSKmERxhMKmnX5TaGHTFhRa5HVT+XwOiu9YsQZpdhYEZlequO/Sl3CU9lI8s7GMzCrFX0859/+YMtKjHcrOEJjbjQFKNLzgidTd2eXbUa+5wubmkj8LS4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wlv0mz64; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wlv0mz64"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f752b3423so226092f8f.3
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459335; x=1786064135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0l/pRmNV4Ll2NqQ/WmoamneRpENJZgYHmDD8yN8NHyk=;
        b=Wlv0mz64vuvN2kZUu1OWpb1Hys5Z6p3nLoc5ksWDjtQ3Bo0mRaRxlByquwN6pgXI07
         IRoMJz0zHd9CrUzdz0dJFMzPu9iy7Vo61REyGJ/AJ+5Pxco8kgpfmmUQED8ydYYwYKvh
         x3VXWbhyxB0V1Q8XY0CJI40clVSRzYUEmbEmaOQ+feaKOhYYB+PzDhRaviclIu+k+VAd
         uCobrc5rTwjGdO3bujwBnfnDVXawHhL+i8C3OBGFTKGX3q7HH2odkteQv6AIphluCwkI
         4SZGWOLu0J+H2EoF3gumZYwOF2XpYbIunwyrKlKw6qLNk0E9S8o2vrdsQDu51EkHhDFi
         LXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459335; x=1786064135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0l/pRmNV4Ll2NqQ/WmoamneRpENJZgYHmDD8yN8NHyk=;
        b=rdcFelB00JH+Sl6M0ybLGC838XpQ0vcemm+NPto26zcoR2ONgQt3mv+fmdJySxGFSY
         erzrl7N1ytE/+5Fy+8kvRCCM8MMRyNxEccVUpQ+GgKsmkqjBTLwgmJqlkeHDgdMrRlHW
         IB3yeZVfZCPCJ+2Hu8ny4fT7cKTbrBtHmW2r/RYnNLnxGP+e0oOlnQepqCPYa5UrWvBc
         chlbKoNA7nmX67dIlaUvCX9m58rdIznehzsQNUKNd6hv9Y6jeI73+GKiMx0oxZgCvHzF
         eBqYoH4yekNrP7fX1gYGmQ7zDtci/03e5A6SRk/0PGUs4fr3ZBvMhUeC5uRGbyh9L3L5
         nWMA==
X-Gm-Message-State: AOJu0YzwHLbv8JG2/J8IJw9gsOJyzL+SKMCTSN9xPhV9myVjKPz0WtNp
	yVOVSwhBoamshzjX5nqDkQabN0CBRzoJ6LmzGF8F9lIociVYZmXtH8X74IDqILtj
X-Gm-Gg: AR+sD11vFiymTds1yyeaEfV2SzWnYPzjpW/7B4Kxdwg9DXFzf3CGIOPAOAGy367xLNn
	jUAo/5fT/3+DyTZpt5dY1J5Z7JqcX3oHHJjDZmFGfLEXv+Rj14vuh8L3dE+IifIuFtxfhJmsbRf
	qEKG3quJo9ZXtWP+2JIaN6F8tVU5ulmVHBOe8kQhjXYp6ih1XxYvkhXdTHWTdNhRKegaY2eKo6i
	Fwtll/FqceSYx4xEGHope22nOXqqACASm2mFeIJhFh2WuOk8p5XyhRzmnEJuRpxTMoaV41kfoHH
	nz5iaiiDZx4jYCPJK5lUMefxwf0NnR7cWIVMh5Y2NB2J5UkWb1Z98KLP6WtFXc2GWLavX3hARXu
	sMoTggygdnHao26obvWu/s172x7CTkkP0Oiq5t9axCElRtt0T5SRBoX4/us7f6yRENPzjtQ1IQs
	VJ5AyqpM3ytD+lca3oLon3lM0ieTX4KJjpDrshTEiFRMiiNRVH6QzOiop1+waqkbZTSRdl+F2W4
	ZAH2Z4S/Ik0gi1HdNTyCCSQuhiY8kY=
X-Received: by 2002:a05:6000:41e5:b0:47f:95ce:6f48 with SMTP id ffacd0b85a97d-47fd2abbbe3mr352412f8f.11.1785459334625;
        Thu, 30 Jul 2026 17:55:34 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:34 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v9 05/11] ext4: add dirdata format definitions and access helpers
Date: Thu, 30 Jul 2026 20:54:22 -0400
Message-ID: <20260731005430.36801-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
References: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h | 103 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8d8d92391bf..0c5da7d39b48 100644
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
 
@@ -4018,6 +4061,66 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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

