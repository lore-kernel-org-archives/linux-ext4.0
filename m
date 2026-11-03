Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713826;
	b=DgKDnLdYW0cDaDsFQY2MGJo9uPOscr3W3u840vLowomtAoQg/WJK291R0aZKHHtmhVXF
	 GcDjZEy9cnRHmMx44w0JwQ2qfABHLj3MYKk4t6EqkSyw4iriie7HnKbJOidCzUpHBV+RY
	 ANcxu9ys0EGZrsmVFD4085NNrL3VjiQ2l4NGPBCQOXGxx4qQY8FObtfxsh3e2OAlWKyTR
	 CfhifMk4Z2EwGOYipSvIXxuo8p9A9crINo89XvHGkN9ihBxqZOwWghE0guPzcnI9Ko/Fi
	 AZE0yNhuM68lWNT5FAIZl5yvy+crey4SrqG9q36Q/6uUA9yko2x57m7jpgmXeC2J9Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713826;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NAx/FzSIhHSljSXo4wBbkhL+48GLXaN8CLeHANN5hNc=;
	b=W+r9eVpNoi+s9m8kXwT1jRoe1tH37R0yfRe1pbM4kV0Emm6CBAwwuETFiT1evEmeZG2y
	 yWoDUdVynt8k7JgjAMI9bzoDd9QoyYldFdhTVFRBTGSJlfLxhD3BY1F/cYzXPW3siRV3o
	 Gc08agiMzSkCFayz3VvoxCCQLb2uYVktQLiHvYm4x+1VfUAHVaobqRXYz9HffblWmQpXb
	 yfY9NkYJibtc/KwZrCQpbO/+xF12iJ3sxyEJ0PScDm5ltzm/bkCmOE8kV0sj1It5yrKTc
	 qUqeeeYO+lmEcuB9inJ08o48xk16t0g6eiVijBcURd85jemVKQFIrMnjMTI93xSKCZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uZnP962N;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F19606A33C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45F19606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uZnP962N
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a208d93758so44803325e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713825; x=1794318625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NAx/FzSIhHSljSXo4wBbkhL+48GLXaN8CLeHANN5hNc=;
        b=uZnP962NafdLzhe+yOxVIgVsjhrbCDSiTfg2NcOmveqCdlw6A0Y32rrXXZOXSarSHJ
         Rfh7JYpYbErDapLU4YAxwIwkVMB62MpvbF6vgUKPPodEYj/+SBk/RLVgvY1tGBF5xhME
         ofe9HkqlWhEnrYS/mp6hCqvXq4t0mJepy66z75WA5JSkAWXLehGizRcGFscrEfTAKD9G
         rb9HxO4pb6PEURyr/40rcqd5JNI/O53yl9sDWXgVpj97fj5qCAxtIg53NCicgUiEPQVR
         p0qL9DNnMVWC5xbPMHgx2MPlZ4trNWuB2rl4kqEkeyryuB1B3uhfUaurMhaHufwOPWzu
         YvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713825; x=1794318625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NAx/FzSIhHSljSXo4wBbkhL+48GLXaN8CLeHANN5hNc=;
        b=GBpmfPMLKBvsAo0wQpxI6f/qq+c8oa+BIzmOOGzXjMe4BK2G3eWAcMReuTh9w8pssY
         Tva/xqYz5v5zydUTfrlwdtlc1UU6jRioyReOAvs1DH9xlwtEptTsH2HjJYVfpOIEG27B
         dE5/pSQ9+my3vFEQKbjHHd4jcbyGk3pPPrRtHt+8kS7EsgJXYgLlr+Wx1rhTVQn5bM6E
         eanDPrbdK3u08W7jDPOzW6UMy6qZo6vyJIw5XhmRVT3CysuwaU6jgQ4Ea1tR0kmyEHnQ
         oGdmlszNJ6rXgJmaubJ5jEXg+o/doLZf4MXZ0hULG2HGXH0BPiLal4pZ6NXYidNfvI3O
         /U9A==
X-Gm-Message-State: APuU4Z/oUB5Ui79EyQYOzM3V+65/Au9xftfUHwFJRaiFe2nB5ACSuN7Y
	c2qP4zXcqRpItAwp5RkilPU1HJSfn+cEtToEeemBabCndKoqbg1UXGRqMQYqqyAZJYk=
X-Gm-Gg: AYBFou1muJBJBgUwVu4UrUbJxRMXJCtQI/QVznGtqfBoTPWpdp4xiFgBz1ioDvUf466
	u+LL4cjsEXunJBcw0sopHI8SO8+3LvI069h67mb29UQ3qCHPPkPrMVTScCwn/lxidI1FImIwaDC
	N0fe3XkhPskevU4hV3xe5CcU34y7/JACPCn2xRe6zEOYMK/qa7PL/ork4Fl227GUfbnN1H3K6Al
	/FFGMVW1TJCR2qWbXSSYAxdr1N76A3iw5W8xGTnDO4chDHT4sz0w831BzLmKpd+lnsCbFc5ArIk
	cX1pt19SRMWTJbmdzH0LJewyV7Uy1vLtFUT/SL8k4uE9jjv6QV2d+08yr7uoNDyoZQTFo5tmMLR
	9944s6Dhf66EvZ1ZunT6E34zoj2PLf8/jvGBsDSd19IA0Qfok1Zit/oaKGBYUVavfaeVuQecXPt
	V4DAtV8lB2RLPK7d5w8nIVYMyrvslK7Ty6dgHMeTMVy9Vi5GG+7zKNbMzmdysJtdCd0elzjHj8L
	uE1tWdl/9OP3HIiFdxkOXiUvkhtsGL/qEBPyC1FsPRoVQZhMdhii4Us92pk8yQceSmi9Y6yTKON
	DDKcpcEVVTSyrSKKKJSFPFlbF3rpTSMXW8rOlH+7BVO+BF5WRJWQ4xAq4ABc
X-Received: by 2002:a05:600c:3f06:b0:4a1:e672:5721 with SMTP id 5b1f17b1804b1-4ac181e75c2mr320018685e9.13.1793713824720;
        Tue, 03 Nov 2026 05:50:24 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:24 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Pravin Shelar <pravin.shelar@sun.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 05/12] ext4: add dirdata format definitions and access helpers
Date: Tue,  3 Nov 2026 13:49:12 +0000
Message-ID: <20261103134921.610047-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
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
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/ext4.h | 123 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 41152914aa6c..d224132fc80b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2589,6 +2589,55 @@ struct ext4_dir_entry_tail {
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
+/*
+ * The hash words are declared as scalars rather than as a nested
+ * struct ext4_dir_entry_hash: a 4-byte aligned struct inside a packed
+ * struct makes clang warn about unaligned access (-Wunaligned-access).
+ */
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header	dh_header;
+	__le32				dh_hash;
+	__le32				dh_minor_hash;
+} __packed;
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
@@ -4117,6 +4166,80 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
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

